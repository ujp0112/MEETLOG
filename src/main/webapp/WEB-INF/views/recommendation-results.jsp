<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - ${title}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .glass-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        
        .gradient-text {
            background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .recommendation-score {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <!-- 헤더 섹션 -->
                <div class="mb-8">
                    <h1 class="text-3xl md:text-4xl font-bold gradient-text mb-4">${title}</h1>
                    <p class="text-slate-600">
                        <c:choose>
                            <c:when test="${recommendationType == 'personalized'}">
                                당신의 취향과 비슷한 사용자들의 데이터를 분석하여 추천합니다.
                            </c:when>
                            <c:when test="${recommendationType == 'collaborative'}">
                                비슷한 취향의 사용자들이 좋아한 맛집들을 추천합니다.
                            </c:when>
                            <c:when test="${recommendationType == 'content-based'}">
                                선택한 맛집과 비슷한 특성을 가진 맛집들을 추천합니다.
                            </c:when>
                            <c:when test="${recommendationType == 'hybrid'}">
                                AI가 여러 알고리즘을 조합하여 최적의 맛집을 추천합니다.
                            </c:when>
                            <c:otherwise>
                                인기 있는 맛집들을 추천합니다.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- 추천 결과 -->
                <c:choose>
                    <c:when test="${not empty recommendations}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="recommendation" items="${recommendations}" varStatus="status">
                                <div class="glass-card p-6 rounded-2xl fade-in" style="animation-delay: ${status.index * 0.1}s">
                                    <!-- 맛집 이미지 -->
                                    <div class="relative mb-4 overflow-hidden rounded-xl">
                                        <img src="${not empty recommendation.restaurant.image ? recommendation.restaurant.image : 'https://placehold.co/400x250/3b82f6/ffffff?text=맛집+이미지'}" 
                                             alt="${recommendation.restaurant.name}" 
                                             class="w-full h-48 object-cover hover:scale-105 transition-transform duration-300">
                                        
                                        <!-- 추천 점수 배지 -->
                                        <div class="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full">
                                            <span class="text-sm font-bold recommendation-score">
                                                <fmt:formatNumber value="${recommendation.recommendationScore * 100}" pattern="0" />%
                                            </span>
                                        </div>
                                        
                                        <!-- 개인화 추천 배지 -->
                                        <c:if test="${recommendation.personalized}">
                                            <div class="absolute top-3 left-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                                                ✨ 맞춤 추천
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- 맛집 정보 -->
                                    <div class="space-y-3">
                                        <div>
                                            <h3 class="text-xl font-bold text-slate-800 mb-1">${recommendation.restaurant.name}</h3>
                                            <p class="text-slate-600 text-sm">${recommendation.restaurant.category} • ${recommendation.restaurant.location}</p>
                                        </div>

                                        <!-- 평점 -->
                                        <div class="flex items-center space-x-2">
                                            <div class="flex space-x-1">
                                                <c:forEach begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${i <= recommendation.restaurant.rating}">
                                                            <span class="text-yellow-400 text-sm">★</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-slate-300 text-sm">☆</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                            <span class="text-slate-600 text-sm">
                                                <fmt:formatNumber value="${recommendation.restaurant.rating}" pattern="0.0" />
                                                (${recommendation.restaurant.reviewCount}개 리뷰)
                                            </span>
                                        </div>

                                        <!-- 추천 이유 -->
                                        <div class="bg-blue-50 p-3 rounded-lg">
                                            <p class="text-sm text-blue-800">
                                                <strong>💡 추천 이유:</strong> ${recommendation.recommendationReason}
                                            </p>
                                        </div>

                                        <!-- 매칭 요소들 -->
                                        <c:if test="${not empty recommendation.matchingFactors}">
                                            <div class="flex flex-wrap gap-2">
                                                <c:forEach var="factor" items="${recommendation.matchingFactors}">
                                                    <span class="bg-slate-100 text-slate-700 px-2 py-1 rounded-full text-xs">
                                                        ${factor}
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <!-- 액션 버튼들 -->
                                        <div class="flex space-x-2 pt-2">
                                            <a href="${pageContext.request.contextPath}/restaurant/detail/${recommendation.restaurant.id}" 
                                               class="flex-1 bg-sky-600 text-white text-center py-2 px-4 rounded-lg hover:bg-sky-700 transition-colors">
                                                상세보기
                                            </a>
                                            <button class="bg-slate-100 text-slate-700 py-2 px-4 rounded-lg hover:bg-slate-200 transition-colors">
                                                ❤️
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 더 보기 버튼 -->
                        <div class="text-center mt-8">
                            <button onclick="loadMoreRecommendations()" 
                                    class="bg-gradient-to-r from-sky-500 to-purple-500 text-white px-8 py-3 rounded-2xl font-semibold hover:from-sky-600 hover:to-purple-600 transition-all">
                                더 많은 추천 보기
                            </button>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- 추천 결과가 없는 경우 -->
                        <div class="text-center py-16">
                            <div class="text-6xl mb-4">🤔</div>
                            <h3 class="text-2xl font-bold text-slate-800 mb-4">추천할 맛집이 없습니다</h3>
                            <p class="text-slate-600 mb-8">
                                더 많은 리뷰를 작성하시면 더 정확한 추천을 받을 수 있습니다.
                            </p>
                            <div class="space-x-4">
                                <a href="${pageContext.request.contextPath}/main" 
                                   class="bg-sky-600 text-white px-6 py-3 rounded-lg hover:bg-sky-700">
                                    메인으로 돌아가기
                                </a>
                                <a href="${pageContext.request.contextPath}/restaurant/list" 
                                   class="bg-slate-100 text-slate-700 px-6 py-3 rounded-lg hover:bg-slate-200">
                                    맛집 둘러보기
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function loadMoreRecommendations() {
            // 더 많은 추천 로드 기능 (AJAX 구현)
            console.log('더 많은 추천을 로드합니다...');
            // TODO: AJAX로 추가 추천 로드
        }
    </script>
</body>
</html>
