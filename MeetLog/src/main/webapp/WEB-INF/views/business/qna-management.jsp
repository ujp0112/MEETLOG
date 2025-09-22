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
                                
                                <!-- 답변 작성 폼 -->
                                <c:if test="${qna.status == 'PENDING'}">
                                    <div class="mt-4">
                                        <form method="post" action="${pageContext.request.contextPath}/business/qna/reply" class="space-y-4">
                                            <input type="hidden" name="qnaId" value="${qna.id}">
                                            <div>
                                                <label class="block text-sm font-semibold text-slate-700 mb-2">답변 작성</label>
                                                <textarea name="answer" rows="4" placeholder="고객의 질문에 답변을 작성해주세요..." 
                                                          class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"></textarea>
                                            </div>
                                            <div class="flex space-x-3">
                                                <button type="submit" class="btn-success text-white px-6 py-2 rounded-lg">
                                                    답변 등록
                                                </button>
                                                <button type="button" onclick="closeQnA(${qna.id})" class="btn-warning text-white px-6 py-2 rounded-lg">
                                                    종료
                                                </button>
                                            </div>
                                        </form>
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
    
    <script>
        // 상태별 필터링
        function filterByStatus(status) {
            const qnaItems = document.querySelectorAll('.qna-item');
            qnaItems.forEach(item => {
                if (status === 'all' || item.dataset.status === status) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        // Q&A 답변 폼 제출
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const answer = this.querySelector('textarea[name="answer"]').value;
                if (answer.trim() === '') {
                    alert('답변 내용을 입력해주세요.');
                    return;
                }
                this.submit();
            });
        });
        
        // Q&A 종료
        function closeQnA(qnaId) {
            if (confirm('이 Q&A를 종료하시겠습니까?')) {
                // TODO: Q&A 종료 API 호출
                alert('Q&A가 종료되었습니다.');
            }
        }
        
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
