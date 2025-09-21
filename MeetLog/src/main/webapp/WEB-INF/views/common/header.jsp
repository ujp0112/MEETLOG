<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- [추가] 직접 만든 mytag 라이브러리 선언 --%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>

<header class="bg-white/80 backdrop-blur-lg shadow-sm sticky top-0 z-50">
	<div
		class="container mx-auto px-4 py-4 flex justify-between items-center">
		<a href="${pageContext.request.contextPath}/main">
			<h1 class="text-3xl font-bold text-sky-600">MEET LOG</h1>
		</a>

		<nav class="hidden md:flex items-center space-x-2">
			<a href="${pageContext.request.contextPath}/main"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">홈</a>
			<a href="${pageContext.request.contextPath}/restaurant/list"
				class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">맛집찾기</a>
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
						<div class="group relative">
							<a href="#"
								class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">
								비즈니스 메뉴 ▼ </a>
							<div
								class="absolute right-0 top-full pt-4 hidden group-hover:block z-50">
								<div
									class="min-w-[200px] bg-white rounded-md shadow-lg py-2 border border-slate-200">
									<div class="px-4 py-2 text-sm font-semibold text-slate-500">사업자
										메뉴</div>
									<a
										href="${pageContext.request.contextPath}/business/restaurants"
										class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍙
										내 가게 관리</a>

									<c:if test="${sessionScope.businessUser.role == 'HQ'}">
										<div class="my-1 border-t border-slate-200"></div>
										<div class="px-4 py-2 text-sm font-semibold text-slate-500">본사(HQ)
											메뉴</div>
										<a
											href="${pageContext.request.contextPath}/hq/branch-management"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🏪
											지점 승인 관리</a>
										<a href="${pageContext.request.contextPath}/hq/materials"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">재료</a>
										<a href="${pageContext.request.contextPath}/hq/menus"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">메뉴</a>
										<a href="${pageContext.request.contextPath}/hq/sales-orders"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">수주</a>
									</c:if>
									
									<c:if test="${sessionScope.businessUser.role.toUpperCase() == 'BRANCH'}">
										<div class="my-1 border-t border-slate-200"></div>
										<div class="px-4 py-2 text-sm font-semibold text-slate-500">지점(BRANCH)
											메뉴</div>
										<a
											href="${pageContext.request.contextPath}/branch/inventory"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🏪
											지점 재고 관리</a>
										<a href="${pageContext.request.contextPath}/branch/menus"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">메뉴 관리</a>
										<a href="${pageContext.request.contextPath}/branch/order"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">발주</a>
										<a href="${pageContext.request.contextPath}/branch/orders-history"
											class="block px-4 py-2 text-slate-700 hover:bg-slate-100">발주 기록</a>
									</c:if>
								</div>
							</div>
						</div>
					</c:if>

					<%-- 마이페이지 + 로그아웃 메뉴 --%>
					<div class="group relative ml-2">
						<button class="flex items-center space-x-2 py-2 px-2 rounded-md hover:bg-slate-100">
							<%-- [수정] 프로필 이미지를 mytag으로 추가 --%>
							<mytag:image fileName="${sessionScope.user.profileImage}" altText="프로필" cssClass="w-8 h-8 rounded-full object-cover" />
							<span class="text-slate-700 font-medium">안녕하세요, ${sessionScope.user.nickname}님 ▼</span>
						</button>
						<div
							class="absolute right-0 top-full pt-4 hidden group-hover:block z-50">
							<div
								class="min-w-[240px] bg-white rounded-md shadow-lg py-2 border border-slate-200">
								<div class="px-4 py-2 text-sm font-semibold text-slate-500">사용자
									메뉴</div>
								<a href="${pageContext.request.contextPath}/mypage"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">👤
									마이페이지</a> <a
									href="${pageContext.request.contextPath}/mypage/settings"
									class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🔧
									설정</a>
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