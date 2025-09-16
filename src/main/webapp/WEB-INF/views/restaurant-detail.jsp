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
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e03c6239551c6c52a0a3822198007b27&libraries=services"></script>
    <style>
        body { 
            font-family: 'Noto Sans KR', sans-serif; 
            min-height: 100vh;
        }
        .page-content { 
            animation: fadeIn 0.8s ease-out; 
        }
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(20px); } 
            to { opacity: 1; transform: translateY(0); } 
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        .gradient-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .floating-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .floating-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 35px 60px -12px rgba(0, 0, 0, 0.3);
        }
        .pulse-animation {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        .shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 2s infinite;
        }
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        .rating-stars {
            filter: drop-shadow(0 2px 4px rgba(255, 193, 7, 0.3));
        }
        .coupon-glow {
            box-shadow: 0 0 20px rgba(255, 193, 7, 0.4);
            animation: glow 2s ease-in-out infinite alternate;
        }
        @keyframes glow {
            from { box-shadow: 0 0 20px rgba(255, 193, 7, 0.4); }
            to { box-shadow: 0 0 30px rgba(255, 193, 7, 0.6); }
        }
    </style>
    <style type="text/tailwindcss">
        .time-slot { @apply p-3 rounded-xl transition-all duration-300 font-semibold; }
        .time-slot-available { @apply cursor-pointer text-white bg-gradient-to-r from-emerald-500 to-teal-500 hover:from-emerald-600 hover:to-teal-600 transform hover:scale-105; }
        .time-slot-closing { @apply cursor-pointer text-white bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 transform hover:scale-105; }
        .time-slot-full { @apply cursor-not-allowed text-slate-400 bg-slate-200; }
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

                                <!-- 🖼️ 사진 갤러리 섹션 -->
                                <section id="shop-photos" class="glass-card floating-card p-8 rounded-3xl">
                                    <div class="grid grid-cols-2 gap-4">
                                        <!-- 1번 이미지: 2칸 차지 (큰 이미지) -->
                                        <div class="group relative overflow-hidden rounded-2xl shadow-xl col-span-2">
                                            <img src="${not empty restaurant.image ? restaurant.image : 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832'}" 
                                                 alt="${restaurant.name}" class="w-full h-64 object-cover transition-transform duration-500 group-hover:scale-110">
                                            <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                                        </div>
                                        <!-- 2번 이미지: 1칸 차지 (작은 이미지) -->
                                        <div class="group relative overflow-hidden rounded-2xl shadow-xl">
                                            <img src="https://placehold.co/600x400/4ecdc4/ffffff?text=맛집" alt="맛집 내부" class="w-full h-48 object-cover transition-transform duration-500 group-hover:scale-110">
                                            <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                                        </div>
                                        <!-- 3번 이미지: 1칸 차지 (작은 이미지 + 전체보기 오버레이) -->
                                        <div class="group relative overflow-hidden rounded-2xl shadow-xl">
                                            <img src="https://placehold.co/600x400/ff6b6b/ffffff?text=EXTERIOR" alt="맛집 외관" class="w-full h-48 object-cover transition-transform duration-500 group-hover:scale-110">
                                            <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center text-white text-lg font-bold rounded-2xl">
                                                전체보기 (3)
                                            </div>
                                        </div>
                                    </div>
                                </section>

                                <!-- 🏪 가게 헤더 섹션 -->
                                <section id="shop-header" class="glass-card floating-card p-8 rounded-3xl">
                                    <div class="flex justify-between items-start mb-6">
                                        <div>
                                            <h1 class="text-4xl font-black mb-3 gradient-text">${restaurant.name}</h1>
                                            <div class="flex items-center space-x-2 text-slate-600">
                                                <span class="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-3 py-1 rounded-full text-sm font-semibold">${restaurant.category}</span>
                                                <span class="text-lg">📍 ${restaurant.location}</span>
                                            </div>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-4xl font-black bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text text-transparent">${restaurant.rating}</div>
                                            <div class="flex items-center justify-center mt-2">
                                                <div class="rating-stars flex space-x-1">
                                                    <c:forEach begin="1" end="5">
                                                        <c:choose>
                                                            <c:when test="${restaurant.rating >= 4.5}">
                                                                <span class="text-yellow-400 text-xl">★</span>
                                                            </c:when>
                                                            <c:when test="${restaurant.rating >= 3.5}">
                                                                <span class="text-yellow-400 text-xl">★</span>
                                                            </c:when>
                                                            <c:when test="${restaurant.rating >= 2.5}">
                                                                <span class="text-yellow-400 text-xl">★</span>
                                                            </c:when>
                                                            <c:when test="${restaurant.rating >= 1.5}">
                                                                <span class="text-yellow-400 text-xl">★</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-slate-300 text-xl">☆</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="text-sm text-slate-500 mt-1">${restaurant.reviewCount}개 리뷰</div>
                                        </div>
                                    </div>
                                    <div class="flex space-x-4">
                                        <button class="bg-gradient-to-r from-red-500 to-pink-500 text-white px-6 py-3 rounded-2xl font-semibold hover:from-red-600 hover:to-pink-600 transform hover:scale-105 transition-all duration-300 shadow-lg pulse-animation">
                                            ❤️ 찜하기
                                        </button>
                                        <button class="bg-gradient-to-r from-slate-500 to-slate-600 text-white px-6 py-3 rounded-2xl font-semibold hover:from-slate-600 hover:to-slate-700 transform hover:scale-105 transition-all duration-300 shadow-lg">
                                            📤 공유
                                        </button>
                                    </div>
                                </section>
                                
                                <!-- 🎫 쿠폰 섹션 -->
                                <section id="coupon-section" class="glass-card floating-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold mb-6 gradient-text">🎫 MEET LOG 단독 쿠폰</h3>
                                    <div class="coupon-glow bg-gradient-to-r from-yellow-100 to-orange-100 p-6 rounded-3xl border-2 border-yellow-300 relative overflow-hidden">
                                        <div class="absolute top-0 right-0 w-20 h-20 bg-yellow-400 rounded-full -translate-y-10 translate-x-10 opacity-20"></div>
                                        <div class="absolute bottom-0 left-0 w-16 h-16 bg-orange-400 rounded-full translate-y-8 -translate-x-8 opacity-20"></div>
                                        <div class="relative z-10">
                                            <div class="flex items-center justify-between">
                                                <div>
                                                    <p class="text-2xl font-black text-yellow-800 mb-2">🎉 모든 메뉴 10% 할인</p>
                                                    <p class="text-yellow-700 font-semibold">지금 바로 사용 가능한 특별 혜택!</p>
                                                </div>
                                                <div class="text-4xl">🎫</div>
                                            </div>
                                            <button class="mt-4 bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-8 py-4 rounded-2xl font-bold hover:from-yellow-600 hover:to-orange-600 transform hover:scale-105 transition-all duration-300 shadow-xl">
                                                🎁 쿠폰받기
                                            </button>
                                        </div>
                                    </div>
                                </section>
                                
                                <!-- 📍 가게 정보 섹션 -->
                                <section id="shop-info" class="glass-card floating-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold mb-6 gradient-text">📍 가게 정보</h3>
                                    <div class="space-y-6">
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl">
                                            <div class="text-2xl">🏠</div>
                                            <div>
                                                <span class="font-bold text-slate-700">주소</span>
                                                <p class="text-slate-600 mt-1">${restaurant.address}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl">
                                            <div class="text-2xl">📞</div>
                                            <div>
                                                <span class="font-bold text-slate-700">전화번호</span>
                                                <p class="text-slate-600 mt-1">${restaurant.phone}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl">
                                            <div class="text-2xl">🕒</div>
                                            <div>
                                                <span class="font-bold text-slate-700">영업시간</span>
                                                <p class="text-slate-600 mt-1">매일 12:00 - 22:00</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl">
                                            <div class="text-2xl">🍽️</div>
                                            <div class="flex-1">
                                                <span class="font-bold text-slate-700">인기 메뉴</span>
                                                <div class="mt-2 space-y-2">
                                                    <c:choose>
                                                        <c:when test="${not empty menus}">
                                                            <c:forEach var="menu" items="${menus}" begin="0" end="2">
                                                                <div class="flex justify-between items-center bg-white/50 p-2 rounded-lg">
                                                                    <span class="font-semibold">${menu.name}</span>
                                                                    <span class="text-orange-600 font-bold"><fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="원" /></span>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-slate-500 italic">메뉴 정보가 없습니다.</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>

                                <!-- ⭐ 방문자 평가 섹션 -->
                                <section id="visitor-ratings" class="glass-card floating-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold mb-6 gradient-text">⭐ 방문자 평가</h3>
                                    <div class="flex items-center mb-8">
                                        <div class="text-6xl font-black bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text text-transparent mr-6">${restaurant.rating}</div>
                                        <div class="flex space-x-1">
                                            <c:forEach begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${restaurant.rating >= 4.5}">
                                                        <span class="text-yellow-400 text-3xl rating-stars">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 3.5}">
                                                        <span class="text-yellow-400 text-3xl rating-stars">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 2.5}">
                                                        <span class="text-yellow-400 text-3xl rating-stars">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 1.5}">
                                                        <span class="text-yellow-400 text-3xl rating-stars">★</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-slate-300 text-3xl">☆</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="space-y-6">
                                        <div class="flex items-center p-4 bg-gradient-to-r from-yellow-50 to-orange-50 rounded-2xl">
                                            <span class="w-16 text-lg font-bold text-slate-700">🍽️ 맛</span>
                                            <div class="flex-1 bg-slate-200 rounded-full h-3 mx-4 shadow-inner">
                                                <div class="bg-gradient-to-r from-yellow-400 to-orange-500 h-3 rounded-full transition-all duration-1000" style="width: ${restaurant.rating * 20}%"></div>
                                            </div>
                                            <span class="text-lg font-bold text-orange-600">${restaurant.rating}</span>
                                        </div>
                                        <div class="flex items-center p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl">
                                            <span class="w-16 text-lg font-bold text-slate-700">💰 가격</span>
                                            <div class="flex-1 bg-slate-200 rounded-full h-3 mx-4 shadow-inner">
                                                <div class="bg-gradient-to-r from-green-400 to-emerald-500 h-3 rounded-full transition-all duration-1000" style="width: ${restaurant.rating * 20}%"></div>
                                            </div>
                                            <span class="text-lg font-bold text-green-600">${restaurant.rating}</span>
                                        </div>
                                        <div class="flex items-center p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl">
                                            <span class="w-16 text-lg font-bold text-slate-700">😊 응대</span>
                                            <div class="flex-1 bg-slate-200 rounded-full h-3 mx-4 shadow-inner">
                                                <div class="bg-gradient-to-r from-blue-400 to-indigo-500 h-3 rounded-full transition-all duration-1000" style="width: ${restaurant.rating * 20}%"></div>
                                            </div>
                                            <span class="text-lg font-bold text-blue-600">${restaurant.rating}</span>
                                        </div>
                                    </div>
                                </section>
                                
                                <!-- 💬 방문자 리뷰 섹션 -->
                                <section id="shop-reviews" class="glass-card floating-card p-8 rounded-3xl">
                                    <div class="flex justify-between items-center mb-6">
                                        <h3 class="text-2xl font-bold gradient-text">💬 방문자 리뷰 (${restaurant.reviewCount})</h3>
                                        <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" 
                                           class="bg-gradient-to-r from-cyan-500 to-blue-500 text-white px-6 py-3 rounded-2xl font-semibold hover:from-cyan-600 hover:to-blue-600 transform hover:scale-105 transition-all duration-300 shadow-lg">
                                            ✍️ 리뷰 작성
                                        </a>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <div class="space-y-6">
                                                <c:forEach var="review" items="${reviews}">
                                                    <div class="bg-gradient-to-r from-white/80 to-slate-50/80 p-6 rounded-2xl border border-white/20 shadow-lg">
                                                        <div class="flex items-center mb-4">
                                                            <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg mr-4">
                                                                ${review.author.charAt(0)}
                                                            </div>
                                                            <div class="flex-1">
                                                                <div class="flex items-center space-x-2">
                                                                    <span class="font-bold text-slate-800">${review.author}</span>
                                                                    <div class="flex space-x-1">
                                                                        <c:forEach begin="1" end="${review.rating}">
                                                                            <span class="text-yellow-400 text-lg rating-stars">★</span>
                                                                        </c:forEach>
                                                                        <c:forEach begin="${review.rating + 1}" end="5">
                                                                            <span class="text-slate-300 text-lg">☆</span>
                                                                        </c:forEach>
                                                                    </div>
                                                                </div>
                                                                <span class="text-sm text-slate-500">${review.createdAt}</span>
                                                            </div>
                                                        </div>
                                                        <p class="text-slate-700 leading-relaxed">${review.content}</p>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-12">
                                                <div class="text-6xl mb-4">📝</div>
                                                <h4 class="text-xl font-bold text-slate-600 mb-2">아직 리뷰가 없습니다</h4>
                                                <p class="text-slate-500">첫 번째 리뷰를 작성해보세요!</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </section>

                            </div>

                            <!-- 📱 사이드바 -->
                            <div class="lg:col-span-1 space-y-8">
                                <!-- 🗺️ 위치 섹션 -->
                                <section id="location-section" class="glass-card floating-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold mb-6 gradient-text">📍 위치</h3>
                                    <div class="w-full h-64 bg-gradient-to-br from-blue-100 to-indigo-200 rounded-2xl flex items-center justify-center relative overflow-hidden">
                                        <div class="absolute inset-0 bg-gradient-to-br from-blue-400/20 to-indigo-600/20"></div>
                                        <div class="relative z-10 text-center">
                                            <div class="text-4xl mb-2">🗺️</div>
                                            <span class="text-slate-600 font-semibold">지도 영역</span>
                                        </div>
                                    </div>
                                </section>

                                <!-- 📅 예약 섹션 -->
                                <section id="reservation-section" class="glass-card floating-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold mb-6 gradient-text">📅 온라인 예약</h3>
                                    <div class="space-y-6">
                                        <div>
                                            <label class="block text-sm font-bold mb-3 text-slate-700">📅 날짜</label>
                                            <input type="date" value="2023-09-15" class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold mb-3 text-slate-700">👥 인원</label>
                                            <select class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
                                                <option>2명</option>
                                                <option>3명</option>
                                                <option>4명</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold mb-3 text-slate-700">⏰ 예약가능시간</label>
                                            <div class="grid grid-cols-2 gap-3">
                                                <button class="time-slot time-slot-available">17:00</button>
                                                <button class="time-slot time-slot-available">18:00</button>
                                                <button class="time-slot time-slot-closing">19:00</button>
                                                <button class="time-slot time-slot-full">20:00</button>
                                            </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}" 
                                           class="w-full bg-gradient-to-r from-emerald-500 to-teal-500 text-white py-4 rounded-2xl font-bold block text-center hover:from-emerald-600 hover:to-teal-600 transform hover:scale-105 transition-all duration-300 shadow-xl">
                                            🎯 예약하기
                                        </a>
                                    </div>
                                </section>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="glass-card floating-card p-12 rounded-3xl text-center">
                            <div class="text-8xl mb-6">😔</div>
                            <h2 class="text-3xl font-bold gradient-text mb-4">맛집 정보를 찾을 수 없습니다</h2>
                            <p class="text-slate-600 mb-8">요청하신 맛집 정보가 존재하지 않거나 삭제되었습니다.</p>
                            <a href="${pageContext.request.contextPath}/main" 
                               class="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-8 py-4 rounded-2xl font-semibold hover:from-blue-600 hover:to-purple-600 transform hover:scale-105 transition-all duration-300 shadow-lg">
                                🏠 메인 페이지로 돌아가기
                            </a>
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