package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import model.Faq;
import service.FaqService;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/admin/faq-management")
public class FaqManagementServlet extends HttpServlet {

    private final FaqService faqService = new FaqService();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");

            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // 실제 DB에서 모든 FAQ 조회 (관리자용)
            List<Faq> faqs = faqService.getAllFaqs();
            List<String> categories = faqService.getDistinctCategories();

            // 통계 정보
            int totalFaqs = faqService.getTotalFaqCount();
            int activeFaqs = faqService.getActiveFaqCount();

            System.out.println("DEBUG: 관리자 FAQ 관리 - 조회된 FAQ 수: " + faqs.size());
            System.out.println("DEBUG: 전체 FAQ: " + totalFaqs + ", 활성 FAQ: " + activeFaqs);

            request.setAttribute("faqs", faqs);
            request.setAttribute("categories", categories);
            request.setAttribute("totalFaqs", totalFaqs);
            request.setAttribute("activeFaqs", activeFaqs);

            request.getRequestDispatcher("/WEB-INF/views/admin-faq-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "FAQ 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");

            if (adminId == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "관리자 권한이 필요합니다.");
                return;
            }

            String action = request.getParameter("action");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            switch (action) {
                case "create":
                    handleCreateFaq(request, out);
                    break;
                case "update":
                    handleUpdateFaq(request, out);
                    break;
                case "delete":
                    handleDeleteFaq(request, out);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, out);
                    break;
                default:
                    out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleCreateFaq(HttpServletRequest request, PrintWriter out) throws IOException {
        String category = request.getParameter("category");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");
        String displayOrderStr = request.getParameter("displayOrder");

        if (category == null || question == null || answer == null) {
            out.print("{\"success\": false, \"message\": \"필수 항목을 모두 입력해주세요.\"}");
            return;
        }

        Faq faq = new Faq();
        faq.setCategory(category.trim());
        faq.setQuestion(question.trim());
        faq.setAnswer(answer.trim());
        faq.setDisplayOrder(displayOrderStr != null ? Integer.parseInt(displayOrderStr) : 0);
        faq.setActive(true);

        boolean success = faqService.createFaq(faq);
        if (success) {
            out.print("{\"success\": true, \"message\": \"FAQ가 성공적으로 등록되었습니다.\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"FAQ 등록에 실패했습니다.\"}");
        }
    }

    private void handleUpdateFaq(HttpServletRequest request, PrintWriter out) throws IOException {
        String idStr = request.getParameter("id");
        String category = request.getParameter("category");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");
        String displayOrderStr = request.getParameter("displayOrder");
        String isActiveStr = request.getParameter("isActive");

        if (idStr == null || category == null || question == null || answer == null) {
            out.print("{\"success\": false, \"message\": \"필수 항목을 모두 입력해주세요.\"}");
            return;
        }

        Faq faq = new Faq();
        faq.setId(Integer.parseInt(idStr));
        faq.setCategory(category.trim());
        faq.setQuestion(question.trim());
        faq.setAnswer(answer.trim());
        faq.setDisplayOrder(displayOrderStr != null ? Integer.parseInt(displayOrderStr) : 0);
        faq.setActive(isActiveStr != null && Boolean.parseBoolean(isActiveStr));

        boolean success = faqService.updateFaq(faq);
        if (success) {
            out.print("{\"success\": true, \"message\": \"FAQ가 성공적으로 수정되었습니다.\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"FAQ 수정에 실패했습니다.\"}");
        }
    }

    private void handleDeleteFaq(HttpServletRequest request, PrintWriter out) throws IOException {
        String idStr = request.getParameter("id");

        if (idStr == null) {
            out.print("{\"success\": false, \"message\": \"FAQ ID가 필요합니다.\"}");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean success = faqService.deleteFaq(id);

        if (success) {
            out.print("{\"success\": true, \"message\": \"FAQ가 성공적으로 삭제되었습니다.\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"FAQ 삭제에 실패했습니다.\"}");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, PrintWriter out) throws IOException {
        String idStr = request.getParameter("id");
        String isActiveStr = request.getParameter("isActive");

        if (idStr == null || isActiveStr == null) {
            out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean isActive = Boolean.parseBoolean(isActiveStr);

        boolean success = faqService.toggleFaqStatus(id, isActive);

        if (success) {
            String status = isActive ? "활성화" : "비활성화";
            out.print("{\"success\": true, \"message\": \"FAQ가 " + status + "되었습니다.\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"FAQ 상태 변경에 실패했습니다.\"}");
        }
    }
}
