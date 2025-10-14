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
    <title>${targetUser.nickname}의 피드 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-secondary { background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(107, 114, 128, 0.4); }
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
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            <!-- 사용자 프로필 사이드바 -->
            <div class="lg:col-span-1">
                <div class="glass-card p-6 rounded-3xl fade-in sticky top-8">
                    <div class="text-center mb-6">
                        <mytag:image fileName="${targetUser.profileImage}"
                                   altText="${targetUser.nickname}"
                                   cssClass="w-24 h-24 rounded-full object-cover mx-auto border-4 border-white shadow-lg mb-4" />
                        <h2 class="text-2xl font-bold text-slate-800">${targetUser.nickname}</h2>
                        <p class="text-slate-600 text-sm">@${targetUser.email}</p>
                    </div>

                    <div class="grid grid-cols-2 gap-4 mb-6">
                        <div class="text-center p-3 bg-blue-50 rounded-xl">
                            <div class="text-2xl font-bold text-blue-600">${followingCount}</div>
                            <div class="text-sm text-slate-600">팔로잉</div>
                        </div>
                        <div class="text-center p-3 bg-purple-50 rounded-xl">
                            <div class="text-2xl font-bold text-purple-600">${followerCount}</div>
                            <div class="text-sm text-slate-600">팔로워</div>
                        </div>
                    </div>

                    <div class="space-y-3">
                        <c:choose>
                            <c:when test="${isOwnProfile}">
                                <a href="${pageContext.request.contextPath}/mypage"
                                   class="block w-full bg-slate-100 hover:bg-slate-200 text-slate-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                    내 프로필 편집
                                </a>
                                <a href="${pageContext.request.contextPath}/feed"
                                   class="block w-full btn-primary text-white text-center py-2 px-4 rounded-lg font-semibold">
                                    팔로우 피드로 이동
                                </a>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${isFollowing}">
                                        <button onclick="toggleFollow(${targetUser.id}, false)"
                                                class="block w-full btn-secondary text-white text-center py-2 px-4 rounded-lg font-semibold">
                                            언팔로우
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button onclick="toggleFollow(${targetUser.id}, true)"
                                                class="block w-full btn-primary text-white text-center py-2 px-4 rounded-lg font-semibold">
                                            팔로우
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/feed"
                                   class="block w-full bg-slate-100 hover:bg-slate-200 text-slate-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                    내 피드로 돌아가기
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- 메인 활동 피드 -->
            <div class="lg:col-span-3">
                <!-- 헤더 -->
                <div class="glass-card p-6 rounded-3xl fade-in mb-8">
                    <h1 class="text-3xl font-bold gradient-text mb-2">
                        <c:choose>
                            <c:when test="${isOwnProfile}">내 활동</c:when>
                            <c:otherwise>${targetUser.nickname}님의 활동</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-slate-600">
                        <c:choose>
                            <c:when test="${isOwnProfile}">내가 작성한 리뷰, 칼럼, 코스 등의 활동을 확인해보세요</c:when>
                            <c:otherwise>${targetUser.nickname}님의 최근 활동을 확인해보세요</c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- 활동 목록 -->
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
                                                <h3 class="text-lg font-bold text-slate-800">${activity.userNickname}</h3>
                                                <span class="px-2 py-1 rounded-full text-xs font-semibold
                                                    <c:choose>
                                                        <c:when test="${activity.activityType == 'REVIEW'}">bg-amber-100 text-amber-800</c:when>
                                                        <c:when test="${activity.activityType == 'COURSE'}">bg-emerald-100 text-emerald-800</c:when>
                                                        <c:when test="${activity.activityType == 'COLUMN'}">bg-purple-100 text-purple-800</c:when>
                                                        <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${activity.activityType == 'REVIEW'}">리뷰</c:when>
                                                        <c:when test="${activity.activityType == 'COURSE'}">코스</c:when>
                                                        <c:when test="${activity.activityType == 'COLUMN'}">칼럼</c:when>
                                                        <c:otherwise>${activity.activityType}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <p class="text-sm text-slate-500">
                                                <c:choose>
                                                    <c:when test="${activity.createdAt != null}">
                                                        ${activity.createdAt.toString().substring(0, 10).replace('-', '.')} ${activity.createdAt.toString().substring(11, 16)}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>

                                    <!-- 활동 내용 -->
                                    <div class="mb-4">
                                        <p class="text-slate-700 mb-3">${activity.contentDescription}</p>
                                        <c:if test="${not empty activity.contentImage}">
                                            <mytag:image fileName="${activity.contentImage}"
                                                       altText="활동 이미지"
                                                       cssClass="w-full max-h-96 object-cover rounded-xl" />
                                        </c:if>
                                    </div>

                                    <!-- 관련 링크 -->
                                    <c:if test="${not empty activity.contentTitle}">
                                        <div class="flex items-center space-x-2 p-3 bg-slate-50 rounded-xl">
                                            <c:if test="${not empty activity.contentImage}">
                                                <mytag:image fileName="${activity.contentImage}"
                                                           altText="${activity.contentTitle}"
                                                           cssClass="w-10 h-10 rounded-lg object-cover" />
                                            </c:if>
                                            <div class="flex-1">
                                                <h4 class="font-semibold text-slate-800 text-sm">${activity.contentTitle}</h4>
                                                <c:if test="${not empty activity.contentLocation}">
                                                    <p class="text-xs text-slate-500">${activity.contentLocation}</p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 상호작용 버튼 -->
                                    <div class="flex items-center justify-between pt-4 border-t border-slate-100">
                                        <div class="flex space-x-4">
                                            <span class="text-sm text-slate-500">
                                                👍 ${activity.likeCount > 0 ? activity.likeCount : '0'}
                                            </span>
                                            <span class="text-sm text-slate-500">
                                                💬 ${activity.commentCount > 0 ? activity.commentCount : '0'}
                                            </span>
                                        </div>
                                        <c:if test="${not empty activity.targetUrl}">
                                            <a href="${activity.targetUrl}"
                                               class="text-sm text-blue-600 hover:text-blue-800 font-medium">
                                                자세히 보기 →
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${hasMore}">
                                <div class="glass-card p-6 rounded-3xl text-center mt-6">
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
                            <!-- 활동이 없을 때 -->
                            <div class="glass-card p-12 rounded-3xl text-center slide-up">
                                <h3 class="text-xl font-bold text-slate-800 mb-2">
                                    <c:choose>
                                        <c:when test="${isOwnProfile}">아직 활동이 없어요</c:when>
                                        <c:otherwise>${targetUser.nickname}님의 활동이 없어요</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="text-slate-600 mb-6">
                                    <c:choose>
                                        <c:when test="${isOwnProfile}">첫 번째 리뷰나 코스를 작성해보세요!</c:when>
                                        <c:otherwise>아직 활동이 없습니다. 나중에 다시 확인해보세요.</c:otherwise>
                                    </c:choose>
                                </p>
                                <c:if test="${isOwnProfile}">
                                    <div class="space-x-4">
                                        <a href="${pageContext.request.contextPath}/review/write"
                                           class="inline-block btn-primary text-white px-6 py-2 rounded-lg font-semibold">
                                            리뷰 작성하기
                                        </a>
                                        <a href="${pageContext.request.contextPath}/course/create"
                                           class="inline-block bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2 rounded-lg font-semibold transition-colors">
                                            코스 만들기
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <script>
    // 팔로우/언팔로우 토글 함수
    function toggleFollow(targetUserId, isFollow) {
        const action = isFollow ? 'follow' : 'unfollow';
        const url = '${pageContext.request.contextPath}/feed/toggle-follow';

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=' + action + '&targetUserId=' + targetUserId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 페이지 새로고침하여 팔로우 상태 업데이트
                location.reload();
            } else {
                alert(data.message || '오류가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('팔로우 처리 중 오류가 발생했습니다.');
        });
    }
    </script>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
