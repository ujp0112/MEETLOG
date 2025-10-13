package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.BusinessUser;
import service.UserService;

public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final UserService userService = new UserService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");
	    String email = request.getParameter("email");
	    String password = request.getParameter("password");
	    String userType = request.getParameter("userType");
	    String redirectUrl = request.getParameter("redirectUrl");
	    
	    try {
	        User user = userService.authenticateUser(email, password, userType);
	        
	        if (user != null) {
	            // ============== 인증 성공 ==============
	            HttpSession session = request.getSession();
	            session.setAttribute("user", user);
	            session.setMaxInactiveInterval(30 * 60);

	            // ▼▼▼ [수정] 기업 회원 로그인 시 HQ/Branch 구분 로직 추가 ▼▼▼
	            if ("BUSINESS".equals(user.getUserType())) {
	                BusinessUser businessUser = userService.getBusinessUserByUserId(user.getId());
	                
	                // 승인 상태 확인 (기존 로직 유지)
	                if (businessUser != null && "PENDING".equals(businessUser.getStatus())) {
	                    request.setAttribute("errorMessage", "가입 승인 대기 중인 계정입니다. 본사의 승인 후 로그인해주세요.");
	                    request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
	                    return;
	                }
	                
	                if (businessUser != null) {
	                    session.setAttribute("businessUser", businessUser);
	                    System.out.println("BusinessUser 세션 저장 완료: " + businessUser.getRole());
	                } else {
	                    System.out.println("BusinessUser 정보를 찾을 수 없음: userId=" + user.getId());
	                    // 비즈니스 회원이지만 business_users 정보가 없는 예외적인 경우
	                    request.setAttribute("errorMessage", "기업 회원 정보를 찾을 수 없습니다. 관리자에게 문의하세요.");
	                    request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
	                    return;
	                }
	            }

	            // ▼▼▼ [수정] 리다이렉션 URL 결정 로직 수정 ▼▼▼
	            // 1. 세션에서 필터가 저장한 리다이렉션 URL을 먼저 확인합니다.
	            String targetUrl = (String) session.getAttribute("redirectUrl");
	            System.out.println("targetUrl: " + targetUrl);
	            // 2. 사용 후에는 세션에서 즉시 제거합니다.
	            if (targetUrl != null) {
	                session.removeAttribute("redirectUrl");
	            }

	            // 3. 세션에 URL이 없으면, 기존 로직(파라미터 또는 기본값)을 따릅니다.
	            if (targetUrl == null || targetUrl.trim().isEmpty()) {
	                targetUrl = redirectUrl; // form에서 전달된 파라미터
	                switch (user.getUserType()) {
	                    case "BUSINESS":
	                        // 세션에서 businessUser 정보를 다시 가져와 역할(role)에 따라 분기
	                        BusinessUser bizUser = (BusinessUser) session.getAttribute("businessUser");
	                        if (bizUser != null && "HQ".equalsIgnoreCase(bizUser.getRole())) {
	                            // 본사(HQ) 사용자는 관리 페이지로 이동
	                            targetUrl = request.getContextPath() + "/business/restaurants"; // 예시 URL
	                        } else {
	                            // 지점(Branch) 사용자는 기존 페이지로 이동
	                            targetUrl = request.getContextPath() + "/business/restaurants";
	                        }
	                        break;
	                    default: // PERSONAL
	                        targetUrl = request.getContextPath() + "/main";
	                        break;
	                }
	            }
	            response.sendRedirect(targetUrl);
	            
	        } else {
	            // ============== 인증 실패 ==============
	            request.setAttribute("errorMessage", "이메일 또는 비밀번호가 올바르지 않습니다.");
	            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다.");
	        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
	    }
	}
}