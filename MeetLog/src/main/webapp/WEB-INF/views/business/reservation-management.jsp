<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 관리 - MEET LOG</title>
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
        .btn-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-success:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(16, 185, 129, 0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .status-pending { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
        .status-confirmed { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        .status-cancelled { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">예약 관리</h1>
                <div class="flex space-x-4">
                    <select id="reservation-filter" class="px-4 py-2 border-2 border-slate-200 rounded-xl focus:border-blue-500 focus:outline-none">
                        <option value="all">전체</option>
                        <option value="PENDING">대기중</option>
                        <option value="CONFIRMED">확정</option>
                        <option value="CANCELLED">취소</option>
                        <option value="COMPLETED">완료</option>
                    </select>
                    <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                        📊 통계 보기
                    </button>
                </div>
            </div>

            <!-- 실시간 알림 바 -->
            <div id="reservation-notification-bar" class="hidden mb-6 p-4 bg-gradient-to-r from-emerald-500 to-teal-500 text-white rounded-2xl shadow-lg">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <span class="text-2xl">🔔</span>
                        <span id="reservation-notification-message" class="font-semibold"></span>
                    </div>
                    <button id="close-reservation-notification" class="text-white/80 hover:text-white text-xl">&times;</button>
                </div>
            </div>
            
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <c:forEach var="reservation" items="${reservations}">
                            <div class="glass-card p-6 rounded-2xl card-hover reservation-card" data-reservation-id="${reservation.id}" data-status="${reservation.status}">
                                <div class="flex justify-between items-start mb-4">
                                    <div class="flex-1">
                                        <h3 class="text-xl font-bold text-slate-800">${reservation.restaurantName}</h3>
                                        <p class="text-slate-600">예약자: ${reservation.customerName}</p>
                                        <p class="text-slate-600">연락처: ${reservation.customerPhone}</p>
                                    </div>
                                    <div class="text-right">
                                        <span class="reservation-status status-${reservation.status} text-white px-4 py-2 rounded-full text-sm font-semibold">
                                            ${reservation.status == 'PENDING' ? '대기중' :
                                              reservation.status == 'CONFIRMED' ? '확정' :
                                              reservation.status == 'CANCELLED' ? '취소' : '완료'}
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                                    <div class="p-4 bg-slate-50 rounded-xl">
                                        <p class="text-sm text-slate-600">예약 날짜</p>
                                        <p class="font-semibold text-slate-800">${reservation.reservationDate}</p>
                                    </div>
                                    <div class="p-4 bg-slate-50 rounded-xl">
                                        <p class="text-sm text-slate-600">예약 시간</p>
                                        <p class="font-semibold text-slate-800">${reservation.reservationTime}</p>
                                    </div>
                                    <div class="p-4 bg-slate-50 rounded-xl">
                                        <p class="text-sm text-slate-600">인원</p>
                                        <p class="font-semibold text-slate-800">${reservation.partySize}명</p>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty reservation.specialRequests}">
                                    <div class="p-4 bg-blue-50 rounded-xl mb-4">
                                        <p class="text-sm text-blue-600 font-semibold">특별 요청사항</p>
                                        <p class="text-blue-800">${reservation.specialRequests}</p>
                                    </div>
                                </c:if>
                                
                                <div class="reservation-actions flex space-x-2">
                                    <c:if test="${reservation.status == 'PENDING'}">
                                        <button type="button" class="status-update-btn btn-success text-white px-4 py-2 rounded-lg text-sm"
                                                data-reservation-id="${reservation.id}" data-new-status="CONFIRMED">
                                            <span class="button-text">확정</span>
                                            <span class="loading-spinner hidden">⏳</span>
                                        </button>
                                        <button type="button" class="status-update-btn btn-danger text-white px-4 py-2 rounded-lg text-sm"
                                                data-reservation-id="${reservation.id}" data-new-status="CANCELLED">
                                            <span class="button-text">거절</span>
                                            <span class="loading-spinner hidden">⏳</span>
                                        </button>
                                    </c:if>
                                    <c:if test="${reservation.status == 'CONFIRMED'}">
                                        <button type="button" class="status-update-btn btn-warning text-white px-4 py-2 rounded-lg text-sm"
                                                data-reservation-id="${reservation.id}" data-new-status="COMPLETED">
                                            <span class="button-text">완료</span>
                                            <span class="loading-spinner hidden">⏳</span>
                                        </button>
                                    </c:if>
                                    <button class="btn-secondary text-white px-4 py-2 rounded-lg text-sm">상세보기</button>
                                </div>

                                <!-- 상태 업데이트 메시지 -->
                                <div class="status-message mt-2 text-sm hidden"></div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">📅</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">예약이 없습니다</h3>
                            <p class="text-slate-500">아직 예약이 없습니다. 음식점을 등록하고 홍보해보세요!</p>
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
            initializeReservationManagement();
            startNotificationCheck();
        });

        function initializeReservationManagement() {
            // 필터링 기능
            const filterSelect = document.getElementById('reservation-filter');
            if (filterSelect) {
                filterSelect.addEventListener('change', handleStatusFilter);
            }

            // 상태 업데이트 버튼 이벤트 리스너
            document.querySelectorAll('.status-update-btn').forEach(button => {
                button.addEventListener('click', handleStatusUpdate);
            });

            // 알림 닫기 기능
            const closeNotification = document.getElementById('close-reservation-notification');
            if (closeNotification) {
                closeNotification.addEventListener('click', hideNotification);
            }

            // 카드 호버 효과
            initializeHoverEffects();
        }

        // 카드 호버 효과 초기화
        function initializeHoverEffects() {
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
        }

        // 상태 필터링
        function handleStatusFilter() {
            const selectedStatus = this.value;
            const reservationCards = document.querySelectorAll('.reservation-card');

            reservationCards.forEach(card => {
                const cardStatus = card.dataset.status;
                if (selectedStatus === 'all' || cardStatus === selectedStatus) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // 예약 상태 업데이트 (AJAX)
        async function handleStatusUpdate(event) {
            const button = event.target.closest('.status-update-btn');
            const reservationId = button.dataset.reservationId;
            const newStatus = button.dataset.newStatus;
            const card = button.closest('.reservation-card');
            const messageDiv = card.querySelector('.status-message');

            // 로딩 상태 표시
            showLoading(button, true);

            try {
                const response = await fetch(contextPath + '/business/reservation/update-status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        reservationId: parseInt(reservationId),
                        status: newStatus
                    })
                });

                const result = await response.json();

                if (result.success) {
                    // 성공 메시지 표시
                    showMessage(messageDiv, '예약 상태가 성공적으로 업데이트되었습니다.', 'success');

                    // UI 업데이트
                    updateReservationUI(card, newStatus, result.reservation);

                } else {
                    showMessage(messageDiv, result.message || '상태 업데이트에 실패했습니다.', 'error');
                }
            } catch (error) {
                console.error('예약 상태 업데이트 오류:', error);
                showMessage(messageDiv, '서버 연결에 실패했습니다.', 'error');
            } finally {
                showLoading(button, false);
            }
        }

        // 예약 UI 업데이트
        function updateReservationUI(card, newStatus, reservationData) {
            // 카드 상태 업데이트
            card.dataset.status = newStatus;

            // 상태 표시 업데이트
            const statusSpan = card.querySelector('.reservation-status');
            statusSpan.className = `reservation-status status-${newStatus} text-white px-4 py-2 rounded-full text-sm font-semibold`;

            const statusText = {
                'PENDING': '대기중',
                'CONFIRMED': '확정',
                'CANCELLED': '취소',
                'COMPLETED': '완료'
            };
            statusSpan.textContent = statusText[newStatus];

            // 액션 버튼 업데이트
            updateActionButtons(card, newStatus);

            // 현재 필터에 맞지 않으면 카드 숨김
            const currentFilter = document.getElementById('reservation-filter').value;
            if (currentFilter !== 'all' && currentFilter !== newStatus) {
                card.style.display = 'none';
            }
        }

        // 액션 버튼 업데이트
        function updateActionButtons(card, status) {
            const actionsDiv = card.querySelector('.reservation-actions');
            const reservationId = card.getAttribute('data-reservation-id');
            let buttonsHTML = '';

            if (status === 'PENDING') {
                buttonsHTML = `
                    <button type="button" class="status-update-btn btn-success text-white px-4 py-2 rounded-lg text-sm"
                            data-reservation-id="${reservationId}" data-new-status="CONFIRMED">
                        <span class="button-text">확정</span>
                        <span class="loading-spinner hidden">⏳</span>
                    </button>
                    <button type="button" class="status-update-btn btn-danger text-white px-4 py-2 rounded-lg text-sm"
                            data-reservation-id="${reservationId}" data-new-status="CANCELLED">
                        <span class="button-text">거절</span>
                        <span class="loading-spinner hidden">⏳</span>
                    </button>
                `;
            } else if (status === 'CONFIRMED') {
                buttonsHTML = `
                    <button type="button" class="status-update-btn btn-warning text-white px-4 py-2 rounded-lg text-sm"
                            data-reservation-id="${reservationId}" data-new-status="COMPLETED">
                        <span class="button-text">완료</span>
                        <span class="loading-spinner hidden">⏳</span>
                    </button>
                `;
            }

            buttonsHTML += '<button class="btn-secondary text-white px-4 py-2 rounded-lg text-sm">상세보기</button>';
            actionsDiv.innerHTML = buttonsHTML;

            // 새로운 버튼에 이벤트 리스너 추가
            actionsDiv.querySelectorAll('.status-update-btn').forEach(button => {
                button.addEventListener('click', handleStatusUpdate);
            });
        }

        // 실시간 새 예약 알림 체크
        function startNotificationCheck() {
            notificationCheckInterval = setInterval(checkNewReservations, 30000); // 30초마다 체크
        }

        async function checkNewReservations() {
            try {
                const response = await fetch(contextPath + '/business/reservation/notifications');
                const result = await response.json();

                if (result.success && result.hasNewReservations) {
                    showNotification(result.message);
                }
            } catch (error) {
                console.error('새 예약 알림 체크 오류:', error);
            }
        }

        // 알림 표시
        function showNotification(message) {
            const notificationBar = document.getElementById('reservation-notification-bar');
            const messageSpan = document.getElementById('reservation-notification-message');

            if (notificationBar && messageSpan) {
                messageSpan.textContent = message;
                notificationBar.classList.remove('hidden');

                // 5초 후 자동 숨김
                setTimeout(hideNotification, 5000);
            }
        }

        // 알림 숨김
        function hideNotification() {
            const notificationBar = document.getElementById('reservation-notification-bar');
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
