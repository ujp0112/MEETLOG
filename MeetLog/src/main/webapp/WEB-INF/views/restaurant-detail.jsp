<%@ page import="util.ApiKeyLoader, model.OperatingHour, java.time.LocalTime, java.time.LocalDate, java.time.format.DateTimeFormatter, java.util.ArrayList, java.util.List, java.util.Collections" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<%@ page isELIgnored="false" %>
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
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= kakaoApiKey %>&libraries=services&autoload=false"></script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f7f9fc; }
        .custom-card { background-color: #ffffff; border-radius: 16px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08); padding: 24px; margin-bottom: 24px; }
        .gradient-heading { background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .rating-score { font-size: 2.8rem; font-weight: 900; color: #ffc107; }
        .btn-primary { background-image: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%); color: white; padding: 12px 24px; border-radius: 12px; font-weight: 600; text-align: center; display: block; }
        .btn-reserve-time { background-color: #f0f7ff; color: #2575fc; border: 1px solid #cce1ff; padding: 8px 16px; border-radius: 8px; font-weight: 500; cursor: pointer; }
        .btn-reserve-time.selected { background-color: #2575fc; color: white; }
        .section-title { font-size: 1.5rem; font-weight: 700; color: #333; margin-bottom: 20px; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800">

    <div id="app" class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8 max-w-7xl">
                <c:choose>
                    <c:when test="${not empty restaurant}">
                         <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                            <div class="lg:col-span-2">
                                
                                 <%-- 메인 이미지 섹션 --%>
                                <div class="custom-card p-4">
                                    <div class="overflow-hidden rounded-xl shadow-md">
                                         <mytag:image fileName="${restaurant.image}" altText="${restaurant.name}" cssClass="w-full h-80 object-cover" />
                                    </div>
                                 </div>

                                <%-- 맛집 정보 및 액션 버튼 섹션 --%>
                                <div class="custom-card p-6 flex flex-col sm:flex-row justify-between items-start sm:items-center">
                                     <div class="mb-4 sm:mb-0">
                                        <h1 class="text-4xl font-black mb-2 gradient-heading">${restaurant.name}</h1>
                                         <div class="flex items-center space-x-3 text-gray-600 text-lg">
                                            <span class="bg-blue-100 text-blue-800 text-sm font-semibold px-3 py-1 rounded-full">${restaurant.category}</span>
                                             <span>${restaurant.location}</span>
                                        </div>
                                    </div>
                                     <div class="text-right flex items-center space-x-4">
                                        <div class="text-center">
                                             <div class="rating-score"><fmt:formatNumber value="${restaurant.rating}" maxFractionDigits="1"/></div>
                                            <div class="text-sm text-gray-500">${restaurant.reviewCount}개 리뷰</div>
                                         </div>
                                    </div>
                                </div>
                                 
                                <%-- 상세 정보 섹션 --%>
                                <div class="custom-card p-6">
                                     <h3 class="section-title">상세 정보</h3>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-gray-700">
                                        <p><strong>🏠 주소:</strong> ${restaurant.address}</p>
                                         <p><strong>📞 전화번호:</strong> ${not empty restaurant.phone ? restaurant.phone : "정보 없음"}</p>
                                        <p><strong>🕒 영업시간:</strong> ${not empty restaurant.hours ? restaurant.hours : "정보 없음"}</p>
                                        <p><strong>🅿️ 주차:</strong> ${restaurant.parking ? "가능" : "불가"}</p>
                                    </div>
                                    <c:if test="${not empty restaurant.description}">
                                         <div class="mt-6 pt-4 border-t border-gray-200">
                                            <h4 class="font-semibold text-lg mb-2 text-gray-700">설명</h4>
                                             <p class="text-gray-600 leading-relaxed">${restaurant.description}</p>
                                        </div>
                                    </c:if>
                                 </div>

                                <%-- 리뷰 섹션 --%>
                                <div class="custom-card p-6">
                                     <div class="flex justify-between items-center mb-5">
                                        <h3 class="section-title">리뷰 (${fn:length(reviews)})</h3>
                                         <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" class="btn-primary text-sm px-4 py-2">리뷰 작성</a>
                                    </div>
                                    <c:choose>
                                         <c:when test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                 <div class="border-t border-gray-200 py-4">
                                                    <div class="flex justify-between items-center mb-2">
                                                         <span class="font-bold text-gray-900">${review.author}</span>
                                                         <span class="text-sm text-gray-500">${review.createdAt.format(DateTimeFormatter.ofPattern('yyyy.MM.dd'))}</span>
                                                    </div>
                                                     <p class="text-gray-700">${review.content}</p>
                                                </div>
                                             </c:forEach>
                                        </c:when>
                                         <c:otherwise>
                                            <p class="text-center py-8 text-gray-500">아직 작성된 리뷰가 없습니다. 첫 리뷰를 남겨주세요!</p>
                                        </c:otherwise>
                                    </c:choose>
                                 </div>
                            </div>
                            
                            <%-- 사이드바 --%>
                             <div>
                                <div class="custom-card p-6">
                                    <h3 class="section-title">위치</h3>
                                     <div id="map" class="w-full h-56 rounded-xl border border-gray-200 shadow-inner"></div>
                                    <hr class="my-6 border-gray-200">
                                     <h3 class="section-title">온라인 예약</h3>
                                    
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
                                        pageContext.setAttribute("lunchStart", LocalTime.of(12, 0));
                                        pageContext.setAttribute("dinnerStart", LocalTime.of(17, 0));
                                    %>
                                    
                                    <c:choose>
                                         <c:when test="${not empty timeSlots}">
                                            <div class="space-y-4">
                                                 <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-1">날짜</label>
                                                     <input type="date" class="w-full rounded-md border-gray-300 shadow-sm p-2" value="<%= LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE) %>">
                                                </div>
                                                 <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-1">인원</label>
                                                     <select class="w-full rounded-md border-gray-300 shadow-sm p-2"><option>2명</option></select>
                                                </div>
                                                 <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-2">예약 가능 시간</label>
                                                     <div class="grid grid-cols-3 gap-2">
                                                          <c:set var="lastCategory" value="" />
                                                        <c:forEach var="time" items="${timeSlots}">
                                                             <c:set var="currentTime" value="${LocalTime.parse(time)}" />
                                                            <c:set var="currentCategory" value="" />
                                                             <c:if test="${currentTime.isBefore(lunchStart)}"><c:set var="currentCategory" value="오전" /></c:if>
                                                             <c:if test="${not currentTime.isBefore(lunchStart) and currentTime.isBefore(dinnerStart)}"><c:set var="currentCategory" value="점심" /></c:if>
                                                            <c:if test="${not currentTime.isBefore(dinnerStart)}"><c:set var="currentCategory" value="저녁" /></c:if>
                                                             <c:if test="${empty lastCategory}"><c:set var="lastCategory" value="${currentCategory}" /></c:if>
                                                             <c:if test="${lastCategory ne currentCategory}">
                                                                <div class="col-span-3 flex items-center my-2"><hr class="flex-grow border-t border-gray-200"><span class="px-2 text-sm text-gray-500">${currentCategory}</span><hr class="flex-grow border-t border-gray-200"></div>
                                                            </c:if>
                                                             
                                                            <button type="button" class="btn-reserve-time">${time}</button>
                                                             <c:set var="lastCategory" value="${currentCategory}" />
                                                         </c:forEach>
                                                    </div>
                                                 </div>
                                                <a href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}" class="btn-primary w-full mt-4 !py-3">예약하기</a>
                                             </div>
                                        </c:when>
                                        <c:otherwise>
                                             <p class="text-center py-8 text-gray-500">오늘은 예약 가능한 시간이 없습니다.</p>
                                        </c:otherwise>
                                     </c:choose>
                                </div>
                            </div>
                        </div>
                     </c:when>
                    <c:otherwise>
                        <div class="custom-card text-center">
                            <p class="py-12 text-gray-600 text-xl">맛집 정보를 찾을 수 없습니다.</p>
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

        document.querySelectorAll('.btn-reserve-time').forEach(button => {
            button.addEventListener('click', () => {
                document.querySelectorAll('.btn-reserve-time').forEach(btn => btn.classList.remove('selected'));
                button.classList.add('selected');
            });
        });
     </script>
</body>
</html>