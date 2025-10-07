<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약 상세</title>
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
                <div class="max-w-2xl mx-auto">
                    <c:choose>
                        <c:when test="${not empty reservation}">
                            <%-- Set status-specific variables for cleaner HTML --%>
                            <c:set var="statusClass" value="bg-slate-500 text-white" />
                            <c:set var="statusText" value="${reservation.status}" />
                            <c:if test="${reservation.status == 'CONFIRMED'}">
                                <c:set var="statusClass" value="bg-green-500 text-white" />
                                <c:set var="statusText" value="확정" />
                            </c:if>
                            <c:if test="${reservation.status == 'PENDING'}">
                                <c:set var="statusClass" value="bg-yellow-500 text-white" />
                                <c:set var="statusText" value="대기중" />
                            </c:if>
                            <c:if test="${reservation.status == 'CANCELLED'}">
                                <c:set var="statusClass" value="bg-red-500 text-white" />
                                <c:set var="statusText" value="취소됨" />
                            </c:if>
                            
                            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                                <div class="bg-sky-600 text-white p-6">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <h1 class="text-2xl font-bold">예약 #${reservation.id}</h1>
                                            <p class="text-sky-100 mt-1">예약 상세 정보</p>
                                        </div>
                                        <div class="text-right">
                                            <span class="px-3 py-1 text-sm rounded-full ${statusClass}">
                                                ${statusText}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="p-6">
                                    <div class="mb-6">
                                        <h2 class="text-lg font-bold text-slate-800 mb-3">맛집 정보</h2>
                                        <div class="bg-slate-50 p-4 rounded-lg">
                                            <c:choose>
                                                <c:when test="${not empty restaurant}">
                                                    <h3 class="font-semibold text-slate-800 mb-2">${restaurant.name}</h3>
                                                    <p class="text-slate-600 text-sm mb-1">${restaurant.category} • ${restaurant.location}</p>
                                                    <p class="text-slate-600 text-sm mb-1">주소: ${restaurant.address}</p>
                                                    <c:if test="${not empty restaurant.phone}">
                                                        <p class="text-slate-600 text-sm">전화: ${restaurant.phone}</p>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-slate-600">맛집 정보를 불러올 수 없습니다.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="mb-6">
                                        <h2 class="text-lg font-bold text-slate-800 mb-3">예약 정보</h2>
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">예약 날짜</h3>
                                                <p class="text-slate-800"><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></p>
                                            </div>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">예약 시간</h3>
                                                <p class="text-slate-800">${reservation.reservationTimeStr}</p>
                                            </div>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">인원 수</h3>
                                                <p class="text-slate-800">${reservation.partySize}명</p>
                                            </div>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">연락처</h3>
                                                <p class="text-slate-800">${reservation.contactPhone}</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty reservation.specialRequests}">
                                        <div class="mb-6">
                                            <h2 class="text-lg font-bold text-slate-800 mb-3">특별 요청사항</h2>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <p class="text-slate-700">${reservation.specialRequests}</p>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="mb-6">
                                        <h2 class="text-lg font-bold text-slate-800 mb-3">예약 일정</h2>
                                        <div class="space-y-2 text-sm">
                                            <div class="flex justify-between">
                                                <span class="text-slate-600">예약 신청:</span>
                                                <span class="text-slate-800"><fmt:formatDate value="${reservation.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                                            </div>
                                            <c:if test="${not empty reservation.updatedAt}">
                                                <div class="flex justify-between">
                                                    <span class="text-slate-600">마지막 수정:</span>
                                                    <span class="text-slate-800"><fmt:formatDate value="${reservation.updatedAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="flex justify-between items-center pt-6 border-t border-slate-200">
                                        <a href="${pageContext.request.contextPath}/mypage/reservations" class="text-slate-600 hover:text-slate-800 text-sm font-medium">
                                            ← 예약 목록으로 돌아가기
                                        </a>
                                        
                                        <%-- Show cancel button only if the user is the owner and the status is cancellable --%>
                                        <c:if test="${not empty sessionScope.user and sessionScope.user.id == reservation.userId and (reservation.status == 'PENDING' or reservation.status == 'CONFIRMED')}">
                                            <div class="flex space-x-3">
                                                <button onclick="cancelReservation(${reservation.id})" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 text-sm">
                                                    예약 취소
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12">
                                <div class="text-6xl mb-4">📅</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">예약을 찾을 수 없습니다</h2>
                                <p class="text-slate-600 mb-6">요청하신 예약이 존재하지 않거나 삭제되었습니다.</p>
                                <a href="${pageContext.request.contextPath}/mypage/reservations" class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                    예약 목록으로 돌아가기
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>

        <%-- Replaced inline footer with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        // This client-side script remains the same as it contains no JSP code.
        function cancelReservation(reservationId) {
            if (confirm('정말로 이 예약을 취소하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/reservation/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=cancel&reservationId=' + reservationId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('예약이 취소되었습니다.');
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
