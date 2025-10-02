package service;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import dao.UserDAO;
import dao.BusinessUserDAO;
import dao.RestaurantDAO;
import dao.CompanyDAO; // CompanyDAO import
import model.User;
import model.AdminBusinessSummary;
import model.BusinessUser;
import model.Restaurant;
import model.Company; // Company 모델 import

public class BusinessUserService {
    private final UserDAO userDAO = new UserDAO();
    private final BusinessUserDAO businessUserDAO = new BusinessUserDAO();
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final CompanyDAO companyDAO = new CompanyDAO(); // CompanyDAO 객체 생성

    // [수정] Company 객체를 파라미터로 받아 4개 테이블을 트랜잭션으로 처리
    public void registerHqUser(User user, BusinessUser businessUser, Restaurant restaurant, Company company) throws Exception {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. User 저장
            if (userDAO.insert(user, sqlSession) == 0) throw new Exception("사용자 정보 생성 실패");
            
            // 2. Company 저장
            if (companyDAO.insert(sqlSession, company) == 0) throw new Exception("회사 정보 생성 실패");
            
            // 3. BusinessUser에 생성된 ID들 설정 후 저장
            businessUser.setUserId(user.getId());
            businessUser.setCompanyId(company.getId()); // 생성된 Company ID 설정
            if (businessUserDAO.insert(businessUser, sqlSession) == 0) throw new Exception("사업자 정보 생성 실패");
            
            // 4. Restaurant 저장
            restaurant.setOwnerId(user.getId());
            if (restaurantDAO.insert(sqlSession, restaurant) == 0) throw new Exception("식당 정보 생성 실패");
            
            sqlSession.commit();
        } catch (Exception e) {
            sqlSession.rollback();
            // 에러 원인을 포함하여 예외를 다시 던짐
            throw new Exception("본사 회원 등록 중 오류가 발생했습니다: " + e.getMessage(), e);
        } finally {
            sqlSession.close();
        }
    }

    public void registerBranchUser(User user, BusinessUser businessUser, Restaurant restaurant) throws Exception {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            if (userDAO.insert(user, sqlSession) == 0) throw new Exception("사용자 정보 생성 실패");
            
            businessUser.setUserId(user.getId());
            if (businessUserDAO.insert(businessUser, sqlSession) == 0) throw new Exception("사업자 정보 생성 실패");

            restaurant.setOwnerId(user.getId());
            if (restaurantDAO.insert(sqlSession, restaurant) == 0) throw new Exception("식당 정보 생성 실패");
            
            sqlSession.commit();
        } catch (Exception e) {
            sqlSession.rollback();
            throw new Exception("지점 회원 등록 중 오류가 발생했습니다: " + e.getMessage(), e);
        } finally {
            sqlSession.close();
        }
    }

    public BusinessUser findHqByIdentifier(String identifier) {
        return businessUserDAO.findHqByIdentifier(identifier);
    }
    public java.util.List<AdminBusinessSummary> getAdminBusinessSummaries() {
        return businessUserDAO.findAdminBusinessSummaries();
    }

    public boolean updateBusinessStatus(int userId, String status) {
        return businessUserDAO.updateStatus(userId, status) > 0;
    }

	public void registerIndividualUser(User user, BusinessUser businessUser, Restaurant restaurant, Company company) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. User 저장
            if (userDAO.insert(user, sqlSession) == 0) throw new Exception("사용자 정보 생성 실패");
            
            // 2. Company 저장
            if (companyDAO.insert(sqlSession, company) == 0) throw new Exception("회사 정보 생성 실패");
            
            // 3. BusinessUser에 생성된 ID들 설정 후 저장
            businessUser.setUserId(user.getId());
            businessUser.setCompanyId(company.getId()); // 생성된 Company ID 설정
            if (businessUserDAO.insert(businessUser, sqlSession) == 0) throw new Exception("사업자 정보 생성 실패");
            
            // 4. Restaurant 저장
//            restaurant.setOwnerId(user.getId());
//            if (restaurantDAO.insert(sqlSession, restaurant) == 0) throw new Exception("식당 정보 생성 실패");

            sqlSession.commit();
        } catch (Exception e) {
            sqlSession.rollback();
            // 에러 원인을 포함하여 예외를 다시 던짐
            throw new Exception("개인 사업자 회원 등록 중 오류가 발생했습니다: " + e.getMessage(), e);
        } finally {
            sqlSession.close();
        }
	}
}