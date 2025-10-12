<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 수단 선택 - MEET LOG</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
}

.payment-method-label {
	border: 2px solid #e5e7eb;
	transition: all 0.2s;
}

.payment-method-label:hover {
	border-color: #f59e0b;
}

.payment-method-input:checked+.payment-method-label {
	border-color: #d97706;
	background-color: #fffbeb;
}
</style>
</head>
<body class="bg-slate-100">

	<c:set var="reservation" value="${requestScope.reservation}" />
	<c:set var="naverConfig" value="${paymentConfigs.NAVERPAY}" />
	<c:set var="kakaoConfig" value="${paymentConfigs.KAKAOPAY}" />

	<div class="min-h-screen flex items-center justify-center p-6">
		<div class="bg-white shadow-xl rounded-2xl p-10 max-w-2xl w-full">
			<h1 class="text-2xl font-bold text-slate-800 text-center mb-8">결제
				수단 선택</h1>

			<div class="bg-slate-50 rounded-xl p-5 text-sm mb-8">
				<div class="flex justify-between">
					<span>${reservation.restaurantName} 예약금</span> <span
						class="font-semibold"><fmt:formatNumber
							value="${reservation.depositAmount}" type="number" />원</span>
				</div>
			</div>

			<div>
				<h2 class="text-lg font-semibold text-slate-700 mb-4">간편결제</h2>
				<div class="space-y-4">
					<div>
						<input type="radio" name="payment-method" id="naverpay-method"
							value="NAVERPAY" class="hidden payment-method-input" checked>
						<label for="naverpay-method"
							class="payment-method-label flex items-center p-4 rounded-lg cursor-pointer">
							<div class="flex items-center justify-center w-24 h-10">
								<img
									src="${pageContext.request.contextPath}/img/naverpay_logo.svg"
									alt="Naver Pay" class="max-h-full max-w-full object-contain">
							</div> <span class="ml-4 font-semibold text-slate-700">네이버페이</span>
						</label>
					</div>

					<div>
						<input type="radio" name="payment-method" id="kakaopay-method"
							value="KAKAOPAY" class="hidden payment-method-input"> <label
							for="kakaopay-method"
							class="payment-method-label flex items-center p-4 rounded-lg cursor-pointer">
							<div class="flex items-center justify-center w-24 h-10">
								<img
									src="${pageContext.request.contextPath}/img/kakaopay_logo.png"
									alt="Kakao Pay" class="max-h-full max-w-full object-contain">
							</div> <span class="ml-4 font-semibold text-slate-700">카카오페이</span>
						</label>
					</div>

				</div>
			</div>

			<div class="mt-8">
				<button id="finalPayButton"
					class="w-full py-3 rounded-lg bg-amber-500 hover:bg-amber-600 text-white font-semibold transition">
					<fmt:formatNumber value="${reservation.depositAmount}"
						type="number" />
					원 결제하기
				</button>
			</div>
		</div>
	</div>

	<%-- ▼▼▼ [수정] 스크립트 전체를 교체해주세요 ▼▼▼ --%>
	<script>
    // 1. JSP 변수를 JavaScript 변수로 안전하게 변환합니다.
    // 숫자는 따옴표 없이, 문자열은 따옴표를 사용하여 JS 문법 오류를 방지합니다.
    const paymentConfigs = {
        NAVERPAY: {
            clientId: '<c:out value="${naverConfig.clientId}" default=""/>',
            mode: '<c:out value="${naverConfig.mode}" default="production"/>',
            merchantUserKey: '<c:out value="${naverConfig.merchantUserKey}" default=""/>',
            merchantPayKey: '<c:out value="${naverConfig.merchantPayKey}" default=""/>',
            productName: '<c:out value="${naverConfig.productName}" escapeXml="true"/>',
            productCount: <c:out value="${naverConfig.productCount}" default="0"/>,
            totalPayAmount: <c:out value="${naverConfig.totalPayAmountAsString}" default="0"/>,
            taxScopeAmount: <c:out value="${naverConfig.taxScopeAmountAsString}" default="0"/>,
            taxExScopeAmount: <c:out value="${naverConfig.taxExScopeAmountAsString}" default="0"/>,
            returnUrl: '<c:out value="${naverConfig.returnUrl}" default=""/>',
            merchantId: '<c:out value="${naverConfig.merchantId}" default=""/>',
            chainId: '<c:out value="${naverConfig.chainId}" default=""/>'
        },
        KAKAOPAY: {
            redirectUrl: '<c:out value="${kakaoConfig.next_redirect_pc_url}" default=""/>'
        }
    };

    document.getElementById('finalPayButton').addEventListener('click', () => {
        const selectedMethod = document.querySelector('input[name="payment-method"]:checked').value;
        
        if (selectedMethod === 'NAVERPAY') {
            const config = paymentConfigs.NAVERPAY;
            const pay = Naver.Pay.create({ mode: config.mode, clientId: config.clientId, chainId: config.chainId });
            
            // 2. pay.open()에 모든 필수 금액 필드를 '숫자' 타입으로 전달합니다.
            pay.open({
                merchantUserKey: config.merchantUserKey,
                merchantPayKey: config.merchantPayKey,
                productName: config.productName,
                totalPayAmount: config.totalPayAmount,
                taxScopeAmount: config.taxScopeAmount,
                taxExScopeAmount: config.taxExScopeAmount,
                productCount: config.productCount, // 상품 수량도 전달하는 것이 좋습니다.
                returnUrl: config.returnUrl,
            });
        } else if (selectedMethod === 'KAKAOPAY') {
            const config = paymentConfigs.KAKAOPAY;
            if (config.redirectUrl) {
                window.location.href = config.redirectUrl;
            } else {
                alert('카카오페이 결제를 시작할 수 없습니다. 잠시 후 다시 시도해주세요.');
            }
        }
    });
	</script>

</body>
</html>