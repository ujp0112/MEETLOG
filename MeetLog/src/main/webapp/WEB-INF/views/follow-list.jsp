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
    <title><c:choose><c:when test="${isFollowingPage}">팔로잉</c:when><c:otherwise>팔로워</c:otherwise></c:choose> - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-secondary { background: linear-gradient(135deg, #64748b 0%, #475569 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(100, 116, 139, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-2px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl fade-in">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/mypage" 
                           class="text-slate-600 hover:text-blue-600 p-2 rounded-lg hover:bg-white/50">
                            ← 프로필로 돌아가기
                        </a>
                        <div>
                            <h1 class="text-4xl font-bold gradient-text">
                                <c:choose>
                                    <c:when test="${isFollowingPage}">팔로잉 목록</c:when>
                                    <c:otherwise>팔로워 목록</c:otherwise>
                                </c:choose>
                            </h1>
                            <p class="text-slate-600 mt-1">
                                <c:choose>
                                    <c:when test="${isFollowingPage}">
                                        👥 ${fn:length(followingUsers)}명을 팔로우하고 있습니다
                                    </c:when>
                                    <c:otherwise>
                                        👥 ${fn:length(followers)}명이 팔로우하고 있습니다
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 사용자 목록 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <c:choose>
                    <c:when test="${isFollowingPage}">
                        <c:choose>
                            <c:when test="${not empty followingUsers}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach var="user" items="${followingUsers}">
                                        <div class="card-hover rounded-2xl p-6 bg-white border border-slate-200">
                                            <div class="flex items-center space-x-4 mb-4">
                                                <div class="relative">
                                                    <mytag:image fileName="${user.profileImage}" 
                                                               altText="${user.nickname}" 
                                                               cssClass="w-16 h-16 rounded-full object-cover border-2 border-white shadow-lg" />
                                                    <div class="absolute -bottom-1 -right-1 w-5 h-5 bg-green-500 rounded-full border-2 border-white"></div>
                                                </div>
                                                <div class="flex-1">
                                                    <h3 class="text-lg font-bold text-slate-800">${user.nickname}</h3>
                                                    <p class="text-slate-500 text-sm">
                                                        팔로잉 중
                                                    </p>
                                                </div>
                                            </div>
                                            
                                            <div class="flex space-x-3">
                                                <a href="${pageContext.request.contextPath}/feed/user/${user.id}" 
                                                   class="flex-1 bg-blue-100 hover:bg-blue-200 text-blue-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                                    프로필 보기
                                                </a>
                                                <c:if test="${user.id != sessionScope.user.id}">
                                                    <button data-target-user-id="${user.id}"
                                                            class="toggle-follow-btn px-4 py-2 rounded-lg font-semibold transition-colors btn-secondary text-white">
                                                        언팔로우
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">👥</div>
                                    <h3 class="text-xl font-bold text-slate-800 mb-2">아직 팔로우하는 사람이 없습니다</h3>
                                    <p class="text-slate-600 mb-6">관심 있는 사람들을 팔로우해서 그들의 활동을 확인해보세요!</p>
                                    <a href="${pageContext.request.contextPath}/user/search" 
                                       class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                                        사람 찾기
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty followers}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach var="user" items="${followers}">
                                        <div class="card-hover rounded-2xl p-6 bg-white border border-slate-200">
                                            <div class="flex items-center space-x-4 mb-4">
                                                <div class="relative">
                                                    <mytag:image fileName="${user.profileImage}" 
                                                               altText="${user.nickname}" 
                                                               cssClass="w-16 h-16 rounded-full object-cover border-2 border-white shadow-lg" />
                                                    <div class="absolute -bottom-1 -right-1 w-5 h-5 bg-green-500 rounded-full border-2 border-white"></div>
                                                </div>
                                                <div class="flex-1">
                                                    <h3 class="text-lg font-bold text-slate-800">${user.nickname}</h3>
                                                    <p class="text-slate-500 text-sm">
                                                        나를 팔로우 중
                                                    </p>
                                                </div>
                                            </div>
                                            
                                            <div class="flex space-x-3">
                                                <a href="${pageContext.request.contextPath}/feed/user/${user.id}" 
                                                   class="flex-1 bg-blue-100 hover:bg-blue-200 text-blue-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                                    프로필 보기
                                                </a>
                                                <c:if test="${user.id != sessionScope.user.id}">
                                                    <button data-target-user-id="${user.id}"
                                                            class="toggle-follow-btn px-4 py-2 rounded-lg font-semibold transition-colors ${user.isFollowing ? 'btn-secondary text-white' : 'btn-primary text-white'}">
                                                        <c:choose>
                                                            <c:when test="${user.isFollowing}">언팔로우</c:when>
                                                            <c:otherwise>맞팔로우</c:otherwise>
                                                        </c:choose>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">👥</div>
                                    <h3 class="text-xl font-bold text-slate-800 mb-2">아직 팔로워가 없습니다</h3>
                                    <p class="text-slate-600 mb-6">더 많은 활동을 통해 팔로워를 늘려보세요!</p>
                                    <div class="flex justify-center space-x-4">
                                        <a href="${pageContext.request.contextPath}/review/write" 
                                           class="bg-orange-100 hover:bg-orange-200 text-orange-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                            리뷰 작성하기
                                        </a>
                                        <a href="${pageContext.request.contextPath}/column/write" 
                                           class="bg-purple-100 hover:bg-purple-200 text-purple-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                            칼럼 작성하기
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function toggleFollow(targetUserId, button) {
            // 현재 버튼 상태를 기반으로 action 결정
            const isCurrentlyFollowing = button.textContent.trim() === '언팔로우';
            const action = isCurrentlyFollowing ? 'unfollow' : 'follow';
            
            fetch('${pageContext.request.contextPath}/feed/toggle-follow', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=' + action + '&targetUserId=' + targetUserId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (action === 'follow') {
                        button.textContent = '언팔로우';
                        button.className = 'toggle-follow-btn px-4 py-2 rounded-lg font-semibold transition-colors btn-secondary text-white';
                    } else {
                        button.textContent = '팔로우';
                        button.className = 'toggle-follow-btn px-4 py-2 rounded-lg font-semibold transition-colors btn-primary text-white';
                    }
                } else {
                    alert(data.message || '오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        }
        
        // 페이지 로드 시 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.toggle-follow-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const targetUserId = this.getAttribute('data-target-user-id');
                    toggleFollow(targetUserId, this);
                });
            });
        });
    </script>
</body>
</html>
