package dao;

import model.User;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class UserDAO {
	private static final String NAMESPACE = "dao.UserDAO";

	public User findByEmail(String email) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findByEmail", email);
		}
	}

	public User findByNickname(String nickname) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findByNickname", nickname);
		}
	}

	public User findById(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findById", id);
		}
	}

	// ▼▼▼ [추가] 이메일과 사용자 유형으로 사용자를 찾는 신규 메소드 ▼▼▼
	public User findByEmailAndUserType(String email, String userType) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("email", email);
			params.put("userType", userType);
			// 매퍼의 "findByEmailAndUserType" ID를 가진 쿼리 실행
			return sqlSession.selectOne(NAMESPACE + ".findByEmailAndUserType", params);
		}
	}

	/**
	 * [신규] 트랜잭션 관리를 위해 SqlSession을 외부(서비스 계층)에서 받아 처리하는 메소드
	 */
	public int insert(User user, SqlSession sqlSession) {
		// 이 메소드는 commit/close를 직접 하지 않습니다.
		return sqlSession.insert(NAMESPACE + ".insert", user);
	}

	/**
	 * 단독으로 User를 삽입할 때 사용하는 기존 메소드 (Auto-commit)
	 */
	public int insert(User user) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) { // 자동 커밋
			return sqlSession.insert(NAMESPACE + ".insert", user);
		}
	}

	public int update(User user) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
			return sqlSession.update(NAMESPACE + ".update", user);
		}
	}

	public int updatePassword(int userId, String newHashedPassword) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
			Map<String, Object> params = new HashMap<>();
			params.put("id", userId);
			params.put("password", newHashedPassword);
			return sqlSession.update(NAMESPACE + ".updatePassword", params);
		}
	}

	public int delete(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
			return sqlSession.update(NAMESPACE + ".delete", id);
		}
	}

	public List<User> findAll() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findAll");
		}
	}

	public List<User> findAllIncludingInactive() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findAllIncludingInactive");
		}
	}

	public int update(User user, SqlSession sqlSession) {
		return sqlSession.update(NAMESPACE + ".update", user);
	}

	public int delete(int id, SqlSession sqlSession) {
		return sqlSession.update(NAMESPACE + ".delete", id);
	}

	public int updateActiveStatus(int id, boolean active) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
			Map<String, Object> params = new HashMap<>();
			params.put("id", id);
			params.put("active", active);
			return sqlSession.update(NAMESPACE + ".updateActiveStatus", params);
		}
	}

	public int linkSocialAccount(int userId, String socialProvider, String socialId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
			Map<String, Object> params = new HashMap<>();
			params.put("id", userId);
			params.put("socialProvider", socialProvider);
			params.put("socialId", socialId);
			return sqlSession.update(NAMESPACE + ".linkSocialAccount", params);
		}
	}

	public User findBySocial(String socialProvider, String socialId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("socialProvider", socialProvider);
			params.put("socialId", socialId);
			return sqlSession.selectOne(NAMESPACE + ".findBySocial", params);
		}
	}
}
