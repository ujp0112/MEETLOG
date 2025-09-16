<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 검색 결과</title>
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
                <div class="mb-6">
                    <h2 class="text-2xl md:text-3xl font-bold mb-4">검색 결과</h2>
                    <div class="text-slate-600">
                        <%-- Conditionally display search criteria using JSTL --%>
                        <c:if test="${not empty searchLocation}">
                            <span class="bg-sky-100 text-sky-800 px-2 py-1 rounded text-sm mr-2">지역: ${searchLocation}</span>
                        </c:if>
                        <c:if test="${not empty searchCategory}">
                            <span class="bg-sky-100 text-sky-800 px-2 py-1 rounded text-sm mr-2">카테고리: ${searchCategory}</span>
                        </c:if>
                        <c:if test="${not empty searchPriceRange}">
                            <span class="bg-sky-100 text-sky-800 px-2 py-1 rounded text-sm mr-2">가격대: ${searchPriceRange}</span>
                        </c:if>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:choose>
                        <c:when test="${not empty searchResults}">
                            <c:forEach var="restaurant" items="${searchResults}">
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
                                <div class="text-6xl mb-4">🔍</div>
                                <h3 class="text-xl font-bold text-slate-800 mb-2">검색 결과가 없습니다</h3>
                                <p class="text-slate-600 mb-6">다른 검색 조건으로 다시 시도해보세요.</p>
                                <a href="${pageContext.request.contextPath}/main" 
                                   class="inline-block bg-sky-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-sky-700">
                                    다시 검색하기
                                </a>
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