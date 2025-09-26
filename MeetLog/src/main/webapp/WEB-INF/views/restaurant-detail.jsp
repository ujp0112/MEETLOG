<%@ page
	import="util.ApiKeyLoader, model.OperatingHour, java.time.LocalTime, java.time.LocalDate, java.time.format.DateTimeFormatter, java.util.ArrayList, java.util.List, java.util.Collections"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<%@ page isELIgnored="false"%>
<%
ApiKeyLoader.load(application);
String kakaoApiKey = ApiKeyLoader.getApiKey("kakao.api.key");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - <c:out value="${restaurant.name}"
		default="맛집 상세" /></title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=kakaoApiKey%>&libraries=services&autoload=false"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
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
	background: linear-gradient(135deg, var(--primary) 0%, var(--secondary)
		100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.btn-primary {
	background: linear-gradient(135deg, var(--primary) 0%,
		var(--primary-dark) 100%);
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4);
}

.gallery {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 8px;
	height: 400px;
}

.gallery.gallery-full {
	grid-template-columns: 1fr;
}

.gallery.gallery-full .gallery-main {
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
	border-radius: 12px;
}

.gallery-background {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	object-fit: cover;
	image-rendering: pixelated;
	transform: scale(5);
	opacity: 0.5;
	z-index: 1;
	border-radius: 12px;
}

@keyframes fadeIn {from { opacity:0;
	transform: translateY(20px);
.gallery-main .gallery-image {
	position: relative;
	z-index: 2;
	max-height: 100%;
}
/* 리뷰 캐러셀 스타일 */
.review-carousel-container {
	position: relative;
	width: 100%;
	overflow: hidden; /* 중요: 옆으로 삐져나온 카드들을 숨김 */
}

#reviewCarouselTrack {
	display: flex;
	transition: transform 0.5s ease-in-out;
	padding-bottom: 20px; /* 스크롤바 공간 확보 */
	overflow-x: auto; /* 가로 스크롤바 생성 */
	scroll-snap-type: x mandatory; /* 스크롤 시 카드에 딱 맞게 멈춤 */
	-ms-overflow-style: none; /* IE, Edge 스크롤바 숨김 */
	scrollbar-width: thin; /* Firefox 스크롤바 스타일 */
}

#reviewCarouselTrack::-webkit-scrollbar {
	height: 8px;
}

#reviewCarouselTrack::-webkit-scrollbar-track {
	background: #f1f1f1;
	border-radius: 10px;
}

#reviewCarouselTrack::-webkit-scrollbar-thumb {
	background: #888;
	border-radius: 10px;
}

#reviewCarouselTrack::-webkit-scrollbar-thumb:hover {
	background: #555;
}

.review-carousel-viewport {
	overflow: hidden;
}

