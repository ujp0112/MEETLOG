<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

                <c:if test="${not empty reservations}">
                    <c:set var="totalReservations" value="${fn:length(reservations)}" />
                    <c:set var="pendingCount" value="0" />
                    <c:set var="confirmedCount" value="0" />
                    <c:set var="completedCount" value="0" />
                    <c:set var="cancelledCount" value="0" />
                    <c:forEach var="reservation" items="${reservations}">
                        <c:choose>
                            <c:when test="${reservation.status == 'PENDING'}">
                                <c:set var="pendingCount" value="${pendingCount + 1}" />
                            </c:when>
                            <c:when test="${reservation.status == 'CONFIRMED'}">
                                <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                            </c:when>
                            <c:when test="${reservation.status == 'COMPLETED'}">
                                <c:set var="completedCount" value="${completedCount + 1}" />
                            </c:when>
                            <c:when test="${reservation.status == 'CANCELLED'}">
                                <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 mb-6">
                        <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                            <p class="text-sm text-slate-500">전체 예약</p>
                            <p class="mt-2 text-2xl font-semibold text-slate-900">${totalReservations}</p>
                        </div>
                        <div class="rounded-xl border border-yellow-100 bg-yellow-50 p-5 shadow-sm">
                            <p class="text-sm text-yellow-600">대기중</p>
                            <p class="mt-2 text-2xl font-semibold text-yellow-700">${pendingCount}</p>
                        </div>
                        <div class="rounded-xl border border-green-100 bg-green-50 p-5 shadow-sm">
                            <p class="text-sm text-green-600">확정</p>
                            <p class="mt-2 text-2xl font-semibold text-green-700">${confirmedCount}</p>
                        </div>
                        <div class="rounded-xl border border-blue-100 bg-blue-50 p-5 shadow-sm">
                            <p class="text-sm text-blue-600">방문 완료</p>
                            <p class="mt-2 text-2xl font-semibold text-blue-700">${completedCount}</p>
                        </div>
                        <div class="rounded-xl border border-red-100 bg-red-50 p-5 shadow-sm">
                            <p class="text-sm text-red-600">취소</p>
                            <p class="mt-2 text-2xl font-semibold text-red-700">${cancelledCount}</p>
                        </div>
                    </div>
                </c:if>

                <!-- 예약 목록 -->
                <div class="bg-white rounded-xl shadow-lg">
                    <div class="p-6 border-b border-slate-200">
                        <h3 class="text-lg font-semibold text-slate-800">예약 목록</h3>
                    </div>

                    <!-- 필터 버튼 그룹 -->
                    <c:if test="${not empty reservations}">
                        <div class="px-6 py-4 border-b border-slate-200">
                            <div class="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
                                <div class="order-2 flex flex-wrap gap-2 lg:order-1">
                                    <button type="button" onclick="filterReservations('all')"
                                            class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-blue-600 text-white"
                                            data-filter="all">
                                        전체
                                    </button>
                                    <button type="button" onclick="filterReservations('PENDING')"
                                            class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                            data-filter="PENDING">
                                        🟡 대기중
                                    </button>
                                    <button type="button" onclick="filterReservations('CONFIRMED')"
                                            class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                            data-filter="CONFIRMED">
                                        🟢 확정
                                    </button>
                                    <button type="button" onclick="filterReservations('COMPLETED')"
                                            class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                            data-filter="COMPLETED">
                                        🔵 완료
                                    </button>
                                    <button type="button" onclick="filterReservations('CANCELLED')"
                                            class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                            data-filter="CANCELLED">
                                        🔴 취소
                                    </button>
                                </div>
                                <div class="order-1 flex w-full flex-col gap-3 sm:flex-row sm:items-center lg:order-2 lg:w-auto">
                                    <div class="relative flex-1 sm:flex-initial sm:min-w-[220px]">
                                        <input type="search"
                                               id="reservationSearchInput"
                                               placeholder="고객명, 연락처, 메모 검색"
                                               class="w-full rounded-lg border border-slate-200 px-3 py-2 text-sm text-slate-700 focus:border-sky-500 focus:outline-none focus:ring-2 focus:ring-sky-200" />
                                    </div>
                                    <div>
                                        <input type="date"
                                               id="reservationDateFilter"
                                               class="rounded-lg border border-slate-200 px-3 py-2 text-sm text-slate-700 focus:border-sky-500 focus:outline-none focus:ring-2 focus:ring-sky-200" />
                                    </div>
                                    <button type="button"
                                            id="resetReservationFilters"
                                            class="rounded-lg border border-slate-200 px-3 py-2 text-sm font-medium text-slate-600 transition hover:border-sky-400 hover:text-sky-600">
                                        필터 초기화
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="p-6">
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <div id="reservationList" class="space-y-4">
                                    <c:forEach var="reservation" items="${reservations}">
                                        <c:set var="rawReservationTime" value="${not empty reservation.reservationTimeStr ? reservation.reservationTimeStr : reservation.reservationTime}" />
                                        <c:set var="normalizedReservationTime" value="${not empty rawReservationTime ? fn:replace(rawReservationTime, 'T', ' ') : ''}" />
                                        <c:set var="reservationDateKey" value="" />
                                        <c:if test="${not empty normalizedReservationTime && fn:length(normalizedReservationTime) >= 10}">
                                            <c:set var="reservationDateKey" value="${fn:substring(normalizedReservationTime, 0, 10)}" />
                                        </c:if>
                                        <c:set var="statusLabel" value="${reservation.status}" />
                                        <c:set var="statusClass" value="bg-slate-100 text-slate-700" />
                                        <c:choose>
                                            <c:when test="${reservation.status == 'PENDING'}">
                                                <c:set var="statusLabel" value="대기중" />
                                                <c:set var="statusClass" value="bg-yellow-100 text-yellow-700" />
                                            </c:when>
                                            <c:when test="${reservation.status == 'CONFIRMED'}">
                                                <c:set var="statusLabel" value="확정" />
                                                <c:set var="statusClass" value="bg-green-100 text-green-700" />
                                            </c:when>
                                            <c:when test="${reservation.status == 'COMPLETED'}">
                                                <c:set var="statusLabel" value="방문 완료" />
                                                <c:set var="statusClass" value="bg-blue-100 text-blue-700" />
                                            </c:when>
                                            <c:when test="${reservation.status == 'CANCELLED'}">
                                                <c:set var="statusLabel" value="취소됨" />
                                                <c:set var="statusClass" value="bg-red-100 text-red-700" />
                                            </c:when>
                                        </c:choose>

                                        <div class="reservation-card rounded-xl border border-slate-200 p-5 shadow-sm transition hover:border-sky-200 hover:bg-slate-50"
                                             data-status="${reservation.status}"
                                             data-customer="<c:out value='${reservation.customerName}'/>"
                                             data-phone="<c:out value='${reservation.contactPhone}'/>"
                                             data-requests="<c:out value='${reservation.specialRequests}'/>"
                                             data-date="${reservationDateKey}">
                                            <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                                                <div class="flex-1 space-y-4">
                                                    <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                                                        <div class="space-y-1">
                                                            <h4 class="text-lg font-semibold text-slate-900">${reservation.customerName}</h4>
                                                            <p class="text-sm text-slate-500">예약 ID #${reservation.id}</p>
                                                        </div>
                                                        <span class="inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold ${statusClass}">
                                                            ${statusLabel}
                                                        </span>
                                                    </div>

                                                    <dl class="grid gap-x-6 gap-y-2 text-sm text-slate-600 sm:grid-cols-2">
                                                        <div>
                                                            <dt class="font-medium text-slate-500">예약 일시</dt>
                                                            <dd class="text-slate-800">
                                                                <c:choose>
                                                                    <c:when test="${not empty normalizedReservationTime}">
                                                                        ${normalizedReservationTime}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        -
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                        </div>
                                                        <div>
                                                            <dt class="font-medium text-slate-500">인원</dt>
                                                            <dd class="text-slate-800">${reservation.partySize}명</dd>
                                                        </div>
                                                        <div>
                                                            <dt class="font-medium text-slate-500">연락처</dt>
                                                            <dd class="text-slate-800">
                                                                <c:choose>
                                                                    <c:when test="${not empty reservation.contactPhone}">
                                                                        ${reservation.contactPhone}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        -
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                        </div>
                                                        <div>
                                                            <dt class="font-medium text-slate-500">예약 등록</dt>
                                                            <dd class="text-slate-800">
                                                                <c:choose>
                                                                    <c:when test="${reservation.createdAtAsDate ne null}">
                                                                        <fmt:formatDate value="${reservation.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" />
                                                                    </c:when>
                                                                    <c:otherwise>-</c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                        </div>
                                                    </dl>

                                                    <c:if test="${not empty reservation.specialRequests}">
                                                        <div class="rounded-lg bg-sky-50 p-3 text-sm text-sky-700">
                                                            <p class="font-medium text-sky-800">고객 메모</p>
                                                            <p class="mt-1 leading-relaxed">${reservation.specialRequests}</p>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${reservation.status == 'CANCELLED'}">
                                                        <div class="rounded-lg bg-red-50 p-3 text-sm text-red-700">
                                                            <p class="font-medium text-red-800">취소 정보</p>
                                                            <c:if test="${not empty reservation.cancelReason}">
                                                                <p class="mt-1 leading-relaxed">${reservation.cancelReason}</p>
                                                            </c:if>
                                                            <c:if test="${reservation.cancelledAtAsDate ne null}">
                                                                <p class="mt-2 text-xs text-red-600">취소일: <fmt:formatDate value="${reservation.cancelledAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <div class="flex flex-wrap items-start gap-2 md:justify-end">
                                                    <c:choose>
                                                        <c:when test="${reservation.status == 'PENDING'}">
                                                            <button type="button"
                                                                    class="rounded-lg bg-green-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-green-700"
                                                                    data-action="confirm" data-reservation-id="${reservation.id}">
                                                                확정 처리
                                                            </button>
                                                            <button type="button"
                                                                    class="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-red-700"
                                                                    data-action="cancel" data-reservation-id="${reservation.id}">
                                                                예약 취소
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${reservation.status == 'CONFIRMED'}">
                                                            <button type="button"
                                                                    class="rounded-lg bg-sky-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-sky-700"
                                                                    data-action="complete" data-reservation-id="${reservation.id}">
                                                                방문 완료 처리
                                                            </button>
                                                            <button type="button"
                                                                    class="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-red-700"
                                                                    data-action="cancel" data-reservation-id="${reservation.id}">
                                                                예약 취소
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${reservation.status == 'COMPLETED'}">
                                                            <span class="inline-flex items-center rounded-lg bg-slate-100 px-3 py-1 text-sm font-medium text-slate-600">
                                                                방문 완료 상태
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${reservation.status == 'CANCELLED'}">
                                                            <span class="inline-flex items-center rounded-lg bg-red-100 px-3 py-1 text-sm font-medium text-red-600">
                                                                취소됨
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center rounded-lg bg-slate-100 px-3 py-1 text-sm font-medium text-slate-600">
                                                                상태: ${reservation.status}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
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
        let activeStatus = 'ALL';
        const reservationList = document.getElementById('reservationList');
        const searchInput = document.getElementById('reservationSearchInput');
        const dateFilter = document.getElementById('reservationDateFilter');
        const resetFiltersBtn = document.getElementById('resetReservationFilters');
        const filterButtons = document.querySelectorAll('.filter-btn');

        function updateFilterButtonStyles() {
            filterButtons.forEach(btn => {
                const target = (btn.dataset.filter || '').toUpperCase();
                if (target === activeStatus) {
                    btn.classList.remove('bg-slate-100', 'text-slate-700', 'hover:bg-slate-200');
                    btn.classList.add('bg-blue-600', 'text-white');
                } else {
                    btn.classList.remove('bg-blue-600', 'text-white');
                    btn.classList.add('bg-slate-100', 'text-slate-700', 'hover:bg-slate-200');
                }
            });
        }

        function filterReservations(status) {
            activeStatus = (status || 'all').toUpperCase();
            updateFilterButtonStyles();
            applyReservationFilters();
        }

        function applyReservationFilters() {
            if (!reservationList) {
                return;
            }

            const cards = reservationList.querySelectorAll('.reservation-card');
            const query = searchInput ? searchInput.value.trim().toLowerCase() : '';
            const selectedDate = dateFilter ? dateFilter.value : '';
            let visibleCount = 0;

            cards.forEach(card => {
                const cardStatus = (card.dataset.status || '').toUpperCase();
                const matchesStatus = activeStatus === 'ALL' || cardStatus === activeStatus;

                const concatenatedText = [
                    card.dataset.customer || '',
                    card.dataset.phone || '',
                    card.dataset.requests || ''
                ].join(' ').toLowerCase();
                const matchesQuery = !query || concatenatedText.includes(query);

                const cardDate = card.dataset.date || '';
                const matchesDate = !selectedDate || cardDate === selectedDate;

                if (matchesStatus && matchesQuery && matchesDate) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            let noResultMsg = document.getElementById('noResultMessage');
            if (visibleCount === 0 && cards.length > 0) {
                if (!noResultMsg) {
                    noResultMsg = document.createElement('div');
                    noResultMsg.id = 'noResultMessage';
                    noResultMsg.className = 'text-center py-12 text-slate-500';
                    noResultMsg.innerHTML = '<div class="text-4xl mb-3">🔍</div><p class="text-lg font-medium">조건에 맞는 예약이 없습니다.</p>';
                    reservationList.appendChild(noResultMsg);
                }
                noResultMsg.style.display = 'block';
            } else if (noResultMsg) {
                noResultMsg.style.display = 'none';
            }
        }

        if (searchInput) {
            searchInput.addEventListener('input', () => applyReservationFilters());
        }

        if (dateFilter) {
            dateFilter.addEventListener('change', () => applyReservationFilters());
        }

        if (resetFiltersBtn) {
            resetFiltersBtn.addEventListener('click', () => {
                if (searchInput) {
                    searchInput.value = '';
                }
                if (dateFilter) {
                    dateFilter.value = '';
                }
                filterReservations('all');
            });
        }

        window.addEventListener('DOMContentLoaded', () => {
            updateFilterButtonStyles();
            applyReservationFilters();
        });
    </script>
</body>
</html>
