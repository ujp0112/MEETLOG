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
                                                <button id="column-like-btn-${column.id}" onclick="likeColumn(${column.id})"
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
                                <h3 class="text-xl font-bold text-slate-800 mb-4">댓글 (<span id="comment-count">${commentCount}</span>)</h3>

                                <!-- 댓글 입력 폼 -->
                                <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <textarea id="comment-content" class="form-input w-full mb-4"
                                                placeholder="따뜻한 댓글을 남겨주세요." rows="3"></textarea>
                                            <div class="text-right">
                                                <button id="submit-comment" class="form-btn-primary">댓글 등록</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-slate-500 text-center py-4">
                                                <a href="${pageContext.request.contextPath}/login" class="text-sky-600 hover:text-sky-700">로그인</a>하시면 댓글을 작성할 수 있습니다.
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- 댓글 목록 -->
                                <div id="comments-list" class="space-y-4">
                                    <c:choose>
                                        <c:when test="${not empty comments}">
                                            <c:forEach var="comment" items="${comments}">
                                                <div class="bg-white rounded-xl shadow-sm p-6 comment-item" data-comment-id="${comment.id}">
                                                    <div class="flex items-start space-x-3">
                                                        <mytag:image fileName="${comment.profileImage}"
                                                            altText="${comment.author}"
                                                            cssClass="w-10 h-10 rounded-full object-cover flex-shrink-0" />
                                                        <div class="flex-1">
                                                            <div class="flex items-center justify-between mb-2">
                                                                <h4 class="font-semibold text-slate-800">${comment.author}</h4>
                                                                <div class="flex items-center space-x-2 comment-actions">
                                                                    <span class="text-sm text-slate-500">
                                                                        ${comment.createdAt.toString().substring(0, 16).replace('T', ' ')}
                                                                    </span>
                                                                    <c:if test="${not empty sessionScope.user and sessionScope.user.id == comment.userId}">
                                                                        <button onclick="editComment(${comment.id})" class="text-blue-500 hover:text-blue-700 text-sm">수정</button>
                                                                        <button onclick="deleteComment(${comment.id})" class="text-red-500 hover:text-red-700 text-sm">삭제</button>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <p id="comment-content-${comment.id}" class="text-slate-700 leading-relaxed">${comment.content}</p>
                                                            <div class="mt-2 flex items-center space-x-4">
                                                                <button id="comment-like-btn-${comment.id}" onclick="likeComment(${comment.id})" class="flex items-center space-x-1 text-slate-600 hover:text-red-500 transition-colors">
                                                                    <span>❤️</span>
                                                                    <span id="comment-like-count-${comment.id}">${comment.likeCount > 0 ? comment.likeCount : 0}</span>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-8 text-slate-500">
                                                <p>아직 댓글이 없습니다. 첫 번째 댓글을 남겨보세요!</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
        // 댓글 등록 기능
        document.addEventListener('DOMContentLoaded', function() {
            const submitBtn = document.getElementById('submit-comment');
            if (submitBtn) {
                submitBtn.addEventListener('click', submitComment);
            }
        });

        function submitComment() {
            const content = document.getElementById('comment-content').value.trim();
            if (!content) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }

            const formData = new URLSearchParams();
            formData.append('columnId', ${column.id});
            formData.append('content', content);

            fetch('${pageContext.request.contextPath}/api/column/comment/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('네트워크 응답이 올바르지 않습니다.');
                }
                return response.json();
            })
            .then(data => {
                console.log('서버 응답:', data);
                if (data.success) {
                    // 댓글 입력창 초기화
                    document.getElementById('comment-content').value = '';

                    // 댓글 목록 새로고침
                    refreshComments();

                    alert('댓글이 등록되었습니다.');
                } else {
                    alert(data.message || '댓글 등록에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('댓글 등록 중 네트워크 오류가 발생했습니다.');
            });
        }

        function deleteComment(commentId) {
            if (!confirm('댓글을 삭제하시겠습니까?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/api/column/comment/delete/' + commentId, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 댓글 목록 새로고침
                    refreshComments();
                    alert('댓글이 삭제되었습니다.');
                } else {
                    alert(data.message || '댓글 삭제에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('댓글 삭제 중 오류가 발생했습니다.');
            });
        }

        function refreshComments() {
            // 페이지 새로고침 대신 AJAX로 댓글 목록만 업데이트
            location.reload();
        }

        // 전역 변수로 원본 내용 저장
        let originalCommentContent = {};

        function editComment(commentId) {
            const commentElement = document.getElementById('comment-content-' + commentId);
            const currentContent = commentElement.textContent.trim();

            console.log('수정 모드 진입:', commentId, currentContent);

            // 원본 내용 저장
            originalCommentContent[commentId] = currentContent;

            // textarea 생성
            const textarea = document.createElement('textarea');
            textarea.id = 'edit-textarea-' + commentId;
            textarea.className = 'w-full p-3 border border-slate-300 rounded-lg resize-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500';
            textarea.rows = 3;
            textarea.value = currentContent;

            // 버튼 컨테이너 생성
            const buttonContainer = document.createElement('div');
            buttonContainer.className = 'mt-2 flex space-x-2';

            // 저장 버튼 생성
            const saveButton = document.createElement('button');
            saveButton.className = 'px-4 py-2 bg-sky-600 text-white font-semibold rounded-lg hover:bg-sky-700 text-sm';
            saveButton.textContent = '저장';
            saveButton.onclick = function() { saveComment(commentId); };

            // 취소 버튼 생성
            const cancelButton = document.createElement('button');
            cancelButton.className = 'px-4 py-2 bg-slate-300 text-slate-700 font-semibold rounded-lg hover:bg-slate-400 text-sm';
            cancelButton.textContent = '취소';
            cancelButton.onclick = function() { cancelEdit(commentId); };

            // 버튼들을 컨테이너에 추가
            buttonContainer.appendChild(saveButton);
            buttonContainer.appendChild(cancelButton);

            // 기존 내용을 교체
            commentElement.innerHTML = '';
            commentElement.appendChild(textarea);
            commentElement.appendChild(buttonContainer);

            // 기존 수정/삭제 버튼 숨기기
            const actionButtons = commentElement.parentElement.querySelector('.comment-actions');
            if (actionButtons) {
                actionButtons.style.display = 'none';
            }

            // textarea에 포커스
            textarea.focus();
        }

        function cancelEdit(commentId) {
            console.log('수정 취소:', commentId, originalCommentContent[commentId]);

            const commentElement = document.getElementById('comment-content-' + commentId);

            // 원본 내용으로 복원
            commentElement.innerHTML = '';
            commentElement.textContent = originalCommentContent[commentId];

            // 기존 수정/삭제 버튼 다시 보이기
            const actionButtons = commentElement.parentElement.querySelector('.comment-actions');
            if (actionButtons) {
                actionButtons.style.display = 'flex';
            }

            // 저장된 원본 내용 정리
            delete originalCommentContent[commentId];
        }

        function saveComment(commentId) {
            const textarea = document.getElementById('edit-textarea-' + commentId);
            if (!textarea) {
                alert('수정할 수 없습니다.');
                return;
            }

            const newContent = textarea.value.trim();
            console.log('댓글 저장 시도:', commentId, newContent);

            if (!newContent) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }

            // 저장 중 버튼 비활성화
            const saveButton = textarea.parentElement.querySelector('button');
            if (saveButton) {
                saveButton.disabled = true;
                saveButton.textContent = '저장 중...';
            }

            fetch('${pageContext.request.contextPath}/api/column/comment/', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    commentId: commentId,
                    content: newContent
                })
            })
            .then(response => {
                console.log('HTTP 응답 상태:', response.status, response.statusText);
                console.log('응답 헤더:', response.headers.get('content-type'));

                if (!response.ok) {
                    throw new Error(`서버 응답 오류: ${response.status} ${response.statusText}`);
                }
                return response.text().then(text => {
                    console.log('원본 응답 텍스트:', text);
                    try {
                        return JSON.parse(text);
                    } catch (e) {
                        console.error('JSON 파싱 오류:', e);
                        throw new Error('서버 응답을 JSON으로 파싱할 수 없습니다: ' + text);
                    }
                });
            })
            .then(data => {
                console.log('파싱된 서버 응답:', data);
                if (data.success) {
                    // 댓글 내용 업데이트 (페이지 새로고침 대신)
                    const commentElement = document.getElementById('comment-content-' + commentId);
                    commentElement.innerHTML = '';
                    commentElement.textContent = newContent;

                    // 수정/삭제 버튼 다시 보이기
                    const actionButtons = commentElement.parentElement.querySelector('.comment-actions');
                    if (actionButtons) {
                        actionButtons.style.display = 'flex';
                    }

                    // 저장된 원본 내용 정리
                    delete originalCommentContent[commentId];

                    alert('댓글이 수정되었습니다.');
                } else {
                    alert(data.message || '댓글 수정에 실패했습니다.');
                    // 버튼 복원
                    if (saveButton) {
                        saveButton.disabled = false;
                        saveButton.textContent = '저장';
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('댓글 수정 중 오류가 발생했습니다.');
                // 버튼 복원
                if (saveButton) {
                    saveButton.disabled = false;
                    saveButton.textContent = '저장';
                }
            });
        }

        function likeComment(commentId) {
            const buttonElement = document.getElementById('comment-like-btn-' + commentId);

            // 중복 클릭 방지: 이미 처리 중이면 리턴
            if (buttonElement && buttonElement.disabled) {
                return;
            }

            // 버튼 비활성화 및 로딩 상태 표시
            if (buttonElement) {
                buttonElement.disabled = true;
                buttonElement.style.opacity = '0.6';
            }

            fetch('${pageContext.request.contextPath}/api/column/comment/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'commentId=' + commentId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const likeElement = document.getElementById('comment-like-count-' + commentId);
                    if (likeElement) {
                        likeElement.textContent = data.likeCount;
                    }
                    if (buttonElement) {
                        // 좋아요 토글 UI 업데이트
                        if (data.isLiked) {
                            buttonElement.classList.add('text-red-600');
                            buttonElement.classList.remove('text-slate-600');
                        } else {
                            buttonElement.classList.add('text-slate-600');
                            buttonElement.classList.remove('text-red-600');
                        }
                    }
                } else {
                    alert(data.message || '좋아요 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('좋아요 처리 중 오류가 발생했습니다.');
            })
            .finally(() => {
                // 버튼 재활성화
                if (buttonElement) {
                    buttonElement.disabled = false;
                    buttonElement.style.opacity = '1';
                }
            });
        }

        // 좋아요 기능 (비동기 처리)
        function likeColumn(columnId) {
            const buttonElement = document.getElementById('column-like-btn-' + columnId);

            // 중복 클릭 방지: 이미 처리 중이면 리턴
            if (buttonElement && buttonElement.disabled) {
                return;
            }

            // 버튼 비활성화 및 로딩 상태 표시
            if (buttonElement) {
                buttonElement.disabled = true;
                buttonElement.style.opacity = '0.6';
            }

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
                    if (buttonElement) {
                        // 좋아요 토글 UI 업데이트
                        if (data.isLiked) {
                            buttonElement.classList.add('bg-red-100', 'text-red-600');
                            buttonElement.classList.remove('bg-slate-100');
                        } else {
                            buttonElement.classList.add('bg-slate-100');
                            buttonElement.classList.remove('bg-red-100', 'text-red-600');
                        }
                    }
                } else {
                    alert(data.message || '처리 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('좋아요 처리 중 오류가 발생했습니다.');
            })
            .finally(() => {
                // 버튼 재활성화
                if (buttonElement) {
                    buttonElement.disabled = false;
                    buttonElement.style.opacity = '1';
                }
            });
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