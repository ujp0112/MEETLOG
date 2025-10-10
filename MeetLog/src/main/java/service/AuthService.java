package service;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import dto.AppUser;
import dto.Branch;
import dto.Company;
import util.MyBatisSqlSessionFactory;

public class AuthService {
	private static final Logger log = LoggerFactory.getLogger(AuthService.class);

	public AppUser findByEmail(String email) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("email", email);
			return s.selectOne("mapper.AuthMapper.findByEmail", p);
		}
	}

	public AppUser findHqByIdentifier(String identifier) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("identifier", identifier);
			return s.selectOne("mapper.AuthMapper.findHqByIdentifier", p);
		}
	}

	public long createCompany(Company c) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			s.insert("mapper.AuthMapper.insertCompany", c);
			return c.getId();
		}
	}

	public long createBranch(Branch b) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			s.insert("mapper.AuthMapper.insertBranch", b);
			return b.getId();
		}
	}

	public long createUser(AppUser u) {
		try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
			s.insert("mapper.AuthMapper.insertUser", u);
			return u.getId();
		}
	}
}
