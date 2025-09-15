package dao;

import model.Reservation;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class ReservationDAO {
    private static final String NAMESPACE = "dao.ReservationDAO";

    public Reservation findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    public List<Reservation> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }

    public int insert(Reservation reservation) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.insert(NAMESPACE + ".insert", reservation);
        }
    }

    public int updateStatus(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.update(NAMESPACE + ".updateStatus", params);
        }
    }
}