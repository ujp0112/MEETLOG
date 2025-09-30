package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.Notice;
import service.NoticeService;

public class NoticeServlet extends HttpServlet {

    private final NoticeService noticeService = new NoticeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // DB에서 공지사항 조회
            List<Notice> notices = noticeService.getAllNotices();

            System.out.println("DEBUG: 조회된 공지사항 수: " + notices.size());

            request.setAttribute("notices", notices);

            request.getRequestDispatcher("/WEB-INF/views/notice.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "공지사항을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
