package service;

import java.util.List;
import model.Menu;
import dao.MenuDAO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

public class MenuService {
    private MenuDAO menuDAO = new MenuDAO();
    
    /**
     * 메뉴 추가 (트랜잭션 포함)
     */
    public boolean addMenu(Menu menu, SqlSession sqlSession) {
        try {
            return menuDAO.insert(menu, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 메뉴 추가 (자동 트랜잭션)
     */
    public boolean addMenu(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = menuDAO.insert(menu, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 메뉴 수정 (트랜잭션 포함)
     */
    public boolean updateMenu(Menu menu, SqlSession sqlSession) {
        try {
            return menuDAO.update(menu, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 메뉴 수정 (자동 트랜잭션)
     */
    public boolean updateMenu(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = menuDAO.update(menu, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 메뉴 삭제 (트랜잭션 포함)
     */
    public boolean deleteMenu(int menuId, SqlSession sqlSession) {
        try {
            return menuDAO.delete(menuId, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 메뉴 삭제 (자동 트랜잭션)
     */
    public boolean deleteMenu(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = menuDAO.delete(menuId, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 음식점별 메뉴 목록 조회
     */
    public List<Menu> getMenusByRestaurantId(int restaurantId) {
        return menuDAO.findByRestaurantId(restaurantId);
    }
    
    /**
     * 메뉴 상세 조회
     */
    public Menu getMenuById(int menuId) {
        return menuDAO.findById(menuId);
    }
    
    /**
     * 인기 메뉴 목록 조회
     */
    public List<Menu> getPopularMenus() {
        return menuDAO.findPopularMenus();
    }
}