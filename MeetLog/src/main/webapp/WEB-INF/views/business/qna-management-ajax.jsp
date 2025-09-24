<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Q&A 관리 (실시간) - MEET LOG</title>
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

        .qna-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 4px solid transparent;
        }
        .qna-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }
        .qna-card.pending { border-left-color: #f59e0b; }
        .qna-card.answered { border-left-color: #10b981; }
        .qna-card.closed { border-left-color: #6b7280; }

        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-weight: 600;
        }
        .status-pending { background-color: #fef3c7; color: #92400e; }
        .status-answered { background-color: #d1fae5; color: #065f46; }
        .status-closed { background-color: #f3f4f6; color: #374151; }

        .fade-in { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .reply-section {
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
            margin-top: 1rem;
            padding: 1rem;
            border-radius: 0 0 0.5rem 0.5rem;
        }

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
    </style>
</head>
<body>
    <!-- 실시간 알림 바 -->
    <div id="notificationBar" class="notification-bar bg-blue-500 text-white p-3">
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
                        <i class="fas fa-comments text-blue-500 mr-3"></i>Q&A 관리
                    </h1>
                    <p class="text-gray-600">실시간으로 고객 문의를 확인하고 답변하세요</p>
                </div>
                <div class="flex items-center space-x-4">
                    <div class="text-right">
                        <div class="text-2xl font-bold text-blue-600" id="totalQnACount">0</div>
                        <div class="text-sm text-gray-500">총 문의</div>
                    </div>
                    <div class="text-right">
                        <div class="text-2xl font-bold text-orange-600" id="pendingQnACount">0</div>
                        <div class="text-sm text-gray-500">답변대기</div>
                    </div>
                </div>
            </div>

            <!-- 실시간 상태 -->
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-2">
                    <div class="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
                    <span class="text-sm text-gray-600">실시간 모니터링 중</span>
                    <span class="text-xs text-gray-500">마지막 확인: <span id="lastCheckTime">--:--</span></span>
                </div>
                <div class="flex items-center space-x-2">
                    <button onclick="toggleAutoRefresh()" id="autoRefreshBtn"
                            class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors text-sm">
                        <i class="fas fa-sync-alt mr-2"></i>자동 새로고침 ON
                    </button>
                    <button onclick="refreshQnAs()"
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
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <select id="statusFilter" onchange="filterQnAs()"
                        class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="">모든 상태</option>
                    <option value="답변대기">답변대기</option>
                    <option value="답변완료">답변완료</option>
                    <option value="종료">종료</option>
                </select>
                <select id="sortOrder" onchange="filterQnAs()"
                        class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="latest">최신순</option>
                    <option value="oldest">오래된순</option>
                    <option value="pending">답변대기 우선</option>
                </select>
                <input type="text" id="searchKeyword" placeholder="제목이나 내용으로 검색..."
                       onkeyup="filterQnAs()"
                       class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>
        </div>

        <!-- Q&A 목록 -->
        <div id="qnaContainer">
            <!-- AJAX로 동적 로드 -->
        </div>

        <!-- 로딩 인디케이터 -->
        <div id="loadingIndicator" class="text-center py-8 hidden">
            <div class="loading-spinner mx-auto mb-4"></div>
            <p class="text-gray-500">Q&A를 불러오는 중...</p>
        </div>

        <!-- 빈 상태 -->
        <div id="emptyState" class="text-center py-16 hidden">
            <i class="fas fa-comments text-gray-300 text-6xl mb-4"></i>
            <h3 class="text-xl font-semibold text-gray-500 mb-2">등록된 문의가 없습니다</h3>
            <p class="text-gray-400">고객 문의가 들어오면 여기에 표시됩니다.</p>
        </div>
    </main>

    <!-- 답변 모달 -->
    <div id="replyModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-xl max-w-2xl w-full">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex items-center justify-between">
                        <h3 class="text-lg font-semibold text-gray-800">답변 작성</h3>
                        <button onclick="closeReplyModal()" class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div class="p-6">
                    <div class="mb-4">
                        <h4 class="font-medium text-gray-700 mb-2">문의 내용</h4>
                        <div id="modalQnaContent" class="bg-gray-50 p-4 rounded-lg text-sm text-gray-600">
                            <!-- 동적으로 설정 -->
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="replyContent" class="block text-sm font-medium text-gray-700 mb-2">답변 내용</label>
                        <textarea id="replyContent" rows="6"
                                  class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                  placeholder="고객에게 전달할 답변을 작성해주세요..."></textarea>
                    </div>
                    <div class="flex items-center justify-end space-x-3">
                        <button onclick="closeReplyModal()"
                                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            취소
                        </button>
                        <button onclick="submitReply()" id="submitReplyBtn"
                                class="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors">
                            <span class="submit-text">답변 등록</span>
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
        let currentQnAs = [];
        let currentReplyQnaId = null;

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            loadQnAs();
            startAutoRefresh();
        });

        // Q&A 목록 로드
        async function loadQnAs() {
            showLoading(true);
            try {
                const response = await fetch(`${pageContext.request.contextPath}/business/qna-management`, {
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
                    currentQnAs = result.qnas || [];
                    updateQnAStats(result.stats || {});
                    renderQnAs(currentQnAs);
                } else {
                    showError('Q&A 목록을 불러오는데 실패했습니다.');
                }
            } catch (error) {
                console.error('Error loading Q&As:', error);
                showError('Q&A 목록을 불러오는 중 오류가 발생했습니다.');
            } finally {
                showLoading(false);
                updateLastCheckTime();
            }
        }

        // Q&A 목록 렌더링
        function renderQnAs(qnas) {
            const container = document.getElementById('qnaContainer');

            if (!qnas || qnas.length === 0) {
                container.innerHTML = '';
                document.getElementById('emptyState').classList.remove('hidden');
                return;
            }

            document.getElementById('emptyState').classList.add('hidden');

            const html = qnas.map(qna => `
                <div class="glass-card qna-card ${qna.status === '답변대기' ? 'pending' : qna.status === '답변완료' ? 'answered' : 'closed'} rounded-xl p-6 mb-6 fade-in"
                     data-qna-id="${qna.id}" data-status="${qna.status}">
                    <div class="flex items-start justify-between mb-4">
                        <div class="flex-1">
                            <div class="flex items-center space-x-3 mb-2">
                                <h3 class="text-lg font-semibold text-gray-800">${escapeHtml(qna.title)}</h3>
                                <span class="status-badge status-${qna.status === '답변대기' ? 'pending' : qna.status === '답변완료' ? 'answered' : 'closed'}">
                                    ${qna.status}
                                </span>
                            </div>
                            <p class="text-sm text-gray-500 mb-2">
                                <i class="fas fa-user mr-1"></i>${escapeHtml(qna.customerName || '고객')} |
                                <i class="fas fa-clock mr-1"></i>${formatDateTime(qna.createdAt)}
                            </p>
                        </div>
                        <div class="flex items-center space-x-2">
                            ${qna.status === '답변대기' ? `
                                <button onclick="openReplyModal(${qna.id})"
                                        class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm">
                                    <i class="fas fa-reply mr-2"></i>답변하기
                                </button>
                            ` : ''}
                            <button onclick="toggleQnADetail(${qna.id})"
                                    class="px-3 py-2 border border-gray-300 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors text-sm">
                                <i class="fas fa-eye mr-1"></i>상세
                            </button>
                        </div>
                    </div>

                    <div class="text-gray-700 mb-4">
                        <div class="qna-content" id="content-${qna.id}">
                            ${escapeHtml(qna.content).length > 150 ?
                                escapeHtml(qna.content).substring(0, 150) + '...' :
                                escapeHtml(qna.content)}
                        </div>
                        ${qna.content.length > 150 ? `
                            <button onclick="toggleContent(${qna.id})" class="text-blue-500 hover:text-blue-600 text-sm mt-2">
                                더보기
                            </button>
                        ` : ''}
                    </div>

                    ${qna.answer ? `
                        <div class="reply-section">
                            <div class="flex items-center mb-2">
                                <i class="fas fa-reply text-green-500 mr-2"></i>
                                <span class="font-medium text-gray-800">답변</span>
                                <span class="text-sm text-gray-500 ml-auto">${formatDateTime(qna.answeredAt)}</span>
                            </div>
                            <div class="text-gray-700 text-sm">
                                ${escapeHtml(qna.answer)}
                            </div>
                        </div>
                    ` : ''}
                </div>
            `).join('');

            container.innerHTML = html;
        }

        // Q&A 통계 업데이트
        function updateQnAStats(stats) {
            document.getElementById('totalQnACount').textContent = stats.total || currentQnAs.length;
            document.getElementById('pendingQnACount').textContent = stats.pending ||
                currentQnAs.filter(qna => qna.status === '답변대기').length;
        }

        // 답변 모달 열기
        function openReplyModal(qnaId) {
            const qna = currentQnAs.find(q => q.id === qnaId);
            if (!qna) return;

            currentReplyQnaId = qnaId;
            document.getElementById('modalQnaContent').innerHTML = `
                <h5 class="font-medium text-gray-800 mb-2">${escapeHtml(qna.title)}</h5>
                <p class="text-gray-600">${escapeHtml(qna.content)}</p>
            `;
            document.getElementById('replyContent').value = '';
            document.getElementById('replyModal').classList.remove('hidden');
        }

        // 답변 모달 닫기
        function closeReplyModal() {
            document.getElementById('replyModal').classList.add('hidden');
            currentReplyQnaId = null;
        }

        // 답변 제출
        async function submitReply() {
            if (!currentReplyQnaId) return;

            const answer = document.getElementById('replyContent').value.trim();
            if (!answer) {
                alert('답변 내용을 입력해주세요.');
                return;
            }

            const submitBtn = document.getElementById('submitReplyBtn');
            const submitText = submitBtn.querySelector('.submit-text');
            const loadingSpinner = submitBtn.querySelector('.loading-spinner');

            // 로딩 상태
            submitBtn.disabled = true;
            submitText.textContent = '등록 중...';
            loadingSpinner.classList.remove('hidden');

            try {
                const response = await fetch(`${pageContext.request.contextPath}/business/qna/reply`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                    },
                    body: JSON.stringify({
                        qnaId: currentReplyQnaId,
                        answer: answer
                    })
                });

                const result = await response.json();

                if (result.success) {
                    showNotification('답변이 성공적으로 등록되었습니다!', 'success');
                    closeReplyModal();
                    await loadQnAs(); // 목록 새로고침
                } else {
                    alert(result.message || '답변 등록에 실패했습니다.');
                }
            } catch (error) {
                console.error('Error submitting reply:', error);
                alert('답변 등록 중 오류가 발생했습니다.');
            } finally {
                // 로딩 상태 해제
                submitBtn.disabled = false;
                submitText.textContent = '답변 등록';
                loadingSpinner.classList.add('hidden');
            }
        }

        // 필터링
        function filterQnAs() {
            const statusFilter = document.getElementById('statusFilter').value;
            const sortOrder = document.getElementById('sortOrder').value;
            const searchKeyword = document.getElementById('searchKeyword').value.toLowerCase();

            let filteredQnAs = [...currentQnAs];

            // 상태 필터
            if (statusFilter) {
                filteredQnAs = filteredQnAs.filter(qna => qna.status === statusFilter);
            }

            // 검색 키워드 필터
            if (searchKeyword) {
                filteredQnAs = filteredQnAs.filter(qna =>
                    qna.title.toLowerCase().includes(searchKeyword) ||
                    qna.content.toLowerCase().includes(searchKeyword)
                );
            }

            // 정렬
            if (sortOrder === 'latest') {
                filteredQnAs.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
            } else if (sortOrder === 'oldest') {
                filteredQnAs.sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt));
            } else if (sortOrder === 'pending') {
                filteredQnAs.sort((a, b) => {
                    if (a.status === '답변대기' && b.status !== '답변대기') return -1;
                    if (a.status !== '답변대기' && b.status === '답변대기') return 1;
                    return new Date(b.createdAt) - new Date(a.createdAt);
                });
            }

            renderQnAs(filteredQnAs);
        }

        // 자동 새로고침
        function startAutoRefresh() {
            if (autoRefreshInterval) clearInterval(autoRefreshInterval);

            autoRefreshInterval = setInterval(async () => {
                if (autoRefreshEnabled) {
                    await loadQnAs();
                    checkForNewQnAs();
                }
            }, 30000); // 30초마다
        }

        // 새로운 Q&A 확인
        async function checkForNewQnAs() {
            try {
                const response = await fetch(`${pageContext.request.contextPath}/business/qna/notifications`, {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' }
                });

                if (response.ok) {
                    const result = await response.json();
                    if (result.success && result.hasNewQnAs) {
                        showNotification(result.message, 'info');
                    }
                }
            } catch (error) {
                console.error('Error checking for new Q&As:', error);
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
        function refreshQnAs() {
            loadQnAs();
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

        function toggleContent(qnaId) {
            const element = document.getElementById(`content-${qnaId}`);
            const qna = currentQnAs.find(q => q.id === qnaId);
            if (!qna) return;

            const isExpanded = element.getAttribute('data-expanded') === 'true';

            if (isExpanded) {
                element.textContent = qna.content.substring(0, 150) + '...';
                element.setAttribute('data-expanded', 'false');
            } else {
                element.textContent = qna.content;
                element.setAttribute('data-expanded', 'true');
            }
        }

        function toggleQnADetail(qnaId) {
            // 상세 정보 토글 구현 (선택사항)
            console.log('Toggle detail for Q&A:', qnaId);
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