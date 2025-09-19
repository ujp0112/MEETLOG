<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - ${restaurant.name} 대시보드</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
    </style>
</head>
<body class="bg-gray-100">

    <div class="min-h-screen flex flex-col">
        <%-- 상단 헤더: 다른 페이지와 통일성을 위해 수정 --%>
        <header class="bg-white shadow-sm sticky top-0 z-10">
            <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8 flex justify-between items-center">
                <a href="${pageContext.request.contextPath}/business/restaurants" class="text-xl font-bold text-sky-600">MEET LOG 파트너 센터</a>
                <a href="${pageContext.request.contextPath}/logout" class="text-sm font-medium text-gray-600 hover:text-gray-900">로그아웃</a>
            </div>
        </header>

        <%-- 메인 컨텐츠 --%>
        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                
                <%-- 페이지 타이틀 및 액션 버튼 --%>
                <div class="flex flex-col md:flex-row justify-between md:items-center gap-4 mb-6">
                    <div>
                        <a href="${pageContext.request.contextPath}/business/restaurants" class="text-sm text-blue-600 hover:underline">&larr; 내 가게 목록으로 돌아가기</a>
                        <h1 class="text-3xl font-bold text-gray-900 mt-1">${restaurant.name} 대시보드</h1>
                    </div>
                    <%-- ▼▼▼ 가게 삭제 버튼 추가 ▼▼▼ --%>
                    <form action="${pageContext.request.contextPath}/business/restaurants/delete" method="post" 
                          onsubmit="return confirm('정말로 이 가게를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.');">
                        <input type="hidden" name="restaurantId" value="${restaurant.id}">
                        <button type="submit" class="w-full md:w-auto bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 text-sm font-medium">
                            가게 삭제
                        </button>
                    </form>
                </div>
                
                <%-- 통계 카드 그리드 --%>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white p-5 shadow-lg rounded-xl"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 예약 수</dt><dd class="text-3xl font-semibold text-gray-900 mt-1">${totalReservations}</dd></dl></div>
                    <div class="bg-white p-5 shadow-lg rounded-xl"><dl><dt class="text-sm font-medium text-gray-500 truncate">오늘 예약</dt><dd class="text-3xl font-semibold text-gray-900 mt-1">${todayReservations}</dd></dl></div>
                    <div class="bg-white p-5 shadow-lg rounded-xl"><dl><dt class="text-sm font-medium text-gray-500 truncate">평균 평점</dt><dd class="text-3xl font-semibold text-gray-900 mt-1">${averageRating}</dd></dl></div>
                    <div class="bg-white p-5 shadow-lg rounded-xl"><dl><dt class="text-sm font-medium text-gray-500 truncate">월 매출</dt><dd class="text-3xl font-semibold text-gray-900 mt-1"><fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="₩"/></dd></dl></div>
                </div>
                
                <%-- 최근 예약 및 리뷰 --%>
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-white shadow-lg rounded-xl p-6">
                        <h3 class="text-lg font-medium text-gray-900 mb-4">최근 예약</h3>
                        <div class="space-y-4">
                            <c:forEach var="reservation" items="${recentReservations}">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div>
                                        <p class="text-sm font-medium text-gray-900">${reservation.customerName}</p>
                                        <p class="text-sm text-gray-500">${reservation.reservationDate} ${reservation.reservationTime} (${reservation.partySize}명)</p>
                                    </div>
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                        ${reservation.status == '확정' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}">
                                        ${reservation.status}
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="bg-white shadow-lg rounded-xl p-6">
                        <h3 class="text-lg font-medium text-gray-900 mb-4">최근 리뷰</h3>
                        <div class="space-y-4">
                            <c:if test="${empty recentReviews}">
                                <p class="text-center text-gray-500 py-8">아직 등록된 리뷰가 없습니다.</p>
                            </c:if>
                            <c:forEach var="review" items="${recentReviews}">
                                <%-- 실제 리뷰 데이터가 있을 때 표시될 부분 --%>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>