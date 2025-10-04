<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 통계 대시보드</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100">

    <c:set var="adminMenu" scope="request" value="statistics" />
    <div class="min-h-screen flex flex-col">
        <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">통계 대시보드</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-6 mb-8">
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-blue-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">👥</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 사용자</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalUsers}</dd><dd class="text-sm text-green-600">+${statisticsData.userGrowthRate}%</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-green-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">🏪</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 맛집</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalRestaurants}</dd><dd class="text-sm text-green-600">+${statisticsData.restaurantGrowthRate}%</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-yellow-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">📅</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 예약</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalReservations}</dd><dd class="text-sm text-green-600">+${statisticsData.reservationGrowthRate}%</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-purple-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">💰</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 매출</dt><dd class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${statisticsData.totalRevenue}" type="currency" currencySymbol="₩"/></dd><dd class="text-sm text-green-600">+${statisticsData.revenueGrowthRate}%</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-red-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">🏢</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 지점</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalBranches}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-indigo-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">👨‍💼</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 직원</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalEmployees}</dd></dl></div></div></div></div>
                </div>
                
                <div class="bg-white shadow rounded-lg mb-8">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">인기 카테고리 TOP 5</h3>
                        <div class="space-y-4">
                            <c:forEach var="category" items="${statisticsData.popularCategories}" varStatus="status">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div class="flex items-center">
                                        <span class="text-lg font-bold text-gray-900 mr-4">${status.index + 1}</span>
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">${category.categoryName}</p>
                                            <p class="text-sm text-gray-500">맛집 ${category.restaurantCount}개 | 예약 ${category.reservationCount}건</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${category.revenue}" type="currency" currencySymbol="₩"/></p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <!-- 월별 성장 추이 차트 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    <div class="bg-white shadow rounded-lg p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">월별 사용자 & 예약 추이</h3>
                        <canvas id="growthChart"></canvas>
                    </div>
                    <div class="bg-white shadow rounded-lg p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">월별 매출 추이</h3>
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- 카테고리별 분포 차트 -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    <div class="bg-white shadow rounded-lg p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">카테고리별 매출 분포</h3>
                        <canvas id="categoryChart"></canvas>
                    </div>
                    <div class="bg-white shadow rounded-lg p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">지역별 예약 분포</h3>
                        <canvas id="regionChart"></canvas>
                    </div>
                </div>
                
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">지역별 분포</h3>
                        <div class="space-y-4">
                            <c:forEach var="region" items="${statisticsData.regionalDistributions}">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div>
                                        <p class="text-sm font-medium text-gray-900">${region.region}</p>
                                        <p class="text-sm text-gray-500">맛집 ${region.restaurantCount}개 | 예약 ${region.reservationCount}건</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${region.revenue}" type="currency" currencySymbol="₩"/></p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

    <script>
        // 월별 사용자 & 예약 추이 차트
        const growthCtx = document.getElementById('growthChart').getContext('2d');
        const growthChart = new Chart(growthCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="month" items="${statisticsData.monthlyGrowths}" varStatus="status">
                        '${month.yearMonth}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: '사용자',
                    data: [
                        <c:forEach var="month" items="${statisticsData.monthlyGrowths}" varStatus="status">
                            ${month.totalUsers}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    borderColor: 'rgb(59, 130, 246)',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    tension: 0.4
                }, {
                    label: '예약',
                    data: [
                        <c:forEach var="month" items="${statisticsData.monthlyGrowths}" varStatus="status">
                            ${month.totalReservations}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    borderColor: 'rgb(16, 185, 129)',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        // 월별 매출 추이 차트
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach var="month" items="${statisticsData.monthlyGrowths}" varStatus="status">
                        '${month.yearMonth}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: '매출',
                    data: [
                        <c:forEach var="month" items="${statisticsData.monthlyGrowths}" varStatus="status">
                            ${month.totalRevenue}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(147, 51, 234, 0.6)',
                    borderColor: 'rgb(147, 51, 234)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        // 카테고리별 매출 분포 차트
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        const categoryChart = new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: [
                    <c:forEach var="category" items="${statisticsData.popularCategories}" varStatus="status">
                        '${category.categoryName}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    data: [
                        <c:forEach var="category" items="${statisticsData.popularCategories}" varStatus="status">
                            ${category.revenue}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: [
                        'rgba(59, 130, 246, 0.8)',
                        'rgba(16, 185, 129, 0.8)',
                        'rgba(251, 191, 36, 0.8)',
                        'rgba(239, 68, 68, 0.8)',
                        'rgba(147, 51, 234, 0.8)'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'right' }
                }
            }
        });

        // 지역별 예약 분포 차트
        const regionCtx = document.getElementById('regionChart').getContext('2d');
        const regionChart = new Chart(regionCtx, {
            type: 'pie',
            data: {
                labels: [
                    <c:forEach var="region" items="${statisticsData.regionalDistributions}" varStatus="status">
                        '${region.region}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    data: [
                        <c:forEach var="region" items="${statisticsData.regionalDistributions}" varStatus="status">
                            ${region.reservationCount}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: [
                        'rgba(239, 68, 68, 0.8)',
                        'rgba(251, 191, 36, 0.8)',
                        'rgba(16, 185, 129, 0.8)',
                        'rgba(59, 130, 246, 0.8)',
                        'rgba(147, 51, 234, 0.8)',
                        'rgba(236, 72, 153, 0.8)'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'right' }
                }
            }
        });
    </script>

</body>
</html>
