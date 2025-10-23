# Phase 7: 결제 시스템 - 구현 가이드

## 개요
Toss Payments를 활용한 예약 결제 시스템 구축
**상태**: ⏳ 진행 중 (기본 구조 완료, PG 연동 필요)

---

## 1. 완료된 작업

### 1.1 Entity Layer ✅
**파일**: `MeetLog-SpringBoot/src/main/java/com/meetlog/model/Payment.java` (132 lines)

```java
public class Payment {
    // 기본 정보
    private Long id;
    private String paymentType; // RESERVATION, COURSE_RESERVATION
    private Long referenceId;
    private Long userId;

    // 결제 정보
    private String orderId; // 고유 주문 ID
    private String orderName;
    private BigDecimal amount;
    private String currency; // KRW

    // 결제 수단
    private String paymentMethod; // CARD, VIRTUAL_ACCOUNT, etc.
    private String provider; // TOSS, KAKAO, NAVER

    // 상태 관리
    private String status; // READY, IN_PROGRESS, DONE, CANCELED, etc.
    private String paymentKey; // PG사 제공 키

    // 시간 정보
    private LocalDateTime requestedAt;
    private LocalDateTime approvedAt;
    private LocalDateTime canceledAt;

    // 환불
    private BigDecimal refundAmount;
    private String refundStatus; // NONE, PARTIAL, FULL

    // Helper methods: isDone(), canCancel(), getStatusText(), etc.
}
```

**Helper Methods**:
- `isReady()`, `isDone()`, `isCanceled()`, `canCancel()`
- `getStatusText()` - 결제 완료, 결제 취소 등
- `getMethodText()` - 카드, 가상계좌 등

---

### 1.2 DTO Layer ✅
**위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/dto/payment/`

1. **PaymentDto** - 결제 응답 DTO (사용자 정보 포함)
2. **PaymentRequest** - 결제 요청 DTO
   ```java
   @Data
   public class PaymentRequest {
       @NotBlank String paymentType;
       @NotNull Long referenceId;
       @NotBlank String orderName;
       @NotNull BigDecimal amount;
       @NotBlank String paymentMethod;
       String successUrl, failUrl;
   }
   ```

3. **PaymentApprovalRequest** - Toss 승인 요청
   ```java
   @Data
   public class PaymentApprovalRequest {
       @NotBlank String paymentKey;
       @NotBlank String orderId;
       @NotNull BigDecimal amount;
   }
   ```

4. **PaymentCancelRequest** - 취소 요청
5. **TossPaymentResponse** - Toss API 응답 매핑
   - 카드, 가상계좌, 취소, 실패 정보 포함

---

###1.3 Repository Layer ✅
**위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/repository/`

**PaymentRepository.java** (인터페이스)
```java
@Mapper
public interface PaymentRepository {
    Payment findById(Long id);
    Payment findByOrderId(String orderId);
    PaymentDto findDtoById(Long id);
    List<PaymentDto> findByUserId(Long userId, int page, int size);
    List<PaymentDto> findByReference(String paymentType, Long referenceId);
    int insert(Payment payment);
    int update(Payment payment);
    int updateStatus(Long id, String status);
}
```

**PaymentRepositoryMapper.xml** - MyBatis 매퍼 (완료)

---

## 2. 미완료 작업 (구현 필요)

### 2.1 Database Schema ⏳

현재 `reservations` 테이블에 결제 필드가 존재하지만, 별도의 `payments` 테이블 생성 권장:

