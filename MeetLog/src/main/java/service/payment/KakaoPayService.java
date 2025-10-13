package service.payment;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import model.Reservation;
import model.User;
import util.AppConfig;

public class KakaoPayService implements PaymentGatewayService {

	private final String cid;
	private final String adminKey;
	private final String apiBaseUrl = "https://kapi.kakao.com";
	private final Gson gson = new Gson();

	public KakaoPayService() {
		this.cid = AppConfig.getProperty("kakaopay.cid", "TC0ONETIME");
		this.adminKey = AppConfig.getProperty("kakaopay.adminKey", "");
	}

	@Override
	public String getProviderName() {
		return "KAKAOPAY";
	}

	@Override
	public Object buildPaymentRequest(HttpServletRequest request, User user, Reservation reservation) {
		KakaoPayReadyResponse readyResponse = preparePayment(request, reservation);

		// ✨ CHANGED: 결제 준비 단계에서 받은 tid와 orderId를 세션에 저장합니다.
		// 이 정보는 나중에 결제 승인 단계에서 꼭 필요합니다.
		if (readyResponse != null && readyResponse.getTid() != null) {
			HttpSession session = request.getSession();
			session.setAttribute("kakaoPayTid", readyResponse.getTid());
			session.setAttribute("kakaoPayPartnerOrderId", readyResponse.getPartnerOrderId());
		}

		return readyResponse;
	}

	private KakaoPayReadyResponse preparePayment(HttpServletRequest request, Reservation reservation) {
		try {
			URL url = new URL(apiBaseUrl + "/v1/payment/ready");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "KakaoAK " + this.adminKey);
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setDoOutput(true);

			String orderId = "RES-" + reservation.getId() + "-" + System.currentTimeMillis();
			String itemName = reservation.getRestaurantName() + " 예약금";

			String approvalUrl = resolveAbsoluteUrl(request, "/payment/kakao/callback?result=approval");
			String cancelUrl = resolveAbsoluteUrl(request, "/payment/kakao/callback?result=cancel");
			String failUrl = resolveAbsoluteUrl(request, "/payment/kakao/callback?result=fail");

			String params = String.join("&", "cid=" + cid, "partner_order_id=" + orderId,
					"partner_user_id=" + "USER-" + reservation.getUserId(), "item_name=" + itemName, "quantity=1",
					"total_amount=" + reservation.getDepositAmount().toBigInteger(), "tax_free_amount=0",
					"approval_url=" + approvalUrl, "cancel_url=" + cancelUrl, "fail_url=" + failUrl);

			try (OutputStream os = conn.getOutputStream()) {
				os.write(params.getBytes(StandardCharsets.UTF_8));
			}

			int responseCode = conn.getResponseCode();
			try (BufferedReader br = new BufferedReader(
					new InputStreamReader(responseCode == 200 ? conn.getInputStream() : conn.getErrorStream()))) {
				String responseLine;
				StringBuilder response = new StringBuilder();
				while ((responseLine = br.readLine()) != null) {
					response.append(responseLine);
				}
				if (responseCode == 200) {
					KakaoPayReadyResponse readyResponse = gson.fromJson(response.toString(),
							KakaoPayReadyResponse.class);
					readyResponse.setPartnerOrderId(orderId); // 응답에 없으므로 직접 설정
					return readyResponse;
				} else {
					System.err.println("KakaoPay Ready Error: " + response.toString());
					return null;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// ✨ NEW: 결제 승인 API를 호출하는 메소드를 새로 구현합니다.
	public PaymentConfirmResult approvePayment(String pgToken, String tid, String partnerOrderId,
			String partnerUserId) {
		try {
			URL url = new URL(apiBaseUrl + "/v1/payment/approve");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "KakaoAK " + this.adminKey);
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setDoOutput(true);

			String params = String.join("&", "cid=" + cid, "tid=" + tid, "partner_order_id=" + partnerOrderId,
					"partner_user_id=" + partnerUserId, "pg_token=" + pgToken);

			try (OutputStream os = conn.getOutputStream()) {
				os.write(params.getBytes(StandardCharsets.UTF_8));
			}

			int responseCode = conn.getResponseCode();
			try (BufferedReader br = new BufferedReader(
					new InputStreamReader(responseCode == 200 ? conn.getInputStream() : conn.getErrorStream()))) {
				String responseStr = br.lines().collect(java.util.stream.Collectors.joining());
				if (responseCode == 200) {
					JsonObject json = gson.fromJson(responseStr, JsonObject.class);
					String paymentId = json.get("aid").getAsString(); // 카카오의 고유 거래번호
					return new PaymentConfirmResult(true, paymentId, partnerOrderId, "SUCCESS", "결제 성공");
				} else {
					JsonObject errorJson = gson.fromJson(responseStr, JsonObject.class);
					String errorMsg = errorJson.has("msg") ? errorJson.get("msg").getAsString() : "결제 승인 실패";
					return new PaymentConfirmResult(false, null, partnerOrderId, "FAIL", errorMsg);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new PaymentConfirmResult(false, null, partnerOrderId, "EXCEPTION", e.getMessage());
		}
	}

	@Override
	public PaymentConfirmResult confirmPayment(HttpServletRequest request) {
		// 이 메소드는 NaverPay와 같은 동기식 콜백에서는 유용하지만,
		// KakaoPay의 다단계 인증에서는 직접 사용되지 않습니다.
		// 대신 approvePayment가 사용됩니다.
		return new PaymentConfirmResult(false, null, null, "NOT_SUPPORTED", "이 메소드는 카카오페이에서 지원하지 않습니다.");
	}

	public static class KakaoPayReadyResponse {
		private String tid;
		private String next_redirect_pc_url;
		private String created_at;
		private transient String partner_order_id; // API 응답에는 없지만, 내부적으로 전달하기 위해 추가

		public String getTid() {
			return tid;
		}

		public String getNext_redirect_pc_url() {
			return next_redirect_pc_url;
		}

		public String getCreated_at() {
			return created_at;
		}

		public String getPartnerOrderId() {
			return partner_order_id;
		}

		public void setPartnerOrderId(String partnerOrderId) {
			this.partner_order_id = partnerOrderId;
		}
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
		sb.append(contextPath).append(path);
		return sb.toString();
	}
}