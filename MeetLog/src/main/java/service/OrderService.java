package service;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import dto.*;
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
			s.insert("mapper.OrderMapper.insertOrder", po);
			int i = 1;
			for (PurchaseOrderLine l : lines) {
				l.setCompanyId(companyId);
				l.setOrderId(po.getId());
				l.setLineNo(i++);
				s.insert("mapper.OrderMapper.insertOrderLine", l);
			}
			
			return po.getId();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public List<PurchaseOrder> listOrdersForCompany(long companyId, String status, int limit, int offset) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("status", status);
			p.put("limit", limit);
			p.put("offset", offset);
			return s.selectList("mapper.OrderMapper.listOrdersForCompany", p);
		}
	}

	public List<PurchaseOrderLine> listOrderLines(long companyId, long orderId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("orderId", orderId);
			return s.selectList("mapper.OrderMapper.listOrderLines", p);
		}
	}

	public void updateStatus(long companyId, long orderId, String status) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("orderId", orderId);
			p.put("status", status);
			s.update("mapper.OrderMapper.updateOrderStatus", p);
		}
	}

	// 입고 처리: 재고 증가 + 상태 RECEIVED
	public void markReceivedAndIncreaseInventory(long companyId, long orderId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("companyId", companyId);
			params.put("orderId", orderId);
			PurchaseOrder po = s.selectOne("mapper.OrderMapper.getOrderWithLines", params);
			if (po == null)
				throw new RuntimeException("Order not found");
			Long branchId = po.getBranchId();
			List<PurchaseOrderLine> lines = s.selectList("mapper.OrderMapper.listOrderLines", params);
			for (PurchaseOrderLine l : lines) {
				Map<String, Object> q = new HashMap<>();
				q.put("companyId", companyId);
				q.put("branchId", branchId);
				q.put("materialId", l.getMaterialId());
				q.put("qty", l.getQty());
				s.insert("mapper.OrderMapper.increaseInventory", q);
			}
			Map<String, Object> p2 = new HashMap<>();
			p2.put("companyId", companyId);
			p2.put("orderId", orderId);
			p2.put("status", "RECEIVED");
			s.update("mapper.OrderMapper.updateOrderStatus", p2);
			
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
			return s.selectList("mapper.OrderMapper.listOrdersForBranch", p);
		}
	}

	public int getTotalOrderCountForBranch(long companyId, long branchId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("branchId", branchId);
			Integer count = s.selectOne("mapper.OrderMapper.getTotalOrderCountForBranch", p);
			return count != null ? count : 0;
		}
	}
}
