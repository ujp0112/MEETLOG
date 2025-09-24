<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시스템 성능 모니터링 - MEETLOG</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
    <script src="${pageContext.request.contextPath}/js/chart-utils.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <div class="min-h-screen">
        <!-- 헤더 -->
        <header class="bg-white shadow-sm border-b">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center py-4">
                    <div class="flex items-center">
                        <h1 class="text-2xl font-bold text-gray-900">시스템 성능 모니터링</h1>
                        <span class="ml-4 px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                            실시간 모니터링
                        </span>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button id="refreshBtn" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                            <i class="fas fa-sync-alt mr-2"></i>새로고침
                        </button>
                        <button id="settingsBtn" class="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                            <i class="fas fa-cog mr-2"></i>관리
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- 실시간 상태 카드들 -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <!-- 캐시 상태 -->
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">캐시 사용량</p>
                            <p id="cacheUsage" class="text-2xl font-bold text-blue-600">0 MB</p>
                        </div>
                        <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-database text-blue-600 text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <p class="text-sm text-gray-500">총 <span id="cacheEntries">0</span>개 항목</p>
                    </div>
                </div>

                <!-- 연결 풀 상태 -->
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">DB 연결 풀</p>
                            <p id="connectionUsage" class="text-2xl font-bold text-green-600">0%</p>
                        </div>
                        <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-plug text-green-600 text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <p class="text-sm text-gray-500">활성: <span id="activeConnections">0</span> / <span id="maxConnections">0</span></p>
                    </div>
                </div>

                <!-- 비동기 작업 상태 -->
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">비동기 작업</p>
                            <p id="taskSuccessRate" class="text-2xl font-bold text-purple-600">100%</p>
                        </div>
                        <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-tasks text-purple-600 text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <p class="text-sm text-gray-500">실행 중: <span id="activeTasks">0</span>개</p>
                    </div>
                </div>

                <!-- JVM 메모리 상태 -->
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">JVM 메모리</p>
                            <p id="jvmMemoryUsage" class="text-2xl font-bold text-orange-600">0%</p>
                        </div>
                        <div class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-microchip text-orange-600 text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <p class="text-sm text-gray-500">사용: <span id="usedMemory">0</span> MB</p>
                    </div>
                </div>
            </div>

            <!-- 차트 영역 -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                <!-- 연결 풀 상태 차트 -->
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">DB 연결 풀 상태</h3>
                    <div style="height: 300px;">
                        <canvas id="connectionPoolChart"></canvas>
                    </div>
                </div>

                <!-- 비동기 작업 통계 차트 -->
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">비동기 작업 통계</h3>
                    <div style="height: 300px;">
                        <canvas id="asyncTaskChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- 쿼리 성능 테이블 -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="p-6 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">상위 쿼리 성능 통계</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">쿼리 ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">실행 횟수</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">평균 시간 (ms)</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">최대 시간 (ms)</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">최소 시간 (ms)</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">총 시간 (ms)</th>
                            </tr>
                        </thead>
                        <tbody id="queryStatsTable" class="bg-white divide-y divide-gray-200">
                            <!-- 동적으로 생성 -->
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- 관리 모달 -->
    <div id="settingsModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-xl max-w-md w-full">
                <div class="p-6 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">시스템 관리</h3>
                </div>
                <div class="p-6 space-y-4">
                    <button id="clearCacheBtn" class="w-full px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                        <i class="fas fa-trash mr-2"></i>모든 캐시 클리어
                    </button>
                    <button id="resetQueryStatsBtn" class="w-full px-4 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors">
                        <i class="fas fa-chart-line mr-2"></i>쿼리 통계 리셋
                    </button>
                    <button id="forceGCBtn" class="w-full px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                        <i class="fas fa-recycle mr-2"></i>가비지 컬렉션 실행
                    </button>
                    <div class="border-t pt-4">
                        <label class="block text-sm font-medium text-gray-700 mb-2">캐시 패턴 무효화</label>
                        <div class="flex space-x-2">
                            <input id="cachePatternInput" type="text" class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" placeholder="예: user_, restaurant_">
                            <button id="invalidateCacheBtn" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                무효화
                            </button>
                        </div>
                    </div>
                </div>
                <div class="p-6 border-t border-gray-200 flex justify-end">
                    <button id="closeModalBtn" class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-colors">
                        닫기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        class PerformanceMonitor {
            constructor() {
                this.charts = {};
                this.isRunning = false;
                this.refreshInterval = 5000; // 5초마다 업데이트

                this.init();
            }

            init() {
                this.initEventListeners();
                this.initCharts();
                this.startMonitoring();
            }

            initEventListeners() {
                // 새로고침 버튼
                document.getElementById('refreshBtn').addEventListener('click', () => {
                    this.fetchPerformanceData();
                });

                // 설정 모달
                document.getElementById('settingsBtn').addEventListener('click', () => {
                    document.getElementById('settingsModal').classList.remove('hidden');
                });

                document.getElementById('closeModalBtn').addEventListener('click', () => {
                    document.getElementById('settingsModal').classList.add('hidden');
                });

                // 관리 액션들
                document.getElementById('clearCacheBtn').addEventListener('click', () => {
                    this.executeAction('clearCache');
                });

                document.getElementById('resetQueryStatsBtn').addEventListener('click', () => {
                    this.executeAction('resetQueryStats');
                });

                document.getElementById('forceGCBtn').addEventListener('click', () => {
                    this.executeAction('forceGC');
                });

                document.getElementById('invalidateCacheBtn').addEventListener('click', () => {
                    const pattern = document.getElementById('cachePatternInput').value.trim();
                    if (pattern) {
                        this.executeAction('invalidateCache', { pattern });
                    }
                });
            }

            initCharts() {
                // 연결 풀 차트
                const connectionPoolCtx = document.getElementById('connectionPoolChart').getContext('2d');
                this.charts.connectionPool = ChartUtils.createDoughnutChart(connectionPoolCtx, {
                    title: 'DB 연결 풀 상태',
                    data: {
                        labels: ['활성 연결', '사용 가능한 연결'],
                        datasets: [{
                            data: [0, 0],
                            backgroundColor: ['#EF4444', '#10B981']
                        }]
                    }
                });

                // 비동기 작업 차트
                const asyncTaskCtx = document.getElementById('asyncTaskChart').getContext('2d');
                this.charts.asyncTask = ChartUtils.createBarChart(asyncTaskCtx, {
                    title: '비동기 작업 통계',
                    data: {
                        labels: ['성공', '실패', '실행 중', '대기 중'],
                        datasets: [{
                            label: '작업 수',
                            data: [0, 0, 0, 0],
                            backgroundColor: ['#10B981', '#EF4444', '#F59E0B', '#6B7280']
                        }]
                    }
                });
            }

            async fetchPerformanceData() {
                try {
                    const response = await fetch('/MeetLog/admin/performance', {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    });

                    const result = await response.json();

                    if (result.success) {
                        this.updateUI(result.data);
                    } else {
                        console.error('성능 데이터 조회 실패:', result.message);
                    }
                } catch (error) {
                    console.error('성능 데이터 조회 오류:', error);
                }
            }

            updateUI(data) {
                // 캐시 상태 업데이트
                if (data.cache) {
                    document.getElementById('cacheUsage').textContent = data.cache.memoryUsage;
                    document.getElementById('cacheEntries').textContent = data.cache.totalEntries.toLocaleString();
                }

                // 연결 풀 상태 업데이트
                if (data.connectionPool) {
                    const usagePercent = Math.round(data.connectionPool.usagePercentage);
                    document.getElementById('connectionUsage').textContent = usagePercent + '%';
                    document.getElementById('activeConnections').textContent = data.connectionPool.activeConnections;
                    document.getElementById('maxConnections').textContent = data.connectionPool.maxConnections;

                    // 연결 풀 차트 업데이트
                    this.charts.connectionPool.data.datasets[0].data = [
                        data.connectionPool.activeConnections,
                        data.connectionPool.availableConnections
                    ];
                    this.charts.connectionPool.update();
                }

                // 비동기 작업 상태 업데이트
                if (data.asyncTasks) {
                    const successRate = Math.round(data.asyncTasks.successRate);
                    document.getElementById('taskSuccessRate').textContent = successRate + '%';
                    document.getElementById('activeTasks').textContent = data.asyncTasks.activeTasks;

                    // 비동기 작업 차트 업데이트
                    this.charts.asyncTask.data.datasets[0].data = [
                        data.asyncTasks.successfulTasks,
                        data.asyncTasks.failedTasks,
                        data.asyncTasks.activeTasks,
                        data.asyncTasks.queuedTasks
                    ];
                    this.charts.asyncTask.update();
                }

                // JVM 메모리 상태 업데이트
                if (data.jvm) {
                    const memoryUsagePercent = Math.round((data.jvm.usedMemory / data.jvm.totalMemory) * 100);
                    document.getElementById('jvmMemoryUsage').textContent = memoryUsagePercent + '%';
                    document.getElementById('usedMemory').textContent = Math.round(data.jvm.usedMemory / 1024 / 1024);
                }

                // 쿼리 통계 테이블 업데이트
                if (data.topQueries) {
                    this.updateQueryStatsTable(data.topQueries);
                }
            }

            updateQueryStatsTable(queryStats) {
                const tbody = document.getElementById('queryStatsTable');
                tbody.innerHTML = '';

                Object.entries(queryStats).forEach(([queryId, stats]) => {
                    const row = document.createElement('tr');
                    row.className = 'hover:bg-gray-50';
                    row.innerHTML = `
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${queryId}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${stats.executionCount.toLocaleString()}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${Math.round(stats.averageExecutionTime)}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${stats.maxExecutionTime}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${stats.minExecutionTime}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${stats.totalExecutionTime.toLocaleString()}</td>
                    `;
                    tbody.appendChild(row);
                });
            }

            async executeAction(action, data = {}) {
                try {
                    const response = await fetch('/MeetLog/admin/performance', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ action, ...data })
                    });

                    const result = await response.json();

                    if (result.success) {
                        alert(result.message);
                        this.fetchPerformanceData(); // 데이터 새로고침
                    } else {
                        alert('오류: ' + result.message);
                    }
                } catch (error) {
                    console.error('액션 실행 오류:', error);
                    alert('액션 실행 중 오류가 발생했습니다.');
                }
            }

            startMonitoring() {
                if (this.isRunning) return;

                this.isRunning = true;
                this.fetchPerformanceData();

                // 주기적 업데이트
                this.monitoringInterval = setInterval(() => {
                    this.fetchPerformanceData();
                }, this.refreshInterval);
            }

            stopMonitoring() {
                this.isRunning = false;
                if (this.monitoringInterval) {
                    clearInterval(this.monitoringInterval);
                }
            }
        }

        // 페이지 로드 시 모니터링 시작
        document.addEventListener('DOMContentLoaded', function() {
            window.performanceMonitor = new PerformanceMonitor();
        });

        // 페이지 언로드 시 모니터링 중지
        window.addEventListener('beforeunload', function() {
            if (window.performanceMonitor) {
                window.performanceMonitor.stopMonitoring();
            }
        });
    </script>
</body>
</html>