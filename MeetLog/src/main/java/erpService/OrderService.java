package erpService;

import org.apache.ibatis.session.SqlSession;

import erpDto.*;
import util.MyBatisSqlSessionFactory;

import java.util.*;

public class OrderService {
	public long createOrder(long companyId, long branchId, List<PurchaseOrderLine> lines) {
		long total = 0;
		for (PurchaseOrderLine l : lines)
			total += Math.round(l.getUnitPrice() * l.getQty()); // KRW 반올림
		PurchaseOrder po = new PurchaseOrder();
		po.setCompanyId(companyId);
		po.setBranchId(branchId);
		po.setStatus("REQUESTED");
		po.setTotalPrice(total);
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			s.insert("erpMapper.OrderMapper.insertOrder", po);
			int i = 1;
			for (PurchaseOrderLine l : lines) {
				l.setCompanyId(companyId);
				l.setOrderId(po.getId());
				l.setLineNo(i++);
				s.insert("erpMapper.OrderMapper.insertOrderLine", l);
			}

			return po.getId();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	public List<PurchaseOrder> listOrdersForBranch(long companyId, long branchId, int limit, int offset) {
	    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
	        Map<String, Object> p = new HashMap<>();
	        p.put("companyId", companyId);
	        p.put("branchId", branchId);
	        p.put("limit", limit);
	        p.put("offset", offset);
	        return s.selectList("erpMapper.OrderMapper.listOrdersForBranch", p);
	    }
	}

	public int getTotalOrderCountForBranch(long companyId, long branchId) {
	    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
	        Map<String, Object> p = new HashMap<>();
	        p.put("companyId", companyId);
	        p.put("branchId", branchId);
	        return s.selectOne("erpMapper.OrderMapper.getTotalOrderCountForBranch", p);
	    }
	}

	public List<PurchaseOrder> listOrdersForCompany(long companyId, String status, int limit, int offset) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("status", status);
			p.put("limit", limit);
			p.put("offset", offset);
			return s.selectList("erpMapper.OrderMapper.listOrdersForCompany", p);
		}
	}

	public int getTotalOrderCountForCompany(long companyId, String status) {
	    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
	        Map<String, Object> p = new HashMap<>();
	        p.put("companyId", companyId);
	        p.put("status", status);
	        Integer count = s.selectOne("erpMapper.OrderMapper.getTotalOrderCountForCompany", p);
	        return count != null ? count : 0;
	    }
	}

	public List<PurchaseOrderLine> listOrderLines(long companyId, long orderId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("orderId", orderId);
			return s.selectList("erpMapper.OrderMapper.listOrderLines", p);
		}
	}

	public void updateStatus(long companyId, long orderId, String status) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("orderId", orderId);
			p.put("status", status);
			s.update("erpMapper.OrderMapper.updateOrderStatus", p);
		}
	}

	public void updateOrderLineStatuses(long companyId, long orderId, List<PurchaseOrderLine> lines) {
		SqlSession s = MyBatisSqlSessionFactory.getSqlSession();
		try {
			for (PurchaseOrderLine line : lines) {
				Map<String, Object> p = new HashMap<>();
				p.put("companyId", companyId);
				p.put("orderId", orderId);
				p.put("lineNo", line.getLineNo());
				p.put("status", line.getStatus().toUpperCase()); // "REQUESTED", "APPROVED" 등
				s.update("erpMapper.OrderMapper.updateOrderLineStatus", p);
			}
			updateOverallOrderStatus(s, companyId, orderId);

			s.commit(); // 모든 DB 작업이 끝난 후 한번만 커밋
		} catch (Exception e) {
			s.rollback(); // 오류 발생 시 롤백
			throw new RuntimeException("Failed to update order line statuses", e);
		} finally {
			s.close(); // 세션 닫기
		}
	}

	// 입고 처리: 재고 증가 + 상태 RECEIVED
	public void markReceivedAndIncreaseInventory(long companyId, long orderId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("companyId", companyId);
			params.put("orderId", orderId);
			PurchaseOrder po = s.selectOne("erpMapper.OrderMapper.getOrderWithLines", params);
			if (po == null)
				throw new RuntimeException("Order not found");
			Long branchId = po.getBranchId();
			List<PurchaseOrderLine> lines = s.selectList("erpMapper.OrderMapper.listOrderLines", params);
			for (PurchaseOrderLine l : lines) {
				Map<String, Object> q = new HashMap<>();
				q.put("companyId", companyId);
				q.put("branchId", branchId);
				q.put("materialId", l.getMaterialId());
				q.put("qty", l.getQty());
				s.insert("erpMapper.OrderMapper.increaseInventory", q);
			}
			Map<String, Object> p2 = new HashMap<>();
			p2.put("companyId", companyId);
			p2.put("orderId", orderId);
			p2.put("status", "RECEIVED");
			s.update("erpMapper.OrderMapper.updateOrderStatus", p2);

		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	// service/OrderService.java
	private void updateOverallOrderStatus(SqlSession session, long companyId, long orderId) {
		Map<String, Object> params = new HashMap<>();
		params.put("companyId", companyId);
		params.put("orderId", orderId);

		// MyBatis 캐시가 혹시 모를 문제를 일으키는 것을 방지하기 위해 캐시를 비워줍니다.
		session.clearCache();

		// 1. 해당 발주에 속한 모든 품목 라인의 상태를 조회합니다.
		List<String> statuses = session.selectList("erpMapper.OrderMapper.getLineStatusesForOrder", params);

		
		if (statuses == null || statuses.isEmpty()) {
			return;
		}

		// 2. 상태별로 카운트합니다.
		long receivedCount = statuses.stream().filter(s -> "RECEIVED".equals(s)).count();
		long requestedCount = statuses.stream().filter(s -> "REQUESTED".equals(s)).count();
		int totalLines = statuses.size();

		String newOverallStatus;

		// 3. 비즈니스 규칙에 따라 전체 발주 상태를 결정합니다.
		if (receivedCount == totalLines) {
			newOverallStatus = "RECEIVED";
		} else if (requestedCount == 0) {
			newOverallStatus = "APPROVED";
		} else {
			newOverallStatus = "REQUESTED";
		}

		// 4. 결정된 상태로 purchase_order 테이블을 업데이트합니다.
		params.put("status", newOverallStatus);
		session.update("erpMapper.OrderMapper.updateOrderStatus", params);
	}
}
