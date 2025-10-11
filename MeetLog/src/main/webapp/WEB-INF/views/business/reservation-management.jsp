<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 관리 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-success:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(16, 185, 129, 0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .status-pending { background-color: #fef9c3; color: #a16207; }
        .status-confirmed { background-color: #dcfce7; color: #166534; }
        .status-cancelled { background-color: #fee2e2; color: #991b1b; }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl">
            <div class="mb-8">
                <h1 class="text-3xl font-bold gradient-text">예약 관리</h1>
                <p class="text-slate-600 mt-2">매장별 예약 현황을 확인하고 관리하세요</p>
            </div>

            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-3 xl:grid-cols-6 gap-6 mb-8">
                <div class="bg-blue-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('ALL')">
                    <div class="text-3xl font-bold text-blue-600" id="totalCount">0</div>
                    <div class="text-slate-600">총 예약</div>
                </div>
                <div class="bg-yellow-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('PENDING')">
                    <div class="text-3xl font-bold text-yellow-600" id="pendingCount">0</div>
                    <div class="text-slate-600">대기중</div>
                </div>
                <div class="bg-green-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('CONFIRMED')">
                    <div class="text-3xl font-bold text-green-600" id="confirmedCount">0</div>
                    <div class="text-slate-600">확정</div>
                </div>
                <div class="bg-red-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('CANCELLED')">
                    <div class="text-3xl font-bold text-red-600" id="cancelledCount">0</div>
                    <div class="text-slate-600">취소</div>
                </div>
                <div class="bg-emerald-50 p-6 rounded-xl text-center">
                    <div class="text-3xl font-bold text-emerald-600" id="depositPaidCount">${depositPaidCount}</div>
                    <div class="text-slate-600">예약금 결제 완료</div>
                    <p class="text-xs text-emerald-700 mt-2">총 수납: <span id="depositPaidAmount"><fmt:formatNumber value="${paidDepositAmount}" pattern="#,##0"/></span>원</p>
                    <p class="text-xs text-slate-500 mt-1">전체 예약금: <span id="totalDepositAmount"><fmt:formatNumber value="${totalDepositAmount}" pattern="#,##0"/></span>원</p>
                </div>
                <div class="bg-amber-50 p-6 rounded-xl text-center">
                    <div class="text-3xl font-bold text-amber-600" id="depositPendingCount">${depositPendingCount}</div>
                    <div class="text-slate-600">예약금 결제 대기</div>
                    <p class="text-xs text-amber-700 mt-2">미수금: <span id="depositOutstandingAmount"><fmt:formatNumber value="${outstandingDepositAmount}" pattern="#,##0"/></span>원</p>
                </div>
            </div>

            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty myRestaurants}">
                        <c:forEach var="restaurant" items="${myRestaurants}">
                            <div class="restaurant-section" <c:if test="${empty restaurant.reservationList}">style="display:none;"</c:if>>
                                <h2 class="text-2xl font-semibold text-slate-800 mb-4">${restaurant.name}의 예약 목록</h2>
                                <div class="reservation-list" data-restaurant-id="${restaurant.id}">
                                    <c:forEach var="reservation" items="${restaurant.reservationList}">
                                        <div class="reservation-card glass-card p-6 rounded-2xl card-hover mb-4" data-status="${reservation.status}"
                                             data-payment-status="${empty reservation.paymentStatus ? 'NONE' : reservation.paymentStatus}"
                                             data-deposit-required="${reservation.depositRequired}"
                                             data-deposit-amount="${reservation.depositAmount != null ? reservation.depositAmount : 0}">
                                            <div class="flex items-start justify-between mb-4">
                                                <div class="flex-1">
                                                    <h3 class="text-xl font-bold text-slate-800">${reservation.userName}님의 예약</h3>
                                                    <p class="text-slate-600">연락처: ${reservation.contactPhone}</p>
                                                </div>
                                                <div class="text-right">
                                                    <span class="px-4 py-2 rounded-full text-sm font-semibold
                                                        status-${fn:toLowerCase(reservation.status)}">
                                                        ${reservation.status == 'PENDING' ? '대기중' : 
                                                          (reservation.status == 'CONFIRMED' ? '확정' : '취소')}
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                                                <c:set var="dateTimeParts" value="${fn:split(reservation.reservationTime, 'T')}" />
                                                <c:set var="datePart" value="${dateTimeParts[0]}" />
                                                <c:set var="timePart" value="${fn:substring(dateTimeParts[1], 0, 5)}" />
                                                
                                                <div class="p-4 bg-slate-50 rounded-xl">
                                                    <p class="text-sm text-slate-600">예약 날짜</p>
                                                    <p class="font-semibold text-slate-800">${datePart}</p>
                                                </div>
                                                <div class="p-4 bg-slate-50 rounded-xl">
                                                    <p class="text-sm text-slate-600">예약 시간</p>
                                                    <p class="font-semibold text-slate-800">${timePart}</p>
                                                </div>
                                                <div class="p-4 bg-slate-50 rounded-xl">
                                                    <p class="text-sm text-slate-600">인원</p>
                                                    <p class="font-semibold text-slate-800">${reservation.partySize}명</p>
                                                </div>
                                            </div>

                                            <c:if test="${not empty reservation.specialRequests}">
                                                <div class="p-4 bg-blue-50 rounded-xl mb-4">
                                                    <p class="text-sm text-blue-600 font-semibold">특별 요청사항</p>
                                                    <p class="text-blue-800">${reservation.specialRequests}</p>
                                                </div>
                                            </c:if>

                                            <c:choose>
                                                <c:when test="${reservation.depositRequired}">
                                                    <div class="p-4 rounded-xl mb-4 border ${reservation.paymentStatus == 'PAID' ? 'bg-emerald-50 border-emerald-200' : 'bg-amber-50 border-amber-200'}">
                                                        <div class="flex items-start justify-between">
                                                            <div>
                                                                <p class="text-sm text-slate-600">예약금</p>
                                                                <p class="font-semibold text-slate-800">
                                                                    <fmt:formatNumber value="${reservation.depositAmount}" pattern="#,##0"/>원
                                                                </p>
                                                                <c:if test="${not empty reservation.paymentProvider}">
                                                                    <span class="mt-2 inline-block px-3 py-1 rounded-full text-xs font-semibold text-slate-600 bg-white border border-slate-200">${reservation.paymentProvider}</span>
                                                                </c:if>
                                                            </div>
                                                            <div class="text-right">
                                                                <c:choose>
                                                                    <c:when test="${reservation.paymentStatus == 'PAID'}">
                                                                        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold text-emerald-700 bg-emerald-100">결제 완료</span>
                                                                        <c:if test="${reservation.paymentApprovedAt != null}">
                                                                            <c:set var="paidDateTimeParts" value="${fn:split(reservation.paymentApprovedAt, 'T')}" />
                                                                            <div class="text-xs text-emerald-700 mt-2">
                                                                                승인: ${paidDateTimeParts[0]} ${fn:length(paidDateTimeParts) > 1 ? fn:substring(paidDateTimeParts[1],0,5) : ''}
                                                                            </div>
                                                                        </c:if>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold text-amber-700 bg-amber-100">
                                                                            ${reservation.paymentStatus == 'FAILED' ? '결제 실패' : '결제 대기'}
                                                                        </span>
                                                                        <c:if test="${reservation.paymentStatus == 'FAILED'}">
                                                                            <div class="text-xs text-amber-700 mt-2">재결제나 안내가 필요합니다.</div>
                                                                        </c:if>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="p-4 bg-slate-50 rounded-xl mb-4">
                                                        <p class="text-sm text-slate-500">이 예약은 예약금이 필요하지 않습니다.</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- 쿠폰 정보 표시 -->
                                            <c:if test="${not empty reservation.userCouponId and reservation.userCouponId > 0}">
                                                <div class="p-4 rounded-xl mb-4 border ${reservation.couponIsUsed ? 'bg-slate-50 border-slate-200' : 'bg-purple-50 border-purple-200'}">
                                                    <div class="flex items-start justify-between">
                                                        <div>
                                                            <p class="text-sm ${reservation.couponIsUsed ? 'text-slate-600' : 'text-purple-600'} font-semibold">쿠폰 정보</p>
                                                            <p class="font-semibold ${reservation.couponIsUsed ? 'text-slate-800' : 'text-purple-800'}">
                                                                ${reservation.couponName}
                                                            </p>
                                                            <p class="text-sm ${reservation.couponIsUsed ? 'text-slate-600' : 'text-purple-700'} mt-1">
                                                                할인: <fmt:formatNumber value="${reservation.couponDiscountAmount}" pattern="#,##0"/>원
                                                                <c:if test="${reservation.couponDiscountType == 'PERCENTAGE'}"> (%)</c:if>
                                                            </p>
                                                        </div>
                                                        <div class="text-right">
                                                            <c:choose>
                                                                <c:when test="${reservation.couponIsUsed}">
                                                                    <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold text-slate-700 bg-slate-200">사용 완료</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold text-purple-700 bg-purple-100">사용 대기</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <div class="flex space-x-2">
                                                <c:if test="${reservation.status == 'PENDING'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/business/reservation/update-status" style="display: inline;">
                                                        <input type="hidden" name="reservationId" value="${reservation.id}">
                                                        <input type="hidden" name="status" value="CONFIRMED">
                                                        <button type="submit" class="btn-success text-white px-4 py-2 rounded-lg text-sm">확정</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/business/reservation/update-status" style="display: inline;">
                                                        <input type="hidden" name="reservationId" value="${reservation.id}">
                                                        <input type="hidden" name="status" value="CANCELLED">
                                                        <button type="submit" class="btn-danger text-white px-4 py-2 rounded-lg text-sm">거절</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${reservation.status == 'CONFIRMED'}">
                                                     <form method="post" action="${pageContext.request.contextPath}/business/reservation/update-status" style="display: inline;">
                                                        <input type="hidden" name="reservationId" value="${reservation.id}">
                                                        <input type="hidden" name="status" value="COMPLETED">
                                                        <button type="submit" class="text-white px-4 py-2 rounded-lg text-sm" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);">완료</button>
                                                    </form>
                                                    <!-- 쿠폰 사용 완료 버튼 -->
                                                    <c:if test="${not empty reservation.userCouponId and reservation.userCouponId > 0 and not reservation.couponIsUsed}">
                                                        <form method="post" action="${pageContext.request.contextPath}/business/reservation/use-coupon" style="display: inline;">
                                                            <input type="hidden" name="userCouponId" value="${reservation.userCouponId}">
                                                            <input type="hidden" name="reservationId" value="${reservation.id}">
                                                            <button type="submit" class="text-white px-4 py-2 rounded-lg text-sm" style="background: linear-gradient(135deg, #9333ea 0%, #7e22ce 100%);">쿠폰 사용 완료</button>
                                                        </form>
                                                    </c:if>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/reservation/detail/${reservation.id}"
       class="bg-slate-500 hover:bg-slate-600 text-white px-4 py-2 rounded-lg text-sm">상세보기</a>

                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">📅</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">예약이 없습니다</h3>
                            <p class="text-slate-500">아직 예약이 없습니다. 음식점을 등록하고 홍보해보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            calculateStats();
        });

        function formatCurrency(value) {
            const numeric = Number.isFinite(value) ? value : Number(value) || 0;
            return new Intl.NumberFormat('ko-KR').format(Math.max(0, Math.floor(numeric)));
        }

        function calculateStats() {
            const allCards = document.querySelectorAll('.reservation-card');
            let total = 0, pending = 0, confirmed = 0, cancelled = 0;
            let depositPaid = 0, depositPending = 0;
            let totalDeposit = 0, paidDeposit = 0, outstandingDeposit = 0;

            allCards.forEach(card => {
                total++;
                const status = card.dataset.status;
                if (status === 'PENDING') pending++;
                else if (status === 'CONFIRMED') confirmed++;
                else if (status === 'CANCELLED') cancelled++;

                const depositRequired = card.dataset.depositRequired === 'true';
                if (!depositRequired) {
                    return;
                }

                const amount = Number(card.dataset.depositAmount || 0);
                if (amount <= 0) {
                    return;
                }
                totalDeposit += amount;

                const paymentStatus = (card.dataset.paymentStatus || '').toUpperCase();
                if (paymentStatus === 'PAID') {
                    depositPaid++;
                    paidDeposit += amount;
                } else {
                    depositPending++;
                    outstandingDeposit += amount;
                }
            });

            document.getElementById('totalCount').textContent = total;
            document.getElementById('pendingCount').textContent = pending;
            document.getElementById('confirmedCount').textContent = confirmed;
            document.getElementById('cancelledCount').textContent = cancelled;

            const depositPaidCountEl = document.getElementById('depositPaidCount');
            const depositPendingCountEl = document.getElementById('depositPendingCount');
            if (depositPaidCountEl) depositPaidCountEl.textContent = depositPaid;
            if (depositPendingCountEl) depositPendingCountEl.textContent = depositPending;

            const paidAmountEl = document.getElementById('depositPaidAmount');
            const outstandingAmountEl = document.getElementById('depositOutstandingAmount');
            const totalDepositAmountEl = document.getElementById('totalDepositAmount');
            if (paidAmountEl) paidAmountEl.textContent = formatCurrency(paidDeposit);
            if (outstandingAmountEl) outstandingAmountEl.textContent = formatCurrency(outstandingDeposit);
            if (totalDepositAmountEl) totalDepositAmountEl.textContent = formatCurrency(totalDeposit);
        }

        function filterByStatus(status) {
            document.querySelectorAll('.restaurant-section').forEach(section => {
                const reservationList = section.querySelector('.reservation-list');
                let visibleCount = 0;

                reservationList.querySelectorAll('.reservation-card').forEach(card => {
                    const cardStatus = card.dataset.status;
                    if (status === 'ALL' || cardStatus === status) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });

                if (visibleCount > 0) {
                    section.style.display = 'block';
                } else {
                    section.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
