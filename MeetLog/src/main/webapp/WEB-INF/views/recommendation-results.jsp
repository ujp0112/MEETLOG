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
            <div class="container mx-auto p-4 md:p-8" id="recommendation-container"
                 data-context-path="${pageContext.request.contextPath}"
                 data-type="${recommendationType}"
                 data-batch-size="${pageSize != null ? pageSize : 6}"
                 data-base-restaurant-id="${empty baseRestaurantId ? '' : baseRestaurantId}">
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
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" id="recommendation-list">
                            <c:forEach var="recommendation" items="${recommendations}" varStatus="status">
                                <div class="glass-card p-6 rounded-2xl fade-in" style="animation-delay: ${status.index * 0.1}s" data-restaurant-id="${recommendation.restaurant.id}">
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
                            <button id="load-more-button" onclick="loadMoreRecommendations()" 
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
        (function() {
            const noop = function() {};
            const container = document.getElementById('recommendation-container');
            const recommendationList = document.getElementById('recommendation-list');
            const loadMoreButton = document.getElementById('load-more-button');

            if (!container || !recommendationList || !loadMoreButton) {
                window.loadMoreRecommendations = noop;
                return;
            }

            const contextPath = container.dataset.contextPath || '';
            const recommendationType = (container.dataset.type || '').toLowerCase();
            const batchSize = Number.parseInt(container.dataset.batchSize || '6', 10) || 6;
            const baseRestaurantId = container.dataset.baseRestaurantId || '';
            const loadedIds = new Set();

            recommendationList.querySelectorAll('[data-restaurant-id]').forEach((item) => {
                const value = Number.parseInt(item.dataset.restaurantId, 10);
                if (!Number.isNaN(value)) {
                    loadedIds.add(value);
                }
            });

            const initialButtonText = loadMoreButton.textContent;

            function escapeHtml(value) {
                if (typeof value !== 'string') {
                    return '';
                }
                return value.replace(/[&<>"']/g, (match) => {
                    switch (match) {
                        case '&':
                            return '&amp;';
                        case '<':
                            return '&lt;';
                        case '>':
                            return '&gt;';
                        case '"':
                            return '&quot;';
                        case "'":
                            return '&#39;';
                        default:
                            return match;
                    }
                });
            }

            function toPercent(score) {
                const numeric = Number(score);
                if (!Number.isFinite(numeric)) {
                    return 0;
                }
                return Math.max(0, Math.min(100, Math.round(numeric * 100)));
            }

            function formatRating(value) {
                if (value === null || value === undefined) {
                    return null;
                }
                const numeric = Number(value);
                if (!Number.isFinite(numeric)) {
                    return null;
                }
                return numeric.toFixed(1);
            }

            function setButtonState(state) {
                if (!loadMoreButton) {
                    return;
                }
                if (state === 'loading') {
                    loadMoreButton.disabled = true;
                    loadMoreButton.textContent = '불러오는 중...';
                    loadMoreButton.classList.add('opacity-60', 'cursor-not-allowed');
                } else if (state === 'disabled') {
                    loadMoreButton.disabled = true;
                    loadMoreButton.textContent = '더 이상의 추천이 없습니다';
                    loadMoreButton.classList.add('opacity-60', 'cursor-not-allowed');
                } else {
                    loadMoreButton.disabled = false;
                    loadMoreButton.textContent = initialButtonText || '더 많은 추천 보기';
                    loadMoreButton.classList.remove('opacity-60', 'cursor-not-allowed');
                }
            }

            function buildMatchingFactorsHtml(factors) {
                if (!Array.isArray(factors) || factors.length === 0) {
                    return '';
                }
                return factors
                    .filter((factor) => factor !== null && factor !== undefined)
                    .map((factor) => `<span class="bg-slate-100 text-slate-700 px-2 py-1 rounded-full text-xs">${escapeHtml(String(factor))}</span>`)
                    .join('');
            }

            function buildCard(rec, delayIndex) {
                if (!rec || !rec.restaurant || !rec.restaurant.id) {
                    return null;
                }

                const restaurant = rec.restaurant;
                const restaurantId = restaurant.id;
                if (loadedIds.has(restaurantId)) {
                    return null;
                }
                loadedIds.add(restaurantId);

                const card = document.createElement('div');
                card.className = 'glass-card p-6 rounded-2xl fade-in';
                card.dataset.restaurantId = restaurantId;
                card.style.animationDelay = `${delayIndex * 0.1}s`;

                const imageUrl = restaurant.image || restaurant.mainImage || 'https://placehold.co/400x250/3b82f6/ffffff?text=맛집+이미지';
                const restaurantName = escapeHtml(restaurant.name || '추천 맛집');
                const recommendationReason = escapeHtml(rec.recommendationReason || '');
                const description = escapeHtml(restaurant.description || '');
                const address = escapeHtml(restaurant.address || '');
                const scoreText = toPercent(rec.recommendationScore);
                const isPersonalized = Boolean(rec.isPersonalized || rec.personalized);
                const averageRating = formatRating(restaurant.averageRating);
                const predictedRating = formatRating(rec.predictedRating);
                const reviewCount = Number.isFinite(Number(restaurant.reviewCount)) ? Number(restaurant.reviewCount) : null;
                const matchingFactorsHtml = buildMatchingFactorsHtml(rec.matchingFactors);
                const detailUrl = escapeHtml(`${contextPath}/restaurant/detail/${restaurantId}`);
                const imageSrc = escapeHtml(imageUrl);

                card.innerHTML = `
                    <div class="relative mb-4 overflow-hidden rounded-xl">
                        <img src="${imageSrc}" alt="${restaurantName}" class="w-full h-48 object-cover hover:scale-105 transition-transform duration-300">
                        <div class="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full">
                            <span class="text-sm font-bold recommendation-score">${scoreText}%</span>
                        </div>
                        ${isPersonalized ? '<div class="absolute top-3 left-3 bg-sky-600 text-white text-xs font-semibold px-3 py-1 rounded-full">For You</div>' : ''}
                    </div>
                    <div class="space-y-3">
                        <div>
                            <h3 class="text-xl font-semibold text-slate-800 mb-1">${restaurantName}</h3>
                            ${address ? `<p class="text-sm text-slate-500">${address}</p>` : ''}
                        </div>
                        ${recommendationReason ? `<p class="text-sm text-slate-600 bg-slate-50 p-3 rounded-lg"><strong>💡 추천 이유:</strong> ${recommendationReason}</p>` : ''}
                        ${description ? `<p class="text-sm text-slate-500">${description}</p>` : ''}
                        ${(averageRating || predictedRating || reviewCount !== null) ? `
                            <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
                                ${averageRating ? `<span>⭐ ${averageRating}</span>` : ''}
                                ${reviewCount !== null ? `<span>리뷰 ${reviewCount}개</span>` : ''}
                                ${predictedRating ? `<span>예상 평점 ${predictedRating}</span>` : ''}
                            </div>
                        ` : ''}
                        ${matchingFactorsHtml ? `<div class="flex flex-wrap gap-2">${matchingFactorsHtml}</div>` : ''}
                        <div class="flex space-x-2 pt-2">
                            <a href="${detailUrl}" class="flex-1 bg-sky-600 text-white text-center py-2 px-4 rounded-lg hover:bg-sky-700 transition-colors">상세보기</a>
                            <button type="button" class="bg-slate-100 text-slate-700 py-2 px-4 rounded-lg hover:bg-slate-200 transition-colors" aria-label="위시리스트">❤️</button>
                        </div>
                    </div>
                `;

                return card;
            }

            window.loadMoreRecommendations = function() {
                setButtonState('loading');

                const params = new URLSearchParams();
                if (recommendationType) {
                    params.append('type', recommendationType);
                }
                params.append('limit', String(batchSize));
                if (baseRestaurantId) {
                    params.append('restaurantId', baseRestaurantId);
                }
                if (loadedIds.size > 0) {
                    params.append('excludeIds', Array.from(loadedIds).join(','));
                }

                const requestUrl = `${contextPath}/recommendations/load-more?${params.toString()}`;

                fetch(requestUrl, {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' },
                    credentials: 'same-origin'
                })
                    .then((response) => {
                        if (!response.ok) {
                            throw new Error(`HTTP ${response.status}`);
                        }
                        return response.json();
                    })
                    .then((data) => {
                        if (!Array.isArray(data) || data.length === 0) {
                            setButtonState('disabled');
                            return;
                        }

                        const startIndex = recommendationList.children.length;
                        let appended = 0;

                        data.forEach((item, index) => {
                            const card = buildCard(item, startIndex + index);
                            if (card) {
                                recommendationList.appendChild(card);
                                appended += 1;
                            }
                        });

                        if (appended === 0 || appended < batchSize) {
                            setButtonState('disabled');
                        } else {
                            setButtonState('idle');
                        }
                    })
                    .catch((error) => {
                        console.error('추천 로드 실패:', error);
                        setButtonState('idle');
                        alert('추천을 불러오는 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    });
            };

            if (recommendationList.children.length < batchSize) {
                setButtonState('disabled');
            }
        })();
    </script>
</body>
</html>
