package service.payment;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.math.RoundingMode;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import model.Reservation;
import model.User;
import util.AppConfig;

/**
 * 네이버페이 샌드박스/실서비스 연동 유틸리티.
 * <p>
 * JavaScript SDK 초기화와 서버사이드 결제 승인(Confirm) 요청을 모두 담당한다.
 */
public class NaverPayService {

    private static final String DEFAULT_MODE = "development"; // 샌드박스 기본값
    private static final String DEFAULT_RETURN_PATH = "/payment/naver/return";
    private static final String SANDBOX_API_BASE = "https://dev.apis.naver.com/naverpay-partner/naverpay/payments/v2";
    private static final String PRODUCTION_API_BASE = "https://apis.naver.com/naverpay-partner/naverpay/payments/v2";

    private final String clientId;
    private final String clientSecret;
    private final String mode;
    private final String merchantId;
    private final String confirmEndpointOverride;
    private final String chainId;
    private final Gson gson = new Gson();

    public NaverPayService() {
        this.clientId = AppConfig.getProperty("naverpay.clientId", "");
        this.clientSecret = AppConfig.getProperty("naverpay.clientSecret", "");
        this.mode = AppConfig.getProperty("naverpay.mode", DEFAULT_MODE);
        this.merchantId = AppConfig.getProperty("naverpay.merchantId", "");
        this.confirmEndpointOverride = AppConfig.getProperty("naverpay.confirmEndpoint");
        this.chainId = AppConfig.getProperty("naverpay.chainId", "");
    }

    public boolean isConfigured() {
        return clientId != null && !clientId.isBlank();
    }

