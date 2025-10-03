package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import util.AdminSessionUtils;

import model.Inquiry;
import service.InquiryService;

public class InquiryManagementServlet extends HttpServlet {

    private final InquiryService inquiryService = new InquiryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            String action = request.getParameter("action");

            // 상세보기 API
            if ("detail".equals(action)) {
                handleGetInquiryDetail(request, response);
                return;
            }

            // DB에서 모든 문의 조회
            List<Inquiry> inquiries = inquiryService.getAllInquiries();
            int totalInquiries = inquiryService.getTotalInquiryCount();
            int pendingCount = inquiryService.getInquiryCountByStatus("PENDING");
            int resolvedCount = inquiryService.getInquiryCountByStatus("RESOLVED");

            System.out.println("DEBUG: 관리자 문의 관리 - 조회된 문의 수: " + inquiries.size());

            request.setAttribute("inquiries", inquiries);
            request.setAttribute("totalInquiries", totalInquiries);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("resolvedCount", resolvedCount);

            request.getRequestDispatcher("/WEB-INF/views/admin-inquiry-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "문의 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    private void handleGetInquiryDetail(HttpServletRequest request, HttpServletResponse response)
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

            int id = Integer.parseInt(idStr);
            Inquiry inquiry = inquiryService.getInquiryById(id);

            if (inquiry == null) {
                out.print("{\"success\": false, \"message\": \"문의를 찾을 수 없습니다.\"}");
                return;
            }

            // JSON 응답 생성
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"inquiryId\": ").append(inquiry.getInquiryId()).append(",");
            json.append("\"userName\": \"").append(escapeJson(inquiry.getUserName())).append("\",");
            json.append("\"subject\": \"").append(escapeJson(inquiry.getSubject())).append("\",");
            json.append("\"content\": \"").append(escapeJson(inquiry.getContent())).append("\",");
            json.append("\"status\": \"").append(inquiry.getStatus()).append("\",");
            if (inquiry.getReply() != null) {
                json.append("\"reply\": \"").append(escapeJson(inquiry.getReply())).append("\",");
            } else {
                json.append("\"reply\": null,");
            }
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            json.append("\"createdAt\": \"").append(sdf.format(inquiry.getCreatedAt())).append("\"");
            json.append("}");

            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"문의 조회 중 오류가 발생했습니다.\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.getAdminUser(request) == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            String action = request.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                request.setAttribute("errorMessage", "요청 작업이 지정되지 않았습니다.");
                doGet(request, response);
                return;
            }

            boolean success = false;
            String message = "";

            switch (action) {
                case "reply":
                    success = handleReplyInquiryForm(request);
                    message = success ? "답변이 성공적으로 등록되었습니다." : "답변 등록에 실패했습니다.";
                    break;
                case "updateStatus":
                    success = handleUpdateStatusForm(request);
                    message = success ? "상태가 성공적으로 변경되었습니다." : "상태 변경에 실패했습니다.";
                    break;
                case "delete":
                    success = handleDeleteInquiryForm(request);
                    message = success ? "문의가 성공적으로 삭제되었습니다." : "문의 삭제에 실패했습니다.";
                    break;
                default:
                    message = "잘못된 요청입니다.";
            }

            if (success) {
                request.setAttribute("successMessage", message);
            } else {
                request.setAttribute("errorMessage", message);
            }

            // 목록 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/admin/inquiry-management");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "서버 오류가 발생했습니다.");
            doGet(request, response);
        }
    }

    private boolean handleReplyInquiryForm(HttpServletRequest request) {
        try {
            String idStr = request.getParameter("inquiryId");
            String reply = request.getParameter("reply");

            if (idStr == null || reply == null || reply.trim().isEmpty()) {
                return false;
            }

            int id = Integer.parseInt(idStr.trim());
            return inquiryService.replyToInquiry(id, reply.trim(), "RESOLVED");
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean handleUpdateStatusForm(HttpServletRequest request) {
        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");

            if (idStr == null || status == null) {
                return false;
            }

            int id = Integer.parseInt(idStr.trim());
            return inquiryService.updateInquiryStatus(id, status.trim());
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean handleDeleteInquiryForm(HttpServletRequest request) {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                return false;
            }

            int id = Integer.parseInt(idStr.trim());
            return inquiryService.deleteInquiry(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
