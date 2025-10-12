package service.payment;

// 모든 결제 승인 결과가 반환해야 할 공통 객체
public class PaymentConfirmResult {
	private final boolean success;
	private final String paymentId; // 결제사 거래 ID
	private final String orderId; // 우리 시스템의 주문 ID (merchantPayKey)
	private final String resultCode; // 결과 코드
	private final String message; // 결과 메시지
	private String rawResponse; // 원본 응답 (디버깅용)

	public PaymentConfirmResult(boolean success, String paymentId, String orderId, String resultCode, String message) {
		this.success = success;
		this.paymentId = paymentId;
		this.orderId = orderId;
		this.resultCode = resultCode;
		this.message = message;
	}

	// Getters
	public boolean isSuccess() {
		return success;
	}

	public String getPaymentId() {
		return paymentId;
	}

	public String getOrderId() {
		return orderId;
	}

	public String getResultCode() {
		return resultCode;
	}

	public String getMessage() {
		return message;
	}

	public String getRawResponse() {
		return rawResponse;
	}

	public PaymentConfirmResult withRawResponse(String raw) {
		this.rawResponse = raw;
		return this;
	}
}