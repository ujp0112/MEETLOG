<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>

<%-- CSS from 'sang' branch for smoother dropdowns --%>
<style>
.dropdown {
	position: relative;
}

.dropdown-content {
	opacity: 0;
	visibility: hidden;
	transform: translateY(-10px);
	transition: all 0.2s ease-in-out;
}

.dropdown:hover .dropdown-content {
	opacity: 1;
	visibility: visible;
	transform: translateY(0);
}

.dropdown-content::before {
	content: '';
	position: absolute;
	top: -10px;
	left: 0;
	right: 0;
	height: 10px;
	background: transparent;
}

.dropdown-content a {
	transition: all 0.15s ease-in-out;
}

.dropdown-content a:hover {
	background-color: #f8fafc;
	transform: translateX(2px);
}

.brand {
	display: flex;
	align-items: center;
	gap: 10px;
	font-weight: 800;
	font-size: 18px;
	white-space: nowrap;
	text-decoration: none
}

.brand .badge {
	font-size: 10px;
	padding: 4px 8px;
	border-radius: 999px;
	background: #e8eaec
}
</style>

<header class="bg-white/80 backdrop-blur-lg shadow-sm sticky top-0 z-50">
	<div
		class="container mx-auto px-4 py-4 flex justify-between items-center">
		<a href="${pageContext.request.contextPath}/main">
			<h1 class="text-3xl font-bold text-sky-600">MEET LOG</h1>
		</a>

		<nav class="hidden md:flex items-center space-x-2">
			<a href="${pageContext.request.contextPath}/main"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">홈</a>
			<a href="${pageContext.request.contextPath}/search"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">키워드 검색</a> 
			<a href="${pageContext.request.contextPath}/searchRestaurant?keyword=서울시청"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">지도 검색</a>
			<a href="${pageContext.request.contextPath}/column"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">칼럼</a>
			<a href="${pageContext.request.contextPath}/course"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">추천코스</a>
			<a href="${pageContext.request.contextPath}/event/list"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">이벤트</a>

			<c:choose>
				<%-- 로그인 상태일 때 --%>
				<c:when test="${not empty sessionScope.user}">

					<%-- 비즈니스 회원 전용 메뉴 --%>
					<c:if test="${sessionScope.user.userType == 'BUSINESS'}">
						<div class="dropdown group relative">
							<a href="#"
								class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">
								비즈니스 메뉴 ▼ </a>
							<div
								class="absolute right-0 top-full pt-4 hidden group-hover:block z-50 opacity-0 group-hover:opacity-100 transition-all duration-200">
								<div
									class="min-w-[200px] bg-white rounded-md shadow-lg py-2 border border-slate-200">
									<%-- <div class="px-4 py-2 text-sm font-semibold text-slate-500">사업자 메뉴</div>
									<a href="${pageContext.request.contextPath}/business/dashboard" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📊 대시보드</a>
									<a href="${pageContext.request.contextPath}/business/restaurants" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍙 내 가게 관리</a>
									<a href="${pageContext.request.contextPath}/business/restaurants/add" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">➕ 새 음식점 등록</a>
									<a href="${pageContext.request.contextPath}/coupon-management" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🎟️ 쿠폰 관리</a>
									<a href="${pageContext.request.contextPath}/business/review-management" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">💬 고객 리뷰 관리</a>
									<a href="${pageContext.request.contextPath}/business/qna-management" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">❓ Q&A 관리</a>
									<a href="${pageContext.request.contextPath}/business/reservation-management" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📅 예약 관리</a>
									<div class="border-t border-slate-200 my-2"></div> --%>


									<c:if test="${sessionScope.businessUser.role == 'HQ'}">
										<div class="my-1 border-t border-slate-200"></div>
										<div class="px-4 py-2 text-sm font-semibold text-slate-500">본사(HQ)
											메뉴</div>
										<a
											href="${pageContext.request.contextPath}/hq/branch-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🏪
											지점 승인 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/dashboard"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📊
											대시보드</a>
										<a
											href="${pageContext.request.contextPath}/business/restaurants"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍙
											지점 관리</a>
										<%-- <a href="${pageContext.request.contextPath}/hq/material" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">재료</a>
										<a href="${pageContext.request.contextPath}/hq/menus" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">메뉴</a>
										<a href="${pageContext.request.contextPath}/hq/sales-orders" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">수주</a> --%>
										<a href="${pageContext.request.contextPath}/hq/notice"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">✉
											사내 공지 관리</a>
										<a href="${pageContext.request.contextPath}/hq/recipe"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍽
											레시피 관리</a>
										<a href="${pageContext.request.contextPath}/hq/promotion"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🎉
											프로모션</a>
										<a href="${pageContext.request.contextPath}/hq/sales-orders"
											class="brand block px-4 py-2 text-slate-700 hover:bg-slate-100">🏪
											MeetERP<span class="badge">HQ</span>
										</a>
									</c:if>

									<c:if
										test="${sessionScope.businessUser.role.toUpperCase() == 'BRANCH'}">
										<div class="my-1 border-t border-slate-200"></div>
										<div class="px-4 py-2 text-sm font-semibold text-slate-500">지점(BRANCH)
											메뉴</div>
										<a
											href="${pageContext.request.contextPath}/business/dashboard"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📊
											대시보드</a>
										<a
											href="${pageContext.request.contextPath}/business/restaurants"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍙
											내 가게 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/restaurants/add"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">➕
											새 음식점 등록</a>
										<a href="${pageContext.request.contextPath}/coupon-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🎟️
											쿠폰 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/review-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">💬
											고객 리뷰 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/qna-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">❓
											Q&A 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/reservation-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📅
											예약 관리</a>
										<a href="${pageContext.request.contextPath}/branch/inventory"
											class="brand block px-4 py-2 text-slate-700 hover:bg-slate-100">🏪
											MeetERP<span class="badge">BRANCH</span>
										</a>
										<%-- <a href="${pageContext.request.contextPath}/branch/menus" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">메뉴 관리</a>
										<a href="${pageContext.request.contextPath}/branch/order" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">발주</a>
										<a href="${pageContext.request.contextPath}/branch/orders-history" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">발주 기록</a>
										<a href="${pageContext.request.contextPath}/branch/notice" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">사내 공지</a>
										<a href="${pageContext.request.contextPath}/branch/promotion" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">프로모션</a> --%>
									</c:if>

									<c:if
										test="${sessionScope.businessUser.role.toUpperCase() == 'INDIVIDUAL'}">
										<div class="my-1 border-t border-slate-200"></div>
										<div class="px-4 py-2 text-sm font-semibold text-slate-500">개인 사업자 메뉴</div>
										<a
											href="${pageContext.request.contextPath}/business/dashboard"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📊
											대시보드</a>
										<a
											href="${pageContext.request.contextPath}/business/restaurants"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍙
											내 가게 관리</a>
										<%-- <a href="${pageContext.request.contextPath}/business/restaurants/add" class="block px-4 py-2 text-slate-700 hover:bg-slate-100"> ➕ 새 음식점 등록</a> --%>
										<a href="${pageContext.request.contextPath}/coupon-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🎟️
											쿠폰 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/review-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">💬
											고객 리뷰 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/qna-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">❓
											Q&A 관리</a>
										<a
											href="${pageContext.request.contextPath}/business/reservation-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📅
											예약 관리</a>
									</c:if>
								</div>
							</div>
						</div>
					</c:if>

					<%-- 마이페이지 + 로그아웃 메뉴 --%>
					<div class="dropdown group relative ml-2">
						<button
							class="flex items-center space-x-2 py-2 px-2 rounded-md hover:bg-slate-100">
							<mytag:image fileName="${sessionScope.user.profileImage}"
								altText="프로필" cssClass="w-8 h-8 rounded-full object-cover" />
							<span class="text-slate-700 font-medium">안녕하세요,
								${sessionScope.user.nickname}님 ▼</span>
						</button>
						<div
							class="absolute right-0 top-full pt-4 hidden group-hover:block z-50 opacity-0 group-hover:opacity-100 transition-all duration-200">
							<div
								class="min-w-[240px] bg-white rounded-md shadow-lg py-2 border border-slate-200">
								<div class="px-4 py-2 text-sm font-semibold text-slate-500">사용자
									메뉴</div>
								<a href="${pageContext.request.contextPath}/notifications"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">
									🔔 알림 <c:if test="${not empty unreadCount && unreadCount > 0}">
										<span
											class="ml-2 bg-red-500 text-white text-xs rounded-full px-2 py-1">${unreadCount}</span>
									</c:if>
								</a> <a href="${pageContext.request.contextPath}/mypage"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">👤
									마이페이지</a> 
									<a href="${pageContext.request.contextPath}/feed/user/${sessionScope.user.id}"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📖
									내 피드	</a> 
									<a href="${pageContext.request.contextPath}/feed"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📱
									팔로우 피드	</a> 
									<a href="${pageContext.request.contextPath}/my-courses"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🗺️
									내 코스</a> <a href="${pageContext.request.contextPath}/wishlist"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📁
									내가 찜한 목록</a> <a
									href="${pageContext.request.contextPath}/mypage/reviews"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">✨
									내 리뷰 관리</a> <a
									href="${pageContext.request.contextPath}/mypage/settings"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🔧
									환경설정</a>
								<div class="my-1 border-t border-slate-200"></div>
								<a href="${pageContext.request.contextPath}/logout"
									class="block px-4 py-2 text-red-600 hover:bg-red-50">로그아웃</a>
							</div>
						</div>
					</div>
				</c:when>

				<%-- 로그아웃 상태일 때 --%>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/register"
						class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 text-sm">회원가입</a>
					<a href="${pageContext.request.contextPath}/login"
						class="bg-sky-500 text-white font-bold py-2 px-5 rounded-full hover:bg-sky-600 text-sm">로그인</a>
				</c:otherwise>
			</c:choose>
		</nav>
	</div>
</header>
