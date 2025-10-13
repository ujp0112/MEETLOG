<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"
	import="util.ApiKeyLoader, model.OperatingHour, java.time.LocalTime, java.time.LocalDate, java.time.format.DateTimeFormatter, java.util.ArrayList, java.util.List, java.util.Collections, java.sql.Timestamp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>

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
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services&autoload=false"></script>
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

.gallery-main .gallery-image {
	position: relative;
	z-index: 2;
	max-height: 100%;
}

.card-hover {
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.card-hover:hover {
	transform: translateY(-2px);
	box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
}

.review-keyword-tag {
	display: inline-flex;
	align-items: center;
	background-color: #e0f2fe;
	color: #0c4a6e;
	padding: 6px 12px;
	border-radius: 9999px;
	font-size: 0.8rem;
	font-weight: 500;
	border: 1px solid #bae6fd;
}

.review-text.truncated {
	overflow: hidden;
	display: -webkit-box;
	-webkit-line-clamp: 3;
	-webkit-box-orient: vertical;
}

.read-more-btn {
	color: #94a3b8;
	font-weight: 500;
	font-size: 0.875rem;
	cursor: pointer;
	transition: color 0.2s;
}

.read-more-btn:hover {
	color: #334155;
}

.review-image-container {
	position: relative;
	overflow: hidden;
}

.review-image-track {
	display: flex;
	overflow-x: auto;
	scroll-snap-type: x mandatory;
	scroll-behavior: smooth;
	-ms-overflow-style: none;
	scrollbar-width: none;
}

.review-image-track::-webkit-scrollbar {
	display: none;
}

.review-image-item {
	flex: 0 0 100%;
	scroll-snap-align: center;
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
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
	z-index: 10;
	opacity: 0;
	transition: opacity 0.2s ease-in-out;
}

.review-image-container:hover .review-image-arrow {
	opacity: 1;
}

.review-image-arrow.prev {
	left: 8px;
}

.review-image-arrow.next {
	right: 8px;
}

.review-image-pagination {
	position: absolute;
	bottom: 10px;
	left: 50%;
	transform: translateX(-50%);
	display: flex;
	gap: 6px;
	z-index: 10;
}

.pagination-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	background-color: rgba(255, 255, 255, 0.5);
	transition: background-color 0.2s ease-in-out;
}

.pagination-dot.active {
	background-color: white;
}

.modal-overlay {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.7);
	z-index: 1000;
	display: none;
	justify-content: center;
	align-items: center;
}

.modal-close-btn {
	position: absolute;
	top: 1rem;
	right: 1rem;
	width: 2rem;
	height: 2rem;
	background: #f1f5f9;
	color: #64748b;
	border: none;
	border-radius: 50%;
	font-size: 1.25rem;
	font-weight: bold;
	cursor: pointer;
	line-height: 2rem;
	text-align: center;
	z-index: 20;
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
</style>
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
	background: linear-gradient(135deg, var(--primary) 0%, var(--secondary)
		100%);
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
	background: linear-gradient(90deg, transparent 0%, var(--gray-300) 50%,
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
	background: linear-gradient(135deg, var(--primary) 0%, var(--secondary)
		100%);
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
	height: 400px; /* 갤러리 높이 고정 */
}

.gallery-main img { /*  width: 100%; */
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

.gallery-side img { /*  width: 100%;  */
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
	min-height: 0; /* flex/grid 아이템이 수축할 수 있도록 허용 */
}
/* ▼▼▼ 아래의 새로운 오버레이 스타일을 추가합니다 ▼▼▼ */
.panel-overlay {
	display: none; /* 평소엔 숨김 */
	background: #ffffff;
	border: 1px solid #e2e8f0;
	border-radius: 1.5rem; /* 24px */
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
	margin-top: -1.5rem; /* 갤러리와 살짝 겹치게 */
	padding: 1.5rem;
	animation: fadeIn 0.4s ease-out;
}

.panel-overlay.show {
	display: block; /* show 클래스가 붙으면 보임 */
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
	/* 반응형 2열 이상 */
	gap: 1rem;
	max-height: 600px; /* 최대 높이 지정 후 스크롤 */
	overflow-y: auto;
	padding-right: 8px; /* 스크롤바 공간 */
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
/* ▼▼▼ 이미지 확대 모달 스타일 추가 ▼▼▼ */
.zoom-modal-mask {
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.4); /* 어두운 반투명 배경 */
	display: none; /* 평소엔 숨김 */
	align-items: center;
	justify-content: center;
	z-index: 2000; /* 모든 오버레이 위에 표시 */
}

.zoom-modal-mask.show {
	display: flex; /* show 클래스가 추가되면 표시 */
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
	object-fit: contain; /* 이미지 전체가 보이도록 */
	border-radius: 8px;
}

.zoom-close-x {
	position: absolute;
	top: -40px; /* 모달 상단 바깥쪽 */
	right: -40px; /* 모달 우측 바깥쪽 */
	color: #ffffff; /* 흰색 X 버튼 */
	font-size: 40px;
	background: none;
	border: none;
	cursor: pointer;
	line-height: 1;
	padding: 0;
}
/* 작은 화면에서는 X 버튼 위치 조정 */
@media ( max-width : 768px) {
	.zoom-close-x {
		top: 10px;
		right: 10px;
		color: #ffffff;
		font-size: 30px;
	}
}

/* restaurant-detail.jsp의 <style> 태그 안에 추가 */
.gallery {
	display: grid;
	grid-template-columns: 2fr 1fr; /* 기존 스타일 유지 */
	gap: 8px;
	height: 400px;
}

/* ▼▼▼ 아래 새로운 스타일을 추가하세요 ▼▼▼ */
.gallery.gallery-full {
	grid-template-columns: 1fr; /* 이미지가 하나일 때 1개의 컬럼만 사용 */
}

/* .gallery.gallery-full 클래스 바로 아래에 추가하면 좋습니다. */
.gallery.gallery-full .gallery-main {
	position: relative; /* 자식 요소를 위한 기준점 */
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden; /* [추가] 자식 요소가 부모 영역을 벗어나지 않도록 설정 */
	border-radius: 12px;
	/* [추가] 부모에도 border-radius를 적용해 잘려나간 부분이 깔끔하게 보이도록 함 */
}

.gallery-background {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	object-fit: cover;
	/* [수정] 이미지를 강제로 픽셀화하여 모자이크 효과를 냅니다. */
	image-rendering: -moz-crisp-edges; /* Firefox */
	image-rendering: pixelated; /* Chrome, Edge, Opera */
	/* [수정] 이미지를 아주 작게 축소했다가 크게 확대하여 픽셀을 돋보이게 합니다. */
	transform: scale(5);
	opacity: 0.5; /* 배경이 너무 튀지 않도록 투명도 조절 */
	z-index: 1;
	border-radius: 12px;
}

.gallery-main .gallery-image {
	position: relative;
	z-index: 2; /* 앞쪽으로 보내기 */
	max-height: 100%; /* 부모 높이를 넘지 않도록 */
}
/* 전체 사진 오버레이 그리드 스타일 (CSS Grid 방식) */
#overlayGrid {
	display: grid;
	grid-template-columns: repeat(2, 1fr); /* 2개의 동일한 너비의 열을 생성합니다. */
	gap: 8px; /* 이미지 사이의 간격을 설정합니다. */
}

/* 각 이미지를 감싸는 wrapper 스타일 */
#overlayGrid .gallery-image-wrapper {
	width: 100%;
	aspect-ratio: 1/1;
	/* 이미지 비율을 1:1 (정사각형)으로 고정합니다. (원하면 16/9 등으로 변경 가능) */
	border-radius: 8px;
	overflow: hidden;
}

/* wrapper 안의 실제 이미지 스타일 */
#overlayGrid .gallery-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	object-position: center;
}

/* ▼▼▼ [추가] 리뷰 '더보기' 메뉴 관련 스타일 ▼▼▼ */
.review-options-container {
	position: relative; /* 자식 요소(드롭다운)의 기준점 */
}

.review-options-btn {
	background: transparent;
	border: none;
	cursor: pointer;
	padding: 4px;
	border-radius: 50%;
	transition: background-color 0.2s;
	line-height: 1; /* 아이콘 정렬 */
}

.review-options-btn:hover {
	background-color: #f1f5f9; /* 연한 회색 배경 */
}

.review-options-dropdown {
	position: absolute;
	top: 100%;
	right: 0;
	z-index: 20;
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	border: 1px solid #e2e8f0;
	min-width: 120px;
	padding: 8px;
	opacity: 0;
	transform: translateY(-10px);
	transition: opacity 0.2s ease, transform 0.2s ease;
	visibility: hidden; /* display: none 대신 사용 */
}

