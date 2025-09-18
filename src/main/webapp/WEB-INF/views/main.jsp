<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
									href="${pageContext.request.contextPath}/restaurant/detail?id=${r.id}"
									class="flex-shrink-0 w-60 bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 transition-transform duration-300 group">
									<div class="relative">
										<img
											src="${not empty r.image ? r.image : 'https://placehold.co/600x400/e2e8f0/64748b?text=MEET+LOG'}"
											alt="${r.name}"
											class="w-full h-36 object-cover group-hover:opacity-90 transition-opacity">
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
							<p class="text-slate-500 py-8">인기 맛집 정보를 불러오고 있습니다.</p>
						</c:otherwise>
					</c:choose>
				</div>
			</section>

			<!-- 개인화 추천 섹션 (로그인한 사용자만) -->
			<c:if test="${not empty user}">
				<section class="mb-12">
					<div class="flex justify-between items-center mb-6">
						<h2 class="text-2xl md:text-3xl font-bold">✨ ${user.nickname}님을 위한 맞춤 추천</h2>
						<a href="${pageContext.request.contextPath}/recommendation/personalized" 
						   class="text-sky-600 hover:text-sky-700 font-semibold text-sm">
							더 보기 →
						</a>
					</div>
					<c:choose>
						<c:when test="${not empty personalizedRecommendations}">
							<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
								<c:forEach var="rec" items="${personalizedRecommendations}" varStatus="status">
									<div class="bg-white rounded-xl shadow-md overflow-hidden transform hover:-translate-y-1 transition-all duration-300 group">
										<div class="relative">
											<img src="${not empty rec.restaurant.image ? rec.restaurant.image : 'https://placehold.co/600x400/e2e8f0/64748b?text=MEET+LOG'}" 
												 alt="${rec.restaurant.name}" 
												 class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300">
											
											<!-- 추천 점수 배지 -->
											<div class="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full">
												<span class="text-sm font-bold text-green-600">
													<fmt:formatNumber value="${rec.recommendationScore * 100}" pattern="0" />%
												</span>
											</div>
											
											<!-- 맞춤 추천 배지 -->
											<div class="absolute top-3 left-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
												✨ 맞춤 추천
											</div>
										</div>
										
										<div class="p-4">
											<h3 class="text-lg font-bold text-slate-800 mb-1">${rec.restaurant.name}</h3>
											<p class="text-slate-600 text-sm mb-2">${rec.restaurant.category} • ${rec.restaurant.location}</p>
											
											<div class="flex items-center space-x-2 mb-3">
												<div class="flex space-x-1">
													<c:forEach begin="1" end="5">
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
												<span class="text-slate-600 text-sm">
													<fmt:formatNumber value="${rec.restaurant.rating}" pattern="0.0" />
													(${rec.restaurant.reviewCount}개 리뷰)
												</span>
											</div>
											
											<div class="bg-blue-50 p-2 rounded-lg mb-3">
												<p class="text-xs text-blue-800">
													<strong>💡 추천 이유:</strong> ${rec.recommendationReason}
												</p>
											</div>
											
											<a href="${pageContext.request.contextPath}/restaurant/detail/${rec.restaurant.id}" 
											   class="block w-full bg-sky-600 text-white text-center py-2 px-4 rounded-lg hover:bg-sky-700 transition-colors">
												상세보기
											</a>
										</div>
									</div>
								</c:forEach>
							</div>
						</c:when>
						<c:otherwise>
							<div class="bg-white p-8 rounded-xl shadow-md text-center">
								<div class="text-4xl mb-4">🤔</div>
								<h3 class="text-lg font-bold text-slate-800 mb-2">아직 추천할 맛집이 없습니다</h3>
								<p class="text-slate-600 mb-4">더 많은 리뷰를 작성하시면 맞춤 추천을 받을 수 있습니다.</p>
								<a href="${pageContext.request.contextPath}/restaurant/list" 
								   class="bg-sky-600 text-white px-6 py-2 rounded-lg hover:bg-sky-700">
									맛집 둘러보기
								</a>
							</div>
						</c:otherwise>
					</c:choose>
				</section>
			</c:if>

			<section class="bg-white p-6 rounded-xl my-12 shadow-md">
				<h2 class="text-2xl font-bold mb-6 text-center">나에게 꼭 맞는 맛집 찾기
					🔎</h2>
				<form action="${pageContext.request.contextPath}/restaurant/search" method="get"
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

			<section class="mt-12">
				<h2 class="text-2xl md:text-3xl font-bold mb-6">🔥 지금 뜨는 후기</h2>
				<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
					<c:choose>
						<c:when test="${not empty hotReviews}">
							<c:forEach var="review" items="${hotReviews}">
								<div
									class="bg-white p-5 rounded-xl shadow-lg transform hover:scale-105 transition-transform duration-300">
									<div class="flex items-center mb-3">
										<img
											src="${not empty review.authorImage ? review.authorImage : 'https://placehold.co/100x100/e2e8f0/64748b?text=U'}"
											class="w-12 h-12 rounded-full mr-4 object-cover">
										<div>
											<p class="font-bold text-slate-800">${review.author}</p>
											<p class="text-sm text-yellow-500">
												<c:forEach begin="1" end="${review.rating}">★</c:forEach>
												<c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
											</p>
										</div>
									</div>
									<p class="text-slate-700 h-16 overflow-hidden line-clamp-3">${review.content}</p>
									<a
										href="${pageContext.request.contextPath}/restaurant/detail?id=${review.restaurantId}"
										class="block mt-3 pt-3 border-t border-slate-100 text-sm font-semibold text-sky-600 hover:underline">
										'${review.restaurantName}' 리뷰 더보기 </a>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<p class="text-slate-500 py-8 md:col-span-3 text-center">최신
								리뷰를 불러오고 있습니다.</p>
						</c:otherwise>
					</c:choose>
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
									<div class="flex items-center mb-4">
										<img
											src="${not empty column.authorImage ? column.authorImage : 'https://placehold.co/50x50/a78bfa/ffffff?text=C'}"
											alt="${column.author}" class="w-10 h-10 rounded-full mr-3">
										<div>
											<h4 class="font-semibold">${column.author}</h4>
											<p class="text-sm text-slate-500">
												${column.createdAt}
											</p>
										</div>
									</div>
									<h3
										class="font-bold text-lg mb-2 h-14 overflow-hidden line-clamp-2">${column.title}</h3>
									<p
										class="text-slate-600 text-sm h-10 overflow-hidden line-clamp-2">${column.content}</p>
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

	<jsp:include page="/WEB-INF/views/common/loading.jsp" />
</body>
</html>