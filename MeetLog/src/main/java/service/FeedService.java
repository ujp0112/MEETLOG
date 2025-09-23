package service;

import model.FeedActivity;
import dao.ReviewDAO;
import dao.CourseDAO;
import dao.ColumnDAO;
import dao.RestaurantDAO;
import dao.UserDAO;
import model.Review;
import model.Course;
import model.Column;
import model.Restaurant;
import model.User;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class FeedService {
    private ReviewDAO reviewDAO = new ReviewDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private ColumnDAO columnDAO = new ColumnDAO();
    private RestaurantDAO restaurantDAO = new RestaurantDAO();
    private UserDAO userDAO = new UserDAO();
    private FollowService followService = new FollowService();
    
    /**
     * 사용자의 팔로우 피드 조회
     */
    public List<FeedActivity> getFollowFeed(int userId, int limit, int offset) {
        // 팔로우하는 사용자들의 ID 목록 조회
        List<Integer> followingIds = followService.getFollowingIds(userId);
        
        if (followingIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<FeedActivity> activities = new ArrayList<>();
        
        // 각 팔로우하는 사용자의 활동들을 조회
        for (Integer followingId : followingIds) {
            // 리뷰 활동
            List<Review> reviews = reviewDAO.getRecentReviewsByUser(followingId, 5);
            for (Review review : reviews) {
                FeedActivity activity = createReviewActivity(review);
                if (activity != null) {
                    activities.add(activity);
                }
            }
            
            // 코스 활동
            List<Course> courses = courseDAO.getRecentCoursesByUser(followingId, 5);
            for (Course course : courses) {
                FeedActivity activity = createCourseActivity(course);
                if (activity != null) {
                    activities.add(activity);
                }
            }
            
            // 칼럼 활동
            List<Column> columns = columnDAO.getRecentColumnsByUser(followingId, 5);
            for (Column column : columns) {
                FeedActivity activity = createColumnActivity(column);
                if (activity != null) {
                    activities.add(activity);
                }
            }
        }
        
        // 시간순으로 정렬 (최신순)
        Collections.sort(activities, new Comparator<FeedActivity>() {
            @Override
            public int compare(FeedActivity a1, FeedActivity a2) {
                return a2.getCreatedAt().compareTo(a1.getCreatedAt());
            }
        });
        
        // 페이징 처리
        int fromIndex = Math.min(offset, activities.size());
        int toIndex = Math.min(offset + limit, activities.size());
        
        return activities.subList(fromIndex, toIndex);
    }
    
    private FeedActivity createReviewActivity(Review review) {
        try {
            User user = userDAO.findById(review.getUserId());
            if (user == null) return null;
            
            Restaurant restaurant = restaurantDAO.findById(review.getRestaurantId());
            
            FeedActivity activity = new FeedActivity(review.getUserId(), "REVIEW", review.getId());
            activity.setCreatedAt(review.getCreatedAt());
            activity.setUserNickname(user.getNickname());
            activity.setUserProfileImage(user.getProfileImage());
            activity.setContentTitle("리뷰: " + (restaurant != null ? restaurant.getName() : "음식점"));
            activity.setContentDescription(review.getContent());
            activity.setContentRating((double) review.getRating());
            activity.setRestaurantName(restaurant != null ? restaurant.getName() : "");
            activity.setContentLocation(restaurant != null ? restaurant.getLocation() : "");
            
            return activity;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private FeedActivity createCourseActivity(Course course) {
        try {
            User user = userDAO.findById(course.getAuthorId());
            if (user == null) return null;
            
            FeedActivity activity = new FeedActivity(course.getAuthorId(), "COURSE", course.getCourseId());
            activity.setCreatedAt(course.getCreatedAt());
            activity.setUserNickname(user.getNickname());
            activity.setUserProfileImage(user.getProfileImage());
            activity.setContentTitle(course.getTitle());
            activity.setContentDescription(course.getDescription());
            activity.setContentImage(course.getPreviewImage());
            
            return activity;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private FeedActivity createColumnActivity(Column column) {
        try {
            FeedActivity activity = new FeedActivity(0, "COLUMN", column.getId()); // Column에서 author_id 대신 author 필드 사용
            // Timestamp를 LocalDateTime으로 변환
            if (column.getCreatedAt() != null) {
                activity.setCreatedAt(column.getCreatedAt().toLocalDateTime());
            }
            activity.setUserNickname(column.getAuthor());
            activity.setContentTitle(column.getTitle());
            activity.setContentDescription(column.getContent().length() > 200 ? 
                column.getContent().substring(0, 200) + "..." : column.getContent());
            activity.setContentImage(column.getImage());
            
            return activity;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 피드 활동 총 개수 조회
     */
    public int getFeedCount(int userId) {
        List<Integer> followingIds = followService.getFollowingIds(userId);
        
        if (followingIds.isEmpty()) {
            return 0;
        }
        
        int totalCount = 0;
        
        for (Integer followingId : followingIds) {
            totalCount += reviewDAO.getReviewCountByUser(followingId);
            totalCount += courseDAO.getCourseCountByUser(followingId);
            totalCount += columnDAO.getColumnCountByUser(followingId);
        }
        
        return totalCount;
    }
}