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

    // [추가된 메서드]
    public List<Reservation> findRecentByUserId(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            // 이 ID는 ReservationMapper.xml에 추가한 쿼리의 id와 일치합니다.
            return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
        }
    }
    // [추가 끝]

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