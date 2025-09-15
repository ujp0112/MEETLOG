package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Column;
import model.Reservation;
import model.Review;
import model.User;
import service.ColumnService;
import service.ReservationService;
import service.ReviewService;
import service.UserService;

//@WebServlet({"/mypage/*"})
public class MypageServlet extends HttpServlet {
   private UserService userService = new UserService();
   private ReviewService reviewService = new ReviewService();
   private ColumnService columnService = new ColumnService();
   private ReservationService reservationService = new ReservationService();

   public MypageServlet() {
   }

   /**
    * 마이페이지 관련 GET 요청을 처리합니다. (경로별 분기)
    */
   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String pathInfo = request.getPathInfo();
      
      // pathInfo가 null이면 "/mypage"와 동일하게 메인 대시보드로 취급합니다.
      if (pathInfo == null || pathInfo.equals("/")) {
         this.handleMyPageMain(request, response);
      } else if (pathInfo.equals("/reviews")) {
         this.handleMyReviews(request, response);
      } else if (pathInfo.equals("/columns")) {
         this.handleMyColumns(request, response);
      } else if (pathInfo.equals("/reservations")) {
         this.handleMyReservations(request, response);
      } else if (pathInfo.equals("/settings")) {
         this.handleSettings(request, response);
      } else {
         response.sendError(HttpServletResponse.SC_NOT_FOUND, "페이지를 찾을 수 없습니다.");
      }
   }

   /**
    * 마이페이지 관련 POST 요청을 처리합니다. (설정 변경 등)
    */
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      
      // POST 요청은 어떤 동작(action)인지 파라미터로 구분합니다.
      String action = request.getParameter("action");
      
      // settings.jsp의 폼 제출
      if ("updateProfile".equals(action)) {
         this.handleUpdateProfile(request, response);
      } else if ("changePassword".equals(action)) {
         this.handleChangePassword(request, response);
      } else {
         response.sendError(HttpServletResponse.SC_BAD_REQUEST, "알 수 없는 요청입니다.");
      }
   }

   // --- Private Helper Methods (GET) ---

   /**
    * 마이페이지 메인 대시보드 (최근 리뷰/칼럼/예약 5개 요약)
    */
   private void handleMyPageMain(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         HttpSession session = request.getSession();
         Integer userId = (Integer)session.getAttribute("userId");
         if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         User user = this.userService.getUserById(userId);
         if (user == null) {
            // 세션은 있지만 DB에 유저가 없는 경우 (탈퇴 등)
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         // 최근 5개씩 가져오기
         List<Review> recentReviews = this.reviewService.getReviewsByUserId(userId);
         if (recentReviews.size() > 5) {
            recentReviews = recentReviews.subList(0, 5);
         }

         List<Column> recentColumns = this.columnService.getColumnsByUserId(userId);
         if (recentColumns.size() > 5) {
            recentColumns = recentColumns.subList(0, 5);
         }

         List<Reservation> recentReservations = this.reservationService.getReservationsByUserId(userId);
         if (recentReservations.size() > 5) {
            recentReservations = recentReservations.subList(0, 5);
         }

         request.setAttribute("user", user); // mypage.jsp에서 프로필 정보 표시용
         request.setAttribute("myReviews", recentReviews);
         request.setAttribute("myColumns", recentColumns);
         request.setAttribute("myReservations", recentReservations);
         request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
         
      } catch (Exception var9) {
         var9.printStackTrace();
         request.setAttribute("errorMessage", "마이페이지를 불러오는 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
      }
   }

   /**
    * 내 리뷰 전체 목록 페이지
    */
   private void handleMyReviews(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         HttpSession session = request.getSession();
         Integer userId = (Integer)session.getAttribute("userId");
         if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         List<Review> reviews = this.reviewService.getReviewsByUserId(userId); // 전체 목록
         request.setAttribute("myReviews", reviews); // jsp에서 사용할 이름 수정 (myReviews)
         request.getRequestDispatcher("/WEB-INF/views/my-reviews.jsp").forward(request, response);
      } catch (Exception var6) {
         var6.printStackTrace();
         request.setAttribute("errorMessage", "리뷰 목록을 불러오는 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
      }
   }

   /**
    * 내 칼럼 전체 목록 페이지
    */
   private void handleMyColumns(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         HttpSession session = request.getSession();
         Integer userId = (Integer)session.getAttribute("userId");
         if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         List<Column> columns = this.columnService.getColumnsByUserId(userId); // 전체 목록
         request.setAttribute("myColumns", columns); // jsp에서 사용할 이름 수정 (myColumns)
         request.getRequestDispatcher("/WEB-INF/views/my-columns.jsp").forward(request, response);
      } catch (Exception var6) {
         var6.printStackTrace();
         request.setAttribute("errorMessage", "칼럼 목록을 불러오는 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
      }
   }

   /**
    * 내 예약 전체 목록 페이지
    */
   private void handleMyReservations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         HttpSession session = request.getSession();
         Integer userId = (Integer)session.getAttribute("userId");
         if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         List<Reservation> reservations = this.reservationService.getReservationsByUserId(userId); // 전체 목록
         request.setAttribute("myReservations", reservations); // jsp에서 사용할 이름 수정 (myReservations)
         request.getRequestDispatcher("/WEB-INF/views/my-reservations.jsp").forward(request, response);
      } catch (Exception var6) {
         var6.printStackTrace();
         request.setAttribute("errorMessage", "예약 목록을 불러오는 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
      }
   }

   /**
    * 설정 페이지 (프로필 수정 폼)
    */
   private void handleSettings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         HttpSession session = request.getSession();
         Integer userId = (Integer)session.getAttribute("userId");
         if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         User user = this.userService.getUserById(userId);
         request.setAttribute("user", user); // settings.jsp가 폼을 채울 수 있도록 user 객체를 전달
         request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
      } catch (Exception var6) {
         var6.printStackTrace();
         request.setAttribute("errorMessage", "설정 페이지를 불러오는 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
      }
   }

   
   // --- Private Helper Methods (POST) ---

   /**
    * 프로필 수정 (닉네임 변경) 처리
    */
   private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // [치명적 버그 수정] 
      // 원인: settings.jsp 폼은 'nickname'만 보내는데, 서블릿은 'profileImage' 파라미터도 받으려 시도함.
      // 결과: profileImage가 null이 되어 DB의 기존 프로필 이미지를 NULL로 덮어쓰는 버그 발생.
      // 해결: DB에서 User 객체를 로드한 후, 폼에서 넘어온 'nickname'만 수정하도록 변경.
      
      try {
         HttpSession session = request.getSession();
         Integer userId = (Integer)session.getAttribute("userId");
         if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
         }

         // 1. DB에서 현재 사용자 정보를 다시 로드 (세션 객체를 직접 수정하지 않음)
         User user = this.userService.getUserById(userId);
         
         if (user != null) {
            String nickname = request.getParameter("nickname");
            
            // 2. 폼에서 넘어온 닉네임만 객체에 설정
            user.setNickname(nickname);
            // user.setProfileImage(request.getParameter("profileImage")); // <- 버그 원인 코드 (삭제)

            // 3. 닉네임만 수정된 User 객체를 DB에 업데이트
            boolean success = this.userService.updateUser(user);
            
            if (success) {
               // 4. [중요] DB 변경 성공 시, 세션 정보도 최신 User 객체로 갱신
               session.setAttribute("user", user); 
               response.sendRedirect(request.getContextPath() + "/mypage");
            } else {
               request.setAttribute("errorMessage", "프로필 수정 중 오류가 발생했습니다.");
               request.setAttribute("user", user); // 실패 시에도 입력값을 유지하기 위해 user 객체 전달
               request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
            }
         }
      } catch (Exception e) {
         e.printStackTrace();
         request.setAttribute("errorMessage", "프로필 수정 중 심각한 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
      }
   }

   /**
    * 비밀번호 변경 처리 (현재 기능 미구현 상태)
    */
   private void handleChangePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // [기능 누락] 원본 코드는 이 메서드가 아무 작업 없이 리다이렉트만 수행함.
      // TODO: settings.jsp에 현재/새 비밀번호 폼을 추가하고, UserService에 비밀번호 변경 로직을 구현해야 함.
      
      // 현재는 기능이 없으므로, 사용자에게 알림 메시지를 전달하고 설정 페이지로 다시 포워딩.
      request.setAttribute("infoMessage", "비밀번호 변경 기능은 현재 준비 중입니다.");
      this.handleSettings(request, response); // 리다이렉트 대신 포워딩으로 변경하여 메시지 전달
   }
}