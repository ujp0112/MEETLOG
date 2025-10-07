<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약금 결제 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
    </style>
</head>
<body class="bg-slate-100">
<c:set var="config" value="${naverPayConfig}" />
<c:set var="reservation" value="${requestScope.reservation}" />

<c:choose>
    <c:when test="${config != null}">
        <div class="min-h-screen flex items-center justify-center p-6">
            <div class="bg-white shadow-xl rounded-2xl p-10 max-w-lg w-full text-center">
                <div class="mb-6">
                    <div class="w-16 h-16 mx-auto rounded-full bg-amber-100 flex items-center justify-center text-amber-500 text-2xl">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h1 class="mt-4 text-2xl font-bold text-slate-800">예약금 결제 진행</h1>
                    <p class="text-slate-600 mt-2">예약을 확정하기 위해 네이버페이 결제를 완료해주세요.</p>
                </div>

                <div class="bg-slate-50 rounded-xl p-5 text-left mb-6">
                    <p class="text-sm text-slate-500 mb-1">예약 매장</p>
                    <p class="font-semibold text-slate-800 mb-3">${reservation.restaurantName}</p>
                    <p class="text-sm text-slate-500 mb-1">결제 금액</p>
                    <p class="text-2xl font-bold text-amber-600">${config.totalPayAmountAsString}원</p>
                    <c:if test="${not empty depositDescription}">
                        <div class="mt-4 text-sm text-slate-600 bg-white border border-slate-200 rounded-lg p-3">
                            ${depositDescription}
                        </div>
                    </c:if>
                </div>

                <button id="payButton" class="w-full py-3 rounded-lg bg-amber-500 hover:bg-amber-600 text-white font-semibold transition">네이버페이로 결제하기</button>
                <a href="${pageContext.request.contextPath}/mypage/reservations" class="mt-4 inline-block text-sm text-slate-500 hover:text-slate-700">나중에 결제하기</a>
                <p id="errorMessage" class="text-sm text-red-500 mt-3 hidden"></p>
            </div>
        </div>

        <script>
            const config = {
                clientId: '${config.clientId}',
                mode: '${config.mode}',
                merchantUserKey: '${config.merchantUserKey}',
                merchantPayKey: '${config.merchantPayKey}',
                productName: '${config.productName}',
                productCount: '${config.productCount}',
                totalPayAmount: '${config.totalPayAmountAsString}',
                taxScopeAmount: '${config.taxScopeAmountAsString}',
                taxExScopeAmount: '${config.taxExScopeAmountAsString}',
                returnUrl: '${config.returnUrl}',
                merchantId: '${config.merchantId}',
                chainId: '${config.chainId}',
                skipConfirm: '${config.skipConfirm}' === 'true'
            };

            document.addEventListener('DOMContentLoaded', () => {
                console.log('NaverPay config payload', config);

                const payButton = document.getElementById('payButton');
                if (!payButton) {
                    return;
                }

                payButton.addEventListener('click', (event) => {
                    event.preventDefault();

                    if (config.skipConfirm) {
                        alert('개발 모드: 예약금을 테스트 결제로 처리합니다.');
                        const mockPaymentId = 'DEV-MOCK-' + Date.now();
                        window.location.href = config.returnUrl
                            + '?resultCode=Success'
                            + '&merchantPayKey=' + encodeURIComponent(config.merchantPayKey)
                            + '&paymentId=' + encodeURIComponent(mockPaymentId);
                        return;
                    }

                    if (!(window.Naver && Naver.Pay)) {
                        console.error('네이버페이 SDK가 로드되지 않았습니다.');
                        return;
                    }

                    const pay = Naver.Pay.create({
                        mode: config.mode || 'development',
                        clientId: config.clientId,
                        chainId: config.chainId || undefined
                    });

                    const payload = {
                        merchantUserKey: config.merchantUserKey,
                        merchantPayKey: config.merchantPayKey,
                        productName: config.productName,
                        productCount: parseInt(config.productCount || '1', 10).toString(),
                        totalPayAmount: Math.floor(Number(config.totalPayAmount || '0')).toString(),
                        taxScopeAmount: Math.floor(Number(config.taxScopeAmount || '0')).toString(),
                        taxExScopeAmount: Math.floor(Number(config.taxExScopeAmount || '0')).toString(),
                        returnUrl: config.returnUrl,
                        merchantId: config.merchantId || undefined,
                        chainId: config.chainId || undefined
                    };

                    console.log('NaverPay payload', payload);
                    pay.open(payload);
                });
            });
        </script>
    </c:when>
    <c:otherwise>
        <div class="min-h-screen flex items-center justify-center p-6">
            <div class="bg-white shadow-xl rounded-2xl p-8 max-w-md w-full text-center">
                <h1 class="text-xl font-semibold text-slate-800 mb-4">결제 구성이 준비되지 않았습니다.</h1>
                <p class="text-slate-600 text-sm">관리자에게 네이버페이 설정을 확인한 뒤 다시 시도해주세요.</p>
                <a href="${pageContext.request.contextPath}/mypage/reservations" class="mt-6 inline-block text-sm text-sky-600 hover:text-sky-800">내 예약으로 돌아가기</a>
            </div>
        </div>
    </c:otherwise>
</c:choose>
</body>
</html>
