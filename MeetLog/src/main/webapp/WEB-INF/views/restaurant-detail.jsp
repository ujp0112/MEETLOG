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
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=kakaoApiKey%>&libraries=services&autoload=false"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
<style>
:root { -
	-primary: #3b82f6; -
	-primary-dark: #2563eb; -
	-secondary: #8b5cf6; -
	-accent: #f59e0b; -
	-success: #10b981; -
	-warning: #f59e0b; -
	-error: #ef4444; -
	-gray-50: #f8fafc; -
	-gray-100: #f1f5f9; -
	-gray-200: #e2e8f0; -
	-gray-300: #cbd5e1; -
	-gray-400: #94a3b8; -
	-gray-500: #64748b; -
	-gray-600: #475569; -
	-gray-700: #334155; -
	-gray-800: #1e293b; -
	-gray-900: #0f172a;
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
	background: linear-gradient(135deg, var(- -primary) 0%,
		var(- -secondary) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.btn-primary {
	background: linear-gradient(135deg, var(- -primary) 0%,
		var(- -primary-dark) 100%);
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4);
}

.btn-secondary {
	background: linear-gradient(135deg, var(- -secondary) 0%, #7c3aed 100%);
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

@
keyframes fadeIn {from { opacity:0;
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

@
keyframes slideUp {from { opacity:0;
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

@
keyframes pulseGlow { 0%, 100% {
	box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
}

50


%
{
box-shadow


:


0


0


30px


rgba
(


59
,
130
,
246
,
0
.5


)
;


}
}
.shimmer {
	background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
	background-size: 200% 100%;
	animation: shimmer 2s infinite;
}

@
keyframes shimmer { 0% {
	background-position: -200% 0;
}

100


%
{
background-position


:


200
%


0
;


}
}
.progress-bar {
	background: linear-gradient(90deg, var(- -accent) 0%, #fbbf24 100%);
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
		linear-gradient(135deg, var(- -primary), var(- -secondary)) border-box;
}

.coupon-glow {
	background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
	border: 2px solid #f59e0b;
	box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);
	animation: couponGlow 3s ease-in-out infinite;
}

@
keyframes couponGlow { 0%, 100% {
	box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);
}

50


%
{
box-shadow


:


0


0


30px


rgba
(


245
,
158
,
11
,
0
.5


)
;


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
	background: linear-gradient(135deg, var(- -primary) 0%,
		var(- -secondary) 100%);
	color: white;
	padding: 0.5rem 1rem;
	border-radius: 9999px;
	font-weight: 600;
	font-size: 0.875rem;
	display: inline-block;
}

.location-badge {
	background: linear-gradient(135deg, var(- -success) 0%, #059669 100%);
	color: white;
	padding: 0.5rem 1rem;
	border-radius: 9999px;
	font-weight: 600;
	font-size: 0.875rem;
	display: inline-block;
}

.rating-badge {
	background: linear-gradient(135deg, var(- -accent) 0%, #d97706 100%);
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

@
keyframes float { 0%, 100% {
	transform: translateY(0px);
}

50


%
{
transform


:


translateY
(


-10px


)
;


}
}
.section-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent 0%, var(- -gray-300) 50%,
		transparent 100%);
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

.floating-action-btn {
	position: fixed;
	bottom: 2rem;
	right: 2rem;
	z-index: 50;
	animation: float 3s ease-in-out infinite;
	background: linear-gradient(135deg, var(- -primary) 0%,
		var(- -secondary) 100%);
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

@media ( max-width : 768px) {
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

@media ( max-width : 480px) {
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

.gallery {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 8px;
	height: 400px;
}

.gallery-main img {
	height: 100%;
	object-fit: contain;
	border-radius: 12px;
}

.gallery-side {
	display: grid;
	grid-template-rows: 1fr 1fr;
	gap: 8px;
}

.gallery-side .img-wrap {
	position: relative;
	max-height: 200px;
}

.gallery-side img {
	height: 100%;
	object-fit: contain;
	border-radius: 12px;
}

.more-overlay {
	position: absolute;
	inset: 0;
	background: rgba(0, 0, 0, 0.5);
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 24px;
	font-weight: bold;
	border-radius: 12px;
	cursor: pointer;
}

.gallery-image {
	width: 100%;
	height: 100%;
	object-fit: contain;
	background-color: transparent;
	border-radius: 12px;
}

.gallery-main, .gallery-side .img-wrap {
	height: 100%;
	min-height: 0;
}

.panel-overlay {
	display: none;
	background: #ffffff;
	border: 1px solid #e2e8f0;
	border-radius: 1.5rem;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
	margin-top: -1.5rem;
	padding: 1.5rem;
	animation: fadeIn 0.4s ease-out;
}

.panel-overlay.show {
	display: block;
}

.overlay-hd {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding-bottom: 1rem;
	margin-bottom: 1rem;
	border-bottom: 1px solid #e2e8f0;
}

.overlay-bd {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
	gap: 1rem;
	max-height: 600px;
	overflow-y: auto;
	padding-right: 8px;
}

.overlay-bd .gallery-image {
	width: 100%;
	height: auto;
	aspect-ratio: 4/3;
	object-fit: cover;
	border-radius: 12px;
}

.close-x {
	border: 0;
	background: transparent;
	font-size: 24px;
	cursor: pointer;
	color: #64748b;
}

.zoom-modal-mask {
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.4);
	display: none;
	align-items: center;
	justify-content: center;
	z-index: 2000;
}

.zoom-modal-mask.show {
	display: flex;
}

.zoom-modal-content {
	position: relative;
	max-width: 90%;
	max-height: 90%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.zoomed-image {
	max-width: 100%;
	max-height: 100%;
	object-fit: contain;
	border-radius: 8px;
}

.zoom-close-x {
	position: absolute;
	top: -40px;
	right: -40px;
	color: #ffffff;
	font-size: 40px;
	background: none;
	border: none;
	cursor: pointer;
	line-height: 1;
	padding: 0;
}

@media ( max-width : 768px) {
	.zoom-close-x {
		top: 10px;
		right: 10px;
		color: #ffffff;
		font-size: 30px;
	}
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

.gallery-main .gallery-image {
	position: relative;
	z-index: 2;
	max-height: 100%;
}

.review-card .line-clamp-3 {
	overflow: hidden;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	-webkit-line-clamp: 3;
}

.review-detail-panel {
	display: none;
	grid-template-columns: 1fr 1fr;
	gap: 2rem;
	background: #ffffff;
	border: 1px solid #e2e8f0;
	border-radius: 1.5rem;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
	margin-top: 1.5rem;
	padding: 2rem;
	animation: fadeIn 0.4s ease-out;
	grid-column: 1/-1;
}

.review-detail-panel.show {
	display: grid;
}

.review-image-slider {
	position: relative;
	width: 100%;
	aspect-ratio: 1/1;
	overflow: hidden;
	border-radius: 1rem;
}

.review-image-slider img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: opacity 0.3s ease-in-out;
}

.slider-btn {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	background: rgba(0, 0, 0, 0.4);
	color: white;
	border: none;
	border-radius: 50%;
	width: 40px;
	height: 40px;
	cursor: pointer;
	font-size: 20px;
	z-index: 10;
}

.slider-btn.prev {
	left: 10px;
}

.slider-btn.next {
	right: 10px;
}

@media ( max-width : 768px) {
	.review-detail-panel {
		grid-template-columns: 1fr;
	}
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

								<section id="imageOverlay" class="panel-overlay">
									<div class="overlay-hd">
										<h2 class="text-2xl font-bold gradient-text">전체 사진 보기</h2>
										<button id="closeOverlayBtn" class="close-x" type="button">×</button>
									</div>
									<div class="overlay-bd" id="overlayGrid"></div>
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
											class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold pulse-glow">
											❤️ 찜하기</button>
										<button
											class="btn-secondary text-white px-6 py-3 rounded-2xl font-semibold">
											📤 공유하기</button>
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
																	<span class="text-slate-600"> <c:choose>
																			<c:when test="${hour.dayOfWeek == 1}">월요일</c:when>
																			<c:when test="${hour.dayOfWeek == 2}">화요일</c:when>
																			<c:when test="${hour.dayOfWeek == 3}">수요일</c:when>
																			<c:when test="${hour.dayOfWeek == 4}">목요일</c:when>
																			<c:when test="${hour.dayOfWeek == 5}">금요일</c:when>
																			<c:when test="${hour.dayOfWeek == 6}">토요일</c:when>
																			<c:when test="${hour.dayOfWeek == 7}">일요일</c:when>
																		</c:choose>
																	</span> <span class="text-slate-600"> <c:choose>
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
										<h2 class="text-2xl font-bold gradient-text mb-6">🍽️ 메뉴</h2>
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
														<span class="text-2xl font-bold text-sky-600"> <c:choose>
																<c:when test="${fn:contains(menu.price, '원')}">
                                                                    ${menu.price}
                                                                </c:when>
																<c:otherwise>
																	<fmt:formatNumber value="${menu.price}" type="currency"
																		currencySymbol="₩" />
																</c:otherwise>
															</c:choose>
														</span>
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
											✍️ 리뷰 작성 </a>
									</div>
									<c:choose>
										<c:when test="${not empty reviews}">
											<div id="reviewGrid"
												class="grid grid-cols-1 md:grid-cols-2 gap-6">
												<%-- [수정됨] varStatus="status"를 추가하여 인덱스를 사용 --%>
												<c:forEach var="review" items="${reviews}"
													varStatus="status">
													<%--
                [수정됨] 모든 data-review-* 속성을 제거하고,
                onclick 이벤트에 status.index (0부터 시작하는 현재 아이템의 인덱스)를 넘겨줍니다.
            --%>
													<div
														class="review-card p-0 rounded-2xl card-hover overflow-hidden flex flex-col bg-white/50 cursor-pointer"
														onclick="showReviewDetail(${status.index})">

														<c:if
															test="${not empty review.images and not empty review.images[0]}">
															<mytag:image fileName="${review.images[0]}"
																altText="${review.author}님의 리뷰 사진"
																cssClass="w-full h-48 object-cover" />
														</c:if>
														<div class="p-6 flex flex-col flex-grow">
															<div class="flex items-center mb-4">
																<mytag:image fileName="${review.profileImage}"
																	altText="${review.author}"
																	cssClass="w-10 h-10 rounded-full mr-3 object-cover" />
																<div>
																	<span class="font-bold text-slate-800">${review.author}</span>
																	<span class="text-sm text-slate-500 block">${review.createdAt.format(DateTimeFormatter.ofPattern('yyyy.MM.dd'))}</span>
																</div>
															</div>
															<div class="flex space-x-1 mb-3">
																<c:forEach begin="1" end="5" var="star">
																	<c:choose>
																		<c:when test="${review.rating >= star}">
																			<span class="text-yellow-400 text-lg rating-stars">★</span>
																		</c:when>
																		<c:otherwise>
																			<span class="text-slate-300 text-lg">☆</span>
																		</c:otherwise>
																	</c:choose>
																</c:forEach>
															</div>
															<p
																class="text-slate-700 leading-relaxed line-clamp-3 mb-4 flex-grow">${review.content}</p>
															<div
																class="flex items-center justify-between mt-auto pt-4 border-t border-slate-200/80">
																<button
																	class="text-sky-600 hover:text-sky-700 text-sm font-semibold flex items-center space-x-1">
																	<span>❤️</span> <span>${review.likes > 0 ? review.likes : 0}</span>
																</button>
															</div>
														</div>
													</div>
												</c:forEach>
												<div id="reviewDetailPanel" class="review-detail-panel"></div>
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
										<h2 class="text-2xl font-bold gradient-text mb-6">🎫 MEET
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
																	class="bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-6 py-3 rounded-2xl font-bold hover:from-yellow-600 hover:to-orange-600 transform hover:scale-105 transition-all duration-300 shadow-xl">
																	🎁 쿠폰받기</button>
															</div>
														</div>
													</div>
												</div>
											</c:forEach>
										</div>
									</section>
								</c:if>

								<section class="glass-card p-8 rounded-3xl slide-up">
									<div class="flex justify-between items-center mb-6">
										<h2 class="text-2xl font-bold gradient-text">❓ Q&A</h2>
										<button onclick="toggleQnAForm()"
											class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
											💬 문의하기</button>
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
														class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
														문의 등록</button>
													<button type="button" onclick="toggleQnAForm()"
														class="px-6 py-3 border border-slate-300 text-slate-700 rounded-xl font-semibold hover:bg-slate-50">
														취소</button>
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
																	class="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-3 py-1 rounded-full text-sm font-semibold">Q</span>
																<span class="ml-3 text-sm text-slate-500 font-medium">고객</span>
																<span
																	class="ml-2 px-2 py-1 bg-slate-100 text-slate-600 text-xs rounded-full">
																	<c:choose>
																		<c:when test="${empty qna.answer}">답변 대기</c:when>
																		<c:otherwise>답변 완료</c:otherwise>
																	</c:choose>
																</span>
															</div>
															<p class="text-slate-800 font-medium">${qna.question}</p>
														</div>
														<c:if test="${not empty qna.answer}">
															<div class="border-t border-slate-200 pt-4">
																<div class="flex items-center mb-3">
																	<span
																		class="bg-gradient-to-r from-green-500 to-emerald-500 text-white px-3 py-1 rounded-full text-sm font-semibold">A</span>
																	<span class="ml-3 text-sm text-slate-500 font-medium">
																		<c:choose>
																			<c:when test="${qna.owner}">사장님</c:when>
																			<c:otherwise>관리자</c:otherwise>
																		</c:choose>
																	</span>
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
								<section class="glass-card p-8 rounded-3xl slide-up">
									<div id="map" class="w-full h-64 rounded-2xl border"></div>
								</section>
								<section class="glass-card p-8 rounded-3xl slide-up">
									<h3 class="text-2xl font-bold gradient-text mb-6">온라인 예약</h3>
									<%
									List<OperatingHour> operatingHours = (List<OperatingHour>) request.getAttribute("operatingHours");
									int todayDayOfWeek = LocalDate.now().getDayOfWeek().getValue();
									List<String> timeSlots = new ArrayList<>();
									if (operatingHours != null) {
										for (OperatingHour oh : operatingHours) {
											if (oh.getDayOfWeek() == todayDayOfWeek && oh.getOpeningTime() != null && oh.getClosingTime() != null) {
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
												날짜</label> <input type="date"
												value="<%=LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE)%>"
												class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
										</div>
										<div>
											<label class="block text-sm font-bold mb-3 text-slate-700">👥
												인원</label> <select
												class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
												<option>1명</option>
												<option selected>2명</option>
												<option>3명</option>
												<option>4명</option>
												<option>5명</option>
												<option>6명 이상</option>
											</select>
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

															<button type="button" class="btn-reserve-time"
																onclick="selectTime(this, '${time}')">${time}</button>
															<c:set var="lastCategory" value="${currentCategory}" />
														</c:forEach>
													</div>
												</c:when>
												<c:otherwise>
													<div class="text-center p-4 bg-slate-50 rounded-lg">
														<p class="text-slate-500">오늘 예약 가능한 시간이 없습니다.</p>
													</div>
												</c:otherwise>
											</c:choose>
										</div>
										<a
											href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}"
											class="w-full btn-primary text-white py-4 rounded-2xl font-bold block text-center pulse-glow">
											🎯 예약하기 </a>
									</div>
								</section>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div class="glass-card p-12 rounded-3xl text-center fade-in">
							<div class="text-8xl mb-6">😔</div>
							<h2 class="text-3xl font-bold gradient-text mb-4">맛집 정보를 찾을
								수 없습니다</h2>
							<p class="text-slate-600 mb-8">요청하신 맛집 정보가 존재하지 않거나 삭제되었습니다.</p>
							<a href="${pageContext.request.contextPath}/main"
								class="btn-primary text-white px-8 py-4 rounded-2xl font-semibold inline-block">
								🏠 메인 페이지로 돌아가기 </a>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</main>

		<jsp:include page="/WEB-INF/views/common/footer.jsp" />

		<c:if test="${not empty restaurant}">
			<a
				href="${pageContext.request.contextPath}/reservation/create?restaurantId=${restaurant.id}"
				class="floating-action-btn"> 🎯 예약하기 </a>
		</c:if>
	</div>
	<div id="imageZoomModal" class="zoom-modal-mask">
		<div class="zoom-modal-content">
			<button id="closeZoomModalBtn" class="close-x zoom-close-x"
				type="button">×</button>
			<img id="zoomedImage" src="" alt="확대 이미지" class="zoomed-image">
		</div>
	</div>

	<c:if
		test="${not empty restaurant and restaurant.latitude != 0 and restaurant.longitude != 0}">
		<script>
        var restaurantLat = <c:out value="${restaurant.latitude}" />;
        var restaurantLng = <c:out value="${restaurant.longitude}" />;
		kakao.maps.load(function() {
            var mapContainer = document.getElementById('map');
            var mapOption = { 
                center: new kakao.maps.LatLng(restaurantLat, restaurantLng),
                    level: 3
                };
      
           var map = new kakao.maps.Map(mapContainer, mapOption); 
            var marker = new kakao.maps.Marker({ 
                position: new kakao.maps.LatLng(restaurantLat, restaurantLng)
            });
                marker.setMap(map);
        });
        </script>
	</c:if>

	<script>
        // ===================================================================================
        // SCRIPT START: 여기에 모든 페이지 관련 JavaScript 코드가 있습니다.
        // ===================================================================================
        
        // JSP와 JS의 문법 충돌을 피하기 위해 contextPath를 JS 변수로 저장
        const contextPath = '${pageContext.request.contextPath}';

        function toggleQnAForm() {
            const form = document.getElementById('qnaForm');
            if (form.classList.contains('hidden')) {
                form.classList.remove('hidden');
                form.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                form.classList.add('hidden');
            }
        }
        function selectTime(button, time) {
            document.querySelectorAll('.btn-reserve-time, .time-slot-available, .time-slot-closing').forEach(btn => btn.classList.remove('selected'));
            button.classList.add('selected');
            window.selectedTime = time;
        }

        // --- 이미지 갤러리 및 모달 관련 ---
        const allImageFiles = ["${restaurant.image}", <c:forEach var="img" items="${restaurant.additionalImages}">'${fn:escapeXml(img)}',</c:forEach>].filter(Boolean);
        const overlaySection = document.getElementById('imageOverlay');
        const overlayGrid = document.getElementById('overlayGrid');
        const closeOverlayBtn = document.getElementById('closeOverlayBtn');
        const imageZoomModal = document.getElementById('imageZoomModal');
        const zoomedImage = document.getElementById('zoomedImage');
        const closeZoomModalBtn = document.getElementById('closeZoomModalBtn');

        function cycleImages() {
            overlaySection && overlaySection.classList.contains('show') ? closeImageOverlay() : showImageOverlay();
        }
        function showImageOverlay() {
            if (!overlaySection || !overlayGrid) return;
            overlayGrid.innerHTML = ''; 
            allImageFiles.forEach(fileName => {
                const img = document.createElement('img');
                img.className = 'gallery-image';
                img.alt = '전체 이미지';
                img.src = contextPath + '/uploads/restaurants/' + encodeURIComponent(fileName.trim());
                img.addEventListener('click', () => openZoomModal(img.src));
                overlayGrid.appendChild(img);
            });
            overlaySection.classList.add('show');
        }
        function closeImageOverlay() {
            if (overlaySection) overlaySection.classList.remove('show');
        }
        function openZoomModal(imageSrc) {
            if (zoomedImage) zoomedImage.src = imageSrc;
            if (imageZoomModal) imageZoomModal.classList.add('show');
        }
        function closeZoomModal() {
            if (imageZoomModal) imageZoomModal.classList.remove('show');
        }
        
        if (closeOverlayBtn) closeOverlayBtn.addEventListener('click', closeImageOverlay);
        if (closeZoomModalBtn) closeZoomModalBtn.addEventListener('click', closeZoomModal);
        if (imageZoomModal) {
            imageZoomModal.addEventListener('click', (e) => {
                if (e.target === imageZoomModal) { closeZoomModal(); }
            });
        }

		// --- 리뷰 상세 패널 관련 ---
		const reviewsData = ${reviewsJson};

    // --- 리뷰 상세 패널 관련 ---
    const reviewGrid = document.getElementById('reviewGrid');
    const reviewDetailPanel = document.getElementById('reviewDetailPanel');
    let currentReviewSlider = {
        images: [],
        currentIndex: 0,
        imageElement: null
    };
    
    // [수정됨] 이제 element가 아닌 index를 매개변수로 받습니다.
    function showReviewDetail(index) {
        // reviewsData 배열에서 해당 인덱스의 리뷰 데이터를 가져옵니다.
        const review = reviewsData[index];
        
        // JSP EL이 아닌, 순수 JavaScript 변수로 데이터를 사용합니다.
        const author = review.author;
        const profileImage = review.profileImage;
        const rating = parseInt(review.rating, 10);
        const date = new Date(review.createdAt.year, review.createdAt.month-1, review.createdAt.dayOfMonth).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/ /g, '');
        const content = review.content;
        const images = review.images || [];
        
        // 이하는 이전 코드와 거의 동일하나, 데이터를 review 객체에서 직접 가져옵니다.
        let sliderHtml = '';
        if (images.length > 0) {
            sliderHtml += '<img id="reviewSliderImage" src="' + contextPath + '/uploads/reviews/' + images[0] + '" alt="리뷰 상세 이미지">';
            if (images.length > 1) {
                sliderHtml += 
                    '<button class="slider-btn prev" onclick="changeReviewImage(-1)">&#10094;</button>' +
                    '<button class="slider-btn next" onclick="changeReviewImage(1)">&#10095;</button>';
            }
        } else {
            sliderHtml = '<div class="w-full h-full bg-slate-100 flex items-center justify-center text-slate-400">이미지 없음</div>';
        }
        
        let starsHtml = '';
        for (let i = 0; i < 5; i++) {
            starsHtml += i < rating ? '★' : '☆';
        }
        const ratingColorClass = 'text-yellow-400';
        
        reviewDetailPanel.innerHTML = 
            '<div class="review-image-slider">' + sliderHtml + '</div>' +
            '<div class="flex flex-col">' +
                '<div class="flex items-center mb-4">' +
                    '<img src="' + contextPath + '/uploads/profiles/' + profileImage + '" class="w-12 h-12 rounded-full mr-4 object-cover">' +
                    '<div>' +
                        '<div class="font-bold text-lg text-slate-800">' + author + '</div>' +
                        '<div class="text-sm text-slate-500">' + date + '</div>' +
                    '</div>' +
                    '<button class="ml-auto text-2xl text-slate-400 hover:text-slate-600" onclick="closeReviewDetail()">×</button>' +
                '</div>' +
                '<div class="flex space-x-1 mb-4 text-lg ' + ratingColorClass + '">' + starsHtml + '</div>' +
                '<div class="text-slate-700 leading-relaxed overflow-y-auto" style="max-height: 300px;">' +
                    content.replace(/\n/g, '<br>') + // content의 줄바꿈을 <br>로 변환
                '</div>' +
            '</div>';

        currentReviewSlider.images = images;
        currentReviewSlider.currentIndex = 0;
        currentReviewSlider.imageElement = document.getElementById('reviewSliderImage');

        reviewGrid.appendChild(reviewDetailPanel);
        reviewDetailPanel.classList.add('show');
        reviewDetailPanel.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // ... (closeReviewDetail, changeReviewImage 함수는 이전 수정과 동일)
    function closeReviewDetail() {
        if (reviewDetailPanel) {
            reviewDetailPanel.classList.remove('show');
        }
    }

    function changeReviewImage(direction) {
        event.stopPropagation();
        const { images } = currentReviewSlider;
        if (!images || images.length <= 1) return;
        
        let newIndex = currentReviewSlider.currentIndex + direction;
        if (newIndex < 0) newIndex = images.length - 1;
        else if (newIndex >= images.length) newIndex = 0;
        
        currentReviewSlider.currentIndex = newIndex;
        if(currentReviewSlider.imageElement) {
            currentReviewSlider.imageElement.src = contextPath + '/uploads/reviews/' + images[newIndex];
        }
    }
</script>
</body>
</html>