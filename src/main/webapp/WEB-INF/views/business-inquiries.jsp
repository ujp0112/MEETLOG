<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비즈니스 문의 관리 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="mb-8">
                <h1 class="text-3xl font-bold gradient-text mb-2">💬 문의 관리</h1>
                <p class="text-slate-600">고객 문의사항을 확인하고 답변하세요</p>
            </div>
            
            <!-- 통계 카드 섹션 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">총 문의</p>
                            <p class="text-3xl font-bold text-slate-800">${totalInquiries}</p>
                        </div>
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">📝</span>
                        </div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">답변 대기</p>
                            <p class="text-3xl font-bold text-orange-600">${pendingInquiries}</p>
                        </div>
                        <div class="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">⏳</span>
                        </div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">답변 완료</p>
                            <p class="text-3xl font-bold text-green-600">${answeredInquiries}</p>
                        </div>
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 문의 목록 -->
            <div class="glass-card p-6 rounded-2xl">
                <h2 class="text-2xl font-bold text-slate-800 mb-6">문의 목록</h2>
                
                <c:choose>
                    <c:when test="${not empty inquiries}">
                        <div class="space-y-4">
                            <c:forEach var="inquiry" items="${inquiries}">
                                <div class="border border-slate-200 rounded-lg p-6 hover:shadow-md transition-shadow">
                                    <div class="flex items-start justify-between mb-4">
                                        <div class="flex-1">
                                            <h3 class="text-lg font-semibold text-slate-800 mb-2">${inquiry.title}</h3>
                                            <p class="text-slate-600 text-sm mb-2">${inquiry.content}</p>
                                            <div class="flex items-center space-x-4 text-sm text-slate-500">
                                                <span>📅 <fmt:formatDate value="${inquiry.createdAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                                                <span>👤 ${inquiry.userName}</span>
                                                <span>📧 ${inquiry.userEmail}</span>
                                            </div>
                                        </div>
                                        <div class="ml-4">
                                            <c:choose>
                                                <c:when test="${'PENDING'.equals(inquiry.status)}">
                                                    <span class="px-3 py-1 bg-orange-100 text-orange-800 rounded-full text-xs font-medium">답변 대기</span>
                                                </c:when>
                                                <c:when test="${'ANSWERED'.equals(inquiry.status)}">
                                                    <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">답변 완료</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-3 py-1 bg-gray-100 text-gray-800 rounded-full text-xs font-medium">처리중</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty inquiry.answer}">
                                        <div class="mt-4 p-4 bg-slate-50 rounded-lg">
                                            <h4 class="font-semibold text-slate-700 mb-2">답변:</h4>
                                            <p class="text-slate-600">${inquiry.answer}</p>
                                            <p class="text-xs text-slate-500 mt-2">
                                                답변일: <fmt:formatDate value="${inquiry.answeredAt}" pattern="yyyy-MM-dd HH:mm"/>
                                            </p>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${'PENDING'.equals(inquiry.status)}">
                                        <div class="mt-4 flex space-x-2">
                                            <button onclick="answerInquiry(${inquiry.id})" 
                                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium">
                                                답변하기
                                            </button>
                                            <button onclick="viewInquiry(${inquiry.id})" 
                                                    class="px-4 py-2 bg-slate-600 text-white rounded-lg hover:bg-slate-700 transition-colors text-sm font-medium">
                                                상세보기
                                            </button>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">💬</div>
                            <h3 class="text-xl font-bold text-slate-600 mb-2">문의가 없습니다</h3>
                            <p class="text-slate-500">고객으로부터 문의가 들어오면 여기에 표시됩니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function answerInquiry(inquiryId) {
            const answer = prompt('답변을 입력하세요:');
            if (answer && answer.trim()) {
                // 답변 전송 로직 (추후 구현)
                fetch('${pageContext.request.contextPath}/business/inquiries/answer', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'inquiryId=' + inquiryId + '&answer=' + encodeURIComponent(answer)
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('답변 저장 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('답변 저장 중 오류가 발생했습니다.');
                });
            }
        }
        
        function viewInquiry(inquiryId) {
            // 문의 상세보기 로직 (추후 구현)
            window.open('${pageContext.request.contextPath}/business/inquiries/' + inquiryId, '_blank');
        }
    </script>
</body>
</html>
