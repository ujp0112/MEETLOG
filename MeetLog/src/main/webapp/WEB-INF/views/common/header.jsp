<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>

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

.dropdown:hover .dropdown-content, .dropdown:focus-within .dropdown-content
	{
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
	text-decoration: none;
}

.brand .badge {
	font-size: 10px;
	padding: 4px 8px;
	border-radius: 999px;
	background: #e8eaec;
}

.mobile-nav-link {
	display: block;
	padding: 0.75rem 1rem;
	border-radius: 0.75rem;
	font-size: 0.95rem;
	font-weight: 500;
	color: #334155;
	transition: background-color 0.2s, color 0.2s;
}

.mobile-nav-link:hover {
	background-color: #f1f5f9;
	color: #0ea5e9;
}
</style>

<header class="bg-white/85 backdrop-blur-lg shadow-sm sticky top-0 z-50">
	<div
		class="container mx-auto flex items-center justify-between gap-6 px-4 py-4">
		<a href="${pageContext.request.contextPath}/main"
			class="flex items-center gap-3 group"> <!-- <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-sky-500/10 ring-2 ring-sky-500/40">
        <span class="text-2xl font-black text-sky-600">M</span>
      </div> -->
			<div class="leading-tight">
				<p
					class="text-xl font-black text-slate-900 transition group-hover:text-sky-600 md:text-2xl">MEET
					LOG</p>
			</div>
		</a>

		<button id="mobileNavToggle" type="button"
			class="inline-flex items-center justify-center rounded-full border border-slate-200 p-2 text-slate-700 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-sky-500 md:hidden"
			aria-label="메뉴 열기" aria-expanded="false"
			aria-controls="mobileNavPanel">
			<svg id="mobileNavIconOpen" class="h-6 w-6" fill="none"
				stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round"
					d="M4 6h16M4 12h16M4 18h16" />
      </svg>
			<svg id="mobileNavIconClose" class="hidden h-6 w-6" fill="none"
				stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round"
					d="M6 6l12 12M6 18L18 6" />
      </svg>
		</button>

		<nav id="primaryNav" class="hidden items-center space-x-4 md:flex">
			<div
				class="flex items-center space-x-2 text-sm font-medium text-slate-700">
				<a href="${pageContext.request.contextPath}/main"
					class="block rounded-md px-4 py-2 hover:bg-slate-100 hover:text-sky-600">홈</a>
				<a href="${pageContext.request.contextPath}/search"
					class="block rounded-md px-4 py-2 hover:bg-slate-100 hover:text-sky-600">키워드
					검색</a> <a
					href="${pageContext.request.contextPath}/searchRestaurant?keyword=서울특별시청&category=전체"
					class="block rounded-md px-4 py-2 hover:bg-slate-100 hover:text-sky-600">지도
					검색</a> <a href="${pageContext.request.contextPath}/column"
					class="block rounded-md px-4 py-2 hover:bg-slate-100 hover:text-sky-600">칼럼</a>
				<a href="${pageContext.request.contextPath}/course"
					class="block rounded-md px-4 py-2 hover:bg-slate-100 hover:text-sky-600">추천코스</a>
				<a href="${pageContext.request.contextPath}/event/list"
					class="block rounded-md px-4 py-2 hover:bg-slate-100 hover:text-sky-600">이벤트</a>
			</div>

			<c:choose>
				<c:when test="${not empty sessionScope.user}">
					<div class="flex items-center space-x-4">
						<c:if test="${sessionScope.user.userType == 'BUSINESS'}">
							<div class="dropdown group relative">
								<button type="button"
									class="inline-flex items-center gap-2 rounded-md px-4 py-2 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-sky-500">
									<span class="text-slate-700 font-medium">비즈니스 메뉴</span>
									<svg class="h-4 w-4 text-slate-500" fill="none"
										stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
											d="M6 9l6 6 6-6" />
                  </svg>
								</button>
								<div
									class="dropdown-content absolute right-0 top-full z-50 pt-3">
									<div
										class="min-w-[220px] rounded-xl border border-slate-200 bg-white py-3 shadow-xl">
										<c:if test="${sessionScope.businessUser.role == 'HQ'}">
											<div
												class="px-4 py-2 text-xs font-semibold uppercase tracking-wide text-slate-400">본사(HQ)</div>
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
											<div
												class="px-4 py-2 text-xs font-semibold uppercase tracking-wide text-slate-400">지점</div>
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
											<a
												href="${pageContext.request.contextPath}/coupon-management"
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
										</c:if>

										<c:if
											test="${sessionScope.businessUser.role.toUpperCase() == 'INDIVIDUAL'}">
											<div
												class="px-4 py-2 text-xs font-semibold uppercase tracking-wide text-slate-400">개인
												사업자</div>
											<a
												href="${pageContext.request.contextPath}/business/dashboard"
												class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📊
												대시보드</a>
											<a
												href="${pageContext.request.contextPath}/business/restaurants"
												class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍙
												내 가게 관리</a>
											<a
												href="${pageContext.request.contextPath}/coupon-management"
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

						<div class="dropdown group relative">
							<button type="button"
								class="flex items-center gap-2 rounded-md px-3 py-2 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-sky-500">
								<mytag:image fileName="${sessionScope.user.profileImage}"
									altText="프로필"
									cssClass="h-8 w-8 rounded-full border border-slate-200 object-cover" />
								<span class="text-slate-700 font-medium">${sessionScope.user.nickname}님</span>
								<svg class="h-4 w-4 text-slate-500" fill="none"
									stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round"
										d="M6 9l6 6 6-6" />
                </svg>
							</button>
							<div class="dropdown-content absolute right-0 top-full z-50 pt-3">
								<div
									class="min-w-[240px] rounded-xl border border-slate-200 bg-white py-3 shadow-xl">
									<div
										class="px-4 pb-2 text-xs font-semibold uppercase tracking-wide text-slate-400">내
										계정</div>
									<a href="${pageContext.request.contextPath}/notifications"
										class="flex items-center justify-between px-4 py-2 text-slate-700 hover:bg-slate-100">
										<span>🔔 알림</span> <c:if
											test="${not empty unreadCount && unreadCount > 0}">
											<span
												class="ml-2 rounded-full bg-red-500 px-2 py-1 text-xs font-semibold text-white">${unreadCount}</span>
										</c:if>
									</a> <a href="${pageContext.request.contextPath}/mypage"
										class="block px-4 py-2 text-slate-700 hover:bg-slate-100">👤
										마이페이지</a> <a
										href="${pageContext.request.contextPath}/feed/user/${sessionScope.user.id}"
										class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📖
										내 피드</a> <a href="${pageContext.request.contextPath}/feed"
										class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📱
										팔로우 피드</a> <a href="${pageContext.request.contextPath}/my-courses"
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
									<div class="my-3 border-t border-slate-200"></div>
									<a href="${pageContext.request.contextPath}/logout"
										class="block px-4 py-2 text-red-600 hover:bg-red-50">로그아웃</a>
								</div>
							</div>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="flex items-center space-x-2">
						<a href="${pageContext.request.contextPath}/register"
							class="rounded-md px-3 py-2 text-slate-700 hover:text-sky-600">회원가입</a>
						<a href="${pageContext.request.contextPath}/login"
							class="inline-flex items-center justify-center rounded-full bg-sky-500 px-5 py-2 text-sm font-semibold text-white shadow-sm hover:bg-sky-600">로그인</a>
					</div>
				</c:otherwise>
			</c:choose>
		</nav>
	</div>

	<div id="mobileNavPanel"
		class="hidden border-t border-slate-200 bg-white/95 backdrop-blur-sm md:hidden">
		<div class="container mx-auto space-y-6 px-4 py-6">
			<div class="space-y-1">
				<a href="${pageContext.request.contextPath}/main"
					class="mobile-nav-link">홈</a> <a
					href="${pageContext.request.contextPath}/search"
					class="mobile-nav-link">키워드 검색</a> <a
					href="${pageContext.request.contextPath}/searchRestaurant?keyword=서울특별시청&category=전체"
					class="mobile-nav-link">지도 검색</a> <a
					href="${pageContext.request.contextPath}/column"
					class="mobile-nav-link">칼럼</a> <a
					href="${pageContext.request.contextPath}/course"
					class="mobile-nav-link">추천코스</a> <a
					href="${pageContext.request.contextPath}/event/list"
					class="mobile-nav-link">이벤트</a>
			</div>

			<c:choose>
				<c:when test="${not empty sessionScope.user}">
					<c:if test="${sessionScope.user.userType == 'BUSINESS'}">
						<div class="space-y-2">
							<p
								class="px-4 text-xs font-semibold uppercase tracking-widest text-slate-400">비즈니스</p>
							<c:if test="${sessionScope.businessUser.role == 'HQ'}">
								<a
									href="${pageContext.request.contextPath}/hq/branch-management"
									class="mobile-nav-link">🏪 지점 승인 관리</a>
								<a href="${pageContext.request.contextPath}/business/dashboard"
									class="mobile-nav-link">📊 대시보드</a>
								<a
									href="${pageContext.request.contextPath}/business/restaurants"
									class="mobile-nav-link">🍙 지점 관리</a>
								<a href="${pageContext.request.contextPath}/hq/notice"
									class="mobile-nav-link">✉ 사내 공지 관리</a>
								<a href="${pageContext.request.contextPath}/hq/recipe"
									class="mobile-nav-link">🍽 레시피 관리</a>
								<a href="${pageContext.request.contextPath}/hq/promotion"
									class="mobile-nav-link">🎉 프로모션</a>
								<a href="${pageContext.request.contextPath}/hq/sales-orders"
									class="mobile-nav-link">🏪 MeetERP HQ</a>
							</c:if>

							<c:if
								test="${sessionScope.businessUser.role.toUpperCase() == 'BRANCH'}">
								<a href="${pageContext.request.contextPath}/business/dashboard"
									class="mobile-nav-link">📊 대시보드</a>
								<a
									href="${pageContext.request.contextPath}/business/restaurants"
									class="mobile-nav-link">🍙 내 가게 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/restaurants/add"
									class="mobile-nav-link">➕ 새 음식점 등록</a>
								<a href="${pageContext.request.contextPath}/coupon-management"
									class="mobile-nav-link">🎟️ 쿠폰 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/review-management"
									class="mobile-nav-link">💬 고객 리뷰 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/qna-management"
									class="mobile-nav-link">❓ Q&A 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/reservation-management"
									class="mobile-nav-link">📅 예약 관리</a>
								<a href="${pageContext.request.contextPath}/branch/inventory"
									class="mobile-nav-link">🏪 MeetERP BRANCH</a>
							</c:if>

							<c:if
								test="${sessionScope.businessUser.role.toUpperCase() == 'INDIVIDUAL'}">
								<a href="${pageContext.request.contextPath}/business/dashboard"
									class="mobile-nav-link">📊 대시보드</a>
								<a
									href="${pageContext.request.contextPath}/business/restaurants"
									class="mobile-nav-link">🍙 내 가게 관리</a>
								<a href="${pageContext.request.contextPath}/coupon-management"
									class="mobile-nav-link">🎟️ 쿠폰 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/review-management"
									class="mobile-nav-link">💬 고객 리뷰 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/qna-management"
									class="mobile-nav-link">❓ Q&A 관리</a>
								<a
									href="${pageContext.request.contextPath}/business/reservation-management"
									class="mobile-nav-link">📅 예약 관리</a>
							</c:if>
						</div>
					</c:if>

					<div class="space-y-2">
						<p
							class="px-4 text-xs font-semibold uppercase tracking-widest text-slate-400">내
							계정</p>
						<a href="${pageContext.request.contextPath}/notifications"
							class="mobile-nav-link flex items-center justify-between"> <span>🔔
								알림</span> <c:if test="${not empty unreadCount && unreadCount > 0}">
								<span
									class="ml-2 rounded-full bg-red-500 px-2 py-0.5 text-xs font-semibold text-white">${unreadCount}</span>
							</c:if>
						</a> <a href="${pageContext.request.contextPath}/mypage"
							class="mobile-nav-link">👤 마이페이지</a> <a
							href="${pageContext.request.contextPath}/feed/user/${sessionScope.user.id}"
							class="mobile-nav-link">📖 내 피드</a> <a
							href="${pageContext.request.contextPath}/feed"
							class="mobile-nav-link">📱 팔로우 피드</a> <a
							href="${pageContext.request.contextPath}/my-courses"
							class="mobile-nav-link">🗺️ 내 코스</a> <a
							href="${pageContext.request.contextPath}/wishlist"
							class="mobile-nav-link">📁 내가 찜한 목록</a> <a
							href="${pageContext.request.contextPath}/mypage/reviews"
							class="mobile-nav-link">✨ 내 리뷰 관리</a> <a
							href="${pageContext.request.contextPath}/mypage/settings"
							class="mobile-nav-link">🔧 환경설정</a>
						<div class="border-t border-slate-200 pt-3"></div>
						<a href="${pageContext.request.contextPath}/logout"
							class="mobile-nav-link text-red-600">로그아웃</a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="space-y-3">
						<a href="${pageContext.request.contextPath}/register"
							class="block rounded-full border border-slate-200 px-4 py-3 text-center font-semibold text-slate-700 hover:bg-slate-100">회원가입</a>
						<a href="${pageContext.request.contextPath}/login"
							class="block rounded-full bg-sky-500 px-4 py-3 text-center font-semibold text-white shadow hover:bg-sky-600">로그인</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</header>

