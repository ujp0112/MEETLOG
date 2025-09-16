<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 고객 지원 대시보드</title>
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
                        <a href="${pageContext.request.contextPath}/admin/support-dashboard" class="text-blue-600 font-medium">고객 지원</a>
                        <a href="${pageContext.request.contextPath}/admin/feedback-management" class="text-gray-700 hover:text-gray-900">피드백 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/support-statistics" class="text-gray-700 hover:text-gray-900">지원 통계</a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">고객 지원 대시보드</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-blue-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">📞</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 문의</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.totalInquiries}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-yellow-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">⏳</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">대기 중</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.pendingInquiries}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-green-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">✅</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">해결됨</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.resolvedInquiries}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-purple-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">⏱️</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">평균 응답시간</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.averageResponseTime}시간</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-red-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">😊</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">고객 만족도</dt><dd class="text-lg font-medium text-gray-900">${dashboardData.customerSatisfaction}/5</dd></dl></div></div></div></div>
                </div>
                
                <div class="bg-white shadow rounded-lg mb-8">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">문의 유형별 통계</h3>
                        <div class="space-y-4">
                            <c:forEach var="type" items="${dashboardData.inquiryTypeStats}">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10"><div class="h-10 w-10 rounded-lg bg-blue-100 flex items-center justify-center"><span class="text-blue-600 text-sm font-medium">📋</span></div></div>
                                        <div class="ml-4">
                                            <p class="text-sm font-medium text-gray-900">${type.type}</p>
                                            <p class="text-sm text-gray-500">총 ${type.count}건 (${type.percentage}%)</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-sm text-green-600">해결: ${type.resolvedCount}건</p>
                                        <p class="text-sm text-yellow-600">대기: ${type.pendingCount}건</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white shadow rounded-lg mb-8">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">최근 문의</h3>
                        <div class="space-y-4">
                            <c:forEach var="inquiry" items="${dashboardData.recentInquiries}">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10"><div class="h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center"><span class="text-sm font-medium text-gray-700">${inquiry.userName.charAt(0)}</span></div></div>
                                        <div class="ml-4">
                                            <div class="flex items-center">
                                                <p class="text-sm font-medium text-gray-900">${inquiry.userName}</p>
                                                <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${inquiry.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' : inquiry.status == 'IN_PROGRESS' ? 'bg-blue-100 text-blue-800' : 'bg-green-100 text-green-800'}">
                                                    ${inquiry.status == 'PENDING' ? '대기중' : inquiry.status == 'IN_PROGRESS' ? '처리중' : '해결됨'}
                                                </span>
                                                <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${inquiry.priority == 'HIGH' ? 'bg-red-100 text-red-800' : inquiry.priority == 'MEDIUM' ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}">
                                                    ${inquiry.priority == 'HIGH' ? '높음' : inquiry.priority == 'MEDIUM' ? '보통' : '낮음'}
                                                </span>
                                            </div>
                                            <p class="text-sm text-gray-500">${inquiry.subject} (${inquiry.type})</p>
                                            <p class="text-xs text-gray-400"><fmt:formatDate value="${inquiry.createdAt}" pattern="yyyy.MM.dd HH:mm"/></p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">고객 만족도 통계</h3>
                        <div class="space-y-3">
                            <c:forEach var="satisfaction" items="${dashboardData.satisfactionStats}">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <span class="text-sm font-medium text-gray-900">${satisfaction.rating}점</span>
                                        <div class="ml-4 w-32 bg-gray-200 rounded-full h-2">
                                            <div class="bg-blue-600 h-2 rounded-full" style="width: ${satisfaction.percentage}%"></div>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <span class="text-sm text-gray-500">${satisfaction.count}명 (${satisfaction.percentage}%)</span>
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