<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- The title is now dynamic based on the restaurant name --%>
    <title>MEET LOG - <c:out value="${restaurant.name}" default="맛집 상세" /></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

    <div id="app" class="min-h-screen flex flex-col">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <c:choose>
                    <c:when test="${not empty restaurant}">
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:items-start">
                            <div class="lg:col-span-2 space-y-8">
                                <section class="bg-white p-6 rounded-2xl shadow-lg">
                                    <img src="${not empty restaurant.image ? restaurant.image : 'https://placehold.co/800x400/94a3b8/ffffff?text=No+Image'}" 
                                         alt="${restaurant.name}" class="w-full h-64 object-cover rounded-lg">
                                </section>

                                <section class="bg-white p-6 rounded-2xl shadow-lg">
                                    <div class="flex items-start justify-between mb-4">
                                        <div>
                                            <h1 class="text-3xl font-bold text-slate-800">${restaurant.name}</h1>
                                            <p class="text-slate-600 mt-2">${restaurant.category} • ${restaurant.location}</p>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-2xl font-bold text-sky-600">${restaurant.rating}점</div>
                                            <div class="text-sm text-slate-500">${restaurant.reviewCount}개 리뷰</div>
                                        </div>
                                    </div>
                                    
                                    <div class="grid grid-cols-2 gap-4 mt-6">
                                        <div>
                                            <h3 class="font-semibold text-slate-700">주소</h3>
                                            <p class="text-slate-600">${restaurant.address}</p>
                                        </div>
                                        <div>
                                            <h3 class="font-semibold text-slate-700">전화번호</h3>
                                            <p class="text-slate-600">${not empty restaurant.phone ? restaurant.phone : "정보 없음"}</p>
                                        </div>
                                        <div>
                                            <h3 class="font-semibold text-slate-700">영업시간</h3>
                                            <p class="text-slate-600">${not empty restaurant.hours ? restaurant.hours : "정보 없음"}</p>
                                        </div>
                                        <div>
                                            <h3 class="font-semibold text-slate-700">주차</h3>
                                            <p class="text-slate-600">${restaurant.parking ? "가능" : "불가"}</p>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty restaurant.description}">
                                        <div class="mt-6">
                                            <h3 class="font-semibold text-slate-700 mb-2">설명</h3>
                                            <p class="text-slate-600">${restaurant.description}</p>
                                        </div>
                                    </c:if>
                                </section>

                                <c:if test="${not empty restaurant.menuList}">
                                    <section class="bg-white p-6 rounded-2xl shadow-lg">
                                        <h2 class="text-2xl font-bold mb-6">메뉴</h2>
                                        <div class="space-y-4">
                                            <c:forEach var="menu" items="${restaurant.menuList}">
                                                <div class="flex justify-between items-center p-4 border border-slate-200 rounded-lg">
                                                    <div>
                                                        <h3 class="font-semibold text-slate-800">${menu.name}</h3>
                                                        <c:if test="${not empty menu.description}">
                                                            <p class="text-sm text-slate-600">${menu.description}</p>
                                                        </c:if>
                                                    </div>
                                                    <div class="text-right">
                                                        <span class="font-bold text-sky-600">
                                                            <fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="₩" />
                                                        </span>
                                                        <c:if test="${menu.popular}">
                                                            <span class="ml-2 text-xs bg-red-100 text-red-600 px-2 py-1 rounded">인기</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>

                                <section class="bg-white p-6 rounded-2xl shadow-lg">
                                    <div class="flex justify-between items-center mb-6">
                                        <h2 class="text-2xl font-bold">리뷰</h2>
                                        <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" 
                                           class="bg-sky-600 text-white font-bold py-2 px-4 rounded-lg hover:bg-sky-700 text-sm">
                                            리뷰 작성
                                        </a>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="border-b border-slate-200 pb-4 mb-4 last:border-b-0">
                                                    <div class="flex items-center mb-3">
                                                        <img src="${not empty review.authorImage ? review.authorImage : 'https://placehold.co/100x100/94a3b8/ffffff?text=U'}" 
                                                             class="w-10 h-10 rounded-full mr-3">
                                                        <div>
                                                            <p class="font-semibold text-slate-800">${review.author}</p>
                                                            <p class="text-sm text-yellow-500">
                                                                <c:forEach begin="1" end="${review.rating}">★</c:forEach>
                                                                <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <p class="text-slate-700">${review.content}</p>
                                                    <div class="flex items-center justify-between mt-3">
                                                        <span class="text-sm text-slate-500"><fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd" /></span>
                                                        <button class="text-sky-600 hover:text-sky-700 text-sm">❤️ ${review.likes}</button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-slate-500 py-8">아직 리뷰가 없습니다.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </section>
                            </div>

                            <div class="space-y-6">
                                <div class="bg-white p-6 rounded-2xl shadow-lg">
                                    <a href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}" 
                                       class="w-full bg-sky-600 text-white font-bold py-3 px-4 rounded-lg hover:bg-sky-700 block text-center">
                                        예약하기
                                    </a>
                                </div>
                                <div class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="font-semibold text-slate-700 mb-4">위치</h3>
                                    <div class="bg-slate-100 h-48 rounded-lg flex items-center justify-center">
                                        <p class="text-slate-500">지도 영역</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <h2 class="text-2xl font-bold text-slate-800 mb-4">맛집 정보를 찾을 수 없습니다</h2>
                            <a href="${pageContext.request.contextPath}/main" class="text-sky-600 hover:text-sky-700">메인 페이지로 돌아가기</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <%-- Added missing footer include for consistency --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

</body>
</html>