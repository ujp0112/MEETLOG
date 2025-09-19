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
<<<<<<< HEAD
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
=======
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
                                <!-- 🖼️ 메인 이미지 섹션 -->
                                <section class="glass-card p-8 rounded-3xl fade-in">
                                    <div class="relative group overflow-hidden rounded-2xl">
                                        <img src="${not empty restaurant.image ? restaurant.image : 'https://placehold.co/800x400/3b82f6/ffffff?text=맛집+이미지'}" 
                                             alt="${restaurant.name}" class="w-full h-80 object-cover image-hover">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                                        <div class="absolute bottom-4 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                                            <h2 class="text-2xl font-bold text-shadow">${restaurant.name}</h2>
                                            <p class="text-sm text-shadow">${restaurant.category} • ${restaurant.location}</p>
                                        </div>
                                    </div>
                                </section>

                                <!-- 🏪 가게 정보 헤더 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <div class="flex items-start justify-between mb-6">
                                        <div class="flex-1">
                                            <h1 class="text-4xl font-bold gradient-text mb-3">${restaurant.name}</h1>
                                            <div class="flex items-center space-x-3 mb-4">
                                                <span class="info-badge">${restaurant.category}</span>
                                                <span class="location-badge">📍 ${restaurant.location}</span>
                                            </div>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-5xl font-black rating-badge mb-2">${restaurant.rating}</div>
                                            <div class="flex items-center justify-center mb-2">
                                                <div class="rating-stars flex space-x-1">
                                                    <c:forEach begin="1" end="5">
                                                        <c:choose>
                                                            <c:when test="${restaurant.rating >= 4.5}">
                                                                <span class="text-yellow-400 text-2xl">★</span>
                                                            </c:when>
                                                            <c:when test="${restaurant.rating >= 3.5}">
                                                                <span class="text-yellow-400 text-2xl">★</span>
                                                            </c:when>
                                                            <c:when test="${restaurant.rating >= 2.5}">
                                                                <span class="text-yellow-400 text-2xl">★</span>
                                                            </c:when>
                                                            <c:when test="${restaurant.rating >= 1.5}">
                                                                <span class="text-yellow-400 text-2xl">★</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-slate-300 text-2xl">☆</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="text-sm text-slate-500">${restaurant.reviewCount}개 리뷰</div>
                                        </div>
                                    </div>
                                    
                                    <div class="flex space-x-4">
                                        <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold pulse-glow">
                                            ❤️ 찜하기
                                        </button>
                                        <button class="btn-secondary text-white px-6 py-3 rounded-2xl font-semibold">
                                            📤 공유하기
                                        </button>
                                    </div>
                                </section>
                                
                                <!-- 📍 상세 정보 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <h3 class="text-2xl font-bold gradient-text mb-6">상세 정보</h3>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl card-hover">
                                            <div class="text-2xl">🏠</div>
                                            <div>
                                                <span class="font-bold text-slate-700">주소</span>
                                                <p class="text-slate-600 mt-1">${restaurant.address}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl card-hover">
                                            <div class="text-2xl">📞</div>
                                            <div>
                                                <span class="font-bold text-slate-700">전화번호</span>
                                                <p class="text-slate-600 mt-1">${not empty restaurant.phone ? restaurant.phone : "정보 없음"}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl card-hover">
                                            <div class="text-2xl">🕒</div>
                                            <div>
                                                <span class="font-bold text-slate-700">영업시간</span>
                                                <p class="text-slate-600 mt-1">${not empty restaurant.hours ? restaurant.hours : "정보 없음"}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4 p-4 bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl card-hover">
                                            <div class="text-2xl">🚗</div>
                                            <div>
                                                <span class="font-bold text-slate-700">주차</span>
                                                <p class="text-slate-600 mt-1">${restaurant.parking ? "가능" : "불가"}</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty restaurant.description}">
                                        <div class="mt-6 p-4 bg-gradient-to-r from-slate-50 to-gray-50 rounded-2xl">
                                            <h3 class="font-bold text-slate-700 mb-2">📝 설명</h3>
                                            <p class="text-slate-600 leading-relaxed">${restaurant.description}</p>
                                        </div>
                                    </c:if>
                                </section>

                                <!-- 🕒 운영 시간 섹션 -->
                                <c:if test="${not empty operatingHours}">
                                    <section class="glass-card p-8 rounded-3xl slide-up">
                                        <h3 class="text-2xl font-bold gradient-text mb-6">🕒 운영 시간</h3>
                                        <div class="space-y-2">
                                            <c:forEach var="hour" items="${operatingHours}">
                                                <div class="flex justify-between items-center p-3 bg-slate-50 rounded-lg">
                                                    <span class="font-semibold">${hour.dayOfWeek}</span>
                                                    <span class="text-slate-600">${hour.openingTime} - ${hour.closingTime}</span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>

                                <!-- 🍽️ 메뉴 섹션 -->
                                <c:if test="${not empty restaurant.menuList}">
                                    <section class="glass-card p-8 rounded-3xl slide-up">
                                        <h2 class="text-2xl font-bold gradient-text mb-6">🍽️ 메뉴</h2>
                                        <div class="space-y-4">
                                            <c:forEach var="menu" items="${restaurant.menuList}">
                                                <div class="menu-item flex justify-between items-center p-6 border-gradient rounded-2xl bg-white/50 backdrop-blur-sm">
                                                    <div class="flex-1">
                                                        <div class="flex items-center space-x-3">
                                                            <h3 class="font-bold text-slate-800 text-lg">${menu.name}</h3>
                                                            <c:if test="${menu.popular}">
                                                                <span class="text-xs bg-gradient-to-r from-red-500 to-pink-500 text-white px-3 py-1 rounded-full font-semibold">🔥 인기</span>
                                                            </c:if>
                                                        </div>
                                                        <c:if test="${not empty menu.description}">
                                                            <p class="text-sm text-slate-600 mt-1">${menu.description}</p>
                                                        </c:if>
                                                    </div>
                                                    <div class="text-right">
                                                        <span class="text-2xl font-bold text-sky-600">
                                                            <fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="₩" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>

                                <!-- 💬 리뷰 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <div class="flex justify-between items-center mb-6">
                                        <h2 class="text-2xl font-bold gradient-text">리뷰 (${restaurant.reviewCount})</h2>
                                        <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" 
                                           class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                                            ✍️ 리뷰 작성
                                        </a>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <div class="space-y-6">
                                                <c:forEach var="review" items="${reviews}">
                                                    <div class="review-card p-6 rounded-2xl card-hover">
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
                                                        
                                                        <!-- 상세 평점 표시 -->
                                                        <c:if test="${review.tasteRating > 0}">
                                                            <div class="mt-3 p-3 bg-slate-50 rounded-lg">
                                                                <h5 class="text-sm font-semibold text-slate-700 mb-2">상세 평점</h5>
                                                                <div class="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm">
                                                                    <div class="flex items-center space-x-1">
                                                                        <span class="text-slate-600">맛:</span>
                                                                        <div class="flex space-x-1">
                                                                            <c:forEach begin="1" end="${review.tasteRating}">
                                                                                <span class="text-yellow-400">★</span>
                                                                            </c:forEach>
                                                                            <c:forEach begin="${review.tasteRating + 1}" end="5">
                                                                                <span class="text-slate-300">☆</span>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                    <div class="flex items-center space-x-1">
                                                                        <span class="text-slate-600">서비스:</span>
                                                                        <div class="flex space-x-1">
                                                                            <c:forEach begin="1" end="${review.serviceRating}">
                                                                                <span class="text-yellow-400">★</span>
                                                                            </c:forEach>
                                                                            <c:forEach begin="${review.serviceRating + 1}" end="5">
                                                                                <span class="text-slate-300">☆</span>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                    <div class="flex items-center space-x-1">
                                                                        <span class="text-slate-600">분위기:</span>
                                                                        <div class="flex space-x-1">
                                                                            <c:forEach begin="1" end="${review.atmosphereRating}">
                                                                                <span class="text-yellow-400">★</span>
                                                                            </c:forEach>
                                                                            <c:forEach begin="${review.atmosphereRating + 1}" end="5">
                                                                                <span class="text-slate-300">☆</span>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                    <div class="flex items-center space-x-1">
                                                                        <span class="text-slate-600">가격:</span>
                                                                        <div class="flex space-x-1">
                                                                            <c:forEach begin="1" end="${review.priceRating}">
                                                                                <span class="text-yellow-400">★</span>
                                                                            </c:forEach>
                                                                            <c:forEach begin="${review.priceRating + 1}" end="5">
                                                                                <span class="text-slate-300">☆</span>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- 방문 정보 표시 -->
                                                                <c:if test="${not empty review.visitDate || review.partySize > 0 || not empty review.visitPurpose}">
                                                                    <div class="mt-2 pt-2 border-t border-slate-200">
                                                                        <div class="flex flex-wrap gap-4 text-xs text-slate-500">
                                                                            <c:if test="${not empty review.visitDate}">
                                                                                <span>📅 ${review.visitDate}</span>
                                                                            </c:if>
                                                                            <c:if test="${review.partySize > 0}">
                                                                                <span>👥 ${review.partySize}명</span>
                                                                            </c:if>
                                                                            <c:if test="${not empty review.visitPurpose}">
                                                                                <span>🎯 ${review.visitPurpose}</span>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </c:if>
                                                            </div>
                                                        </div>
                                                        <p class="text-slate-700 leading-relaxed mb-4">${review.content}</p>
                                                        <div class="flex items-center justify-between">
                                                            <button class="text-sky-600 hover:text-sky-700 text-sm font-semibold flex items-center space-x-1">
                                                                <span>❤️</span>
                                                                <span>${review.likes}</span>
                                                            </button>
                                                        </div>
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

                                <!-- 🎫 쿠폰 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <h2 class="text-2xl font-bold gradient-text mb-6">MEET LOG 단독 쿠폰</h2>
                                    <c:choose>
                                        <c:when test="${not empty coupons}">
                                            <div class="space-y-4">
                                                <c:forEach var="coupon" items="${coupons}">
                                                    <div class="coupon-glow p-6 rounded-3xl relative overflow-hidden">
                                                        <div class="absolute top-0 right-0 w-20 h-20 bg-yellow-400 rounded-full -translate-y-10 translate-x-10 opacity-20"></div>
                                                        <div class="absolute bottom-0 left-0 w-16 h-16 bg-orange-400 rounded-full translate-y-8 -translate-x-8 opacity-20"></div>
                                                        <div class="relative z-10">
                                                            <div class="flex items-center justify-between">
                                                                <div class="flex-1">
                                                                    <h3 class="text-2xl font-black text-yellow-800 mb-2">${coupon.title}</h3>
                                                                    <p class="text-yellow-700 font-semibold mb-2">${coupon.description}</p>
                                                                    <p class="text-xs text-yellow-600">유효기간: ${coupon.expiryDate}</p>
                                                                </div>
                                                                <div class="text-right">
                                                                    <div class="text-4xl font-black text-yellow-800 mb-4">${coupon.discountValue}${coupon.discountType == 'PERCENTAGE' ? '%' : '원'}</div>
                                                                    <button class="bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-6 py-3 rounded-2xl font-bold hover:from-yellow-600 hover:to-orange-600 transform hover:scale-105 transition-all duration-300 shadow-xl">
                                                                        🎁 쿠폰받기
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-12">
                                                <div class="text-6xl mb-4">🎫</div>
                                                <h4 class="text-xl font-bold text-slate-600 mb-2">사용 가능한 쿠폰이 없습니다</h4>
                                                <p class="text-slate-500">곧 새로운 혜택을 준비할 예정입니다!</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </section>

                                <!-- ❓ Q&A 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <h2 class="text-2xl font-bold gradient-text mb-6">Q&A</h2>
                                    <c:choose>
                                        <c:when test="${not empty qnas}">
                                            <div class="space-y-6">
                                                <c:forEach var="qna" items="${qnas}">
                                                    <div class="border-gradient rounded-2xl p-6 bg-white/50 backdrop-blur-sm card-hover">
                                                        <div class="mb-4">
                                                            <div class="flex items-center mb-3">
                                                                <span class="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-3 py-1 rounded-full text-sm font-semibold">Q</span>
                                                                <span class="ml-3 text-sm text-slate-500 font-medium">${qna.isOwner ? '사장님' : '고객'}</span>
                                                            </div>
                                                            <p class="text-slate-800 font-medium">${qna.question}</p>
                                                        </div>
                                                        <div class="border-t border-slate-200 pt-4">
                                                            <div class="flex items-center mb-3">
                                                                <span class="bg-gradient-to-r from-green-500 to-emerald-500 text-white px-3 py-1 rounded-full text-sm font-semibold">A</span>
                                                                <span class="ml-3 text-sm text-slate-500 font-medium">사장님</span>
                                                            </div>
                                                            <p class="text-slate-800">${qna.answer}</p>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-12">
                                                <div class="text-6xl mb-4">❓</div>
                                                <h4 class="text-xl font-bold text-slate-600 mb-2">등록된 Q&A가 없습니다</h4>
                                                <p class="text-slate-500">궁금한 점이 있으시면 언제든 문의해주세요!</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </section>
                            </div>

                            <!-- 📱 사이드바 -->
                            <div class="space-y-8">
                                <!-- 🗺️ 위치 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <h3 class="text-2xl font-bold gradient-text mb-6">위치</h3>
                                    <div class="w-full h-64 bg-gradient-to-br from-blue-100 to-indigo-200 rounded-2xl flex items-center justify-center relative overflow-hidden">
                                        <div class="absolute inset-0 bg-gradient-to-br from-blue-400/20 to-indigo-600/20"></div>
                                        <div class="relative z-10 text-center">
                                            <div class="text-4xl mb-2">🗺️</div>
                                            <span class="text-slate-600 font-semibold">지도 영역</span>
                                            <p class="text-sm text-slate-500 mt-1">${restaurant.address}</p>
                                        </div>
                                    </div>
                                </section>

                                <!-- 📅 예약 섹션 -->
                                <section class="glass-card p-8 rounded-3xl slide-up">
                                    <h3 class="text-2xl font-bold gradient-text mb-6">온라인 예약</h3>
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
                                                <option>5명</option>
                                                <option>6명 이상</option>
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
                                           class="w-full btn-primary text-white py-4 rounded-2xl font-bold block text-center pulse-glow">
                                            🎯 예약하기
                                        </a>
                                    </div>
                                </section>
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
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