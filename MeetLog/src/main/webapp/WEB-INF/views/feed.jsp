<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>팔로우 피드 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-2px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .activity-card { border-left: 4px solid transparent; }
        .activity-card.review { border-left-color: #f59e0b; }
        .activity-card.course { border-left-color: #10b981; }
        .activity-card.column { border-left-color: #8b5cf6; }
        .activity-card.follow { border-left-color: #3b82f6; }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            <!-- 사이드바 -->
            <div class="lg:col-span-1">
                <div class="glass-card p-6 rounded-3xl fade-in sticky top-8">
                    <div class="text-center mb-6">
                        <mytag:image fileName="${sessionScope.user.profileImage}" 
                                   altText="${sessionScope.user.nickname}" 
                                   cssClass="w-20 h-20 rounded-full object-cover mx-auto border-4 border-white shadow-lg mb-4" />
                        <h2 class="text-xl font-bold text-slate-800">${sessionScope.user.nickname}</h2>
                        <p class="text-slate-600 text-sm">@${sessionScope.user.email}</p>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-4 mb-6">
                        <a class="text-center p-3 bg-blue-50 rounded-xl hover:bg-blue-100 transition-colors">
                            <div class="text-2xl font-bold text-blue-600">${followingCount}</div>
                            <div class="text-sm text-slate-600">팔로잉</div>
                        </a>
                        <a class="text-center p-3 bg-purple-50 rounded-xl hover:bg-purple-100 transition-colors">
                            <div class="text-2xl font-bold text-purple-600">${followerCount}</div>
                            <div class="text-sm text-slate-600">팔로워</div>
                        </a>
                    </div>
                    
                    <div class="space-y-3">
                        <a href="${pageContext.request.contextPath}/mypage" 
                           class="block w-full bg-slate-100 hover:bg-slate-200 text-slate-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                            내 프로필
                        </a>
                        <a href="${pageContext.request.contextPath}/wishlist" 
                           class="block w-full bg-pink-100 hover:bg-pink-200 text-pink-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                            찜 목록
                        </a>
                        <a href="${pageContext.request.contextPath}/review/write" 
                           class="block w-full btn-primary text-white text-center py-2 px-4 rounded-lg font-semibold">
                            리뷰 작성
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- 메인 피드 -->
            <div class="lg:col-span-3">
                <!-- 헤더 -->
                <div class="glass-card p-6 rounded-3xl fade-in mb-8">
                    <h1 class="text-3xl font-bold gradient-text mb-2">팔로우 피드</h1>
                    <p class="text-slate-600">팔로우하는 사람들의 최근 활동을 확인해보세요</p>
                </div>
                
                <!-- 피드 활동 목록 -->
                <div class="space-y-6">
                    <c:choose>
                        <c:when test="${hasActivities}">
                            <c:forEach var="activity" items="${activities}">
                                <div class="glass-card p-6 rounded-3xl card-hover activity-card ${fn:toLowerCase(activity.activityType)} slide-up">
                                    <!-- 활동 헤더 -->
                                    <div class="flex items-center space-x-4 mb-4">
                                        <mytag:image fileName="${activity.userProfileImage}" 
                                                   altText="${activity.userNickname}" 
                                                   cssClass="w-12 h-12 rounded-full object-cover border-2 border-white shadow-md" />
                                        <div class="flex-1">
                                            <div class="flex items-center space-x-2">
                                                <h3><a href="${pageContext.request.contextPath}/feed/user/${activity.userId}" class="text-lg font-bold text-slate-800 hover:text-blue-600 transition-colors">${activity.userNickname}</a></h3>
                                                <span class="px-2 py-1 rounded-full text-xs font-semibold
                                                    <c:choose>
                                                        <c:when test="${activity.activityType == 'REVIEW'}">bg-orange-100 text-orange-700</c:when>
                                                        <c:when test="${activity.activityType == 'COURSE'}">bg-green-100 text-green-700</c:when>
                                                        <c:when test="${activity.activityType == 'COLUMN'}">bg-purple-100 text-purple-700</c:when>
                                                        <c:when test="${activity.activityType == 'FOLLOW'}">bg-blue-100 text-blue-700</c:when>
                                                        <c:otherwise>bg-gray-100 text-gray-700</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${activity.activityType == 'REVIEW'}">리뷰 작성</c:when>
                                                        <c:when test="${activity.activityType == 'COURSE'}">코스 생성</c:when>
                                                        <c:when test="${activity.activityType == 'COLUMN'}">칼럼 작성</c:when>
                                                        <c:when test="${activity.activityType == 'FOLLOW'}">새로운 팔로우</c:when>
                                                        <c:otherwise>${activity.activityType}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <p class="text-slate-500 text-sm">
                                                ${activity.createdAt.toString().substring(0, 16).replace('T', ' ')}
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- 활동 내용 -->
                                    <div class="mb-4">
                                        <h4 class="text-xl font-bold text-slate-800 mb-2">${activity.contentTitle}</h4>
                                        
                                        <c:if test="${activity.activityType == 'REVIEW'}">
                                            <div class="flex items-center space-x-2 mb-2">
                                                <c:if test="${not empty activity.contentRating}">
                                                    <div class="flex items-center">
                                                        <span class="text-yellow-500 mr-1">⭐</span>
                                                        <span class="font-semibold"><fmt:formatNumber value="${activity.contentRating}" maxFractionDigits="1"/></span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty activity.contentLocation}">
                                                    <span class="text-slate-500">• ${activity.contentLocation}</span>
                                                </c:if>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty activity.contentDescription}">
                                            <p class="text-slate-700 leading-relaxed">
                                                <c:choose>
                                                    <c:when test="${fn:length(activity.contentDescription) > 150}">
                                                        ${fn:substring(activity.contentDescription, 0, 150)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${activity.contentDescription}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </c:if>
                                    </div>
                                    
                                    <!-- 이미지 (있는 경우) -->
                                    <c:if test="${not empty activity.contentImage}">
                                        <div class="mb-4 rounded-xl overflow-hidden">
                                            <mytag:image fileName="${activity.contentImage}" 
                                                       altText="${activity.contentTitle}" 
                                                       cssClass="w-full h-48 object-cover" />
                                        </div>
                                    </c:if>
                                    
                                    <!-- 액션 버튼 -->
                                    <div class="flex justify-between items-center pt-4 border-t border-slate-200">
                                        <div class="flex space-x-4">
                                            <c:choose>
                                                <c:when test="${activity.activityType == 'REVIEW'}">
                                                    <c:if test="${not empty activity.contentLocation}">
                                                        <a href="${pageContext.request.contextPath}/restaurant/detail/${activity.contentLocation}#reviews" 
                                                           class="text-orange-600 hover:text-orange-700 font-semibold text-sm">
                                                            리뷰 보기
                                                        </a>
                                                    </c:if>
                                                    <%--<c:if test="${not empty activity.restaurantName}">
                                                        <a href="${pageContext.request.contextPath}/restaurant/search?keyword=${activity.restaurantName}" 
                                                           class="text-slate-600 hover:text-slate-700 font-semibold text-sm">
                                                            음식점 보기
                                                        </a>
                                                    </c:if>--%>
                                                </c:when>
                                                <c:when test="${activity.activityType == 'COURSE'}">
                                                    <a href="${pageContext.request.contextPath}/course/detail?id=${activity.contentId}" 
                                                       class="text-green-600 hover:text-green-700 font-semibold text-sm">
                                                        코스 보기
                                                    </a>
                                                </c:when>
                                                <c:when test="${activity.activityType == 'COLUMN'}">
                                                    <a href="${pageContext.request.contextPath}/column/detail?id=${activity.contentId}" 
                                                       class="text-purple-600 hover:text-purple-700 font-semibold text-sm">
                                                        칼럼 보기
                                                    </a>
                                                </c:when>
                                                <c:when test="${activity.activityType == 'FOLLOW'}">
                                                    <a href="${pageContext.request.contextPath}/feed/user/${activity.contentId}" 
                                                       class="text-blue-600 hover:text-blue-700 font-semibold text-sm">
                                                        프로필 보기
                                                    </a>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="flex items-center space-x-3 text-slate-500">
                                        <%--<button class="hover:text-red-500 transition-colors">
                                                ❤️ 좋아요
                                            </button>
                                            <button class="hover:text-blue-500 transition-colors">
                                                💬 댓글
                                            </button> --%>
                                            <button class="hover:text-green-500 transition-colors">
                                                📤 공유
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${hasMore}">
                                <div class="glass-card p-6 rounded-3xl text-center">
                                    <form method="get" class="inline-block">
                                        <input type="hidden" name="page" value="${nextPage}" />
                                        <button type="submit" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                                            더 보기
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="glass-card p-12 rounded-3xl text-center">
                                <h3 class="text-2xl font-bold text-slate-800 mb-4">아직 피드가 비어있습니다</h3>
                                <p class="text-slate-600 mb-6">
                                    <c:choose>
                                        <c:when test="${followingCount == 0}">
                                            관심 있는 사람들을 팔로우해서 그들의 활동을 확인해보세요!
                                        </c:when>
                                        <c:otherwise>
                                            팔로우하는 사람들이 아직 활동하지 않았습니다.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="flex justify-center space-x-4">
                                    <c:if test="${followingCount == 0}">
                                        <a href="${pageContext.request.contextPath}/column" 
                                           class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                                            칼럼 보기
                                        </a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/restaurant/list" 
                                       class="bg-orange-100 hover:bg-orange-200 text-orange-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                        맛집 둘러보기
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
