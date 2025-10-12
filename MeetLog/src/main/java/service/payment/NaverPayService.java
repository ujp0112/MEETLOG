package service.payment;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import model.Reservation;
import model.User;
import service.ReservationService;
import util.AppConfig;

public class NaverPayService implements PaymentGatewayService {

	private static final String DEFAULT_MODE = "development";
	private static final String DEFAULT_RETURN_PATH = "/payment/naver/return";
	private static final String SANDBOX_API_BASE = "https://dev.apis.naver.com/naverpay-partner/naverpay/payments/v2";
	private static final String PRODUCTION_API_BASE = "https://apis.naver.com/naverpay-partner/naverpay/payments/v2";

	private final String clientId;
	private final String clientSecret;
	private final String mode;
	private final String merchantId;
	private final String confirmEndpointOverride;
	private final String chainId;
	private final boolean skipConfirm;
	private final boolean fallbackOnFailure;
	private final boolean autoApproveOnReturn;
	private final Gson gson = new Gson();

	public NaverPayService() {
		this.clientId = AppConfig.getProperty("naverpay.clientId", "");
		this.clientSecret = AppConfig.getProperty("naverpay.clientSecret", "");
		this.mode = AppConfig.getProperty("naverpay.mode", DEFAULT_MODE);
		this.merchantId = AppConfig.getProperty("naverpay.merchantId", "");
		this.confirmEndpointOverride = AppConfig.getProperty("naverpay.confirmEndpoint");
		this.chainId = AppConfig.getProperty("naverpay.chainId", "");
		this.skipConfirm = Boolean.parseBoolean(AppConfig.getProperty("naverpay.skipConfirm", "false"));
		this.fallbackOnFailure = Boolean.parseBoolean(AppConfig.getProperty("naverpay.fallbackOnFailure", "false"));
		this.autoApproveOnReturn = Boolean.parseBoolean(AppConfig.getProperty("naverpay.autoApproveOnReturn", "false"));
	}

	@Override
	public String getProviderName() {
		return "NAVERPAY";
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

	public boolean isSkipConfirm() {
		return skipConfirm;
	}

	public boolean isFallbackOnFailure() {
		return fallbackOnFailure;
	}

	public boolean isAutoApproveOnReturn() {
		return autoApproveOnReturn;
	}

	@Override
	public Object buildPaymentRequest(HttpServletRequest request, User user, Reservation reservation) {
		BigDecimal depositAmount = reservation.getDepositAmount();

		NaverPayJsConfig config = new NaverPayJsConfig();
		config.setClientId(getClientId());
		config.setMode(getMode());
		config.setMerchantUserKey("USER-" + user.getId());
		config.setMerchantPayKey(reservation.getPaymentOrderId() != null && !reservation.getPaymentOrderId().isBlank()
				? reservation.getPaymentOrderId()
				: generateMerchantPayKey(reservation.getId()));
		config.setProductName(reservation.getRestaurantName() + " 예약금");
		config.setTotalPayAmount(depositAmount == null ? BigDecimal.ZERO : depositAmount);
		config.setTaxScopeAmount(config.getTotalPayAmount());
		config.setTaxExScopeAmount(BigDecimal.ZERO);
		config.setProductCount(1);
		String returnUrl = skipConfirm ? resolveAbsoluteUrl(request, "/payment-result") : resolveReturnUrl(request);
		config.setReturnUrl(appendQueryParam(returnUrl, "reservationId", String.valueOf(reservation.getId())));
		config.setReservationId(reservation.getId());
		config.setMerchantId(getMerchantId());
		config.setChainId(getChainId());
		config.setSkipConfirm(skipConfirm);
		return config;
	}

	@Override
	public PaymentConfirmResult confirmPayment(HttpServletRequest request) {
		String paymentId = request.getParameter("paymentId");
		String merchantPayKey = request.getParameter("merchantPayKey");
		String resultCode = request.getParameter("resultCode");
		String resultMessage = request.getParameter("resultMessage");
		String errorMessage = request.getParameter("errorMessage");

		Reservation reservation = findReservationFromRequest(request);
		if (reservation == null) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "RESERVATION_NOT_FOUND",
					"예약 정보를 찾을 수 없습니다.");
		}

