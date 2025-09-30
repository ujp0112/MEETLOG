package dao;

import model.Notice;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class NoticeDAO {

    public List<Notice> findAll() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("NoticeMapper.findAll");
        }
    }

    public Notice findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("NoticeMapper.findById", id);
        }
    }

    public List<Notice> findRecent(int limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("NoticeMapper.findRecent", limit);
        }
    }

    public int insert(Notice notice) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert("NoticeMapper.insert", notice);
            session.commit();
            return result;
        }
    }

    public int update(Notice notice) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update("NoticeMapper.update", notice);
            session.commit();
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("NoticeMapper.delete", id);
            session.commit();
            return result;
        }
    }

    public int countTotal() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("NoticeMapper.countTotal");
        }
    }
}