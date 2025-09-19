<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
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
        <!-- 헤더 -->
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">메뉴 관리</h1>
                <p class="text-gray-600 mt-2">${restaurant.name}</p>
            </div>
            <div class="flex space-x-3">
                <a href="${pageContext.request.contextPath}/business/restaurants" class="btn-secondary">← 내 음식점 목록</a>
                <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus/add" class="btn-primary">➕ 새 메뉴 추가</a>
            </div>
        </div>

        <!-- 메뉴 목록 -->
        <c:if test="${empty menus}">
            <div class="bg-white p-8 rounded-lg shadow-md text-center text-gray-600">
                <div class="text-6xl mb-4">🍽️</div>
                <p class="text-xl mb-4">아직 등록된 메뉴가 없습니다.</p>
                <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus/add" class="btn-primary">첫 메뉴를 추가해보세요!</a>
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
                                    <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus/edit/${menu.id}" 
                                       class="text-sm bg-blue-100 text-blue-700 px-3 py-1 rounded hover:bg-blue-200 transition">
                                        수정
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus/delete/${menu.id}" 
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