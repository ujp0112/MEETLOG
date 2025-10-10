package service;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import util.PasswordUtil; // 👈 PasswordUtil 임포트 추가
import dao.UserDAO;
import dao.BusinessUserDAO;
import dao.RestaurantDAO;
import dao.CompanyDAO;
import model.User;
import model.AdminBusinessSummary;
import model.BusinessUser;
import model.Restaurant;
import model.Company;

public class BusinessUserService {
	private final UserDAO userDAO = new UserDAO();
	private final BusinessUserDAO businessUserDAO = new BusinessUserDAO();
	private final RestaurantDAO restaurantDAO = new RestaurantDAO();
	private final CompanyDAO companyDAO = new CompanyDAO();

	public void registerHqUser(User user, BusinessUser businessUser, Restaurant restaurant, Company company)
			throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
		try {
			// ▼▼▼ 수정된 부분 ▼▼▼
			// DB에 저장하기 직전, 서비스 계층에서 비밀번호를 암호화합니다.
			String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
			user.setPassword(hashedPassword);
			// ▲▲▲ 수정된 부분 ▲▲▲
			
			// ▼▼▼ [디버깅 코드 추가] ▼▼▼
	        System.out.println("### [가입 시점] 암호화된 비밀번호: " + hashedPassword);
	        // ▲▲▲ [디버깅 코드 추가] ▲▲▲

			if (userDAO.insert(user, sqlSession) == 0)
				throw new Exception("사용자 정보 생성 실패");
			if (companyDAO.insert(sqlSession, company) == 0)
				throw new Exception("회사 정보 생성 실패");

			businessUser.setUserId(user.getId());
			businessUser.setCompanyId(company.getId());
			if (businessUserDAO.insert(businessUser, sqlSession) == 0)
				throw new Exception("사업자 정보 생성 실패");

			restaurant.setOwnerId(user.getId());
			if (restaurantDAO.insert(sqlSession, restaurant) == 0)
				throw new Exception("식당 정보 생성 실패");

			sqlSession.commit();
		} catch (Exception e) {
			sqlSession.rollback();
			throw new Exception("본사 회원 등록 중 오류가 발생했습니다: ".concat(e.getMessage()), e);
		} finally {
			sqlSession.close();
		}
	}

	public void registerBranchUser(User user, BusinessUser businessUser, Restaurant restaurant) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
		try {
			// ▼▼▼ 수정된 부분 ▼▼▼
			String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
			user.setPassword(hashedPassword);
			// ▲▲▲ 수정된 부분 ▲▲▲

			if (userDAO.insert(user, sqlSession) == 0)
				throw new Exception("사용자 정보 생성 실패");

			businessUser.setUserId(user.getId());
			if (businessUserDAO.insert(businessUser, sqlSession) == 0)
				throw new Exception("사업자 정보 생성 실패");

			restaurant.setOwnerId(user.getId());
			if (restaurantDAO.insert(sqlSession, restaurant) == 0)
				throw new Exception("식당 정보 생성 실패");

			sqlSession.commit();
		} catch (Exception e) {
			sqlSession.rollback();
			throw new Exception("지점 회원 등록 중 오류가 발생했습니다: ".concat(e.getMessage()), e);
		} finally {
			sqlSession.close();
		}
	}

	public void registerIndividualUser(User user, BusinessUser businessUser, Restaurant restaurant, Company company)
			throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
		try {
			// ▼▼▼ 수정된 부분 ▼▼▼
			String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
			user.setPassword(hashedPassword);
			// ▲▲▲ 수정된 부분 ▲▲▲

			if (userDAO.insert(user, sqlSession) == 0)
				throw new Exception("사용자 정보 생성 실패");
			if (companyDAO.insert(sqlSession, company) == 0)
				throw new Exception("회사 정보 생성 실패");

			businessUser.setUserId(user.getId());
			businessUser.setCompanyId(company.getId());
			if (businessUserDAO.insert(businessUser, sqlSession) == 0)
				throw new Exception("사업자 정보 생성 실패");

			// 개인 사업자도 식당 정보가 필요하다면 주석 해제
			// restaurant.setOwnerId(user.getId());
			// if (restaurantDAO.insert(sqlSession, restaurant) == 0) throw new
			// Exception("식당 정보 생성 실패");

			sqlSession.commit();
		} catch (Exception e) {
			sqlSession.rollback();
			throw new Exception("개인 사업자 회원 등록 중 오류가 발생했습니다: ".concat(e.getMessage()), e);
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
}