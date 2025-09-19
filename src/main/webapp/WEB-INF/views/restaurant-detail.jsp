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
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --secondary: #8b5cf6;
            --accent: #f59e0b;
            --success: #10b981;
            --warning: #f59e0b;
            --error: #ef4444;
            --gray-50: #f8fafc;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-300: #cbd5e1;
            --gray-400: #94a3b8;
            --gray-500: #64748b;
            --gray-600: #475569;
            --gray-700: #334155;
            --gray-800: #1e293b;
            --gray-900: #0f172a;
        }
        
        * {
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .glass-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        
        .gradient-text {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary) 0%, #7c3aed 100%);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4);
        }
        
        .rating-stars {
            filter: drop-shadow(0 2px 4px rgba(251, 191, 36, 0.3));
        }
        
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes fadeIn {
            from { 
                opacity: 0; 
                transform: translateY(20px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        .slide-up {
            animation: slideUp 0.8s ease-out;
        }
        
        @keyframes slideUp {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        .pulse-glow {
            animation: pulseGlow 2s ease-in-out infinite;
        }
        
        @keyframes pulseGlow {
            0%, 100% { 
                box-shadow: 0 0 20px rgba(59, 130, 246, 0.3); 
            }
            50% { 
                box-shadow: 0 0 30px rgba(59, 130, 246, 0.5); 
            }
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
        
        .progress-bar {
            background: linear-gradient(90deg, var(--accent) 0%, #fbbf24 100%);
            transition: width 1s ease-out;
        }
        
        .image-hover {
            transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .image-hover:hover {
            transform: scale(1.05);
        }
        
        .card-hover {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
        }
        
        .text-shadow {
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .border-gradient {
            border: 2px solid transparent;
            background: linear-gradient(white, white) padding-box,
                        linear-gradient(135deg, var(--primary), var(--secondary)) border-box;
        }
        
        .coupon-glow {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 2px solid #f59e0b;
            box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);
            animation: couponGlow 3s ease-in-out infinite;
        }
        
        @keyframes couponGlow {
            0%, 100% { 
                box-shadow: 0 0 20px rgba(245, 158, 11, 0.3); 
            }
            50% { 
                box-shadow: 0 0 30px rgba(245, 158, 11, 0.5); 
            }
        }
        
        .review-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(248, 250, 252, 0.9) 100%);
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }
        
        .menu-item {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .menu-item:hover {
            transform: translateX(4px);
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }
        
        .info-badge {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-block;
        }
        
        .location-badge {
            background: linear-gradient(135deg, var(--success) 0%, #059669 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-block;
        }
        
        .rating-badge {
            background: linear-gradient(135deg, var(--accent) 0%, #d97706 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-block;
        }
        
        .floating-action {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            z-index: 50;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }
        
        .section-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent 0%, var(--gray-300) 50%, transparent 100%);
            margin: 2rem 0;
        }
        
        .loading-skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
        }
        
        .time-slot {
            padding: 0.75rem;
            border-radius: 0.75rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 600;
            border: 2px solid transparent;
        }
        
        .time-slot-available {
            cursor: pointer;
            color: white;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border-color: #10b981;
        }
        
        .time-slot-available:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
        }
        
        .time-slot-closing {
            cursor: pointer;
            color: white;
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            border-color: #f59e0b;
        }
        
        .time-slot-closing:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(245, 158, 11, 0.4);
        }
        
        .time-slot-full {
            cursor: not-allowed;
            color: #94a3b8;
            background: #f1f5f9;
            border-color: #e2e8f0;
        }
        
        .floating-action-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            z-index: 50;
            animation: float 3s ease-in-out infinite;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.4);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .floating-action-btn:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 20px 40px rgba(59, 130, 246, 0.6);
        }
        
        @media (max-width: 768px) {
            .glass-card {
                margin: 0.5rem;
                border-radius: 1rem;
                padding: 1.5rem;
            }
            
            .floating-action-btn {
                bottom: 1rem;
                right: 1rem;
                padding: 0.75rem 1.25rem;
            }
            
            .text-4xl {
                font-size: 2rem;
            }
            
            .text-5xl {
                font-size: 2.5rem;
            }
            
            .grid-cols-2 {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .glass-card {
                margin: 0.25rem;
                padding: 1rem;
            }
            
            .text-2xl {
                font-size: 1.5rem;
            }
            
            .text-3xl {
                font-size: 1.75rem;
            }
        }
    </style>
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
                                            <div class="flex-1">
                                                <span class="font-bold text-slate-700">영업시간</span>
                                                <c:choose>
                                                    <c:when test="${not empty operatingHours}">
                                                        <div class="mt-2 space-y-1">
                                                            <c:forEach var="hour" items="${operatingHours}">
                                                                <div class="flex justify-between text-sm">
                                                                    <span class="text-slate-600">
                                                                        <c:choose>
                                                                            <c:when test="${hour.dayOfWeek == 1}">월요일</c:when>
                                                                            <c:when test="${hour.dayOfWeek == 2}">화요일</c:when>
                                                                            <c:when test="${hour.dayOfWeek == 3}">수요일</c:when>
                                                                            <c:when test="${hour.dayOfWeek == 4}">목요일</c:when>
                                                                            <c:when test="${hour.dayOfWeek == 5}">금요일</c:when>
                                                                            <c:when test="${hour.dayOfWeek == 6}">토요일</c:when>
                                                                            <c:when test="${hour.dayOfWeek == 7}">일요일</c:when>
                                                                        </c:choose>
                                                                    </span>
                                                                    <span class="text-slate-600">
                                                                        <c:choose>
                                                                            <c:when test="${empty hour.openingTime}">
                                                                                <span class="text-red-500">휴무</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${hour.openingTime} - ${hour.closingTime}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="text-slate-600 mt-1">영업시간 정보 없음</p>
                                                    </c:otherwise>
                                                </c:choose>
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
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="glass-card p-12 rounded-3xl text-center fade-in">
                            <div class="text-8xl mb-6">😔</div>
                            <h2 class="text-3xl font-bold gradient-text mb-4">맛집 정보를 찾을 수 없습니다</h2>
                            <p class="text-slate-600 mb-8">요청하신 맛집 정보가 존재하지 않거나 삭제되었습니다.</p>
                            <a href="${pageContext.request.contextPath}/main" 
                               class="btn-primary text-white px-8 py-4 rounded-2xl font-semibold inline-block">
                                🏠 메인 페이지로 돌아가기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <%-- Added missing footer include for consistency --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        
        <!-- 플로팅 액션 버튼 -->
        <c:if test="${not empty restaurant}">
            <a href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}" 
               class="floating-action-btn">
                🎯 예약하기
            </a>
        </c:if>
    </div>

    <script>
        // 페이지 로드 시 애니메이션 효과
        document.addEventListener('DOMContentLoaded', function() {
            // 스크롤 애니메이션
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);
            
            // 모든 섹션에 애니메이션 적용
            document.querySelectorAll('.glass-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
                observer.observe(card);
            });
            
            // 이미지 호버 효과
            document.querySelectorAll('.image-hover').forEach(img => {
                img.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.05)';
                });
                
                img.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                });
            });
            
            // 카드 호버 효과
            document.querySelectorAll('.card-hover').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                    this.style.boxShadow = '0 12px 24px rgba(0, 0, 0, 0.15)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.1)';
                });
            });
        });
    </script>

</body>
</html>