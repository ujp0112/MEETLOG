<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 메뉴 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <div class="min-h-screen">
        <!-- 비즈니스 헤더 -->
        <nav class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <h1 class="text-xl font-bold text-gray-900">메뉴 관리</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/business/dashboard" 
                           class="text-gray-700 hover:text-gray-900">대시보드</a>
                        <a href="${pageContext.request.contextPath}/business/menu-management" 
                           class="text-blue-600 font-medium">메뉴 관리</a>
                        <a href="${pageContext.request.contextPath}/business/reservation-management" 
                           class="text-gray-700 hover:text-gray-900">예약 관리</a>
                        <a href="${pageContext.request.contextPath}/business/review-management" 
                           class="text-gray-700 hover:text-gray-900">리뷰 관리</a>
                        <a href="${pageContext.request.contextPath}/business/info-edit" 
                           class="text-gray-700 hover:text-gray-900">가게 정보</a>
                        <a href="${pageContext.request.contextPath}/logout" 
                           class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
            <div class="px-4 py-6 sm:px-0">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">메뉴 관리</h2>
                    <button class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                        새 메뉴 추가
                    </button>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="bg-white shadow overflow-hidden sm:rounded-md">
                    <div class="px-4 py-5 sm:px-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">메뉴 목록</h3>
                        <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 메뉴를 관리할 수 있습니다.</p>
                    </div>
                    <ul class="divide-y divide-gray-200">
                        <c:forEach var="item" items="${menuItems}">
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-16 w-16">
                                                <div class="h-16 w-16 rounded-lg bg-gray-300 flex items-center justify-center">
                                                    <span class="text-sm font-medium text-gray-700">🍽️</span>
                                                </div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="flex items-center">
                                                    <p class="text-lg font-medium text-gray-900">${item.name}</p>
                                                    <c:if test="${!item.isAvailable}">
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                            품절
                                                        </span>
                                                    </c:if>
                                                </div>
                                                <p class="text-sm text-gray-500">${item.description}</p>
                                                <div class="flex items-center mt-1">
                                                    <span class="text-sm font-medium text-gray-900">₩${item.price}</span>
                                                    <span class="ml-2 text-sm text-gray-500">• ${item.category}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <button class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                수정
                                            </button>
                                            <c:if test="${item.isAvailable}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="unavailable">
                                                    <input type="hidden" name="menuId" value="${item.id}">
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
                                                        품절 처리
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${!item.isAvailable}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="available">
                                                    <input type="hidden" name="menuId" value="${item.id}">
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                        판매 재개
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="menuId" value="${item.id}">
                                                <button type="submit" 
                                                        class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                                        onclick="return confirm('정말로 이 메뉴를 삭제하시겠습니까?')">
                                                    삭제
                                                </button>
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
    </div>

</body>
</html>
