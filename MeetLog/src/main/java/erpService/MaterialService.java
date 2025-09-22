package erpService;

import org.apache.ibatis.session.SqlSession;

import erpDto.Material;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MaterialService {

  public void create(Material m) {
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.insert("MaterialMapper.insertMaterial", m);
    }
  }

  public void update(Material m) {
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.update("MaterialMapper.updateMaterial", m);
    }
  }

  public void softDelete(long companyId, long id) {
    Map<String,Object> p = new HashMap<>();
    p.put("companyId", companyId);
    p.put("id", id);
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      s.update("MaterialMapper.softDeleteMaterial", p);
    }
  }

  public Material findById(long companyId, long id) {
    Map<String,Object> p = new HashMap<>();
    p.put("companyId", companyId);
    p.put("id", id);
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      return s.selectOne("MaterialMapper.findById", p);
    }
  }

  public List<Material> listByCompany(long companyId) {
    Map<String,Object> p = new HashMap<>();
    p.put("companyId", companyId);
    try (SqlSession s = MyBatisSqlSessionFactory.getSqlSession()) {
      return s.selectList("MaterialMapper.listByCompany", p);
    }
  }
}
