package controller;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import model.Restaurant;
import model.Review;
import model.Column;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/debug")
public class DebugServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println("<h1>데이터 디버그 테스트</h1>");
        
        // 실제 데이터 생성
        List<Restaurant> restaurants = createTestRestaurants();
        List<Review> reviews = createTestReviews();
        List<Column> columns = createTestColumns();
        
        // HTML 출력
        response.getWriter().println("<h2>맛집 데이터</h2>");
        for (Restaurant restaurant : restaurants) {
            response.getWriter().println("<p>" + restaurant.getName() + " - " + restaurant.getCategory() + "</p>");
        }
        
        response.getWriter().println("<h2>리뷰 데이터</h2>");
        for (Review review : reviews) {
            response.getWriter().println("<p>" + review.getContent() + " - 평점: " + review.getRating() + "</p>");
        }
        
        response.getWriter().println("<h2>칼럼 데이터</h2>");
        for (Column column : columns) {
            response.getWriter().println("<p>" + column.getTitle() + " - " + column.getAuthor() + "</p>");
        }
    }
    
    private List<Restaurant> createTestRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();
        
        Restaurant restaurant1 = new Restaurant();
        restaurant1.setName("테스트 맛집 1");
        restaurant1.setCategory("한식");
        restaurant1.setAddress("서울시 강남구");
        restaurant1.setRating(4.5);
        restaurants.add(restaurant1);
        
        Restaurant restaurant2 = new Restaurant();
        restaurant2.setName("테스트 맛집 2");
        restaurant2.setCategory("양식");
        restaurant2.setAddress("서울시 홍대");
        restaurant2.setRating(4.2);
        restaurants.add(restaurant2);
        
        return restaurants;
    }
    
    private List<Review> createTestReviews() {
        List<Review> reviews = new ArrayList<>();
        
        Review review1 = new Review();
        review1.setContent("정말 맛있어요!");
        review1.setRating(5);
        reviews.add(review1);
        
        Review review2 = new Review();
        review2.setContent("괜찮아요");
        review2.setRating(4);
        reviews.add(review2);
        
        return reviews;
    }
    
    private List<Column> createTestColumns() {
        List<Column> columns = new ArrayList<>();
        
        Column column1 = new Column();
        column1.setTitle("테스트 칼럼 1");
        column1.setAuthor("작성자1");
        columns.add(column1);
        
        Column column2 = new Column();
        column2.setTitle("테스트 칼럼 2");
        column2.setAuthor("작성자2");
        columns.add(column2);
        
        return columns;
    }
}
