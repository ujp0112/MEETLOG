<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 관리 (실시간) - MEET LOG</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <meta name="csrf-token" content="${sessionScope.CSRF_TOKEN}">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .reservation-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 4px solid transparent;
        }
        .reservation-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }
        .reservation-card.pending { border-left-color: #f59e0b; }
        .reservation-card.confirmed { border-left-color: #10b981; }
        .reservation-card.cancelled { border-left-color: #ef4444; }
        .reservation-card.completed { border-left-color: #6b7280; }

        .status-badge {
            font-size: 0.75rem;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-weight: 600;
        }
        .status-pending { background-color: #fef3c7; color: #92400e; }
        .status-confirmed { background-color: #d1fae5; color: #065f46; }
        .status-cancelled { background-color: #fee2e2; color: #991b1b; }
        .status-completed { background-color: #f3f4f6; color: #374151; }

        .notification-bar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            transform: translateY(-100%);
            transition: transform 0.3s ease-in-out;
        }
        .notification-bar.show {
            transform: translateY(0);
        }

        .loading-spinner {
            border: 2px solid #f3f4f6;
            border-top: 2px solid #3b82f6;
            border-radius: 50%;
            width: 16px;
            height: 16px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .fade-in { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .pulse-animation {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
    </style>
</head>
<body>
    <!-- 실시간 알림 바 -->
    <div id="notificationBar" class="notification-bar bg-green-500 text-white p-3">
        <div class="container mx-auto flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <i class="fas fa-bell animate-pulse"></i>
                <span id="notificationText"></span>
            </div>
            <button onclick="hideNotification()" class="text-white hover:text-gray-200">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8 mt-4">
        <!-- 헤더 섹션 -->
        <div class="glass-card rounded-xl p-6 mb-8 fade-in">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-3xl font-bold text-gray-800 mb-2">
                        <i class="fas fa-calendar-check text-green-500 mr-3"></i>예약 관리
                    </h1>
                    <p class="text-gray-600">실시간으로 예약 현황을 확인하고 관리하세요</p>
                </div>
                <div class="flex items-center space-x-4">
                    <div class="text-right">
                        <div class="text-2xl font-bold text-blue-600" id="totalReservationCount">0</div>
                        <div class="text-sm text-gray-500">총 예약</div>
                    </div>
                    <div class="text-right">
                        <div class="text-2xl font-bold text-orange-600" id="pendingReservationCount">0</div>
                        <div class="text-sm text-gray-500">승인대기</div>
                    </div>
                    <div class="text-right">
                        <div class="text-2xl font-bold text-green-600" id="confirmedReservationCount">0</div>
                        <div class="text-sm text-gray-500">확정</div>
                    </div>
                </div>
            </div>

            <!-- 실시간 상태 -->
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-2">
                    <div class="w-3 h-3 bg-green-500 rounded-full pulse-animation"></div>
                    <span class="text-sm text-gray-600">실시간 모니터링 중</span>
                    <span class="text-xs text-gray-500">마지막 확인: <span id="lastCheckTime">--:--</span></span>
                </div>
                <div class="flex items-center space-x-2">
                    <button onclick="toggleAutoRefresh()" id="autoRefreshBtn"
                            class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors text-sm">
                        <i class="fas fa-sync-alt mr-2"></i>자동 새로고침 ON
                    </button>
                    <button onclick="refreshReservations()"
                            class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm">
                        <i class="fas fa-refresh mr-2"></i>새로고침
                    </button>
                </div>
            </div>
        </div>

        <!-- 필터 및 검색 -->
        <div class="glass-card rounded-xl p-6 mb-8 fade-in">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-semibold text-gray-800">필터 및 검색</h3>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <select id="statusFilter" onchange="filterReservations()"
                        class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="">모든 상태</option>
                    <option value="PENDING">승인대기</option>
                    <option value="CONFIRMED">확정</option>
                    <option value="CANCELLED">취소</option>
                    <option value="COMPLETED">완료</option>
                </select>
                <select id="dateFilter" onchange="filterReservations()"
                        class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="">모든 날짜</option>
                    <option value="today">오늘</option>
                    <option value="tomorrow">내일</option>
                    <option value="week">이번주</option>
                    <option value="month">이번달</option>
                </select>
                <select id="sortOrder" onchange="filterReservations()"
                        class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="latest">최신순</option>
                    <option value="oldest">오래된순</option>
                    <option value="date">예약날짜순</option>
                    <option value="pending">승인대기 우선</option>
                </select>
                <input type="text" id="searchKeyword" placeholder="예약자명, 연락처로 검색..."
                       onkeyup="filterReservations()"
                       class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>
        </div>

        <!-- 예약 목록 -->
        <div id="reservationContainer">
            <!-- AJAX로 동적 로드 -->
        </div>

        <!-- 로딩 인디케이터 -->
        <div id="loadingIndicator" class="text-center py-8 hidden">
            <div class="loading-spinner mx-auto mb-4"></div>
            <p class="text-gray-500">예약 목록을 불러오는 중...</p>
        </div>

        <!-- 빈 상태 -->
        <div id="emptyState" class="text-center py-16 hidden">
            <i class="fas fa-calendar-times text-gray-300 text-6xl mb-4"></i>
            <h3 class="text-xl font-semibold text-gray-500 mb-2">예약이 없습니다</h3>
            <p class="text-gray-400">새로운 예약이 들어오면 여기에 표시됩니다.</p>
        </div>
    </main>

    <!-- 예약 상태 변경 모달 -->
    <div id="statusModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-xl max-w-md w-full">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex items-center justify-between">
                        <h3 class="text-lg font-semibold text-gray-800">예약 상태 변경</h3>
                        <button onclick="closeStatusModal()" class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div class="p-6">
                    <div class="mb-4">
                        <h4 class="font-medium text-gray-700 mb-2">예약 정보</h4>
                        <div id="modalReservationInfo" class="bg-gray-50 p-4 rounded-lg text-sm text-gray-600">
                            <!-- 동적으로 설정 -->
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="newStatus" class="block text-sm font-medium text-gray-700 mb-2">새 상태</label>
                        <select id="newStatus" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="PENDING">승인대기</option>
                            <option value="CONFIRMED">확정</option>
                            <option value="CANCELLED">취소</option>
                            <option value="COMPLETED">완료</option>
                        </select>
                    </div>
                    <div class="flex items-center justify-end space-x-3">
                        <button onclick="closeStatusModal()"
                                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            취소
                        </button>
                        <button onclick="submitStatusChange()" id="submitStatusBtn"
                                class="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors">
                            <span class="submit-text">상태 변경</span>
                            <div class="loading-spinner hidden ml-2"></div>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 전역 변수
        let autoRefreshEnabled = true;
        let autoRefreshInterval;
        let currentReservations = [];
        let currentReservationId = null;

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            loadReservations();
            startAutoRefresh();
        });

        // 예약 목록 로드
        async function loadReservations() {
            showLoading(true);
            try {
                const response = await fetch(`${pageContext.request.contextPath}/business/reservation-management`, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const result = await response.json();

                if (result.success) {
                    currentReservations = result.reservations || [];
                    updateReservationStats(result.stats || {});
                    renderReservations(currentReservations);
                } else {
                    showError('예약 목록을 불러오는데 실패했습니다.');
                }
            } catch (error) {
                console.error('Error loading reservations:', error);
                showError('예약 목록을 불러오는 중 오류가 발생했습니다.');
            } finally {
                showLoading(false);
                updateLastCheckTime();
            }
        }

        // 예약 목록 렌더링
        function renderReservations(reservations) {
            const container = document.getElementById('reservationContainer');

            if (!reservations || reservations.length === 0) {
                container.innerHTML = '';
                document.getElementById('emptyState').classList.remove('hidden');
                return;
            }

            document.getElementById('emptyState').classList.add('hidden');

            const html = reservations.map(reservation => `
                <div class="glass-card reservation-card ${reservation.status.toLowerCase()} rounded-xl p-6 mb-6 fade-in"
                     data-reservation-id="${reservation.id}" data-status="${reservation.status}">
                    <div class="flex items-start justify-between mb-4">
                        <div class="flex-1">
                            <div class="flex items-center space-x-3 mb-2">
                                <h3 class="text-lg font-semibold text-gray-800">${escapeHtml(reservation.customerName)}</h3>
                                <span class="status-badge status-${reservation.status.toLowerCase()}">
                                    ${getStatusText(reservation.status)}
                                </span>
                                ${reservation.isNew ? '<span class="bg-red-500 text-white text-xs px-2 py-1 rounded-full">NEW</span>' : ''}
                            </div>
                            <p class="text-sm text-gray-500 mb-1">
                                <i class="fas fa-phone mr-1"></i>${escapeHtml(reservation.customerPhone || '연락처 없음')}
                            </p>
                            <p class="text-sm text-gray-500">
                                <i class="fas fa-utensils mr-1"></i>${escapeHtml(reservation.restaurantName || '레스토랑 정보 없음')}
                            </p>
                        </div>
                        <div class="flex items-center space-x-2">
                            ${reservation.status !== 'COMPLETED' && reservation.status !== 'CANCELLED' ? `
                                <button onclick="openStatusModal(${reservation.id})"
                                        class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm">
                                    <i class="fas fa-edit mr-2"></i>상태 변경
                                </button>
                            ` : ''}
                            <button onclick="toggleReservationDetail(${reservation.id})"
                                    class="px-3 py-2 border border-gray-300 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors text-sm">
                                <i class="fas fa-eye mr-1"></i>상세
                            </button>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                        <div class="bg-gray-50 p-4 rounded-lg">
                            <div class="text-sm text-gray-600 mb-1">예약 날짜</div>
                            <div class="font-semibold text-gray-800">
                                <i class="fas fa-calendar mr-2 text-blue-500"></i>
                                ${formatDate(reservation.reservationDate)}
                            </div>
                        </div>
                        <div class="bg-gray-50 p-4 rounded-lg">
                            <div class="text-sm text-gray-600 mb-1">예약 시간</div>
                            <div class="font-semibold text-gray-800">
                                <i class="fas fa-clock mr-2 text-green-500"></i>
                                ${reservation.reservationTime}
                            </div>
                        </div>
                        <div class="bg-gray-50 p-4 rounded-lg">
                            <div class="text-sm text-gray-600 mb-1">인원</div>
                            <div class="font-semibold text-gray-800">
                                <i class="fas fa-users mr-2 text-purple-500"></i>
                                ${reservation.partySize}명
                            </div>
                        </div>
                    </div>

                    ${reservation.specialRequests ? `
                        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                            <div class="flex items-center mb-1">
                                <i class="fas fa-exclamation-circle text-yellow-600 mr-2"></i>
                                <span class="text-sm font-medium text-yellow-800">특별 요청사항</span>
                            </div>
                            <p class="text-sm text-yellow-700">${escapeHtml(reservation.specialRequests)}</p>
                        </div>
                    ` : ''}

                    <div class="flex items-center justify-between mt-4 pt-4 border-t border-gray-200">
                        <div class="text-sm text-gray-500">
                            등록일: ${formatDateTime(reservation.createdAt)}
                        </div>
                        ${reservation.updatedAt !== reservation.createdAt ? `
                            <div class="text-sm text-gray-500">
                                수정일: ${formatDateTime(reservation.updatedAt)}
                            </div>
                        ` : ''}
                    </div>
                </div>
            `).join('');

            container.innerHTML = html;
        }

        // 예약 통계 업데이트
        function updateReservationStats(stats) {
            const total = stats.total || currentReservations.length;
            const pending = stats.pending || currentReservations.filter(r => r.status === 'PENDING').length;
            const confirmed = stats.confirmed || currentReservations.filter(r => r.status === 'CONFIRMED').length;

            document.getElementById('totalReservationCount').textContent = total;
            document.getElementById('pendingReservationCount').textContent = pending;
            document.getElementById('confirmedReservationCount').textContent = confirmed;
        }

        // 상태 변경 모달 열기
        function openStatusModal(reservationId) {
            const reservation = currentReservations.find(r => r.id === reservationId);
            if (!reservation) return;

            currentReservationId = reservationId;
            document.getElementById('modalReservationInfo').innerHTML = `
                <h5 class="font-medium text-gray-800 mb-2">${escapeHtml(reservation.customerName)}</h5>
                <div class="grid grid-cols-2 gap-2 text-sm">
                    <div>날짜: ${formatDate(reservation.reservationDate)}</div>
                    <div>시간: ${reservation.reservationTime}</div>
                    <div>인원: ${reservation.partySize}명</div>
                    <div>현재 상태: ${getStatusText(reservation.status)}</div>
                </div>
            `;
            document.getElementById('newStatus').value = reservation.status;
            document.getElementById('statusModal').classList.remove('hidden');
        }

        // 상태 변경 모달 닫기
        function closeStatusModal() {
            document.getElementById('statusModal').classList.add('hidden');
            currentReservationId = null;
        }

        // 상태 변경 제출
        async function submitStatusChange() {
            if (!currentReservationId) return;

            const newStatus = document.getElementById('newStatus').value;
            if (!newStatus) {
                alert('새로운 상태를 선택해주세요.');
                return;
            }

            const submitBtn = document.getElementById('submitStatusBtn');
            const submitText = submitBtn.querySelector('.submit-text');
            const loadingSpinner = submitBtn.querySelector('.loading-spinner');

            // 로딩 상태
            submitBtn.disabled = true;
            submitText.textContent = '변경 중...';
            loadingSpinner.classList.remove('hidden');

            try {
                const response = await fetch(`${pageContext.request.contextPath}/business/reservation/update-status`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                    },
                    body: JSON.stringify({
                        reservationId: currentReservationId,
                        status: newStatus
                    })
                });

                const result = await response.json();

                if (result.success) {
                    showNotification('예약 상태가 성공적으로 변경되었습니다!', 'success');
                    closeStatusModal();
                    await loadReservations(); // 목록 새로고침
                } else {
                    alert(result.message || '상태 변경에 실패했습니다.');
                }
            } catch (error) {
                console.error('Error updating reservation status:', error);
                alert('상태 변경 중 오류가 발생했습니다.');
            } finally {
                // 로딩 상태 해제
                submitBtn.disabled = false;
                submitText.textContent = '상태 변경';
                loadingSpinner.classList.add('hidden');
            }
        }

        // 필터링
        function filterReservations() {
            const statusFilter = document.getElementById('statusFilter').value;
            const dateFilter = document.getElementById('dateFilter').value;
            const sortOrder = document.getElementById('sortOrder').value;
            const searchKeyword = document.getElementById('searchKeyword').value.toLowerCase();

            let filteredReservations = [...currentReservations];

            // 상태 필터
            if (statusFilter) {
                filteredReservations = filteredReservations.filter(r => r.status === statusFilter);
            }

            // 날짜 필터
            if (dateFilter) {
                const now = new Date();
                filteredReservations = filteredReservations.filter(r => {
                    const reservationDate = new Date(r.reservationDate);
                    switch (dateFilter) {
                        case 'today':
                            return reservationDate.toDateString() === now.toDateString();
                        case 'tomorrow':
                            const tomorrow = new Date(now);
                            tomorrow.setDate(tomorrow.getDate() + 1);
                            return reservationDate.toDateString() === tomorrow.toDateString();
                        case 'week':
                            const weekFromNow = new Date(now);
                            weekFromNow.setDate(weekFromNow.getDate() + 7);
                            return reservationDate >= now && reservationDate <= weekFromNow;
                        case 'month':
                            return reservationDate.getMonth() === now.getMonth() &&
                                   reservationDate.getFullYear() === now.getFullYear();
                        default:
                            return true;
                    }
                });
            }

            // 검색 키워드 필터
            if (searchKeyword) {
                filteredReservations = filteredReservations.filter(r =>
                    r.customerName.toLowerCase().includes(searchKeyword) ||
                    (r.customerPhone && r.customerPhone.includes(searchKeyword))
                );
            }

            // 정렬
            filteredReservations.sort((a, b) => {
                switch (sortOrder) {
                    case 'latest':
                        return new Date(b.createdAt) - new Date(a.createdAt);
                    case 'oldest':
                        return new Date(a.createdAt) - new Date(b.createdAt);
                    case 'date':
                        return new Date(a.reservationDate) - new Date(b.reservationDate);
                    case 'pending':
                        if (a.status === 'PENDING' && b.status !== 'PENDING') return -1;
                        if (a.status !== 'PENDING' && b.status === 'PENDING') return 1;
                        return new Date(b.createdAt) - new Date(a.createdAt);
                    default:
                        return 0;
                }
            });

            renderReservations(filteredReservations);
        }

        // 자동 새로고침
        function startAutoRefresh() {
            if (autoRefreshInterval) clearInterval(autoRefreshInterval);

            autoRefreshInterval = setInterval(async () => {
                if (autoRefreshEnabled) {
                    await loadReservations();
                    checkForNewReservations();
                }
            }, 30000); // 30초마다
        }

        // 새로운 예약 확인
        async function checkForNewReservations() {
            try {
                const response = await fetch(`${pageContext.request.contextPath}/business/reservation/notifications`, {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' }
                });

                if (response.ok) {
                    const result = await response.json();
                    if (result.success && result.hasNewReservations) {
                        showNotification(result.message, 'info');
                    }
                }
            } catch (error) {
                console.error('Error checking for new reservations:', error);
            }
        }

        // 자동 새로고침 토글
        function toggleAutoRefresh() {
            autoRefreshEnabled = !autoRefreshEnabled;
            const btn = document.getElementById('autoRefreshBtn');

            if (autoRefreshEnabled) {
                btn.innerHTML = '<i class="fas fa-sync-alt mr-2"></i>자동 새로고침 ON';
                btn.className = 'px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors text-sm';
            } else {
                btn.innerHTML = '<i class="fas fa-pause mr-2"></i>자동 새로고침 OFF';
                btn.className = 'px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors text-sm';
            }
        }

        // 유틸리티 함수들
        function refreshReservations() {
            loadReservations();
        }

        function showLoading(show) {
            document.getElementById('loadingIndicator').classList.toggle('hidden', !show);
        }

        function updateLastCheckTime() {
            document.getElementById('lastCheckTime').textContent = new Date().toLocaleTimeString();
        }

        function showNotification(message, type = 'info') {
            const bar = document.getElementById('notificationBar');
            const text = document.getElementById('notificationText');

            text.textContent = message;
            bar.className = `notification-bar show ${type === 'success' ? 'bg-green-500' : type === 'error' ? 'bg-red-500' : 'bg-blue-500'} text-white p-3`;

            setTimeout(() => hideNotification(), 5000);
        }

        function hideNotification() {
            document.getElementById('notificationBar').classList.remove('show');
        }

        function showError(message) {
            showNotification(message, 'error');
        }

        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function formatDateTime(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleString('ko-KR');
        }

        function formatDate(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleDateString('ko-KR');
        }

        function getStatusText(status) {
            const statusMap = {
                'PENDING': '승인대기',
                'CONFIRMED': '확정',
                'CANCELLED': '취소',
                'COMPLETED': '완료'
            };
            return statusMap[status] || status;
        }

        function toggleReservationDetail(reservationId) {
            // 상세 정보 토글 구현 (선택사항)
            console.log('Toggle detail for reservation:', reservationId);
        }

        // 페이지 언로드시 자동 새로고침 정리
        window.addEventListener('beforeunload', function() {
            if (autoRefreshInterval) {
                clearInterval(autoRefreshInterval);
            }
        });
    </script>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>