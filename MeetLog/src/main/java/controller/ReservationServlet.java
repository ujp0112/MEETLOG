package controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Reservation;
import model.Restaurant;
import model.User;
import service.ReservationService;
import service.RestaurantService;

// [아키텍처 오류 수정] 기존 JDBC 서블릿을 삭제하고 Service 계층을 사용하는 컨트롤러로 변경합니다.
//
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ReservationService reservationService = new ReservationService();
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/create".equals(pathInfo)) {
                // 예약 폼 페이지 요청 (restaurantId 쿼리 파라미터 필요)
                handleReservationCreateForm(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/detail/")) {
                // 예약 상세 페이지 요청 (예: /reservation/detail/1)
                handleReservationDetail(request, response, pathInfo);
            } else {
                 // 그 외 경로는 내 예약 목록으로 보냄
                 response.sendRedirect(request.getContextPath() + "/mypage/reservations");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 페이지 처리 중 오류.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        if ("/create".equals(pathInfo)) {
            // 예약 폼 제출
            handleReservationCreateSubmit(request, response);
        } else if ("/cancel".equals(pathInfo)) {
            // 예약 취소 요청 (my-reservations.jsp에서 호출)
            handleReservationCancel(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void handleReservationCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 예약 폼을 보여주기 전, 대상 식당 정보가 필요합니다.
        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant != null) {
                request.setAttribute("restaurant", restaurant);
                request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "식당 정보 없음");
            }
        } catch (NumberFormatException e) {
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 식당 ID");
        }
    }
    
    private void handleReservationDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        // (reservation-detail.jsp 페이지를 위한 로직)
        try {
            int reservationId = Integer.parseInt(pathInfo.substring("/detail/".length()));
            Reservation reservation = reservationService.getReservationById(reservationId);
            
            // TODO: 본인 예약인지 확인하는 로직 필요
            
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/WEB-INF/views/reservation-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 예약 ID");
        }
    }

    private void handleReservationCreateSubmit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int restaurantId = 0;
        try {
            restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            String restaurantName = request.getParameter("restaurantName");
            String reservationDate = request.getParameter("reservationDate"); // "YYYY-MM-DD"
            String reservationTimeStr = request.getParameter("reservationTime"); // "HH:MM"
            int partySize = Integer.parseInt(request.getParameter("partySize"));
            String contactPhone = request.getParameter("contactPhone");

            // 날짜와 시간을 LocalDateTime으로 결합
            LocalDateTime reservationDateTime = LocalDateTime.parse(reservationDate + "T" + reservationTimeStr);

            Reservation reservation = new Reservation(
                restaurantId, user.getId(), restaurantName, user.getNickname(), 
                reservationDateTime, partySize, contactPhone
            );
            
            if (reservationService.createReservation(reservation)) {
                // 예약 성공 시, 내 예약 목록 페이지로 이동
                response.sendRedirect(request.getContextPath() + "/mypage/reservations");
            } else {
                throw new Exception("예약 등록 실패 (DB insert 실패)");
            }

        } catch (DateTimeParseException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "잘못된 날짜 또는 시간 형식입니다.");
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId); // 폼 재전송을 위해 식당정보 로드
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 처리 중 오류가 발생했습니다.");
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId); // 폼 재전송을 위해 식당정보 로드
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
        }
    }
    
    private void handleReservationCancel(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        // my-reservations.jsp에서 호출하는 취소 로직
         HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "로그인이 필요합니다.");
            return;
        }
        
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            // TODO: 이 예약을 요청한 사용자가 실제 예약자인지 검증하는 로직 필요
            
            if (reservationService.cancelReservation(reservationId)) {
                 response.sendRedirect(request.getContextPath() + "/mypage/reservations");
            } else {
                 request.setAttribute("errorMessage", "예약 취소 실패.");
                 request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 취소 처리 중 오류.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}