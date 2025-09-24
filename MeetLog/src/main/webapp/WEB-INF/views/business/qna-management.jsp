<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Q&A 관리 - MEET LOG</title>
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
        .btn-warning { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-warning:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(245, 158, 11, 0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .status-pending { background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%); }
        .status-answered { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        .status-closed { background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <!-- 실시간 알림 바 -->
        <div id="notification-bar" class="hidden mb-4">
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 flex items-center justify-between">
                <div class="flex items-center space-x-2">
                    <div class="animate-pulse w-2 h-2 bg-blue-500 rounded-full"></div>
                    <span class="text-blue-800" id="notification-text"></span>
                </div>
                <button onclick="hideNotification()" class="text-blue-600 hover:text-blue-800">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
        </div>

        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold gradient-text">Q&A 관리</h1>
                    <p class="text-slate-600 mt-2">고객 문의사항을 실시간으로 확인하고 답변하세요</p>
                </div>
                <div class="flex space-x-4">
                    <select class="px-4 py-2 border-2 border-slate-200 rounded-xl focus:border-blue-500 focus:outline-none" onchange="filterByStatus(this.value)">
                        <option value="all">전체</option>
                        <option value="PENDING">답변 대기</option>
                        <option value="ANSWERED">답변 완료</option>
                        <option value="CLOSED">종료</option>
                    </select>
                    <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold" onclick="showStatistics()">
                        📊 Q&A 통계
                    </button>
                </div>
            </div>
            
            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div class="bg-blue-50 p-6 rounded-xl text-center">
                    <div class="text-3xl font-bold text-blue-600">${totalQnA}</div>
                    <div class="text-slate-600">총 Q&A</div>
                </div>
                <div class="bg-yellow-50 p-6 rounded-xl text-center">
                    <div class="text-3xl font-bold text-yellow-600">${pendingQnA}</div>
                    <div class="text-slate-600">답변 대기</div>
                </div>
                <div class="bg-green-50 p-6 rounded-xl text-center">
                    <div class="text-3xl font-bold text-green-600">${answeredQnA}</div>
                    <div class="text-slate-600">답변 완료</div>
                </div>
            </div>
            
            <!-- Q&A 목록 -->
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty qnaList}">
                        <c:forEach var="qna" items="${qnaList}">
                            <div class="glass-card p-6 rounded-2xl card-hover qna-item" data-status="${qna.status}">
                                <div class="flex justify-between items-start mb-4">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 bg-gradient-to-r from-blue-400 to-purple-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                            ${qna.userName.charAt(0)}
                                        </div>
                                        <div>
                                            <h3 class="font-bold text-slate-800">${qna.userName}</h3>
                                            <p class="text-slate-600 text-sm">${qna.restaurantName}</p>
                                            <p class="text-slate-500 text-xs">${qna.userEmail}</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <span class="px-3 py-1 rounded-full text-white text-sm font-semibold status-${qna.status.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${qna.status == 'PENDING'}">답변 대기</c:when>
                                                <c:when test="${qna.status == 'ANSWERED'}">답변 완료</c:when>
                                                <c:when test="${qna.status == 'CLOSED'}">종료</c:when>
                                                <c:otherwise>${qna.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <p class="text-slate-500 text-sm mt-2">
                                            <fmt:formatDate value="${qna.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        </p>
                                    </div>
                                </div>
                                
                                <!-- 질문 -->
                                <div class="mb-4">
                                    <h4 class="font-semibold text-slate-700 mb-2">질문</h4>
                                    <p class="text-slate-600 bg-slate-50 p-4 rounded-lg">${qna.question}</p>
                                </div>
                                
                                <!-- 답변 -->
                                <c:if test="${not empty qna.answer}">
                                    <div class="mb-4">
                                        <h4 class="font-semibold text-slate-700 mb-2">답변</h4>
                                        <p class="text-slate-600 bg-green-50 p-4 rounded-lg">${qna.answer}</p>
                                        <p class="text-slate-500 text-sm mt-2">
                                            답변일: <fmt:formatDate value="${qna.answeredAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        </p>
                                    </div>
                                </c:if>
                                
                                <!-- 답변 작성 폼 (AJAX 기반) -->
                                <c:if test="${qna.status == 'PENDING'}">
                                    <div class="mt-4" id="answerForm_${qna.id}">
                                        <div class="space-y-4">
                                            <div>
                                                <label class="block text-sm font-semibold text-slate-700 mb-2">답변 작성</label>
                                                <textarea id="answer_${qna.id}" rows="4" placeholder="고객의 질문에 답변을 작성해주세요..."
                                                          class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"></textarea>
                                            </div>
                                            <div class="flex space-x-3">
                                                <button onclick="submitAnswer(${qna.id})" class="btn-success text-white px-6 py-2 rounded-lg">
                                                    <span class="answer-btn-text">답변 등록</span>
                                                    <span class="answer-loading hidden">
                                                        <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white inline" fill="none" viewBox="0 0 24 24">
                                                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                                        </svg>
                                                        등록 중...
                                                    </span>
                                                </button>
                                                <button type="button" onclick="closeQnA(${qna.id})" class="btn-warning text-white px-6 py-2 rounded-lg">
                                                    종료
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- 답변 완료된 경우 -->
                                <c:if test="${qna.status == 'ANSWERED'}">
                                    <div class="flex space-x-3">
                                        <button onclick="editAnswer(${qna.id})" class="btn-secondary text-white px-4 py-2 rounded-lg text-sm">
                                            답변 수정
                                        </button>
                                        <button onclick="closeQnA(${qna.id})" class="btn-warning text-white px-4 py-2 rounded-lg text-sm">
                                            종료
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">❓</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">Q&A가 없습니다</h3>
                            <p class="text-slate-500">아직 고객의 문의사항이 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <!-- Q&A 실시간 관리 시스템 JavaScript -->
    <script>
        // 전역 변수
        let qnaUpdateInterval;
        const contextPath = '${pageContext.request.contextPath}';

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            initRealtimeQnA();
            setupEventListeners();
            startQnAUpdates();
        });

        /**
         * 실시간 Q&A 시스템 초기화
         */
        function initRealtimeQnA() {
            console.log('실시간 Q&A 시스템이 시작되었습니다.');
            showNotification('실시간 Q&A 모니터링이 활성화되었습니다. 📞');
        }

        /**
         * 실시간 업데이트 시작
         */
        function startQnAUpdates() {
            // 30초마다 새로운 Q&A 확인
            qnaUpdateInterval = setInterval(function() {
                checkForNewQnA();
            }, 30000);
        }

        /**
         * 새로운 Q&A 확인
         */
        function checkForNewQnA() {
            fetch(contextPath + '/business/qna/check-new', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.hasNew) {
                    showNotification(`새로운 질문 ${data.count}개가 등록되었습니다! 🔔`);
                    refreshQnAList();
                }
            })
            .catch(error => {
                console.log('Q&A 업데이트 확인 실패:', error);
            });
        }

        /**
         * Q&A 답변 제출 (AJAX)
         */
        function submitAnswer(qnaId) {
            const answerText = document.getElementById(`answer_${qnaId}`).value;

            if (answerText.trim() === '') {
                showErrorNotification('답변 내용을 입력해주세요.');
                return;
            }

            // 버튼 상태 변경
            const button = document.querySelector(`#answerForm_${qnaId} button`);
            toggleButtonLoading(button, true);

            fetch(contextPath + '/business/qna/reply', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    qnaId: qnaId,
                    answer: answerText
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccessNotification('답변이 성공적으로 등록되었습니다! ✅');
                    updateQnAItem(qnaId, data.qna);
                } else {
                    showErrorNotification(data.message || '답변 등록에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('답변 등록 오류:', error);
                showErrorNotification('답변 등록 중 오류가 발생했습니다.');
            })
            .finally(() => {
                toggleButtonLoading(button, false);
            });
        }

        /**
         * Q&A 종료 (AJAX)
         */
        function closeQnA(qnaId) {
            if (!confirm('이 Q&A를 종료하시겠습니까?')) {
                return;
            }

            fetch(contextPath + '/business/qna/close', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ qnaId: qnaId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccessNotification('Q&A가 종료되었습니다.');
                    updateQnAStatus(qnaId, 'CLOSED');
                } else {
                    showErrorNotification(data.message || 'Q&A 종료에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Q&A 종료 오류:', error);
                showErrorNotification('Q&A 종료 중 오류가 발생했습니다.');
            });
        }

        /**
         * 답변 수정
         */
        function editAnswer(qnaId) {
            // TODO: 답변 수정 모달 또는 인라인 에디터 구현
            showNotification('답변 수정 기능을 준비 중입니다.');
        }

        /**
         * 상태별 필터링
         */
        function filterByStatus(status) {
            const qnaItems = document.querySelectorAll('.qna-item');
            qnaItems.forEach(item => {
                if (status === 'all' || item.dataset.status === status) {
                    item.style.display = 'block';
                    item.classList.add('fade-in');
                } else {
                    item.style.display = 'none';
                    item.classList.remove('fade-in');
                }
            });

            // 통계 업데이트 애니메이션
            updateStatistics();
        }

        /**
         * 통계 업데이트
         */
        function updateStatistics() {
            const totalItems = document.querySelectorAll('.qna-item').length;
            const visibleItems = document.querySelectorAll('.qna-item[style*="block"], .qna-item:not([style*="none"])').length;

            // 통계 표시 (실제 구현 시 추가)
            console.log(`전체: ${totalItems}, 표시: ${visibleItems}`);
        }

        /**
         * Q&A 목록 새로고침
         */
        function refreshQnAList() {
            showLoading();

            fetch(contextPath + '/business/qna/list', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateQnAListUI(data.qnaList);
                    showSuccessNotification('목록이 업데이트되었습니다.');
                } else {
                    showErrorNotification('목록 새로고침에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('목록 새로고침 오류:', error);
                showErrorNotification('목록 새로고침 중 오류가 발생했습니다.');
            })
            .finally(() => {
                hideLoading();
            });
        }

        /**
         * Q&A 아이템 업데이트
         */
        function updateQnAItem(qnaId, qnaData) {
            const qnaElement = document.querySelector(`[data-qna-id="${qnaId}"]`);
            if (qnaElement) {
                // 답변 섹션 추가/업데이트
                const answerSection = createAnswerSection(qnaData);
                const answerForm = qnaElement.querySelector(`#answerForm_${qnaId}`);

                if (answerForm) {
                    answerForm.innerHTML = answerSection;
                }

                // 상태 업데이트
                updateQnAStatus(qnaId, qnaData.status);
            }
        }

        /**
         * Q&A 상태 업데이트
         */
        function updateQnAStatus(qnaId, newStatus) {
            const qnaElement = document.querySelector(`[data-qna-id="${qnaId}"]`);
            if (qnaElement) {
                qnaElement.dataset.status = newStatus;

                // 상태 배지 업데이트
                const statusBadge = qnaElement.querySelector('.status-badge');
                if (statusBadge) {
                    updateStatusBadge(statusBadge, newStatus);
                }
            }
        }

        /**
         * 상태 배지 업데이트
         */
        function updateStatusBadge(badge, status) {
            const statusConfig = {
                'PENDING': { class: 'status-pending', text: '답변 대기' },
                'ANSWERED': { class: 'status-answered', text: '답변 완료' },
                'CLOSED': { class: 'status-closed', text: '종료' }
            };

            const config = statusConfig[status] || statusConfig['PENDING'];
            badge.className = `px-3 py-1 rounded-full text-xs font-semibold ${config.class}`;
            badge.textContent = config.text;
        }

        /**
         * 답변 섹션 생성
         */
        function createAnswerSection(qnaData) {
            if (qnaData.status === 'ANSWERED' && qnaData.answer) {
                return `
                    <div class="mb-4">
                        <h4 class="font-semibold text-slate-700 mb-2">답변</h4>
                        <p class="text-slate-600 bg-green-50 p-4 rounded-lg">${qnaData.answer}</p>
                        <p class="text-slate-500 text-sm mt-2">
                            답변일: ${new Date(qnaData.answeredAt).toLocaleString()}
                        </p>
                    </div>
                    <div class="flex space-x-3">
                        <button onclick="editAnswer(${qnaData.id})" class="btn-secondary text-white px-4 py-2 rounded-lg text-sm">
                            답변 수정
                        </button>
                        <button onclick="closeQnA(${qnaData.id})" class="btn-warning text-white px-4 py-2 rounded-lg text-sm">
                            종료
                        </button>
                    </div>
                `;
            }
            return '<p class="text-slate-500 text-center">답변이 등록되었습니다.</p>';
        }

        /**
         * 알림 표시
         */
        function showNotification(message, type = 'info') {
            const notificationBar = document.getElementById('notification-bar');
            const notificationText = document.getElementById('notification-text');

            notificationText.textContent = message;
            notificationBar.classList.remove('hidden');

            // 3초 후 자동 숨김
            setTimeout(() => {
                hideNotification();
            }, 3000);
        }

        /**
         * 성공 알림
         */
        function showSuccessNotification(message) {
            showNotification(message, 'success');
        }

        /**
         * 에러 알림
         */
        function showErrorNotification(message) {
            showNotification(message, 'error');
        }

        /**
         * 알림 숨김
         */
        function hideNotification() {
            document.getElementById('notification-bar').classList.add('hidden');
        }

        /**
         * 로딩 상태 표시
         */
        function showLoading() {
            document.body.style.cursor = 'wait';
        }

        /**
         * 로딩 상태 해제
         */
        function hideLoading() {
            document.body.style.cursor = 'default';
        }

        /**
         * 버튼 로딩 상태 토글
         */
        function toggleButtonLoading(button, isLoading) {
            const btnText = button.querySelector('.answer-btn-text');
            const loadingSpan = button.querySelector('.answer-loading');

            if (isLoading) {
                btnText.classList.add('hidden');
                loadingSpan.classList.remove('hidden');
                button.disabled = true;
            } else {
                btnText.classList.remove('hidden');
                loadingSpan.classList.add('hidden');
                button.disabled = false;
            }
        }

        /**
         * 이벤트 리스너 설정
         */
        function setupEventListeners() {
            // 페이지 언로드 시 인터벌 정리
            window.addEventListener('beforeunload', function() {
                if (qnaUpdateInterval) {
                    clearInterval(qnaUpdateInterval);
                }
            });

            // 키보드 단축키 (Ctrl+R: 새로고침)
            document.addEventListener('keydown', function(e) {
                if (e.ctrlKey && e.key === 'r') {
                    e.preventDefault();
                    refreshQnAList();
                }
            });
        }

        /**
         * 통계 보기
         */
        function showStatistics() {
            showNotification('통계 기능을 준비 중입니다.');
        }
    </script>
</body>
</html>
        
        // 답변 수정
        function editAnswer(qnaId) {
            // TODO: 답변 수정 모달 또는 페이지로 이동
            alert('답변 수정 기능은 준비 중입니다.');
        }
        
        // Q&A 통계 모달 표시
        function showStatistics() {
            alert('Q&A 통계 기능은 준비 중입니다.');
        }
    </script>
</body>
</html>
