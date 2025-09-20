package service;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import dto.*;
import java.util.*;

public class AuthService {
  public AppUser findByEmail(String email){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      Map<String,Object> p=new HashMap<>(); p.put("email", email);
      return s.selectOne("mapper.AuthMapper.findByEmail", p);
    }
  }
  public AppUser findHqByIdentifier(String identifier){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      Map<String,Object> p=new HashMap<>(); p.put("identifier", identifier);
      return s.selectOne("mapper.AuthMapper.findHqByIdentifier", p);
    }
  }
  public long createCompany(Company c){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("mapper.AuthMapper.insertCompany", c);
      return c.getId();
    }
  }
  public long createBranch(Branch b){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("mapper.AuthMapper.insertBranch", b);
      return b.getId();
    }
  }
  public long createUser(AppUser u){
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("mapper.AuthMapper.insertUser", u);
      return u.getId();
    }
  }
  public List<Branch> findPendingBranches(long companyId) {
      try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
          Map<String, Object> p = new HashMap<>();
          p.put("companyId", companyId);
          return s.selectList("mapper.AuthMapper.findPendingBranchesByCompany", p);
      }
  }

  // [추가] 지점 가입을 승인하는 서비스 메소드
  public void approveBranch(long companyId, long branchId, long userId) {
      try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) { // auto-commit
          Map<String, Object> params = new HashMap<>();
          params.put("companyId", companyId);
          params.put("branchId", branchId);
          params.put("userId", userId);
          params.put("activeYn", "Y");
          
          s.update("mapper.AuthMapper.updateBranchActive", params);
          s.update("mapper.AuthMapper.updateUserActive", params);
      }
  }
  
  // [추가] 지점 가입을 거절(삭제)하는 서비스 메소드
  public void rejectBranch(long companyId, long branchId, long userId) {
      try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) { // auto-commit
           Map<String, Object> params = new HashMap<>();
          params.put("companyId", companyId);
          params.put("branchId", branchId);
          params.put("userId", userId);

          // 사용자를 먼저 삭제해야 외래 키 제약 조건에 위배되지 않습니다.
          s.delete("mapper.AuthMapper.deleteUser", params);
          s.delete("mapper.AuthMapper.deleteBranch", params);
      }
  }
	  
}
