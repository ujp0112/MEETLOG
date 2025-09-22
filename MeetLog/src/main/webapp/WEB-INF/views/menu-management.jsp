<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
<<<<<<< HEAD
    <title>메뉴 관리 - ${restaurant.name} - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .card { background-color: white; border-radius: 0.75rem; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); padding: 1.5rem; }
        .btn-primary { background-color: #0284c7; color: white; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 600; transition: background-color 0.2s; }
        .btn-primary:hover { background-color: #0369a1; }
        .btn-secondary { background-color: #6b7280; color: white; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 600; transition: background-color 0.2s; }
        .btn-secondary:hover { background-color: #4b5563; }
        .btn-danger { background-color: #dc2626; color: white; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 600; transition: background-color 0.2s; }
        .btn-danger:hover { background-color: #b91c1c; }
    </style>
</head>
<body class="bg-gray-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <div class="max-w-6xl mx-auto py-12 px-4">
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">메뉴 관리</h1>
                <p class="text-gray-600 mt-2">${restaurant.name}</p>
            </div>
            <div class="flex space-x-3">
                <a href="${pageContext.request.contextPath}/restaurant/my" class="btn-secondary">← 내 음식점 목록</a>
                <a href="${pageContext.request.contextPath}/business/menus/add/${restaurant.id}" class="btn-primary">➕ 새 메뉴 추가</a>
            </div>
        </div>

        <c:if test="${empty menus}">
            <div class="bg-white p-8 rounded-lg shadow-md text-center text-gray-600">
                <div class="text-6xl mb-4">🍽️</div>
                <p class="text-xl mb-4">아직 등록된 메뉴가 없습니다.</p>
                <a href="${pageContext.request.contextPath}/business/menus/add/${restaurant.id}" class="btn-primary">첫 메뉴를 추가해보세요!</a>
            </div>
        </c:if>

        <c:if test="${not empty menus}">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="menu" items="${menus}">
                    <div class="card">
                        <div class="flex items-start space-x-4">
                            <c:choose>
                                <c:when test="${not empty menu.image}">
                                    <img src="${pageContext.request.contextPath}/${menu.image}" alt="${menu.name} 이미지" class="w-20 h-20 object-cover rounded-lg">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-20 h-20 bg-gray-200 rounded-lg flex items-center justify-center text-gray-500">
                                        No Image
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="flex-grow">
                                <div class="flex items-center justify-between mb-2">
                                    <h3 class="text-lg font-semibold text-gray-800">${menu.name}</h3>
                                    <c:if test="${menu.popular}">
                                        <span class="text-xs bg-red-500 text-white px-2 py-1 rounded-full">인기</span>
                                    </c:if>
                                </div>
                                
                                <p class="text-gray-600 text-sm mb-2">${menu.price}</p>
                                
                                <c:if test="${not empty menu.description}">
                                    <p class="text-gray-500 text-sm mb-3 line-clamp-2">${menu.description}</p>
                                </c:if>
                                
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/business/menus/edit/${restaurant.id}/${menu.id}" 
                                       class="text-sm bg-blue-100 text-blue-700 px-3 py-1 rounded hover:bg-blue-200 transition">
                                        수정
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/business/menus/delete/${restaurant.id}/${menu.id}" 
                                          class="inline" onsubmit="return confirm('정말로 이 메뉴를 삭제하시겠습니까?')">
                                        <button type="submit" class="text-sm bg-red-100 text-red-700 px-3 py-1 rounded hover:bg-red-200 transition">
                                            삭제
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
=======
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
>>>>>>> origin/my-feature
