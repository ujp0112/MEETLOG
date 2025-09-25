<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user.nickname}님의 대시보드 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.js"></script>
    <!-- Chart Utils -->
    <script src="${pageContext.request.contextPath}/js/chart-utils.js"></script>
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        .gradient-text {
            background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .pulse-animation { animation: pulse 2s infinite; }
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8">
        <!-- 웰컴 섹션 -->
        <div class="glass-card p-8 rounded-3xl fade-in mb-8">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold gradient-text mb-2">
                        🍽️ ${user.nickname}님의 맛집 여행
                    </h1>
                    <p class="text-slate-600">당신만의 특별한 맛집 스토리를 확인해보세요</p>
                </div>
                <div class="hidden md:block">
                    <div class="text-center">
                        <img src="${not empty user.profileImage ? user.profileImage : 'https://placehold.co/80x80/3b82f6/ffffff?text=' + user.nickname.substring(0,1)}"
                             alt="프로필" class="w-20 h-20 rounded-full mx-auto mb-2 border-4 border-white shadow-lg">
                        <p class="text-sm text-slate-600">맛집 탐험가</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 통계 카드 섹션 -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">방문한 맛집</p>
                        <p class="text-3xl font-bold text-slate-800" id="visitedRestaurants">${visitedCount > 0 ? visitedCount : 12}</p>
                    </div>
                    <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">🏪</span>
                    </div>
                </div>
            </div>

            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">작성한 리뷰</p>
                        <p class="text-3xl font-bold text-slate-800" id="writtenReviews">${reviewCount > 0 ? reviewCount : 28}</p>
                    </div>
                    <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">⭐</span>
                    </div>
                </div>
            </div>

            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">나의 평균 평점</p>
                        <p class="text-3xl font-bold text-slate-800" id="averageRating">
                            <fmt:formatNumber value="${avgRating > 0 ? avgRating : 4.2}" pattern="0.0"/>
                        </p>
                    </div>
                    <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">📊</span>
                    </div>
                </div>
            </div>

            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">팔로워</p>
                        <p class="text-3xl font-bold text-slate-800" id="followerCount">${followerCount > 0 ? followerCount : 15}</p>
                    </div>
                    <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">👥</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 차트 대시보드 섹션 -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- 월별 방문 패턴 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-slate-800">📅 월별 방문 패턴</h3>
                    <div class="flex items-center space-x-2">
                        <div class="w-3 h-3 bg-green-500 rounded-full pulse-animation"></div>
                        <span class="text-sm text-gray-600">활동 중</span>
                    </div>
                </div>
                <div class="relative h-64">
                    <canvas id="visitPatternChart"></canvas>
                </div>
            </div>

            <!-- 선호 카테고리 분포 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">🍜 선호 카테고리</h3>
                <div class="relative h-64">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
        </div>

        <!-- 상세 분석 차트 -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
            <!-- 평점 분포 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">⭐ 내가 준 평점 분포</h3>
                <div class="relative h-48">
                    <canvas id="myRatingChart"></canvas>
                </div>
            </div>

            <!-- 지역별 방문 횟수 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">🗺️ 지역별 방문</h3>
                <div class="relative h-48">
                    <canvas id="locationChart"></canvas>
                </div>
            </div>

            <!-- 시간대별 방문 선호도 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">⏰ 시간대별 선호도</h3>
                <div class="relative h-48">
                    <canvas id="timeChart"></canvas>
                </div>
            </div>
        </div>

        <!-- 맛집 추천 & 최근 활동 -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- AI 맞춤 추천 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-slate-800">🤖 AI 맞춤 추천</h3>
                    <button onclick="refreshRecommendations()" class="text-blue-600 hover:text-blue-700 text-sm font-medium">
                        🔄 새로고침
                    </button>
                </div>
                <div id="recommendationList" class="space-y-3">
                    <!-- 추천 목록이 여기에 동적으로 로드됩니다 -->
                </div>
            </div>

            <!-- 최근 활동 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">📝 최근 활동</h3>
                <div class="space-y-4" id="recentActivities">
                    <!-- 최근 활동이 여기에 동적으로 로드됩니다 -->
                </div>
            </div>
        </div>

        <!-- 개인 성취 배지 -->
        <div class="glass-card p-6 rounded-2xl slide-up">
            <h3 class="text-lg font-bold text-slate-800 mb-4">🏆 나의 성취</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4" id="achievementBadges">
                <!-- 배지들이 여기에 동적으로 로드됩니다 -->
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <!-- 사용자 대시보드 JavaScript -->
    <script>
        // 차트 인스턴스들을 저장할 객체
        const userCharts = {};

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            initializeUserCharts();
            loadRecommendations();
            loadRecentActivities();
            loadAchievementBadges();
            startPersonalizedUpdates();
        });

        /**
         * 사용자 차트 초기화
         */
        function initializeUserCharts() {
            initVisitPatternChart();
            initCategoryChart();
            initMyRatingChart();
            initLocationChart();
            initTimeChart();
        }

        /**
         * 월별 방문 패턴 차트
         */
        function initVisitPatternChart() {
            const ctx = document.getElementById('visitPatternChart').getContext('2d');

            const data = {
                labels: ['8월', '9월', '10월', '11월', '12월'],
                datasets: [{
                    label: '방문 횟수',
                    data: [5, 8, 12, 7, 15],
                    borderColor: chartUtils.defaultColors.success,
                    backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.success),
                    tension: 0.4
                }]
            };

            userCharts.visitPattern = chartUtils.createLineChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                }
            });
        }

        /**
         * 선호 카테고리 도넛 차트
         */
        function initCategoryChart() {
            const ctx = document.getElementById('categoryChart').getContext('2d');

            const data = {
                labels: ['한식', '일식', '양식', '중식', '카페'],
                values: [35, 25, 20, 15, 5]
            };

            userCharts.category = chartUtils.createDoughnutChart(ctx, data);
        }

        /**
         * 내가 준 평점 분포 차트
         */
        function initMyRatingChart() {
            const ctx = document.getElementById('myRatingChart').getContext('2d');

            const data = {
                labels: ['1점', '2점', '3점', '4점', '5점'],
                datasets: [{
                    label: '개수',
                    data: [0, 2, 8, 12, 6],
                    backgroundColor: [
                        '#ef4444',
                        '#f97316',
                        '#eab308',
                        '#22c55e',
                        '#16a34a'
                    ]
                }]
            };

            userCharts.myRating = chartUtils.createBarChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                }
            });
        }

        /**
         * 지역별 방문 차트
         */
        function initLocationChart() {
            const ctx = document.getElementById('locationChart').getContext('2d');

            const data = {
                labels: ['강남', '홍대', '이태원', '명동', '기타'],
                values: [15, 12, 8, 6, 4]
            };

            userCharts.location = chartUtils.createDoughnutChart(ctx, data, {
                cutout: '50%'
            });
        }

        /**
         * 시간대별 선호도 차트
         */
        function initTimeChart() {
            const ctx = document.getElementById('timeChart').getContext('2d');

            const data = {
                labels: ['점심', '저녁', '브런치', '야식'],
                datasets: [{
                    label: '방문 횟수',
                    data: [18, 25, 5, 8],
                    backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.warning)
                }]
            };

            userCharts.time = chartUtils.createBarChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                }
            });
        }

        /**
         * AI 맞춤 추천 로드
         */
        function loadRecommendations() {
            const container = document.getElementById('recommendationList');

            // 샘플 추천 데이터 (실제로는 서버에서 가져옴)
            const recommendations = [
                {
                    name: '미슐랭 가이드 레스토랑',
                    category: '프렌치',
                    reason: '고급 양식을 좋아하는 패턴',
                    score: 95
                },
                {
                    name: '전통 한식당',
                    category: '한식',
                    reason: '한식 방문 빈도가 높음',
                    score: 88
                },
                {
                    name: '이자카야 술집',
                    category: '일식',
                    reason: '저녁 시간대 선호',
                    score: 82
                }
            ];

            container.innerHTML = recommendations.map(rec => `
                <div class="flex items-center space-x-3 p-3 bg-slate-50 rounded-lg hover:bg-slate-100 cursor-pointer">
                    <div class="flex-1">
                        <h4 class="font-semibold text-slate-800">${rec.name}</h4>
                        <p class="text-sm text-slate-600">${rec.reason}</p>
                    </div>
                    <div class="text-right">
                        <div class="text-lg font-bold text-green-600">${rec.score}%</div>
                        <div class="text-xs text-slate-500">매칭도</div>
                    </div>
                </div>
            `).join('');
        }

        /**
         * 최근 활동 로드
         */
        function loadRecentActivities() {
            const container = document.getElementById('recentActivities');

            const activities = [
                {
                    type: 'review',
                    content: '강남역 파스타 맛집에 리뷰를 남겼습니다',
                    time: '2시간 전',
                    icon: '⭐'
                },
                {
                    type: 'visit',
                    content: '홍대 카페를 방문했습니다',
                    time: '1일 전',
                    icon: '📍'
                },
                {
                    type: 'follow',
                    content: '새로운 팔로워가 생겼습니다',
                    time: '2일 전',
                    icon: '👥'
                }
            ];

            container.innerHTML = activities.map(activity => `
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                        <span class="text-sm">${activity.icon}</span>
                    </div>
                    <div class="flex-1">
                        <p class="text-sm text-slate-800">${activity.content}</p>
                        <p class="text-xs text-slate-500">${activity.time}</p>
                    </div>
                </div>
            `).join('');
        }

        /**
         * 성취 배지 로드
         */
        function loadAchievementBadges() {
            const container = document.getElementById('achievementBadges');

            const badges = [
                { name: '첫 리뷰', icon: '🌟', earned: true },
                { name: '맛집 탐험가', icon: '🗺️', earned: true },
                { name: '미식가', icon: '👨‍🍳', earned: true },
                { name: '소셜 스타', icon: '📱', earned: false },
                { name: '리뷰 마스터', icon: '📝', earned: false },
                { name: '코스 크리에이터', icon: '🎯', earned: false }
            ];

            container.innerHTML = badges.map(badge => `
                <div class="text-center p-3 rounded-lg ${badge.earned ? 'bg-yellow-50 border-2 border-yellow-200' : 'bg-gray-50 opacity-50'}">
                    <div class="text-2xl mb-1">${badge.icon}</div>
                    <div class="text-xs font-medium ${badge.earned ? 'text-yellow-800' : 'text-gray-500'}">${badge.name}</div>
                </div>
            `).join('');
        }

        /**
         * 추천 새로고침
         */
        function refreshRecommendations() {
            document.getElementById('recommendationList').innerHTML = `
                <div class="flex items-center justify-center py-8">
                    <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                    <span class="ml-3">새로운 추천을 찾고 있습니다...</span>
                </div>
            `;

            setTimeout(() => {
                loadRecommendations();
            }, 2000);
        }

        /**
         * 개인화된 실시간 업데이트 시작
         */
        function startPersonalizedUpdates() {
            // 5분마다 데이터 업데이트
            setInterval(function() {
                updateUserStats();
            }, 300000);
        }

        /**
         * 사용자 통계 업데이트
         */
        function updateUserStats() {
            // 실제로는 서버에서 최신 데이터를 가져옴
            // 여기서는 시뮬레이션
            const visitedEl = document.getElementById('visitedRestaurants');
            const reviewEl = document.getElementById('writtenReviews');

            // 애니메이션과 함께 숫자 업데이트
            animateCounter(visitedEl, parseInt(visitedEl.textContent), parseInt(visitedEl.textContent) + 1);
        }

        /**
         * 카운터 애니메이션
         */
        function animateCounter(element, start, end) {
            const duration = 1000;
            const startTime = performance.now();

            function update(currentTime) {
                const elapsed = currentTime - startTime;
                const progress = Math.min(elapsed / duration, 1);

                const current = Math.floor(start + (end - start) * progress);
                element.textContent = current;

                if (progress < 1) {
                    requestAnimationFrame(update);
                }
            }

            requestAnimationFrame(update);
        }
    </script>
</body>
</html>