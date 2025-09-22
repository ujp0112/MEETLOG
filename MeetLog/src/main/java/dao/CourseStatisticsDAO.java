package dao;

import java.util.List;
import model.MonthlyReservation;
import model.PopularCourse;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory; // 사용자님이 제공해주신 SqlSessionFactory 클래스

public class CourseStatisticsDAO {

    // Mapper XML 파일의 namespace를 상수로 정의해두면 편리합니다.
    private static final String NAMESPACE = "mapper.CourseStatisticsMapper.";

    public int countTotalCourses() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            // selectOne 메소드는 결과가 하나의 행일 때 사용합니다.
            // 쿼리 결과가 없으면 null, 여러 개면 예외를 발생시킵니다.
            Integer result = session.selectOne(NAMESPACE + "countTotalCourses");
            return (result != null) ? result : 0;
        }
    }

    public int countActiveCourses() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer result = session.selectOne(NAMESPACE + "countActiveCourses");
            return (result != null) ? result : 0;
        }
    }

    public long sumTotalReservations() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Long result = session.selectOne(NAMESPACE + "sumTotalReservations");
            return (result != null) ? result : 0L;
        }
    }
    
    public long sumTotalRevenue() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Long result = session.selectOne(NAMESPACE + "sumTotalRevenue");
            return (result != null) ? result : 0L;
        }
    }
    
    public double getAverageRating() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(NAMESPACE + "getAverageRating");
            return (result != null) ? result : 0.0;
        }
    }
    
    public List<PopularCourse> findPopularCoursesTop5() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            // selectList 메소드는 결과가 여러 행일 때 사용합니다.
            return session.selectList(NAMESPACE + "findPopularCoursesTop5");
        }
    }
    
    public List<MonthlyReservation> findMonthlyReservations() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + "findMonthlyReservations");
        }
    }
}