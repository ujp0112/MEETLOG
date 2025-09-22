package service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import dao.MenuDAO;
import model.Menu;
import util.MyBatisSqlSessionFactory;

public class MenuService {
    private MenuDAO menuDAO = new MenuDAO();

    public List<Menu> findByRestaurantId(int restaurantId) {
        return menuDAO.findByRestaurantId(restaurantId);
    }

    public List<Menu> getMenusByRestaurantId(int restaurantId) {
        return menuDAO.findByRestaurantId(restaurantId);
    }

    public Menu findById(int menuId) {
        return menuDAO.findById(menuId);
    }

    public boolean addMenu(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = menuDAO.insert(sqlSession, menu);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean updateMenu(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = menuDAO.update(sqlSession, menu);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean deleteMenu(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = menuDAO.delete(sqlSession, menuId);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }
}