@keyframes slideUp {from { opacity:0;
	transform: translateY(30px);
.review-carousel-track {
	display: flex;
	transition: transform 0.5s ease-in-out;
}

.review-card-wrapper {
	flex: 0 0 90%; /* 한 번에 카드 1개가 보이도록 너비 조정 (90%로 설정해 다음 카드 살짝 보이게 함) */
	scroll-snap-align: start; /* 스크롤 시 카드가 시작점에 맞춰 정렬됨 */
	margin-right: 20px;
	box-sizing: border-box;
}

.carousel-arrow {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	background-color: rgba(255, 255, 255, 0.9);
	border-radius: 50%;
	width: 48px;
	height: 48px;
	z-index: 10;
	cursor: pointer;
	border: 1px solid #e2e8f0;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.5rem;
	color: #334155;
}

@keyframes pulseGlow { 0%, 100% {
	box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
.carousel-arrow:disabled {
	opacity: 0.3;
	cursor: not-allowed;
}

50%
{
box-shadow
:
0
0
30px
rgba(
59
,
130
,
246
,
0.5
);
.carousel-arrow.prev {
	left: -24px;
}

@keyframes shimmer { 0% {
	background-position: -200% 0;
.carousel-arrow.next {
	right: -24px;
}

100%
{
background-position
:
200%
0;
.review-photo-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 4px;
	height: 200px;
	border-radius: 12px;
	overflow: hidden;
}

.review-photo-item {
	position: relative;
	cursor: pointer;
}

.review-photo-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
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

@keyframes couponGlow { 0%, 100% {
	box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);
}

50%
{
box-shadow
:
0
0
30px
rgba(
245
,
158
,
11
,
0.5
);
}
}
.review-card {
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%,
		rgba(248, 250, 252, 0.9) 100%);
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
	background: linear-gradient(135deg, var(--primary) 0%,
		var(--secondary) 100%);
.review-photo-more {
	position: absolute;
	inset: 0;
	background-color: rgba(0, 0, 0, 0.5);
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.5rem;
	font-weight: bold;
}

.review-keyword-tag {
	background-color: #f1f5f9;
	color: #475569;
	padding: 4px 12px;
	border-radius: 9999px;
	font-size: 0.8rem;
}

@media ( min-width : 1024px) {
	.review-card-wrapper {
		flex-basis: calc(50% - 10px); /* 넓은 화면에서는 2개씩 보이도록 조정 */
	}
}

@media ( max-width : 768px) {
	.review-card-wrapper {
		width: 100%;
	}
	.carousel-arrow.prev {
		left: 0;
	}
	.carousel-arrow.next {
		right: 0;
	}
}
/* 리뷰 사진 모달 스타일 */
.review-photo-modal {
	position: fixed;
	inset: 0;
	background-color: rgba(0, 0, 0, 0.7);
	display: none;
	align-items: center;
	justify-content: center;
	z-index: 1000;
	animation: fadeIn 0.3s;
}

@keyframes float { 0%, 100% {
	transform: translateY(0px);
.review-photo-modal.show {
	display: flex;
}

50%
{
transform
:
translateY(
-10px
);
.review-photo-modal-content {
	position: relative;
	background-color: white;
	padding: 16px;
	border-radius: 16px;
	max-width: 80vw;
	max-height: 80vh;
	display: flex;
	flex-direction: column;
	animation: slideUp 0.4s;
}

.review-photo-modal-main-image {
	max-width: 100%;
	max-height: 70vh;
	object-fit: contain;
}

.review-photo-modal-thumbnails {
	display: flex;
	gap: 8px;
	margin-top: 16px;
	overflow-x: auto;
	padding-bottom: 8px;
}

.review-photo-modal-thumbnail {
	width: 80px;
	height: 60px;
	object-fit: cover;
	border-radius: 8px;
	cursor: pointer;
	border: 2px solid transparent;
	transition: border-color 0.2s;
}

.review-photo-modal-thumbnail.active {
	border-color: var(--primary);
}

.review-photo-modal-close {
	position: absolute;
	top: -16px;
	right: -16px;
	background-color: white;
	border-radius: 50%;
	width: 32px;
	height: 32px;
	border: none;
	cursor: pointer;
	font-size: 1.5rem;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}
/* 예약 시간 버튼 CSS */
.btn-reserve-time {
	background-color: #f0f7ff;
	color: #2575fc;
	border: 1px solid #cce1ff;
	padding: 8px 16px;
	border-radius: 8px;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
}

.btn-reserve-time:hover {
	background-color: #e0f2fe;
	transform: scale(1.02);
}

.btn-reserve-time.selected {
	background-color: #2575fc;
	color: white;
	border-color: #2575fc;
	transform: scale(1.05);
	box-shadow: 0 4px 12px rgba(37, 117, 252, 0.4);
}
/* 더보기 기능 CSS */
.review-text.truncated {
	overflow: hidden;
	display: -webkit-box;
	-webkit-line-clamp: 3; /* 3줄 후 생략 */
	-webkit-box-orient: vertical;
}

.read-more-btn {
	color: #94a3b8; /* 글자색을 더 연하게 변경 */
	font-weight: 500; /* 폰트 두께를 중간으로 변경 */
	font-size: 0.875rem; /* 폰트 크기 축소 */
	cursor: pointer;
	transition: color 0.2s; /* 색상 변경 애니메이션 효과 */
}

.read-more-btn:hover {
	color: #334155; /* 마우스 올렸을 때 색상을 진하게 변경 */
}
/* 리뷰 카드 내 이미지 캐러셀 스타일 */
.review-image-carousel {
    display: flex; /* 내부 트랙을 flex로 정렬 */
    position: relative;
    width: 100%;
    overflow-x: auto; /* [핵심] 숨김(hidden) 대신 가로 스크롤(auto) 적용 */
    scroll-snap-type: x mandatory; /* 스크롤 시 이미지 경계에 딱 맞게 멈춤 */
    scroll-behavior: smooth; /* JS로 스크롤 시 부드럽게 이동 */
    padding-bottom: 15px; /* 스크롤바 공간 확보 */
    -ms-overflow-style: none; /* IE, Edge 스크롤바 숨김 */
    scrollbar-width: thin; /* Firefox 스크롤바 스타일 */
}

.review-image-carousel::-webkit-scrollbar {
    height: 8px;
}
.review-image-carousel::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 10px;
}
.review-image-carousel::-webkit-scrollbar-thumb {
    background: #888;
    border-radius: 10px;
}
.review-image-carousel::-webkit-scrollbar-thumb:hover {
    background: #555;
}

.review-image-track {
	display: flex;
}

.review-image-item {
    flex: 0 0 90%; /* [핵심] 너비를 90%로 하여 다음 이미지가 살짝 보이게 함 */
    scroll-snap-align: start; /* 스크롤 시 이 아이템의 시작점에 맞춰 정렬 */
    height: 200px;
    padding-right: 10px;
    box-sizing: border-box;
}

.review-image-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border-radius: 8px;
}

.review-image-arrow {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	background-color: rgba(0, 0, 0, 0.4);
	color: white;
	border: none;
	border-radius: 50%;
	width: 32px;
	height: 32px;
	font-size: 1.2rem;
	cursor: pointer;
	z-index: 10;
	opacity: 0; /* 평소에는 숨김 */
	transition: opacity 0.2s, background-color 0.2s;
	display: flex;
	align-items: center;
	justify-content: center;
}

.review-image-carousel:hover .review-image-arrow {
	opacity: 1; /* 마우스를 올렸을 때 버튼 표시 */
}

.review-image-arrow:hover {
	background-color: rgba(0, 0, 0, 0.7);
}

.review-image-arrow.prev {
	left: 8px;
}

.review-image-arrow.next {
	right: 8px;
}

.review-image-arrow:disabled {
	opacity: 0.2;
	cursor: not-allowed;
}
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
								<section class="glass-card p-8 rounded-3xl fade-in">
									<div
										class="gallery ${empty restaurant.additionalImages ? 'gallery-full' : ''}"
										id="restaurantGallery">
										<div class="gallery-main">
											<c:if test="${empty restaurant.additionalImages}">
												<mytag:image fileName="${restaurant.image}" altText=""
													cssClass="gallery-background" />
											</c:if>
											<mytag:image fileName="${restaurant.image}"
												altText="${restaurant.name}" cssClass="gallery-image" />
										</div>
										<c:if test="${not empty restaurant.additionalImages}">
											<div class="gallery-side">
												<c:choose>
													<c:when
														test="${fn:length(restaurant.additionalImages) >= 1}">
														<div class="img-wrap">
															<mytag:image fileName="${restaurant.additionalImages[0]}"
																altText="${restaurant.name}" cssClass="gallery-image" />
														</div>
													</c:when>
													<c:otherwise>
														<div class="img-wrap"
															style="background: transparent; border-radius: 12px;"></div>
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when
														test="${fn:length(restaurant.additionalImages) >= 2}">
														<div class="img-wrap">
															<mytag:image fileName="${restaurant.additionalImages[1]}"
																altText="${restaurant.name}" cssClass="gallery-image" />
															<c:if
																test="${fn:length(restaurant.additionalImages) + 1 > 3}">
																<div class="more-overlay" onclick="cycleImages()">+${fn:length(restaurant.additionalImages) - 1}</div>
															</c:if>
														</div>
													</c:when>
													<c:otherwise>
														<div class="img-wrap"
															style="background: transparent; border-radius: 12px;"></div>
													</c:otherwise>
												</c:choose>
											</div>
										</c:if>
									</div>
								</section>

								<section class="glass-card p-8 rounded-3xl slide-up">
									<div class="flex items-start justify-between mb-6">
										<div class="flex-1">
											<h1 class="text-4xl font-bold gradient-text mb-3">${restaurant.name}</h1>
											<div class="flex items-center space-x-3 mb-4">
												<span class="info-badge">${restaurant.category}</span> <span
													class="location-badge">📍 ${restaurant.location}</span>
											</div>
										</div>
										<div class="text-right">
											<div class="text-5xl font-black rating-badge mb-2">
												<fmt:formatNumber value="${restaurant.rating}"
													maxFractionDigits="1" />
											</div>
											<div class="flex items-center justify-center mb-2">
												<div class="rating-stars flex space-x-1">
													<c:forEach begin="1" end="5" var="star">
														<c:choose>
															<c:when test="${restaurant.rating >= star}">
																<span class="text-yellow-400 text-2xl">★</span>
															</c:when>
															<c:otherwise>
																<span class="text-slate-300 text-2xl">☆</span>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</div>
											</div>
											<div class="text-sm text-slate-500">${restaurant.reviewCount}개
												리뷰</div>
										</div>
									</div>
									<div class="flex space-x-4">
										<button
											class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold pulse-glow">❤️
											찜하기</button>
										<button
											class="btn-secondary text-white px-6 py-3 rounded-2xl font-semibold">📤
											공유하기</button>
									</div>
								</section>

								<section class="glass-card p-8 rounded-3xl slide-up">
									<h3 class="text-2xl font-bold gradient-text mb-6">상세 정보</h3>
									<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
										<div
											class="flex items-start space-x-4 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl card-hover">
											<div class="text-2xl">🏠</div>
											<div>
												<span class="font-bold text-slate-700">주소</span>
												<p class="text-slate-600 mt-1">${restaurant.address}</p>
											</div>
										</div>
										<div
											class="flex items-start space-x-4 p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl card-hover">
											<div class="text-2xl">📞</div>
											<div>
												<span class="font-bold text-slate-700">전화번호</span>
												<p class="text-slate-600 mt-1">${not empty restaurant.phone ? restaurant.phone : "정보 없음"}</p>
											</div>
										</div>
										<div
											class="flex items-start space-x-4 p-4 bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl card-hover">
											<div class="text-2xl">🕒</div>
											<div class="flex-1">
												<span class="font-bold text-slate-700">영업시간</span>
												<c:choose>
													<c:when test="${not empty operatingHours}">
														<div class="mt-2 space-y-1">
															<c:forEach var="hour" items="${operatingHours}">
																<div class="flex justify-between text-sm">
																	<span class="text-slate-600"><c:choose>
																			<c:when test="${hour.dayOfWeek == 1}">월요일</c:when>
																			<c:when test="${hour.dayOfWeek == 2}">화요일</c:when>
																			<c:when test="${hour.dayOfWeek == 3}">수요일</c:when>
																			<c:when test="${hour.dayOfWeek == 4}">목요일</c:when>
																			<c:when test="${hour.dayOfWeek == 5}">금요일</c:when>
																			<c:when test="${hour.dayOfWeek == 6}">토요일</c:when>
																			<c:when test="${hour.dayOfWeek == 7}">일요일</c:when>
																		</c:choose></span><span class="text-slate-600"><c:choose>
																			<c:when test="${empty hour.openingTime}">
																				<span class="text-red-500">휴무</span>
																			</c:when>
																			<c:otherwise>${hour.openingTime} - ${hour.closingTime}</c:otherwise>
																		</c:choose></span>
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
										<div
											class="flex items-start space-x-4 p-4 bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl card-hover">
											<div class="text-2xl">🚗</div>
											<div>
												<span class="font-bold text-slate-700">주차</span>
												<p class="text-slate-600 mt-1">${restaurant.parking ? "가능" : "불가"}</p>
											</div>
										</div>
									</div>
									<c:if test="${not empty restaurant.description}">
										<div
											class="mt-6 p-4 bg-gradient-to-r from-slate-50 to-gray-50 rounded-2xl">
											<h3 class="font-bold text-slate-700 mb-2">📝 설명</h3>
											<p class="text-slate-600 leading-relaxed">${restaurant.description}</p>
										</div>
									</c:if>
								</section>

								<c:if test="${not empty menus}">
									<section class="glass-card p-8 rounded-3xl slide-up">
										<h2 class="text-2xl font-bold gradient-text mb-6">메뉴</h2>
										<div class="space-y-4">
											<c:forEach var="menu" items="${menus}">
												<div
													class="menu-item flex justify-between items-center p-6 border-gradient rounded-2xl bg-white/50 backdrop-blur-sm">
													<div class="flex-1">
														<div class="flex items-center space-x-3">
															<h3 class="font-bold text-slate-800 text-lg">${menu.name}</h3>
															<c:if test="${menu.popular}">
																<span
																	class="text-xs bg-gradient-to-r from-red-500 to-pink-500 text-white px-3 py-1 rounded-full font-semibold">🔥
																	인기</span>
															</c:if>
														</div>
														<c:if test="${not empty menu.description}">
															<p class="text-sm text-slate-600 mt-1">${menu.description}</p>
														</c:if>
													</div>
													<div class="text-right">
														<span class="text-2xl font-bold text-sky-600"><c:choose>
																<c:when test="${fn:contains(menu.price, '원')}">${menu.price}</c:when>
																<c:otherwise>
																	<fmt:formatNumber value="${menu.price}" type="currency"
																		currencySymbol="₩" />
																</c:otherwise>
															</c:choose></span>
													</div>
												</div>
											</c:forEach>
										</div>
									</section>
								</c:if>

								<section class="glass-card p-8 rounded-3xl slide-up">
									<div class="flex justify-between items-center mb-6">
										<h2 class="text-2xl font-bold gradient-text">리뷰
											(${fn:length(reviews)})</h2>
										<a
											href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}"
											class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
											리뷰 작성 </a>
									</div>
									<c:choose>
										<c:when test="${not empty reviews}">
											<div class="review-carousel-container">
												<div class="review-carousel-viewport">
													<div id="reviewCarouselTrack"
														class="review-carousel-track -mx-2">
														<c:forEach var="review" items="${reviews}">
															<div class="review-card-wrapper">
																<div
																	class="bg-white p-6 rounded-2xl shadow-lg h-full flex flex-col">
																	<div class="flex justify-between items-start mb-4">
																		<div class="flex items-start">
																			<mytag:image fileName="${review.profileImage}"
																				altText="${review.author}"
																				cssClass="w-12 h-12 rounded-full object-cover mr-4" />
																			<div>
																				<span class="font-bold text-slate-800">${review.author}</span>
																				<div
																					class="flex items-center text-sm text-slate-500 mt-1">
																					<div class="flex">
																						<c:forEach begin="1" end="5" var="i">
																							<span
																								class="${i <= review.rating ? 'text-yellow-400' : 'text-slate-300'}">★</span>
																						</c:forEach>
																					</div>
																					<span class="mx-2">·</span> <span>${review.createdAt.format(DateTimeFormatter.ofPattern('yy.MM.dd'))}</span>
																				</div>
																			</div>
																		</div>
																		<button
																			class="text-sm text-sky-600 font-semibold border border-sky-600 rounded-full px-4 py-1 hover:bg-sky-50 transition whitespace-nowrap flex-shrink-0">팔로우</button>
																	</div>
																	<c:if
																		test="${not empty review.images and not empty review.images[0]}">
																		<%--
        [수정] fn:join 함수가 ArrayList<String>을 처리하지 못하는 문제를 해결하기 위해
        c:forEach를 사용해 직접 쉼표로 구분된 문자열(imageListAsString)을 만듭니다.
    --%>
																		<c:set var="imageListAsString" value="" />
																		<c:forEach var="imgName" items="${review.images}"
																			varStatus="loop">
																			<c:set var="imageListAsString"
																				value="${imageListAsString}${imgName}${!loop.last ? ',' : ''}" />
																		</c:forEach>

																		<div class="review-image-carousel">
																			<div class="review-image-track">
																				<%-- [핵심 수정] c:forEach를 사용해 review.images에 있는 모든 이미지를 반복 출력 --%>
																				<c:forEach var="imagePath" items="${review.images}"
																					varStatus="loop">
																					<div class="review-image-item"
																						onclick="openReviewPhotoModal(this)"
																						data-images="<c:forEach var='img' items='${review.images}' varStatus='status'>${img}<c:if test='${!status.last}'>,</c:if></c:forEach>"
																						data-index="${loop.index}">

																						<img
																							src="${pageContext.request.contextPath}/images/${imagePath}"
																							alt="리뷰 사진 ${loop.count}" class="review-image">
																					</div>
																				</c:forEach>
																			</div>
																			<button class="review-image-arrow prev">&lt;</button>
																			<button class="review-image-arrow next">&gt;</button>
																		</div>
																	</c:if>
																	<div class="review-content-wrapper mb-4 flex-grow">
																		<p
																			class="review-text text-slate-700 leading-relaxed truncated">${review.content}</p>
																		<span
																			class="read-more-btn mt-2 inline-block cursor-pointer">더
																			보기</span>
																	</div>
																	<c:if test="${not empty review.keywords}">
																		<div class="flex flex-wrap gap-2 mb-4">
																			<c:forEach var="keyword" items="${review.keywords}">
																				<span class="review-keyword-tag">${keyword}</span>
																			</c:forEach>
																		</div>
																	</c:if>
																	<div class="border-t pt-3 text-sm text-slate-500">
																		<span>${review.likes > 0 ? review.likes : 0}명이
																			좋아합니다</span>
																	</div>
																</div>
															</div>
														</c:forEach>
													</div>
												</div>
												<c:if test="${fn:length(reviews) > 3}">
													<button id="prevReviewBtn" class="carousel-arrow prev">‹</button>
													<button id="nextReviewBtn" class="carousel-arrow next">›</button>
												</c:if>
											</div>
										</c:when>
										<c:otherwise>
											<div class="text-center py-12">
												<div class="text-6xl mb-4">📝</div>
												<h4 class="text-xl font-bold text-slate-600 mb-2">아직
													리뷰가 없습니다</h4>
												<p class="text-slate-500">첫 번째 리뷰를 작성해보세요!</p>
											</div>
										</c:otherwise>
									</c:choose>
								</section>
								<c:if test="${not empty coupons}">
									<section class="glass-card p-8 rounded-3xl slide-up">
										<h2 class="text-2xl font-bold gradient-text mb-6">MEET
											LOG 단독 쿠폰</h2>
										<div class="space-y-4">
											<c:forEach var="coupon" items="${coupons}">
												<div
													class="coupon-glow p-6 rounded-3xl relative overflow-hidden">
													<div
														class="absolute top-0 right-0 w-20 h-20 bg-yellow-400 rounded-full -translate-y-10 translate-x-10 opacity-20"></div>
													<div
														class="absolute bottom-0 left-0 w-16 h-16 bg-orange-400 rounded-full translate-y-8 -translate-x-8 opacity-20"></div>
													<div class="relative z-10">
														<div class="flex items-center justify-between">
															<div class="flex-1">
																<h3 class="text-2xl font-black text-yellow-800 mb-2">${coupon.title}</h3>
																<p class="text-yellow-700 font-semibold mb-2">${coupon.description}</p>
																<p class="text-xs text-yellow-600">유효기간:
																	${coupon.validity}</p>
															</div>
															<div class="text-right">
																<div class="text-4xl font-black text-yellow-800 mb-4">🎫</div>
																<button
																	class="bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-6 py-3 rounded-2xl font-bold hover:from-yellow-600 hover:to-orange-600 transform hover:scale-105 transition-all duration-300 shadow-xl">🎁
																	쿠폰받기</button>
															</div>
														</div>
													</div>
												</div>
											</c:forEach>
										</div>
									</section>

									<c:if test="${not empty coupons}">
										<section class="glass-card p-8 rounded-3xl slide-up">...</section>
									</c:if>
									<section class="glass-card p-8 rounded-3xl slide-up">...</section>
								</c:if>

								<section class="glass-card p-8 rounded-3xl slide-up">
									<div class="flex justify-between items-center mb-6">
										<h2 class="text-2xl font-bold gradient-text">❓ Q&A</h2>
										<button onclick="toggleQnAForm()"
											class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">💬
											문의하기</button>
									</div>
									<div id="qnaForm" class="hidden mb-8">
										<div
											class="bg-gradient-to-r from-blue-50 to-purple-50 p-6 rounded-2xl border border-blue-200">
											<h3 class="text-lg font-bold text-slate-800 mb-4">궁금한 점을
												문의해주세요</h3>
											<form method="post"
												action="${pageContext.request.contextPath}/restaurant/qna/register"
												class="space-y-4">
												<input type="hidden" name="restaurantId"
													value="${restaurant.id}">
												<div>
													<label
														class="block text-sm font-semibold text-slate-700 mb-2">문의
														내용</label>
													<textarea name="question" rows="4"
														placeholder="음식점에 대해 궁금한 점을 자유롭게 문의해주세요..."
														class="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
														required></textarea>
												</div>
												<div class="flex space-x-3">
													<button type="submit"
														class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">문의
														등록</button>
													<button type="button" onclick="toggleQnAForm()"
														class="px-6 py-3 border border-slate-300 text-slate-700 rounded-xl font-semibold hover:bg-slate-50">취소</button>
												</div>
											</form>
										</div>
									</div>
									<c:choose>
										<c:when test="${not empty qnas}">
											<div class="space-y-6">
												<c:forEach var="qna" items="${qnas}">
													<div
														class="border-gradient rounded-2xl p-6 bg-white/50 backdrop-blur-sm card-hover">
														<div class="mb-4">
															<div class="flex items-center mb-3">
																<span
																	class="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-3 py-1 rounded-full text-sm font-semibold">Q</span><span
																	class="ml-3 text-sm text-slate-500 font-medium">고객</span>
																<span
																	class="ml-2 px-2 py-1 bg-slate-100 text-slate-600 text-xs rounded-full"><c:choose>
																		<c:when test="${empty qna.answer}">답변 대기</c:when>
																		<c:otherwise>답변 완료</c:otherwise>
																	</c:choose></span>
															</div>
															<p class="text-slate-800 font-medium">${qna.question}</p>
														</div>
														<c:if test="${not empty qna.answer}">
															<div class="border-t border-slate-200 pt-4">
																<div class="flex items-center mb-3">
																	<span
																		class="bg-gradient-to-r from-green-500 to-emerald-500 text-white px-3 py-1 rounded-full text-sm font-semibold">A</span>
																	<span class="ml-3 text-sm text-slate-500 font-medium"><c:choose>
																			<c:when test="${qna.owner}">사장님</c:when>
																			<c:otherwise>관리자</c:otherwise>
																		</c:choose></span>
																</div>
																<p class="text-slate-800">${qna.answer}</p>
															</div>
														</c:if>
													</div>
												</c:forEach>
											</div>
										</c:when>
										<c:otherwise>
											<div class="text-center py-12">
												<div class="text-6xl mb-4">❓</div>
												<h4 class="text-xl font-bold text-slate-600 mb-2">등록된
													Q&A가 없습니다</h4>
												<p class="text-slate-500">궁금한 점이 있으시면 언제든 문의해주세요!</p>
											</div>
										</c:otherwise>
									</c:choose>
								</section>
							</div>

							<div class="space-y-8">
							<form id="reservationForm" action="${pageContext.request.contextPath}/reservation/create" method="GET">
							
								<section class="glass-card p-8 rounded-3xl slide-up">
									<div id="map" class="w-full h-64 rounded-2xl border"></div>
								</section>
								<input type="hidden" name="restaurantId" value="${restaurant.id}">
								<input type="hidden" id="selectedTime" name="reservationTime" value="">
    							

								<section class="glass-card p-8 rounded-3xl slide-up" style="margin-top:32px">
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
									pageContext.setAttribute("lunchStart", LocalTime.of(12, 0));
									pageContext.setAttribute("dinnerStart", LocalTime.of(17, 0));
									%>
									<div class="space-y-6">
										<div>
											<label class="block text-sm font-bold mb-3 text-slate-700">📅
												날짜</label><input type="date" name="reservationDate"
												value="<%=LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE)%>"
												class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
										</div>
										<div>
											<label class="block text-sm font-bold mb-3 text-slate-700">👥
												인원</label><select name="partySize"
												class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300"><option value="1">1명</option>
												<option value="2" selected>2명</option>
												<option value="3">3명</option>
												<option value="4">4명</option>
												<option value="5">5명</option>
												<option value="6">6명 이상</option></select>
										</div>
										<div>
											<label class="block text-sm font-bold mb-3 text-slate-700">⏰
												예약가능시간</label>
											<c:choose>
												<c:when test="${not empty timeSlots}">
													<div class="grid grid-cols-3 gap-2">
														<c:set var="lastCategory" value="" />
														<c:forEach var="time" items="${timeSlots}">
															<c:set var="currentTime" value="${LocalTime.parse(time)}" />
															<c:set var="currentCategory" value="" />
															<c:if test="${currentTime.isBefore(lunchStart)}">
																<c:set var="currentCategory" value="오전" />
															</c:if>
															<c:if
																test="${not currentTime.isBefore(lunchStart) and currentTime.isBefore(dinnerStart)}">
																<c:set var="currentCategory" value="점심" />
															</c:if>
															<c:if test="${not currentTime.isBefore(dinnerStart)}">
																<c:set var="currentCategory" value="저녁" />
															</c:if>
															<c:if test="${empty lastCategory}">
																<c:set var="lastCategory" value="${currentCategory}" />
															</c:if>
															<c:if test="${lastCategory ne currentCategory}">
																<div class="col-span-3 flex items-center my-2">
																	<hr class="flex-grow border-t border-gray-200">
																	<span class="px-2 text-sm text-gray-500">${currentCategory}</span>
																	<hr class="flex-grow border-t border-gray-200">
																</div>
															</c:if>
															<button type="button" class="btn-reserve-time bg-slate-100 text-slate-700 border border-slate-200 py-2 px-4 rounded-lg font-medium hover:bg-slate-200 transition-all duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-400"
																onclick="selectTime(this, '${time}')">${time}</button>
															<c:set var="lastCategory" value="${currentCategory}" />
														</c:forEach>
													</div>
												</c:when>
												<c:otherwise>
													<div class="text-center p-4 bg-slate-100 rounded-xl">
														<p class="text-slate-500">오늘 예약 가능한 시간이 없습니다.</p>
													</div>
												</c:otherwise>
											</c:choose>
										</div>
										<button type="submit"
											class="w-full btn-primary text-white py-4 rounded-2xl font-bold block text-center pulse-glow">
											예약하기 </button>
									</div>
								</section>
								</form>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div class="glass-card p-12 rounded-3xl text-center fade-in">...</div>
					</c:otherwise>
				</c:choose>
			</div>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
		<c:if test="${not empty restaurant}">
			<a href="..." class="floating-action-btn">🎯 예약하기</a>
		</c:if>
	</div>

	<script>
    // =========================================================================
    // 헬퍼 함수 (DOM 로드 전에도 선언 가능)
    // =========================================================================

    // 예약 시간 선택 함수
    function selectTime(element, time) {
        $('.btn-reserve-time').removeClass('bg-blue-500 text-white border-blue-600')
                             .addClass('bg-slate-100 text-slate-700 border-slate-200');
        $(element).removeClass('bg-slate-100 text-slate-700 border-slate-200')
                  .addClass('bg-blue-500 text-white border-blue-600');
        $('#selectedTime').val(time);
    }

    // Q&A 폼 토글 함수
    function toggleQnAForm() {
        const form = document.getElementById('qnaForm');
        if (form) {
            form.classList.toggle('hidden');
            if (!form.classList.contains('hidden')) {
                form.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    }
    
    // --- 레스토랑 전체 이미지 갤러리 관련 함수 ---
    const allImageFiles = [ "${restaurant.image}", <c:forEach var="img" items="${restaurant.additionalImages}">'${fn:escapeXml(img)}',</c:forEach> ].filter(Boolean);
    const overlaySection = document.getElementById('imageOverlay'); 
    const overlayGrid = document.getElementById('overlayGrid'); 
    const closeOverlayBtn = document.getElementById('closeOverlayBtn'); 
    const imageZoomModal = document.getElementById('imageZoomModal'); 
    const zoomedImage = document.getElementById('zoomedImage'); 
    const closeZoomModalBtn = document.getElementById('closeZoomModalBtn');
    
    function cycleImages() { 
        if (overlaySection && overlaySection.classList.contains('show')) { 
            closeImageOverlay(); 
        } else { 
            showImageOverlay(); 
        } 
    }
    
    function showImageOverlay() { 
        if (!overlaySection || !overlayGrid) return; 
        overlayGrid.innerHTML = ''; 
        allImageFiles.forEach(fileName => { 
            const img = document.createElement('img'); 
            img.className = 'gallery-image'; 
            img.src = '${pageContext.request.contextPath}/images/' + encodeURIComponent(fileName); 
            img.addEventListener('click', () => openZoomModal(img.src)); 
            overlayGrid.appendChild(img); 
        }); 
        overlaySection.classList.add('show'); 
    }

    function closeImageOverlay() { 
        if (overlaySection) overlaySection.classList.remove('show'); 
    }
    
    function openZoomModal(imageSrc) { 
        if (!imageZoomModal || !zoomedImage) return; 
        zoomedImage.src = imageSrc; 
        imageZoomModal.classList.add('show'); 
    }
    
    function closeZoomModal() { 
        if (imageZoomModal) imageZoomModal.classList.remove('show'); 
    }
    
    // --- 리뷰 이미지 모달 관련 함수 ---
    const reviewModal = document.getElementById('reviewPhotoModal');
    const mainImage = document.getElementById('reviewModalMainImage');
    const thumbnailsContainer = document.getElementById('reviewModalThumbnails');

    window.openReviewPhotoModal = function(element) {
        const images = element.dataset.images.split(',').map(s => s.trim()).filter(Boolean);
        const startIndex = parseInt(element.dataset.index, 10);
        const imageUrlPrefix = '${pageContext.request.contextPath}/images/';
        
        mainImage.src = imageUrlPrefix + images[startIndex];
        thumbnailsContainer.innerHTML = '';
        
        images.forEach((img, index) => {
            const thumb = document.createElement('img');
            thumb.src = imageUrlPrefix + img;
            thumb.className = 'review-photo-modal-thumbnail';
            if (index === startIndex) thumb.classList.add('active');
            thumb.onclick = () => {
                mainImage.src = thumb.src;
                document.querySelectorAll('.review-photo-modal-thumbnail').forEach(t => t.classList.remove('active'));
                thumb.classList.add('active');
            };
            thumbnailsContainer.appendChild(thumb);
        });
        reviewModal.classList.add('show');
    }

    window.closeReviewPhotoModal = function() {
        reviewModal.classList.remove('show');
    }


    // =========================================================================
    // DOM이 모두 로드된 후 실행될 스크립트들을 하나로 통합
    // =========================================================================
    document.addEventListener('DOMContentLoaded', function() {
    
        // 1. 예약 폼 유효성 검사
        var reservationForm = document.getElementById('reservationForm');
        if (reservationForm) {
            reservationForm.addEventListener('submit', function(event) {
                var selectedTime = document.getElementById('selectedTime').value;
                if (!selectedTime) {
                    alert('예약 시간을 선택해주세요.');
                    event.preventDefault(); // 폼 제출 중단
                }
            });
        }
    
        // 2. 글래스 카드 등장 애니메이션
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

        document.querySelectorAll('.glass-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
            observer.observe(card);
        });

        // 3. Q&A 등록 성공 알림 처리
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'qna_added') {
            alert('문의가 성공적으로 등록되었습니다!');
            window.history.replaceState({}, document.title, window.location.pathname);
        }

        // 4. 리뷰 텍스트 "더 보기/접기" 기능 초기화
        document.querySelectorAll('.review-card-wrapper').forEach(card => {
            const textElement = card.querySelector('.review-text');
            const readMoreBtn = card.querySelector('.read-more-btn');
            if (textElement && readMoreBtn) {
                if (textElement.scrollHeight <= textElement.clientHeight) {
                    readMoreBtn.style.display = 'none';
                }
                readMoreBtn.addEventListener('click', () => {
                    textElement.classList.toggle('truncated');
                    readMoreBtn.textContent = textElement.classList.contains('truncated') ? '더 보기' : '접기';
                });
            }
        });

        // 5. 각 리뷰 카드 내 이미지 슬라이드(캐러셀) 기능 초기화
        document.querySelectorAll('.review-image-carousel').forEach(carousel => {
            const track = carousel.querySelector('.review-image-track');
            const prevBtn = carousel.querySelector('.review-image-arrow.prev');
            const nextBtn = carousel.querySelector('.review-image-arrow.next');
            const items = carousel.querySelectorAll('.review-image-item');
            
            if (!track || items.length <= 1) {
                if (prevBtn) prevBtn.style.display = 'none';
                if (nextBtn) nextBtn.style.display = 'none';
                return;
            }

            let currentIndex = 0;
            const totalItems = items.length;

            function updateCarousel() {
                const itemWidth = items[0].offsetWidth;
                track.style.transform = `translateX(-${currentIndex * itemWidth}px)`;
                if(prevBtn) prevBtn.disabled = currentIndex === 0;
                if(nextBtn) nextBtn.disabled = currentIndex === totalItems - 1;
            }

            if(prevBtn) {
                prevBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    if (currentIndex > 0) {
                        currentIndex--;
                        updateCarousel();
                    }
                });
            }
            if(nextBtn) {
                nextBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    if (currentIndex < totalItems - 1) {
                        currentIndex++;
                        updateCarousel();
                    }
                });
            }
            updateCarousel();
        });

        // 6. 리뷰 섹션 전체를 좌우로 넘기는 캐러셀 기능
        const reviewTrack = document.getElementById('reviewCarouselTrack');
        if (reviewTrack) {
            const prevBtn = document.getElementById('prevReviewBtn');
            const nextBtn = document.getElementById('nextReviewBtn');
            const reviews = reviewTrack.querySelectorAll('.review-card-wrapper');
            
            if (reviews.length > 0) {
                let currentIndex = 0;
                const updateReviewCarousel = () => {
                    const cardWidth = reviews[0].offsetWidth;
                    const cardMargin = parseInt(window.getComputedStyle(reviews[0]).marginRight);
                    const totalMove = cardWidth + cardMargin;
                    
                    let reviewsPerPage = Math.floor(reviewTrack.parentElement.offsetWidth / totalMove);
                    if (window.innerWidth <= 768) { reviewsPerPage = 1; }
                    else if (window.innerWidth <= 1024) { reviewsPerPage = 2; }
                    else { reviewsPerPage = 3; }
					
                    reviewTrack.style.transform = `translateX(-${currentIndex * totalMove}px)`;

                    if (prevBtn) prevBtn.disabled = currentIndex === 0;
                    if (nextBtn) nextBtn.disabled = currentIndex >= reviews.length - reviewsPerPage;
                };

                if (nextBtn) {
                    nextBtn.addEventListener('click', () => {
                        let reviewsPerPage = 3; // 이 값을 동적으로 계산해야 합니다.
                        if (window.innerWidth <= 768) { reviewsPerPage = 1; }
                        else if (window.innerWidth <= 1024) { reviewsPerPage = 2; }
                        if (currentIndex < reviews.length - reviewsPerPage) {
                            currentIndex++;
                            updateReviewCarousel();
                        }
                    });
                }

                if (prevBtn) {
                    prevBtn.addEventListener('click', () => {
                        if (currentIndex > 0) {
                            currentIndex--;
                            updateReviewCarousel();
                        }
                    });
                }

                window.addEventListener('resize', updateReviewCarousel);
                updateReviewCarousel();
            }
        }
        
        // 7. 모달창 닫기 등 전역 이벤트 리스너 바인딩
        if (closeOverlayBtn) closeOverlayBtn.addEventListener('click', closeImageOverlay);
        if (closeZoomModalBtn) closeZoomModalBtn.addEventListener('click', closeZoomModal);
        if (imageZoomModal) imageZoomModal.addEventListener('click', (e) => {
            if (e.target === imageZoomModal) closeZoomModal();
        });
        
        
    });
</script>
</body>
</html>