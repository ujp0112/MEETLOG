package service;

import java.util.List;
import dao.NewsDAO;
import model.News;

public class NewsService {
    private NewsDAO newsDAO = new NewsDAO();
    
    /**
     * 맛집별 뉴스 조회
     */
    public List<News> getNewsByRestaurantId(int restaurantId) {
        try {
            return newsDAO.findByRestaurantId(restaurantId);
        } catch (Exception e) {
            System.err.println("맛집별 뉴스 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 모든 활성 뉴스 조회
     */
    public List<News> getAllActiveNews() {
        try {
            return newsDAO.findAllActive();
        } catch (Exception e) {
            System.err.println("활성 뉴스 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 뉴스 추가
     */
    public boolean addNews(News news) {
        try {
            int result = newsDAO.insertNews(news);
            return result > 0;
        } catch (Exception e) {
            System.err.println("뉴스 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 뉴스 수정
     */
    public boolean updateNews(News news) {
        try {
            int result = newsDAO.updateNews(news);
            return result > 0;
        } catch (Exception e) {
            System.err.println("뉴스 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 뉴스 삭제
     */
    public boolean deleteNews(int newsId) {
        try {
            int result = newsDAO.deleteNews(newsId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("뉴스 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