<script>
	document.addEventListener('DOMContentLoaded', function() {
		var toggleButton = document.getElementById('mobileNavToggle');
		var navPanel = document.getElementById('mobileNavPanel');
		var iconOpen = document.getElementById('mobileNavIconOpen');
		var iconClose = document.getElementById('mobileNavIconClose');

		if (!toggleButton || !navPanel) {
			return;
		}

		var closeMobileMenu = function() {
			navPanel.classList.add('hidden');
			toggleButton.setAttribute('aria-expanded', 'false');
			iconOpen.classList.remove('hidden');
			iconClose.classList.add('hidden');
			document.body.classList.remove('overflow-hidden');
		};

		toggleButton.addEventListener('click', function() {
			var isHidden = navPanel.classList.contains('hidden');
			if (isHidden) {
				navPanel.classList.remove('hidden');
				toggleButton.setAttribute('aria-expanded', 'true');
				iconOpen.classList.add('hidden');
				iconClose.classList.remove('hidden');
				document.body.classList.add('overflow-hidden');
			} else {
				closeMobileMenu();
			}
		});

		window.addEventListener('resize', function() {
			if (window.innerWidth >= 768) {
				closeMobileMenu();
			}
		});

		document.addEventListener('keyup', function(event) {
			if (event.key === 'Escape') {
				closeMobileMenu();
			}
		});

		navPanel.querySelectorAll('a').forEach(function(link) {
			link.addEventListener('click', closeMobileMenu);
		});
	});
</script>

</script>

<%-- 카카오 SDK 스크립트 추가 --%>
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.1/kakao.min.js"></script>

<%-- 카카오 SDK 초기화 스크립트 수정 --%>
<script>
	// 카카오 SDK가 로드되었는지 확인 후 초기화합니다.
	if (window.Kakao) {
		if (!Kakao.isInitialized()) {
			// ✨ FIXED: 하드코딩된 키 대신, AppConfigListener가 만들어준 전역 변수를 사용합니다.
			Kakao.init('${KAKAO_API_KEY}');
		}
	}
</script>
