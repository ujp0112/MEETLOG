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
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">Q&A 관리</h1>
                <%-- <div class="flex space-x-4">
                    <select class="px-4 py-2 border-2 border-slate-200 rounded-xl focus:border-blue-500 focus:outline-none" onchange="filterByStatus(this.value)">
                        <option value="all">전체</option>
                        <option value="PENDING">답변 대기</option>
                        <option value="ANSWERED">답변 완료</option>
                    </select>
                </div> --%>
            </div>
            
            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div class="bg-blue-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('all')">
                    <div class="text-3xl font-bold text-blue-600">${totalQnA}</div>
                    <div class="text-slate-600">총 Q&A</div>
                </div>
                <div class="bg-yellow-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('PENDING')">
                    <div class="text-3xl font-bold text-yellow-600">${pendingQnA}</div>
                    <div class="text-slate-600">답변 대기</div>
                </div>
                <div class="bg-green-50 p-6 rounded-xl text-center cursor-pointer hover:shadow-lg transition-all" onclick="filterByStatus('ANSWERED')">
                    <div class="text-3xl font-bold text-green-600">${answeredQnA}</div>
                    <div class="text-slate-600">답변 완료</div>
                </div>
            </div>
            
            <!-- Q&A 목록 -->
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty qnaList}">
                        <c:forEach var="qna" items="${qnaList}">
                            <div class="glass-card p-6 rounded-2xl card-hover qna-item" data-status="${qna.status}" data-qna-id="${qna.id}">
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
                                            <fmt:formatDate value="${qna.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm"/>
                                        </p>
                                        <!-- 해결 완료 체크박스 (답변이 있을 때만 표시) -->
                                        <!-- <c:if test="${not empty qna.answer}">
                                            <div class="flex items-center mt-2">
                                                <input type="checkbox"
                                                       id="resolved-${qna.id}"
                                                       ${qna.isResolved ? 'checked' : ''}
                                                       onchange="toggleResolved(${qna.id}, this.checked)"
                                                       class="w-4 h-4 text-green-600 bg-gray-100 border-gray-300 rounded focus:ring-green-500">
                                                <label for="resolved-${qna.id}" class="ml-2 text-sm text-slate-600">해결 완료</label>
                                            </div>
                                        </c:if> -->
                                    </div>
                                </div>
                                
                                <!-- 질문 -->
                                <div class="mb-4">
                                    <h4 class="font-semibold text-slate-700 mb-2">질문</h4>
                                    <p class="text-slate-600 bg-slate-50 p-4 rounded-lg">${qna.question}</p>
                                </div>
                                
                                <!-- 답변 -->
                                <c:if test="${not empty qna.answer}">
                                    <div class="mb-4" id="answer-${qna.id}">
                                        <h4 class="font-semibold text-slate-700 mb-2">답변</h4>
                                        <p class="text-slate-600 bg-green-50 p-4 rounded-lg answer-content">${qna.answer}</p>
                                        <p class="text-slate-500 text-sm mt-2">
                                            답변일: <fmt:formatDate value="${qna.answeredAtAsDate}" pattern="yyyy-MM-dd HH:mm"/>
                                        </p>
                                    </div>
                                </c:if>
                                
                                <!-- 답변 작성 폼 -->
                                <c:if test="${qna.status == 'PENDING'}">
                                    <div class="mt-4" id="form-${qna.id}">
                                        <div class="space-y-4">
                                            <div>
                                                <label class="block text-sm font-semibold text-slate-700 mb-2">답변 작성</label>
                                                <textarea id="answer-${qna.id}" rows="4" placeholder="고객의 질문에 답변을 작성해주세요..."
                                                          class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"></textarea>
                                            </div>
                                            <div class="flex space-x-3">
                                                <button type="button" onclick="submitAnswer(${qna.id})" class="btn-success text-white px-6 py-2 rounded-lg">
                                                    답변 등록
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
    
    <!-- 답변 수정 모달 -->
    <div id="edit-answer-modal" class="hidden fixed inset-0 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center z-50">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl mx-4 p-6">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-xl font-semibold text-slate-800">답변 수정</h3>
                <button type="button" class="text-slate-400 hover:text-slate-600" onclick="closeEditModal()" aria-label="모달 닫기">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <div class="space-y-4">
                <p class="text-sm text-slate-500">기존 답변을 수정하여 저장할 수 있습니다.</p>
                <textarea id="edit-answer-content" rows="6" class="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none" placeholder="수정할 답변을 입력해주세요."></textarea>
                <div class="flex justify-end space-x-3">
                    <button type="button" class="px-5 py-2 rounded-lg border border-slate-300 text-slate-600 hover:bg-slate-50" onclick="closeEditModal()">취소</button>
                    <button type="button" id="edit-answer-submit" class="px-5 py-2 rounded-lg bg-gradient-to-r from-blue-500 to-indigo-500 text-white shadow hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" onclick="submitEditedAnswer()">저장</button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let currentEditQnaId = null;
        let isSubmittingEdit = false;

        // 상태별 필터링
        function filterByStatus(status) {
            const qnaItems = document.querySelectorAll('.qna-item');
            const selectElement = document.querySelector('select');

            // 드롭다운도 함께 업데이트
            if (selectElement) {
                selectElement.value = status;
            }

            qnaItems.forEach(item => {
                if (status === 'all' || item.dataset.status === status) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        function openEditModal(qnaId, existingAnswer) {
            currentEditQnaId = qnaId;
            const modal = document.getElementById('edit-answer-modal');
            const textarea = document.getElementById('edit-answer-content');
            textarea.value = existingAnswer || '';
            modal.classList.remove('hidden');
            textarea.focus();
        }

        function closeEditModal() {
            const modal = document.getElementById('edit-answer-modal');
            modal.classList.add('hidden');
            currentEditQnaId = null;
            isSubmittingEdit = false;
            document.getElementById('edit-answer-content').value = '';
            const submitButton = document.getElementById('edit-answer-submit');
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.textContent = '저장';
            }
        }

        // Q&A 답변 등록 (AJAX)
        function submitAnswer(qnaId) {
            const answerTextarea = document.getElementById('answer-' + qnaId);
            const content = answerTextarea.value.trim();

            if (content === '') {
                alert('답변 내용을 입력해주세요.');
                return;
            }

            const formData = new URLSearchParams();
            formData.append('action', 'addAnswer');
            formData.append('qnaId', qnaId);
            formData.append('answer', content);

            fetch('${pageContext.request.contextPath}/business/qna-management', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.reload(); // 페이지 새로고침으로 변경된 내용 표시
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
            });
        }

        function submitEditedAnswer() {
            if (currentEditQnaId == null || isSubmittingEdit) {
                return;
            }

            const textarea = document.getElementById('edit-answer-content');
            const content = textarea.value.trim();

            if (content === '') {
                alert('답변 내용을 입력해주세요.');
                textarea.focus();
                return;
            }

            isSubmittingEdit = true;
            const submitButton = document.getElementById('edit-answer-submit');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.textContent = '저장 중...';
            }

            const formData = new URLSearchParams();
            formData.append('action', 'updateAnswer');
            formData.append('qnaId', currentEditQnaId);
            formData.append('answer', content);

            fetch('${pageContext.request.contextPath}/business/qna-management', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 오류가 발생했습니다.');
                })
                .finally(() => {
                    isSubmittingEdit = false;
                    if (submitButton) {
                        submitButton.disabled = false;
                        submitButton.textContent = '저장';
                    }
                });
        }

        function editAnswer(qnaId) {
            const answerElement = document.querySelector('#answer-' + qnaId + ' .answer-content');
            const currentAnswer = answerElement ? answerElement.textContent.trim() : '';
            openEditModal(qnaId, currentAnswer);
        }

        // 해결완료 상태 토글 (AJAX)
        function toggleResolved(qnaId, isResolved) {
            const formData = new URLSearchParams();
            formData.append('action', 'toggleResolved');
            formData.append('qnaId', qnaId);
            formData.append('isResolved', isResolved);

            fetch('${pageContext.request.contextPath}/business/qna-management', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    console.log(data.message);
                    // 체크박스 상태는 이미 변경되어 있음
                } else {
                    alert(data.message);
                    // 실패 시 체크박스 상태 롤백
                    document.getElementById('resolved-' + qnaId).checked = !isResolved;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
                // 에러 시 체크박스 상태 롤백
                document.getElementById('resolved-' + qnaId).checked = !isResolved;
            });
        }

        // Q&A 종료
        function closeQnA(qnaId) {
            if (confirm('이 Q&A를 종료하시겠습니까?')) {
                const formData = new URLSearchParams();
                formData.append('action', 'closeQnA');
                formData.append('qnaId', qnaId);

                fetch('${pageContext.request.contextPath}/business/qna-management', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert(data.message);
                            location.reload();
                        } else {
                            alert(data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('서버 오류가 발생했습니다.');
                    });
            }
        }

        // 모달 바깥 클릭 시 닫기
        document.addEventListener('click', function(event) {
            const modal = document.getElementById('edit-answer-modal');
            if (!modal || modal.classList.contains('hidden')) {
                return;
            }
            if (event.target === modal) {
                closeEditModal();
            }
        });
    </script>
</body>
</html>
