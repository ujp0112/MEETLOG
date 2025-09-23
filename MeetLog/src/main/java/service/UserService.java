package service;

import org.apache.ibatis.session.SqlSession;
import dao.UserDAO;
import dao.BusinessUserDAO;
import dao.CompanyDAO;
import model.User;
import model.BusinessUser;
import model.Company;
import util.MyBatisSqlSessionFactory;
import util.PasswordUtil; // 새로 만든 PasswordUtil 클래스를 import 합니다.
import java.util.List;

public class UserService {
    private final UserDAO userDAO = new UserDAO();
    private final BusinessUserDAO businessUserDAO = new BusinessUserDAO();
    private final CompanyDAO companyDAO = new CompanyDAO();

    // --- 신규 통합 회원가입 로직 ---
    public boolean registerHqUser(User user, BusinessUser businessUser) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false);
        try {
            Company company = new Company();
            company.setName(businessUser.getBusinessName());
            companyDAO.insert(sqlSession, company);
            int newCompanyId = company.getId();

            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
            user.setUserType("BUSINESS");
            userDAO.insert(user, sqlSession);
            int newUserId = user.getId();

            businessUser.setUserId(newUserId);
            businessUser.setCompanyId(newCompanyId);
            businessUserDAO.insert(businessUser, sqlSession);

            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) sqlSession.rollback();
            return false;
        } finally {
            if (sqlSession != null) sqlSession.close();
        }
    }

    public boolean registerBranchUser(User user, BusinessUser businessUser) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false);
        try {
            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
            user.setUserType("BUSINESS");
            userDAO.insert(user, sqlSession);
            int newUserId = user.getId();

            businessUser.setUserId(newUserId);
            businessUserDAO.insert(businessUser, sqlSession);
            
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) sqlSession.rollback();
            return false;
        } finally {
            if (sqlSession != null) sqlSession.close();
        }
    }

    public boolean registerUser(User user) {
        // 입력값 검증
        if (user == null) {
            throw new IllegalArgumentException("사용자 정보가 null입니다.");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("이메일이 비어있습니다.");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("비밀번호가 비어있습니다.");
        }
        
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        return userDAO.insert(user) > 0;
    }

    // --- 기존 서비스 메소드들 ---
    public User authenticateUser(String email, String password) {
        User user = userDAO.findByEmail(email);
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }
    
    public boolean isCompanyExists(int companyId) {
        return companyDAO.existsById(companyId);
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

    public User findByEmail(String email) {
        return userDAO.findByEmail(email);
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
    
    public BusinessUser findHqUserByIdentifier(String identifier) {
        return businessUserDAO.findHqByIdentifier(identifier);
    }
    
    // --- HQ/Branch 관리 기능 ---
    
    public BusinessUser getBusinessUserByUserId(int userId) {
        return businessUserDAO.findByUserId(userId);
    }
    
    public List<BusinessUser> getPendingBranches(int companyId) {
        return businessUserDAO.findPendingByCompanyId(companyId);
    }
    
    public boolean approveBranch(int branchUserId) {
        return businessUserDAO.updateStatus(branchUserId, "ACTIVE") > 0;
    }

    public boolean rejectBranch(int branchUserId) {
        return userDAO.delete(branchUserId) > 0;
    }
}