```sql
CREATE TABLE `payments` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `payment_type` VARCHAR(50) NOT NULL COMMENT 'RESERVATION, COURSE_RESERVATION',
  `reference_id` BIGINT NOT NULL COMMENT '예약 ID',
  `user_id` INT NOT NULL,

  -- 주문 정보
  `order_id` VARCHAR(120) NOT NULL UNIQUE COMMENT '고유 주문 ID',
  `order_name` VARCHAR(200) NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `currency` VARCHAR(10) NOT NULL DEFAULT 'KRW',

  -- 결제 수단
  `payment_method` VARCHAR(50) NOT NULL,
  `provider` VARCHAR(50) NOT NULL DEFAULT 'TOSS',

  -- 상태
  `status` VARCHAR(30) NOT NULL DEFAULT 'READY',
  `payment_key` VARCHAR(200) DEFAULT NULL,

  -- 시간
  `requested_at` TIMESTAMP NOT NULL,
  `approved_at` TIMESTAMP NULL DEFAULT NULL,
  `canceled_at` TIMESTAMP NULL DEFAULT NULL,
  `cancel_reason` TEXT DEFAULT NULL,

  -- 환불
  `refund_amount` DECIMAL(12,2) DEFAULT 0.00,
  `refund_status` VARCHAR(20) DEFAULT 'NONE',

  -- 메타
  `raw_response` LONGTEXT DEFAULT NULL COMMENT 'PG사 응답 JSON',
  `fail_reason` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  INDEX `idx_payments_order_id` (`order_id`),
  INDEX `idx_payments_user_id` (`user_id`),
  INDEX `idx_payments_reference` (`payment_type`, `reference_id`),
  INDEX `idx_payments_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**마이그레이션 스크립트**:
```bash
mysql -u root -p1234 meetlog < migrations/007_create_payments_table.sql
```

---

### 2.2 Service Layer ⏳

**PaymentService.java** 구현 필요:

```java
@Service
@RequiredArgsConstructor
public class PaymentService {
    private final PaymentRepository paymentRepository;
    private final RestTemplate restTemplate;

    @Value("${toss.secret-key}")
    private String tossSecretKey;

    @Value("${toss.api.url}")
    private String tossApiUrl;

    /**
     * 결제 준비 (주문 ID 생성)
     */
    @Transactional
    public PaymentDto preparePayment(PaymentRequest request, Long userId) {
        // 1. 주문 ID 생성 (UUID 또는 타임스탬프)
        String orderId = generateOrderId();

        // 2. Payment 엔티티 생성
        Payment payment = Payment.builder()
                .paymentType(request.getPaymentType())
                .referenceId(request.getReferenceId())
                .userId(userId)
                .orderId(orderId)
                .orderName(request.getOrderName())
                .amount(request.getAmount())
                .currency("KRW")
                .paymentMethod(request.getPaymentMethod())
                .provider("TOSS")
                .status("READY")
                .requestedAt(LocalDateTime.now())
                .refundStatus("NONE")
                .build();

        paymentRepository.insert(payment);

        // 3. 예약 상태 업데이트 (payment_order_id 저장)
        updateReservationPaymentOrderId(request.getPaymentType(),
                                         request.getReferenceId(),
                                         orderId);

        return convertToDto(payment);
    }

    /**
     * 결제 승인 (Toss Payments API 호출)
     */
    @Transactional
    public PaymentDto approvePayment(PaymentApprovalRequest request) {
        // 1. Payment 조회
        Payment payment = paymentRepository.findByOrderId(request.getOrderId());
        if (payment == null) {
            throw new RuntimeException("Payment not found");
        }

        // 2. Toss Payments API 호출
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(tossSecretKey, "");
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> body = Map.of(
            "paymentKey", request.getPaymentKey(),
            "orderId", request.getOrderId(),
            "amount", request.getAmount()
        );

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<TossPaymentResponse> response = restTemplate.exchange(
                tossApiUrl + "/v1/payments/confirm",
                HttpMethod.POST,
                entity,
                TossPaymentResponse.class
            );

            TossPaymentResponse tossResponse = response.getBody();

            // 3. Payment 업데이트
            payment.setPaymentKey(tossResponse.getPaymentKey());
            payment.setStatus("DONE");
            payment.setApprovedAt(tossResponse.getApprovedAt());
            payment.setRawResponse(toJson(tossResponse));

            paymentRepository.update(payment);

            // 4. 예약 상태 업데이트 (CONFIRMED)
            updateReservationStatus(payment.getPaymentType(),
                                     payment.getReferenceId(),
                                     "CONFIRMED");

            return convertToDto(payment);

        } catch (Exception e) {
            payment.setStatus("ABORTED");
            payment.setFailReason(e.getMessage());
            paymentRepository.update(payment);
            throw new RuntimeException("Payment approval failed", e);
        }
    }

    /**
     * 결제 취소
     */
    @Transactional
    public PaymentDto cancelPayment(Long paymentId, PaymentCancelRequest request, Long userId) {
        Payment payment = paymentRepository.findById(paymentId);
        if (payment == null) {
            throw new RuntimeException("Payment not found");
        }

        if (!payment.getUserId().equals(userId)) {
            throw new RuntimeException("No permission");
        }

        if (!payment.canCancel()) {
            throw new RuntimeException("Cannot cancel this payment");
        }

        // Toss Payments 취소 API 호출
        BigDecimal cancelAmount = request.getCancelAmount() != null
                                  ? request.getCancelAmount()
                                  : payment.getAmount();

        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(tossSecretKey, "");
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> body = Map.of(
            "cancelReason", request.getCancelReason(),
            "cancelAmount", cancelAmount
        );

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<TossPaymentResponse> response = restTemplate.exchange(
                tossApiUrl + "/v1/payments/" + payment.getPaymentKey() + "/cancel",
                HttpMethod.POST,
                entity,
                TossPaymentResponse.class
            );

            // Payment 업데이트
            payment.setStatus("CANCELED");
            payment.setCanceledAt(LocalDateTime.now());
            payment.setCancelReason(request.getCancelReason());
            payment.setRefundAmount(cancelAmount);
            payment.setRefundStatus(cancelAmount.compareTo(payment.getAmount()) == 0 ? "FULL" : "PARTIAL");

            paymentRepository.update(payment);

            // 예약 상태 업데이트 (CANCELLED)
            updateReservationStatus(payment.getPaymentType(),
                                     payment.getReferenceId(),
                                     "CANCELLED");

            return convertToDto(payment);

        } catch (Exception e) {
            throw new RuntimeException("Payment cancellation failed", e);
        }
    }

    private String generateOrderId() {
        return "ORD_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8);
    }
}
```

