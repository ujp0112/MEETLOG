<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<header id="global-header" class="bg-white/80 backdrop-blur-lg shadow-sm sticky top-0 z-20">
    <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <a href="${pageContext.request.contextPath}/main">
            <h1 class="text-3xl font-bold text-sky-600">MEET LOG</h1>
        </a>
        
        <nav class="hidden md:flex items-center space-x-2">
            
            <%-- 공통 메뉴 (로그인 여부와 상관없이 항상 보임) --%>
            <a href="${pageContext.request.contextPath}/main" class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">홈</a>
            <a href="${pageContext.request.contextPath}/restaurant" class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">맛집찾기</a>
            <a href="${pageContext.request.contextPath}/column" class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">칼럼</a>
            
            <a href="${pageContext.request.contextPath}/course" class="text-slate-700 
hover:text-sky-600 transition font-medium px-4 py-2">추천코스</a>
            
            <a href="${pageContext.request.contextPath}/event/list" class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">이벤트</a>

            <c:choose>
                <%-- =============================================================== --%>
                <%-- [수정됨] 1. 로그인 상태일 때의 메뉴 (relative 추가)               --%>
                <%-- =============================================================== --%>
                <c:when test="${not empty sessionScope.user}">
                    
                    <%-- 비즈니스 메뉴 (유지) --%>
                    <c:if test="${sessionScope.user.userType == 'BUSINESS'}">
                        <%-- [수정됨] "relative" 클래스 추가 --%>
                        <div class="dropdown group relative">
                            <a href="#" class="dropdown-trigger text-slate-700 
hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">비즈니스 ▼</a>
                            
                            <%-- (mt-2 삭제됨) --%>
                            <div class="dropdown-content hidden group-hover:block absolute z-50 top-full right-0 min-w-[200px] bg-white rounded-md shadow-lg py-2 border border-slate-200">
                                <div class="px-4 py-2 text-sm font-semibold text-slate-500">사업자 메뉴</div>
                                <a href="${pageContext.request.contextPath}/business/dashboard" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">📊 통계/분석</a>
                                <a href="${pageContext.request.contextPath}/branch/menus" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🍽️ 메뉴 관리</a>
                                <a href="${pageContext.request.contextPath}/coupon-management" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🎟️ 쿠폰 관리</a>
                                <a href="${pageContext.request.contextPath}/business/review-management" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">💬 고객 리뷰 관리</a>
                                <div class="px-4 py-2 text-sm font-semibold text-slate-500">고급 기능</div>
                                <a href="${pageContext.request.contextPath}/advanced-search" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🔍 고급 검색</a>
                                <a href="${pageContext.request.contextPath}/notifications" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🔔 알림</a>
                            </div>
                        </div>
                    </c:if>

                    <%-- 마이페이지 + 로그아웃 통합 드롭다운 --%>
                    <%-- [수정됨] "relative" 클래스 추가 --%>
                    <div class="dropdown group relative ml-2">
                        
                        <button class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">
                            안녕하세요, ${sessionScope.user.nickname}님 ▼
                        </button>
                        
                        <%-- (mt-2 삭제됨) --%>
                        <div class="dropdown-content hidden group-hover:block absolute z-50 top-full right-0 min-w-[240px] bg-white rounded-md shadow-lg py-2 border border-slate-200">
                            <div class="px-4 py-2 text-sm font-semibold text-slate-500">사용자 메뉴</div>
                            <a href="${pageContext.request.contextPath}/mypage" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">👤 내 프로필</a>
                            <a href="${pageContext.request.contextPath}/mypage/reviews" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">✨ 내 리뷰 관리</a>
                            <a href="${pageContext.request.contextPath}/column/write" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">✍️ 새 칼럼 작성</a>
                            <a href="${pageContext.request.contextPath}/mypage/settings" class="block px-4 py-2 text-slate-700 hover:bg-slate-100">🔧 환경설정</a>
                            
                            <div class="my-1 border-t border-slate-200"></div> 
                            
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-red-600 hover:bg-red-50">로그아웃</a>
                        </div>
                    </div>
                    
                </c:when>
                <%-- =============================================================== --%>
                <%-- [끝] 수정된 부분                                                  --%>
                <%-- =============================================================== --%>


                <%-- 2. 로그아웃 상태일 때의 메뉴 --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="bg-sky-500 text-white font-bold py-2 px-5 rounded-full hover:bg-sky-600 text-sm ml-4">로그인</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>