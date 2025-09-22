<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.ApiKeyLoader, model.OperatingHour, java.time.LocalTime, java.time.LocalDate, java.time.format.DateTimeFormatter, java.util.ArrayList, java.util.List, java.util.Collections" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<%
    ApiKeyLoader.load(application);
    String kakaoApiKey = ApiKeyLoader.getApiKey("kakao.api.key");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - <c:out value="${restaurant.name}" default="맛집 상세" /></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= kakaoApiKey %>&libraries=services&autoload=false"></script>
    <style>
        :root {
            --primary: #3b82f6; --primary-dark: #2563eb; --secondary: #8b5cf6; --accent: #f59e0b;
            --success: #10b981; --warning: #f59e0b; --error: #ef4444; --gray-50: #f8fafc;
            --gray-100: #f1f5f9; --gray-200: #e2e8f0; --gray-300: #cbd5e1; --gray-400: #94a3b8;
            --gray-500: #64748b; --gray-600: #475569; --gray-700: #334155; --gray-800: #1e293b; --gray-900: #0f172a;
        }
        * { font-family: 'Noto Sans KR', sans-serif; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .glass-card:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .gradient-text { background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .rating-stars { filter: drop-shadow(0 2px 4px rgba(251, 191, 36, 0.3)); }
        .time-slot { padding: 0.75rem; border-radius: 0.75rem; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); font-weight: 600; border: 2px solid transparent; }
        .time-slot-available { cursor: pointer; color: white; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-color: #10b981; }
        .time-slot-available:hover { transform: scale(1.05); box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4); }
        .time-slot-full { cursor: not-allowed; color: #94a3b8; background: #f1f5f9; border-color: #e2e8f0; }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <c:choose>
                    <c:when test="${not empty restaurant}">
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:items-start">
                            <div class="lg:col-span-2 space-y-8">
                                <section class="glass-card p-8 rounded-3xl">
                                    <div class="relative group overflow-hidden rounded-2xl">
                                        <mytag:image fileName="${restaurant.image}" altText="${restaurant.name}" cssClass="w-full h-80 object-cover" />
                                    </div>
                                </section>
                                <section class="glass-card p-8 rounded-3xl">
                                    <div class="flex items-start justify-between mb-6">
                                        <div class="flex-1">
                                            <h1 class="text-4xl font-bold gradient-text mb-3">${restaurant.name}</h1>
                                            <div class="flex items-center space-x-3 mb-4">
                                                <span class="info-badge">${restaurant.category}</span>
                                                <span class="location-badge">📍 ${restaurant.location}</span>
                                            </div>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-5xl font-black rating-badge mb-2"><fmt:formatNumber value="${restaurant.rating}" maxFractionDigits="1"/></div>
                                            <div class="text-sm text-slate-500">${restaurant.reviewCount}개 리뷰</div>
                                        </div>
                                    </div>
                                </section>
                                <section class="glass-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold gradient-text mb-6">상세 정보</h3>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <p><strong>🏠 주소:</strong> ${restaurant.address}</p>
                                        <p><strong>📞 전화번호:</strong> ${not empty restaurant.phone ? restaurant.phone : "정보 없음"}</p>
                                        <p><strong>🕒 영업시간:</strong> ${not empty restaurant.hours ? restaurant.hours : "정보 없음"}</p>
                                        <p><strong>🅿️ 주차:</strong> ${restaurant.parking ? "가능" : "불가"}</p>
                                    </div>
                                </section>
                                <section class="glass-card p-8 rounded-3xl">
                                    <h2 class="text-2xl font-bold gradient-text mb-6">리뷰 (${fn:length(reviews)})</h2>
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="border-t border-gray-200 py-4">
                                                    <span class="font-bold text-gray-900">${review.author}</span> - <span>${review.createdAt.format(DateTimeFormatter.ofPattern('yyyy.MM.dd'))}</span>
                                                    <p class="text-gray-700">${review.content}</p>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-center py-8 text-gray-500">아직 작성된 리뷰가 없습니다.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </section>
                            </div>
                            <div class="space-y-8">
                                <section class="glass-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold gradient-text mb-6">위치</h3>
                                    <div id="map" class="w-full h-64 rounded-2xl border"></div>
                                </section>
                                <section class="glass-card p-8 rounded-3xl">
                                    <h3 class="text-2xl font-bold gradient-text mb-6">온라인 예약</h3>
                                    <%
                                        List<OperatingHour> operatingHours = (List<OperatingHour>) request.getAttribute("operatingHours");
                                        int todayDayOfWeek = LocalDate.now().getDayOfWeek().getValue();
                                        List<String> timeSlots = new ArrayList<>();
                                        if (operatingHours != null) {
                                            for (OperatingHour oh : operatingHours) {
                                                if (oh.getDayOfWeek() == todayDayOfWeek) {
                                                    LocalTime startTime = oh.getOpeningTime();
                                                    LocalTime endTime = oh.getClosingTime().minusMinutes(30);
                                                    LocalTime currentTime = startTime;
                                                    while (!currentTime.isAfter(endTime)) {
                                                        timeSlots.add(currentTime.format(DateTimeFormatter.ofPattern("HH:mm")));
                                                        currentTime = currentTime.plusMinutes(30);
                                                    }
                                                }
                                            }
                                        }
                                        Collections.sort(timeSlots);
                                        pageContext.setAttribute("timeSlots", timeSlots);
                                    %>
                                    <c:choose>
                                        <c:when test="${not empty timeSlots}">
                                            <div class="grid grid-cols-3 gap-2">
                                                <c:forEach var="time" items="${timeSlots}">
                                                    <button type="button" class="time-slot time-slot-available">${time}</button>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-center py-8 text-gray-500">오늘은 예약 가능한 시간이 없습니다.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </section>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="glass-card p-12 rounded-3xl text-center">
                            <h2 class="text-3xl font-bold gradient-text mb-4">맛집 정보를 찾을 수 없습니다</h2>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
    <script>
        <c:if test="${not empty restaurant and restaurant.latitude != 0 and restaurant.longitude != 0}">
            kakao.maps.load(() => {
                const mapContainer = document.getElementById('map');
                const mapOption = { 
                    center: new kakao.maps.LatLng(${restaurant.latitude}, ${restaurant.longitude}),
                    level: 3
                };
                const map = new kakao.maps.Map(mapContainer, mapOption);
                const marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(${restaurant.latitude}, ${restaurant.longitude}) });
                marker.setMap(map);
            });
        </c:if>
    </script>
</body>
</html>