.review-options-dropdown.show {
	opacity: 1;
	transform: translateY(0);
	visibility: visible;
}

.dropdown-item {
	display: block;
	width: 100%;
	text-align: left;
	padding: 8px 12px;
	font-size: 0.875rem; /* 14px */
	color: #334155;
	background: none;
	border: none;
	cursor: pointer;
	border-radius: 4px;
	transition: background-color 0.2s;
}

.dropdown-item:hover {
	background-color: #f1f5f9;
}

.dropdown-item.delete {
	color: #ef4444; /* 빨간색 텍스트 */
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
								<%-- ▼▼▼ 이 코드로 기존 갤러리 섹션 전체를 교체하세요 (스크립트는 절대 수정하지 마세요!) ▼▼▼ --%>
								<c:choose>
									<%-- =================================================================== --%>
									<%-- 1. 외부 검색(Google 이미지)일 경우                                        --%>
									<%-- =================================================================== --%>
									<c:when test="${isExternal}">
										<section class="glass-card p-8 rounded-3xl fade-in">
											<c:set var="images" value="${restaurant.additionalImages}" />
											<c:set var="imageCount" value="${fn:length(images)}" />
											<c:choose>
												<c:when test="${imageCount == 0}">
													<div class="text-center py-12">
														<p class="text-slate-500">가게 이미지를 불러올 수 없습니다.</p>
													</div>
												</c:when>
												<c:when test="${imageCount == 1}">
													<div class="w-full aspect-video rounded-lg overflow-hidden">
														<img src="${images[0]}" alt="${restaurant.name}"
															class="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
													</div>
												</c:when>
												<c:when test="${imageCount == 2}">
													<div class="grid grid-cols-2 gap-2 aspect-video">
														<div class="rounded-lg overflow-hidden">
															<img src="${images[0]}" alt="${restaurant.name}"
																class="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
														<div class="rounded-lg overflow-hidden">
															<img src="${images[1]}" alt="${restaurant.name}"
																class="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
													</div>
												</c:when>
												<c:otherwise>
													<div
														class="grid grid-cols-3 grid-rows-2 gap-2 aspect-video">
														<div
															class="col-span-2 row-span-2 rounded-lg overflow-hidden">
															<img src="${images[0]}" alt="${restaurant.name}"
																class="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
														<div class="rounded-lg overflow-hidden">
															<img src="${images[1]}" alt="${restaurant.name}"
																class="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
														<div
															class="relative rounded-lg overflow-hidden flex items-center justify-center cursor-pointer bg-gray-800"
															onclick="cycleImages()">
															<%-- ✨ [수정] '더보기' 이미지에서 image-lightbox-trigger 클래스 제거 --%>
															<img src="${images[2]}" alt="${restaurant.name}"
																class="w-full h-full object-cover ${imageCount > 3 ? 'opacity-30' : ''}" />
															<c:if test="${imageCount > 3}">
																<span class="absolute text-white text-2xl font-bold">+${imageCount - 3}</span>
															</c:if>
														</div>
													</div>
												</c:otherwise>
											</c:choose>
										</section>
									</c:when>

									<%-- =================================================================== --%>
									<%-- 2. 내부 DB(기존 이미지)일 경우                                         --%>
									<%-- =================================================================== --%>
									<c:otherwise>
										<section class="glass-card p-8 rounded-3xl fade-in">
											<c:set var="mainImage" value="${restaurant.image}" />
											<c:set var="additionalImages"
												value="${restaurant.additionalImages}" />
											<c:set var="totalCount"
												value="${(empty mainImage ? 0 : 1) + fn:length(additionalImages)}" />
											<c:choose>
												<c:when test="${totalCount == 0}">
													<div class="text-center py-12">
														<p class="text-slate-500">등록된 가게 이미지가 없습니다.</p>
													</div>
												</c:when>
												<c:when test="${totalCount == 1}">
													<div class="w-full aspect-video rounded-lg overflow-hidden">
														<mytag:image fileName="${mainImage}"
															altText="${restaurant.name}"
															cssClass="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
													</div>
												</c:when>
												<c:when test="${totalCount == 2}">
													<div class="grid grid-cols-2 gap-2 aspect-video">
														<div class="rounded-lg overflow-hidden">
															<mytag:image fileName="${mainImage}"
																altText="${restaurant.name}"
																cssClass="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
														<div class="rounded-lg overflow-hidden">
															<mytag:image fileName="${additionalImages[0]}"
																altText="${restaurant.name}"
																cssClass="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
													</div>
												</c:when>
												<c:otherwise>
													<div
														class="grid grid-cols-3 grid-rows-2 gap-2 aspect-video">
														<div
															class="col-span-2 row-span-2 rounded-lg overflow-hidden">
															<mytag:image fileName="${mainImage}"
																altText="${restaurant.name}"
																cssClass="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
														<div class="rounded-lg overflow-hidden">
															<mytag:image fileName="${additionalImages[0]}"
																altText="${restaurant.name}"
																cssClass="w-full h-full object-cover image-lightbox-trigger cursor-pointer" />
														</div>
														<div
															class="relative rounded-lg overflow-hidden flex items-center justify-center cursor-pointer"
															onclick="cycleImages()">
															<%-- ✨ [수정] '더보기' 이미지에서 image-lightbox-trigger 클래스 제거 --%>
															<mytag:image fileName="${additionalImages[1]}"
																altText="${restaurant.name}"
																cssClass="w-full h-full object-cover ${totalCount > 3 ? 'opacity-30' : ''}" />
															<c:if test="${totalCount > 3}">
																<span class="absolute text-white text-2xl font-bold">+${totalCount - 3}</span>
															</c:if>
														</div>
													</div>
												</c:otherwise>
											</c:choose>
										</section>
									</c:otherwise>
								</c:choose>

								<%-- ✨ X버튼 오류 해결: 기존 JS와 연동되도록 원래 클래스명으로 복원했습니다 --%>
								<section id="imageOverlay" class="panel-overlay">
									<div class="overlay-hd">
										<h2 class="title">전체 사진 보기</h2>
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
										<%-- ▼▼▼ [수정] isExternal 값에 따라 분기 처리 ▼▼▼ --%>
										<c:choose>
											<%-- 외부(Google) 데이터일 경우 --%>
											<c:when test="${isExternal}">
												<div class="text-right">
													<c:if test="${restaurant.rating > 0}">
														<div class="text-5xl font-black rating-badge mb-2">
															<fmt:formatNumber value="${restaurant.rating}"
																maxFractionDigits="1" />
														</div>
														<div class="text-sm text-slate-500">${restaurant.reviewCount}개
															Google 리뷰</div>
													</c:if>
												</div>
											</c:when>
											<%-- 내부 DB 데이터일 경우 --%>
											<c:otherwise>
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
											</c:otherwise>
										</c:choose>
										<%-- ▲▲▲ [수정] 분기 처리 끝 ▲▲▲ --%>
									</div>
									<c:if test="${!isExternal}">
										<div class="flex space-x-4">
											<div class="text-right">
												<button
													class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold pulse-glow">❤️
													찜하기</button>
												<button
													class="btn-secondary text-white px-6 py-3 rounded-2xl font-semibold">📤
													공유하기</button>
											</div>
										</div>
									</c:if>
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
												<%-- ▼▼▼ [수정] 외부/내부 데이터 분기 처리 ▼▼▼ --%>
												<c:choose>
													<%-- 1. 외부(Google) 데이터일 경우 --%>
													<c:when test="${isExternal and not empty restaurant.hours}">
														<%-- ▼▼▼ [수정] pre 태그를 사용하여 줄바꿈과 공백을 그대로 표시하도록 변경 ▼▼▼ --%>
														<pre
															class="mt-2 text-sm text-slate-600 font-sans whitespace-pre-wrap break-words">${restaurant.hours}</pre>
														<%-- ▲▲▲ [수정] 로직 끝 ▲▲▲ --%>
													</c:when>
													<%-- 2. 내부 DB 데이터일 경우 --%>
													<c:when
														test="${not isExternal and not empty operatingHours}">
														<div class="mt-2 space-y-1">
															<%-- ▼▼▼ [수정] mytag 제거 및 JSTL로 요일/시간 직접 출력 ▼▼▼ --%>
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
																	</span> <span class="text-slate-600"> <c:if
																			test="${not empty hour.openingTime and not empty hour.closingTime}">
																			${fn:substring(hour.openingTime, 0, 5)} - ${fn:substring(hour.closingTime, 0, 5)}
																		</c:if> <c:if
																			test="${empty hour.openingTime or empty hour.closingTime}">
																			<span class="text-red-500">휴무</span>
																		</c:if>
																	</span>
																</div>
															</c:forEach>
															<%-- ▲▲▲ [수정] 로직 끝 ▲▲▲ --%>
														</div>
													</c:when>
													<%-- 3. 정보가 없는 경우 --%>
													<c:otherwise>
														<p class="text-slate-600 mt-1">영업시간 정보 없음</p>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
										<c:if test="${!isExternal}">
											<div
												class="flex items-start space-x-4 p-4 bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl card-hover">
												<div class="text-2xl">🚗</div>
												<div>
													<span class="font-bold text-slate-700">주차</span>
													<p class="text-slate-600 mt-1">${restaurant.parking ? "가능" : "불가"}</p>
												</div>
											</div>
										</c:if>
									</div>
									<c:if test="${not empty restaurant.description}">
										<div
											class="mt-6 p-4 bg-gradient-to-r from-slate-50 to-gray-50 rounded-2xl">
											<h3 class="font-bold text-slate-700 mb-2">📝 가게 소개</h3>
											<p class="text-slate-600 leading-relaxed break-words">${restaurant.description}</p>
										</div>
									</c:if>
								</section>
								<c:if test="${!isExternal}">
									<%-- 내부 DB 맛집일 경우에만 메뉴 표시 --%>
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
																		<fmt:formatNumber value="${menu.price}"
																			type="currency" currencySymbol="₩" />
																	</c:otherwise>
																</c:choose></span>
														</div>
													</div>
												</c:forEach>
											</div>
										</section>
									</c:if>
								</c:if>

								<%-- ▼▼▼ [수정] 리뷰 섹션 시작 ▼▼▼ --%>
								<section class="glass-card p-8 rounded-3xl slide-up">
									<div class="flex justify-between items-center mb-6">
										<%-- 외부/내부 데이터에 따라 리뷰 개수 표시 --%>
										<c:choose>
											<c:when test="${isExternal}">
												<h2 class="text-2xl font-bold gradient-text">리뷰
													(${restaurant.reviewCount})</h2>
											</c:when>
											<c:otherwise>
												<h2 class="text-2xl font-bold gradient-text">리뷰
													(${fn:length(reviews)})</h2>
											</c:otherwise>
										</c:choose>

										<%-- 내부 DB 맛집이고, 소유자가 아닐 때만 리뷰 작성 버튼 표시 --%>
										<c:if
											test="${!isExternal and !isOwner and not empty sessionScope.user}">
											<a
												href="${pageContext.request.contextPath}/review/write?restaurantId=${restaurant.id}"
												class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">리뷰
												작성</a>
										</c:if>
									</div>
									<%-- ▼▼▼ [수정] isExternal 값에 따라 reviewList 변수에 적절한 리뷰 목록을 할당합니다. ▼▼▼ --%>
									<c:set var="reviewList" value="${isExternal ? restaurant.reviews : reviews}" />									
									<c:choose>
										<c:when test="${not empty reviews or not empty restaurant.reviews}">
											<div id="review-list-container" class="space-y-6">
												<c:forEach var="review" items="${reviewList}">
													<div class="review-item" style="display: none;"> 
														<div class="bg-white p-6 rounded-2xl h-full flex flex-col">
															<div class="flex justify-between items-start mb-4"> <%-- 이 div 안에 '더보기' 메뉴를 넣습니다. --%>
																<div class="flex items-start">
																	<c:choose>
																		<%-- 외부(Google) 리뷰 프로필 이미지 --%>
																		<c:when test="${isExternal}">
																			<img src="${review.profileImage}"
																				alt="${review.author}" onerror="this.onerror=null;"
																				class="w-12 h-12 rounded-full object-cover mr-4">
																		</c:when>
																		<c:otherwise>
																				<img
																					src="${pageContext.request.contextPath}/images/${review.profileImage}"
																					alt="${review.author}"
																					onerror="this.onerror=null; this.src='https://placehold.co/600x400/e2e8f0/64748b?text=${review.author }';"
																					class="w-12 h-12 rounded-full object-cover mr-4">
																		</c:otherwise>
																	</c:choose>
																	<c:choose>
																		<c:when test="${isExternal or review.userId == 0}">
																			<span class="font-bold text-slate-800">${review.author}</span>
																		</c:when>
																		<c:otherwise>
																			<a
																				href="${pageContext.request.contextPath}/feed/user/${review.userId}"
																				class="font-bold text-slate-800 hover:text-blue-600 transition-colors">${review.author}</a>
																		</c:otherwise>
																	</c:choose>
																	<div
																		class="flex items-center text-sm text-slate-500 mt-1">
																		<div class="flex">
																			<c:forEach begin="1" end="5" var="i">
																				<span
																					class="${i <= review.rating ? 'text-yellow-400' : 'text-slate-300'}">★
																				</span>
																			</c:forEach>
																		</div>
																		<%-- Google 리뷰는 createdAt, DB 리뷰는 createdAtAsDate 사용 --%>
																		<span class="mx-2">·</span> <span><fmt:formatDate
																				value="${isExternal ? review.createdAt : review.createdAtAsDate}"
																				pattern="yy.MM.dd" /></span>
																	</div>
																</div>

																<%-- ▼▼▼ [수정] '더보기' 메뉴 버튼 및 드롭다운 메뉴를 이곳으로 이동 ▼▼▼ --%>
																<c:if test="${not empty sessionScope.user}">
																	<div class="review-options-container">
																		<button class="review-options-btn"
																			data-review-id="${review.id}">
																			<img
																				src="${pageContext.request.contextPath}/img/icon_more_vertical.png"
																				alt="더보기" class="w-5 h-5">
																		</button>
																		<div class="review-options-dropdown">
																			<c:choose>
																				<%-- 리뷰 작성자와 현재 로그인한 유저가 같을 경우 --%>
																				<c:when
																					test="${sessionScope.user.id == review.userId}">
																					<a
																						href="${pageContext.request.contextPath}/review/edit?reviewId=${review.id}"
																						class="dropdown-item">리뷰 수정</a>
																					<button
																						class="dropdown-item delete review-delete-btn"
																						data-review-id="${review.id}">리뷰 삭제</button>
																				</c:when>
																				<%-- 다른 유저일 경우 --%>
																				<c:otherwise>
																					<button class="dropdown-item review-report-btn"
																						data-review-id="${review.id}"
																						data-review-author="${fn:escapeXml(review.author)}">리뷰
																						신고</button>
																				</c:otherwise>
																			</c:choose>
																		</div>
																	</div>
																</c:if>
																<!-- <c:if
																			test="${not empty sessionScope.user and sessionScope.user.id != review.userId}">
																			<c:choose>
																				<c:when
																					test="${review.authorIsFollowedByCurrentUser}">
																					<button
																						class="follow-btn text-xs font-bold py-1 px-3 rounded-full bg-gray-200 text-gray-700 transition-colors"
																						data-user-id="${review.userId}">팔로잉</button>
																				</c:when>
																				<c:otherwise>
																					<button
																						class="follow-btn text-xs font-bold py-1 px-3 rounded-full bg-blue-500 text-white hover:bg-blue-600 transition-colors"
																						data-user-id="${review.userId}">팔로우</button>
																				</c:otherwise>
																			</c:choose>
																		</c:if> -->
															</div>
														</div>

														<c:if test="${not empty review.images}">
															<div class="review-image-container mb-4 rounded-lg">
																<div class="review-image-track">
																	<c:forEach var="imagePath" items="${review.images}"
																		varStatus="loop">
																		<div
																			class="review-image-item aspect-video bg-slate-100 rounded-lg">
																			<%-- [수정] 외부 리뷰는 URL을 직접 사용, 내부 리뷰는 contextPath 사용 --%>
																			<c:choose>
																				<c:when test="${isExternal}">
																					<img src="${imagePath}" alt="리뷰 사진"
																						class="w-full h-full object-cover rounded-lg cursor-pointer image-lightbox-trigger" />
																				</c:when>
																				<c:otherwise>
																					<img
																						src="${pageContext.request.contextPath}/images/${imagePath}"
																						alt="리뷰 사진"
																						class="w-full h-full object-cover rounded-lg cursor-pointer image-lightbox-trigger" />
																				</c:otherwise>
																			</c:choose>
																		</div>
																	</c:forEach>
																</div>
																<c:if test="${fn:length(review.images) > 1}">
																	<button class="review-image-arrow prev">&lt;</button>
																	<button class="review-image-arrow next">&gt;</button>
																	<div class="review-image-pagination"></div>
																</c:if>
															</div>
														</c:if>
														<div class="review-content-wrapper mb-4 flex-grow">
															<p
																class="review-text text-slate-700 leading-relaxed truncated break-words">${review.content}</p>
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
														<%-- 외부 리뷰는 좋아요/댓글 기능 미제공 --%>
														<c:if test="${!isExternal}">
															<div
																class="border-t pt-3 text-sm text-slate-500 flex items-center gap-2">
																<button type="button"
																	class="like-btn text-2xl leading-none ${review.likedByCurrentUser ? 'text-red-500' : 'text-slate-300'} ${not empty sessionScope.user ? 'hover:text-red-400' : ''} transition-colors duration-200"
																	data-review-id="${review.id}"
																	${empty sessionScope.user ? 'disabled' : ''}>♥</button>
																<span
																	class="likers-modal-trigger cursor-pointer hover:underline"
																	data-review-id="${review.id}"><strong
																	class="like-count">${review.likes > 0 ? review.likes : 0}</strong>명이
																	좋아합니다</span>
															</div>
															<c:if test="${not empty review.replyContent}">
																<div
																	class="mt-4 pt-4 border-t bg-slate-50 p-4 rounded-lg">
																	<div class="flex items-start text-sm">
																		<span class="font-bold mr-3 text-violet-600">👑&nbsp;사장님&nbsp;답글</span>
																		<div class="flex-1 break-words">
																			<p class="text-slate-800 whitespace-pre-line">${review.replyContent}</p>
																			<c:if test="${not empty review.replyCreatedAt}">
																				<%-- ▼▼▼ [수정 2] .replyCreatedAtAsDate 사용 및 변수명 오류 수정 ▼▼▼ --%>
																				<span><fmt:formatDate
																						value="${review.replyCreatedAtAsDate}"
																						pattern="yy.MM.dd" /></span>
																			</c:if>
																		</div>
																	</div>
																</div>
															</c:if>
															<c:if test="${isOwner and empty review.replyContent}">
																<div class="mt-4 pt-4 border-t border-dashed">
																	<form
																		action="${pageContext.request.contextPath}/review/reply"
																		method="post" class="space-y-2">
																		<input type="hidden" name="reviewId"
																			value="${review.id}"> <input type="hidden"
																			name="restaurantId" value="${restaurant.id}">
																		<textarea name="replyContent" rows="2"
																			placeholder="답글을 작성해주세요..."
																			class="w-full p-2 border rounded-md text-sm"></textarea>
																		<div class="text-right">
																			<button type="submit"
																				class="text-xs bg-sky-600 text-white px-3 py-1 rounded-md hover:bg-sky-700 transition-colors">답글
																				등록</button>
																		</div>
																	</form>
																</div>
															</c:if>
															<div class="mt-4 pt-4 border-t">
																<c:choose>
																    <c:when test="${not empty review.comments and empty review.comments[0].content}">
																        <h4 class="font-bold text-sm mb-3">댓글 (0)</h4>
																        <%-- 첫 번째 댓글 내용이 비어있으면 댓글 목록을 아예 표시하지 않음 --%>
																    </c:when>
																    <c:otherwise>
																        <h4 class="font-bold text-sm mb-3">댓글 (${fn:length(review.comments)})</h4>
																        <div class="space-y-3 mb-4">
																            <c:forEach var="comment" items="${review.comments}">
																                <div class="flex items-start text-sm">
																                    <img
																                        src="${pageContext.request.contextPath}/images/${comment.profileImage}"
																                        alt="${comment.author}"
																                        class="w-8 h-8 rounded-full object-cover mr-3 flex-shrink-0">
																                    <div class="flex-1 bg-gray-100 p-2 rounded-lg">
																                        <a
																                            href="${pageContext.request.contextPath}/feed/user/${comment.userId}"
																                            class="font-bold text-slate-800">${comment.author}</a>
																                        <p class="text-slate-700">${comment.content}</p>
																                    </div>
																                </div>
																            </c:forEach>
																        </div>
																    </c:otherwise>
																</c:choose>
																<c:choose>
																	<c:when test="${not empty sessionScope.user}">
																		<form
																			action="${pageContext.request.contextPath}/review/addComment"
																			method="post" class="flex items-center gap-2">
																			<input type="hidden" name="reviewId"
																				value="${review.id}" /><input type="hidden"
																				name="restaurantId" value="${restaurant.id}" /> <input
																				type="text" name="content"
																				class="w-full p-2 border rounded-lg text-sm"
																				placeholder="댓글을 입력하세요..." required />
																			<button type="submit"
																				class="text-sm bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 whitespace-nowrap">등록</button>
																		</form>
																	</c:when>
																	<c:otherwise>
																		<a href="${pageContext.request.contextPath}/login"
																			class="block w-full p-3 border rounded-lg text-sm text-center text-gray-500 bg-gray-100 hover:bg-gray-200 transition">로그인
																			후 댓글을 작성할 수 있습니다.</a>
																	</c:otherwise>
																</c:choose>
															</div>
														</c:if>
													</div>
												</c:forEach>
											</div>
											<!-- [수정] '더보기' 버튼 컨테이너를 c:when 블록 바깥으로 이동하여 항상 렌더링되도록 합니다. -->
											
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
									<!-- [수정] '더보기' 버튼이 생성될 컨테이너를 이곳으로 이동 -->
									<div id="load-more-container" class="text-center mt-8"></div>
								</section>
								<%-- ▲▲▲ [수정] 리뷰 섹션 끝 ▲▲▲ --%>

								<c:if test="${!isExternal and not empty coupons}">
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
								</c:if>

								<c:if test="${!isExternal}">
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
												<h3 class="text-lg font-bold text-slate-800 mb-4">궁금한
													점을 문의해주세요</h3>
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
																			<c:when test="${empty qna.answer}">답변대기</c:when>
																			<c:otherwise>답변 완료</c:otherwise>
																		</c:choose></span>
																</div>
																<p class="text-slate-800 font-medium break-words">${qna.question}</p>
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
																	<p class="text-slate-800 break-words">${qna.answer}</p>
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
								</c:if>
							</div>

							<div class="space-y-8">
								<section
									class="glass-card p-8 rounded-3xl slide-up map-trigger cursor-pointer">
									<div id="map" class="w-full h-64 rounded-2xl border"></div>
								</section>

								<%-- 1. 서블릿에서 전달받은 reservationSettings 객체를 사용하여 예약 활성화 여부를 체크합니다. --%>
								<c:if test="${reservationSettings.reservation_enabled == true}">
									<form id="reservationForm"
										action="${pageContext.request.contextPath}/reservation/create"
										method="GET">

										<input type="hidden" name="restaurantId"
											value="${restaurant.id}">
										<%-- 2. 사용자가 시간 버튼을 클릭하면 이 hidden input에 값이 저장됩니다. --%>
										<input type="hidden" id="selectedTime" name="reservationTime"
											value="">

										<section class="glass-card p-8 rounded-3xl slide-up"
											style="margin-top: 32px">
											<h3 class="text-2xl font-bold gradient-text mb-6">온라인 예약</h3>

											<div class="space-y-6">
												<div>
													<label class="block text-sm font-bold mb-3 text-slate-700">📅
														날짜</label> <input type="date" name="reservationDate"
														value="<%=java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE)%>"
														class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
												</div>
												<div>
													<label class="block text-sm font-bold mb-3 text-slate-700">👥
														인원</label> <select name="partySize"
														class="w-full p-4 border-2 border-slate-200 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors duration-300">
														<c:forEach var="i"
															begin="${reservationSettings.min_party_size}"
															end="${reservationSettings.max_party_size}">
															<option value="${i}" ${i == 2 ? 'selected' : ''}>${i}명</option>
														</c:forEach>
													</select>
												</div>
												<div>
													<label class="block text-sm font-bold mb-3 text-slate-700">⏰
														예약가능시간</label>
													<div id="time-slots-container"
														class="grid grid-cols-3 gap-2">
														<div id="no-slots-message"
															class="col-span-3 text-center p-4 bg-slate-100 rounded-xl text-slate-500"
															style="display: none;">
															<p>예약 가능한 시간이 없습니다.</p>
														</div>
													</div>
												</div>
												<button type="submit"
													class="w-full btn-primary text-white py-4 rounded-2xl font-bold block text-center pulse-glow">예약하기</button>
											</div>
										</section>
									</form>
								</c:if>
							</div>

						</div>
					</c:when>
					<c:otherwise>
						<div class="glass-card p-12 rounded-3xl text-center fade-in">
							<h2 class="text-2xl font-bold text-slate-700 mb-4">맛집 정보를 찾을
								수 없습니다.</h2>
							<p class="text-slate-500 mb-6">요청하신 맛집이 존재하지 않거나 삭제되었을 수
								있습니다.</p>
							<a href="${pageContext.request.contextPath}/"
								class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">홈으로
								돌아가기</a>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</main>

		<div id="imageLightbox" class="modal-overlay">
			<div class="p-4 relative">
				<button class="modal-close-btn"
					style="top: 0; right: 0; transform: translate(50%, -50%);">&times;</button>
				<img id="lightboxImage" src="" alt="확대된 리뷰 이미지"
					class="max-w-[90vw] max-h-[90vh] rounded-lg shadow-2xl">
			</div>
		</div>

		<div id="likersModal" class="modal-overlay" style="display: none;">
			<div
				class="bg-white rounded-lg w-full max-w-sm max-h-[60vh] flex flex-col">
				<div class="p-4 border-b text-center relative">
					<h3 class="font-bold">좋아요</h3>
					<button class="modal-close-btn absolute top-2 right-2">&times;</button>
				</div>
				<div id="likersList" class="p-4 overflow-y-auto"></div>
			</div>
		</div>

		<div id="reviewReportModal" class="modal-overlay"
			style="display: none;">
			<div
				class="bg-white rounded-2xl w-full max-w-md p-6 relative shadow-xl">
				<button type="button" class="modal-close-btn">&times;</button>
				<h3 class="text-xl font-bold text-slate-900 mb-2">리뷰 신고</h3>
				<p class="text-sm text-slate-500 mb-4">문제가 있는 리뷰를 알려주시면 운영팀이 검토
					후 조치합니다.</p>
				<div id="reportTargetWrapper" class="text-sm text-slate-600 mb-4"
					style="display: none;">
					<span class="font-semibold text-slate-800"
						id="reportTargetNickname"></span>님의 리뷰를 신고합니다.
				</div>
				<form id="reviewReportForm" class="space-y-5">
					<input type="hidden" id="reportReviewId" name="reviewId" value="">
					<fieldset class="space-y-3">
						<legend class="text-sm font-semibold text-slate-700">신고
							사유</legend>
						<label class="flex items-center gap-2 text-sm text-slate-600">
							<input type="radio" name="reportReason" value="스팸/홍보성 내용"
							class="h-4 w-4 border-slate-300"> 스팸/홍보성 내용
						</label> <label class="flex items-center gap-2 text-sm text-slate-600">
							<input type="radio" name="reportReason" value="부적절한 언어 및 비속어"
							class="h-4 w-4 border-slate-300"> 부적절한 언어 및 비속어
						</label> <label class="flex items-center gap-2 text-sm text-slate-600">
							<input type="radio" name="reportReason" value="허위 정보 또는 사실 왜곡"
							class="h-4 w-4 border-slate-300"> 허위 정보 또는 사실 왜곡
						</label> <label class="flex items-center gap-2 text-sm text-slate-600">
							<input type="radio" name="reportReason" value="개인정보 노출"
							class="h-4 w-4 border-slate-300"> 개인정보 노출
						</label> <label class="flex items-center gap-2 text-sm text-slate-600">
							<input type="radio" name="reportReason" value="기타 문제"
							class="h-4 w-4 border-slate-300"> 기타 문제 (추가 설명 필수)
						</label>
					</fieldset>
					<div>
						<label for="reportReasonDetail"
							class="text-sm font-semibold text-slate-700">추가 설명 (선택,
							'기타 문제' 선택 시 필수)</label>
						<textarea id="reportReasonDetail"
							class="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm focus:border-blue-500 focus:outline-none"
							rows="4" maxlength="500"
							placeholder="신고 사유를 자세히 입력해 주세요. (최대 500자)"></textarea>
						<p class="mt-1 text-xs text-slate-400">허위 신고는 이용 제한 사유가 될 수
							있습니다.</p>
						<p id="reportReasonCounter"
							class="mt-1 text-xs text-slate-400 text-right">0 / 500</p>
					</div>
					<div class="flex items-center justify-end gap-3">
						<button type="button" id="cancelReportBtn"
							class="px-4 py-2 text-sm font-medium text-slate-500 hover:text-slate-700">취소</button>
						<button type="submit" id="reviewReportSubmit"
							data-default-text="신고하기"
							class="px-5 py-2.5 rounded-lg bg-red-500 text-white text-sm font-semibold shadow hover:bg-red-600 transition-colors">신고하기</button>
					</div>
				</form>
			</div>
		</div>

		<div id="mapModal" class="modal-overlay" style="display: none;"
			onclick="this.style.display='none'">
			<div class="bg-white rounded-xl w-full max-w-4xl h-[80vh] relative"
				onclick="event.stopPropagation()">
				<div id="modalMapContainer"
					style="width: 100%; height: 100%; border-radius: 0.75rem;"></div>
				<button class="modal-close-btn"
					onclick="document.getElementById('mapModal').style.display='none'">&times;</button>
			</div>
		</div>

		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
		<c:if test="${not empty restaurant}">
			<a href="#reservationForm" class="floating-action-btn">🎯 예약하기</a>
		</c:if>
	</div>

	<div id="imageZoomModal" class="modal-overlay hidden"
		style="background-color: rgba(0, 0, 0, 0.9); display: none;">
		<button id="closeZoomModalBtn" class="modal-close-btn close-x"
			style="position: absolute; top: 2rem; right: 2rem; font-size: 3rem; color: white;">×</button>
		<div class="modal-content"
			style="padding: 0; background: none; box-shadow: none;">
			<img id="zoomedImage" src="" alt="확대 이미지"
				style="max-width: 90vw; max-height: 90vh; object-fit: contain;">
		</div>
	</div>
	<script>
	// =========================================================================
	// 전역 변수 및 헬퍼 함수
	// =========================================================================
	const contextPath = "${pageContext.request.contextPath}";
	const isLoggedIn = ${not empty sessionScope.user};
	const currentUserId = <c:out value="${sessionScope.user.id}" default="null"/>;
	const $reviewReportModal = $('#reviewReportModal');
	const $reviewReportForm = $('#reviewReportForm');
	const $reportReviewId = $('#reportReviewId');
	const $reportReasonDetail = $('#reportReasonDetail');
	const $reportReasonCounter = $('#reportReasonCounter');
	const $reportTargetWrapper = $('#reportTargetWrapper');
	const $reportTargetNickname = $('#reportTargetNickname');
	const $cancelReportBtn = $('#cancelReportBtn');
	const $reviewReportSubmit = $('#reviewReportSubmit');
	const defaultReportSubmitText = $reviewReportSubmit.data('default-text') || $reviewReportSubmit.text();
	let isSubmittingReport = false;

	function setReportSubmittingState(submitting) {
		if (!$reviewReportSubmit.length) {
			return;
		}
		isSubmittingReport = submitting;
		if (submitting) {
			$reviewReportSubmit.prop('disabled', true)
				.addClass('opacity-60 cursor-not-allowed')
				.text('신고 접수 중...');
		} else {
			$reviewReportSubmit.prop('disabled', false)
				.removeClass('opacity-60 cursor-not-allowed')
				.text(defaultReportSubmitText);
		}
	}

	function resetReviewReportForm(reviewId) {
		if (!$reviewReportForm.length) {
			return;
		}
		$reviewReportForm[0].reset();
		if ($reportReviewId.length) {
			$reportReviewId.val(reviewId || '');
		}
		if ($reportReasonDetail.length) {
			$reportReasonDetail.val('');
		}
		if ($reportReasonCounter.length) {
			$reportReasonCounter.text('0 / 500');
		}
		$('input[name="reportReason"]').prop('checked', false);
		setReportSubmittingState(false);
	}

	function openReviewReportModal(reviewId, authorName) {
		resetReviewReportForm(reviewId);
		if ($reportTargetWrapper.length) {
			if (authorName) {
				$reportTargetNickname.text(authorName);
				$reportTargetWrapper.show();
			} else {
				$reportTargetWrapper.hide();
			}
		}
		if ($reviewReportModal.length) {
			$reviewReportModal.css('display', 'flex');
		}
	}

	function closeReviewReportModal() {
		if ($reviewReportModal.length) {
			$reviewReportModal.hide();
		}
	}
	// ✨ [추가] 모달 닫기 버튼에 대한 공통 이벤트 핸들러
	$('.modal-close-btn').on('click', function() {
		$(this).closest('.modal-overlay').hide();
	});

	if ($reportReasonDetail.length) {
		$reportReasonDetail.on('input', function() {
			if ($reportReasonCounter.length) {
				const currentLength = $(this).val().length;
				$reportReasonCounter.text(currentLength + ' / 500');
			}
		});
	}

	if ($cancelReportBtn.length) {
		$cancelReportBtn.on('click', function() {
			closeReviewReportModal();
		});
	}

	if ($reviewReportForm.length) {
		$reviewReportForm.on('submit', function(event) {
			event.preventDefault();
			if (isSubmittingReport) {
				return;
			}
			if (!isLoggedIn) {
				alert('로그인이 필요합니다.');
				window.location.href = contextPath + '/login';
				return;
			}
			const reviewIdValue = $reportReviewId.val();
			const parsedReviewId = parseInt(reviewIdValue, 10);
			if (Number.isNaN(parsedReviewId)) {
				alert('신고 대상 리뷰를 찾을 수 없습니다.');
				return;
			}
			const selectedReason = $('input[name="reportReason"]:checked').val();
			if (!selectedReason) {
				alert('신고 사유를 선택해주세요.');
				return;
			}
			const detailText = $reportReasonDetail.length ? $reportReasonDetail.val().trim() : '';
			if (selectedReason === '기타 문제' && detailText.length === 0) {
				alert('기타 문제를 선택한 경우 추가 설명을 입력해주세요.');
				return;
			}
			let reasonToSubmit = selectedReason;
			if (detailText.length > 0) {
				reasonToSubmit += ' - ' + detailText;
			}
			if (reasonToSubmit.length > 500) {
				alert('신고 사유는 500자 이내로 입력해주세요.');
				return;
			}
			setReportSubmittingState(true);
			fetch(contextPath + '/review/report', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					reviewId: parsedReviewId,
					reason: reasonToSubmit
				})
			}).then(async response => {
				let data = {};
				try {
					data = await response.json();
				} catch (jsonError) {
					data = {};
				}
				if (response.ok && data.status === 'success') {
					alert(data.message || '신고가 접수되었습니다.');
					closeReviewReportModal();
				} else {
					alert(data.message || '신고 처리 중 오류가 발생했습니다.');
				}
				setReportSubmittingState(false);
			}).catch(error => {
				console.error('Review report error:', error);
				alert('신고 처리 중 오류가 발생했습니다.');
				setReportSubmittingState(false);
			});
		});
	}


    // 예약 시간 선택 함수
    function selectTime(element, time) {
        $('.btn-reserve-time').removeClass('bg-blue-500 text-white border-blue-600')
                             .addClass('bg-slate-100 text-slate-700 border-slate-200');
        $(element).removeClass('bg-slate-100 text-slate-700 border-slate-200')
                  .addClass('bg-blue-500 text-white border-blue-600');
        $('#selectedTime').val(time);
    }

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
	let allImageFiles = [];
	const isExternal = ${isExternal eq true};

	if (isExternal) {
		// [수정] 서블릿에서 제거된 externalImages 대신 restaurant.additionalImages를 사용합니다.
		allImageFiles = [<c:forEach var="imgUrl" items="${restaurant.additionalImages}" varStatus="status">'${imgUrl}'<c:if test="${!status.last}">,</c:if></c:forEach>];
	} else {
		allImageFiles = [ "${restaurant.image}", <c:forEach var="img" items="${restaurant.additionalImages}">'${fn:escapeXml(img)}',</c:forEach> ].filter(Boolean);
	}

	const overlaySection = document.getElementById('imageOverlay');
	const overlayGrid = document.getElementById('overlayGrid');
	const closeOverlayBtn = document.getElementById('closeOverlayBtn'); // 'X' 닫기 버튼
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

	// ✨ 수정된 showImageOverlay 함수
	function showImageOverlay() {
	    if (!overlaySection || !overlayGrid) return;

	    // 오버레이를 열기 전 내용을 깨끗하게 비웁니다.
	    overlayGrid.innerHTML = '';

	    allImageFiles.forEach(fileName => {
	        // 1. 이미지를 감쌀 <div> wrapper를 생성합니다.
	        const wrapper = document.createElement('div');
	        wrapper.className = 'gallery-image-wrapper';

	        // 2. <img> 태그를 생성합니다.
	        const img = document.createElement('img');
	        img.className = 'gallery-image image-lightbox-trigger cursor-pointer';
	        img.src = isExternal ? fileName : '${pageContext.request.contextPath}/images/' + encodeURIComponent(fileName);

	        // 3. 이미지를 wrapper에 넣고, wrapper를 그리드에 추가합니다.
	        wrapper.appendChild(img);
	        overlayGrid.appendChild(wrapper);
	    });

	    // '유령' 요소 추가 로직이 제거되었습니다.

	    overlaySection.classList.add('show');
	}

	// ✨ [수정 1] 누락되었던 오버레이 닫기 함수를 추가합니다.
	function closeImageOverlay() {
		if (overlaySection) {
			overlaySection.classList.remove('show');
		}
	}

	// ✨ [수정 2] 'X' 닫기 버튼에 클릭 이벤트를 연결합니다.
	if (closeOverlayBtn) {
		closeOverlayBtn.addEventListener('click', closeImageOverlay);
	}

	// =========================================================================
	// DOM이 모두 로드된 후 실행될 스크립트 (jQuery 사용)
	// =========================================================================
	$(document).ready(function() {

		// 1. 예약 폼 유효성 검사
		$('#reservationForm').on('submit', function(event) {
			if (!$('#selectedTime').val()) {
				alert('예약 시간을 선택해주세요.');
				event.preventDefault();
			}
		});

		// 2. 글래스 카드 등장 애니메이션
		const observer = new IntersectionObserver((entries) => {
			entries.forEach(entry => {
				if (entry.isIntersecting) {
					$(entry.target).css({
						'opacity': '1',
						'transform': 'translateY(0)'
					});
				}
			});
		}, {
			threshold: 0.1,
			rootMargin: '0px 0px -50px 0px'
		});

		$('.glass-card').css({
			'opacity': '0',
			'transform': 'translateY(30px)',
			'transition': 'opacity 0.6s ease-out, transform 0.6s ease-out'
		}).each(function() {
			observer.observe(this);
		});

		// 3. Q&A 등록 성공 알림 처리
		const urlParams = new URLSearchParams(window.location.search);
		if (urlParams.get('success') === 'qna_added') {
			alert('문의가 성공적으로 등록되었습니다!');
			window.history.replaceState({}, document.title, window.location.pathname);
		}

		// 4. 리뷰 텍스트 "더 보기/접기" 기능
		$('.review-content-wrapper').each(function() {
			const textElement = $(this).find('.review-text');
			const readMoreBtn = $(this).find('.read-more-btn');
			if (textElement.prop('scrollHeight') <= textElement.prop('clientHeight')) {
				readMoreBtn.hide();
			}
			readMoreBtn.on('click', function() {
				textElement.toggleClass('truncated');
				$(this).text(textElement.hasClass('truncated') ? '더 보기' : '접기');
			});
		});

		// 5. 재사용 가능한 캐러셀 설정 함수
		function setupImageCarousel(container) {
			const track = container.querySelector('.review-image-track');
			if (!track) return;

			const prevBtn = container.querySelector('.review-image-arrow.prev');
			const nextBtn = container.querySelector('.review-image-arrow.next');
			const pagination = container.querySelector('.review-image-pagination');
			const images = track.querySelectorAll('.review-image-item');
			const imageCount = images.length;

			if (imageCount <= 1) {
				if (prevBtn) prevBtn.style.display = 'none';
				if (nextBtn) nextBtn.style.display = 'none';
				if (pagination) pagination.style.display = 'none';
				return;
			}

			let currentIndex = 0;

			if (pagination) {
				pagination.innerHTML = '';
				for (let i = 0; i < imageCount; i++) {
					const dot = document.createElement('span');
					dot.classList.add('pagination-dot');
					pagination.appendChild(dot);
				}
			}
			const dots = pagination ? pagination.querySelectorAll('.pagination-dot') : [];

			function updateSliderState(initialIndex = -1) {
				if (initialIndex !== -1) {
					currentIndex = initialIndex;
				}
				track.scrollLeft = images[0].offsetWidth * currentIndex;
				if (dots.length > 0) {
					dots.forEach((dot, index) => dot.classList.toggle('active', index === currentIndex));
				}
				if (prevBtn) prevBtn.disabled = currentIndex === 0;
				if (nextBtn) nextBtn.disabled = currentIndex === imageCount - 1;
			}

			if (nextBtn) nextBtn.addEventListener('click', (e) => {
				e.stopPropagation();
				if (currentIndex < imageCount - 1) {
					currentIndex++;
					updateSliderState();
				}
			});

			if (prevBtn) prevBtn.addEventListener('click', (e) => {
				e.stopPropagation();
				if (currentIndex > 0) {
					currentIndex--;
					updateSliderState();
				}
			});

			let scrollTimeout;
			track.addEventListener('scroll', () => {
				clearTimeout(scrollTimeout);
				scrollTimeout = setTimeout(() => {
					const newIndex = Math.round(track.scrollLeft / images[0].offsetWidth);
					if (newIndex !== currentIndex) {
						currentIndex = newIndex;
						updateSliderState();
					}
				}, 150);
			});
			updateSliderState();
		}

		document.querySelectorAll('.review-image-container').forEach(setupImageCarousel);

		// 6. '리뷰 더보기' 기능 (2개씩 보여주기)
		const reviewContainer = document.getElementById('review-list-container');
		if (reviewContainer) {
			// [수정] JSP 변수에서 전체 리뷰 개수를 가져옵니다.
			const totalReviews = parseInt('${isExternal ? fn:length(restaurant.reviews) : fn:length(reviews)}', 10) || 0;
			const reviewItems = Array.from(reviewContainer.querySelectorAll('.review-item'));
			const loadMoreCount = 2;
			let shownCount = 0;

			// 모든 리뷰를 초기에 숨깁니다.
			reviewItems.forEach(review => review.style.display = 'none');

			function showMoreReviews() {
				const nextReviews = reviewItems.slice(shownCount, shownCount + loadMoreCount);
				nextReviews.forEach(review => review.style.display = 'block');
				shownCount += nextReviews.length;

				if (shownCount >= reviewItems.length) { // [수정] 화면에 렌더링된 아이템 기준으로 변경
					$('#load-more-container').hide();
				}
			}

			// 초기에 2개 리뷰를 먼저 보여줍니다.
			if (totalReviews > 0) {
				showMoreReviews();
			}


			// [수정] JSP에서 가져온 totalReviews를 기준으로 '더보기' 버튼 표시 여부를 결정합니다.
			if (totalReviews > 2) {
				const loadMoreContainer = document.getElementById('load-more-container');
				if (loadMoreContainer) {
					$(loadMoreContainer).html('<button id="load-more-reviews-btn" class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">리뷰 더보기</button>').show();
					$('#load-more-reviews-btn').on('click', showMoreReviews);
				}
			}
		}
		

		// 7. 필요한 변수 선언
		const imageLightbox = document.getElementById('imageLightbox');
		const lightboxImage = document.getElementById('lightboxImage');
		const mapModal = document.getElementById('mapModal');
		const mapTriggerSection = document.querySelector('.map-trigger');

		// 8. 카카오맵 스크립트
		if (mapTriggerSection && typeof kakao !== 'undefined' && kakao.maps) {
			let mapInitialized = false;
			const mapObserver = new IntersectionObserver((entries, observer) => {
				if (entries[0].isIntersecting && !mapInitialized && kakao.maps.load) {
					mapInitialized = true;
					kakao.maps.load(() => {
						const lat = parseFloat("${restaurant.latitude}");
						const lon = parseFloat("${restaurant.longitude}");
						const defaultLat = 37.566826;
						const defaultLon = 126.9786567;
						const isValidCoord = !isNaN(lat) && !isNaN(lon) && lat !== 0 && lon !== 0;
						const mapCenter = new kakao.maps.LatLng(isValidCoord ? lat : defaultLat, isValidCoord ? lon : defaultLon);
						let pageMap = null;
						let modalMap = null;
						const mapContainer = document.getElementById('map');
						if (mapContainer) {
							const mapOption = {
								center: mapCenter,
								level: 3
							};
							pageMap = new kakao.maps.Map(mapContainer, mapOption);
							const marker = new kakao.maps.Marker({
								position: mapCenter
							});
							marker.setMap(pageMap);
						}
						if (mapTriggerSection && mapModal) {
							mapTriggerSection.addEventListener('click', function() {
								mapModal.style.display = 'flex';
								const modalMapContainer = document.getElementById('modalMapContainer');
								if (!modalMap && modalMapContainer) {
									const mapOption = {
										center: mapCenter,
										level: 3
									};
									modalMap = new kakao.maps.Map(modalMapContainer, mapOption);
									const marker = new kakao.maps.Marker({
										position: mapCenter
									});
									marker.setMap(modalMap);
								} else if (modalMap) {
									setTimeout(() => {
										modalMap.relayout();
										modalMap.setCenter(mapCenter);
									}, 0);
								}
							});
						}
					});
					observer.unobserve(mapTriggerSection);
				}
			});
			mapObserver.observe(mapTriggerSection);
		}

		// 9. 모든 동적 클릭 이벤트를 관리하는 최종 핸들러
		$(document).on('click', function(e) {
			const $target = $(e.target);

			// --- 이미지 라이트박스 열기 ---
			if ($target.hasClass('image-lightbox-trigger')) {
				e.stopPropagation();
				const imageSrc = $target.attr('src');
				if (imageSrc) {
					$('#lightboxImage').attr('src', imageSrc);
					$('#imageLightbox').css('display', 'flex');
				}
			}

			// ✨ [수정] 모달 닫기 로직은 상단 공통 핸들러로 이동

			// --- 좋아요 버튼 클릭 처리 ---
			if (e.target.closest('.like-btn')) {
				if (!isLoggedIn) {
					alert('로그인이 필요합니다.');
					window.location.href = contextPath + "/login";
					return;
				}
				const button = e.target.closest('.like-btn');
				const $button = $(button);
				const reviewId = button.dataset.reviewId;

				fetch(contextPath +"/review/like", {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ reviewId: reviewId })
				})
				.then(response => response.json())
				.then(data => {
					if (data.status === 'success') {
						const $likeCountSpan = $button.parent().find('.like-count');
						$likeCountSpan.text(data.newLikeCount);

						if (data.isLiked) {
							$button.addClass('text-red-500').removeClass('text-slate-300');
						} else {
							$button.addClass('text-slate-300').removeClass('text-red-500');
						}
						// ✨ [추가] 좋아요 목록 트리거 텍스트도 업데이트
						$button.parent().find('.likers-modal-trigger').html('<strong class="like-count">' + data.newLikeCount + '</strong>명이 좋아합니다');
					} else {
						alert(data.message || '오류가 발생했습니다.');
					}
				})
				.catch(error => console.error('Like fetch error:', error));
			}

			// --- 좋아요 목록 모달 열기 ---
			if (e.target.closest('.likers-modal-trigger')) {
				e.preventDefault();
				const $trigger = $(e.target.closest('.likers-modal-trigger'));
				const reviewId = $trigger.data('review-id');
				const $likersList = $('#likersList');
				$likersList.html('<div class="text-center">로딩 중...</div>');
				document.getElementById('likersModal').style.display = 'flex';

				fetch(contextPath + "/review/getLikers/" + reviewId)
					.then(response => response.json())
					.then(likers => {
						likersList.innerHTML = '';
						if (!likers || likers.length === 0) {
							$likersList.html('<div class="text-center text-gray-500">아직 좋아요가 없습니다.</div>');
							return;
						}
						$likersList.empty(); // 목록 비우기
						likers.forEach(liker => {
							let followButtonHtml = '';
							if (isLoggedIn && liker.id !== currentUserId) {
								const isFollowing = liker.isFollowing;
								const btnClass = isFollowing ? 'bg-gray-200 text-gray-700' : 'bg-blue-500 text-white';
								const btnText = isFollowing ? '팔로잉' : '팔로우';
								followButtonHtml = '<button class="follow-btn text-xs font-bold py-1 px-3 rounded-full ' + btnClass + '" data-user-id="' + liker.id + '">' + btnText + '</button>';
							}

							const likerHtml =
								'<div class="flex items-center justify-between py-2 user-row" data-user-id="' + liker.id + '">' +
									'<div class="flex items-center">' +
										'<a href="' + contextPath + '/feed/user/' + liker.id + '">' + // [수정] /images/ 경로가 mytag:image 에서 자동으로 붙으므로 여기서는 제거
											'<img src="' + contextPath + '/images/' + liker.profileImage + '" alt="' + liker.nickname + '" class="w-10 h-10 rounded-full object-cover mr-3">' +
										'</a>' +
										'<div><a href="' + contextPath + '/feed/user/' + liker.id + '" class="font-bold text-slate-800">' + liker.nickname + '</a></div>' +
									'</div>' +
									'<div class="follow-btn-container">' + followButtonHtml + '</div>' +
								'</div>';
							$likersList.append(likerHtml);
						});
					})
					.catch(error => {
						console.error('Likers fetch error:', error);
						$likersList.html('<div class="text-center text-red-500">목록을 불러오는데 실패했습니다.</div>');
					});
			}

			// --- 팔로우 버튼 클릭 (페이지 + 모달 공통) ---
			if ($target.hasClass('follow-btn')) {
				if (!isLoggedIn) {
					alert('로그인이 필요합니다.');
					window.location.href = contextPath + '/login';
					return;
				}
				const userIdToFollow = $target.data('user-id');

				$.post(contextPath + '/user/follow', {
						userId: userIdToFollow
					})
					.done(function(data) {
						if (data.status === 'success') {
							// [수정] 클릭된 버튼과 동일한 사용자의 모든 팔로우 버튼을 찾아 상태를 업데이트합니다.
							const $buttonsToUpdate = $(`.follow-btn[data-user-id="${userIdToFollow}"]`);
							
							if (data.isFollowing) {
								$buttonsToUpdate.text('팔로잉').removeClass('bg-blue-500 text-white').addClass('bg-gray-200 text-gray-700');
							} else {
								$buttonsToUpdate.text('팔로우').removeClass('bg-gray-200 text-gray-700').addClass('bg-blue-500 text-white');
							}
						}
					}).fail(function(xhr) {
						if (xhr.status === 401) {
							alert('로그인이 필요합니다.');
							window.location.href = contextPath + '/login';
						} else {
							alert('오류가 발생했습니다.');
						}
					});
			}

			// --- 모든 모달 닫기 처리 ---
			if (e.target.classList.contains('modal-overlay') || e.target.closest('.modal-close-btn')) {
				const modal = e.target.closest('.modal-overlay');
				if (modal) {
					modal.style.display = 'none';
				}
			}
		});
		// 10. 리뷰 '더보기' 메뉴 토글 기능
		$(document).on('click', '.review-options-btn', function(e) {
		    e.stopPropagation(); // 이벤트 전파 중단
		    // 현재 클릭한 메뉴 외에 다른 메뉴는 모두 닫기
		    $('.review-options-dropdown').not($(this).next('.review-options-dropdown')).removeClass('show');
		    // 현재 클릭한 메뉴의 드롭다운 토글
		    $(this).next('.review-options-dropdown').toggleClass('show');
		});

		// 화면의 다른 곳을 클릭하면 모든 '더보기' 메뉴 닫기
		$(document).on('click', function(e) {
		    if (!$(e.target).closest('.review-options-container').length) {
		        $('.review-options-dropdown').removeClass('show');
		    }
		});

		// 11. 리뷰 삭제 버튼 클릭 이벤트
		$(document).on('click', '.review-delete-btn', function() {
		    const reviewId = $(this).data('review-id');
		    const reviewCard = $(this).closest('.review-card-container'); // 각 리뷰를 감싸는 최상위 div 선택자

		    if (confirm("정말로 이 리뷰를 삭제하시겠습니까?")) {
		        fetch(contextPath + "/review/delete", {
		            method: 'POST',
		            headers: { 'Content-Type': 'application/json' },
		            body: JSON.stringify({ id: reviewId }) // 서블릿에서 받을 수 있도록 JSON 형식으로 변경
		        })
		        .then(response => response.json())
		        .then(data => {
		            if (data.success) {
		                alert("리뷰가 삭제되었습니다.");
		                // ✨ 중요: 페이지를 새로고침하여 레스토랑 평점과 리뷰 수를 정확하게 다시 반영합니다.
		                window.location.reload(); 
		            } else {
		                alert(data.message || '리뷰 삭제에 실패했습니다.');
		            }
		        })
		        .catch(error => {
		            console.error('Error:', error);
		            alert('리뷰 삭제 중 오류가 발생했습니다.');
		        });
		    }
		});

		// 12. 리뷰 신고 버튼 클릭 시 신고 모달 열기
		$(document).on('click', '.review-report-btn', function(e) {
			e.preventDefault();
			if (!isLoggedIn) {
				alert('로그인이 필요합니다.');
				window.location.href = contextPath + '/login';
				return;
			}
			const reviewId = $(this).data('review-id');
			const authorName = $(this).data('review-author');
			openReviewReportModal(reviewId, authorName);
		});
		
	});
