<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 맞춤 추천 섹션 -->
<section class="mb-12" aria-labelledby="recommendations-title">
    <div class="flex justify-between items-center mb-6">
        <h2 id="recommendations-title" class="text-2xl md:text-3xl font-bold">
            ✨ ${user.nickname}님을 위한 맞춤 추천
        </h2>
        <a href="${pageContext.request.contextPath}/recommendation/personalized"
           class="text-sky-600 hover:text-sky-700 font-semibold text-sm">
            더 보기 →
        </a>
    </div>
    <c:choose>
        <c:when test="${not empty personalizedRecommendations}">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="rec" items="${personalizedRecommendations}" varStatus="status">
                    <div class="bg-white rounded-xl shadow-md overflow-hidden transform hover:-translate-y-1 transition-all duration-300 group">
                        <div class="relative">
                            <img src="${not empty rec.restaurant.image ? rec.restaurant.image : 'https://placehold.co/600x400/e2e8f0/64748b?text=MEET+LOG'}"
                                 alt="${rec.restaurant.name}"
                                 loading="lazy"
                                 decoding="async"
                                 class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300">
                            <div class="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1.5 rounded-full shadow-sm">
                                <span class="text-xs font-semibold text-green-700">
                                    추천 정확도 <span class="text-sm font-bold text-green-600"><fmt:formatNumber value="${rec.recommendationScore * 100}" pattern="0" />%</span>
                                </span>
                            </div>
                            <div class="absolute top-3 left-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                                ✨ 맞춤 추천
                            </div>
                        </div>
                        <div class="p-4">
                            <h3 class="text-lg font-bold text-slate-800 mb-1">${rec.restaurant.name}</h3>
                            <p class="text-slate-600 text-sm mb-2">
                                ${rec.restaurant.category} • ${rec.restaurant.location}
                            </p>
                            <div class="flex items-center space-x-2 mb-3">
                                <div class="flex space-x-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= rec.restaurant.rating}">
                                                <span class="text-yellow-400 text-sm">★</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-300 text-sm">☆</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <span class="text-slate-600 text-sm">
                                    <fmt:formatNumber value="${rec.restaurant.rating}" pattern="0.0" />
                                    (${rec.restaurant.reviewCount}개 리뷰)
                                </span>
                            </div>
                            <div class="bg-blue-50 p-2 rounded-lg mb-3">
                                <p class="text-xs text-blue-800">
                                    <strong>💡 추천 이유:</strong> ${rec.recommendationReason}
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/restaurant/detail/${rec.restaurant.id}"
                               class="block w-full bg-sky-600 text-white text-center py-2 px-4 rounded-lg hover:bg-sky-700 transition-colors">
                                상세보기
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- 빈 상태 UI (개선됨) -->
            <jsp:include page="/WEB-INF/views/sections/empty-recommendations.jsp" />
        </c:otherwise>
    </c:choose>
</section>
