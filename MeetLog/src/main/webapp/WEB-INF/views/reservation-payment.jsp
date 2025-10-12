<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>주문 확인 - MEET LOG</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
	rel="stylesheet">
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
}
</style>
</head>
<body class="bg-slate-100">

	<c:set var="reservation" value="${requestScope.reservation}" />

	<div class="min-h-screen flex items-center justify-center p-6">
		<div
			class="bg-white shadow-xl rounded-2xl p-10 max-w-lg w-full text-center">
			<div class="mb-6">
				<div
					class="w-16 h-16 mx-auto rounded-full bg-amber-100 flex items-center justify-center text-amber-500 text-2xl">
					<i class="fas fa-receipt"></i>
				</div>
				<h1 class="mt-4 text-2xl font-bold text-slate-800">주문 내용 확인</h1>
				<p class="text-slate-600 mt-2">아래 예약 내용을 확인하시고 결제를 진행해주세요.</p>
			</div>

			<div class="bg-slate-50 rounded-xl p-5 text-left mb-6">
				<p class="text-sm text-slate-500 mb-1">예약 매장</p>
				<p class="font-semibold text-slate-800 mb-3">${reservation.restaurantName}</p>

				<p class="text-sm text-slate-500 mb-1">결제 금액</p>
				<p class="text-2xl font-bold text-amber-600">
					<fmt:formatNumber value="${reservation.depositAmount}"
						type="number" />
					원
				</p>
				<c:if test="${not empty depositDescription}">
					<div
						class="mt-4 text-sm text-slate-600 bg-white border border-slate-200 rounded-lg p-3">
						${depositDescription}</div>
				</c:if>
			</div>

			<%-- ✨ CHANGED: 결제 수단 선택 페이지로 이동하는 버튼으로 변경 --%>
			<form action="${pageContext.request.contextPath}/payment/methods"
				method="GET">
				<input type="hidden" name="reservationId" value="${reservation.id}" />
				<button type="submit"
					class="w-full py-3 rounded-lg bg-amber-500 hover:bg-amber-600 text-white font-semibold transition">
					결제하기</button>
			</form>

			<a href="${pageContext.request.contextPath}/mypage/reservations"
				class="mt-4 inline-block text-sm text-slate-500 hover:text-slate-700">나중에
				결제하기</a>
		</div>
	</div>

</body>
</html>