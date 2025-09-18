<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
/* 드롭다운 메뉴 스타일 */
.dropdown {
    position: relative;
    display: inline-block;
}

.dropdown-content {
    position: absolute;
    top: 100%;
    left: 0;
    background-color: white;
    min-width: 200px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    border-radius: 8px;
    border: 1px solid #e5e7eb;
    z-index: 1000;
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

.dropdown-content a {
    color: #374151;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    border-bottom: 1px solid #f3f4f6;
    transition: background-color 0.2s ease;
}

.dropdown-content a:hover {
    background-color: #f9fafb;
    color: #1f2937;
}

.dropdown-content a:last-child {
    border-bottom: none;
}

.dropdown-header {
    background-color: #f9fafb;
    color: #6b7280;
    padding: 8px 16px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e5e7eb;
}

/* 드롭다운 트리거 스타일 */
.dropdown-trigger {
    position: relative;
}

.dropdown-trigger::after {
    content: '';
    position: absolute;
    top: 50%;
    right: 8px;
    transform: translateY(-50%);
    width: 0;
    height: 0;
    border-left: 4px solid transparent;
    border-right: 4px solid transparent;
    border-top: 4px solid currentColor;
    transition: transform 0.2s ease;
}

.dropdown:hover .dropdown-trigger::after {
    transform: translateY(-50%) rotate(180deg);
}

/* 드롭다운 메뉴가 열려있을 때 클릭 가능하도록 */
.dropdown-content {
    pointer-events: none;
}

.dropdown:hover .dropdown-content,
.dropdown-content:hover {
    pointer-events: auto;
}

/* 모바일에서 터치 지원 */
@media (max-width: 768px) {
    .dropdown-content {
        position: fixed;
        top: auto;
        left: 50%;
        transform: translateX(-50%) translateY(-10px);
        min-width: 250px;
    }
    
    .dropdown:hover .dropdown-content {
        transform: translateX(-50%) translateY(0);
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 드롭다운 메뉴 클릭 이벤트 처리
    const dropdowns = document.querySelectorAll('.dropdown');
    
    dropdowns.forEach(dropdown => {
        const trigger = dropdown.querySelector('.dropdown-trigger');
        const content = dropdown.querySelector('.dropdown-content');
        
        // 마우스 이벤트 - 드롭다운 영역에 마우스가 있을 때
        dropdown.addEventListener('mouseenter', function() {
            content.style.pointerEvents = 'auto';
        });
        
        // 드롭다운 영역에서 마우스가 나갈 때만 닫기
        dropdown.addEventListener('mouseleave', function() {
            // 약간의 지연을 두어 메뉴 간 이동할 시간을 줌
            setTimeout(() => {
                if (!dropdown.matches(':hover')) {
                    content.style.pointerEvents = 'none';
                }
            }, 100);
        });
        
        // 드롭다운 콘텐츠에 마우스가 있을 때
        content.addEventListener('mouseenter', function() {
            content.style.pointerEvents = 'auto';
        });
        
        // 터치 이벤트 (모바일)
        trigger.addEventListener('click', function(e) {
            // 모바일에서만 preventDefault 실행
            if (window.innerWidth <= 768) {
                e.preventDefault();
                const isVisible = content.style.opacity === '1';
                
                // 다른 드롭다운 닫기
                dropdowns.forEach(otherDropdown => {
                    if (otherDropdown !== dropdown) {
                        const otherContent = otherDropdown.querySelector('.dropdown-content');
                        otherContent.style.opacity = '0';
                        otherContent.style.visibility = 'hidden';
                        otherContent.style.transform = 'translateY(-10px)';
                    }
                });
                
                // 현재 드롭다운 토글
                if (isVisible) {
                    content.style.opacity = '0';
                    content.style.visibility = 'hidden';
                    content.style.transform = 'translateY(-10px)';
                } else {
                    content.style.opacity = '1';
                    content.style.visibility = 'visible';
                    content.style.transform = 'translateY(0)';
                }
            }
            // 데스크톱에서는 기본 링크 동작 허용
        });
    });
    
    // 외부 클릭 시 드롭다운 닫기 (모바일에서만)
    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 768 && !e.target.closest('.dropdown')) {
            dropdowns.forEach(dropdown => {
                const content = dropdown.querySelector('.dropdown-content');
                content.style.opacity = '0';
                content.style.visibility = 'hidden';
                content.style.transform = 'translateY(-10px)';
            });
        }
    });
});
</script>

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
                        <div class="dropdown-content">
                            <div class="dropdown-header">사용자 메뉴</div>
                            <a href="${pageContext.request.contextPath}/mypage">👤 내 프로필</a>
                            <a href="${pageContext.request.contextPath}/mypage/reservations">📅 내 예약</a>
                            <a href="${pageContext.request.contextPath}/mypage/reviews">✨ 내 리뷰 관리</a>
                            <a href="${pageContext.request.contextPath}/mypage/columns">📝 내 칼럼</a>
                            <a href="${pageContext.request.contextPath}/column/write">✍️ 새 칼럼 작성</a>
                            <a href="${pageContext.request.contextPath}/mypage/settings">🔧 환경설정</a>
                        </div>
                    </div>
                    
                    <c:if test="${sessionScope.user.userType == 'BUSINESS'}">
                        <div class="dropdown group">
                            <a href="${pageContext.request.contextPath}/business/dashboard" class="dropdown-trigger text-slate-700 hover:text-sky-600 transition font-medium px-4 py-2 inline-flex items-center">비즈니스 ▼</a>
                            <div class="dropdown-content">
                                <div class="dropdown-header">사업자 메뉴</div>
                                <a href="${pageContext.request.contextPath}/business/dashboard">📊 대시보드</a>
                                <a href="${pageContext.request.contextPath}/business/edit/${sessionScope.user.id}">🏪 매장 정보 수정</a>
                                <a href="${pageContext.request.contextPath}/branch/menus">🍽️ 메뉴 관리</a>
                                <a href="${pageContext.request.contextPath}/branch/inventory">📦 재고 관리</a>
                                <a href="${pageContext.request.contextPath}/branch/orders-history">📋 주문 이력</a>
                                <a href="${pageContext.request.contextPath}/coupon-management">🎟️ 쿠폰 관리</a>
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