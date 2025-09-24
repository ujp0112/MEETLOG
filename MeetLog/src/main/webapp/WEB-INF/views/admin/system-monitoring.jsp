<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시스템 통합 모니터링 - MEETLOG</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
    <script src="${pageContext.request.contextPath}/js/chart-utils.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }
        .status-green { background-color: #10B981; }
        .status-yellow { background-color: #F59E0B; }
        .status-red { background-color: #EF4444; }

        .metric-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .metric-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .log-entry {
            border-left: 4px solid transparent;
            transition: all 0.2s ease;
        }
        .log-entry:hover {
            background-color: #F9FAFB;
        }
        .log-entry.error { border-left-color: #EF4444; }
        .log-entry.security { border-left-color: #F59E0B; }
        .log-entry.performance { border-left-color: #8B5CF6; }
        .log-entry.info { border-left-color: #10B981; }
    </style>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen">
        <!-- 헤더 -->
        <header class="bg-white shadow-sm border-b">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center py-4">
                    <div class="flex items-center space-x-6">
                        <h1 class="text-2xl font-bold text-gray-900">시스템 통합 모니터링</h1>
                        <div class="flex items-center space-x-4">
                            <div class="flex items-center">
                                <span id="systemStatus" class="status-indicator status-green"></span>
                                <span class="text-sm font-medium text-gray-600">시스템 상태</span>
                            </div>
                            <div class="text-sm text-gray-500">
                                마지막 업데이트: <span id="lastUpdate">--:--</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <select id="refreshInterval" class="px-3 py-2 border border-gray-300 rounded-lg text-sm">
                            <option value="5000">5초마다</option>
                            <option value="10000" selected>10초마다</option>
                            <option value="30000">30초마다</option>
                            <option value="60000">1분마다</option>
                        </select>
                        <button id="pauseBtn" class="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                            <i class="fas fa-pause mr-2"></i>일시정지
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <!-- 탭 네비게이션 -->
        <nav class="bg-white border-b">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex space-x-8">
                    <button class="tab-btn active px-4 py-3 text-sm font-medium border-b-2 border-blue-500 text-blue-600" data-tab="dashboard">
                        <i class="fas fa-tachometer-alt mr-2"></i>대시보드
                    </button>
                    <button class="tab-btn px-4 py-3 text-sm font-medium border-b-2 border-transparent text-gray-500 hover:text-gray-700" data-tab="logs">
                        <i class="fas fa-file-alt mr-2"></i>로그
                    </button>
                    <button class="tab-btn px-4 py-3 text-sm font-medium border-b-2 border-transparent text-gray-500 hover:text-gray-700" data-tab="performance">
                        <i class="fas fa-chart-line mr-2"></i>성능
                    </button>
                    <button class="tab-btn px-4 py-3 text-sm font-medium border-b-2 border-transparent text-gray-500 hover:text-gray-700" data-tab="security">
                        <i class="fas fa-shield-alt mr-2"></i>보안
                    </button>
                    <button class="tab-btn px-4 py-3 text-sm font-medium border-b-2 border-transparent text-gray-500 hover:text-gray-700" data-tab="system">
                        <i class="fas fa-server mr-2"></i>시스템
                    </button>
                </div>
            </div>
        </nav>

        <!-- 메인 콘텐츠 -->
        <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

            <!-- 대시보드 탭 -->
            <div id="dashboard-tab" class="tab-content">
                <!-- 시스템 개요 -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <!-- 업타임 -->
                    <div class="metric-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">시스템 업타임</p>
                                <p id="systemUptime" class="text-2xl font-bold text-green-600">0일</p>
                            </div>
                            <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-clock text-green-600 text-xl"></i>
                            </div>
                        </div>
                    </div>

                    <!-- 총 로그 수 -->
                    <div class="metric-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">총 로그 수</p>
                                <p id="totalLogs" class="text-2xl font-bold text-blue-600">0</p>
                            </div>
                            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-file-alt text-blue-600 text-xl"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <p class="text-sm text-gray-500">에러: <span id="errorLogsCount" class="text-red-600 font-semibold">0</span></p>
                        </div>
                    </div>

                    <!-- JVM 메모리 사용률 -->
                    <div class="metric-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">JVM 메모리</p>
                                <p id="jvmMemoryUsage" class="text-2xl font-bold text-purple-600">0%</p>
                            </div>
                            <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-memory text-purple-600 text-xl"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <p class="text-sm text-gray-500">사용: <span id="usedMemory">0</span> MB</p>
                        </div>
                    </div>

                    <!-- 작업 성공률 -->
                    <div class="metric-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">작업 성공률</p>
                                <p id="taskSuccessRate" class="text-2xl font-bold text-orange-600">100%</p>
                            </div>
                            <div class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-tasks text-orange-600 text-xl"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <p class="text-sm text-gray-500">총 작업: <span id="totalTasks">0</span>개</p>
                        </div>
                    </div>
                </div>

                <!-- 차트 영역 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    <!-- 로그 레벨 분포 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">로그 레벨 분포</h3>
                        <div style="height: 300px;">
                            <canvas id="logLevelChart"></canvas>
                        </div>
                    </div>

                    <!-- 시스템 리소스 사용률 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">시스템 리소스</h3>
                        <div style="height: 300px;">
                            <canvas id="resourceChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 최근 중요 이벤트 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- 최근 에러 -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                        <div class="p-6 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">최근 에러</h3>
                        </div>
                        <div class="p-6">
                            <div id="recentErrors" class="space-y-3">
                                <!-- 동적으로 생성 -->
                            </div>
                        </div>
                    </div>

                    <!-- 최근 보안 이벤트 -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                        <div class="p-6 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">최근 보안 이벤트</h3>
                        </div>
                        <div class="p-6">
                            <div id="recentSecurity" class="space-y-3">
                                <!-- 동적으로 생성 -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 로그 탭 -->
            <div id="logs-tab" class="tab-content hidden">
                <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                    <div class="p-6 border-b border-gray-200">
                        <div class="flex justify-between items-center">
                            <h3 class="text-lg font-semibold text-gray-900">시스템 로그</h3>
                            <div class="flex items-center space-x-4">
                                <select id="logLevelFilter" class="px-3 py-2 border border-gray-300 rounded-lg text-sm">
                                    <option value="">모든 레벨</option>
                                    <option value="ERROR">에러</option>
                                    <option value="SECURITY">보안</option>
                                    <option value="PERFORMANCE">성능</option>
                                    <option value="INFO">정보</option>
                                </select>
                                <button id="refreshLogsBtn" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                    <i class="fas fa-sync-alt mr-2"></i>새로고침
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="max-h-96 overflow-y-auto">
                        <div id="logEntries" class="divide-y divide-gray-200">
                            <!-- 동적으로 생성 -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- 성능 탭 -->
            <div id="performance-tab" class="tab-content hidden">
                <!-- 성능 차트와 통계 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    <!-- 쿼리 성능 차트 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">상위 쿼리 성능</h3>
                        <div style="height: 300px;">
                            <canvas id="queryPerformanceChart"></canvas>
                        </div>
                    </div>

                    <!-- 시스템 성능 트렌드 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">성능 트렌드</h3>
                        <div style="height: 300px;">
                            <canvas id="performanceTrendChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 성능 통계 테이블 -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900">쿼리 성능 상세</h3>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">쿼리 ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">실행 횟수</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">평균 시간</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">최대 시간</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">총 시간</th>
                                </tr>
                            </thead>
                            <tbody id="performanceTable" class="bg-white divide-y divide-gray-200">
                                <!-- 동적으로 생성 -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 보안 탭 -->
            <div id="security-tab" class="tab-content hidden">
                <!-- 보안 통계 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    <!-- 보안 이벤트 차트 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">보안 이벤트 유형</h3>
                        <div style="height: 300px;">
                            <canvas id="securityEventChart"></canvas>
                        </div>
                    </div>

                    <!-- IP 별 접근 통계 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">IP 별 접근</h3>
                        <div style="height: 300px;">
                            <canvas id="ipStatsChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 보안 로그 -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900">보안 로그</h3>
                    </div>
                    <div class="max-h-96 overflow-y-auto">
                        <div id="securityLogs" class="divide-y divide-gray-200">
                            <!-- 동적으로 생성 -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- 시스템 탭 -->
            <div id="system-tab" class="tab-content hidden">
                <!-- 시스템 정보 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- JVM 정보 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">JVM 정보</h3>
                        <div id="jvmInfo" class="space-y-3">
                            <!-- 동적으로 생성 -->
                        </div>
                    </div>

                    <!-- 시스템 정보 -->
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">시스템 정보</h3>
                        <div id="systemInfo" class="space-y-3">
                            <!-- 동적으로 생성 -->
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <script>
        class SystemMonitoring {
            constructor() {
                this.charts = {};
                this.isMonitoring = true;
                this.refreshInterval = 10000;
                this.currentTab = 'dashboard';

                this.init();
            }

            init() {
                this.initEventListeners();
                this.initCharts();
                this.startMonitoring();
            }

            initEventListeners() {
                // 탭 전환
                document.querySelectorAll('.tab-btn').forEach(btn => {
                    btn.addEventListener('click', (e) => {
                        this.switchTab(e.target.dataset.tab);
                    });
                });

                // 새로고침 간격 변경
                document.getElementById('refreshInterval').addEventListener('change', (e) => {
                    this.refreshInterval = parseInt(e.target.value);
                    this.restartMonitoring();
                });

                // 일시정지/재시작
                document.getElementById('pauseBtn').addEventListener('click', () => {
                    this.toggleMonitoring();
                });

                // 로그 필터
                document.getElementById('logLevelFilter').addEventListener('change', () => {
                    this.loadLogs();
                });

                // 로그 새로고침
                document.getElementById('refreshLogsBtn').addEventListener('click', () => {
                    this.loadLogs();
                });
            }

            initCharts() {
                // 로그 레벨 분포 차트
                const logLevelCtx = document.getElementById('logLevelChart').getContext('2d');
                this.charts.logLevel = ChartUtils.createDoughnutChart(logLevelCtx, {
                    title: '로그 레벨 분포',
                    data: {
                        labels: ['INFO', 'ERROR', 'SECURITY', 'PERFORMANCE'],
                        datasets: [{
                            data: [0, 0, 0, 0],
                            backgroundColor: ['#10B981', '#EF4444', '#F59E0B', '#8B5CF6']
                        }]
                    }
                });

                // 리소스 사용률 차트
                const resourceCtx = document.getElementById('resourceChart').getContext('2d');
                this.charts.resource = ChartUtils.createBarChart(resourceCtx, {
                    title: '시스템 리소스',
                    data: {
                        labels: ['메모리', 'CPU', '캐시', 'DB 연결'],
                        datasets: [{
                            label: '사용률 (%)',
                            data: [0, 0, 0, 0],
                            backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#8B5CF6']
                        }]
                    }
                });

                // 쿼리 성능 차트
                const queryPerfCtx = document.getElementById('queryPerformanceChart').getContext('2d');
                this.charts.queryPerformance = ChartUtils.createBarChart(queryPerfCtx, {
                    title: '상위 쿼리 성능',
                    data: {
                        labels: [],
                        datasets: [{
                            label: '평균 실행 시간 (ms)',
                            data: [],
                            backgroundColor: '#EF4444'
                        }]
                    }
                });

                // 성능 트렌드 차트
                const perfTrendCtx = document.getElementById('performanceTrendChart').getContext('2d');
                this.charts.performanceTrend = ChartUtils.createLineChart(perfTrendCtx, {
                    title: '성능 트렌드',
                    data: {
                        labels: [],
                        datasets: [{
                            label: '평균 응답시간',
                            data: [],
                            borderColor: '#3B82F6',
                            backgroundColor: 'rgba(59, 130, 246, 0.1)'
                        }]
                    }
                });

                // 보안 이벤트 차트
                const secEventCtx = document.getElementById('securityEventChart').getContext('2d');
                this.charts.securityEvent = ChartUtils.createDoughnutChart(secEventCtx, {
                    title: '보안 이벤트 유형',
                    data: {
                        labels: [],
                        datasets: [{
                            data: [],
                            backgroundColor: ['#EF4444', '#F59E0B', '#8B5CF6', '#10B981']
                        }]
                    }
                });

                // IP 통계 차트
                const ipStatsCtx = document.getElementById('ipStatsChart').getContext('2d');
                this.charts.ipStats = ChartUtils.createBarChart(ipStatsCtx, {
                    title: 'IP 별 접근',
                    data: {
                        labels: [],
                        datasets: [{
                            label: '접근 횟수',
                            data: [],
                            backgroundColor: '#3B82F6'
                        }]
                    }
                });
            }

            async loadDashboardData() {
                try {
                    const response = await fetch('/MeetLog/admin/monitoring?action=dashboard');
                    const result = await response.json();

                    if (result.success) {
                        this.updateDashboard(result);
                    }
                } catch (error) {
                    console.error('대시보드 데이터 로드 실패:', error);
                }
            }

            updateDashboard(data) {
                // 업타임 업데이트
                const uptime = Math.floor((Date.now() - data.overview.timestamp) / (1000 * 60 * 60 * 24));
                document.getElementById('systemUptime').textContent = uptime + '일';

                // 로그 통계 업데이트
                document.getElementById('totalLogs').textContent = data.logs.totalLogs.toLocaleString();
                document.getElementById('errorLogsCount').textContent = data.logs.errorLogs.toLocaleString();

                // JVM 메모리 업데이트
                const memoryUsage = Math.round(data.overview.jvmMemoryUsage);
                document.getElementById('jvmMemoryUsage').textContent = memoryUsage + '%';
                document.getElementById('usedMemory').textContent = Math.round(data.overview.jvmMemoryUsed / 1024 / 1024);

                // 작업 성공률 업데이트
                document.getElementById('taskSuccessRate').textContent = Math.round(data.performance.asyncTasks.successRate) + '%';
                document.getElementById('totalTasks').textContent = data.performance.asyncTasks.totalSubmitted.toLocaleString();

                // 차트 업데이트
                this.charts.logLevel.data.datasets[0].data = [
                    data.logs.totalLogs - data.logs.errorLogs - data.logs.securityLogs - data.logs.performanceLogs,
                    data.logs.errorLogs,
                    data.logs.securityLogs,
                    data.logs.performanceLogs
                ];
                this.charts.logLevel.update();

                // 최근 이벤트 업데이트
                this.updateRecentEvents(data.recentErrors, 'recentErrors');
                this.updateRecentEvents(data.recentSecurity, 'recentSecurity');

                // 마지막 업데이트 시간
                document.getElementById('lastUpdate').textContent = new Date().toLocaleTimeString();
            }

            updateRecentEvents(events, containerId) {
                const container = document.getElementById(containerId);
                container.innerHTML = '';

                if (events.length === 0) {
                    container.innerHTML = '<p class="text-gray-500 text-sm">최근 이벤트가 없습니다.</p>';
                    return;
                }

                events.slice(0, 5).forEach(event => {
                    const eventElement = document.createElement('div');
                    eventElement.className = `log-entry ${event.level.toLowerCase()} p-3 rounded-lg`;
                    eventElement.innerHTML = `
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-900">${event.message}</p>
                                <p class="text-xs text-gray-500 mt-1">${event.timestamp}</p>
                            </div>
                            <span class="px-2 py-1 bg-gray-100 text-xs rounded">${event.level}</span>
                        </div>
                    `;
                    container.appendChild(eventElement);
                });
            }

            async loadLogs() {
                const level = document.getElementById('logLevelFilter').value;

                try {
                    const response = await fetch(`/MeetLog/admin/monitoring?action=logs&level=${level}&limit=100`);
                    const result = await response.json();

                    if (result.success) {
                        this.updateLogEntries(result.logs);
                    }
                } catch (error) {
                    console.error('로그 데이터 로드 실패:', error);
                }
            }

            updateLogEntries(logs) {
                const container = document.getElementById('logEntries');
                container.innerHTML = '';

                logs.forEach(log => {
                    const logElement = document.createElement('div');
                    logElement.className = `log-entry ${log.level.toLowerCase()} p-4`;
                    logElement.innerHTML = `
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <div class="flex items-center space-x-2 mb-1">
                                    <span class="px-2 py-1 bg-gray-100 text-xs rounded font-medium">${log.level}</span>
                                    <span class="text-xs text-gray-500">${log.timestamp}</span>
                                </div>
                                <p class="text-sm text-gray-900">${log.message}</p>
                                ${log.ipAddress ? `<p class="text-xs text-gray-500 mt-1">IP: ${log.ipAddress}</p>` : ''}
                                ${log.requestUri ? `<p class="text-xs text-gray-500">URI: ${log.method} ${log.requestUri}</p>` : ''}
                            </div>
                        </div>
                    `;
                    container.appendChild(logElement);
                });
            }

            switchTab(tabName) {
                // 탭 버튼 업데이트
                document.querySelectorAll('.tab-btn').forEach(btn => {
                    btn.classList.remove('active', 'border-blue-500', 'text-blue-600');
                    btn.classList.add('border-transparent', 'text-gray-500');
                });

                document.querySelector(`[data-tab="${tabName}"]`).classList.add('active', 'border-blue-500', 'text-blue-600');

                // 탭 콘텐츠 전환
                document.querySelectorAll('.tab-content').forEach(content => {
                    content.classList.add('hidden');
                });

                document.getElementById(`${tabName}-tab`).classList.remove('hidden');
                this.currentTab = tabName;

                // 탭별 데이터 로드
                this.loadTabData(tabName);
            }

            async loadTabData(tabName) {
                switch (tabName) {
                    case 'dashboard':
                        await this.loadDashboardData();
                        break;
                    case 'logs':
                        await this.loadLogs();
                        break;
                    case 'performance':
                        await this.loadPerformanceData();
                        break;
                    case 'security':
                        await this.loadSecurityData();
                        break;
                    case 'system':
                        await this.loadSystemData();
                        break;
                }
            }

            async loadPerformanceData() {
                try {
                    const response = await fetch('/MeetLog/admin/monitoring?action=performance');
                    const result = await response.json();

                    if (result.success) {
                        // 쿼리 성능 차트 업데이트
                        const queries = Object.keys(result.topQueries).slice(0, 10);
                        const avgTimes = queries.map(q => Math.round(result.topQueries[q].averageTime));

                        this.charts.queryPerformance.data.labels = queries;
                        this.charts.queryPerformance.data.datasets[0].data = avgTimes;
                        this.charts.queryPerformance.update();

                        // 성능 테이블 업데이트
                        this.updatePerformanceTable(result.topQueries);
                    }
                } catch (error) {
                    console.error('성능 데이터 로드 실패:', error);
                }
            }

            updatePerformanceTable(queries) {
                const tbody = document.getElementById('performanceTable');
                tbody.innerHTML = '';

                Object.entries(queries).forEach(([queryId, stats]) => {
                    const row = document.createElement('tr');
                    row.className = 'hover:bg-gray-50';
                    row.innerHTML = `
                        <td class="px-6 py-4 text-sm font-medium text-gray-900">${queryId}</td>
                        <td class="px-6 py-4 text-sm text-gray-500">${stats.executionCount.toLocaleString()}</td>
                        <td class="px-6 py-4 text-sm text-gray-500">${Math.round(stats.averageTime)}ms</td>
                        <td class="px-6 py-4 text-sm text-gray-500">${stats.maxTime}ms</td>
                        <td class="px-6 py-4 text-sm text-gray-500">${stats.totalTime.toLocaleString()}ms</td>
                    `;
                    tbody.appendChild(row);
                });
            }

            async loadSecurityData() {
                try {
                    const response = await fetch('/MeetLog/admin/monitoring?action=security');
                    const result = await response.json();

                    if (result.success) {
                        // 보안 이벤트 차트 업데이트
                        const eventTypes = Object.keys(result.eventStats);
                        const eventCounts = Object.values(result.eventStats);

                        this.charts.securityEvent.data.labels = eventTypes;
                        this.charts.securityEvent.data.datasets[0].data = eventCounts;
                        this.charts.securityEvent.update();

                        // IP 통계 차트 업데이트
                        const ips = Object.keys(result.ipStats).slice(0, 10);
                        const ipCounts = ips.map(ip => result.ipStats[ip]);

                        this.charts.ipStats.data.labels = ips;
                        this.charts.ipStats.data.datasets[0].data = ipCounts;
                        this.charts.ipStats.update();

                        // 보안 로그 업데이트
                        this.updateSecurityLogs(result.securityLogs);
                    }
                } catch (error) {
                    console.error('보안 데이터 로드 실패:', error);
                }
            }

            updateSecurityLogs(logs) {
                const container = document.getElementById('securityLogs');
                container.innerHTML = '';

                logs.slice(0, 20).forEach(log => {
                    const logElement = document.createElement('div');
                    logElement.className = 'log-entry security p-4';
                    logElement.innerHTML = `
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-900">${log.message}</p>
                                <div class="flex items-center space-x-4 mt-1 text-xs text-gray-500">
                                    <span>${log.timestamp}</span>
                                    ${log.ipAddress ? `<span>IP: ${log.ipAddress}</span>` : ''}
                                    ${log.requestUri ? `<span>URI: ${log.requestUri}</span>` : ''}
                                </div>
                            </div>
                        </div>
                    `;
                    container.appendChild(logElement);
                });
            }

            async loadSystemData() {
                try {
                    const response = await fetch('/MeetLog/admin/monitoring?action=system');
                    const result = await response.json();

                    if (result.success) {
                        this.updateJvmInfo(result.jvm);
                        this.updateSystemInfo(result.system);
                    }
                } catch (error) {
                    console.error('시스템 데이터 로드 실패:', error);
                }
            }

            updateJvmInfo(jvm) {
                const container = document.getElementById('jvmInfo');
                container.innerHTML = `
                    <div class="flex justify-between py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-600">최대 메모리</span>
                        <span class="text-sm text-gray-900">${Math.round(jvm.maxMemory / 1024 / 1024)} MB</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-600">할당된 메모리</span>
                        <span class="text-sm text-gray-900">${Math.round(jvm.totalMemory / 1024 / 1024)} MB</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-600">사용 중인 메모리</span>
                        <span class="text-sm text-gray-900">${Math.round(jvm.usedMemory / 1024 / 1024)} MB</span>
                    </div>
                    <div class="flex justify-between py-2">
                        <span class="text-sm font-medium text-gray-600">프로세서 수</span>
                        <span class="text-sm text-gray-900">${jvm.availableProcessors}개</span>
                    </div>
                `;
            }

            updateSystemInfo(system) {
                const container = document.getElementById('systemInfo');
                container.innerHTML = `
                    <div class="flex justify-between py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-600">Java 버전</span>
                        <span class="text-sm text-gray-900">${system.javaVersion}</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-600">운영체제</span>
                        <span class="text-sm text-gray-900">${system.osName} ${system.osVersion}</span>
                    </div>
                    <div class="flex justify-between py-2">
                        <span class="text-sm font-medium text-gray-600">작업 디렉토리</span>
                        <span class="text-sm text-gray-900 truncate">${system.userDir}</span>
                    </div>
                `;
            }

            toggleMonitoring() {
                const btn = document.getElementById('pauseBtn');

                if (this.isMonitoring) {
                    this.stopMonitoring();
                    btn.innerHTML = '<i class="fas fa-play mr-2"></i>재시작';
                    btn.classList.remove('bg-gray-600', 'hover:bg-gray-700');
                    btn.classList.add('bg-green-600', 'hover:bg-green-700');
                } else {
                    this.startMonitoring();
                    btn.innerHTML = '<i class="fas fa-pause mr-2"></i>일시정지';
                    btn.classList.remove('bg-green-600', 'hover:bg-green-700');
                    btn.classList.add('bg-gray-600', 'hover:bg-gray-700');
                }
            }

            startMonitoring() {
                if (this.isMonitoring) return;

                this.isMonitoring = true;
                this.loadTabData(this.currentTab);

                this.monitoringInterval = setInterval(() => {
                    this.loadTabData(this.currentTab);
                }, this.refreshInterval);
            }

            stopMonitoring() {
                this.isMonitoring = false;
                if (this.monitoringInterval) {
                    clearInterval(this.monitoringInterval);
                }
            }

            restartMonitoring() {
                this.stopMonitoring();
                this.startMonitoring();
            }
        }

        // 페이지 로드 시 모니터링 시작
        document.addEventListener('DOMContentLoaded', function() {
            window.systemMonitoring = new SystemMonitoring();
        });

        // 페이지 언로드 시 모니터링 중지
        window.addEventListener('beforeunload', function() {
            if (window.systemMonitoring) {
                window.systemMonitoring.stopMonitoring();
            }
        });
    </script>
</body>
</html>