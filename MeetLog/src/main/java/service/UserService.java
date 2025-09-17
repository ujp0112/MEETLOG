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

    // [추가] MypageServlet의 '프로필 수정'을 위한 메서드
    public boolean updateProfile(int userId, String nickname, String profileImage) {
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        user.setNickname(nickname);
        user.setProfileImage(profileImage);
        // userDAO.update()는 UserMapper.xml의 <update id="update">를 호출
        return userDAO.update(user) > 0; 
    }
    
    // [추가] MypageServlet의 '비밀번호 변경'을 위한 메서드
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        
        // 현재 비밀번호 확인
        if (!PasswordUtil.verifyPassword(currentPassword, user.getPassword())) {
            return false; // 현재 비밀번호 불일치
        }
        
        // 새 비밀번호 해시
        String newHashedPassword = PasswordUtil.hashPassword(newPassword);
        
        // userDAO.updatePassword()는 UserMapper.xml의 <update id="updatePassword">를 호출
        return userDAO.updatePassword(userId, newHashedPassword) > 0;
    }

    // --- 이하 기존 메서드들 ---

    public boolean registerUser(User user) {
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
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
        return userDAO.update(user) > 0;
    }

    public boolean deleteUser(int userId) {
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