---

### 2.3 Controller Layer ⏳

**PaymentController.java**:

```java
@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/prepare")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<PaymentDto> preparePayment(
            @Valid @RequestBody PaymentRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        PaymentDto payment = paymentService.preparePayment(request, userDetails.getUserId());
        return ResponseEntity.ok(payment);
    }

    @PostMapping("/approve")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<PaymentDto> approvePayment(
            @Valid @RequestBody PaymentApprovalRequest request
    ) {
        PaymentDto payment = paymentService.approvePayment(request);
        return ResponseEntity.ok(payment);
    }

    @PostMapping("/{id}/cancel")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<PaymentDto> cancelPayment(
            @PathVariable Long id,
            @Valid @RequestBody PaymentCancelRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        PaymentDto payment = paymentService.cancelPayment(id, request, userDetails.getUserId());
        return ResponseEntity.ok(payment);
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<PaymentDto> getPayment(@PathVariable Long id) {
        PaymentDto payment = paymentService.getPayment(id);
        return ResponseEntity.ok(payment);
    }

    @GetMapping("/my")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<PaymentDto>> getMyPayments(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        List<PaymentDto> payments = paymentService.getMyPayments(userDetails.getUserId(), page, size);
        return ResponseEntity.ok(payments);
    }
}
```

---

### 2.4 프론트엔드 구현 ⏳

#### payment.js (API Client)

```javascript
import apiClient from './client';

export const paymentAPI = {
  // 결제 준비
  prepare: async (paymentData) => {
    const response = await apiClient.post('/payments/prepare', paymentData);
    return response.data;
  },

  // 결제 승인
  approve: async (approvalData) => {
    const response = await apiClient.post('/payments/approve', approvalData);
    return response.data;
  },

  // 결제 취소
  cancel: async (paymentId, cancelData) => {
    const response = await apiClient.post(`/payments/${paymentId}/cancel`, cancelData);
    return response.data;
  },

  // 결제 상세
  getById: async (id) => {
    const response = await apiClient.get(`/payments/${id}`);
    return response.data;
  },

  // 내 결제 목록
  getMyPayments: async (page = 1, size = 10) => {
    const response = await apiClient.get('/payments/my', { params: { page, size } });
    return response.data;
  }
};
```

#### TossPaymentWidget.jsx (핵심 컴포넌트)

