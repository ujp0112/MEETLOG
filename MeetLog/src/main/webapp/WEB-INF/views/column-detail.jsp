<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - <c:out value="${column.title}" default="칼럼 상세" /></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .prose-content { white-space: pre-wrap; }
        .prose-content img {
            max-width: 100%;
            height: auto;
            margin-top: 1.5em;
            margin-bottom: 1.5em;
            border-radius: 0.5rem; /* 이미지 모서리를 살짝 둥글게 */
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1); /* 그림자 효과 */
        }
        /* 댓글 입력 UI 스타일 추가 */
        .form-input {
            display: block; width: 100%; border-radius: 0.5rem; border: 1px solid #cbd5e1; 
            padding: 0.75rem 1rem;
        }
        .form-input:focus {
            outline: 2px solid transparent; outline-offset: 2px; border-color: #38bdf8;
            box-shadow: 0 0 0 2px #7dd3fc;
        }
        .form-btn-primary {
            display: inline-flex; justify-content: center; border-radius: 0.5rem; background-color: #0284c7;
            padding: 0.5rem 1rem; font-weight: 600; color: white; transition: background-color 0.2s;
        }
        .form-btn-primary:hover { background-color: #0369a1; }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-4xl mx-auto">
                    <c:choose>
                        <c:when test="${not empty column}">
                            <article class="bg-white rounded-xl shadow-lg overflow-hidden">
                                <mytag:image fileName="${column.image}"
                                    altText="${column.title}"
                                    cssClass="w-full h-64 md:h-80 object-cover" />
                                <div class="p-6 md:p-8">
                                    <h1 class="text-2xl md:text-3xl font-bold text-slate-800 mb-4">${column.title}</h1>
                                    <div
                                        class="flex items-center justify-between mb-6 pb-4 border-b border-slate-200">
                                        <div class="flex items-center space-x-3">
                                            <mytag:image fileName="${column.profileImage}"
                                                altText="${column.author}"
                                                cssClass="w-10 h-10 rounded-full object-cover" />
                                            <div>
                                                <p class="font-semibold text-slate-800">${column.author}</p>
                                                <p class="text-sm text-slate-500">
                                                    <fmt:formatDate value="${column.createdAt}"
                                                        pattern="yyyy. MM. dd." />
                                                </p>
                                            </div>
                                        </div>
                                        <div
                                            class="flex items-center space-x-4 text-sm text-slate-500">
                                            <span class="flex items-center space-x-1"> <span>👁️</span>
                                                <span><c:out value="${column.views}" default="0" /></span>
                                            </span> <span class="flex items-center space-x-1"> <span>❤️</span>
                                                <span id="like-count-${column.id}"><c:out
                                                        value="${column.likes}" default="0" /></span>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="prose max-w-none text-slate-700 leading-relaxed">
                                        <div class="prose-content">
                                            <c:out value="${column.content}" escapeXml="false" />
                                        </div>
                                    </div>
                                    <div class="mt-8 pt-6 border-t border-slate-200">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <button onclick="likeColumn(${column.id})"
                                                    class="flex items-center space-x-2 px-4 py-2 bg-slate-100 hover:bg-red-100 hover:text-red-600 rounded-lg transition-colors">
                                                    <span>❤️</span> <span>좋아요</span>
                                                </button>
                                                <button onclick="shareColumn()"
                                                    class="flex items-center space-x-2 px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-lg transition-colors">
                                                    <span>📤</span> <span>공유</span>
                                                </button>
                                            </div>
                                            <c:if
                                                test="${not empty sessionScope.user and sessionScope.user.id == column.userId}">
                                                <div class="flex items-center space-x-2">
                                                    <a
                                                        href="${pageContext.request.contextPath}/column/edit?id=${column.id}"
                                                        class="px-4 py-2 text-slate-600 hover:text-slate-800 text-sm">수정</a>
                                                    <span class="text-slate-300">|</span>
                                                    <button onclick="deleteColumn(${column.id})"
                                                        class="px-4 py-2 text-red-600 hover:text-red-800 text-sm">삭제</button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </article>
                            <div class="mt-8">
                                <h3 class="text-xl font-bold text-slate-800 mb-4">댓글</h3>
                                <div class="bg-white rounded-xl shadow-lg p-6">
                                    <textarea class="form-input w-full mb-4"
                                        placeholder="따뜻한 댓글을 남겨주세요." rows="3"></textarea>
                                    <div class="text-right">
                                        <button class="form-btn-primary">댓글 등록</button>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-20">
                                <div class="text-6xl mb-4">📰</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">칼럼을 찾을 수
                                    없습니다.</h2>
                                <p class="text-slate-600 mb-6">요청하신 칼럼이 존재하지 않거나 삭제되었습니다.</p>
                                <a href="${pageContext.request.contextPath}/column"
                                    class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700 transition-colors">
                                    칼럼 목록으로 돌아가기 </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
    <script>
        // 좋아요 기능 (비동기 처리)
        function likeColumn(columnId) {
            fetch('${pageContext.request.contextPath}/api/column/like', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ columnId: columnId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                     const likeElement = document.getElementById('like-count-' + columnId);
                     if (likeElement) {
                        likeElement.textContent = data.likes; // 서버에서 받은 최신 좋아요 수로 업데이트
                    }
                } else {
                    alert(data.message || '처리 중 오류가 발생했습니다.');
                 }
            })
            .catch(error => console.error('Error:', error));
         }
        // 공유 기능
        function shareColumn() {
            if (navigator.share) {
                navigator.share({
                    title: '<c:out value="${column.title}" />',
                    text: 'MEET LOG에서 흥미로운 칼럼을 확인해보세요!',
                     url: window.location.href
                });
             } else {
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('링크가 클립보드에 복사되었습니다.');
                });
             }
        }
        // 칼럼 삭제 기능
        function deleteColumn(columnId) {
            if (confirm('정말로 이 칼럼을 삭제하시겠습니까? 되돌릴 수 없습니다.')) {
                const form = document.createElement('form');
                 form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/column/delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = columnId;
                form.appendChild(idInput);
                 document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>