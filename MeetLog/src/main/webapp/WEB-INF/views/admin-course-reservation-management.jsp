<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 코스 예약 관리</title>
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
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <h2 class="text-2xl font-bold text-gray-900">코스 예약 관리</h2>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/course-management"
                       class="${subNavBase}">코스 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/course-reservation"
                       class="${subNavActive}">예약 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/course-statistics"
                       class="${subNavBase}">코스 통계</a>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="mb-4 px-4 py-3 rounded-lg bg-green-50 text-green-700 border border-green-200">
                    ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="mb-4 px-4 py-3 rounded-lg bg-red-50 text-red-700 border border-red-200">
                    ${errorMessage}
                </div>
            </c:if>

            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">예약일</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">코스명</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">예약자</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">연락처</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">인원</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">금액</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">상태</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">처리</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="reservation" items="${reservations}">
                                <tr>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">${reservation.reservationDate}</td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${reservation.courseTitle}</td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">${reservation.userName}</td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">${reservation.phone}</td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">${reservation.participantCount}명</td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700"><fmt:formatNumber value="${reservation.totalPrice}" type="currency" currencySymbol="₩"/></td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${reservation.status == 'CONFIRMED' ? 'bg-green-100 text-green-800' : reservation.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' : reservation.status == 'COMPLETED' ? 'bg-blue-100 text-blue-800' : 'bg-red-100 text-red-800'}">
                                            ${reservation.statusLabel}
                                        </span>
                                    </td>
                                    <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">
                                        <form method="post" class="flex flex-wrap gap-2 items-center">
                                            <input type="hidden" name="id" value="${reservation.id}" />
                                            <button name="action" value="confirm"
                                                    class="px-3 py-2 text-xs font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700"
                                                    type="submit">확정</button>
                                            <button name="action" value="complete"
                                                    class="px-3 py-2 text-xs font-medium rounded-md text-white bg-green-600 hover:bg-green-700"
                                                    type="submit">완료</button>
                                            <button name="action" value="cancel"
                                                    class="px-3 py-2 text-xs font-medium rounded-md text-gray-700 bg-gray-100 hover:bg-gray-200"
                                                    type="submit">
                                                취소
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
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