</script>

							<%-- [ ✨ 핵심 수정 ✨ ] --%>
							<%-- 기존의 <script> 블록을 아래의 코드로 완전히 교체해주세요. --%>
							<script>
// 페이지의 모든 HTML 콘텐츠가 로드된 후에 이 스크립트를 실행합니다. 
    document.addEventListener('DOMContentLoaded', function () {

        // 1. DB의 'time_slots' 컬럼 데이터를 JSP 변수로부터 가져옵니다.
        //    (예: "['09:00', '10:00', '11:00', ...]")
        //    JSTL이 작은따옴표(')를 사용할 수 있으므로, JSON.parse가 인식하도록 쌍따옴표(")로 바꿔줍니다.
        const timeSlotsJsonString = '${reservationSettings.time_slots}'.replace(/'/g, '"');

        const container = document.getElementById('time-slots-container');
        const noSlotsMsg = document.getElementById('no-slots-message');
        
        // 시간 버튼을 생성하는 메인 로직
        if (timeSlotsJsonString && container) {
            let timeSlots = [];
            
            try {
                // 2. JSON 형태의 문자열을 실제 자바스크립트 배열로 변환합니다.
                timeSlots = JSON.parse(timeSlotsJsonString);
            } catch (e) {
                console.error("time_slots 파싱 오류:", e);
                console.error("원본 문자열:", timeSlotsJsonString);
                // 파싱에 실패하면 빈 배열로 처리하여 오류를 방지합니다.
                timeSlots = [];
            }

            // 3. 변환된 배열에 시간이 하나라도 있다면, 화면에 버튼을 추가합니다.
            if (timeSlots.length > 0) {
                let lastCategory = ""; // "오전", "점심", "저녁" 구분을 위한 변수
                
                // 4. 배열을 순회하며 각 시간마다 버튼을 생성합니다.
                timeSlots.forEach(time => {
                    // DB에서 가져온 시간 문자열에서 시간(hour) 부분만 추출합니다.
                    const [h] = time.trim().split(':').map(Number);
                    
                    // 시간에 따라 카테고리를 결정합니다.
                    let currentCategory = (h < 12) ? "오전" : (h < 17) ? "점심" : "저녁";

                    // 첫 카테고리이거나 이전 카테고리와 다를 경우 구분선을 추가합니다.
                    if (lastCategory !== currentCategory) {
                        const divider = document.createElement('div');
                        divider.className = 'col-span-3 flex items-center my-2';
                        divider.innerHTML = '<hr class="flex-grow border-t border-gray-200"><span class="px-2 text-sm text-gray-500">' + currentCategory + '</span><hr class="flex-grow border-t border-gray-200">';
                        container.appendChild(divider);
                        lastCategory = currentCategory;
                    }
                    
                    // 시간 버튼 요소를 생성합니다.
                    const button = document.createElement('button');
                    button.type = 'button';
                    button.className = 'btn-reserve-time bg-slate-100 text-slate-700 border border-slate-200 py-2 px-4 rounded-lg font-medium hover:bg-slate-200 transition-all duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-400'; 
                    button.textContent = time.trim(); // 버튼에 시간 텍스트 표시
                    button.onclick = function() { selectTime(this, time.trim()); }; // 클릭 이벤트 핸들러 연결
                    container.appendChild(button); // 컨테이너에 최종적으로 버튼 추가
                });
            } else {
                // 생성된 시간 슬롯이 없으면, '예약 가능한 시간이 없습니다' 메시지를 표시합니다.
                if (noSlotsMsg) noSlotsMsg.style.display = 'block'; 
            }
        } else {
            // `time_slots` 데이터가 아예 없는 경우에도 메시지를 표시합니다.
            if (noSlotsMsg) noSlotsMsg.style.display = 'block'; 
        }
    });

    // 시간 버튼 클릭 시 호출되는 함수 (이 함수는 수정할 필요 없습니다)
    function selectTime(button, time) {
        // 모든 버튼의 선택 스타일을 초기화합니다.
        document.querySelectorAll('.btn-reserve-time').forEach(btn => {
            btn.classList.remove('bg-blue-500', 'text-white');
            btn.classList.add('bg-slate-100', 'text-slate-700');
        });// 클릭된 버튼에만 선택 스타일을 적용합니다. 
        button.classList.add('bg-blue-500', 'text-white');
        button.classList.remove('bg-slate-100', 'text-slate-700');
        // hidden input에 선택된 시간 값을 저장합니다. 
        document.getElementById('selectedTime').value = time;
    }
</script>
</body>
</html>
