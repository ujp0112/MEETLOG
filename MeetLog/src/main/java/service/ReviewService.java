package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.RestaurantDAO;
import dao.ReviewDAO;
import model.Review;
import model.ReviewInfo;
import util.MyBatisSqlSessionFactory;

public class ReviewService {
	private final ReviewDAO reviewDAO = new ReviewDAO();
	private final RestaurantDAO restaurantDAO = new RestaurantDAO();

	// --- Read Operations ---
	public List<Review> findAll() {
		return reviewDAO.findAll();
	}

	public Review findById(int id) {
		return reviewDAO.findById(id);
	}

	public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
		return reviewDAO.getRecentReviewsWithInfo(limit);
	}

	public List<Review> getRecentReviews(int limit) {
		return reviewDAO.findRecentReviews(limit);
	}

	public List<Review> getReviewsByRestaurantId(int restaurantId) {
		return reviewDAO.findByRestaurantId(restaurantId);
	}
	
	public List<Review> getReviewsByRestaurantId(int restaurantId, Integer currentUserId) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("restaurantId", restaurantId);
	    params.put("currentUserId", currentUserId); // 쿼리에 전달할 파라미터
	    return reviewDAO.findByRestaurantId(params);
	}

	public List<Review> getReviewsByUserId(int userId) {
		return reviewDAO.findByUserId(userId);
	}

	public List<Review> getRecentReviews(int userId, int limit) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("limit", limit);
		return reviewDAO.findRecentByUserId(params);
	}

	public List<Review> getRecentReviewsByOwnerId(int ownerId, int limit) {
		return reviewDAO.findRecentReviewsByOwnerId(ownerId, limit);
	}

	public List<Review> searchReviews(Map<String, Object> searchParams) {
		return reviewDAO.findAll(); // 임시로 모든 리뷰 반환
	}

	public boolean addReview(Review review) {
		// SqlSession을 try-with-resources 구문으로 사용하여 자동 close를 보장합니다.
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			try {
				// 1. 리뷰 기본 정보 저장 (성공 시 review 객체에 새로 생성된 ID가 담김)
				reviewDAO.insertReview(session, review);

				List<String> imageList = review.getImages();

				// 2. 저장할 이미지가 있을 경우에만 이미지 정보를 별도 테이블에 저장
				if (imageList != null && !imageList.isEmpty()) {
					Map<String, Object> params = new HashMap<>();
					params.put("reviewId", review.getId()); // 1번에서 생성된 리뷰 ID
					params.put("imageList", imageList); // 서블릿에서 전달받은 이미지 파일명 리스트
					reviewDAO.insertReviewImages(session, params);
				}

				// 3. 피드 아이템 생성 (리뷰 작성 활동을 피드에 추가)
				try {
					FeedService feedService = new FeedService();
					feedService.createSimpleReviewFeedItemWithRestaurant(review.getUserId(), review.getId(),
							review.getRestaurantId());
					System.out.println("DEBUG: 리뷰 피드 아이템 생성 완료 - 리뷰 ID: " + review.getId() + ", 음식점 ID: "
							+ review.getRestaurantId());
				} catch (Exception e) {
					System.err.println("피드 아이템 생성 실패: " + e.getMessage());
					e.printStackTrace();
					// 피드 아이템 생성 실패는 리뷰 작성을 막지 않음
				}
				
				restaurantDAO.updateRatingAndReviewCount(session, review.getRestaurantId());

				// 모든 DB 작업이 성공적으로 끝나면 commit
				session.commit();
				return true;

			} catch (Exception e) {
				// DB 작업 중 하나라도 실패하면 모든 작업을 취소 (rollback)
				session.rollback();
				e.printStackTrace();
				return false;
			}
		}
	}

	public boolean updateReview(Review review) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			try {
				int result = reviewDAO.update(sqlSession, review);
				if (result > 0) {
					restaurantDAO.updateRatingAndReviewCount(sqlSession, review.getRestaurantId());
					sqlSession.commit();
					return true;
				}
			} catch (Exception e) {
				e.printStackTrace();
				sqlSession.rollback();
			}
		}
		return false;
	}

	public boolean deleteReview(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			try {
				// ▼▼▼ [수정] 삭제 전에 레스토랑 ID를 먼저 조회해야 합니다. ▼▼▼
				Review reviewToDelete = reviewDAO.findById(id);
				if (reviewToDelete == null) {
					// 삭제할 리뷰가 없으면 롤백하고 실패를 반환합니다.
					sqlSession.rollback();
					return false;
				}
				int restaurantId = reviewToDelete.getRestaurantId();
				
				int result = reviewDAO.delete(sqlSession, id);
				if (result > 0) {
					// ▼▼▼ [수정] 리뷰 삭제 후 레스토랑 평점 및 리뷰 수 업데이트 로직 추가 ▼▼▼
					restaurantDAO.updateRatingAndReviewCount(sqlSession, restaurantId);
					
					sqlSession.commit();
					return true;
				}
			} catch (Exception e) {
				e.printStackTrace();
				sqlSession.rollback();
			}
		}
		return false;
	}


	public boolean likeReview(int reviewId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			try {
				int result = reviewDAO.likeReview(sqlSession, reviewId);
				if (result > 0) {
					sqlSession.commit();
					return true;
				}
			} catch (Exception e) {
				e.printStackTrace();
				sqlSession.rollback();
			}
		}
		return false;
	}

	public boolean addOwnerReply(int reviewId, String replyContent) {
		// 1. SqlSession을 try-with-resources로 안전하게 가져옵니다.
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			try {
				// TODO: 현재 로그인한 유저가 해당 리뷰의 레스토랑 주인인지 확인하는 보안 로직을 추가하면 더 좋습니다.
				if (replyContent == null || replyContent.trim().isEmpty()) {
					throw new IllegalArgumentException("답글 내용은 비워둘 수 없습니다.");
				}

				Map<String, Object> params = new HashMap<>();
				params.put("reviewId", reviewId);
				params.put("replyContent", replyContent);

				// 2. DAO 메소드에 session을 전달하여 쿼리를 실행합니다.
				reviewDAO.addReply(session, params);

				// 3. 성공 시 commit합니다.
				session.commit();
				return true;

			} catch (Exception e) {
				e.printStackTrace();
				// 4. 실패 시 rollback합니다.
				session.rollback();
				return false;
			}
		}
	}
}