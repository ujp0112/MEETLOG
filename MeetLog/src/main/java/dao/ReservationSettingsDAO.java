package dao;

import model.ReservationSettingsNew;
import model.ReservationOperatingHours;
import model.ReservationBlackoutDate;
import model.RestaurantTable;
import util.MyBatisSqlSessionFactory;

import org.apache.ibatis.session.SqlSession;
import java.time.DayOfWeek;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * 예약 설정 관련 데이터 접근 객체
 * 안전하고 트랜잭션을 고려한 구현
 */
public class ReservationSettingsDAO {

    /**
     * 음식점의 예약 설정 조회
     */
    public ReservationSettingsNew getByRestaurantId(int restaurantId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            return sqlSession.selectOne("dao.ReservationSettingsDAO.getByRestaurantId", restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 예약 설정 생성 (운영시간도 함께 생성)
     */
    public boolean create(ReservationSettingsNew settings) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();

            // 1. 기본 예약 설정 저장
            int result = sqlSession.insert("dao.ReservationSettingsDAO.insert", settings);

            if (result > 0 && settings.getId() > 0) {
                // 2. 기본 운영시간 생성 (월~일, 11:00-21:00)
                createDefaultOperatingHours(sqlSession, settings.getId());

                sqlSession.commit();
                return true;
            }

            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 예약 설정 수정
     */
    public boolean update(ReservationSettingsNew settings) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            int result = sqlSession.update("dao.ReservationSettingsDAO.update", settings);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 예약 설정 삭제 (비활성화)
     */
    public boolean delete(int id) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            int result = sqlSession.update("dao.ReservationSettingsDAO.delete", id);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 운영시간 조회
     */
    public List<ReservationOperatingHours> getOperatingHours(int settingsId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            return sqlSession.selectList("dao.ReservationSettingsDAO.getOperatingHours", settingsId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 운영시간 업데이트
     */
    public boolean updateOperatingHours(List<ReservationOperatingHours> operatingHoursList) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();

            for (ReservationOperatingHours hours : operatingHoursList) {
                // 유효성 검증
                if (!hours.isValidOperatingHours()) {
                    throw new IllegalArgumentException("Invalid operating hours: " + hours);
                }

                sqlSession.update("dao.ReservationSettingsDAO.updateOperatingHours", hours);
            }

            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 예약 불가 날짜 조회
     */
    public List<ReservationBlackoutDate> getBlackoutDates(int restaurantId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            return sqlSession.selectList("dao.ReservationSettingsDAO.getBlackoutDates", restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 예약 불가 날짜 추가
     */
    public boolean addBlackoutDate(ReservationBlackoutDate blackoutDate) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();

            // 유효성 검증
            if (!blackoutDate.isValidBlackoutDate()) {
                return false;
            }

            int result = sqlSession.insert("dao.ReservationSettingsDAO.insertBlackoutDate", blackoutDate);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 예약 불가 날짜 제거
     */
    public boolean removeBlackoutDate(int blackoutDateId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            int result = sqlSession.update("dao.ReservationSettingsDAO.deleteBlackoutDate", blackoutDateId);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 테이블 목록 조회
     */
    public List<RestaurantTable> getTables(int restaurantId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            return sqlSession.selectList("dao.ReservationSettingsDAO.getTables", restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 테이블 추가
     */
    public boolean addTable(RestaurantTable table) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();

            // 유효성 검증
            if (!table.isValidTable()) {
                return false;
            }

            int result = sqlSession.insert("dao.ReservationSettingsDAO.insertTable", table);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 테이블 수정
     */
    public boolean updateTable(RestaurantTable table) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();

            // 유효성 검증
            if (!table.isValidTable()) {
                return false;
            }

            int result = sqlSession.update("dao.ReservationSettingsDAO.updateTable", table);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 테이블 삭제 (비활성화)
     */
    public boolean deleteTable(int tableId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            int result = sqlSession.update("dao.ReservationSettingsDAO.deleteTable", tableId);

            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return false;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 기본 운영시간 생성 (private helper method)
     */
    private void createDefaultOperatingHours(SqlSession sqlSession, int settingsId) {
        DayOfWeek[] days = DayOfWeek.values();

        for (DayOfWeek day : days) {
            Map<String, Object> params = new HashMap<>();
            params.put("settingsId", settingsId);
            params.put("dayOfWeek", day.name());
            params.put("isEnabled", true);
            params.put("startTime", "11:00:00");
            params.put("endTime", "21:00:00");

            sqlSession.insert("dao.ReservationSettingsDAO.insertOperatingHours", params);
        }
    }
}