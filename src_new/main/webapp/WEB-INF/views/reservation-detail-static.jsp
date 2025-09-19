<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - ${restaurant.name}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APP_KEY&libraries=services"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-content { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        
        .time-slot { @apply p-2 rounded-md transition-colors text-center; }
        .time-slot-available { @apply cursor-pointer text-sky-600 font-bold bg-sky-50 hover:bg-sky-100; }
        .time-slot-closing { @apply cursor-pointer text-amber-600 font-bold bg-amber-50 hover:bg-amber-100; }
        .time-slot-full { @apply cursor-not-allowed text-slate-400 bg-slate-100; }
    </style>
</head>
<body class="bg-slate-100">

    <div id="app" class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:items-start">
                    <div class="lg:col-span-2 space-y-8">

                        <section id="shop-photos" class="bg-white p-6 rounded-2xl shadow-lg">
                            <h2 class="text-xl font-bold mb-4">${restaurant.name} 사진</h2>
                            <div class="grid grid-cols-3 gap-2">
                                <c:forEach var="photoUrl" items="${restaurant.photos}" begin="0" end="2">
                                    <img src="${photoUrl}" alt="${restaurant.name} 사진" class="w-full h-24 object-cover rounded-lg">
                                </c:forEach>
                            </div>
                            <c:if test="${fn:length(restaurant.photos) > 3}">
                                <button class="mt-4 bg-sky-500 text-white px-4 py-2 rounded-lg">전체보기 (${fn:length(restaurant.photos)})</button>
                            </c:if>
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
                        
                        <c:if test="${not empty restaurant.coupon}">
                            <section id="coupon-section" class="bg-white p-6 rounded-2xl shadow-lg">
                                <h3 class="text-lg font-bold mb-4">🎫 MEET LOG 단독 쿠폰</h3>
                                <div class="bg-yellow-50 p-4 rounded-lg border border-yellow-200">
                                    <p class="font-bold text-yellow-800">${restaurant.coupon.description}</p>
                                    <button class="mt-2 bg-yellow-500 text-white px-4 py-2 rounded-lg">쿠폰받기</button>
                                </div>
                            </section>
                        </c:if>
                        
                        <section id="shop-info" class="bg-white p-6 rounded-2xl shadow-lg">
                            <h3 class="text-lg font-bold mb-4">📍 가게 정보</h3>
                            <div class="space-y-3">
                                <div><span class="font-semibold">주소:</span> <span>${restaurant.address}</span></div>
                                <div><span class="font-semibold">전화번호:</span> <span>${restaurant.phone}</span></div>
                                <div><span class="font-semibold">영업시간:</span> <span>${restaurant.hours}</span></div>
                                <div>
                                    <span class="font-semibold">메뉴:</span>
                                    <div class="mt-2 space-y-1">
                                        <c:forEach var="menu" items="${restaurant.menuItems}">
                                            <div>${menu.name} - <fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="₩"/></div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section id="visitor-ratings" class="bg-white p-6 rounded-2xl shadow-lg">
                            <h3 class="text-lg font-bold mb-4">⭐ 방문자 평가</h3>
                            <div class="flex items-center mb-4">
                                <div class="text-3xl font-bold mr-4">${restaurant.rating}</div>
                                <div class="flex items-center">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="text-xl ${i <= restaurant.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="space-y-2">
                                <div class="flex items-center"><span class="w-12 text-sm">맛</span><div class="flex-1 bg-slate-200 rounded-full h-2 mx-2"><div class="bg-yellow-400 h-2 rounded-full" style="width: ${restaurant.tasteRating * 20}%"></div></div><span class="text-sm">${restaurant.tasteRating}</span></div>
                                <div class="flex items-center"><span class="w-12 text-sm">가격</span><div class="flex-1 bg-slate-200 rounded-full h-2 mx-2"><div class="bg-yellow-400 h-2 rounded-full" style="width: ${restaurant.priceRating * 20}%"></div></div><span class="text-sm">${restaurant.priceRating}</span></div>
                                <div class="flex items-center"><span class="w-12 text-sm">응대</span><div class="flex-1 bg-slate-200 rounded-full h-2 mx-2"><div class="bg-yellow-400 h-2 rounded-full" style="width: ${restaurant.serviceRating * 20}%"></div></div><span class="text-sm">${restaurant.serviceRating}</span></div>
                            </div>
                        </section>
                        
                        <section id="shop-reviews" class="bg-white p-6 rounded-2xl shadow-lg">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="text-lg font-bold">💬 방문자 리뷰 (${fn:length(restaurant.reviews)})</h3>
                                <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" class="bg-sky-500 text-white px-4 py-2 rounded-lg">리뷰 작성</a>
                            </div>
                            <div class="space-y-4">
                                <c:forEach var="review" items="${restaurant.reviews}">
                                    <div class="border-b pb-4">
                                        <div class="flex items-center mb-2">
                                            <span class="font-semibold">${review.author}</span>
                                            <div class="flex items-center ml-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="text-sm ${i <= review.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span class="text-sm text-slate-500 ml-auto"><fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd"/></span>
                                        </div>
                                        <p>${review.content}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>

                    </div>

                    <div class="lg:col-span-1 space-y-6 lg:sticky lg:top-24">
                        <section id="location-section" class="bg-white p-6 rounded-2xl shadow-lg">
                            <h3 class="text-lg font-bold mb-4">📍 위치</h3>
                            <div id="map" class="w-full h-48 bg-slate-200 rounded-lg"></div>
                        </section>

                        <section id="reservation-section" class="bg-white p-6 rounded-2xl shadow-lg">
                            <h3 class="text-lg font-bold mb-4">📅 온라인 예약</h3>
                            <form "${pageContext.request.contextPath}.do/reservation/create" class="space-y-4">
                                <input type="hidden" name="restaurantId" value="${restaurant.id}">
                                <div>
                                    <label class="block text-sm font-semibold mb-2">날짜</label>
                                    <input type="date" name="date" class="w-full p-2 border rounded-lg">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold mb-2">인원</label>
                                    <select name="partySize" class="w-full p-2 border rounded-lg">
                                        <c:forEach begin="1" end="10" var="i">
                                            <option value="${i}">${i}명</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold mb-2">예약가능시간</label>
                                    <div class="grid grid-cols-2 gap-2">
                                        <c:forEach var="slot" items="${availableSlots}">
                                            <button type="button" class="time-slot ${slot.statusClass}">${slot.time}</button>
                                        </c:forEach>
                                    </div>
                                </div>
                                <button type="submit" class="w-full bg-sky-500 text-white py-3 rounded-lg font-bold">예약하기</button>
                            </form>
                        </section>
                    </div>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
    
    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

    <script>
        // 카카오맵 API 스크립트
        var mapContainer = document.getElementById('map'),
            mapOption = { 
                center: new kakao.maps.LatLng(33.450701, 126.570667), // 기본 중심 좌표
                level: 3 
            };
        var map = new kakao.maps.Map(mapContainer, mapOption); 
        var geocoder = new kakao.maps.services.Geocoder();

        // 주소로 좌표를 검색
        geocoder.addressSearch('${restaurant.address}', function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="width:150px;text-align:center;padding:6px 0;">${restaurant.name}</div>'
                });
                infowindow.open(map, marker);
                map.setCenter(coords);
            } 
        });    
    </script>
</body>
</html>