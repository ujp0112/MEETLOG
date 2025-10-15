<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - 나만의 맛집 기록</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
<script src="${pageContext.request.contextPath}/js/main-optimized.js"
	defer></script>
<style>
.page-content {
	animation: fadeIn 0.5s ease-out;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
/* 메인 페이지 리뷰 캐러셀을 위한 CSS */
.main-carousel .review-carousel-track {
	display: flex;
	overflow-x: auto;
	scroll-snap-type: x mandatory;
	scroll-behavior: smooth;
	padding-bottom: 20px;
	-ms-overflow-style: none;
	scrollbar-width: none;
}

.main-carousel .review-carousel-track::-webkit-scrollbar {
	display: none;
}

.main-carousel .review-card-wrapper {
	flex: 0 0 90%;
	scroll-snap-align: start;
	margin-right: 16px;
}

@media ( min-width : 768px) {
	.main-carousel .review-card-wrapper {
		flex-basis: 45%;
	}
}

@media ( min-width : 1024px) {
	.main-carousel .review-card-wrapper {
		flex-basis: 30%;
	}
}

/* [수정] 리뷰 텍스트 생략(...) 스타일 */
.review-content-scrollable {
	display: -webkit-box;
	-webkit-line-clamp: 4; /* 4줄 후 생략 */
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	min-height: 90px; /* 내용이 적을 때도 최소 높이 확보 */
}
/* 리뷰 카드 관련 스타일 (restaurant-detail.jsp에서 가져옴) */
.review-card {
	background-color: white;
	border-radius: 12px;
	padding: 1.5rem;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	display: flex;
	flex-direction: column;
	height: 100%;
}

.review-author-info {
	display: flex;
	align-items: center;
	margin-bottom: 1rem;
}

.review-author-profile-img {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
	margin-right: 0.75rem;
}

.review-author-name {
	font-weight: 600;
	color: #334155;
}

.review-meta {
	font-size: 0.875rem;
	color: #64748b;
}

.review-image {
	width: 100%;
	height: 180px;
	object-fit: cover;
	border-radius: 8px;
}

/* [새로운 스타일] 리뷰 카드 내 이미지 캐러셀 */
.review-image-container {
	position: relative;
	overflow: hidden;
	/* 내부 요소가 넘치면 숨김 */
}

/* 이미지 트랙: 스크롤바는 숨기고 스크롤 기능은 유지 */
.review-image-track {
	display: flex;
	overflow-x: auto;
	scroll-snap-type: x mandatory;
	scroll-behavior: smooth; /* JS로 제어 시 부드러운 효과 */
	-ms-overflow-style: none; /* IE and Edge */
	scrollbar-width: none;
	/* Firefox */
}

.review-image-track::-webkit-scrollbar {
	display: none; /* Chrome, Safari, Opera */
}

/* 개별 이미지 아이템 */
.review-image-item {
	flex: 0 0 100%;
	/* 너비를 100%로 설정해 한 장씩 보이게 함 */
	scroll-snap-align: center;
	/* 스크롤 시 중앙에 맞춰 정렬 */
}

/* 좌/우 화살표 버튼 */
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
	opacity: 0; /* 평소에는 숨김 */
	transition: opacity 0.2s ease-in-out;
}
/* 이미지 컨테이너에 마우스를 올리면 버튼이 나타남 */
.review-image-container:hover .review-image-arrow {
	opacity: 1;
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

/* 페이지네이션(점) 스타일 */
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

.review-text {
	font-size: 0.95rem;
	color: #475569;
	line-height: 1.6;
	margin-bottom: 0.5rem;
}

.review-text.truncated {
	display: -webkit-box;
	-webkit-line-clamp: 3;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.read-more-btn {
	background: none;
	border: none;
	color: #64748b;
	font-size: 0.875rem;
	font-weight: 600;
	cursor: pointer;
	align-self: flex-start;
	padding: 0.25rem 0;
}

/* [추가] 모달(팝업창)을 위한 스타일 */
.modal-overlay {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.7);
	z-index: 1000;
	display: none; /* 기본 숨김 */
	justify-content: center;
	align-items: center;
}

.modal-content {
	background: white;
	padding: 2rem;
	border-radius: 12px;
	position: relative;
	max-width: 90vw;
	max-height: 90vh;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	animation: zoomIn 0.3s ease-out;
}

@
keyframes zoomIn {from { transform:scale(0.9);
	opacity: 0;
}

to {
	transform: scale(1);
	opacity: 1;
}

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
}

.carousel-arrow {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	background-color: rgba(255, 255, 255, 0.8);
	border: 1px solid #e2e8f0;
	border-radius: 50%;
	width: 40px;
	height: 40px;
	font-size: 1.5rem;
	cursor: pointer;
	z-index: 10;
	display: flex;
	align-items: center;
	justify-content: center;
}

.carousel-arrow.prev {
	left: -20px;
}

.carousel-arrow.next {
	right: -20px;
}

.carousel-arrow:disabled {
	opacity: 0.3;
	cursor: not-allowed;
}

/* 로딩 스피너 스타일 */
.spinner {
	display: inline-block;
	width: 1rem;
	height: 1rem;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: white;
	border-radius: 50%;
	animation: spin 0.6s linear infinite;
}

@
keyframes spin {to { transform:rotate(360deg);
	
}

}
.btn-loading {
	position: relative;
	color: transparent !important;
	pointer-events: none;
}

.btn-loading::after {
	content: '';
	position: absolute;
	width: 1rem;
	height: 1rem;
	top: 50%;
	left: 50%;
	margin-left: -0.5rem;
	margin-top: -0.5rem;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: white;
	border-radius: 50%;
	animation: spin 0.6s linear infinite;
}

.main-search-form {
	display: flex;
	flex-wrap: wrap; /* 작은 화면에서 줄바꿈 허용 */
	gap: 16px;
	align-items: center; /* 요소들을 하단에 정렬 */
}

.search-inputs {
	flex: 1; /* 남는 공간을 모두 차지 */
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
	/* 반응형 그리드 */
	gap: 16px;
	min-width: 200px;
}

.search-inputs .input-group.keyword-group {
	grid-column: 1/-1; /* 키워드 입력창은 항상 한 줄 전체 차지 */
	align-items: end;
}

@media ( min-width : 1024px) {
	.search-inputs .input-group.keyword-group {
		grid-column: span 2; /* 넓은 화면에서는 키워드 입력창이 2칸 차지 */
	}
}

.search-inputs .input-group label {
	display: block;
	font-size: 0.875rem;
	font-weight: 500;
	color: #475569; /* slate-600 */
	margin-bottom: 4px;
}

.search-inputs .input-group input, .search-inputs .input-group select {
	width: 100%;
	border-radius: 0.375rem; /* rounded-md */
	border: 1px solid #cbd5e1; /* slate-300 */
	padding: 0.5rem 0.75rem;
	font-size: 1rem;
	transition: border-color 0.2s, box-shadow 0.2s;
}

.search-inputs .input-group input:focus, .search-inputs .input-group select:focus
	{
	border-color: #3b82f6; /* blue-500 */
	box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.4);
	outline: none;
}

