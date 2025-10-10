package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import model.Inquiry;
import model.User;
import service.InquiryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class MyInquiryServlet extends HttpServlet {
    private final InquiryService inquiryService = new InquiryService();
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirectURL=/my-inquiries");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("detail".equals(action)) {
                handleGetInquiryDetail(request, response, user.getId());
            } else {
                showMyInquiriesList(request, response, user.getId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "문의 내역을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    private void showMyInquiriesList(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {
        List<Inquiry> inquiries = inquiryService.getInquiriesByUserId(userId);
        request.setAttribute("inquiries", inquiries);
        request.getRequestDispatcher("/WEB-INF/views/my-inquiries.jsp").forward(request, response);
    }

    private void handleGetInquiryDetail(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                out.print("{\"success\": false, \"message\": \"문의 ID가 필요합니다.\"}");
                return;
            }

            int inquiryId = Integer.parseInt(idStr);
            Inquiry inquiry = inquiryService.getInquiryById(inquiryId);

            if (inquiry == null) {
                out.print("{\"success\": false, \"message\": \"문의를 찾을 수 없습니다.\"}");
                return;
            }

            // 본인 문의가 맞는지 확인
            if (inquiry.getUserId() != userId) {
                out.print("{\"success\": false, \"message\": \"권한이 없습니다.\"}");
                return;
            }

            out.print(gson.toJson(inquiry));

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"문의 조회 중 오류가 발생했습니다.\"}");
        }
    }
}