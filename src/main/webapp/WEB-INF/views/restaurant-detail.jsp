<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - <c:out value="${restaurant.name}" default="맛집 상세" /></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=&libraries=services"></script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .page-content { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
    <style type="text/tailwindcss">
        .time-slot { @apply p-2 rounded-md transition-colors; }
        .time-slot-available { @apply cursor-pointer text-sky-500 font-bold hover:bg-sky-50; }
        .time-slot-closing { @apply cursor-pointer text-amber-500 font-bold hover:bg-amber-50; }
        .time-slot-full { @apply cursor-not-allowed text-slate-300; }
    </style>
</head>
<body class="bg-slate-100">

    <div id="app" class="min-h-screen flex flex-col">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                <c:choose>
                    <c:when test="${not empty restaurant}">
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:items-start">
                            <div class="lg:col-span-2 space-y-8">

                                <!-- 실제 데이터가 들어있는 섹션들 -->
                                <section id="shop-photos" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h2 class="text-xl font-bold mb-4">${restaurant.name}</h2>
                                    <div class="grid grid-cols-3 gap-2">
                                        <img src="${not empty restaurant.image ? restaurant.image : 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832'}" 
                                             alt="${restaurant.name}" class="w-full h-24 object-cover rounded-lg">
                                        <img src="https://placehold.co/300x200/4ecdc4/ffffff?text=맛집" alt="${restaurant.name}" class="w-full h-24 object-cover rounded-lg">
                                        <img src="https://placehold.co/300x200/45b7d1/ffffff?text=DELICIOUS" alt="${restaurant.name}" class="w-full h-24 object-cover rounded-lg">
                                    </div>
                                    <button class="mt-4 bg-sky-500 text-white px-4 py-2 rounded-lg">전체보기 (3)</button>
                                </section>

                                <section id="shop-header" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <div class="flex justify-between items-start mb-4">
                                        <div>
                                            <h1 class="text-3xl font-bold mb-2">${restaurant.name}</h1>
                                            <p class="text-slate-600">${restaurant.location} • ${restaurant.category}</p>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-2xl font-bold text-sky-600">${restaurant.rating}점</div>
                                            <div class="text-sm text-slate-500">${restaurant.reviewCount}개 리뷰</div>
                                        </div>
                                    </div>
                                    <div class="flex space-x-4">
                                        <button class="bg-red-500 text-white px-4 py-2 rounded-lg">❤️ 찜하기</button>
                                        <button class="bg-slate-500 text-white px-4 py-2 rounded-lg">📤 공유</button>
                                    </div>
                                </section>
                                
                                <section id="coupon-section" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="text-lg font-bold mb-4">🎫 MEET LOG 단독 쿠폰</h3>
                                    <div class="bg-yellow-50 p-4 rounded-lg border border-yellow-200">
                                        <p class="font-bold text-yellow-800">모든 메뉴 10% 할인</p>
                                        <button class="mt-2 bg-yellow-500 text-white px-4 py-2 rounded-lg">쿠폰받기</button>
                                    </div>
                                </section>
                                
                                <section id="shop-info" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="text-lg font-bold mb-4">📍 가게 정보</h3>
                                    <div class="space-y-3">
                                        <div>
                                            <span class="font-semibold">주소:</span>
                                            <span>${restaurant.address}</span>
                                        </div>
                                        <div>
                                            <span class="font-semibold">전화번호:</span>
                                            <span>${restaurant.phone}</span>
                                        </div>
                                        <div>
                                            <span class="font-semibold">영업시간:</span>
                                            <span>매일 12:00 - 22:00</span>
                                        </div>
                                        <div>
                                            <span class="font-semibold">메뉴:</span>
                                            <div class="mt-2 space-y-1">
                                                <c:choose>
                                                    <c:when test="${not empty menus}">
                                                        <c:forEach var="menu" items="${menus}" begin="0" end="2">
                                                            <div>${menu.name} <fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="원" /></div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div>메뉴 정보가 없습니다.</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </section>

                                <section id="visitor-ratings" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="text-lg font-bold mb-4">⭐ 방문자 평가</h3>
                                    <div class="flex items-center mb-4">
                                        <div class="text-3xl font-bold mr-4">${restaurant.rating}</div>
                                        <div class="flex space-x-1">
                                            <c:forEach begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${restaurant.rating >= 4.5}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 3.5}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 2.5}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 1.5}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-slate-300">☆</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="space-y-2">
                                        <div class="flex items-center">
                                            <span class="w-12 text-sm">맛</span>
                                            <div class="flex-1 bg-slate-200 rounded-full h-2 mx-2">
                                                <div class="bg-yellow-400 h-2 rounded-full" style="width: ${restaurant.rating * 20}%"></div>
                                            </div>
                                            <span class="text-sm">${restaurant.rating}</span>
                                        </div>
                                        <div class="flex items-center">
                                            <span class="w-12 text-sm">가격</span>
                                            <div class="flex-1 bg-slate-200 rounded-full h-2 mx-2">
                                                <div class="bg-yellow-400 h-2 rounded-full" style="width: ${restaurant.rating * 20}%"></div>
                                            </div>
                                            <span class="text-sm">${restaurant.rating}</span>
                                        </div>
                                        <div class="flex items-center">
                                            <span class="w-12 text-sm">응대</span>
                                            <div class="flex-1 bg-slate-200 rounded-full h-2 mx-2">
                                                <div class="bg-yellow-400 h-2 rounded-full" style="width: ${restaurant.rating * 20}%"></div>
                                            </div>
                                            <span class="text-sm">${restaurant.rating}</span>
                                        </div>
                                    </div>
                                </section>
                                
                                <section id="shop-reviews" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <div class="flex justify-between items-center mb-4">
                                        <h3 class="text-lg font-bold">💬 방문자 리뷰 (${restaurant.reviewCount})</h3>
                                        <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" 
                                           class="bg-sky-500 text-white px-4 py-2 rounded-lg">리뷰 작성</a>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <div class="space-y-4">
                                                <c:forEach var="review" items="${reviews}">
                                                    <div class="border-b pb-4">
                                                        <div class="flex items-center mb-2">
                                                            <span class="font-semibold">${review.author}</span>
                                                            <div class="flex space-x-1 ml-2">
                                                                <c:forEach begin="1" end="${review.rating}">
                                                                    <span class="text-yellow-400">★</span>
                                                                </c:forEach>
                                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                                    <span class="text-slate-300">☆</span>
                                                                </c:forEach>
                                                            </div>
                                                            <span class="text-sm text-slate-500 ml-2">${review.createdAt}</span>
                                                        </div>
                                                        <p>${review.content}</p>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-slate-500 py-8">아직 리뷰가 없습니다.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </section>


                            </div>

                            <!-- 사이드바 -->
                            <div class="lg:col-span-1 space-y-6">
                                <section id="location-section" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="text-lg font-bold mb-4">📍 위치</h3>
                                    <div class="w-full h-48 bg-slate-200 rounded-lg flex items-center justify-center">
                                        <span class="text-slate-500">지도 영역</span>
                                    </div>
                                </section>

                                <section id="reservation-section" class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="text-lg font-bold mb-4">📅 온라인 예약</h3>
                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-sm font-semibold mb-2">날짜</label>
                                            <input type="date" value="2023-09-15" class="w-full p-2 border rounded-lg">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold mb-2">인원</label>
                                            <select class="w-full p-2 border rounded-lg">
                                                <option>2명</option>
                                                <option>3명</option>
                                                <option>4명</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold mb-2">예약가능시간</label>
                                            <div class="grid grid-cols-2 gap-2">
                                                <button class="time-slot time-slot-available">17:00</button>
                                                <button class="time-slot time-slot-available">18:00</button>
                                                <button class="time-slot time-slot-closing">19:00</button>
                                                <button class="time-slot time-slot-full">20:00</button>
                                            </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}" 
                                           class="w-full bg-sky-500 text-white py-3 rounded-lg font-bold block text-center">예약하기</a>
                                    </div>
                                </section>
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