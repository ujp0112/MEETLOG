package erpService;
import org.apache.ibatis.session.SqlSession;

import erpDto.*;
import util.MyBatisSqlSessionFactory;

import java.util.*;

public class AuthService {
  public AppUser findByEmail(String email){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      Map<String,Object> p=new HashMap<>(); p.put("email", email);
      return s.selectOne("erpMapper.AuthMapper.findByEmail", p);
    }
  }
  public AppUser findHqByIdentifier(String identifier){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      Map<String,Object> p=new HashMap<>(); p.put("identifier", identifier);
      return s.selectOne("erpMapper.AuthMapper.findHqByIdentifier", p);
    }
  }
  public long createCompany(Company c){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("erpMapper.AuthMapper.insertCompany", c);
      return c.getId();
    }
  }
  public long createBranch(Branch b){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("erpMapper.AuthMapper.insertBranch", b);
      return b.getId();
    }
  }
  public long createUser(AppUser u){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("erpMapper.AuthMapper.insertUser", u);
      return u.getId();
    }
  }
}