```jsx
import React, { useEffect, useRef, useState } from 'react';
import { loadTossPayments } from '@tosspayments/payment-sdk';
import { paymentAPI } from '../../api/payment';

const TossPaymentWidget = ({ reservation, onSuccess, onFail }) => {
  const [ready, setReady] = useState(false);
  const [payment, setPayment] = useState(null);
  const widgetRef = useRef(null);

  const clientKey = process.env.REACT_APP_TOSS_CLIENT_KEY;

  useEffect(() => {
    async function init() {
      // 1. Toss Payments SDK 로드
      const tossPayments = await loadTossPayments(clientKey);

      // 2. 결제 위젯 렌더링
      const widget = tossPayments.widgets({ customerKey: `USER_${reservation.userId}` });
      await widget.setAmount(reservation.depositAmount);

      await widget.renderPaymentMethods('#payment-widget', {
        value: reservation.depositAmount
      });

      widgetRef.current = widget;
      setReady(true);
    }

    init();
  }, [clientKey, reservation]);

  const handlePayment = async () => {
    if (!widgetRef.current) return;

    try {
      // 1. 백엔드에 결제 준비 요청
      const prepared = await paymentAPI.prepare({
        paymentType: 'RESERVATION',
        referenceId: reservation.id,
        orderName: `${reservation.restaurantName} 예약`,
        amount: reservation.depositAmount,
        paymentMethod: 'CARD'
      });

      setPayment(prepared);

      // 2. Toss Payments 결제창 호출
      await widgetRef.current.requestPayment({
        orderId: prepared.orderId,
        orderName: prepared.orderName,
        successUrl: `${window.location.origin}/payment/success`,
        failUrl: `${window.location.origin}/payment/fail`,
      });

    } catch (error) {
      console.error('Payment failed:', error);
      if (onFail) onFail(error);
    }
  };

  return (
    <div className="toss-payment-widget">
      <h3 className="text-lg font-bold mb-4">결제 정보</h3>

      <div className="mb-4">
        <p className="text-sm text-gray-600">예약 레스토랑</p>
        <p className="font-medium">{reservation.restaurantName}</p>
      </div>

      <div className="mb-4">
        <p className="text-sm text-gray-600">예약 일시</p>
        <p className="font-medium">
          {new Date(reservation.reservationTime).toLocaleString('ko-KR')}
        </p>
      </div>

      <div className="mb-4">
        <p className="text-sm text-gray-600">결제 금액</p>
        <p className="text-xl font-bold text-blue-600">
          {reservation.depositAmount.toLocaleString()}원
        </p>
      </div>

      {/* Toss Payments 위젯 렌더링 영역 */}
      <div id="payment-widget" className="my-6"></div>

      <button
        onClick={handlePayment}
        disabled={!ready}
        className="w-full py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50"
      >
        {ready ? '결제하기' : '로딩 중...'}
      </button>
    </div>
  );
};

export default TossPaymentWidget;
```

#### PaymentSuccess.jsx (성공 페이지)

```jsx
import React, { useEffect, useState } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { paymentAPI } from '../../api/payment';

const PaymentSuccess = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [processing, setProcessing] = useState(true);
  const [payment, setPayment] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function approve() {
      const paymentKey = searchParams.get('paymentKey');
      const orderId = searchParams.get('orderId');
      const amount = searchParams.get('amount');

      if (!paymentKey || !orderId || !amount) {
        setError('잘못된 접근입니다.');
        setProcessing(false);
        return;
      }

      try {
        const approved = await paymentAPI.approve({
          paymentKey,
          orderId,
          amount: parseFloat(amount)
        });

        setPayment(approved);
        setProcessing(false);

        // 3초 후 예약 상세 페이지로 이동
        setTimeout(() => {
          navigate(`/reservations/${approved.referenceId}`);
        }, 3000);

      } catch (err) {
        console.error('Payment approval failed:', err);
        setError('결제 승인에 실패했습니다.');
        setProcessing(false);
      }
    }

    approve();
  }, [searchParams, navigate]);

  if (processing) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">결제를 처리하고 있습니다...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="text-red-600 text-5xl mb-4">❌</div>
          <h2 className="text-2xl font-bold mb-2">결제 실패</h2>
          <p className="text-gray-600 mb-4">{error}</p>
          <button
            onClick={() => navigate('/reservations')}
            className="px-6 py-2 bg-gray-600 text-white rounded-md"
          >
            예약 목록으로
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="text-center max-w-md">
        <div className="text-green-600 text-5xl mb-4">✅</div>
        <h2 className="text-2xl font-bold mb-2">결제 완료!</h2>
        <p className="text-gray-600 mb-4">
          예약이 확정되었습니다.<br/>
          잠시 후 예약 상세 페이지로 이동합니다.
        </p>

        {payment && (
          <div className="bg-gray-50 rounded-lg p-4 text-left">
            <p className="text-sm text-gray-500">결제 금액</p>
            <p className="text-xl font-bold text-blue-600 mb-2">
              {payment.amount.toLocaleString()}원
            </p>

            <p className="text-sm text-gray-500">결제 수단</p>
            <p className="text-sm font-medium mb-2">{payment.paymentMethod}</p>

            <p className="text-sm text-gray-500">승인 시각</p>
            <p className="text-sm font-medium">
              {new Date(payment.approvedAt).toLocaleString('ko-KR')}
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default PaymentSuccess;
```

