<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 관리 - MEET LOG</title>
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
        .btn-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .rating-stars { filter: drop-shadow(0 2px 4px rgba(251, 191, 36, 0.3)); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">리뷰 관리</h1>
                <div class="flex space-x-4">
                    <select class="px-4 py-2 border-2 border-slate-200 rounded-xl focus:border-blue-500 focus:outline-none">
                        <option>전체</option>
                        <option>5점</option>
                        <option>4점</option>
                        <option>3점</option>
                        <option>2점</option>
                        <option>1점</option>
                    </select>
                    <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                        📊 리뷰 통계
                    </button>
                </div>
            </div>

            <!-- 실시간 알림 바 -->
            <div id="review-notification-bar" class="hidden mb-6 p-4 bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-2xl shadow-lg">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <span class="text-2xl">🔔</span>
                        <span id="notification-message" class="font-semibold"></span>
                    </div>
                    <button id="close-notification" class="text-white/80 hover:text-white text-xl">&times;</button>
                </div>
            </div>
            
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="review" items="${reviews}">
                            <div class="glass-card p-6 rounded-2xl card-hover">
                                <div class="flex justify-between items-start mb-4">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                            ${review.author.charAt(0)}
                                        </div>
                                        <div>
                                            <h3 class="font-bold text-slate-800">${review.author}</h3>
                                            <p class="text-slate-600 text-sm">${review.restaurantName}</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <div class="flex items-center space-x-2 mb-2">
                                            <div class="rating-stars flex space-x-1">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <span class="text-yellow-400 text-lg">★</span>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <span class="text-slate-300 text-lg">☆</span>
                                                </c:forEach>
                                            </div>
                                            <span class="text-slate-700 font-semibold">${review.rating}</span>
                                        </div>
                                        <p class="text-slate-500 text-sm">${review.createdAt}</p>
                                    </div>
                                </div>
                                
                                <p class="text-slate-700 leading-relaxed mb-4">${review.content}</p>
                                
                                <!-- 상세 평점 표시 -->
                                <c:if test="${review.tasteRating > 0}">
                                    <div class="p-4 bg-slate-50 rounded-xl mb-4">
                                        <h5 class="text-sm font-semibold text-slate-700 mb-3">상세 평점</h5>
                                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">맛:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.tasteRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.tasteRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">서비스:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.serviceRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.serviceRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">분위기:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.atmosphereRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.atmosphereRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">가격:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.priceRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.priceRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- 답글 작성 폼 (AJAX 버전) -->
                                <div class="mt-4">
                                    <div class="reply-form flex space-x-2" data-review-id="${review.id}">
                                        <input type="text" name="content" placeholder="리뷰에 답글을 작성하세요..."
                                               class="reply-input flex-1 px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                        <button type="button" class="reply-submit btn-secondary text-white px-6 py-2 rounded-lg">
                                            <span class="button-text">답글 작성</span>
                                            <span class="loading-spinner hidden">⏳</span>
                                        </button>
                                    </div>
                                    <div class="reply-message mt-2 text-sm hidden"></div>
                                </div>

                                <!-- 기존 답글 목록 -->
                                <div class="replies-container mt-4" data-review-id="${review.id}">
                                    <c:if test="${not empty review.replies}">
                                        <div class="ml-8 space-y-3">
                                            <c:forEach var="reply" items="${review.replies}">
                                                <div class="reply-item bg-slate-50 p-4 rounded-lg border-l-4 border-blue-500">
                                                    <div class="flex justify-between items-start mb-2">
                                                        <div class="flex items-center space-x-2">
                                                            <span class="text-blue-600 font-semibold text-sm">사장님</span>
                                                            <span class="text-slate-500 text-xs">${reply.createdAt}</span>
                                                        </div>
                                                    </div>
                                                    <p class="text-slate-700">${reply.content}</p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="flex items-center justify-between mt-4">
                                    <div class="flex items-center space-x-4">
                                        <button class="text-sky-600 hover:text-sky-700 text-sm font-semibold flex items-center space-x-1">
                                            <span>❤️</span>
                                            <span>${review.likes}</span>
                                        </button>
                                    </div>
                                    <div class="flex space-x-2">
                                        <c:if test="${review.rating <= 2}">
                                            <button class="btn-danger text-white px-4 py-2 rounded-lg text-sm">신고</button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">⭐</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">리뷰가 없습니다</h3>
                            <p class="text-slate-500">아직 리뷰가 없습니다. 음식점을 홍보해보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let notificationCheckInterval;

        // DOM 로드 후 초기화
        document.addEventListener('DOMContentLoaded', function() {
            initializeReviewManagement();
            startNotificationCheck();
        });

        function initializeReviewManagement() {
            // 필터링 기능
            const filterSelect = document.querySelector('select');
            if (filterSelect) {
                filterSelect.addEventListener('change', handleRatingFilter);
            }

            // 답글 작성 폼 이벤트 리스너
            document.querySelectorAll('.reply-submit').forEach(button => {
                button.addEventListener('click', handleReplySubmission);
            });

            // 알림 닫기 기능
            const closeNotification = document.getElementById('close-notification');
            if (closeNotification) {
                closeNotification.addEventListener('click', hideNotification);
            }
        }

        // 필터링 기능
        function handleRatingFilter() {
            const selectedRating = this.value;
            const reviewCards = document.querySelectorAll('.glass-card');

            reviewCards.forEach(card => {
                if (selectedRating === '전체') {
                    card.style.display = 'block';
                } else {
                    const ratingStars = card.querySelector('.rating-stars');
                    if (ratingStars) {
                        const filledStars = ratingStars.querySelectorAll('span[class*="text-yellow-400"]').length;
                        if (filledStars.toString() === selectedRating.charAt(0)) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    }
                }
            });
        }

        // 답글 작성 처리 (AJAX)
        async function handleReplySubmission(event) {
            const button = event.target;
            const form = button.closest('.reply-form');
            const reviewId = form.dataset.reviewId;
            const input = form.querySelector('.reply-input');
            const content = input.value.trim();
            const messageDiv = form.parentElement.querySelector('.reply-message');

            if (!content) {
                showMessage(messageDiv, '답글 내용을 입력해주세요.', 'error');
                return;
            }

            // 로딩 상태 표시
            showLoading(button, true);

            try {
                const response = await fetch(contextPath + '/business/review/reply', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        reviewId: parseInt(reviewId),
                        content: content
                    })
                });

                const result = await response.json();

                if (result.success) {
                    // 성공 메시지 표시
                    showMessage(messageDiv, '답글이 성공적으로 등록되었습니다.', 'success');

                    // 입력 필드 초기화
                    input.value = '';

                    // 답글 목록에 새 답글 추가
                    addReplyToDOM(reviewId, result.reply);

                } else {
                    showMessage(messageDiv, result.message || '답글 등록에 실패했습니다.', 'error');
                }
            } catch (error) {
                console.error('답글 등록 오류:', error);
                showMessage(messageDiv, '서버 연결에 실패했습니다.', 'error');
            } finally {
                showLoading(button, false);
            }
        }

        // DOM에 새 답글 추가
        function addReplyToDOM(reviewId, reply) {
            const repliesContainer = document.querySelector(`[data-review-id="${reviewId}"].replies-container`);
            if (!repliesContainer) return;

            let repliesList = repliesContainer.querySelector('.ml-8');
            if (!repliesList) {
                repliesList = document.createElement('div');
                repliesList.className = 'ml-8 space-y-3';
                repliesContainer.appendChild(repliesList);
            }

            const replyElement = document.createElement('div');
            replyElement.className = 'reply-item bg-slate-50 p-4 rounded-lg border-l-4 border-blue-500 fade-in';
            replyElement.innerHTML = `
                <div class="flex justify-between items-start mb-2">
                    <div class="flex items-center space-x-2">
                        <span class="text-blue-600 font-semibold text-sm">사장님</span>
                        <span class="text-slate-500 text-xs">방금 전</span>
                    </div>
                </div>
                <p class="text-slate-700">${reply.content}</p>
            `;

            repliesList.appendChild(replyElement);
        }

        // 실시간 새 리뷰 알림 체크
        function startNotificationCheck() {
            notificationCheckInterval = setInterval(checkNewReviews, 30000); // 30초마다 체크
        }

        async function checkNewReviews() {
            try {
                const response = await fetch(contextPath + '/business/review/notifications');
                const result = await response.json();

                if (result.success && result.hasNewReviews) {
                    showNotification(result.message);
                }
            } catch (error) {
                console.error('새 리뷰 알림 체크 오류:', error);
            }
        }

        // 알림 표시
        function showNotification(message) {
            const notificationBar = document.getElementById('review-notification-bar');
            const messageSpan = document.getElementById('notification-message');

            if (notificationBar && messageSpan) {
                messageSpan.textContent = message;
                notificationBar.classList.remove('hidden');

                // 5초 후 자동 숨김
                setTimeout(hideNotification, 5000);
            }
        }

        // 알림 숨김
        function hideNotification() {
            const notificationBar = document.getElementById('review-notification-bar');
            if (notificationBar) {
                notificationBar.classList.add('hidden');
            }
        }

        // 로딩 상태 표시
        function showLoading(button, isLoading) {
            const buttonText = button.querySelector('.button-text');
            const loadingSpinner = button.querySelector('.loading-spinner');

            if (isLoading) {
                buttonText.classList.add('hidden');
                loadingSpinner.classList.remove('hidden');
                button.disabled = true;
            } else {
                buttonText.classList.remove('hidden');
                loadingSpinner.classList.add('hidden');
                button.disabled = false;
            }
        }

        // 메시지 표시
        function showMessage(messageDiv, message, type) {
            messageDiv.textContent = message;
            messageDiv.className = `mt-2 text-sm ${type === 'success' ? 'text-green-600' : 'text-red-600'}`;
            messageDiv.classList.remove('hidden');

            // 3초 후 메시지 숨김
            setTimeout(() => {
                messageDiv.classList.add('hidden');
            }, 3000);
        }

        // 페이지 언로드 시 정리
        window.addEventListener('beforeunload', function() {
            if (notificationCheckInterval) {
                clearInterval(notificationCheckInterval);
            }
        });
    </script>
</body>
</html>
