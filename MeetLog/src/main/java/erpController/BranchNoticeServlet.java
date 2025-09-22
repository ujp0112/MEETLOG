package erpController;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import erpDto.Notice;
import erpService.NoticeService;
import model.BusinessUser;

@WebServlet({"/branch/notice", "/branch/notice/*"})
public class BranchNoticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final NoticeService noticeService = new NoticeService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        long companyId = user.getCompanyId();
        String pathInfo = req.getPathInfo();

        if ("/view".equals(pathInfo)) {
            long noticeId = Long.parseLong(req.getParameter("id"));
            Notice notice = noticeService.getNoticeById(companyId, noticeId); // 조회수 증가 로직 포함
            req.setAttribute("notice", notice);
            req.getRequestDispatcher("/WEB-INF/branch/branch-notice-view.jsp").forward(req, resp);
            return;
        }

        int currentPage = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null) currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) { currentPage = 1; }
        int offset = (currentPage - 1) * PAGE_SIZE;

        List<Notice> notices = noticeService.listNotices(companyId, PAGE_SIZE, offset);
        int totalCount = noticeService.getNoticeCount(companyId);

        req.setAttribute("notices", notices);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("pageSize", PAGE_SIZE);

        req.getRequestDispatcher("/WEB-INF/branch/branch-notice-list.jsp").forward(req, resp);
    }
}