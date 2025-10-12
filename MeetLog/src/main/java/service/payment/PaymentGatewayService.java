package service.payment;

import javax.servlet.http.HttpServletRequest;
import model.Reservation;
import model.User;

// 모든 결제 모듈이 구현해야 할 공통 인터페이스
public interface PaymentGatewayService {

    /**
     * 결제 페이지(JSP)를 렌더링하는 데 필요한 설정 정보를 생성합니다.
     * @return JSP에서 사용할 설정 객체 (Map<String, Object> 또는 전용 DTO)
     */
    Object buildPaymentRequest(HttpServletRequest request, User user, Reservation reservation);

    /**
     * 결제사로부터의 콜백(return) 요청을 처리하고 최종 결제 승인을 시도합니다.
     * @return 결제 승인 결과 정보
     */
    PaymentConfirmResult confirmPayment(HttpServletRequest request);

    /**
     * 결제 제공사 이름을 반환합니다. (예: "NAVERPAY", "KAKAOPAY")
     * @return 제공사 이름
     */
    String getProviderName();
}