    public String getClientId() {
        return clientId;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public String getMode() {
        return mode == null || mode.isBlank() ? DEFAULT_MODE : mode;
    }

    public String getMerchantId() {
        return merchantId;
    }

    public String getChainId() {
        return chainId;
    }

    /**
     * 네이버페이에서 요구하는 merchantPayKey 생성. 예약 ID 기반으로 생성한다.
     */
    public String generateMerchantPayKey(int reservationId) {
        return "RES-" + reservationId + "-" + System.currentTimeMillis();
    }

    /**
     * JavaScript SDK 호출에 필요한 파라미터 묶음을 생성한다.
     */
    public NaverPayJsConfig buildJsConfig(HttpServletRequest request,
                                          User user,
                                          Reservation reservation,
                                          BigDecimal depositAmount) {
        NaverPayJsConfig config = new NaverPayJsConfig();
        config.setClientId(getClientId());
        config.setMode(getMode());
        config.setMerchantUserKey("USER-" + user.getId());
        config.setMerchantPayKey(
                reservation.getPaymentOrderId() != null && !reservation.getPaymentOrderId().isBlank()
                        ? reservation.getPaymentOrderId()
                        : generateMerchantPayKey(reservation.getId())
        );
        config.setProductName(reservation.getRestaurantName() + " 예약금");
        config.setTotalPayAmount(depositAmount == null ? BigDecimal.ZERO : depositAmount);
        config.setTaxScopeAmount(config.getTotalPayAmount());
        config.setTaxExScopeAmount(BigDecimal.ZERO);
        config.setProductCount(1);
        config.setReturnUrl(resolveReturnUrl(request));
        config.setReservationId(reservation.getId());
        config.setMerchantId(getMerchantId());
        config.setChainId(getChainId());
        return config;
    }

    private String resolveReturnUrl(HttpServletRequest request) {
        String explicit = AppConfig.getProperty("naverpay.returnUrl");
        if (explicit != null && !explicit.isBlank()) {
            return explicit;
        }
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        StringBuilder sb = new StringBuilder();
        sb.append(scheme).append("://").append(serverName);
        if (!("http".equalsIgnoreCase(scheme) && serverPort == 80)
                && !("https".equalsIgnoreCase(scheme) && serverPort == 443)) {
            sb.append(":" + serverPort);
        }
        sb.append(contextPath).append(DEFAULT_RETURN_PATH);
        return sb.toString();
    }

    /**
     * 샌드박스 환경에서는 콜백의 resultCode를 신뢰하고, 필요 시 추후 실제 승인 API 호출로 치환한다.
     */
    /**
     * 네이버페이 결제 승인 API 호출. 샌드박스에서는 네이버가 제공하는 dev 엔드포인트를 사용한다.
     */
    public PaymentConfirmResult confirmPayment(String paymentId,
                                               String merchantPayKey,
                                               BigDecimal totalPayAmount,
                                               String merchantUserKey) {
        if (!isConfigured()) {
            return PaymentConfirmResult.failure("NOT_CONFIGURED", "네이버페이 설정이 완료되지 않았습니다.");
        }

        if (clientId == null || clientId.isBlank()) {
            return PaymentConfirmResult.failure("MISSING_CLIENT_ID", "clientId 설정이 필요합니다.");
        }

        if (clientSecret == null || clientSecret.isBlank()) {
            return PaymentConfirmResult.failure("MISSING_CLIENT_SECRET", "clientSecret 설정이 필요합니다.");
        }

        if (merchantId == null || merchantId.isBlank()) {
            return PaymentConfirmResult.failure("MISSING_MERCHANT_ID", "merchantId 설정이 필요합니다.");
        }

        if (paymentId == null || paymentId.isBlank()) {
            return PaymentConfirmResult.failure("INVALID_PAYMENT_ID", "paymentId가 필요합니다.");
        }

        if (merchantPayKey == null || merchantPayKey.isBlank()) {
            return PaymentConfirmResult.failure("INVALID_PAY_KEY", "merchantPayKey가 필요합니다.");
        }

        String endpoint = resolveConfirmEndpoint();

        Map<String, Object> payload = new HashMap<>();
        payload.put("paymentId", paymentId);
        payload.put("merchantPayKey", merchantPayKey);
        if (merchantUserKey != null && !merchantUserKey.isBlank()) {
            payload.put("merchantUserKey", merchantUserKey);
        }
        if (totalPayAmount != null && totalPayAmount.compareTo(BigDecimal.ZERO) >= 0) {
            payload.put("totalPayAmount", totalPayAmount.toPlainString());
        }

        String requestBody = gson.toJson(payload);

        java.net.HttpURLConnection connection = null;
        try {
            java.net.URL url = new java.net.URL(endpoint);
            connection = (java.net.HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(8000);
            connection.setReadTimeout(10000);
            connection.setDoOutput(true);
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            AuthorizationHeader auth = buildAuthorizationHeader(paymentId);
            connection.setRequestProperty("X-NaverPay-Authorization", auth.headerValue);
            connection.setRequestProperty("X-NaverPay-Timestamp", auth.timestamp);
            connection.setRequestProperty("X-NaverPay-MerchantId", merchantId);
            connection.setRequestProperty("X-NaverPay-Client-Id", clientId);

            try (OutputStream os = connection.getOutputStream()) {
                os.write(requestBody.getBytes(StandardCharsets.UTF_8));
            }

            int status = connection.getResponseCode();
            String responseBody = readBody(connection, status >= 200 && status < 300);

            if (status >= 200 && status < 300) {
                JsonObject json = gson.fromJson(responseBody, JsonObject.class);
                String code = json != null && json.has("code") ? json.get("code").getAsString() : null;
                String message = json != null && json.has("message") ? json.get("message").getAsString() : null;
                if (Objects.equals(code, "Success")) {
                    return PaymentConfirmResult.success(paymentId, code, message, responseBody);
                }
                return PaymentConfirmResult.failure(code != null ? code : "UNKNOWN_RESULT",
                        message != null ? message : "네이버페이 확인 응답이 성공으로 처리되지 않았습니다.")
                        .withRawResponse(responseBody);
            }

            return PaymentConfirmResult.failure("HTTP_" + status,
                    "네이버페이 확인 API 호출이 실패했습니다.").withRawResponse(responseBody);
        } catch (Exception ex) {
            return PaymentConfirmResult.failure("CONFIRM_EXCEPTION", ex.getMessage());
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private AuthorizationHeader buildAuthorizationHeader(String paymentId) throws Exception {
        String timestamp = String.valueOf(System.currentTimeMillis());
        String message = timestamp + merchantId + paymentId;
        String signature = hmacSha256(clientSecret, message);
        String headerValue = "NAVERPAY-HMAC-V1 " + clientId + ":" + signature + ":" + timestamp;
        return new AuthorizationHeader(headerValue, timestamp);
    }

    private String resolveConfirmEndpoint() {
        if (confirmEndpointOverride != null && !confirmEndpointOverride.isBlank()) {
            return confirmEndpointOverride.trim();
        }
        String base = "production".equalsIgnoreCase(getMode()) ? PRODUCTION_API_BASE : SANDBOX_API_BASE;
        if (!base.endsWith("/confirm")) {
            return base + "/confirm";
        }
        return base;
    }

    private String hmacSha256(String secretKey, String message) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        mac.init(secretKeySpec);
        byte[] rawHmac = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(rawHmac);
    }

    private String readBody(java.net.HttpURLConnection connection, boolean successStream) throws IOException {
        try (BufferedReader br = new BufferedReader(new InputStreamReader(
                successStream ? connection.getInputStream() : connection.getErrorStream(), StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        }
    }

    private static class AuthorizationHeader {
        private final String headerValue;
        private final String timestamp;

        AuthorizationHeader(String headerValue, String timestamp) {
            this.headerValue = headerValue;
            this.timestamp = timestamp;
        }
    }

    public static class NaverPayJsConfig {
        private String clientId;
        private String mode;
        private String merchantUserKey;
        private String merchantPayKey;
        private String productName;
        private BigDecimal totalPayAmount;
        private BigDecimal taxScopeAmount;
        private BigDecimal taxExScopeAmount;
        private int productCount;
        private String returnUrl;
        private int reservationId;
        private String merchantId;
        private String chainId;

        public String getClientId() {
            return clientId;
        }

        public void setClientId(String clientId) {
            this.clientId = clientId;
        }

        public String getMode() {
            return mode;
        }

        public void setMode(String mode) {
            this.mode = mode;
        }

        public String getMerchantUserKey() {
            return merchantUserKey;
        }

        public void setMerchantUserKey(String merchantUserKey) {
            this.merchantUserKey = merchantUserKey;
        }

        public String getMerchantPayKey() {
            return merchantPayKey;
        }

        public void setMerchantPayKey(String merchantPayKey) {
            this.merchantPayKey = merchantPayKey;
        }

        public String getProductName() {
            return productName;
        }

        public void setProductName(String productName) {
            this.productName = productName;
        }

        public BigDecimal getTotalPayAmount() {
            return totalPayAmount;
        }

        public void setTotalPayAmount(BigDecimal totalPayAmount) {
            this.totalPayAmount = totalPayAmount;
        }

        public BigDecimal getTaxScopeAmount() {
            return taxScopeAmount;
        }

        public void setTaxScopeAmount(BigDecimal taxScopeAmount) {
            this.taxScopeAmount = taxScopeAmount;
        }

        public BigDecimal getTaxExScopeAmount() {
            return taxExScopeAmount;
        }

        public void setTaxExScopeAmount(BigDecimal taxExScopeAmount) {
            this.taxExScopeAmount = taxExScopeAmount;
        }

        public int getProductCount() {
            return productCount;
        }

        public void setProductCount(int productCount) {
            this.productCount = productCount;
        }

        public String getReturnUrl() {
            return returnUrl;
        }

        public void setReturnUrl(String returnUrl) {
            this.returnUrl = returnUrl;
        }

        public int getReservationId() {
            return reservationId;
        }

        public void setReservationId(int reservationId) {
            this.reservationId = reservationId;
        }

        public String getMerchantId() {
            return merchantId;
        }

        public void setMerchantId(String merchantId) {
            this.merchantId = merchantId;
        }

        public String getChainId() {
            return chainId;
        }

        public void setChainId(String chainId) {
            this.chainId = chainId;
        }

        public String getTotalPayAmountAsString() {
            return toIntegerString(totalPayAmount);
        }

        public String getTaxScopeAmountAsString() {
            return toIntegerString(taxScopeAmount);
        }

        public String getTaxExScopeAmountAsString() {
            return toIntegerString(taxExScopeAmount);
        }
    }

    /**
     * 결제 성공 시점에 예약을 확정 처리하기 위해 공통 로직에서 사용.
     */
    public void markPaymentSuccess(Reservation reservation, String paymentOrderId) {
        reservation.setPaymentStatus("PAID");
        reservation.setPaymentOrderId(paymentOrderId);
        reservation.setPaymentApprovedAt(LocalDateTime.now());
        reservation.setStatus("CONFIRMED");
        reservation.setPaymentProvider("NAVERPAY");
    }

    public void markPaymentFailure(Reservation reservation, String paymentOrderId) {
        reservation.setPaymentStatus("FAILED");
        reservation.setPaymentOrderId(paymentOrderId);
        reservation.setPaymentProvider("NAVERPAY");
    }

    public static class PaymentConfirmResult {
        private final boolean success;
        private final String resultCode;
        private final String message;
        private final String paymentId;
        private String rawResponse;

        private PaymentConfirmResult(boolean success, String paymentId, String resultCode, String message) {
            this.success = success;
            this.paymentId = paymentId;
            this.resultCode = resultCode;
            this.message = message;
        }

        public static PaymentConfirmResult success(String paymentId, String resultCode, String message, String rawResponse) {
            PaymentConfirmResult result = new PaymentConfirmResult(true, paymentId, resultCode, message);
            result.rawResponse = rawResponse;
            return result;
        }

        public static PaymentConfirmResult failure(String resultCode, String message) {
            return new PaymentConfirmResult(false, null, resultCode, message);
        }

        public PaymentConfirmResult withRawResponse(String raw) {
            this.rawResponse = raw;
            return this;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getResultCode() {
            return resultCode;
        }

        public String getMessage() {
            return message;
        }

        public String getPaymentId() {
            return paymentId;
        }

        public String getRawResponse() {
            return rawResponse;
        }
    }

    private static String toIntegerString(BigDecimal value) {
        if (value == null) {
            return "0";
        }
        BigDecimal normalized = value.setScale(0, RoundingMode.DOWN);
        return normalized.stripTrailingZeros().toPlainString();
    }
}
