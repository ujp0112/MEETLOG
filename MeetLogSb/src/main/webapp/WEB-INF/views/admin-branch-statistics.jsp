<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 지점 통계</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <div class="min-h-screen flex flex-col">
        <nav class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <h1 class="text-xl font-bold text-gray-900">MEET LOG 관리자</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-gray-700 hover:text-gray-900">대시보드</a>
                        <a href="${pageContext.request.contextPath}/admin/member-management" class="text-gray-700 hover:text-gray-900">회원 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/business-management" class="text-gray-700 hover:text-gray-900">업체 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/branch-management" class="text-gray-700 hover:text-gray-900">지점 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/employee-management" class="text-gray-700 hover:text-gray-900">직원 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/branch-statistics" class="text-blue-600 font-medium">지점 통계</a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">지점 통계</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-blue-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">🏢</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 지점 수</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalBranches}</dd></dl></div></div></div>
                    </div>
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-green-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">✅</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">운영 지점</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.activeBranches}</dd></dl></div></div></div>
                    </div>
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-yellow-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">👥</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 직원 수</dt><dd class="text-lg font-medium text-gray-900">${statisticsData.totalEmployees}</dd></dl></div></div></div>
                    </div>
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-purple-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">💰</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 매출</dt><dd class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${statisticsData.totalRevenue}" type="currency" currencySymbol="₩"/></dd></dl></div></div></div>
                    </div>
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-red-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">📊</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">지점당 평균 매출</dt><dd class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${statisticsData.averageRevenuePerBranch}" type="currency" currencySymbol="₩"/></dd></dl></div></div></div>
                    </div>
                </div>
                
                <div class="bg-white shadow rounded-lg mb-8">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">지점별 성과</h3>
                        <div class="space-y-4">
                            <c:forEach var="branch" items="${statisticsData.branchPerformances}">
                                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-12 w-12"><div class="h-12 w-12 rounded-lg bg-gradient-to-r from-indigo-500 to-purple-600 flex items-center justify-center"><span class="text-white text-lg font-bold">🏢</span></div></div>
                                        <div class="ml-4">
                                            <p class="text-lg font-medium text-gray-900">${branch.branchName}</p>
                                            <p class="text-sm text-gray-500">직원 ${branch.employeeCount}명 | 고객 ${branch.customerCount}명 | 예약 ${branch.reservationCount}건</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${branch.monthlyRevenue}" type="currency" currencySymbol="₩"/></p>
                                        <div class="flex items-center">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span class="text-sm ${i <= branch.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                            </c:forEach>
                                            <span class="ml-2 text-sm text-gray-500">${branch.rating}</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">월별 매출 추이</h3>
                        <div class="space-y-4">
                            <c:forEach var="month" items="${statisticsData.monthlyRevenues}">
                                <div class="p-4 bg-gray-50 rounded-lg">
                                    <div class="flex justify-between items-center mb-2">
                                        <h4 class="text-lg font-medium text-gray-900">${month.month}</h4>
                                        <p class="text-lg font-bold text-gray-900"><fmt:formatNumber value="${month.revenue}" type="currency" currencySymbol="₩"/></p>
                                    </div>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <c:forEach var="branchRevenue" items="${month.branchRevenues}">
                                            <div class="flex justify-between items-center p-2 bg-white rounded">
                                                <span class="text-sm text-gray-600">${branchRevenue.branchName}</span>
                                                <span class="text-sm font-medium text-gray-900"><fmt:formatNumber value="${branchRevenue.revenue}" type="currency" currencySymbol="₩"/></span>
                                            </div>
                                        </c:forEach>
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
</body>
</html>