package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import model.Faq;
import model.User;
import service.FaqService;
import util.AdminSessionUtils;

@WebServlet("/admin/faq-management")
public class FaqManagementServlet extends HttpServlet {

    private final FaqService faqService = new FaqService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
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
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
                return;
            }

            String action = request.getParameter("action");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (action == null || action.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"요청 작업이 지정되지 않았습니다.\"}");
                return;
            }

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
        try {
            String category = request.getParameter("category");
            String question = request.getParameter("question");
            String answer = request.getParameter("answer");
            String displayOrderStr = request.getParameter("displayOrder");

            if (category == null || question == null || answer == null) {
                out.print("{\"success\": false, \"message\": \"필수 항목을 모두 입력해주세요.\"}");
                return;
            }

            int displayOrder = 0;
            if (displayOrderStr != null && !displayOrderStr.trim().isEmpty()) {
                try {
                    displayOrder = Integer.parseInt(displayOrderStr.trim());
                } catch (NumberFormatException e) {
                    out.print("{\"success\": false, \"message\": \"표시 순서는 숫자여야 합니다.\"}");
                    return;
                }
            }

            Faq faq = new Faq();
            faq.setCategory(category.trim());
            faq.setQuestion(question.trim());
            faq.setAnswer(answer.trim());
            faq.setDisplayOrder(displayOrder);
            faq.setActive(true);

            boolean success = faqService.createFaq(faq);
            if (success) {
                out.print("{\"success\": true, \"message\": \"FAQ가 성공적으로 등록되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"FAQ 등록에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"FAQ 등록 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleUpdateFaq(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
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

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 FAQ ID입니다.\"}");
                return;
            }

            int displayOrder = 0;
            if (displayOrderStr != null && !displayOrderStr.trim().isEmpty()) {
                try {
                    displayOrder = Integer.parseInt(displayOrderStr.trim());
                } catch (NumberFormatException e) {
                    out.print("{\"success\": false, \"message\": \"표시 순서는 숫자여야 합니다.\"}");
                    return;
                }
            }

            Faq faq = new Faq();
            faq.setId(id);
            faq.setCategory(category.trim());
            faq.setQuestion(question.trim());
            faq.setAnswer(answer.trim());
            faq.setDisplayOrder(displayOrder);
            faq.setActive(isActiveStr != null && Boolean.parseBoolean(isActiveStr));

            boolean success = faqService.updateFaq(faq);
            if (success) {
                out.print("{\"success\": true, \"message\": \"FAQ가 성공적으로 수정되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"FAQ 수정에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"FAQ 수정 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleDeleteFaq(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");

            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"FAQ ID가 필요합니다.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 FAQ ID입니다.\"}");
                return;
            }

            boolean success = faqService.deleteFaq(id);

            if (success) {
                out.print("{\"success\": true, \"message\": \"FAQ가 성공적으로 삭제되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"FAQ 삭제에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"FAQ 삭제 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");
            String isActiveStr = request.getParameter("isActive");

            if (idStr == null || idStr.trim().isEmpty() || isActiveStr == null || isActiveStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 FAQ ID입니다.\"}");
                return;
            }

            boolean isActive = Boolean.parseBoolean(isActiveStr.trim());

            boolean success = faqService.toggleFaqStatus(id, isActive);

            if (success) {
                String status = isActive ? "활성화" : "비활성화";
                out.print("{\"success\": true, \"message\": \"FAQ가 " + status + "되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"FAQ 상태 변경에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"FAQ 상태 변경 중 오류가 발생했습니다.\"}");
        }
    }
}
