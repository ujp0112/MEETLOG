package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.Faq;
import service.FaqService;

@WebServlet("/faq")
public class FaqServlet extends HttpServlet {

    private final FaqService faqService = new FaqService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 카테고리 필터링 파라미터 처리
            String category = request.getParameter("category");

            List<Faq> faqs;
            List<String> categories;

            if (category != null && !category.trim().isEmpty()) {
                // 특정 카테고리 FAQ 조회
                faqs = faqService.getFaqsByCategory(category);
                request.setAttribute("selectedCategory", category);
            } else {
                // 모든 활성화된 FAQ 조회
                faqs = faqService.getActiveFaqsOrdered();
            }

            // 카테고리 목록 조회
            categories = faqService.getDistinctCategories();

            System.out.println("DEBUG: 조회된 FAQ 수: " + faqs.size());
            System.out.println("DEBUG: 카테고리 수: " + categories.size());

            request.setAttribute("faqs", faqs);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/WEB-INF/views/faq.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "FAQ를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
