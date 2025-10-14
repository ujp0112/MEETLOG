package erpService;

import org.apache.ibatis.session.SqlSession;

import dao.MenuDAO;
import erpDto.*;
import util.MyBatisSqlSessionFactory;

import java.util.*;

public class BranchMenuService {

	public List<BranchMenu> listMenus(long companyId, int limit, int offset) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("limit", limit);
			p.put("offset", offset);
			return s.selectList("erpMapper.BranchMenuMapper.listMenus", p);
		}
	}
	public int getMenuCount(long companyId) {
		MenuDAO menuDao = new MenuDAO();
	    return menuDao.getMenuCount(companyId);
	}


	public long createMenu(BranchMenu m, List<MenuIngredient> ings) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			s.insert("erpMapper.BranchMenuMapper.insertMenu", m); // useGeneratedKeys=true → id 채워짐
			if (ings != null && !ings.isEmpty()) {
				for (MenuIngredient mi : ings) {
					mi.setCompanyId(m.getCompanyId());
					mi.setMenuId(m.getId());
					s.insert("erpMapper.BranchMenuMapper.insertMenuIngredient", mi);
				}
			}

			return m.getId();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public BranchMenu getMenuDetails(long companyId, long menuId) {
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("companyId", companyId);
			params.put("menuId", menuId);
			return session.selectOne("erpMapper.BranchMenuMapper.selectMenuById", params);
		}
	}

	public void updateRecipe(long companyId, long menuId, String recipe) {
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("companyId", companyId);
			params.put("menuId", menuId);
			params.put("recipe", recipe);
			session.update("erpMapper.BranchMenuMapper.updateMenuRecipe", params);
		}
	}

	public void updateMenu(BranchMenu m, List<MenuIngredient> ings) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {

			// 이미지 보존: 새 경로가 null이면 기존 값 유지
			if (m.getImgPath() == null) {
				Map<String, Object> p = new HashMap<>();
				p.put("companyId", m.getCompanyId());
				p.put("id", m.getId());
				BranchMenu prev = s.selectOne("erpMapper.BranchMenuMapper.selectMenu", p);
				if (prev != null)
					m.setImgPath(prev.getImgPath());
			}

			s.update("erpMapper.BranchMenuMapper.updateMenu", m);

			// 재료 라인 교체
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", m.getCompanyId());
			p.put("menuId", m.getId());
			s.delete("erpMapper.BranchMenuMapper.deleteMenuIngredients", p);
			if (ings != null && !ings.isEmpty()) {
				for (MenuIngredient mi : ings) {
					mi.setCompanyId(m.getCompanyId());
					mi.setMenuId(m.getId());
					s.insert("erpMapper.BranchMenuMapper.insertMenuIngredient", mi);
				}
			}

		}
	}

	public void softDeleteMenu(long companyId, long menuId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("id", menuId);
			s.update("erpMapper.BranchMenuMapper.softDeleteMenu", p);

		}
	}

	public List<MenuIngredient> listIngredients(long companyId, long menuId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("menuId", menuId);
			return s.selectList("erpMapper.BranchMenuMapper.listIngredientsOfMenu", p);
		}
	}

	public void replaceMenuIngredients(long companyId, long menuId, List<MenuIngredient> items) {
		// 트랜잭션 커밋(프레임워크 설정에 따라 자동/수동)
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("menuId", menuId);
			s.delete("erpMapper.BranchMenuMapper.deleteMenuIngredients", p);
			for (MenuIngredient mi : items) {
				// companyId/menuId/materialId/qty 가 채워진 DTO
				s.insert("erpMapper.BranchMenuMapper.insertMenuIngredient", mi);
			}

		}

	}

}
