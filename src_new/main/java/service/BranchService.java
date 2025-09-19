package service;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import dto.*;
import java.util.*;

public class BranchService {

    // [수정] listInventory -> listInventoryForBranch로 이름을 변경하고,
    // 올바른 Mapper ID "listInventoryView"를 사용하도록 수정했습니다.
    public List<InventoryItem> listInventoryForBranch(long companyId, long branchId, int limit, int offset) {
        try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> p = new HashMap<>();
            p.put("companyId", companyId);
            p.put("branchId", branchId);
            p.put("limit", limit);
            p.put("offset", offset);
            // [핵심] 존재하는 쿼리 ID인 "listInventoryView"를 호출합니다.
            return s.selectList("mapper.BranchMapper.listInventoryView", p);
        }
    }

    // [수정] 중복되었던 listInventoryForBranch 메소드는 삭제했습니다.

    public int getTotalMaterialCount(long companyId) {
        try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> p = new HashMap<>();
            p.put("companyId", companyId);
            return s.selectOne("mapper.BranchMapper.countAllMaterialsForCompany", p);
        }
    }
    
    // ===== 아래는 메뉴 관련 기존 메소드들 (수정 없음) =====

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

    public List<Map<String, Object>> listMenuIngredientsByMenu(long companyId, long menuId) {
        try (SqlSession ss = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> p = new HashMap<>();
            p.put("companyId", companyId);
            p.put("menuId", menuId);
            return ss.selectList("mapper.BranchMapper.listMenuIngredientsByMenu", p);
        }
    }
}