.search-actions {
	display: flex;
	flex-direction: column; /* 버튼을 수직으로 쌓음 */
	gap: 8px;
	width: 140px; /* 버튼 그룹 너비 고정 */
}

.search-actions button {
	width: 100%;
	padding: 0.75rem 1rem;
	border-radius: 0.5rem; /* rounded-lg */
	font-weight: 600;
	text-align: center;
	transition: all 0.2s;
	cursor: pointer;
}

/* "맛집 찾기" 버튼 (메인 액션) */
.search-actions .btn-main-search {
	background-color: #3b82f6; /* blue-600 */
	color: white;
	border: 2px solid #3b82f6;
}

.search-actions .btn-main-search:hover {
	background-color: #2563eb; /* blue-700 */
	border-color: #2563eb;
}

/* "지도로 검색" 버튼 (보조 액션) */
.search-actions .btn-map-search {
	background-color: white;
	color: #3b82f6; /* blue-600 */
	border: 2px solid #3b82f6;
}

.search-actions .btn-map-search:hover {
	background-color: #eff6ff; /* blue-50 */
}

/* 작은 화면 대응 */
@media ( max-width : 768px) {
	.main-search-form {
		flex-direction: column;
		align-items: stretch; /* 요소들을 양 옆으로 꽉 채움 */
	}
	.search-actions {
		flex-direction: row; /* 버튼을 수평으로 배치 */
		width: 100%;
	}
	.search-actions button {
		flex: 1; /* 버튼이 공간을 똑같이 나눠가짐 */
	}
}
</style>
</head>
<body class="bg-slate-50">
	<!-- Skip to content link for accessibility -->
	<a href="#main-content" class="sr-only">본문으로 바로가기</a>

	<div id="app" class="flex flex-col min-h-screen">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<main id="main-content" role="main" aria-label="메인 콘텐츠"
			class="flex-grow bg-slate-50">
			<h1 class="sr-only">MEET LOG 메인 페이지</h1>

			<!-- Hero Section: 가치 제안 + 빠른 검색 -->
			<jsp:include page="/WEB-INF/views/sections/hero-search.jsp" />

			<div
				class="mx-auto flex w-full max-w-7xl flex-col gap-16 px-4 pb-16 md:px-6 lg:px-8">
				<!-- 상세 검색 섹션 (Progressive Disclosure) -->
				<section id="advancedSearchSection"
					class="hidden rounded-3xl border border-slate-200 bg-white px-6 py-8 shadow-xl"
					aria-labelledby="search-title" aria-hidden="true">
					<h2 id="search-title" class="text-2xl font-bold mb-6 text-center">나에게
						꼭 맞는 맛집 찾기</h2>

					<%-- [수정] 폼 전체 구조 변경 --%>
					<form id="detailSearchForm"
						action="${pageContext.request.contextPath}/restaurant/list"
						method="get" class="main-search-form" role="search"
						onsubmit="return handleFormSubmit(event, this)">

						<%-- 1. 입력 필드 그룹 --%>
						<div class="search-inputs">
							<div class="input-group keyword-group">
								<label for="mainSearchKeyword">키워드 <span
									class="text-xs text-slate-500 font-normal">(선택)</span></label> <input
									id="mainSearchKeyword" name="keyword" type="text"
									placeholder="예: 강남 한식, 홍대 카페" autocomplete="off">
							</div>
							<div class="input-group">
								<label>음식 종류</label> <select name="category">
									<option value="">전체</option>
									<option value="한식">한식</option>
									<option value="양식">양식</option>
									<option value="일식">일식</option>
									<option value="중식">중식</option>
									<option value="카페">카페</option>
								</select>
							</div>
							<div class="input-group">
								<label>가격대 (1인)</label> <select name="price">
									<option value="">전체</option>
									<option value="1">~1만원</option>
									<option value="2">1~2만원</option>
									<option value="3">2~4만원</option>
									<option value="4">4만원~</option>
								</select>
							</div>
							<div class="input-group">
								<label>주차 여부</label> <select name="parking">
									<option value="">전체</option>
									<option value="true">가능</option>
									<!-- <option value="false">불가</option> -->
								</select>
							</div>
						</div>

						<%-- 2. 버튼 그룹 --%>
						<div class="search-actions">
							<button id="mapSearchBtn" type="button"
								class="btn-map-search js-map-search-btn">지도로 검색</button>
							<button type="submit" class="btn-main-search">맛집 찾기</button>
						</div>

					</form>
				</section>
				<!-- 로그인 사용자용 레이아웃 -->
				<c:if test="${not empty user}">
					<!-- 1. 맞춤 추천 (최우선) -->
					<jsp:include
						page="/WEB-INF/views/sections/personalized-recommendations.jsp" />
