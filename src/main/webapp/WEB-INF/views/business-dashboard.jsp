<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 비즈니스 대시보드</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <div class="min-h-screen flex flex-col">
        <nav class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <h1 class="text-xl font-bold text-gray-900">${dashboardData.restaurantName} 관리</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/business/dashboard" class="text-blue-600 font-medium">대시보드</a>
                        <a href="${pageContext.request.contextPath}/business/menu-management" class="text-gray-700 hover:text-gray-900">메뉴 관리</a>
                        <a href="${pageContext.request.contextPath}/business/reservation-management" class="text-gray-700 hover:text-gray-900">예약 관리</a>
                        <a href="${pageContext.request.contextPath}/business/review-management" class="text-gray-700 hover:text-gray-900">리뷰 관리</a>
                        <a href="${pageContext.request.contextPath}/business/info-edit" class="text-gray-700 hover:text-gray-900">가게 정보</a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">비즈니스 대시보드</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-blue-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">📅</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 예약 수</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.totalReservations}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-green-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">📅</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">오늘 예약</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.todayReservations}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-yellow-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">⭐</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">평균 평점</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.averageRating}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-purple-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">💰</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">월 매출</dt><dd class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${dashboardData.monthlyRevenue}" type="currency" currencySymbol="₩"/></dd></dl></div></div></div></div>
                </div>
                
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-white shadow rounded-lg">
                        <div class="px-4 py-5 sm:p-6">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">최근 예약</h3>
                            <div class="space-y-4">
                                <c:forEach var="reservation" items="${dashboardData.recentReservations}">
                                    <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">${reservation.customerName}</p>
                                            <p class="text-sm text-gray-500">${reservation.reservationTime} (${reservation.partySize}명)</p>
                                        </div>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${reservation.status == 'CONFIRMED' ? 'bg-green-100 text-green-800' : reservation.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800'}">
                                            ${reservation.status == 'CONFIRMED' ? '확정' : reservation.status == 'PENDING' ? '대기' : '완료'}
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white shadow rounded-lg">
                        <div class="px-4 py-5 sm:p-6">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">최근 리뷰</h3>
                            <div class="space-y-4">
                                <c:forEach var="review" items="${dashboardData.recentReviews}">
                                    <div class="p-3 bg-gray-50 rounded-lg">
                                        <div class="flex items-center justify-between mb-2">
                                            <p class="text-sm font-medium text-gray-900">${review.customerName}</p>
                                            <div class="flex items-center">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="text-sm ${i <= review.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p class="text-sm text-gray-600">${review.content}</p>
                                        <p class="text-xs text-gray-500 mt-1">${review.createdAt}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>