package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Restaurant;
import model.Review;
import model.User;
import service.RestaurantService;

@WebServlet("/business/dashboard")
public class BusinessDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String restaurantIdParam = request.getParameter("id");
            if (restaurantIdParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "가게 ID가 필요합니다.");
                return;
            }
            int restaurantId = Integer.parseInt(restaurantIdParam);

            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

            if (restaurant == null || restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
                return;
            }

			// --- 대시보드에 필요한 데이터 구성 ---

			// TODO: 아래 데이터는 나중에 실제 ReservationService, ReviewService를 구현하여 DB에서 가져와야 합니다.
			int totalReservations = 45; // 예시 데이터
			int todayReservations = 8; // 예시 데이터
			double averageRating = restaurant.getRating(); // 가게 평점은 실제 데이터 사용
			int monthlyRevenue = 2500000; // 예시 데이터
			List<Reservation> recentReservations = createMockReservations(); // 예시 데이터
			List<Review> recentReviews = new ArrayList<>(); // 예시 데이터

			// JSP로 데이터 전달
			request.setAttribute("restaurant", restaurant); // 실제 가게 정보
			request.setAttribute("totalReservations", totalReservations);
			request.setAttribute("todayReservations", todayReservations);
			request.setAttribute("averageRating", averageRating);
			request.setAttribute("monthlyRevenue", monthlyRevenue);
			request.setAttribute("recentReservations", recentReservations);
			request.setAttribute("recentReviews", recentReviews);

			// 경로 수정 없이 원래 파일로 포워딩
			request.getRequestDispatcher("/WEB-INF/views/business-dashboard.jsp").forward(request, response);

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 가게 ID 형식입니다.");
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "대시보드를 불러오는 중 오류가 발생했습니다.");
			request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
		}
	}

	// 임시로 예약 목 데이터를 생성하는 메소드
	private List<Reservation> createMockReservations() {
		List<Reservation> reservations = new ArrayList<>();
		reservations.add(new Reservation("김고객", "2025-09-15", "19:00", 4, "확정"));
		reservations.add(new Reservation("이고객", "2025-09-15", "20:30", 2, "대기"));
		return reservations;
	}

	// JSP에서 사용할 임시 예약 데이터 클래스
	public class Reservation {
		private String customerName;
		private String reservationDate;
		private String reservationTime;
		private int partySize;
		private String status;

		public Reservation(String cn, String rd, String rt, int ps, String st) {
			this.customerName = cn;
			this.reservationDate = rd;
			this.reservationTime = rt;
			this.partySize = ps;
			this.status = st;
		}

		// Getters
		public String getCustomerName() {
			return customerName;
		}

		public String getReservationDate() {
			return reservationDate;
		}

		public String getReservationTime() {
			return reservationTime;
		}

		public int getPartySize() {
			return partySize;
		}

		public String getStatus() {
			return status;
		}
	}
}