package service;

import dao.BusinessUserDAO;
import dao.UserDAO;
import model.BusinessUser;
import model.User;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class BusinessUserService {
    private BusinessUserDAO businessUserDAO = new BusinessUserDAO();
    private UserDAO userDAO = new UserDAO();

    /**
     * 비즈니스 사용자 등록
     * @param businessUser 비즈니스 사용자 정보
     * @return 등록 성공 여부
     */
    public boolean registerBusinessUser(User user, BusinessUser businessUser) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. 사용자 정보 먼저 등록
                int userResult = userDAO.insert(user, sqlSession);
                if (userResult <= 0) {
                    sqlSession.rollback();
                    return false;
                }
                
                // 2. 비즈니스 사용자 정보 등록
                businessUser.setUserId(user.getId());
                int businessResult = businessUserDAO.insert(businessUser, sqlSession);
                if (businessResult <= 0) {
                    sqlSession.rollback();
                    return false;
                }
                
                sqlSession.commit();
                return true;
            } catch (Exception e) {
                sqlSession.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    /**
     * 사용자 ID로 비즈니스 사용자 정보 조회
     * @param userId 사용자 ID
     * @return 비즈니스 사용자 정보
     */
    public BusinessUser getBusinessUserByUserId(int userId) {
        return businessUserDAO.findByUserId(userId);
    }

    /**
     * 비즈니스 사용자 정보 수정
     * @param user 수정할 사용자 정보
     * @param businessUser 수정할 비즈니스 사용자 정보
     * @return 수정 성공 여부
     */
    public boolean updateBusinessUser(User user, BusinessUser businessUser) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. 사용자 정보 수정
                int userResult = userDAO.update(user, sqlSession);
                if (userResult <= 0) {
                    sqlSession.rollback();
                    return false;
                }
                
                // 2. 비즈니스 사용자 정보 수정
                int businessResult = businessUserDAO.update(businessUser, sqlSession);
                if (businessResult <= 0) {
                    sqlSession.rollback();
                    return false;
                }
                
                sqlSession.commit();
                return true;
            } catch (Exception e) {
                sqlSession.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    /**
     * 비즈니스 사용자 삭제
     * @param userId 사용자 ID
     * @return 삭제 성공 여부
     */
    public boolean deleteBusinessUser(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. 비즈니스 사용자 정보 삭제
                int businessResult = businessUserDAO.deleteByUserId(userId, sqlSession);
                if (businessResult <= 0) {
                    sqlSession.rollback();
                    return false;
                }
                
                // 2. 사용자 정보 삭제
                int userResult = userDAO.delete(userId, sqlSession);
                if (userResult <= 0) {
                    sqlSession.rollback();
                    return false;
                }
                
                sqlSession.commit();
                return true;
            } catch (Exception e) {
                sqlSession.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    /**
     * 사업자 등록번호 중복 확인
     * @param businessNumber 사업자 등록번호
     * @return 중복 여부
     */
    public boolean isBusinessNumberExists(String businessNumber) {
        return businessUserDAO.findByBusinessNumber(businessNumber) != null;
    }

    /**
     * 비즈니스 사용자 목록 조회 (관리자용)
     * @return 비즈니스 사용자 목록
     */
    public List<BusinessUser> getAllBusinessUsers() {
        return businessUserDAO.findAll();
    }

    /**
     * 비즈니스 사용자 인증
     * @param email 이메일
     * @param password 비밀번호
     * @return 인증된 비즈니스 사용자 정보
     */
    public BusinessUser authenticateBusinessUser(String email, String password) {
        User user = userDAO.findByEmail(email);
        if (user != null && "BUSINESS".equals(user.getUserType())) {
            // 비즈니스 사용자 정보 조회
            return getBusinessUserByUserId(user.getId());
        }
        return null;
    }
}
