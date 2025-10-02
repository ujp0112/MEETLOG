<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>통합 검색 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.92); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.35); box-shadow: 0 18px 45px rgba(15, 23, 42, 0.08); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .search-tab-active { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); color: #fff !important; box-shadow: 0 12px 30px rgba(37, 99, 235, 0.25); }
        .search-tab { transition: all 0.25s ease; cursor: pointer; }
        .search-tab:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(15, 23, 42, 0.12); border-color: rgba(37, 99, 235, 0.35); }
        .search-tab-active h3,
        .search-tab-active p { color: #fff !important; }
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-6px); box-shadow: 0 25px 55px rgba(15, 23, 42, 0.12); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8">
        <input type="hidden" id="activeSearchType" value="${empty searchType ? 'restaurants' : searchType}" />
        <div class="space-y-8">
            <!-- 헤더 및 검색 유형 토글 -->
            <div class="glass-card p-8 rounded-3xl">
                <h1 class="text-4xl font-bold gradient-text mb-2">통합 검색</h1>
                <p class="text-slate-600 mb-8">음식점 · 리뷰 · 예약 순위 · 칼럼을 하나의 화면에서 찾아보세요</p>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <button type="button" class="search-tab w-full text-left bg-white border border-slate-200 rounded-2xl p-6 flex items-center gap-4 ${searchType == 'restaurants' ? 'search-tab-active' : ''}" data-type="restaurants" id="tab-restaurants" onclick="setSearchType('restaurants')">
                        <div class="flex-shrink-0 w-12 h-12 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-2xl">🍽️</div>
                        <div>
                            <h3 class="text-lg font-semibold text-slate-800">음식점 검색</h3>
                            <p class="text-sm text-slate-500">키워드로 맛집을 찾아보세요.</p>
                        </div>
                    </button>
                    <button type="button" class="search-tab w-full text-left bg-white border border-slate-200 rounded-2xl p-6 flex items-center gap-4 ${searchType == 'reviews' ? 'search-tab-active' : ''}" data-type="reviews" id="tab-reviews" onclick="setSearchType('reviews')">
                        <div class="flex-shrink-0 w-12 h-12 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center text-2xl">📝</div>
                        <div>
                            <h3 class="text-lg font-semibold text-slate-800">리뷰 검색</h3>
                            <p class="text-sm text-slate-500">평점, 음식점, 작성자 기준으로 리뷰를 찾아보세요.</p>
                        </div>
                    </button>
                    <button type="button" class="search-tab w-full text-left bg-white border border-slate-200 rounded-2xl p-6 flex items-center gap-4 ${searchType == 'reservations' ? 'search-tab-active' : ''}" data-type="reservations" id="tab-reservations" onclick="setSearchType('reservations')">
                        <div class="flex-shrink-0 w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-2xl">📅</div>
                        <div>
                            <h3 class="text-lg font-semibold text-slate-800">예약 순위 검색</h3>
                            <p class="text-sm text-slate-500">기간별 예약 순위로 음식점을 확인하세요.</p>
                        </div>
                    </button>
                    <button type="button" class="search-tab w-full text-left bg-white border border-slate-200 rounded-2xl p-6 flex items-center gap-4 ${searchType == 'columns' ? 'search-tab-active' : ''}" data-type="columns" id="tab-columns" onclick="setSearchType('columns')">
                        <div class="flex-shrink-0 w-12 h-12 rounded-full bg-indigo-100 text-indigo-600 flex items-center justify-center text-2xl">📰</div>
                        <div>
                            <h3 class="text-lg font-semibold text-slate-800">칼럼 검색</h3>
                            <p class="text-sm text-slate-500">키워드로 칼럼을 찾아보세요.</p>
                        </div>
                    </button>
                </div>
            </div>

            <!-- 검색 폼 영역 -->
            <div class="glass-card p-8 rounded-3xl">
                <!-- 음식점 검색 -->
                <div class="search-section data-section-restaurants" data-type="restaurants" id="form-restaurants" style="display: ${searchType == 'restaurants' ? 'block' : 'none'};">
                    <form action="${pageContext.request.contextPath}/search" method="get" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <input type="hidden" name="type" value="restaurants" />
                        <input type="hidden" name="submitted" value="true" />
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-slate-700 mb-2">키워드</label>
                            <input type="text" name="keyword" value="${empty searchParams.keyword ? '' : searchParams.keyword}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="맛집 이름, 지역, 메뉴 등" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">음식 종류</label>
                            <select name="category" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="한식" ${searchParams.category == '한식' ? 'selected' : ''}>한식</option>
                                <option value="양식" ${searchParams.category == '양식' ? 'selected' : ''}>양식</option>
                                <option value="일식" ${searchParams.category == '일식' ? 'selected' : ''}>일식</option>
                                <option value="중식" ${searchParams.category == '중식' ? 'selected' : ''}>중식</option>
                                <option value="카페" ${searchParams.category == '카페' ? 'selected' : ''}>카페</option>
                                <option value="디저트" ${searchParams.category == '디저트' ? 'selected' : ''}>디저트</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">가격대 (1인)</label>
                            <select name="price" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="1" ${searchParams.price == '1' ? 'selected' : ''}>~1만원</option>
                                <option value="2" ${searchParams.price == '2' ? 'selected' : ''}>1~2만원</option>
                                <option value="3" ${searchParams.price == '3' ? 'selected' : ''}>2~4만원</option>
                                <option value="4" ${searchParams.price == '4' ? 'selected' : ''}>4만원 이상</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">주차 여부</label>
                            <select name="parking" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="true" ${searchParams.parking == 'true' ? 'selected' : ''}>가능</option>
                                <option value="false" ${searchParams.parking == 'false' ? 'selected' : ''}>불가</option>
                            </select>
                        </div>
                        <input type="hidden" name="sortBy" value="${empty searchParams.sortBy ? '' : searchParams.sortBy}" />
                        <div class="md:col-span-2 lg:col-span-3 flex flex-wrap gap-3">
                            <button type="submit" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold flex items-center gap-2">
                                🔍 <span>검색</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 리뷰 검색 -->
                <div class="search-section data-section-reviews" data-type="reviews" id="form-reviews" style="display: ${searchType == 'reviews' ? 'block' : 'none'};">
                    <form action="${pageContext.request.contextPath}/search" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <input type="hidden" name="type" value="reviews" />
                        <input type="hidden" name="submitted" value="true" />
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">키워드</label>
                            <input type="text" name="keyword" value="${empty searchParams.keyword ? '' : searchParams.keyword}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent" placeholder="리뷰 내용, 작성자, 음식점" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">최소 평점</label>
                            <select name="minRating" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="5" ${searchParams.minRating == '5' ? 'selected' : ''}>5점</option>
                                <option value="4" ${searchParams.minRating == '4' ? 'selected' : ''}>4점 이상</option>
                                <option value="3" ${searchParams.minRating == '3' ? 'selected' : ''}>3점 이상</option>
                                <option value="2" ${searchParams.minRating == '2' ? 'selected' : ''}>2점 이상</option>
                                <option value="1" ${searchParams.minRating == '1' ? 'selected' : ''}>1점 이상</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">최대 평점</label>
                            <select name="maxRating" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="5" ${searchParams.maxRating == '5' ? 'selected' : ''}>5점</option>
                                <option value="4" ${searchParams.maxRating == '4' ? 'selected' : ''}>4점 이하</option>
                                <option value="3" ${searchParams.maxRating == '3' ? 'selected' : ''}>3점 이하</option>
                                <option value="2" ${searchParams.maxRating == '2' ? 'selected' : ''}>2점 이하</option>
                                <option value="1" ${searchParams.maxRating == '1' ? 'selected' : ''}>1점 이하</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">시작 날짜</label>
                            <input type="date" name="startDate" value="${empty searchParams.startDate ? '' : searchParams.startDate}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">종료 날짜</label>
                            <input type="date" name="endDate" value="${empty searchParams.endDate ? '' : searchParams.endDate}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent" />
                        </div>
                        <div class="md:col-span-2 flex flex-wrap gap-3">
                            <button type="submit" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold flex items-center gap-2">
                                🔍 <span>검색</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 예약 검색 -->
                <div class="search-section data-section-reservations" data-type="reservations" id="form-reservations" style="display: ${searchType == 'reservations' ? 'block' : 'none'};">
                    <form action="${pageContext.request.contextPath}/search" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <input type="hidden" name="type" value="reservations" />
                        <input type="hidden" name="submitted" value="true" />
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">시작 날짜</label>
                            <input type="date" name="startDate" value="${empty searchParams.startDate ? '' : searchParams.startDate}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">종료 날짜</label>
                            <input type="date" name="endDate" value="${empty searchParams.endDate ? '' : searchParams.endDate}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent" />
                        </div>
                        <div class="md:col-span-2 flex flex-wrap gap-3">
                            <button type="submit" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold flex items-center gap-2">
                                🔍 <span>검색</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 칼럼 검색 -->
                <div class="search-section data-section-columns" data-type="columns" id="form-columns" style="display: ${searchType == 'columns' ? 'block' : 'none'};">
                    <form action="${pageContext.request.contextPath}/search" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <input type="hidden" name="type" value="columns" />
                        <input type="hidden" name="submitted" value="true" />
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">키워드</label>
                            <input type="text" name="keyword" value="${empty searchParams.keyword ? '' : searchParams.keyword}" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent" placeholder="칼럼 내용, 작성자, 칼럼 제목" />
                        </div>
                        <div class="md:col-span-2 flex flex-wrap gap-3">
                            <button type="submit" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold flex items-center gap-2">
                                🔍 <span>검색</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>


            <!-- 검색 결과 영역 -->
            <c:choose>
                <c:when test="${searchType == 'restaurants'}">
                    <div class="glass-card p-8 rounded-3xl">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-2xl font-bold gradient-text">음식점 검색 결과</h2>
                            <span class="text-slate-600">총 <strong>${totalResults != null ? totalResults : 0}</strong>건</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty restaurants}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach var="restaurant" items="${restaurants}">
                                        <div class="bg-white rounded-2xl overflow-hidden card-hover">
                                            <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}">
                                                <div class="h-48 w-full overflow-hidden">
                                                    <mytag:image fileName="${restaurant.image}" altText="${restaurant.name}" cssClass="w-full h-full object-cover" />
                                                </div>
                                            </a>
                                            <div class="p-6 space-y-3">
                                                <div class="flex items-center justify-between">
                                                    <span class="px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-semibold">${restaurant.category}</span>
                                                    <span class="text-sm text-slate-500">${restaurant.location}</span>
                                                </div>
                                                <h3 class="text-xl font-bold text-slate-800">${restaurant.name}</h3>
                                                <div class="flex items-center space-x-2 text-sm">
                                                    <div class="flex space-x-1 text-yellow-400">
                                                        <c:forEach begin="1" end="${restaurant.rating}">
                                                            <span>★</span>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="font-semibold text-slate-700">${restaurant.rating}</span>
                                                    <span class="text-slate-500">(${restaurant.reviewCount}개 리뷰)</span>
                                                </div>
                                                <div class="flex items-center justify-between">
                                                    <span class="text-slate-500 text-sm">주차 ${restaurant.parking ? '가능' : '불가'}</span>
                                                    <span class="text-slate-500 text-sm">찜 ${restaurant.likes}</span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}" class="btn-primary text-white w-full text-center block px-4 py-2 rounded-lg font-semibold">상세 보기</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <c:if test="${totalPages > 1}">
                                    <div class="mt-8 flex justify-center">
                                        <nav class="inline-flex rounded-lg shadow-sm" aria-label="Pagination">
                                            <c:if test="${currentPage > 1}">
                                            <c:url var="prevUrl" value="/search">
                                                <c:param name="page" value="${currentPage - 1}" />
                                                <c:param name="type" value="restaurants" />
                                                <c:param name="submitted" value="true" />
                                                <c:if test="${not empty searchParams.keyword}">
                                                    <c:param name="keyword" value="${searchParams.keyword}" />
                                                </c:if>
                                                    <c:if test="${not empty searchParams.category}">
                                                        <c:param name="category" value="${searchParams.category}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.location}">
                                                        <c:param name="location" value="${searchParams.location}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.price}">
                                                        <c:param name="price" value="${searchParams.price}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.parking}">
                                                        <c:param name="parking" value="${searchParams.parking}" />
                                                    </c:if>
                                                </c:url>
                                                <a href="${prevUrl}" class="px-3 py-2 border border-slate-300 bg-white text-slate-600 rounded-l-lg hover:bg-slate-100">이전</a>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                <c:url var="pageUrl" value="/search">
                                                    <c:param name="page" value="${pageNum}" />
                                                    <c:param name="type" value="restaurants" />
                                                    <c:param name="submitted" value="true" />
                                                    <c:if test="${not empty searchParams.keyword}">
                                                        <c:param name="keyword" value="${searchParams.keyword}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.category}">
                                                        <c:param name="category" value="${searchParams.category}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.location}">
                                                        <c:param name="location" value="${searchParams.location}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.price}">
                                                        <c:param name="price" value="${searchParams.price}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.parking}">
                                                        <c:param name="parking" value="${searchParams.parking}" />
                                                    </c:if>
                                                </c:url>
                                                <a href="${pageUrl}" class="px-3 py-2 border ${pageNum == currentPage ? 'bg-blue-50 border-blue-400 text-blue-600 font-semibold' : 'bg-white border-slate-300 text-slate-600'} hover:bg-slate-100">${pageNum}</a>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <c:url var="nextUrl" value="/search">
                                                    <c:param name="page" value="${currentPage + 1}" />
                                                    <c:param name="type" value="restaurants" />
                                                    <c:param name="submitted" value="true" />
                                                    <c:if test="${not empty searchParams.keyword}">
                                                        <c:param name="keyword" value="${searchParams.keyword}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.category}">
                                                        <c:param name="category" value="${searchParams.category}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.location}">
                                                        <c:param name="location" value="${searchParams.location}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.price}">
                                                        <c:param name="price" value="${searchParams.price}" />
                                                    </c:if>
                                                    <c:if test="${not empty searchParams.parking}">
                                                        <c:param name="parking" value="${searchParams.parking}" />
                                                    </c:if>
                                                </c:url>
                                                <a href="${nextUrl}" class="px-3 py-2 border border-slate-300 bg-white text-slate-600 rounded-r-lg hover:bg-slate-100">다음</a>
                                            </c:if>
                                        </nav>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="text-center py-20">
                                            <div class="text-5xl mb-4">🔍</div>
                                            <p class="text-lg text-slate-600">조건에 맞는 음식점이 없습니다. 필터를 조정해보세요.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-16 text-slate-500">
                                            검색 조건을 입력한 뒤 검색 버튼을 눌러보세요.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:when test="${searchType == 'reviews'}">
                    <div class="glass-card p-8 rounded-3xl">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-2xl font-bold gradient-text">리뷰 검색 결과</h2>
                            <span class="text-slate-600">총 <strong>${searchResults != null ? searchResults.size() : 0}</strong>건</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <div class="space-y-6">
                                    <c:forEach var="review" items="${searchResults}">
                                        <div class="bg-white rounded-2xl p-6 card-hover">
                                            <div class="flex justify-between items-start mb-4">
                                                <div class="flex items-center space-x-4">
                                                    <div class="w-12 h-12 bg-gradient-to-br from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                                        ${fn:length(review.author) > 0 ? fn:substring(review.author, 0, 1) : 'R'}
                                                    </div>
                                                    <div>
                                                        <h3 class="font-bold text-slate-800">${review.author}</h3>
                                                        <p class="text-slate-500 text-sm">${review.restaurantName}</p>
                                                    </div>
                                                </div>
                                                <div class="text-right">
                                                    <div class="flex items-center justify-end space-x-1 text-yellow-400 mb-1">
                                                        <c:forEach begin="1" end="${review.rating}">
                                                            <span>★</span>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="text-slate-600 text-sm">${review.createdAt}</span>
                                                </div>
                                            </div>
                                            <p class="text-slate-700 leading-relaxed">
                                                <c:choose>
                                                    <c:when test="${fn:length(review.content) > 180}">
                                                        ${fn:substring(review.content, 0, 180)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${review.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="text-center py-20">
                                            <div class="text-5xl mb-4">📝</div>
                                            <p class="text-lg text-slate-600">조건에 맞는 리뷰가 없습니다.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-16 text-slate-500">
                                            검색 조건을 입력한 뒤 검색 버튼을 눌러보세요.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:when test="${searchType == 'reservations'}">
                    <div class="glass-card p-8 rounded-3xl">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-2xl font-bold gradient-text">예약 검색 결과</h2>
                            <span class="text-slate-600">총 <strong>${searchResults != null ? searchResults.size() : 0}</strong>건</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <div class="space-y-4">
                                    <c:forEach var="reservation" items="${searchResults}">
                                        <div class="bg-white rounded-2xl p-6 card-hover flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                                            <div>
                                                <h3 class="text-lg font-semibold text-slate-800">${reservation.restaurantName}</h3>
                                                <p class="text-slate-600 text-sm">예약자: ${reservation.customerName} · 인원: ${reservation.partySize}명</p>
                                            </div>
                                            <div class="flex items-center gap-4">
                                                <div class="text-right">
                                                    <p class="text-slate-500 text-sm">${reservation.reservationTime}</p>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold ${reservation.status == 'CONFIRMED' ? 'bg-green-100 text-green-700' : reservation.status == 'PENDING' ? 'bg-yellow-100 text-yellow-700' : reservation.status == 'CANCELLED' ? 'bg-red-100 text-red-700' : 'bg-slate-100 text-slate-600'}">
                                                        ${reservation.status}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="text-center py-20">
                                            <div class="text-5xl mb-4">📅</div>
                                            <p class="text-lg text-slate-600">조건에 맞는 예약 내역이 없습니다.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-16 text-slate-500">
                                            검색 조건을 입력한 뒤 검색 버튼을 눌러보세요.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:when test="${searchType == 'columns'}">
                    <div class="glass-card p-8 rounded-3xl">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-2xl font-bold gradient-text">칼럼 검색 결과</h2>
                            <span class="text-slate-600">총 <strong>${searchResults != null ? searchResults.size() : 0}</strong>건</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <div class="space-y-6">
                                    <c:forEach var="column" items="${searchResults}">
                                        <div class="bg-white rounded-2xl p-6 card-hover">
                                            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-4">
                                                <div>
                                                    <h3 class="text-xl font-bold text-slate-800">${column.title}</h3>
                                                    <p class="text-slate-500 text-sm">작성자: ${column.author}</p>
                                                </div>
                                                <p class="text-slate-500 text-sm">${column.createdAt}</p>
                                            </div>
                                            <p class="text-slate-700 leading-relaxed mb-4">
                                                <c:choose>
                                                    <c:when test="${column.content != null && fn:length(column.content) > 200}">
                                                        ${fn:substring(column.content, 0, 200)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${column.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="flex items-center justify-between text-sm text-slate-500">
                                                <span>조회수 ${column.views}</span>
                                                <span>좋아요 ${column.likes}</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}" class="btn-primary mt-4 inline-block text-white px-4 py-2 rounded-lg font-semibold">칼럼 보기</a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="text-center py-20">
                                            <div class="text-5xl mb-4">📰</div>
                                            <p class="text-lg text-slate-600">조건에 맞는 칼럼이 없습니다.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-16 text-slate-500">
                                            검색 조건을 입력한 뒤 검색 버튼을 눌러보세요.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="glass-card p-8 rounded-3xl text-center">
                        <p class="text-slate-600">검색 유형을 선택하고 조건을 입력해 주세요.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        function setSearchType(type) {
            const hiddenTypeField = document.getElementById('activeSearchType');
            if (hiddenTypeField) {
                hiddenTypeField.value = type;
            }

            document.querySelectorAll('.search-tab').forEach(btn => {
                btn.classList.toggle('search-tab-active', btn.dataset.type === type);
            });

            document.querySelectorAll('.search-section').forEach(section => {
                const isActive = section.dataset.type === type;
                section.style.display = isActive ? 'block' : 'none';
                const typeInput = section.querySelector('input[name="type"]');
                if (typeInput) {
                    typeInput.value = section.dataset.type;
                }
            });
        }

        function resetForm() {
            const activeType = document.getElementById('activeSearchType').value || 'restaurants';
            const activeSection = document.querySelector(`.search-section[data-type="${activeType}"]`);
            if (!activeSection) return;
            const form = activeSection.querySelector('form');
            if (form) {
                form.reset();
                const typeInput = form.querySelector('input[name="type"]');
                if (typeInput) {
                    typeInput.value = activeType;
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            const initialType = document.getElementById('activeSearchType').value || 'restaurants';
            setSearchType(initialType);
        });
    </script>
</body>
</html>