<%-- 
					<!-- 2. 실시간 랭킹 -->
					<jsp:include page="/WEB-INF/views/sections/ranking.jsp" /> --%>
				</c:if>

				<!-- 비로그인 사용자용 로그인 유도 -->
				<c:if test="${empty user}">
					<jsp:include page="/WEB-INF/views/sections/login-cta.jsp" />
				</c:if>
				
				<!-- 비로그인 사용자용 레이아웃 -->
				<c:if test="${empty user}">
					<!-- 1. 실시간 랭킹 -->
					<jsp:include page="/WEB-INF/views/sections/ranking.jsp" />
				</c:if>

				<%-- 생생한 최신 리뷰 섹션 --%>
				<section class="mb-16" aria-labelledby="reviews-title">
					<div class="flex justify-between items-center mb-6">
						<h2 id="reviews-title" class="text-2xl font-bold text-slate-800">생생한
							최신 리뷰</h2>
					</div>

					<div class="relative group">
						<div id="mainReviewCarouselTrack"
							class="flex overflow-x-auto snap-x snap-mandatory pb-5 -mx-4 px-4"
							role="region" aria-label="최신 리뷰 캐러셀" tabindex="0"
							style="scroll-behavior: smooth; scrollbar-width: none; -ms-overflow-style: none;">

							<c:forEach var="review" items="${recentReviews}">
								<%-- [수정] 리뷰 카드 클릭 시 상세 모달을 띄우기 위한 데이터 속성 추가 --%>
								<div
									class="flex-shrink-0 w-[90%] md:w-[45%] lg:w-[32%] snap-start pr-4"
									data-review-id="${review.id}">

									<%-- [수정] 카드 자체에 review-card-clickable 클래스 추가 --%>
									<div
										class="bg-white rounded-xl shadow-lg p-5 flex flex-col h-full text-sm cursor-pointer">

										<%-- 상단: 프로필, 작성자, 팔로우 버튼 --%>
										<div class="flex justify-between items-center mb-3">
											<div class="flex items-center ">
												<mytag:image fileName="${review.profileImage}"
													altText="${review.author} 프로필"
													cssClass="w-10 h-10 rounded-full object-cover mr-3" />
												<span class="font-semibold text-slate-800">${review.author}</span>
											</div>
											<!-- <button
											class="text-xs font-semibold bg-slate-100 text-slate-600 px-3 py-1 rounded-full hover:bg-slate-200 stop-propagation">팔로우</button> -->
										</div>

										<%-- 중상단: 별점, 날짜 --%>
										<div
											class="flex items-center gap-2 mb-4 text-xs text-slate-500">
											<div class="text-amber-400 flex">
												<c:forEach begin="1" end="5" var="i">
													<c:if test="${i <= review.rating}">★</c:if>
													<c:if test="${i > review.rating}">
														<span class="text-slate-300">★</span>
													</c:if>
												</c:forEach>
											</div>
											<span>·</span> <span>${fn:replace(fn:substring(review.createdAt.toString(), 0, 10), '-', '.')}</span>
										</div>

										<%-- 중간: 리뷰 이미지 캐러셀 --%>
										<div
											class="review-image-container mb-4 rounded-lg stop-propagation review-card-clickable">
											<div class="review-image-track">
												<c:choose>
													<c:when test="${not empty review.images}">
														<c:forEach var="imagePath" items="${review.images}">
															<div class="review-image-item">
																<mytag:image fileName="${imagePath}" altText="리뷰 사진"
																	cssClass="w-full h-48 object-cover image-lightbox-trigger cursor-zoom-in" />
															</div>
														</c:forEach>
													</c:when>
													<%-- <c:otherwise>
													<div class="review-image-item">
														<mytag:image fileName="https://placehold.co/100x100/fee2e2/b91c1c?text=${review.author }" altText="기본 이미지" cssClass="w-full h-48 object-cover" />
													</div>
												</c:otherwise> --%>
												</c:choose>
											</div>
											<c:if test="${fn:length(review.images) > 1}">
												<button class="review-image-arrow prev"
													aria-label="이전 리뷰 이미지">
													<span aria-hidden="true">&lt;</span>
												</button>
												<button class="review-image-arrow next"
													aria-label="다음 리뷰 이미지">
													<span aria-hidden="true">&gt;</span>
												</button>
												<div class="review-image-pagination" role="tablist"
													aria-label="리뷰 이미지 페이지"></div>
											</c:if>
										</div>

										<%-- 하단: 리뷰 내용(스크롤 가능), 키워드, 맛집 정보 링크 --%>
										<div class="flex flex-col flex-grow">
											<%-- [수정] a 태그 제거, 스크롤 가능한 p 태그로 변경 --%>
											<p
												class="review-content-scrollable text-slate-700 leading-relaxed mb-4 flex-grow">${review.content}</p>

											<div class="flex flex-wrap gap-2 my-4">
												<c:forEach var="keyword" items="${review.keywords}">
													<span
														class="text-xs text-blue-600 bg-blue-100 font-semibold px-2 py-1 rounded-full">${keyword}</span>
												</c:forEach>
											</div>

											<div class="mt-auto pt-3 border-t border-slate-100 text-xs">
												<a
													href="${pageContext.request.contextPath}/restaurant/detail/${review.restaurantId}"
													class="font-semibold text-blue-600 hover:text-blue-800 transition-colors flex items-center stop-propagation">
													'<c:out value="${review.restaurantName}" />' 맛집 정보 더 보기 <span
													class="ml-1 font-mono">&gt;</span>
												</a>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>

						<button id="prevMainReviewBtn"
							class="absolute top-1/2 left-2 -translate-y-1/2 bg-white rounded-full w-10 h-10 shadow-md flex items-center justify-center text-xl text-slate-600 disabled:opacity-30 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
							aria-label="이전 리뷰">
							<span aria-hidden="true">&lt;</span>
						</button>
						<button id="nextMainReviewBtn"
							class="absolute top-1/2 right-2 -translate-y-1/2 bg-white rounded-full w-10 h-10 shadow-md flex items-center justify-center text-xl text-slate-600 disabled:opacity-30 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
							aria-label="다음 리뷰">
							<span aria-hidden="true">&gt;</span>
						</button>
					</div>
				</section>
				<section class="my-12" aria-labelledby="columns-title">
					<h2 id="columns-title" class="text-2xl md:text-3xl font-bold mb-6">
						최신 칼럼</h2>
					<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
						<c:choose>
							<c:when test="${not empty latestColumns}">
								<c:forEach var="column" items="${latestColumns}">
									<a
										href="${pageContext.request.contextPath}/column/detail?id=${column.id}"
										class="bg-white p-6 rounded-2xl shadow-lg block hover:shadow-xl transition-shadow duration-300">
										<div class="relative mb-4">
											<mytag:image fileName="${column.image}"
												altText="${column.title}"
												cssClass="w-full h-48 object-cover rounded-xl" />
										</div>
										<div class="flex items-center mb-4">
											<mytag:image fileName="${column.profileImage}"
												altText="${column.author}"
												cssClass="w-12 h-12 rounded-full mr-4 object-cover" />
											<div>
												<p class="font-bold text-slate-800">${column.author}</p>
												<p class="text-sm text-slate-500">
													<c:choose>
														<c:when test="${column.createdAt != null}">
														${column.createdAt.toString().substring(0, 10).replace('-', '.')}
													</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</p>
											</div>
										</div>
										<h3
											class="font-bold text-lg mb-2 h-14 overflow-hidden line-clamp-2">${column.title}</h3>
										<p
											class="text-slate-600 text-sm h-10 overflow-hidden line-clamp-2">${column.summary}</p>
									</a>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<p class="text-slate-500 py-8 md:col-span-3 text-center">최신
									칼럼을 불러오고 있습니다.</p>
							</c:otherwise>
						</c:choose>
					</div>
				</section>
			</div>

			<!-- 쿠팡 파트너스 광고 배너 -->
			<section class="bg-white py-8 border-t border-slate-100">
				<div class="container mx-auto px-4 flex justify-center">
					<div>
						<script src="https://ads-partners.coupang.com/g.js"></script>
						<script>
						new PartnersCoupang.G({"id":930603,"template":"carousel","trackingCode":"AF6566533","width":"680","height":"140","tsource":""});
					</script>
					</div>
				</div>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	</div>

	<div id="imageLightbox" class="modal-overlay">
		<div class="p-4 relative">
			<button class="modal-close-btn"
				style="top: 0; right: 0; transform: translate(50%, -50%);">&times;</button>
			<img id="lightboxImage" src="" alt="확대된 리뷰 이미지"
				class="max-w-[90vw] max-h-[90vh] rounded-lg shadow-2xl">
		</div>
	</div>

	<div id="reviewDetailModal" class="modal-overlay p-4">
		<div class="modal-content w-full max-w-2xl overflow-y-auto">
			<button class="modal-close-btn">&times;</button>
			<div id="reviewDetailContent" class="flex flex-col md:flex-row gap-6">
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/common/loading.jsp" />
	<script>
