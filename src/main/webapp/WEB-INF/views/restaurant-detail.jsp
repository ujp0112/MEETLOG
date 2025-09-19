<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${restaurant.name} - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .card { background-color: white; border-radius: 0.75rem; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); padding: 1.5rem; }
    </style>
</head>
<body class="bg-gray-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <div class="max-w-6xl mx-auto py-12 px-4">
        <!-- 음식점 정보 -->
        <div class="card mb-8">
            <div class="flex flex-col md:flex-row gap-6">
                <!-- 이미지 -->
                <div class="md:w-1/3">
                    <c:choose>
                        <c:when test="${not empty restaurant.image}">
                            <img src="${pageContext.request.contextPath}/${restaurant.image}" 
                                 alt="${restaurant.name} 이미지" 
                                 class="w-full h-64 object-cover rounded-lg">
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-64 bg-gray-200 rounded-lg flex items-center justify-center text-gray-500">
                                No Image
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- 정보 -->
                <div class="md:w-2/3">
                    <h1 class="text-3xl font-bold text-gray-900 mb-4">${restaurant.name}</h1>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                        <div>
                            <h3 class="text-sm font-semibold text-gray-500 mb-1">카테고리</h3>
                            <p class="text-gray-900">${restaurant.category}</p>
                        </div>
                        <div>
                            <h3 class="text-sm font-semibold text-gray-500 mb-1">위치</h3>
                            <p class="text-gray-900">${restaurant.location}</p>
                        </div>
                        <div>
                            <h3 class="text-sm font-semibold text-gray-500 mb-1">주소</h3>
                            <p class="text-gray-900">${restaurant.address}</p>
                        </div>
                        <div>
                            <h3 class="text-sm font-semibold text-gray-500 mb-1">전화번호</h3>
                            <p class="text-gray-900">${restaurant.phone}</p>
                        </div>
                    </div>
                    
                    <c:if test="${not empty restaurant.description}">
                        <div class="mb-6">
                            <h3 class="text-sm font-semibold text-gray-500 mb-2">소개</h3>
                            <p class="text-gray-700">${restaurant.description}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty restaurant.hours}">
                        <div class="mb-6">
                            <h3 class="text-sm font-semibold text-gray-500 mb-2">운영시간</h3>
                            <p class="text-gray-700">${restaurant.hours}</p>
                        </div>
                    </c:if>
                    
                    <!-- 소유자용 관리 버튼 -->
                    <c:if test="${isOwner}">
                        <div class="flex space-x-3">
                            <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus" 
                               class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition">
                                메뉴 관리
                            </a>
                            <a href="${pageContext.request.contextPath}/business/restaurants" 
                               class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition">
                                내 음식점 목록
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- 메뉴 목록 -->
        <div class="card">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">메뉴</h2>
            
            <c:if test="${empty menus}">
                <div class="text-center py-12 text-gray-500">
                    <div class="text-6xl mb-4">🍽️</div>
                    <p class="text-xl">아직 등록된 메뉴가 없습니다.</p>
                </div>
            </c:if>
            
            <c:if test="${not empty menus}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="menu" items="${menus}">
                        <div class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition">
                            <c:if test="${not empty menu.image}">
                                <img src="${pageContext.request.contextPath}/${menu.image}" 
                                     alt="${menu.name} 이미지" 
                                     class="w-full h-32 object-cover rounded-lg mb-3">
                            </c:if>
                            
                            <div class="flex items-center justify-between mb-2">
                                <h3 class="text-lg font-semibold text-gray-900">${menu.name}</h3>
                                <c:if test="${menu.popular}">
                                    <span class="text-xs bg-red-500 text-white px-2 py-1 rounded-full">인기</span>
                                </c:if>
                            </div>
                            
                            <p class="text-lg font-bold text-blue-600 mb-2">${menu.price}</p>
                            
                            <c:if test="${not empty menu.description}">
                                <p class="text-gray-600 text-sm">${menu.description}</p>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>