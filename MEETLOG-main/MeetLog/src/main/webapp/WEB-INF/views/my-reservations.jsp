<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 내 예약</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-6 flex justify-between items-center">
                    <div>
                        <h2 class="text-2xl md:text-3xl font-bold mb-2">내 예약</h2>
                        <p class="text-slate-600">예약 내역을 관리하세요.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/reservation/create" 
                       class="bg-sky-600 text-white font-bold py-2 px-4 rounded-lg hover:bg-sky-700">
                        새 예약하기
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <div class="space-y-4">
                                    <c:forEach var="reservation" items="${reservations}">
                                        <%-- Define status-specific variables for cleaner HTML --%>
                                        <c:set var="statusClass" value="bg-slate-100 text-slate-800" />
                                        <c:set var="statusText" value="${reservation.status}" />
                                        <c:if test="${reservation.status == 'CONFIRMED'}">
                                            <c:set var="statusClass" value="bg-green-100 text-green-800" />
                                            <c:set var="statusText" value="확정" />
                                        </c:if>
                                        <c:if test="${reservation.status == 'PENDING'}">
                                            <c:set var="statusClass" value="bg-yellow-100 text-yellow-800" />
                                            <c:set var="statusText" value="대기중" />
                                        </c:if>
                                        <c:if test="${reservation.status == 'CANCELLED'}">
                                            <c:set var="statusClass" value="bg-red-100 text-red-800" />
                                            <c:set var="statusText" value="취소됨" />
                                        </c:if>

                                        <div class="bg-white p-6 rounded-xl shadow-lg">
                                            <div class="flex items-start justify-between mb-4">
                                                <div class="flex-grow">
                                                    <div class="flex items-center mb-2">
                                                        <h3 class="text-lg font-bold text-slate-800 mr-3">예약 #${reservation.id}</h3>
                                                        <span class="px-2 py-1 text-xs rounded-full ${statusClass}">
                                                            ${statusText}
                                                        </span>
                                                    </div>
                                                    <p class="text-slate-600 text-sm mb-2">맛집 ID: ${reservation.restaurantId}</p>
                                                    <p class="text-slate-700 mb-2">예약 날짜: <fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></p>
                                                    <p class="text-slate-700 mb-2">예약 시간: ${reservation.reservationTimeString}</p>
                                                    <p class="text-slate-700">인원: ${reservation.partySize}명</p>
                                                    <c:if test="${not empty reservation.specialRequests}">
                                                        <p class="text-slate-600 text-sm mt-2">특별 요청: ${reservation.specialRequests}</p>
                                                    </c:if>
                                                </div>
                                                <div class="text-right">
                                                    <p class="text-sm text-slate-500 mb-2">예약일: <fmt:formatDate value="${reservation.createdAt}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                    <c:if test="${reservation.status == 'CONFIRMED'}">
                                                        <p class="text-sm text-green-600 font-medium">예약 확정됨</p>
                                                    </c:if>
                                                     <c:if test="${reservation.status == 'PENDING'}">
                                                        <p class="text-sm text-yellow-600 font-medium">승인 대기중</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="flex items-center justify-between pt-4 border-t border-slate-200">
                                                <div class="flex items-center space-x-2">
                                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${reservation.restaurantId}" 
                                                       class="text-sky-600 hover:text-sky-700 text-sm font-medium">맛집 보기</a>
                                                    <span class="text-slate-300">|</span>
                                                    <a href="${pageContext.request.contextPath}/reservation/detail/${reservation.id}" 
                                                       class="text-slate-600 hover:text-slate-700 text-sm font-medium">상세보기</a>
                                                </div>
                                                <div class="flex items-center space-x-2">
                                                    <c:if test="${reservation.status == 'PENDING' || reservation.status == 'CONFIRMED'}">
                                                        <button onclick="cancelReservation(${reservation.id})" 
                                                                class="text-red-600 hover:text-red-700 text-sm font-medium">취소</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">📅</div>
                                    <h3 class="text-xl font-bold text-slate-800 mb-2">예약 내역이 없습니다</h3>
                                    <p class="text-slate-600 mb-6">맛집을 예약해보세요!</p>
                                    <a href="${pageContext.request.contextPath}/main" 
                                       class="inline-block bg-sky-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-sky-700">
                                        맛집 둘러보기
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🔒</div>
                            <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                            <p class="text-slate-600 mb-6">예약을 관리하려면 로그인해주세요.</p>
                            <a href="${pageContext.request.contextPath}/login" 
                               class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                로그인하기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <%-- Replaced inline footer with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function cancelReservation(reservationId) {
            if (confirm('정말로 이 예약을 취소하시겠습니까?')) {
                // This JavaScript logic remains the same as it contains no JSP scriptlets.
                fetch('${pageContext.request.contextPath}/reservation', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=cancel&reservationId=' + reservationId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('예약 취소 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('예약 취소 중 오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>