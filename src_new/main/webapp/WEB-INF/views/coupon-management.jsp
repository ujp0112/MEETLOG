<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 쿠폰 관리</title>
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
                        <a href="${pageContext.request.contextPath}/admin/coupon-management" class="text-blue-600 font-medium">쿠폰 관리</a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">쿠폰 관리</h2>
                    <button class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                        새 쿠폰 생성
                    </button>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-blue-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">🎫</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 쿠폰</dt><dd class="text-lg font-medium text-gray-900">${couponStats.totalCoupons}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-green-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">✅</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">활성 쿠폰</dt><dd class="text-lg font-medium text-gray-900">${couponStats.activeCoupons}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-yellow-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">📊</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">사용된 쿠폰</dt><dd class="text-lg font-medium text-gray-900">${couponStats.usedCoupons}</dd></dl></div></div></div></div>
                    <div class="bg-white overflow-hidden shadow rounded-lg"><div class="p-5"><div class="flex items-center"><div class="flex-shrink-0"><div class="w-8 h-8 bg-purple-500 rounded-md flex items-center justify-center"><span class="text-white text-sm font-medium">💰</span></div></div><div class="ml-5 w-0 flex-1"><dl><dt class="text-sm font-medium text-gray-500 truncate">총 할인액</dt><dd class="text-lg font-medium text-gray-900"><fmt:formatNumber value="${couponStats.totalDiscountAmount}" type="currency" currencySymbol="₩"/></dd></dl></div></div></div></div>
                </div>
                
                <div class="bg-white shadow overflow-hidden sm:rounded-md">
                    <div class="px-4 py-5 sm:px-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">쿠폰 목록</h3>
                        <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 쿠폰을 관리할 수 있습니다.</p>
                    </div>
                    <ul class="divide-y divide-gray-200">
                        <c:forEach var="coupon" items="${coupons}">
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-16 w-16">
                                                <div class="h-16 w-16 rounded-lg bg-gradient-to-r from-red-500 to-pink-600 flex items-center justify-center">
                                                    <span class="text-white text-lg font-bold">🎫</span>
                                                </div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="flex items-center">
                                                    <p class="text-lg font-medium text-gray-900">${coupon.name}</p>
                                                    <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${coupon.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                                        ${coupon.status == 'ACTIVE' ? '활성' : '만료'}
                                                    </span>
                                                </div>
                                                <p class="text-sm text-gray-500">${coupon.description}</p>
                                                <div class="flex items-center mt-1">
                                                    <span class="text-sm text-gray-500">기간: <fmt:formatDate value="${coupon.startDate}" pattern="yyyy.MM.dd"/> ~ <fmt:formatDate value="${coupon.endDate}" pattern="yyyy.MM.dd"/></span>
                                                    <span class="ml-4 text-sm text-gray-500">사용: ${coupon.usedCount}/${coupon.totalCount}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <button class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">수정</button>
                                            <c:if test="${coupon.status == 'ACTIVE'}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="deactivate">
                                                    <input type="hidden" name="couponId" value="${coupon.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">비활성화</button>
                                                </form>
                                            </c:if>
                                            <form method="post" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="couponId" value="${coupon.id}">
                                                <button type="submit" onclick="return confirm('정말로 이 쿠폰을 삭제하시겠습니까?')" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">삭제</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>