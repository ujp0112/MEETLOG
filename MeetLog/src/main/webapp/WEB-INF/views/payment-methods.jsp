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
							<%-- ✨ CHANGED: 로고를 담는 div와 img의 스타일을 변경하여 크기를 키웠습니다. --%>
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
							<%-- ✨ CHANGED: 로고를 담는 div와 img의 스타일을 변경하여 크기를 키웠습니다. --%>
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

	<script>
    // JavaScript 부분은 변경사항 없습니다.
    const paymentConfigs = {
        NAVERPAY: {
            clientId: '${naverConfig.clientId}',
            mode: '${naverConfig.mode}',
            merchantUserKey: '${naverConfig.merchantUserKey}',
            merchantPayKey: '${naverConfig.merchantPayKey}',
            productName: '${naverConfig.productName}',
            productCount: '${naverConfig.productCount}',
            totalPayAmount: '${naverConfig.totalPayAmountAsString}',
            taxScopeAmount: '${naverConfig.taxScopeAmountAsString}',
            taxExScopeAmount: '${naverConfig.taxExScopeAmountAsString}',
            returnUrl: '${naverConfig.returnUrl}',
            merchantId: '${naverConfig.merchantId}',
            chainId: '${naverConfig.chainId}'
        },
        KAKAOPAY: {
            redirectUrl: '${kakaoConfig.next_redirect_pc_url}'
        }
    };

    document.getElementById('finalPayButton').addEventListener('click', () => {
        const selectedMethod = document.querySelector('input[name="payment-method"]:checked').value;
        
        if (selectedMethod === 'NAVERPAY') {
            const config = paymentConfigs.NAVERPAY;
            const pay = Naver.Pay.create({ mode: config.mode, clientId: config.clientId, chainId: config.chainId });
            pay.open({
                merchantUserKey: config.merchantUserKey,
                merchantPayKey: config.merchantPayKey,
                productName: config.productName,
                totalPayAmount: config.totalPayAmount,
                returnUrl: config.returnUrl,
            });
        } else if (selectedMethod === 'KAKAOPAY') {
            const config = paymentConfigs.KAKAOPAY;
            if (config.redirectUrl && config.redirectUrl !== '') {
                window.location.href = config.redirectUrl;
            } else {
                alert('카카오페이 결제를 시작할 수 없습니다. 잠시 후 다시 시도해주세요.');
            }
        }
    });
</script>

</body>
</html>