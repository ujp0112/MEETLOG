package service;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import dto.*;
import java.util.*;

public class BranchService {
	public List<InventoryItem> listInventory(long companyId, long branchId, int limit, int offset) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("branchId", branchId);
			p.put("limit", limit);
			p.put("offset", offset);
			return s.selectList("mapper.BranchMapper.listInventoryView", p);
		}
	}

	public List<MenuIngredient> getMenuIngredients(long companyId, long menuId) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("menuId", menuId);
			return s.selectList("mapper.BranchMapper.getMenuIngredientsForBranch", p);
		}
	}

	public void setMenuToggle(long companyId, long branchId, long menuId, boolean enabled) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			MenuToggle t = new MenuToggle();
			t.setCompanyId(companyId);
			t.setBranchId(branchId);
			t.setMenuId(menuId);
			t.setEnabled(enabled ? "Y" : "N");
			s.insert("mapper.BranchMapper.upsertBranchMenuToggle", t);
		}
	}
	public List<Map<String, Object>> listMenusForBranch(long companyId, long branchId, String q) {
		try (SqlSession ss = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("companyId", companyId);
			p.put("branchId", branchId);
			p.put("q", (q == null || q.isEmpty()) ? null : q);
			return ss.selectList("mapper.BranchMapper.listMenusForBranch", p);
		}
	}

	public void upsertBranchMenuToggle(MenuToggle t) {
		try (SqlSession ss = MyBatisSqlSessionFactory.getSqlSession()) {
			ss.insert("mapper.BranchMapper.upsertBranchMenuToggle", t);
		}
	}
	 public List<Map<String,Object>> listMenuIngredientsByMenu(long companyId, long menuId){
		    try (SqlSession ss = MyBatisSqlSessionFactory.getSqlSession()) {
		      Map<String,Object> p = new HashMap<>();
		      p.put("companyId", companyId);
		      p.put("menuId", menuId);
		      return ss.selectList("mapper.BranchMapper.listMenuIngredientsByMenu", p);
		    }
		  }
}
