<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약 통계</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" scope="request" value="course" />
<div class="min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <c:set var="subNavBase" value="px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition" />
        <c:set var="subNavActive" value="px-3 py-2 text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg border border-blue-100" />
        <div class="px-4 py-6 sm:px-0">
            <div class="flex flex-col gap-4 mb-6">
                <h2 class="text-2xl font-bold text-gray-900">예약 통계</h2>
                <div class="flex flex-wrap items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/course-management"
                       class="${subNavBase}">코스 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/course-reservation"
                       class="${subNavBase}">예약 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/reservation-statistics"
                       class="${subNavActive}">예약 통계</a>
                    <a href="${pageContext.request.contextPath}/admin/course-statistics"
                       class="${subNavBase}">코스 통계</a>
                </div>
            </div>

            <!-- 통계 카드들 -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-blue-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">총 예약 수</dt>
                                <dd class="text-2xl font-bold text-gray-900">${statistics.total}</dd>
                            </dl>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">확정 예약</dt>
                                <dd class="text-2xl font-bold text-gray-900">${statistics.confirmed}</dd>
                            </dl>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-yellow-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">대기 중</dt>
                                <dd class="text-2xl font-bold text-gray-900">${statistics.pending}</dd>
                            </dl>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-purple-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">확정 매출</dt>
                                <dd class="text-2xl font-bold text-gray-900"><fmt:formatNumber value="${statistics.confirmedRevenue}" type="currency" currencySymbol="₩"/></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 예약 목록 -->
            <div class="bg-white shadow overflow-hidden sm:rounded-md">
                <div class="px-4 py-5 sm:px-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">최근 예약 내역</h3>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">최근 10건의 예약 현황을 확인할 수 있습니다.</p>
                </div>
                <div class="border-t border-gray-200">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">예약일</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">코스명</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">예약자</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">인원</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">금액</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${empty recentReservations}">
                                    <tr>
                                        <td colspan="6" class="px-6 py-4 text-center text-sm text-gray-500">
                                            예약 데이터가 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="reservation" items="${recentReservations}">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                                ${reservation.reservationDate}
                                            </td>
                                            <td class="px-6 py-4 text-sm text-gray-900">
                                                ${reservation.courseTitle}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                                ${reservation.participantName}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                                ${reservation.participantCount}명
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                                <fmt:formatNumber value="${reservation.totalPrice}" type="currency" currencySymbol="₩"/>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <c:choose>
                                                    <c:when test="${reservation.status == 'PENDING'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">대기</span>
                                                    </c:when>
                                                    <c:when test="${reservation.status == 'CONFIRMED'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">확정</span>
                                                    </c:when>
                                                    <c:when test="${reservation.status == 'COMPLETED'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">완료</span>
                                                    </c:when>
                                                    <c:when test="${reservation.status == 'CANCELLED'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">취소</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>

<jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>
