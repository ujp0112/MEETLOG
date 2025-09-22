package service;

import java.util.List;
import dao.UserCollectionDAO;
import model.UserCollection;

public class UserCollectionService {
    private UserCollectionDAO userCollectionDAO = new UserCollectionDAO();

    public List<UserCollection> getCollectionsByUserId(int userId) {
        return userCollectionDAO.findByUserId(userId);
    }

    public boolean createCollection(UserCollection collection) {
        return userCollectionDAO.insert(collection) > 0;
    }
}
