<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP 통합 대시보드 - MEET LOG</title>
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
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        /* 상태 인디케이터 */
        .status-indicator {
            position: relative;
            display: inline-flex;
            align-items: center;
        }
        .status-indicator::before {
            content: '';
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s infinite;
        }
        .status-active::before { background-color: #10b981; }
        .status-warning::before { background-color: #f59e0b; }
        .status-error::before { background-color: #ef4444; }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        /* 카드 호버 효과 */
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8">
        <!-- 헤더 섹션 -->
        <div class="glass-card p-8 rounded-3xl fade-in mb-8">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold gradient-text mb-2">🏢 ERP 통합 대시보드</h1>
                    <p class="text-slate-600">전체 가맹점 현황과 비즈니스 인사이트를 실시간으로 확인하세요</p>
                </div>
                <div class="hidden md:block">
                    <div class="flex items-center space-x-4">
                        <div class="status-indicator status-active">
                            <span class="text-sm text-slate-600">시스템 정상</span>
                        </div>
                        <div class="text-right">
                            <p class="text-sm text-slate-500">마지막 업데이트</p>
                            <p class="text-sm font-semibold" id="lastUpdate">방금 전</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- KPI 카드 섹션 -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="glass-card p-6 rounded-2xl slide-up card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">총 가맹점</p>
                        <p class="text-3xl font-bold text-slate-800" id="totalBranches">${totalBranches > 0 ? totalBranches : 45}</p>
                        <p class="text-sm text-green-600">+3 이번 달</p>
                    </div>
                    <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">🏪</span>
                    </div>
                </div>
            </div>

            <div class="glass-card p-6 rounded-2xl slide-up card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">월 매출</p>
                        <p class="text-3xl font-bold text-slate-800" id="monthlyRevenue">
                            <fmt:formatNumber value="${monthlyRevenue > 0 ? monthlyRevenue : 1250000}" pattern="#,##0"/>만원
                        </p>
                        <p class="text-sm text-blue-600">+12% 전월 대비</p>
                    </div>
                    <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">💰</span>
                    </div>
                </div>
            </div>

            <div class="glass-card p-6 rounded-2xl slide-up card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">활성 주문</p>
                        <p class="text-3xl font-bold text-slate-800" id="activeOrders">${activeOrders > 0 ? activeOrders : 128}</p>
                        <p class="text-sm text-yellow-600">15개 검토중</p>
                    </div>
                    <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">📦</span>
                    </div>
                </div>
            </div>

            <div class="glass-card p-6 rounded-2xl slide-up card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-slate-600 text-sm font-medium">재고 회전율</p>
                        <p class="text-3xl font-bold text-slate-800" id="inventoryTurnover">
                            <fmt:formatNumber value="${inventoryTurnover > 0 ? inventoryTurnover : 4.2}" pattern="0.0"/>회
                        </p>
                        <p class="text-sm text-purple-600">목표 달성 92%</p>
                    </div>
                    <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">📊</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 핵심 차트 섹션 -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- 가맹점별 매출 성과 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-slate-800">🏆 가맹점별 매출 성과 TOP 10</h3>
                    <select id="branchPeriod" class="text-sm border border-gray-300 rounded-lg px-3 py-1 focus:outline-none focus:ring-2 focus:ring-green-500">
                        <option value="week">최근 1주</option>
                        <option value="month" selected>최근 1개월</option>
                        <option value="quarter">최근 3개월</option>
                    </select>
                </div>
                <div class="relative h-80">
                    <canvas id="branchPerformanceChart"></canvas>
                </div>
            </div>

            <!-- 주문 상태 분포 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-slate-800">📋 주문 상태 분포</h3>
                    <div class="status-indicator status-active">
                        <span class="text-sm">실시간 업데이트</span>
                    </div>
                </div>
                <div class="relative h-80">
                    <canvas id="orderStatusChart"></canvas>
                </div>
            </div>
        </div>

        <!-- 세부 분석 차트 -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
            <!-- 월별 매출 트렌드 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">📈 월별 매출 트렌드</h3>
                <div class="relative h-64">
                    <canvas id="monthlyTrendChart"></canvas>
                </div>
            </div>

            <!-- 카테고리별 주문량 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">🍽️ 카테고리별 주문량</h3>
                <div class="relative h-64">
                    <canvas id="categoryOrderChart"></canvas>
                </div>
            </div>

            <!-- 지역별 성과 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <h3 class="text-lg font-bold text-slate-800 mb-4">🗺️ 지역별 성과</h3>
                <div class="relative h-64">
                    <canvas id="regionPerformanceChart"></canvas>
                </div>
            </div>
        </div>

        <!-- ROI 분석 및 예측 -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- ROI 분석 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-slate-800">💡 ROI 분석</h3>
                    <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">수익성 높음</span>
                </div>
                <div class="relative h-64">
                    <canvas id="roiAnalysisChart"></canvas>
                </div>
                <div class="mt-4 grid grid-cols-3 gap-4 text-center">
                    <div>
                        <p class="text-2xl font-bold text-green-600">312%</p>
                        <p class="text-sm text-slate-600">평균 ROI</p>
                    </div>
                    <div>
                        <p class="text-2xl font-bold text-blue-600">89%</p>
                        <p class="text-sm text-slate-600">목표 달성률</p>
                    </div>
                    <div>
                        <p class="text-2xl font-bold text-purple-600">45</p>
                        <p class="text-sm text-slate-600">수익성 가맹점</p>
                    </div>
                </div>
            </div>

            <!-- 예측 분석 -->
            <div class="glass-card p-6 rounded-2xl slide-up">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-slate-800">🔮 매출 예측</h3>
                    <div class="flex items-center space-x-2">
                        <div class="w-2 h-2 bg-blue-500 rounded-full"></div>
                        <span class="text-xs text-slate-600">AI 예측</span>
                    </div>
                </div>
                <div class="relative h-64">
                    <canvas id="forecastChart"></canvas>
                </div>
                <div class="mt-4 bg-blue-50 p-3 rounded-lg">
                    <p class="text-sm text-blue-800">
                        <strong>💡 AI 인사이트:</strong>
                        다음 달 예상 매출은 <strong>1,387만원</strong>으로 이번 달 대비 <strong>11% 증가</strong> 전망입니다.
                        특히 강남, 홍대 지역의 성장이 기대됩니다.
                    </p>
                </div>
            </div>
        </div>

        <!-- 알림 및 이슈 모니터링 -->
        <div class="glass-card p-6 rounded-2xl slide-up">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-bold text-slate-800">🚨 실시간 알림 & 이슈</h3>
                <button onclick="refreshAlerts()" class="text-blue-600 hover:text-blue-700 text-sm font-medium">
                    🔄 새로고침
                </button>
            </div>
            <div class="space-y-3" id="alertsList">
                <!-- 알림 목록이 여기에 동적으로 로드됩니다 -->
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <!-- ERP 대시보드 JavaScript -->
    <script>
        // 차트 인스턴스들을 저장할 객체
        const erpCharts = {};

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            initializeERPCharts();
            loadRealTimeAlerts();
            startERPUpdates();
            setupEventListeners();
        });

        /**
         * ERP 차트 초기화
         */
        function initializeERPCharts() {
            initBranchPerformanceChart();
            initOrderStatusChart();
            initMonthlyTrendChart();
            initCategoryOrderChart();
            initRegionPerformanceChart();
            initROIAnalysisChart();
            initForecastChart();
        }

        /**
         * 가맹점별 매출 성과 차트
         */
        function initBranchPerformanceChart() {
            const ctx = document.getElementById('branchPerformanceChart').getContext('2d');

            const data = {
                labels: ['강남점', '홍대점', '이태원점', '명동점', '건대점', '신촌점', '압구정점', '청담점', '잠실점', '여의도점'],
                datasets: [{
                    label: '매출 (만원)',
                    data: [580, 520, 480, 420, 380, 360, 340, 320, 300, 280],
                    backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.success),
                    borderColor: chartUtils.defaultColors.success,
                    borderWidth: 1
                }]
            };

            erpCharts.branchPerformance = chartUtils.createBarChart(ctx, data, {
                indexAxis: 'y',
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
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
         * 주문 상태 분포 차트
         */
        function initOrderStatusChart() {
            const ctx = document.getElementById('orderStatusChart').getContext('2d');

            const data = {
                labels: ['승인 대기', '승인 완료', '배송 중', '배송 완료', '취소'],
                values: [15, 45, 32, 85, 8]
            };

            erpCharts.orderStatus = chartUtils.createDoughnutChart(ctx, data);
        }

        /**
         * 월별 매출 트렌드 차트
         */
        function initMonthlyTrendChart() {
            const ctx = document.getElementById('monthlyTrendChart').getContext('2d');

            const data = {
                labels: ['8월', '9월', '10월', '11월', '12월'],
                datasets: [{
                    label: '매출',
                    data: [980, 1120, 1050, 1180, 1250],
                    borderColor: chartUtils.defaultColors.primary,
                    backgroundColor: chartUtils.createGradient(ctx, ['#3b82f6', '#60a5fa']),
                    tension: 0.4
                }]
            };

            erpCharts.monthlyTrend = chartUtils.createLineChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                }
            });
        }

        /**
         * 카테고리별 주문량 차트
         */
        function initCategoryOrderChart() {
            const ctx = document.getElementById('categoryOrderChart').getContext('2d');

            const data = {
                labels: ['식재료', '포장재', '주방용품', '청소용품', '기타'],
                values: [45, 28, 15, 8, 4]
            };

            erpCharts.categoryOrder = chartUtils.createDoughnutChart(ctx, data, {
                cutout: '50%'
            });
        }

        /**
         * 지역별 성과 차트
         */
        function initRegionPerformanceChart() {
            const ctx = document.getElementById('regionPerformanceChart').getContext('2d');

            const data = {
                labels: ['강남구', '마포구', '용산구', '중구', '광진구'],
                datasets: [{
                    label: '매출',
                    data: [1200, 890, 650, 580, 420],
                    backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.warning)
                }]
            };

            erpCharts.regionPerformance = chartUtils.createBarChart(ctx, data, {
                plugins: {
                    legend: {
                        display: false
                    }
                }
            });
        }

        /**
         * ROI 분석 차트
         */
        function initROIAnalysisChart() {
            const ctx = document.getElementById('roiAnalysisChart').getContext('2d');

            const data = {
                labels: ['1분기', '2분기', '3분기', '4분기'],
                datasets: [
                    {
                        label: 'ROI (%)',
                        data: [285, 320, 298, 312],
                        borderColor: chartUtils.defaultColors.success,
                        backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.success),
                        yAxisID: 'y'
                    },
                    {
                        label: '투자액 (만원)',
                        data: [2500, 2800, 2600, 2900],
                        borderColor: chartUtils.defaultColors.secondary,
                        backgroundColor: 'transparent',
                        borderDash: [5, 5],
                        yAxisID: 'y1'
                    }
                ]
            };

            erpCharts.roiAnalysis = new Chart(ctx, {
                type: 'line',
                data: data,
                options: {
                    ...chartUtils.defaultOptions,
                    scales: {
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            grid: {
                                drawOnChartArea: false,
                            },
                        },
                    }
                }
            });
        }

        /**
         * 매출 예측 차트
         */
        function initForecastChart() {
            const ctx = document.getElementById('forecastChart').getContext('2d');

            const data = {
                labels: ['10월', '11월', '12월', '1월(예측)', '2월(예측)', '3월(예측)'],
                datasets: [
                    {
                        label: '실제 매출',
                        data: [1050, 1180, 1250, null, null, null],
                        borderColor: chartUtils.defaultColors.primary,
                        backgroundColor: chartUtils.createGradient(ctx, chartUtils.defaultColors.gradient.primary)
                    },
                    {
                        label: 'AI 예측',
                        data: [null, null, 1250, 1387, 1420, 1480],
                        borderColor: chartUtils.defaultColors.warning,
                        backgroundColor: 'transparent',
                        borderDash: [10, 5]
                    }
                ]
            };

            erpCharts.forecast = chartUtils.createLineChart(ctx, data);
        }

        /**
         * 실시간 알림 로드
         */
        function loadRealTimeAlerts() {
            const container = document.getElementById('alertsList');

            const alerts = [
                {
                    type: 'warning',
                    title: '재고 부족 알림',
                    message: '홍대점 - 토마토 재고가 부족합니다 (잔여: 5kg)',
                    time: '5분 전',
                    priority: 'high'
                },
                {
                    type: 'success',
                    title: '주문 승인',
                    message: '강남점 - 12월 식재료 주문이 승인되었습니다',
                    time: '15분 전',
                    priority: 'normal'
                },
                {
                    type: 'info',
                    title: '매출 목표 달성',
                    message: '이태원점 - 이번 달 매출 목표를 달성했습니다',
                    time: '1시간 전',
                    priority: 'normal'
                },
                {
                    type: 'error',
                    title: '시스템 점검',
                    message: '배송 추적 시스템 점검이 예정되어 있습니다',
                    time: '2시간 전',
                    priority: 'low'
                }
            ];

            container.innerHTML = alerts.map(alert => {
                const iconMap = {
                    warning: '⚠️',
                    success: '✅',
                    info: 'ℹ️',
                    error: '❌'
                };

                const bgColorMap = {
                    high: 'bg-red-50 border-red-200',
                    normal: 'bg-blue-50 border-blue-200',
                    low: 'bg-gray-50 border-gray-200'
                };

                return `
                    <div class="flex items-start space-x-3 p-3 rounded-lg border ${bgColorMap[alert.priority]}">
                        <div class="text-lg">${iconMap[alert.type]}</div>
                        <div class="flex-1">
                            <div class="flex items-center justify-between">
                                <h4 class="font-semibold text-slate-800 text-sm">${alert.title}</h4>
                                <span class="text-xs text-slate-500">${alert.time}</span>
                            </div>
                            <p class="text-sm text-slate-600 mt-1">${alert.message}</p>
                        </div>
                    </div>
                `;
            }).join('');
        }

        /**
         * ERP 실시간 업데이트 시작
         */
        function startERPUpdates() {
            // 30초마다 데이터 업데이트
            setInterval(function() {
                updateERPData();
                updateLastUpdateTime();
            }, 30000);
        }

        /**
         * ERP 데이터 업데이트
         */
        function updateERPData() {
            // 실시간 KPI 업데이트
            updateKPIs();

            // 주문 상태 차트 업데이트
            updateOrderStatusChart();
        }

        /**
         * KPI 업데이트
         */
        function updateKPIs() {
            const kpis = [
                { id: 'totalBranches', change: Math.random() > 0.8 ? 1 : 0 },
                { id: 'activeOrders', change: Math.floor(Math.random() * 10) - 5 },
                { id: 'monthlyRevenue', change: Math.floor(Math.random() * 50) }
            ];

            kpis.forEach(kpi => {
                const element = document.getElementById(kpi.id);
                if (element && kpi.change !== 0) {
                    const currentValue = parseInt(element.textContent.replace(/[^0-9]/g, ''));
                    const newValue = currentValue + kpi.change;
                    animateCounter(element, currentValue, newValue);
                }
            });
        }

        /**
         * 주문 상태 차트 업데이트
         */
        function updateOrderStatusChart() {
            if (erpCharts.orderStatus) {
                const newData = [
                    Math.floor(Math.random() * 20) + 10,  // 승인 대기
                    Math.floor(Math.random() * 30) + 40,  // 승인 완료
                    Math.floor(Math.random() * 20) + 25,  // 배송 중
                    Math.floor(Math.random() * 40) + 70,  // 배송 완료
                    Math.floor(Math.random() * 10) + 5    // 취소
                ];

                chartUtils.updateChart(erpCharts.orderStatus, [newData]);
            }
        }

        /**
         * 마지막 업데이트 시간 갱신
         */
        function updateLastUpdateTime() {
            const element = document.getElementById('lastUpdate');
            if (element) {
                element.textContent = '방금 전';
            }
        }

        /**
         * 알림 새로고침
         */
        function refreshAlerts() {
            const container = document.getElementById('alertsList');
            container.innerHTML = `
                <div class="flex items-center justify-center py-8">
                    <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-green-600"></div>
                    <span class="ml-3 text-slate-600">알림을 업데이트 중...</span>
                </div>
            `;

            setTimeout(() => {
                loadRealTimeAlerts();
            }, 1500);
        }

        /**
         * 이벤트 리스너 설정
         */
        function setupEventListeners() {
            // 가맹점 성과 기간 변경
            document.getElementById('branchPeriod').addEventListener('change', function(e) {
                updateBranchPerformanceChart(e.target.value);
            });
        }

        /**
         * 가맹점 성과 차트 업데이트
         */
        function updateBranchPerformanceChart(period) {
            if (!erpCharts.branchPerformance) return;

            // 기간에 따른 데이터 생성 (실제로는 서버에서 가져옴)
            let multiplier = 1;
            switch(period) {
                case 'week': multiplier = 0.7; break;
                case 'month': multiplier = 1; break;
                case 'quarter': multiplier = 2.8; break;
            }

            const newData = [580, 520, 480, 420, 380, 360, 340, 320, 300, 280].map(val =>
                Math.floor(val * multiplier + (Math.random() * 50 - 25))
            );

            erpCharts.branchPerformance.data.datasets[0].data = newData;
            erpCharts.branchPerformance.update('active');
        }

        /**
         * 카운터 애니메이션
         */
        function animateCounter(element, start, end) {
            const duration = 1500;
            const startTime = performance.now();

            function update(currentTime) {
                const elapsed = currentTime - startTime;
                const progress = Math.min(elapsed / duration, 1);

                const current = Math.floor(start + (end - start) * progress);
                const formatted = current.toLocaleString();

                if (element.id === 'monthlyRevenue') {
                    element.textContent = formatted + '만원';
                } else {
                    element.textContent = formatted;
                }

                if (progress < 1) {
                    requestAnimationFrame(update);
                }
            }

            requestAnimationFrame(update);
        }
    </script>
</body>
</html>