package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import model.User;
import model.WithdrawalRequest;
import service.WithdrawalService;

/**
 * 출금 신청 요청을 처리하는 서블릿
 * - POST /business/withdrawal/create : 새로운 출금 신청 생성
 */
@WebServlet("/business/withdrawal/create")
public class WithdrawalRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WithdrawalService withdrawalService = new WithdrawalService();
    private final Gson gson = new GsonBuilder().create();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 세션에서 사용자 정보 확인
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"BUSINESS".equals(user.getUserType())) {
                out.print("{\"success\": false, \"message\": \"사업자 회원만 사용 가능합니다.\"}");
                return;
            }

            // 요청 파라미터 파싱
            String requestAmountStr = request.getParameter("requestAmount");
            String bankName = request.getParameter("bankName");
            String accountNumber = request.getParameter("accountNumber");
            String accountHolder = request.getParameter("accountHolder");

            // 입력 검증
            if (requestAmountStr == null || requestAmountStr.isEmpty() ||
                bankName == null || bankName.isEmpty() ||
                accountNumber == null || accountNumber.isEmpty() ||
                accountHolder == null || accountHolder.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"모든 항목을 입력해주세요.\"}");
                return;
            }

            BigDecimal requestAmount;
            try {
                requestAmount = new BigDecimal(requestAmountStr);
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 금액 형식입니다.\"}");
                return;
            }

            if (requestAmount.compareTo(BigDecimal.ZERO) <= 0) {
                out.print("{\"success\": false, \"message\": \"출금 금액은 0보다 커야 합니다.\"}");
                return;
            }

            // 출금 가능 금액 확인
            BigDecimal availableAmount = withdrawalService.calculateAvailableAmount(user.getId());
            if (requestAmount.compareTo(availableAmount) > 0) {
                out.print(String.format("{\"success\": false, \"message\": \"출금 가능 금액을 초과했습니다. (가능: %s원)\"}",
                                      availableAmount.toString()));
                return;
            }

            // WithdrawalRequest 객체 생성
            WithdrawalRequest withdrawalRequest = new WithdrawalRequest();
            withdrawalRequest.setOwnerId(user.getId());
            withdrawalRequest.setRequestAmount(requestAmount);
            withdrawalRequest.setBankName(bankName);
            withdrawalRequest.setAccountNumber(accountNumber);
            withdrawalRequest.setAccountHolder(accountHolder);

            // 출금 신청 생성
            boolean success = withdrawalService.createWithdrawalRequest(withdrawalRequest);

            if (success) {
                out.print("{\"success\": true, \"message\": \"출금 신청이 완료되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"출금 신청 처리 중 오류가 발생했습니다.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }
}
