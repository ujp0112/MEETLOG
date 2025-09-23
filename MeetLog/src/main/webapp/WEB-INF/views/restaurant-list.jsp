<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
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
        <%-- 공통 헤더 포함 --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8">
                    <h2 class="text-2xl md:text-3xl font-bold mb-6">맛집 목록</h2>
                    <div class="bg-white p-6 rounded-xl shadow-md mb-6">
                        <form action="${pageContext.request.contextPath}/restaurant/list" method="get" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 items-end">
                            <div class="col-span-2 lg:col-span-2">
                                <label class="block text-sm font-medium mb-2">키워드</label>
                                <input type="text" name="keyword" value="${selectedKeyword}" class="w-full rounded-md border-slate-300" placeholder="맛집 이름, 지역, 메뉴 등">
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-2">음식 종류</label>
                                <select name="category" class="w-full rounded-md border-slate-300">
                                    <option value="">전체</option>
                                    <option value="한식" ${selectedCategory == '한식' ? 'selected' : ''}>한식</option>
                                    <option value="양식" ${selectedCategory == '양식' ? 'selected' : ''}>양식</option>
                                    <option value="일식" ${selectedCategory == '일식' ? 'selected' : ''}>일식</option>
                                    <option value="중식" ${selectedCategory == '중식' ? 'selected' : ''}>중식</option>
                                    <option value="카페" ${selectedCategory == '카페' ? 'selected' : ''}>카페</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-2">가격대 (1인)</label>
                                <select name="price" class="w-full rounded-md border-slate-300">
                                    <option value="">전체</option>
                                    <option value="1" ${selectedPrice == '1' ? 'selected' : ''}>~1만원</option>
                                    <option value="2" ${selectedPrice == '2' ? 'selected' : ''}>1~2만원</option>
                                    <option value="3" ${selectedPrice == '3' ? 'selected' : ''}>2~4만원</option>
                                    <option value="4" ${selectedPrice == '4' ? 'selected' : ''}>4만원~</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-2">주차 여부</label>
                                <select name="parking" class="w-full rounded-md border-slate-300">
                                    <option value="">전체</option>
                                    <option value="true" ${selectedParking == 'true' ? 'selected' : ''}>가능</option>
                                    <option value="false" ${selectedParking == 'false' ? 'selected' : ''}>불가</option>
                                </select>
                            </div>
                            <div class="col-span-2 md:col-span-1">
                                <button type="submit" class="w-full bg-sky-600 text-white font-bold py-2 px-4 rounded-md hover:bg-sky-700">맛집 찾기</button>
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
                                        <mytag:image fileName="${restaurant.image}" altText="${restaurant.name}" cssClass="w-full h-48 object-cover" />
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
                <c:if test="${totalPages > 1}">
                    <div class="mt-12 flex justify-center">
                        <nav aria-label="Page navigation">
                            <ul class="inline-flex items-center -space-x-px">
                                <c:if test="${currentPage > 1}">
                                    <li>
                                        <c:url var="prevUrl" value="/restaurant/list">
                                            <c:param name="page" value="${currentPage - 1}" />
                                            <c:if test="${not empty selectedKeyword}">
                                                <c:param name="keyword" value="${selectedKeyword}" />
                                            </c:if>
                                            <c:if test="${not empty selectedCategory}">
                                                <c:param name="category" value="${selectedCategory}" />
                                            </c:if>
                                            <c:if test="${not empty selectedLocation}">
                                                <c:param name="location" value="${selectedLocation}" />
                                            </c:if>
                                            <c:if test="${not empty selectedPrice}">
                                                <c:param name="price" value="${selectedPrice}" />
                                            </c:if>
                                            <c:if test="${not empty selectedParking}">
                                                <c:param name="parking" value="${selectedParking}" />
                                            </c:if>
                                            <c:if test="${not empty selectedSortBy}">
                                                <c:param name="sortBy" value="${selectedSortBy}" />
                                            </c:if>
                                        </c:url>
                                        <a href="${prevUrl}" class="py-2 px-3 ml-0 leading-tight text-gray-500 bg-white rounded-l-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700">&laquo;</a>
                                    </li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li>
                                        <c:url var="pageUrl" value="/restaurant/list">
                                            <c:param name="page" value="${i}" />
                                            <c:if test="${not empty selectedKeyword}">
                                                <c:param name="keyword" value="${selectedKeyword}" />
                                            </c:if>
                                            <c:if test="${not empty selectedCategory}">
                                                <c:param name="category" value="${selectedCategory}" />
                                            </c:if>
                                            <c:if test="${not empty selectedLocation}">
                                                <c:param name="location" value="${selectedLocation}" />
                                            </c:if>
                                            <c:if test="${not empty selectedPrice}">
                                                <c:param name="price" value="${selectedPrice}" />
                                            </c:if>
                                            <c:if test="${not empty selectedParking}">
                                                <c:param name="parking" value="${selectedParking}" />
                                            </c:if>
                                            <c:if test="${not empty selectedSortBy}">
                                                <c:param name="sortBy" value="${selectedSortBy}" />
                                            </c:if>
                                        </c:url>
                                        <a href="${pageUrl}"
                                           class="py-2 px-3 leading-tight ${currentPage == i ? 'text-blue-600 bg-blue-50 border-blue-300' : 'text-gray-500 bg-white border-gray-300'} hover:bg-gray-100 hover:text-gray-700">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li>
                                        <c:url var="nextUrl" value="/restaurant/list">
                                            <c:param name="page" value="${currentPage + 1}" />
                                            <c:if test="${not empty selectedKeyword}">
                                                <c:param name="keyword" value="${selectedKeyword}" />
                                            </c:if>
                                            <c:if test="${not empty selectedCategory}">
                                                <c:param name="category" value="${selectedCategory}" />
                                            </c:if>
                                            <c:if test="${not empty selectedLocation}">
                                                <c:param name="location" value="${selectedLocation}" />
                                            </c:if>
                                            <c:if test="${not empty selectedPrice}">
                                                <c:param name="price" value="${selectedPrice}" />
                                            </c:if>
                                            <c:if test="${not empty selectedParking}">
                                                <c:param name="parking" value="${selectedParking}" />
                                            </c:if>
                                            <c:if test="${not empty selectedSortBy}">
                                                <c:param name="sortBy" value="${selectedSortBy}" />
                                            </c:if>
                                        </c:url>
                                        <a href="${nextUrl}" class="py-2 px-3 leading-tight text-gray-500 bg-white rounded-r-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700">&raquo;</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </main>
        <%-- 공통 푸터 포함 --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
