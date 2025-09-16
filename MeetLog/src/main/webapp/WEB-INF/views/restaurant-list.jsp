<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 맛집 목록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8">
                    <h2 class="text-2xl md:text-3xl font-bold mb-6">맛집 목록</h2>
                    
                    <div class="bg-white p-6 rounded-xl shadow-md mb-6">
                        <form "${pageContext.request.contextPath}.do/restaurant" method="get" class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div>
                                <label class="block text-sm font-medium mb-2">카테고리</label>
                                <select name="category" class="w-full rounded-md border-slate-300">
                                    <option value="">전체</option>
                                    <%-- Use EL to set the 'selected' attribute based on the request attribute --%>
                                    <option value="한식" ${selectedCategory == '한식' ? 'selected' : ''}>한식</option>
                                    <option value="양식" ${selectedCategory == '양식' ? 'selected' : ''}>양식</option>
                                    <option value="일식" ${selectedCategory == '일식' ? 'selected' : ''}>일식</option>
                                    <option value="중식" ${selectedCategory == '중식' ? 'selected' : ''}>중식</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-2">지역</label>
                                <input type="text" name="location" value="${selectedLocation}" 
                                       class="w-full rounded-md border-slate-300" placeholder="예: 강남역">
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-2">정렬</label>
                                <select name="sortBy" class="w-full rounded-md border-slate-300">
                                    <option value="rating" ${selectedSortBy == 'rating' ? 'selected' : ''}>평점순</option>
                                    <option value="likes" ${selectedSortBy == 'likes' ? 'selected' : ''}>좋아요순</option>
                                    <option value="recent" ${selectedSortBy == 'recent' ? 'selected' : ''}>최신순</option>
                                </select>
                            </div>
                            <div class="flex items-end">
                                <button type="submit" class="w-full bg-sky-600 text-white font-bold py-2 px-4 rounded-md hover:bg-sky-700">검색</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:choose>
                        <c:when test="${not empty restaurants}">
                            <c:forEach var="restaurant" items="${restaurants}">
                                <div class="bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 transition duration-300">
                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}">
                                        <img src="${not empty restaurant.image ? restaurant.image : 'https://placehold.co/600x400/94a3b8/ffffff?text=No+Image'}" 
                                             alt="${restaurant.name}" class="w-full h-48 object-cover">
                                        <div class="p-4">
                                            <h3 class="text-lg font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                            <p class="text-slate-600 text-sm mb-2">${restaurant.category} • ${restaurant.location}</p>
                                            <div class="flex items-center justify-between">
                                                <div class="text-sm font-bold text-sky-600">${restaurant.rating}점</div>
                                                <div class="text-sm text-slate-500">❤️ <fmt:formatNumber value="${restaurant.likes}" pattern="#,##0" /></div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-span-full text-center py-12">
                                <div class="text-6xl mb-4">🍽️</div>
                                <h3 class="text-xl font-bold text-slate-800 mb-2">맛집이 없습니다</h3>
                                <p class="text-slate-600 mb-6">다른 조건으로 검색해보세요.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        
        <%-- Replaced inline footer with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>