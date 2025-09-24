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
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.js"></script>
    <!-- Chart Utils -->
    <script src="${pageContext.request.contextPath}/js/chart-utils.js"></script>
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

            <!-- 차트 대시보드 섹션 -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                <!-- 매출 트렌드 차트 -->
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-bold text-slate-800">📈 매출 트렌드</h3>
                        <select id="revenueTimeRange" class="text-sm border border-gray-300 rounded-lg px-3 py-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="7">최근 7일</option>
                            <option value="30" selected>최근 30일</option>
                            <option value="90">최근 90일</option>
                        </select>
                    </div>
                    <div class="relative h-64">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- 예약 현황 도넛 차트 -->
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-bold text-slate-800">📅 예약 현황</h3>
                        <div class="flex items-center space-x-2">
                            <div class="w-3 h-3 bg-blue-500 rounded-full"></div>
                            <span class="text-sm text-gray-600">실시간 업데이트</span>
                        </div>
                    </div>
                    <div class="relative h-64">
                        <canvas id="reservationChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- 상세 분석 차트 -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                <!-- 리뷰 점수 분포 -->
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <h3 class="text-lg font-bold text-slate-800 mb-4">⭐ 리뷰 점수 분포</h3>
                    <div class="relative h-48">
                        <canvas id="ratingChart"></canvas>
                    </div>
                </div>

                <!-- 월별 신규 고객 -->
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <h3 class="text-lg font-bold text-slate-800 mb-4">👥 월별 신규 고객</h3>
                    <div class="relative h-48">
                        <canvas id="newCustomerChart"></canvas>
                    </div>
                </div>

                <!-- 인기 메뉴 TOP 5 -->
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <h3 class="text-lg font-bold text-slate-800 mb-4">🍽️ 인기 메뉴 TOP 5</h3>
                    <div class="relative h-48">
                        <canvas id="popularMenuChart"></canvas>
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
                                                        <fmt:formatNumber value="${restaurant.rating}" pattern="0.0"/>
                                                    </span>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4 text-center">
                                                <c:choose>
                                                    <c:when test="${restaurant.isActive}">
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

    <!-- 비즈니스 통계 대시보드 JavaScript -->
    <script>
        // 차트 인스턴스들을 저장할 객체
        const charts = {};

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            initializeCharts();
            startRealTimeUpdates();
            setupEventListeners();
        });

        /**
         * 모든 차트 초기화
         */
        function initializeCharts() {
            initRevenueChart();
            initReservationChart();
            initRatingChart();
            initNewCustomerChart();
            initPopularMenuChart();
        }

        /**
         * 매출 트렌드 차트 초기화
         */
        function initRevenueChart() {
            const ctx = document.getElementById('revenueChart').getContext('2d');

            // 실제 데이터는 서버에서 가져와야 하지만, 일단 샘플 데이터로 시연
            const data = {
                labels: ['1주 전', '6일 전', '5일 전', '4일 전', '3일 전', '2일 전', '어제', '오늘'],
                datasets: [{
                    label: '매출 (만원)',
                    data: [120, 190, 300, 250, 220, 300, 280, 350],
                    borderColor: chartUtils.defaultColors.primary,
                    backgroundColor: chartUtils.createGradient(ctx, ['#3b82f6', '#60a5fa'])
                }]
            };

            charts.revenue = chartUtils.createLineChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        ticks: {
                            callback: function(value) {
                                return value + '만원';
                            }
                        }
                    }
                }
            });
        }

        /**
         * 예약 현황 도넛 차트 초기화
         */
        function initReservationChart() {
            const ctx = document.getElementById('reservationChart').getContext('2d');

            const data = {
                labels: ['확정', '대기', '취소', '완료'],
                values: [${totalReservations > 0 ? totalReservations * 0.6 : 12},
                        ${totalReservations > 0 ? totalReservations * 0.2 : 3},
                        ${totalReservations > 0 ? totalReservations * 0.1 : 2},
                        ${totalReservations > 0 ? totalReservations * 0.1 : 1}]
            };

            charts.reservation = chartUtils.createDoughnutChart(ctx, data);
        }

        /**
         * 리뷰 점수 분포 차트 초기화
         */
        function initRatingChart() {
            const ctx = document.getElementById('ratingChart').getContext('2d');

            const data = {
                labels: ['1점', '2점', '3점', '4점', '5점'],
                datasets: [{
                    label: '리뷰 수',
                    data: [2, 5, 8, 15, 25],
                    backgroundColor: [
                        '#ef4444',
                        '#f97316',
                        '#eab308',
                        '#22c55e',
                        '#16a34a'
                    ]
                }]
            };

            charts.rating = chartUtils.createBarChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        ticks: {
                            stepSize: 5
                        }
                    }
                }
            });
        }

        /**
         * 월별 신규 고객 차트 초기화
         */
        function initNewCustomerChart() {
            const ctx = document.getElementById('newCustomerChart').getContext('2d');

            const data = {
                labels: ['8월', '9월', '10월', '11월', '12월'],
                datasets: [{
                    label: '신규 고객',
                    data: [45, 52, 38, 67, 73],
                    backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.success)
                }]
            };

            charts.newCustomer = chartUtils.createBarChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                }
            });
        }

        /**
         * 인기 메뉴 차트 초기화
         */
        function initPopularMenuChart() {
            const ctx = document.getElementById('popularMenuChart').getContext('2d');

            const data = {
                labels: ['불고기', '김치찌개', '된장찌개', '비빔밥', '갈비탕'],
                values: [35, 28, 22, 18, 15]
            };

            charts.popularMenu = chartUtils.createDoughnutChart(ctx, data, {
                cutout: '50%'
            });
        }

        /**
         * 실시간 데이터 업데이트 시작
         */
        function startRealTimeUpdates() {
            // 30초마다 데이터 업데이트
            setInterval(function() {
                updateRealtimeData();
            }, 30000);

            // 실시간 업데이트 인디케이터 애니메이션
            animateRealtimeIndicator();
        }

        /**
         * 실시간 데이터 업데이트
         */
        function updateRealtimeData() {
            // 실제 환경에서는 서버 API를 호출
            fetch('${pageContext.request.contextPath}/business/statistics/realtime')
                .then(response => response.json())
                .then(data => {
                    // 예약 현황 업데이트
                    if (data.reservations && charts.reservation) {
                        chartUtils.updateChart(charts.reservation, [data.reservations]);
                    }

                    // 새로운 매출 데이터 추가
                    if (data.newRevenue && charts.revenue) {
                        const now = new Date();
                        const label = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
                        chartUtils.addDataPoint(charts.revenue, label, [data.newRevenue]);
                    }
                })
                .catch(error => {
                    console.log('실시간 데이터 업데이트 실패 (개발 모드에서는 정상):', error);
                    // 개발용 더미 데이터
                    simulateRealtimeData();
                });
        }

        /**
         * 개발용 실시간 데이터 시뮬레이션
         */
        function simulateRealtimeData() {
            // 예약 데이터 랜덤 업데이트
            const reservationData = [
                Math.floor(Math.random() * 20) + 10,  // 확정
                Math.floor(Math.random() * 5) + 2,    // 대기
                Math.floor(Math.random() * 3) + 1,    // 취소
                Math.floor(Math.random() * 8) + 3     // 완료
            ];
            chartUtils.updateChart(charts.reservation, [reservationData]);

            // 매출 데이터 추가
            const now = new Date();
            const label = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
            const newRevenue = Math.floor(Math.random() * 100) + 200;
            chartUtils.addDataPoint(charts.revenue, label, [newRevenue]);
        }

        /**
         * 실시간 업데이트 인디케이터 애니메이션
         */
        function animateRealtimeIndicator() {
            const indicator = document.querySelector('.bg-blue-500.rounded-full');
            if (indicator) {
                setInterval(function() {
                    indicator.style.animation = 'pulse 1s ease-in-out';
                    setTimeout(() => {
                        indicator.style.animation = '';
                    }, 1000);
                }, 3000);
            }
        }

        /**
         * 이벤트 리스너 설정
         */
        function setupEventListeners() {
            // 매출 기간 변경 이벤트
            document.getElementById('revenueTimeRange').addEventListener('change', function(e) {
                const days = parseInt(e.target.value);
                updateRevenueChart(days);
            });
        }

        /**
         * 매출 차트 기간 업데이트
         */
        function updateRevenueChart(days) {
            chartUtils.showLoadingState('revenueChart');

            // 실제로는 서버에서 데이터를 가져옴
            setTimeout(() => {
                let labels = [];
                let data = [];

                for (let i = days - 1; i >= 0; i--) {
                    const date = new Date();
                    date.setDate(date.getDate() - i);
                    labels.push(i === 0 ? '오늘' : i + '일 전');
                    data.push(Math.floor(Math.random() * 200) + 150);
                }

                const newData = {
                    labels: labels,
                    datasets: [{
                        label: '매출 (만원)',
                        data: data,
                        borderColor: chartUtils.defaultColors.primary,
                        backgroundColor: charts.revenue.data.datasets[0].backgroundColor
                    }]
                };

                charts.revenue.data = newData;
                charts.revenue.update('active');
            }, 1000);
        }

        /**
         * 차트 리사이즈 (반응형)
         */
        window.addEventListener('resize', function() {
            Object.values(charts).forEach(chart => {
                if (chart && typeof chart.resize === 'function') {
                    chart.resize();
                }
            });
        });
    </script>
</body>
</html>
