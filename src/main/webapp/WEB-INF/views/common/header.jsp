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
            
            <a href="${pageContext.request.contextPath}/course" class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">추천코스</a>
            
            <a href="${pageContext.request.contextPath}/event/list" class="text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2">이벤트</a>

            <c:choose>
                <%-- 1. 로그인 상태일 때의 메뉴 --%>
                <c:when test="${not empty sessionScope.user}">
                    <div class="dropdown group">
                        <a href="${pageContext.request.contextPath}/mypage" class="dropdown-trigger text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">마이페이지 ▼</a>
                        <div class="dropdown-content hidden group-hover:block">
                            <div class="dropdown-header">사용자 메뉴</div>
                            <a href="${pageContext.request.contextPath}/mypage">👤 내 프로필</a>
                            <a href="${pageContext.request.contextPath}/mypage/reviews">✨ 내 리뷰 관리</a>
                            <a href="${pageContext.request.contextPath}/column/write">✍️ 새 칼럼 작성</a>
                            <a href="${pageContext.request.contextPath}/mypage/settings">🔧 환경설정</a>
                            
                        </div>
                    </div>
                    
                    <c:if test="${sessionScope.user.userType == 'BUSINESS'}">
                        <div class="dropdown group">
                            <a href="#" class="dropdown-trigger text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">비즈니스 ▼</a>
                            <div class="dropdown-content hidden group-hover:block">
                                <div class="dropdown-header">사업자 메뉴</div>
                                <a href="#">📊 통계/분석</a>
                                <a href="#">🍽️ 메뉴 관리</a>
                                <a href="#">🎟️ 쿠폰 관리</a>
                                <a href="#">💬 고객 리뷰 관리</a>
                            </div>
                        </div>
                    </c:if>

                    <span class="text-slate-700 px-2">안녕하세요, ${sessionScope.user.nickname}님</span>
                    <a href="${pageContext.request.contextPath}/logout" class="bg-slate-500 text-white font-bold py-2 px-5 rounded-full hover:bg-slate-600 text-sm ml-2">로그아웃</a>
                </c:when>

                <%-- 2. 로그아웃 상태일 때의 메뉴 --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="bg-sky-500 text-white font-bold py-2 px-5 rounded-full hover:bg-sky-600 text-sm ml-4">로그인</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>