		if (!"Success".equalsIgnoreCase(resultCode)) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, resultCode,
					resultMessage != null ? resultMessage : errorMessage);
		}

		BigDecimal expectedAmount = reservation.getDepositAmount();
		String merchantUserKey = "USER-" + reservation.getUserId();

		return executeConfirmApi(paymentId, merchantPayKey, expectedAmount, merchantUserKey, resultCode);
	}

	private PaymentConfirmResult executeConfirmApi(String paymentId, String merchantPayKey, BigDecimal totalPayAmount,
			String merchantUserKey, String resultCodeFromReturn) {
		if (!isConfigured()) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "NOT_CONFIGURED",
					"네이버페이 설정이 완료되지 않았습니다.");
		}
		if (clientId == null || clientId.isBlank()) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "MISSING_CLIENT_ID",
					"clientId 설정이 필요합니다.");
		}
		if (clientSecret == null || clientSecret.isBlank()) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "MISSING_CLIENT_SECRET",
					"clientSecret 설정이 필요합니다.");
		}
		if (merchantId == null || merchantId.isBlank()) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "MISSING_MERCHANT_ID",
					"merchantId 설정이 필요합니다.");
		}

		if (skipConfirm) {
			if (paymentId == null || paymentId.isBlank()) {
				paymentId = "DEV-MOCK-" + System.currentTimeMillis();
			}
			return new PaymentConfirmResult(true, paymentId, merchantPayKey, "Success",
					"Development mode auto-confirm");
		}

		if (isAutoApproveOnReturn() && "Success".equalsIgnoreCase(resultCodeFromReturn)) {
			return new PaymentConfirmResult(true, paymentId, merchantPayKey, "Success",
					"Auto-approved on return (dev mode)");
		}

		if (paymentId == null || paymentId.isBlank()) {
			return new PaymentConfirmResult(false, null, merchantPayKey, "INVALID_PAYMENT_ID", "paymentId가 필요합니다.");
		}

		if (merchantPayKey == null || merchantPayKey.isBlank()) {
			return new PaymentConfirmResult(false, paymentId, null, "INVALID_PAY_KEY", "merchantPayKey가 필요합니다.");
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
					return new PaymentConfirmResult(true, paymentId, merchantPayKey, code, message)
							.withRawResponse(responseBody);
				}
				return new PaymentConfirmResult(false, paymentId, merchantPayKey,
						code != null ? code : "UNKNOWN_RESULT",
						message != null ? message : "네이버페이 확인 응답이 성공으로 처리되지 않았습니다.").withRawResponse(responseBody);
			}

			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "HTTP_" + status,
					"네이버페이 확인 API 호출이 실패했습니다.").withRawResponse(responseBody);
		} catch (Exception ex) {
			return new PaymentConfirmResult(false, paymentId, merchantPayKey, "CONFIRM_EXCEPTION", ex.getMessage());
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
	}

	private Reservation findReservationFromRequest(HttpServletRequest request) {
		String reservationIdParam = request.getParameter("reservationId");
		String merchantPayKey = request.getParameter("merchantPayKey");
		int reservationId = -1;

		if (reservationIdParam != null && !reservationIdParam.isBlank()) {
			try {
				reservationId = Integer.parseInt(reservationIdParam);
			} catch (NumberFormatException e) {
				// 무시
			}
		} else if (merchantPayKey != null && !merchantPayKey.isBlank()) {
			if (merchantPayKey.startsWith("RES-")) {
				try {
					String[] parts = merchantPayKey.split("-");
					if (parts.length >= 2) {
						reservationId = Integer.parseInt(parts[1]);
					}
				} catch (NumberFormatException e) {
					// 무시
				}
			}
		}

		ReservationService reservationService = new ReservationService(); // 직접 생성
		if (reservationId > 0) {
			return reservationService.getReservationById(reservationId);
		}
		if (merchantPayKey != null && !merchantPayKey.isBlank()) {
			return reservationService.getReservationByPaymentOrderId(merchantPayKey);
		}
		return null;
	}

	public String generateMerchantPayKey(int reservationId) {
		return "RES-" + reservationId + "-" + System.currentTimeMillis();
	}

	private String resolveReturnUrl(HttpServletRequest request) {
		String explicit = AppConfig.getProperty("naverpay.returnUrl");
		if (explicit != null && !explicit.isBlank()) {
			return explicit;
		}
		return resolveAbsoluteUrl(request, DEFAULT_RETURN_PATH);
	}

	private String resolveAbsoluteUrl(HttpServletRequest request, String path) {
		String scheme = request.getScheme();
		String serverName = request.getServerName();
		int serverPort = request.getServerPort();
		String contextPath = request.getContextPath();
		StringBuilder sb = new StringBuilder();
		sb.append(scheme).append("://").append(serverName);
		if (!("http".equalsIgnoreCase(scheme) && serverPort == 80)
				&& !("https".equalsIgnoreCase(scheme) && serverPort == 443)) {
			sb.append(":").append(serverPort);
		}
		if (path.startsWith("/")) {
			sb.append(contextPath).append(path);
		} else {
			sb.append(contextPath).append("/").append(path);
		}
		return sb.toString();
	}

	private String appendQueryParam(String url, String key, String value) {
		if (value == null || value.isBlank()) {
			return url;
		}
		String separator = url.contains("?") ? "&" : "?";
		return url + separator + key + "=" + java.net.URLEncoder.encode(value, java.nio.charset.StandardCharsets.UTF_8);
	}

	private AuthorizationHeader buildAuthorizationHeader(String paymentId) throws Exception {
		String timestamp = String.valueOf(System.currentTimeMillis());
		String message = timestamp + merchantId + paymentId;
		String signature = hmacSha256(clientSecret, message);
		String headerValue = "NAVERPAY-HMAC-V1 " + clientId + ":" + signature;
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

	public void markPaymentSuccess(Reservation reservation, String paymentOrderId) {
		reservation.setPaymentStatus("PAID");
		reservation.setPaymentOrderId(paymentOrderId);
		reservation.setPaymentApprovedAt(LocalDateTime.now());
		reservation.setStatus("CONFIRMED");
		reservation.setPaymentProvider(getProviderName());
	}

	public void markPaymentFailure(Reservation reservation, String paymentOrderId) {
		reservation.setPaymentStatus("FAILED");
		reservation.setPaymentOrderId(paymentOrderId);
		reservation.setPaymentProvider(getProviderName());
	}

	private static String toIntegerString(BigDecimal value) {
		if (value == null) {
			return "0";
		}
		BigDecimal normalized = value.setScale(0, RoundingMode.DOWN);
		return normalized.stripTrailingZeros().toPlainString();
	}

	private static class AuthorizationHeader {
		private final String headerValue;
		private final String timestamp;

		AuthorizationHeader(String headerValue, String timestamp) {
			this.headerValue = headerValue;
			this.timestamp = timestamp;
		}
	}

	// JSP에서 EL로 접근하기 위한 DTO 클래스 (public static으로 유지)
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
		private boolean skipConfirm;

		// Getters and Setters
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

		public boolean isSkipConfirm() {
			return skipConfirm;
		}

		public void setSkipConfirm(boolean skipConfirm) {
			this.skipConfirm = skipConfirm;
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
}