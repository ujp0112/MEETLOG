<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비즈니스 통계 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="mb-8">
                <h1 class="text-3xl font-bold gradient-text mb-2">📊 비즈니스 통계</h1>
                <p class="text-slate-600">음식점 운영 현황과 고객 데이터를 한눈에 확인하세요</p>
            </div>
            
            <!-- 통계 카드 섹션 -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">총 음식점</p>
                            <p class="text-3xl font-bold text-slate-800">${totalRestaurants}</p>
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
                            <p class="text-3xl font-bold text-slate-800">${totalReviews}</p>
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
                            <p class="text-3xl font-bold text-slate-800">
                                <fmt:formatNumber value="${averageRating}" pattern="0.0"/>
                            </p>
                        </div>
                        <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">📈</span>
                        </div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">총 예약</p>
                            <p class="text-3xl font-bold text-slate-800">${totalReservations}</p>
                        </div>
                        <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">📅</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 음식점별 상세 통계 -->
            <div class="glass-card p-6 rounded-2xl">
                <h2 class="text-2xl font-bold text-slate-800 mb-6">음식점별 상세 통계</h2>
                
                <c:choose>
                    <c:when test="${not empty restaurants}">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead>
                                    <tr class="border-b border-slate-200">
                                        <th class="text-left py-3 px-4 font-semibold text-slate-700">음식점명</th>
                                        <th class="text-left py-3 px-4 font-semibold text-slate-700">카테고리</th>
                                        <th class="text-left py-3 px-4 font-semibold text-slate-700">위치</th>
                                        <th class="text-center py-3 px-4 font-semibold text-slate-700">리뷰 수</th>
                                        <th class="text-center py-3 px-4 font-semibold text-slate-700">평점</th>
                                        <th class="text-center py-3 px-4 font-semibold text-slate-700">상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="restaurant" items="${restaurants}">
                                        <tr class="border-b border-slate-100 hover:bg-slate-50">
                                            <td class="py-3 px-4">
                                                <div class="flex items-center">
                                                    <img src="${not empty restaurant.image ? restaurant.image : 'https://placehold.co/40x40/3b82f6/ffffff?text=음식점'}"
                                                         alt="${restaurant.name}" class="w-10 h-10 rounded-lg object-cover mr-3">
                                                    <span class="font-medium text-slate-800">${restaurant.name}</span>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4 text-slate-600">${restaurant.category}</td>
                                            <td class="py-3 px-4 text-slate-600">${restaurant.location}</td>
                                            <td class="py-3 px-4 text-center text-slate-600">${restaurant.reviewCount}</td>
                                            <td class="py-3 px-4 text-center">
                                                <div class="flex items-center justify-center">
                                                    <span class="text-yellow-400 mr-1">★</span>
                                                    <span class="font-semibold text-slate-800">
                                                        <fmt:formatNumber value="${restaurant.rating != null ? restaurant.rating : 0.0}" pattern="0.0"/>
                                                    </span>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4 text-center">
                                                <c:choose>
                                                    <c:when test="${restaurant.isActive == true or restaurant.isActive == 1}">
                                                        <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">운영중</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs font-medium">휴업</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">📊</div>
                            <h3 class="text-xl font-bold text-slate-600 mb-2">등록된 음식점이 없습니다</h3>
                            <p class="text-slate-500 mb-6">첫 번째 음식점을 등록하여 통계를 확인해보세요!</p>
                            <a href="${pageContext.request.contextPath}/business/restaurants/add" 
                               class="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                                음식점 등록하기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
