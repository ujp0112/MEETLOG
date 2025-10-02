<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>코스 예약 관리 - MEET LOG</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-6 py-10">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">코스 예약 관리</h1>

        <c:if test="${not empty successMessage}">
            <div class="mb-4 px-4 py-3 rounded bg-green-50 text-green-700 border border-green-200">
                ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="mb-4 px-4 py-3 rounded bg-red-50 text-red-700 border border-red-200">
                ${errorMessage}
            </div>
        </c:if>

        <div class="bg-white rounded-xl shadow overflow-hidden">
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
                    <c:choose>
                        <c:when test="${not empty reservations}">
                            <c:forEach var="reservation" items="${reservations}">
                                <tr>
                                    <td class="px-4 py-3 text-sm text-gray-700">
                                        <fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd"/>
                                        <br />
                                        <span class="text-xs text-gray-500">
                                            <fmt:formatDate value="${reservation.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-800 font-semibold">${reservation.courseTitle}</td>
                                    <td class="px-4 py-3 text-sm text-gray-700">${reservation.participantName}</td>
                                    <td class="px-4 py-3 text-sm text-gray-700">
                                        <div>${reservation.phone}</div>
                                        <div class="text-xs text-gray-500">${reservation.email}</div>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-700">${reservation.participantCount}명</td>
                                    <td class="px-4 py-3 text-sm text-gray-700">
                                        <fmt:formatNumber value="${reservation.totalPrice}" type="number"/>원
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold
                                            <c:choose>
                                                <c:when test="${reservation.status == 'CONFIRMED'}">bg-green-100 text-green-700</c:when>
                                                <c:when test="${reservation.status == 'COMPLETED'}">bg-blue-100 text-blue-700</c:when>
                                                <c:when test="${reservation.status == 'CANCELLED'}">bg-red-100 text-red-700</c:when>
                                                <c:otherwise>bg-yellow-100 text-yellow-700</c:otherwise>
                                            </c:choose>">
                                            ${reservation.status}
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-700 space-y-2">
                                        <form method="post" class="inline">
                                            <input type="hidden" name="id" value="${reservation.id}" />
                                            <input type="hidden" name="action" value="confirm" />
                                            <button type="submit" class="px-3 py-1 rounded bg-green-500 text-white text-xs font-semibold hover:bg-green-600"<c:if test="${reservation.status == 'CONFIRMED'}"> disabled</c:if>>확정</button>
                                        </form>
                                        <form method="post" class="inline">
                                            <input type="hidden" name="id" value="${reservation.id}" />
                                            <input type="hidden" name="action" value="complete" />
                                            <button type="submit" class="px-3 py-1 rounded bg-blue-500 text-white text-xs font-semibold hover:bg-blue-600"<c:if test="${reservation.status == 'COMPLETED'}"> disabled</c:if>>완료</button>
                                        </form>
                                        <form method="post" class="inline">
                                            <input type="hidden" name="id" value="${reservation.id}" />
                                            <input type="hidden" name="action" value="cancel" />
                                            <button type="submit" class="px-3 py-1 rounded bg-red-500 text-white text-xs font-semibold hover:bg-red-600"<c:if test="${reservation.status == 'CANCELLED'}"> disabled</c:if>>취소</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="px-4 py-10 text-center text-sm text-gray-500">
                                    등록된 예약이 없습니다.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
