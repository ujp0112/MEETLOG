package dao;

import java.util.List;
import model.News;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class NewsDAO {
    
    /**
     * 맛집별 뉴스 조회
     */
    public List<News> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("NewsMapper.findByRestaurantId", restaurantId);
        } catch (Exception e) {
            System.err.println("뉴스 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 모든 활성 뉴스 조회
     */
    public List<News> findAllActive() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("NewsMapper.findAllActive");
        } catch (Exception e) {
            System.err.println("뉴스 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 뉴스 추가
     */
    public int insertNews(News news) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("NewsMapper.insertNews", news);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("뉴스 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 뉴스 수정
     */
    public int updateNews(News news) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("NewsMapper.updateNews", news);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("뉴스 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 뉴스 삭제 (비활성화)
     */
    public int deleteNews(int newsId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("NewsMapper.deleteNews", newsId);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("뉴스 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}
