<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- 공통 헤더 포함 --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8">
                    <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">예약 관리</h2>
                    <p class="text-slate-600">매장의 예약 현황을 확인하고 관리합니다.</p>
                </div>

                <!-- 예약 목록 -->
                <div class="bg-white rounded-xl shadow-lg">
                    <div class="p-6 border-b border-slate-200">
                        <h3 class="text-lg font-semibold text-slate-800">예약 목록</h3>
                    </div>

                    <!-- 필터 버튼 그룹 -->
                    <c:if test="${not empty reservations}">
                        <div class="px-6 py-4 border-b border-slate-200">
                            <div class="flex flex-wrap gap-2">
                                <button onclick="filterReservations('all')"
                                        class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-blue-600 text-white"
                                        data-filter="all">
                                    전체
                                </button>
                                <button onclick="filterReservations('PENDING')"
                                        class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                        data-filter="PENDING">
                                    🟡 대기중
                                </button>
                                <button onclick="filterReservations('CONFIRMED')"
                                        class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                        data-filter="CONFIRMED">
                                    🟢 확정
                                </button>
                                <button onclick="filterReservations('COMPLETED')"
                                        class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                        data-filter="COMPLETED">
                                    🔵 완료
                                </button>
                                <button onclick="filterReservations('CANCELLED')"
                                        class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                        data-filter="CANCELLED">
                                    🔴 취소
                                </button>
                            </div>
                        </div>
                    </c:if>

                    <div class="p-6">
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <div id="reservationList" class="space-y-4">
                                    <c:forEach var="reservation" items="${reservations}">
                                        <div class="reservation-card border border-slate-200 rounded-lg p-4 hover:bg-slate-50 transition-colors" data-status="${reservation.status}">
                                            <div class="flex items-center justify-between">
                                                <div class="flex-1">
                                                    <div class="flex items-center space-x-4">
                                                        <div>
                                                            <h4 class="font-medium text-slate-900">${reservation.customerName}</h4>
                                                            <p class="text-sm text-slate-600">예약 시간: ${reservation.reservationTime}</p>
                                                            <p class="text-sm text-slate-600">인원: ${reservation.partySize}명</p>
                                                        </div>
                                                        <div class="flex items-center">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                                                                <c:choose>
                                                                    <c:when test="${reservation.status == 'PENDING'}">bg-yellow-100 text-yellow-800</c:when>
                                                                    <c:when test="${reservation.status == 'CONFIRMED'}">bg-green-100 text-green-800</c:when>
                                                                    <c:when test="${reservation.status == 'COMPLETED'}">bg-blue-100 text-blue-800</c:when>
                                                                    <c:when test="${reservation.status == 'CANCELLED'}">bg-red-100 text-red-800</c:when>
                                                                    <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                                </c:choose>
                                                            ">
                                                                <c:choose>
                                                                    <c:when test="${reservation.status == 'PENDING'}">대기중</c:when>
                                                                    <c:when test="${reservation.status == 'CONFIRMED'}">확정</c:when>
                                                                    <c:when test="${reservation.status == 'COMPLETED'}">완료</c:when>
                                                                    <c:when test="${reservation.status == 'CANCELLED'}">취소</c:when>
                                                                    <c:otherwise>${reservation.status}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="flex space-x-2">
                                                    <button class="px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors">
                                                        확인
                                                    </button>
                                                    <button class="px-3 py-1 text-sm bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
                                                        취소
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <svg class="mx-auto h-12 w-12 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                    </svg>
                                    <h3 class="mt-2 text-sm font-medium text-slate-900">예약이 없습니다</h3>
                                    <p class="mt-1 text-sm text-slate-500">아직 등록된 예약이 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>

        <%-- 공통 푸터 포함 --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        // 예약 필터링 함수
        function filterReservations(status) {
            const reservationCards = document.querySelectorAll('.reservation-card');
            const filterButtons = document.querySelectorAll('.filter-btn');

            // 모든 버튼의 active 상태 제거
            filterButtons.forEach(btn => {
                btn.classList.remove('bg-blue-600', 'text-white');
                btn.classList.add('bg-slate-100', 'text-slate-700', 'hover:bg-slate-200');
            });

            // 클릭된 버튼을 active 상태로 변경
            const activeBtn = document.querySelector(`[data-filter="${status}"]`);
            if (activeBtn) {
                activeBtn.classList.remove('bg-slate-100', 'text-slate-700', 'hover:bg-slate-200');
                activeBtn.classList.add('bg-blue-600', 'text-white');
            }

            // 예약 카드 필터링
            let visibleCount = 0;
            reservationCards.forEach(card => {
                if (status === 'all') {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    if (card.dataset.status === status) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                }
            });

            // 필터링 결과가 없을 때 메시지 표시
            const reservationList = document.getElementById('reservationList');
            let noResultMsg = document.getElementById('noResultMessage');

            if (visibleCount === 0) {
                if (!noResultMsg) {
                    noResultMsg = document.createElement('div');
                    noResultMsg.id = 'noResultMessage';
                    noResultMsg.className = 'text-center py-12 text-slate-500';
                    noResultMsg.innerHTML = '<div class="text-4xl mb-3">🔍</div><p class="text-lg font-medium">해당 상태의 예약이 없습니다.</p>';
                    reservationList.appendChild(noResultMsg);
                }
                noResultMsg.style.display = 'block';
            } else {
                if (noResultMsg) {
                    noResultMsg.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>
