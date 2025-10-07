package dao;

import model.Report;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {
    private static final String NAMESPACE = "mapper.ReportMapper";

    public List<Report> selectAllReports() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".selectAllReports");
        }
    }

    public List<Report> selectReportsByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".selectReportsByStatus", status);
        }
    }

    public Report selectReportById(int reportId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".selectReportById", reportId);
        }
    }

    public int updateReportStatus(int reportId, String status, Integer processedBy, String adminNote) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("reportId", reportId);
            params.put("status", status);
            params.put("processedBy", processedBy);
            params.put("adminNote", adminNote);
            int result = session.update(NAMESPACE + ".updateReportStatus", params);
            session.commit();
            return result;
        }
    }

    public int insertReport(Report report) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(NAMESPACE + ".insertReport", report);
            session.commit();
            return result;
        }
    }

    public boolean existsReport(int reporterId, String reportedType, int reportedId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("reporterId", reporterId);
            params.put("reportedType", reportedType);
            params.put("reportedId", reportedId);
            Integer count = session.selectOne(NAMESPACE + ".countExistingReport", params);
            return count != null && count > 0;
        }
    }

    public Map<String, Integer> getReportStatistics() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".getReportStatistics");
        }
    }
}
