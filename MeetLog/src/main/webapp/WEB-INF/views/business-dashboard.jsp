<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<<<<<<< HEAD

=======
>>>>>>> origin/my-feature
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<<<<<<< HEAD
    <title>비즈니스 대시보드 - MeetLog</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-slate-100">

    <div id="app" class="min-h-screen flex flex-col">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <!-- 🎯 헤더 섹션 -->
                <div class="mb-8">
                    <h1 class="text-4xl font-bold gradient-text mb-2">비즈니스 대시보드</h1>
                    <p class="text-slate-600 text-lg">음식점을 관리하고 고객과 소통하세요</p>
                </div>

                <!-- 📊 통계 카드 섹션 -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="glass-card p-6 rounded-2xl slide-up">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-slate-600 text-sm font-medium">총 음식점</p>
                                <p class="text-3xl font-bold text-slate-800">${restaurantCount}</p>
                            </div>
                            <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                                <span class="text-2xl">🏪</span>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-2xl slide-up">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-slate-600 text-sm font-medium">총 리뷰</p>
                                <p class="text-3xl font-bold text-slate-800">${reviewCount}</p>
                            </div>
                            <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                                <span class="text-2xl">⭐</span>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-2xl slide-up">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-slate-600 text-sm font-medium">평균 평점</p>
                                <p class="text-3xl font-bold text-slate-800">${averageRating}</p>
                            </div>
                            <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                                <span class="text-2xl">📊</span>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-2xl slide-up">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-slate-600 text-sm font-medium">이번 달 방문자</p>
                                <p class="text-3xl font-bold text-slate-800">1,234</p>
                            </div>
                            <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                                <span class="text-2xl">👥</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 🚀 빠른 작업 섹션 -->
                <div class="glass-card p-8 rounded-3xl slide-up mb-8">
                    <h2 class="text-2xl font-bold gradient-text mb-6">빠른 작업</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                        <a href="${pageContext.request.contextPath}/business/restaurants/add" 
                           class="p-6 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-2xl hover:from-blue-600 hover:to-blue-700 transition-all duration-300 transform hover:scale-105">
                            <div class="text-center">
                                <div class="text-3xl mb-2">➕</div>
                                <h3 class="font-semibold">새 음식점 등록</h3>
                                <p class="text-sm opacity-90">새로운 음식점을 등록하세요</p>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/restaurant/my" 
                           class="p-6 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-2xl hover:from-green-600 hover:to-green-700 transition-all duration-300 transform hover:scale-105">
                            <div class="text-center">
                                <div class="text-3xl mb-2">🏪</div>
                                <h3 class="font-semibold">내 음식점 관리</h3>
                                <p class="text-sm opacity-90">등록된 음식점을 관리하세요</p>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/business/statistics" 
                           class="p-6 bg-gradient-to-r from-purple-500 to-purple-600 text-white rounded-2xl hover:from-purple-600 hover:to-purple-700 transition-all duration-300 transform hover:scale-105">
                            <div class="text-center">
                                <div class="text-3xl mb-2">📊</div>
                                <h3 class="font-semibold">통계 보기</h3>
                                <p class="text-sm opacity-90">상세한 분석을 확인하세요</p>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/business/inquiries" 
                           class="p-6 bg-gradient-to-r from-orange-500 to-orange-600 text-white rounded-2xl hover:from-orange-600 hover:to-orange-700 transition-all duration-300 transform hover:scale-105">
                            <div class="text-center">
                                <div class="text-3xl mb-2">💬</div>
                                <h3 class="font-semibold">고객 문의</h3>
                                <p class="text-sm opacity-90">고객 문의를 확인하세요</p>
                            </div>
                        </a>
                    </div>
                </div>

                <!-- 📈 최근 리뷰 섹션 -->
                <c:if test="${not empty recentReviews}">
                    <div class="glass-card p-8 rounded-3xl slide-up mb-8">
                        <h2 class="text-2xl font-bold gradient-text mb-6">최근 리뷰</h2>
                        <div class="space-y-4">
                            <c:forEach var="review" items="${recentReviews}" end="4">
                                <div class="flex items-start space-x-4 p-4 bg-slate-50 rounded-2xl card-hover">
                                    <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                        ${review.author.charAt(0)}
                                    </div>
                                    <div class="flex-1">
                                        <div class="flex items-center space-x-2 mb-2">
                                            <h4 class="font-semibold text-slate-800">${review.author}</h4>
                                            <div class="flex items-center space-x-1">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <span class="text-yellow-400">★</span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p class="text-slate-600 text-sm">${review.content}</p>
                                        <p class="text-slate-400 text-xs mt-2">
                                            ${review.createdAt}
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                
                <!-- 🏪 내 음식점 목록 섹션 -->
                <c:if test="${not empty myRestaurants}">
                    <div class="glass-card p-8 rounded-3xl slide-up">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-2xl font-bold gradient-text">내 음식점</h2>
                            <a href="${pageContext.request.contextPath}/business/restaurants" class="text-blue-600 hover:text-blue-700 font-semibold">전체 보기 →</a>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            <c:forEach var="restaurant" items="${myRestaurants}" end="5">
                                <div class="p-4 bg-slate-50 rounded-2xl card-hover">
                                    <h3 class="font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                    <p class="text-slate-600 text-sm mb-2">${restaurant.category} • ${restaurant.location}</p>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center space-x-1">
                                            <span class="text-yellow-400">★</span>
                                            <span class="text-sm text-slate-600">${restaurant.rating}</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/menu-management?restaurantId=${restaurant.id}" 
                                           class="text-blue-600 hover:text-blue-700 text-sm font-medium">메뉴 관리</a>
                                    </div>
=======
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
>>>>>>> origin/my-feature
                                </div>
                            </c:forEach>
                        </div>
                    </div>
<<<<<<< HEAD
                </c:if>
            </div>
        </main>

        <%-- Standardized footer include path --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <style>
        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .gradient-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .slide-up {
            animation: slideUp 0.6s ease-out;
        }
        
        .card-hover {
            transition: all 0.3s ease;
        }
        
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        @keyframes slideUp {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
    </style>
=======
                    
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
>>>>>>> origin/my-feature
</body>
</html>