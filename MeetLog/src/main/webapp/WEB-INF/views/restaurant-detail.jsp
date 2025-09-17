<%@ page import="util.ApiKeyLoader" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= kakaoApiKey %>&autoload=false..."></script>
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
                                <section class="bg-white p-6 rounded-2xl shadow-lg">
                                     <c:choose>
                                         <c:when test="${not empty restaurant.image and fn:startsWith(restaurant.image, 'http')}">
                                             <c:set var="imageUrl" value="${restaurant.image}" />
                                         </c:when>
                                         <c:when test="${not empty restaurant.image}">
                                             <c:set var="imageUrl" value="${pageContext.request.contextPath}/${restaurant.image}" />
                                         </c:when>
                                         <c:otherwise>
                                             <c:set var="imageUrl" value="https://placehold.co/800x400/94a3b8/ffffff?text=No+Image" />
                                         </c:otherwise>
                                     </c:choose>
                                     <img src="${imageUrl}" alt="${restaurant.name}" class="w-full h-64 object-cover rounded-lg">
                                </section>

                                <section class="bg-white p-6 rounded-2xl shadow-lg">
                                    <div class="flex items-start justify-between mb-4">
                                        <div>
                                            <h1 class="text-3xl font-bold text-slate-800">${restaurant.name}</h1>
                                            <p class="text-slate-600 mt-2">${restaurant.category} • ${restaurant.location}</p>
                                        </div>
                                        <div class="text-right flex-shrink-0 ml-4">
                                            <div class="text-2xl font-bold text-sky-600">${restaurant.rating}점</div>
                                            <div class="text-sm text-slate-500">${restaurant.reviewCount}개 리뷰</div>
                                        </div>
                                    </div>
                                    
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-6">
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
                                        <div class="mt-6 border-t pt-4">
                                            <h3 class="font-semibold text-slate-700 mb-2">설명</h3>
                                            <p class="text-slate-600">${restaurant.description}</p>
                                        </div>
                                    </c:if>
                                </section>
                                
                                <section class="bg-white p-6 rounded-2xl shadow-lg">
                                    <div class="flex justify-between items-center mb-6">
                                        <h2 class="text-2xl font-bold">리뷰</h2>
                                        <a href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}" class="bg-sky-600 text-white font-bold py-2 px-4 rounded-lg hover:bg-sky-700 text-sm">리뷰 작성</a>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="border-b border-slate-200 pb-4 mb-4 last:border-b-0">
                                                    <div class="flex items-center mb-3">
                                                         <c:choose>
                                                             <c:when test="${not empty review.authorImage and fn:startsWith(review.authorImage, 'http')}">
                                                                 <c:set var="authorImageUrl" value="${review.authorImage}" />
                                                             </c:when>
                                                             <c:when test="${not empty review.authorImage}">
                                                                 <c:set var="authorImageUrl" value="${pageContext.request.contextPath}/${review.authorImage}" />
                                                             </c:when>
                                                             <c:otherwise>
                                                                 <c:set var="authorImageUrl" value="https://placehold.co/100x100/94a3b8/ffffff?text=U" />
                                                             </c:otherwise>
                                                         </c:choose>
                                                        <img src="${authorImageUrl}" class="w-10 h-10 rounded-full mr-3">
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
                                                        <span class="text-sm text-slate-500">${review.createdAt.format(DateTimeFormatter.ofPattern('yyyy.MM.dd'))}</span>
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

                            <div class="space-y-6 lg:sticky lg:top-28">
                                <div class="bg-white p-6 rounded-2xl shadow-lg">
                                    <a href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}" class="w-full bg-sky-600 text-white font-bold py-3 px-4 rounded-lg hover:bg-sky-700 block text-center">
                                        예약하기
                                    </a>
                                </div>
                                <div class="bg-white p-6 rounded-2xl shadow-lg">
                                    <h3 class="font-semibold text-slate-700 mb-4">위치</h3>
                                    <div id="map" class="w-full h-64 rounded-lg border"></div>
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
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        <c:if test="${not empty restaurant}">
            <c:set var="lat" value="${not empty restaurant.latitude and restaurant.latitude ne 0 ? restaurant.latitude : 37.566826}" />
            <c:set var="lng" value="${not empty restaurant.longitude and restaurant.longitude ne 0 ? restaurant.longitude : 126.9786567}" />

            // [수정] DOMContentLoaded를 제거하고 kakao.maps.load 콜백만 사용합니다.
            // 이렇게 하면 카카오맵 SDK 로딩이 끝난 직후 지도 생성 코드가 안전하게 실행됩니다.
            kakao.maps.load(() => {
                const lat = ${lat};
                const lng = ${lng};

                const mapContainer = document.getElementById('map');
                if (mapContainer) { 
                    const mapOption = { 
                        center: new kakao.maps.LatLng(lat, lng),
                        level: 3
                    };
                    const map = new kakao.maps.Map(mapContainer, mapOption); 
                    const markerPosition  = new kakao.maps.LatLng(lat, lng); 
                    const marker = new kakao.maps.Marker({
                        position: markerPosition
                    });
                    marker.setMap(map);
                }
            });
        </c:if>
    </script>
</body>
</html>