---

## 3. 환경 설정

### 3.1 application.properties (Spring Boot)

```properties
# Toss Payments 설정
toss.client-key=${TOSS_CLIENT_KEY}
toss.secret-key=${TOSS_SECRET_KEY}
toss.api.url=https://api.tosspayments.com

# RestTemplate Bean 등록 필요 (TossPayments API 호출용)
```

### 3.2 환경 변수 (.env)

```bash
# Backend
TOSS_CLIENT_KEY=test_ck_YOUR_CLIENT_KEY
TOSS_SECRET_KEY=test_sk_YOUR_SECRET_KEY

# Frontend
REACT_APP_TOSS_CLIENT_KEY=test_ck_YOUR_CLIENT_KEY
```

### 3.3 패키지 설치 (Frontend)

```bash
npm install @tosspayments/payment-sdk
```

---

## 4. 테스트 시나리오

### 4.1 통합 테스트

1. **예약 생성** → POST `/api/reservations`
2. **결제 준비** → POST `/api/payments/prepare`
   - orderId 생성 확인
   - reservations 테이블 payment_order_id 업데이트 확인
3. **결제 위젯 렌더링** → TossPaymentWidget 컴포넌트
4. **결제 요청** → Toss Payments 결제창
5. **결제 승인** → POST `/api/payments/approve` (리다이렉트 후)
   - PG사 응인 확인
   - Payment status=DONE 확인
   - Reservation status=CONFIRMED 확인
6. **결제 취소** → POST `/api/payments/{id}/cancel`
   - 환불 처리 확인
   - Reservation status=CANCELLED 확인

---

## 5. 보안 고려사항

1. **Secret Key 보호**:
   - 환경 변수 또는 AWS Secrets Manager 사용
   - application.properties에 직접 저장 금지

2. **금액 검증**:
   - 프론트엔드와 백엔드 양쪽에서 금액 일치 여부 확인
   - 승인 요청 시 DB 금액과 PG 금액 비교

3. **CSRF 방어**:
   - Spring Security CSRF 토큰 활성화
   - 결제 콜백 URL에 토큰 포함

4. **Webhook 검증**:
   - Toss Payments Webhook 서명 검증 구현

---

## 6. 다음 단계

- [ ] Database migration 실행 (payments 테이블 생성)
- [ ] PaymentService 구현
- [ ] PaymentController 구현
- [ ] Toss Payments 테스트 계정 설정
- [ ] TossPaymentWidget 컴포넌트 구현
- [ ] PaymentSuccess/Fail 페이지 구현
- [ ] Webhook 엔드포인트 구현 (가상계좌 입금 알림 등)
- [ ] 프로덕션 배포 시 실제 계정으로 전환

---

## 7. 참고 자료

- [Toss Payments 공식 문서](https://docs.tosspayments.com/)
- [Toss Payments React SDK](https://github.com/tosspayments/payment-sdk)
- [Spring Boot + Toss Payments 예제](https://github.com/tosspayments/examples)

---

**현재 상태**: 기본 구조 완료 (Entity, DTO, Repository)
**다음 작업**: PaymentService 구현 및 Toss Payments API 연동

