<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약 관리</title>
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
                <h2 class="text-2xl font-bold text-gray-900">예약 관리</h2>
                <div class="flex flex-wrap items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/course-management"
                       class="${subNavBase}">코스 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/course-reservation"
                       class="${subNavActive}">예약 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/reservation-statistics"
                       class="${subNavBase}">예약 통계</a>
                    <a href="${pageContext.request.contextPath}/admin/course-statistics"
                       class="${subNavBase}">코스 통계</a>
                </div>
            </div>

            <!-- 필터 -->
            <div class="bg-white shadow rounded-lg p-4 mb-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">예약 상태</label>
                        <select class="w-full border border-gray-300 rounded-md px-3 py-2">
                            <option value="">전체</option>
                            <option value="CONFIRMED">확정</option>
                            <option value="PENDING">대기</option>
                            <option value="CANCELLED">취소</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">코스</label>
                        <select class="w-full border border-gray-300 rounded-md px-3 py-2">
                            <option value="">전체 코스</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">예약일</label>
                        <input type="date" class="w-full border border-gray-300 rounded-md px-3 py-2">
                    </div>
                    <div class="flex items-end">
                        <button class="w-full bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition">
                            검색
                        </button>
                    </div>
                </div>
            </div>

            <!-- 상태별 탭 -->
            <div class="mb-6">
                <div class="border-b border-gray-200">
                    <nav class="-mb-px flex space-x-8">
                        <a href="?status=" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${empty currentStatus ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            전체 (${statistics.total})
                        </a>
                        <a href="?status=PENDING" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'PENDING' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            대기 중 (${statistics.pending})
                        </a>
                        <a href="?status=CONFIRMED" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'CONFIRMED' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            확정 (${statistics.confirmed})
                        </a>
                        <a href="?status=COMPLETED" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'COMPLETED' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            완료 (${statistics.completed})
                        </a>
                        <a href="?status=CANCELLED" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'CANCELLED' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            취소 (${statistics.cancelled})
                        </a>
                    </nav>
                </div>
            </div>

            <!-- 예약 목록 -->
            <div class="bg-white shadow overflow-hidden sm:rounded-md">
                <div class="px-4 py-5 sm:px-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">예약 목록</h3>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">코스 예약 현황을 확인하고 관리할 수 있습니다.</p>
                </div>
                <div class="border-t border-gray-200">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">예약번호</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">코스명</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">예약자</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">예약일시</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">인원/금액</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${empty reservations}">
                                    <tr>
                                        <td colspan="7" class="px-6 py-8 text-center text-sm text-gray-500">
                                            예약 데이터가 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="reservation" items="${reservations}">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">#${reservation.reservationId}</td>
                                            <td class="px-6 py-4 text-sm text-gray-900">${reservation.courseTitle}</td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm font-medium text-gray-900">${reservation.participantName}</div>
                                                <div class="text-sm text-gray-500">${reservation.phone}</div>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm text-gray-900">${reservation.reservationDate}</div>
                                                <div class="text-sm text-gray-500">${reservation.reservationTime}</div>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-gray-700">
                                                ${reservation.participantCount}명 / <fmt:formatNumber value="${reservation.totalPrice}" type="currency" currencySymbol="₩"/>
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
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <c:if test="${reservation.status == 'PENDING'}">
                                                    <form method="post" class="inline-flex space-x-2">
                                                        <input type="hidden" name="reservationId" value="${reservation.reservationId}" />
                                                        <button type="submit" name="action" value="confirm"
                                                                onclick="return confirm('예약을 확정하시겠습니까?')"
                                                                class="px-3 py-1.5 bg-green-600 text-white text-xs rounded hover:bg-green-700">
                                                            확정
                                                        </button>
                                                        <button type="submit" name="action" value="cancel"
                                                                onclick="return confirm('예약을 취소하시겠습니까?')"
                                                                class="px-3 py-1.5 bg-red-600 text-white text-xs rounded hover:bg-red-700">
                                                            취소
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${reservation.status == 'CONFIRMED'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="reservationId" value="${reservation.reservationId}" />
                                                        <button type="submit" name="action" value="complete"
                                                                onclick="return confirm('예약을 완료 처리하시겠습니까?')"
                                                                class="px-3 py-1.5 bg-blue-600 text-white text-xs rounded hover:bg-blue-700">
                                                            완료 처리
                                                        </button>
                                                    </form>
                                                </c:if>
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
