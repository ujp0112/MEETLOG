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

/* [수정] 리뷰 텍스트 스크롤 스타일 */
.review-content-scrollable {
	max-height: 84px; /* 약 4줄 높이 */
	overflow-y: auto;
	scrollbar-width: thin;
	scrollbar-color: #94a3b8 #e2e8f0;
}

.review-content-scrollable::-webkit-scrollbar {
	width: 5px;
}

.review-content-scrollable::-webkit-scrollbar-track {
	background: #f1f5f9;
	border-radius: 10px;
}

.review-content-scrollable::-webkit-scrollbar-thumb {
	background-color: #94a3b8;
	border-radius: 10px;
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
</style>
</head>
<body class="bg-slate-50">
	<div id="app" class="flex flex-col min-h-screen">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<main class="flex-grow container mx-auto p-4 md:p-8">
			<section class="mb-12">
				<h2 class="text-2xl md:text-3xl font-bold mb-6">🏆 실시간 맛집 랭킹
					TOP 10</h2>
				<div
					class="flex space-x-4 overflow-x-auto pb-4 -mx-4 px-4 horizontal-scroll">
					<c:choose>
						<c:when test="${not empty topRankedRestaurants}">
							<c:forEach var="r" items="${topRankedRestaurants}"
								varStatus="status">
								<a
									href="${pageContext.request.contextPath}/restaurant/detail/${r.id}"
									class="flex-shrink-0 w-60 bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 transition-transform duration-300 group">
									<div class="relative">
										<mytag:image fileName="${r.image}" altText="${r.name}"
											cssClass="w-full h-36 object-cover group-hover:opacity-90 transition-opacity" />
										<div
											class="absolute top-2 left-2 bg-black bg-opacity-60 text-white text-lg font-bold w-8 h-8 flex items-center justify-center rounded-full shadow-lg">
											${status.count}</div>
										<div
											class="absolute bottom-0 left-0 right-0 p-3 bg-gradient-to-t from-black/70 to-transparent">
											<h3 class="text-white text-lg font-bold truncate">${r.name}</h3>
											<p class="text-white text-sm opacity-90">${r.location}</p>
										</div>
									</div>
									<div class="p-3">
										<p class="text-sm text-slate-600 truncate">
											❤️
											<fmt:formatNumber value="${r.likes}" type="number" />
											명이 좋아해요
										</p>
										<div class="text-base font-bold text-sky-600 mt-2">⭐
											${r.rating}점</div>
									</div>
								</a>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<p class="text-slate-500 py-8">인기 맛집 정보를
								불러오고 있습니다.</p>
						</c:otherwise>
					</c:choose>
				</div>
			</section>
			<c:if test="${not empty user}">
				<section class="mb-12">
					<div class="flex justify-between items-center mb-6">
						<h2 class="text-2xl md:text-3xl font-bold">✨
							${user.nickname}님을 위한 맞춤 추천</h2>
						<a
							href="${pageContext.request.contextPath}/recommendation/personalized"
							class="text-sky-600 hover:text-sky-700 font-semibold text-sm">
							더 보기 → </a>
					</div>
					<c:choose>
						<c:when test="${not empty personalizedRecommendations}">
							<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
								<c:forEach var="rec" items="${personalizedRecommendations}"
									varStatus="status">
									<div
										class="bg-white rounded-xl shadow-md overflow-hidden transform hover:-translate-y-1 transition-all duration-300 group">
										<div class="relative">
											<img
												src="${not empty rec.restaurant.image ?
 rec.restaurant.image : 'https://placehold.co/600x400/e2e8f0/64748b?text=MEET+LOG'}"
												alt="${rec.restaurant.name}"
												class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300">
											<div
												class="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full">
												<span class="text-sm font-bold text-green-600"> <fmt:formatNumber
														value="${rec.recommendationScore * 100}" pattern="0" />%
												</span>
											</div>
											<div
												class="absolute top-3 left-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
												✨ 맞춤 추천</div>
										</div>
										<div class="p-4">
											<h3 class="text-lg font-bold text-slate-800 mb-1">${rec.restaurant.name}</h3>
											<p class="text-slate-600 text-sm mb-2">${rec.restaurant.category}
												• ${rec.restaurant.location}</p>
											<div class="flex items-center space-x-2 mb-3">
												<div class="flex space-x-1">
													<c:forEach begin="1" end="5" var="i">
														<c:choose>
															<c:when test="${i <= rec.restaurant.rating}">
																<span class="text-yellow-400 text-sm">★</span>
															</c:when>
															<c:otherwise>
																<span class="text-slate-300 text-sm">☆</span>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</div>
												<span class="text-slate-600 text-sm"> <fmt:formatNumber
														value="${rec.restaurant.rating}" pattern="0.0" />
													(${rec.restaurant.reviewCount}개 리뷰)
												</span>
											</div>
											<div class="bg-blue-50 p-2 rounded-lg mb-3">
												<p class="text-xs text-blue-800">
													<strong>💡 추천 이유:</strong> ${rec.recommendationReason}
												</p>
											</div>
											<a
												href="${pageContext.request.contextPath}/restaurant/detail/${rec.restaurant.id}"
												class="block w-full bg-sky-600 text-white text-center py-2 px-4 rounded-lg hover:bg-sky-700 transition-colors">
												상세보기 </a>
										</div>
									</div>
								</c:forEach>
							</div>
						</c:when>
						<c:otherwise>
							<div class="bg-white p-8 rounded-xl shadow-md text-center">
								<div class="text-4xl mb-4">🤔</div>
								<h3 class="text-lg font-bold text-slate-800 mb-2">아직 추천할
									맛집이 없습니다</h3>
								<p class="text-slate-600 mb-4">더 많은 리뷰를 작성하시면 맞춤 추천을 받을 수
									있습니다.</p>
								<a href="${pageContext.request.contextPath}/restaurant/list"
									class="bg-sky-600 text-white px-6 py-2 rounded-lg hover:bg-sky-700">
									맛집 둘러보기 </a>
							</div>
						</c:otherwise>
					</c:choose>
				</section>
			</c:if>
			<section class="bg-white p-6 rounded-xl my-12 shadow-md">
				<h2 class="text-2xl font-bold mb-6 text-center">나에게 꼭 맞는 맛집 찾기
					🔎</h2>
				<form action="${pageContext.request.contextPath}/restaurant/list"
					method="get"
					class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4 items-end">
					<div class="col-span-2 lg:col-span-2">
						<label class="block text-sm font-medium text-slate-700">키워드</label>
						<input name="keyword" type="text" class="form-input mt-1"
							placeholder="맛집 이름, 지역, 메뉴 등">
					</div>
					<div>
						<label class="block text-sm font-medium text-slate-700">음식
							종류</label> <select name="category" class="form-input mt-1">
							<option value="">전체</option>
							<option value="한식">한식</option>
							<option value="양식">양식</option>
							<option value="일식">일식</option>
							<option value="중식">중식</option>
							<option value="카페">카페</option>
						</select>
					</div>
					<div>
						<label class="block text-sm font-medium text-slate-700">가격대
							(1인)</label> <select name="price" class="form-input mt-1">
							<option value="">전체</option>
							<option value="1">~1만원</option>
							<option value="2">1~2만원</option>
							<option value="3">2~4만원</option>
							<option value="4">4만원~</option>
						</select>
					</div>
					<div>
						<label class="block text-sm font-medium text-slate-700">주차
							여부</label> <select name="parking" class="form-input mt-1">
							<option value="">전체</option>
							<option value="true">가능</option>
							<option value="false">불가</option>
						</select>
					</div>
					<div class="col-span-2 md:col-span-1">
						<button type="submit" class="form-btn-primary w-full">맛집
							찾기</button>
					</div>
				</form>
			</section>
			<%-- 생생한 최신 리뷰 섹션 --%>
			<section class="mb-16">
				<div class="flex justify-between items-center mb-6">
					<h2 class="text-2xl font-bold text-slate-800">생생한 최신 리뷰 📢</h2>
				</div>

				<div class="relative group">
					<div id="mainReviewCarouselTrack"
						class="flex overflow-x-auto snap-x snap-mandatory pb-5 -mx-4 px-4"
						style="scroll-behavior: smooth; scrollbar-width: none; -ms-overflow-style: none;">

						<c:forEach var="review" items="${recentReviews}">
							<%-- [수정] 리뷰 카드 클릭 시 상세 모달을 띄우기 위한 데이터 속성 추가 --%>
							<div class="flex-shrink-0 w-[90%] md:w-[45%] lg:w-[32%] snap-start pr-4"
								data-review-id="${review.id}">
								
								<%-- [수정] 카드 자체에 review-card-clickable 클래스 추가 --%>
								<div
									class="bg-white rounded-xl shadow-lg p-5 flex flex-col h-full text-sm cursor-pointer">

									<%-- 상단: 프로필, 작성자, 팔로우 버튼 --%>
									<div class="flex justify-between items-center mb-3">
										<div class="flex items-center ">
											<mytag:image fileName="profile/${review.profileImage}"
												altText="${review.author} 프로필"
												cssClass="w-10 h-10 rounded-full object-cover mr-3" />
											<span class="font-semibold text-slate-800">${review.author}</span>
										</div>
										<button
											class="text-xs font-semibold bg-slate-100 text-slate-600 px-3 py-1 rounded-full hover:bg-slate-200 stop-propagation">팔로우</button>
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
									<c:if test="${not empty review.images}">
										<div
											class="review-image-container mb-4 rounded-lg stop-propagation review-card-clickable">
											<div class="review-image-track">
												<c:forEach var="imagePath" items="${review.images}">
													<div class="review-image-item">
														<img
															src="${pageContext.request.contextPath}/images/${imagePath}"
															alt="리뷰 사진" class="w-full h-48 object-cover image-lightbox-trigger cursor-zoom-in">
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
											<a href="${pageContext.request.contextPath}/restaurant/detail/${review.restaurantId}"
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
						class="absolute top-1/2 left-2 -translate-y-1/2 bg-white rounded-full w-10 h-10 shadow-md flex items-center justify-center text-xl text-slate-600 disabled:opacity-30 opacity-0 group-hover:opacity-100 transition-opacity duration-300">&lt;</button>
					<button id="nextMainReviewBtn"
						class="absolute top-1/2 right-2 -translate-y-1/2 bg-white rounded-full w-10 h-10 shadow-md flex items-center justify-center text-xl text-slate-600 disabled:opacity-30 opacity-0 group-hover:opacity-100 transition-opacity duration-300">&gt;</button>
				</div>
			</section>
			<section class="my-12">
				<h2 class="text-2xl md:text-3xl font-bold mb-6">📝 최신 칼럼</h2>
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
document.addEventListener('DOMContentLoaded', function() {

    // --- 기존 캐러셀 기능들 ---
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
    
    imageLightbox.addEventListener('click', (e) => {
        if (e.target === imageLightbox || e.target.closest('.modal-close-btn')) {
            closeModal(imageLightbox);
        }
    });

    reviewDetailModal.addEventListener('click', (e) => {
        if (e.target === reviewDetailModal || e.target.closest('.modal-close-btn')) {
            closeModal(reviewDetailModal);
        }
    });

    // --- [추가] 이미지 라이트박스 기능 ---
    const lightboxImage = document.getElementById('lightboxImage');
    document.querySelectorAll('.image-lightbox-trigger').forEach(img => {
        img.addEventListener('click', function(e) {
            e.stopPropagation(); // 카드 전체 클릭 방지
            lightboxImage.src = this.src;
            imageLightbox.style.display = 'flex';
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
                imagesHtml = `<div class="review-image-container rounded-lg relative">
                                <div class="review-image-track">`;
                images.forEach(img => {
                    imagesHtml += `<div class="review-image-item"><img src="${img.src}" class="w-full h-64 object-cover" /></div>`;
                });
                imagesHtml += `</div>`;
                if (images.length > 1) {
                    imagesHtml += `<button class="review-image-arrow prev">&lt;</button>
                                   <button class="review-image-arrow next">&gt;</button>
                                   <div class="review-image-pagination"></div>`;
                }
                imagesHtml += `</div>`;
            }

            // 모달 내용 채우기
            reviewDetailContent.innerHTML = `
                <div class="w-full">
                    ${imagesHtml}
                    <div class="flex justify-between items-center my-4">
                        <div class="flex items-center">
                            <img src="${profileImgSrc}" alt="${author}" class="w-12 h-12 rounded-full object-cover mr-3" />
                            <div>
                                <div class="font-bold text-lg">${author}</div>
                                <div class="flex items-center text-sm text-slate-500">${ratingHtml}</div>
                            </div>
                        </div>
                        <button class="text-sm font-semibold bg-sky-100 text-sky-700 px-4 py-2 rounded-full hover:bg-sky-200">팔로우</button>
                    </div>
                    <div class="flex flex-wrap gap-2 my-4">${keywordsHtml}</div>
                    <p class="text-slate-800 leading-relaxed whitespace-pre-wrap">${content}</p>
                    <div class="mt-6 pt-4 border-t border-slate-200">${restaurantLinkHtml}</div>
                </div>
            `;
            
            // 모달 표시
            reviewDetailModal.style.display = 'flex';
            
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