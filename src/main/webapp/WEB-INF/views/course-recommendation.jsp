<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 코스 추천</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-gray-100">

    <div class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">맞춤 코스 추천</h2>
                
                <div class="bg-white shadow rounded-lg mb-8">
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">추천 기준을 선택해주세요</h3>
                        <form class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                            <div class="space-y-2">
                                <label class="block text-sm font-medium text-gray-700">지역</label>
                                <select name="area" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="">지역 선택</option>
                                    <option value="강남구">강남구</option>
                                    <option value="마포구">마포구</option>
                                    <option value="종로구">종로구</option>
                                    <option value="홍대">홍대</option>
                                </select>
                            </div>
                            <div class="space-y-2">
                                <label class="block text-sm font-medium text-gray-700">카테고리</label>
                                <select name="category" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="">카테고리 선택</option>
                                    <option value="한식">한식</option>
                                    <option value="일식">일식</option>
                                    <option value="양식">양식</option>
                                    <option value="중식">중식</option>
                                </select>
                            </div>
                            <div class="space-y-2">
                                <label class="block text-sm font-medium text-gray-700">예산</label>
                                <select name="budget" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="">예산 선택</option>
                                    <option value="30000">3만원 이하</option>
                                    <option value="50000">3-5만원</option>
                                    <option value="100000">5-10만원</option>
                                    <option value="100001">10만원 이상</option>
                                </select>
                            </div>
                            <div>
                                <button type="submit" class="w-full bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">
                                    추천받기
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="course" items="${courses}">
                        <div class="bg-white shadow rounded-lg overflow-hidden">
                            <div class="h-48 bg-gradient-to-r from-blue-500 to-purple-600 flex items-center justify-center">
                                <span class="text-white text-4xl">${course.icon}</span>
                            </div>
                            <div class="p-6">
                                <h3 class="text-lg font-medium text-gray-900 mb-2">${course.title}</h3>
                                <p class="text-sm text-gray-500 mb-4 h-10">${course.description}</p>
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <span class="text-sm text-gray-500">⏱️ ${course.duration}</span>
                                        <span class="ml-4 text-sm text-gray-500">💰 <fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₩"/></span>
                                    </div>
                                    <div class="flex items-center">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span class="text-sm ${i <= course.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                        </c:forEach>
                                        <span class="ml-1 text-sm text-gray-500">${course.rating}</span>
                                    </div>
                                </div>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/courses/${course.id}" class="block w-full text-center bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                                        상세보기
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>