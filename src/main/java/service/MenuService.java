package service;

import model.Menu;
import dao.MenuDAO;
import java.util.List;

public class MenuService {
    private MenuDAO menuDAO = new MenuDAO();

    public List<Menu> getMenusByRestaurantId(int restaurantId) {
        return menuDAO.findByRestaurantId(restaurantId);
    }

    public List<Menu> findByRestaurantId(int restaurantId) {
        return menuDAO.findByRestaurantId(restaurantId);
    }

    public Menu findById(int menuId) {
        return menuDAO.findById(menuId);
    }

    public boolean addMenu(Menu menu) {
        // (핵심 수정!) int 결과를 boolean으로 변환
        return menuDAO.insert(menu) > 0;
    }

    public boolean updateMenu(Menu menu) {
        return menuDAO.update(menu) > 0;
    }

    public boolean deleteMenu(int menuId) {
        return menuDAO.delete(menuId) > 0;
    }
}