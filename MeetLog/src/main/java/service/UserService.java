package service;

import dao.UserDAO;
import dao.BusinessUserDAO;
import model.User;
import model.BusinessUser;
import util.PasswordUtil;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class UserService {
    private UserDAO userDAO = new UserDAO();
    private BusinessUserDAO businessUserDAO = new BusinessUserDAO();

    /**
     * 사업자 회원가입 (User 정보와 BusinessUser 정보를 하나의 트랜잭션으로 처리)
     */
    public boolean registerBusinessUser(User user, BusinessUser businessUser) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. users 테이블에 사용자 정보 삽입
            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
            user.setUserType("BUSINESS");
            userDAO.insert(user, sqlSession); // SqlSession을 전달하여 트랜잭션에 참여

            // 2. 방금 생성된 user의 id를 businessUser 객체에 설정
            businessUser.setUserId(user.getId());

            // 3. business_users 테이블에 사업자 정보 삽입
            businessUserDAO.insert(businessUser, sqlSession);

            // 4. 모든 작업이 성공하면 최종적으로 commit
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            // 중간에 하나라도 오류가 발생하면 모든 작업을 취소 (rollback)
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            // 작업이 끝나면 항상 SqlSession을 닫아줍니다.
            sqlSession.close();
        }
    }
    
    /**
     * 개인 회원가입
     */
    public boolean registerUser(User user) {
        // 이 메소드는 단독 트랜잭션으로 동작합니다.
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        return userDAO.insert(user) > 0;
    }

    // --- 이하 다른 서비스 메소드들 (기존과 동일) ---

    public User authenticateUser(String email, String password, String userType) {
        User user = userDAO.findByEmail(email);
        if (user != null && user.getUserType().equals(userType) && 
            PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public boolean updateProfile(int userId, String nickname, String profileImage) {
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        user.setNickname(nickname);
        user.setProfileImage(profileImage);
        return userDAO.update(user) > 0; 
    }
    
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        
        if (!PasswordUtil.verifyPassword(currentPassword, user.getPassword())) {
            return false;
        }
        
        String newHashedPassword = PasswordUtil.hashPassword(newPassword);
        return userDAO.updatePassword(userId, newHashedPassword) > 0;
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
            
            if (userDAO.updatePassword(user.getId(), hashedPassword) > 0) {
                System.out.println("임시 비밀번호 발급 [" + email + ": " + tempPassword + "]");
                return true;
            }
        }
        return false;
    }
}