// 폼 제출 시 로딩 상태 표시
function handleFormSubmit(event, form) {
    const submitBtn = form.querySelector('button[type="submit"]');
    if (submitBtn && !submitBtn.classList.contains('btn-loading')) {
        const originalText = submitBtn.textContent;
        submitBtn.classList.add('btn-loading');
        submitBtn.disabled = true;
        setTimeout(() => {
            submitBtn.classList.remove('btn-loading');
            submitBtn.disabled = false;
            submitBtn.textContent = originalText;
        }, 3000);
    }
    return true;
}

// 상세 검색 토글 함수
function toggleAdvancedSearch() {
    const section = document.getElementById('advancedSearchSection');
    const toggleButton = document.getElementById('advancedSearchToggle');
    if (!section) {
        return;
    }

    const isHidden = section.classList.contains('hidden');
    if (isHidden) {
        section.classList.remove('hidden');
        section.setAttribute('aria-hidden', 'false');
        if (toggleButton) {
            toggleButton.setAttribute('aria-expanded', 'true');
        }
        
        // --- [수정된 스크롤 로직] ---
        // 헤더의 높이를 가져옵니다. (header.jsp의 태그가 header가 아니면 이 부분을 수정해야 할 수 있습니다.)
        const header = document.querySelector('header'); 
        const headerHeight = header ? header.offsetHeight : 80; // 헤더 높이를 못 찾으면 기본값 80px
        const sectionTop = section.getBoundingClientRect().top + window.scrollY;
        
        // 헤더 높이와 추가 여백(20px)을 고려한 위치로 부드럽게 스크롤
        //window.scrollTo({
        //    top: sectionTop - headerHeight - 20,
        //    behavior: 'smooth'
        //});
        
    } else {
        section.classList.add('hidden');
        section.setAttribute('aria-hidden', 'true');
        if (toggleButton) {
            toggleButton.setAttribute('aria-expanded', 'false');
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {
	const mapSearchBtns = document.querySelectorAll('.js-map-search-btn');
	const heroKeywordInput = document.getElementById('heroKeyword');
	const detailSearchForm = document.getElementById('detailSearchForm');

    // 검색 URL로 이동하는 공통 함수
    const performSearch = (lat, lng) => {
        // ✨ [수정] hero 검색창과 상세 검색창의 키워드를 모두 확인
        const heroKeyword = heroKeywordInput ? heroKeywordInput.value : '';
        const detailKeyword = detailSearchForm.querySelector('input[name="keyword"]').value;
        const category = detailSearchForm.querySelector('select[name="category"]').value;
        
        // hero 검색창에 값이 있으면 그것을 우선 사용, 없으면 상세 검색창 값 사용
        const keyword = heroKeyword.trim() || detailKeyword.trim();
        
        const params = new URLSearchParams();
        if (keyword) {
            params.append('keyword', keyword);
        }
        params.append('category', category || '전체');
        
        if (lat && lng) {
            params.append('lat', lat);
            params.append('lng', lng);
        }
        
        const searchUrl = "${pageContext.request.contextPath}/searchRestaurant?" + params.toString();
        window.location.href = searchUrl;
    };

	// 클래스로 찾은 모든 '지도로 검색' 버튼에 이벤트 연결
	mapSearchBtns.forEach(btn => {
        btn.addEventListener('click', function(event) { // '지도로 검색' 버튼 클릭 시
            event.preventDefault();

            // [수정] 위치 정보(lat, lng) 없이 검색을 수행하도록 performSearch 호출
            // performSearch 함수는 내부적으로 키워드와 카테고리 값을 폼에서 읽어 URL을 생성합니다.
            performSearch(null, null);
        });
    });
    
    const detailKeywordInput = document.getElementById('mainSearchKeyword');
	if(detailKeywordInput) {
        detailKeywordInput.addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                document.getElementById('mapSearchBtn').click();
            }
        });
    }

    // --- (이 아래는 기존 캐러셀 및 모달 기능 코드들... 그대로 유지) ---
    const mainReviewTrack = document.getElementById('mainReviewCarouselTrack');
    if (mainReviewTrack && mainReviewTrack.querySelector('.flex-shrink-0')) {
        const prevMainBtn = document.getElementById('prevMainReviewBtn');
        const nextMainBtn = document.getElementById('nextMainReviewBtn');
        const updateMainButtons = () => {
            const scrollLeft = mainReviewTrack.scrollLeft;
            const scrollWidth = mainReviewTrack.scrollWidth;
            const clientWidth = mainReviewTrack.clientWidth;
            prevMainBtn.disabled = scrollLeft < 10;
            nextMainBtn.disabled = scrollLeft >= (scrollWidth - clientWidth - 10);
        };
        nextMainBtn.addEventListener('click', () => {
            const cardWidth = mainReviewTrack.querySelector('.flex-shrink-0').offsetWidth;
            mainReviewTrack.scrollLeft += cardWidth;
        });
        prevMainBtn.addEventListener('click', () => {
            const cardWidth = mainReviewTrack.querySelector('.flex-shrink-0').offsetWidth;
            mainReviewTrack.scrollLeft -= cardWidth;
        });
        mainReviewTrack.addEventListener('scroll', updateMainButtons);
        updateMainButtons();

        // 키보드 방향키로 캐러셀 네비게이션
        mainReviewTrack.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') {
                e.preventDefault();
                prevMainBtn.click();
            } else if (e.key === 'ArrowRight') {
                e.preventDefault();
                nextMainBtn.click();
            }
        });
    }
    
    // 재사용 가능한 캐러셀 설정 함수
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
        
        function updateSliderState() {
            track.scrollLeft = images[0].offsetWidth * currentIndex;
            if (dots.length > 0) {
                 dots.forEach((dot, index) => dot.classList.toggle('active', index === currentIndex));
            }
            if (prevBtn) prevBtn.disabled = currentIndex === 0;
            if (nextBtn) nextBtn.disabled = currentIndex === imageCount - 1;
        }

        if (nextBtn) nextBtn.addEventListener('click', () => {
            if (currentIndex < imageCount - 1) {
                currentIndex++;
                updateSliderState();
            }
        });

        if (prevBtn) prevBtn.addEventListener('click', () => {
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
    
    // 페이지 내 모든 리뷰 카드 캐러셀 초기화
    document.querySelectorAll('.review-image-container').forEach(setupImageCarousel);

    // --- [추가] 모달 공통 기능 ---
    const imageLightbox = document.getElementById('imageLightbox');
    const reviewDetailModal = document.getElementById('reviewDetailModal');

    function closeModal(modal) {
        if (modal) {
            modal.style.display = 'none';
        }
    }

    // 포커스 트랩 함수
    function trapFocus(e, modal) {
        const focusableElements = modal.querySelectorAll('button, a, input, textarea, select, [tabindex]:not([tabindex="-1"])');
        const firstElement = focusableElements[0];
        const lastElement = focusableElements[focusableElements.length - 1];

        if (e.key === 'Tab') {
            if (e.shiftKey && document.activeElement === firstElement) {
                e.preventDefault();
                lastElement.focus();
            } else if (!e.shiftKey && document.activeElement === lastElement) {
                e.preventDefault();
                firstElement.focus();
            }
        }
    }

    function openModal(modal) {
        modal.style.display = 'flex';
        const focusableElements = modal.querySelectorAll('button, a, input, textarea, select, [tabindex]:not([tabindex="-1"])');
        if (focusableElements.length > 0) {
            focusableElements[0].focus();
        }
    }

    // ESC 키로 모달 닫기
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            if (imageLightbox.style.display === 'flex') {
                closeModal(imageLightbox);
            }
            if (reviewDetailModal.style.display === 'flex') {
                closeModal(reviewDetailModal);
            }
        }
    });

    imageLightbox.addEventListener('click', (e) => {
        if (e.target === imageLightbox || e.target.closest('.modal-close-btn')) {
            closeModal(imageLightbox);
        }
    });

    imageLightbox.addEventListener('keydown', (e) => trapFocus(e, imageLightbox));

    reviewDetailModal.addEventListener('click', (e) => {
        if (e.target === reviewDetailModal || e.target.closest('.modal-close-btn')) {
            closeModal(reviewDetailModal);
        }
    });

    reviewDetailModal.addEventListener('keydown', (e) => trapFocus(e, reviewDetailModal));

    // --- [추가] 이미지 라이트박스 기능 ---
    const lightboxImage = document.getElementById('lightboxImage');
    document.querySelectorAll('.image-lightbox-trigger').forEach(img => {
        img.addEventListener('click', function(e) {
            e.stopPropagation(); // 카드 전체 클릭 방지
            lightboxImage.src = this.src;
            openModal(imageLightbox);
        });
    });

    // --- [수정] 리뷰 상세 모달 기능 (데이터 추출 로직 수정) ---
    const reviewDetailContent = document.getElementById('reviewDetailContent');
    document.querySelectorAll('.review-card-clickable').forEach(card => {
        card.addEventListener('click', function(e) {
            // 카드 내 특정 요소(버튼, 링크 등) 클릭 시 모달이 뜨지 않도록 처리
            if (e.target.closest('.stop-propagation')) {
                return;
            }

            // [수정된 부분] e.target 대신 'this'(클릭된 card 자신)를 기준으로 데이터를 안정적으로 추출
            const cardElement = this;
            const author = cardElement.querySelector('.font-semibold').textContent;
            const profileImgSrc = cardElement.querySelector('.flex.items-center img.w-10').src;
            const ratingHtml = cardElement.querySelector('.flex.items-center.gap-2.text-xs').innerHTML;
            const content = cardElement.querySelector('.review-content-scrollable').textContent;
            const restaurantLinkHtml = cardElement.querySelector('.mt-auto a').outerHTML;
            
            const keywordElements = cardElement.querySelectorAll('.flex-wrap span');
            let keywordsHtml = '';
            keywordElements.forEach(k => { keywordsHtml += k.outerHTML; });

            const images = Array.from(cardElement.querySelectorAll('.review-image-item img'));
            let imagesHtml = '';
            if (images.length > 0) {
                imagesHtml = '<div class="review-image-container rounded-lg relative">' +
                                '<div class="review-image-track">';
                images.forEach(img => {
                    imagesHtml += '<div class="review-image-item"><img src="' + img.src + '" class="w-full h-64 object-cover" /></div>';
                });
                imagesHtml += '</div>';
                if (images.length > 1) {
                    imagesHtml += '<button class="review-image-arrow prev">&lt;</button>' +
                                   '<button class="review-image-arrow next">&gt;</button>' +
                                   '<div class="review-image-pagination"></div>';
                }
                imagesHtml += '</div>';
            }

            // 모달 내용 채우기
            reviewDetailContent.innerHTML = 
                '<div class="w-full">' +
                    imagesHtml +
                    '<div class="flex justify-between items-center my-4">' +
                        '<div class="flex items-center">' +
                            '<img src="' + profileImgSrc + '" alt="' + author + '" class="w-12 h-12 rounded-full object-cover mr-3" />' +
                            '<div>' +
                                '<div class="font-bold text-lg">' + author + '</div>' +
                                '<div class="flex items-center text-sm text-slate-500">' + ratingHtml + '</div>' +
                            '</div>' +
                        '</div>' +
                        '<button class="text-sm font-semibold bg-sky-100 text-sky-700 px-4 py-2 rounded-full hover:bg-sky-200">팔로우</button>' +
                    '</div>' +
                    '<div class="flex flex-wrap gap-2 my-4">' + keywordsHtml + '</div>' +
                    '<p class="text-slate-800 leading-relaxed whitespace-pre-wrap">' + content + '</p>' +
                    '<div class="mt-6 pt-4 border-t border-slate-200">' + restaurantLinkHtml + '</div>' +
                '</div>';
            
            // 모달 표시 및 포커스
            openModal(reviewDetailModal);

            // 모달 내 캐러셀이 있다면 초기화
            const modalCarousel = reviewDetailModal.querySelector('.review-image-container');
            if(modalCarousel) {
                setupImageCarousel(modalCarousel);
            }
        });
    });
});
</script>

</body>
</html>
