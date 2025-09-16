package service;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    public User authenticateUser(String email, String password, String userType) {
        User user = userDAO.findByEmail(email);
        if (user != null && user.getUserType().equals(userType) && 
            PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public boolean registerUser(User user) {
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        // (핵심 수정!) int 결과를 boolean으로 변환
        return userDAO.insert(user) > 0;
    }

    public boolean isEmailExists(String email) {
        return userDAO.findByEmail(email) != null;
    }
    
    public boolean isNicknameExists(String nickname) {
        return userDAO.findByNickname(nickname) != null;
    }

    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }

    public boolean updateUser(User user) {
        // (핵심 수정!) int 결과를 boolean으로 변환
        return userDAO.update(user) > 0;
    }

    public boolean deleteUser(int userId) {
        // (핵심 수정!) int 결과를 boolean으로 변환
        return userDAO.delete(userId) > 0;
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public String findEmailByNickname(String nickname) {
        User user = userDAO.findByNickname(nickname);
        return (user != null) ? user.getEmail() : null;
    }

    public boolean resetPassword(String email) {
        User user = userDAO.findByEmail(email);
        if (user != null) {
            String tempPassword = PasswordUtil.generateTempPassword();
            String hashedPassword = PasswordUtil.hashPassword(tempPassword);
            
            // (핵심 수정!) int 결과를 boolean으로 변환
            boolean updated = userDAO.updatePassword(user.getId(), hashedPassword) > 0;
            
            if (updated) {
                // TODO: 이메일 발송 로직 구현
                System.out.println("임시 비밀번호 발급 [" + email + ": " + tempPassword + "]");
                return true;
            }
        }
        return false;
    }
}