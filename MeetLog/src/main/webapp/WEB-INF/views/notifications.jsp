<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-secondary { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-2px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .notification-unread { border-left: 4px solid #3b82f6; background: linear-gradient(135deg, #dbeafe 0%, #f0f9ff 100%); }
        .notification-read { border-left: 4px solid #e5e7eb; background: #f9fafb; }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl fade-in">
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-4xl font-bold gradient-text mb-2">알림</h1>
                        <p class="text-slate-600">새로운 소식과 업데이트를 확인하세요</p>
                    </div>
                    <div class="flex space-x-4">
                        <c:if test="${unreadCount > 0}">
                            <button onclick="markAllAsRead()" class="btn-secondary text-white px-6 py-3 rounded-xl font-semibold">
                                모두 읽음
                            </button>
                        </c:if>
                        <button onclick="refreshNotifications()" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                            🔄 새로고침
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- 알림 통계 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="glass-card p-6 rounded-2xl card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">전체 알림</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty notifications ? notifications.size() : 0}</p>
                        </div>
                        <div class="text-4xl text-blue-500">📢</div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">읽지 않음</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty unreadCount ? unreadCount : 0}</p>
                        </div>
                        <div class="text-4xl text-red-500">🔴</div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">읽음</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty notifications ? notifications.size() - unreadCount : 0}</p>
                        </div>
                        <div class="text-4xl text-green-500">✅</div>
                    </div>
                </div>
            </div>
            
            <!-- 알림 목록 -->
            <c:choose>
                <c:when test="${not empty notifications}">
                    <div class="glass-card p-8 rounded-3xl slide-up">
                        <h2 class="text-2xl font-bold gradient-text mb-6">알림 목록</h2>
                        <div class="space-y-4">
                            <c:forEach var="notification" items="${notifications}">
                                <div class="p-6 rounded-2xl card-hover ${notification.read ? 'notification-read' : 'notification-unread'}" 
                                     id="notification-${notification.id}"
                                     <c:if test="${not empty notification.actionUrl}">data-action-url="${notification.actionUrl}" data-notification-id="${notification.id}" style="cursor: pointer;"</c:if>>
                                    <div class="flex items-start justify-between">
                                        <div class="flex-1">
                                            <div class="flex items-center space-x-3 mb-2">
                                                <h3 class="text-lg font-bold text-slate-800">${notification.title}</h3>
                                                <c:if test="${!notification.read}">
                                                    <span class="w-2 h-2 bg-blue-500 rounded-full"></span>
                                                </c:if>
                                                <span class="text-slate-500 text-sm">
                                                    ${notification.createdAt.format(DateTimeFormatter.ofPattern('MM/dd HH:mm'))}
                                                </span>
                                            </div>
                                            <p class="text-slate-700 mb-4">${notification.content}</p>
                                            <div class="flex items-center space-x-2">
                                                <span class="px-2 py-1 bg-slate-200 text-slate-700 text-xs rounded-full">
                                                    ${notification.type}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <c:if test="${!notification.read}">
                                                <button data-notification-id="${notification.id}" 
                                                        class="mark-read-btn text-blue-600 hover:text-blue-700 text-sm font-semibold">
                                                    읽음
                                                </button>
                                            </c:if>
                                            <button data-notification-id="${notification.id}" 
                                                    class="delete-btn text-red-600 hover:text-red-700 text-sm font-semibold">
                                                삭제
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="glass-card p-8 rounded-3xl slide-up">
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">📢</div>
                            <p class="text-slate-600 text-lg">알림이 없습니다</p>
                            <p class="text-slate-500 text-sm mt-2">새로운 소식이 있으면 여기에 표시됩니다</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function goToAction(actionUrl, notificationId) {
            // 읽지 않은 알림이면 읽음 처리
            const notification = document.getElementById('notification-' + notificationId);
            if (notification.classList.contains('notification-unread')) {
                markAsRead(notificationId);
            }
            // 액션 URL로 이동
            window.location.href = '${pageContext.request.contextPath}' + actionUrl;
        }
        
        function markAsRead(notificationId) {
            fetch('${pageContext.request.contextPath}/notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markAsRead&notificationId=' + notificationId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const notification = document.getElementById('notification-' + notificationId);
                    notification.classList.remove('notification-unread');
                    notification.classList.add('notification-read');
                    notification.querySelector('.bg-blue-500').remove();
                    location.reload();
                } else {
                    alert('알림을 읽음 처리할 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        }
        
        function markAllAsRead() {
            fetch('${pageContext.request.contextPath}/notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markAllAsRead'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('알림을 읽음 처리할 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        }
        
        function deleteNotification(notificationId) {
            if (confirm('이 알림을 삭제하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/notifications', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&notificationId=' + notificationId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('notification-' + notificationId).remove();
                        location.reload();
                    } else {
                        alert('알림을 삭제할 수 없습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function refreshNotifications() {
            location.reload();
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // 카드 호버 효과
            document.querySelectorAll('.card-hover').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-4px)';
                    this.style.boxShadow = '0 20px 40px rgba(0, 0, 0, 0.15)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.1)';
                });
            });
            
            // 읽음 처리 버튼 이벤트 리스너
            document.querySelectorAll('.mark-read-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const notificationId = this.getAttribute('data-notification-id');
                    markAsRead(notificationId);
                });
            });
            
            // 삭제 버튼 이벤트 리스너
            document.querySelectorAll('.delete-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const notificationId = this.getAttribute('data-notification-id');
                    deleteNotification(notificationId);
                });
            });
            
            // 알림 카드 클릭 이벤트 리스너 (actionUrl이 있는 경우)
            document.querySelectorAll('[data-action-url]').forEach(card => {
                card.addEventListener('click', function(event) {
                    // 버튼 클릭 시에는 카드 클릭 이벤트를 무시
                    if (event.target.tagName === 'BUTTON') {
                        return;
                    }
                    
                    const actionUrl = this.getAttribute('data-action-url');
                    const notificationId = this.getAttribute('data-notification-id');
                    goToAction(actionUrl, notificationId);
                });
            });
        });
    </script>
</body>
</html>
