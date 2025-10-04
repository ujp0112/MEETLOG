<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
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
        .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .prose-content { white-space: pre-wrap; }
        .prose-content img { max-width: 100%; height: auto; margin-top: 1.5em; margin-bottom: 1.5em; border-radius: 0.75rem; box-shadow: 0 10px 25px -15px rgba(15, 23, 42, 0.35); }
    </style>
</head>
<body class="bg-slate-50 text-slate-800">
    <div id="app" class="flex min-h-screen flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="bg-gradient-to-b from-amber-50 via-white to-white">
                <div class="mx-auto w-full max-w-5xl px-6 py-10 md:px-10">
                    <a href="${pageContext.request.contextPath}/column/list" class="inline-flex items-center gap-2 text-sm font-semibold text-slate-500 transition hover:text-amber-600">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                            <path fill-rule="evenodd" d="M12.293 16.707a1 1 0 010-1.414L15.586 12H4a1 1 0 010-2h11.586l-3.293-3.293a1 1 0 111.414-1.414l5 5a1 1 0 010 1.414l-5 5a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                        </svg>
                        칼럼 목록으로 돌아가기
                    </a>

                    <c:choose>
                        <c:when test="${not empty column}">
                            <article class="mt-6 overflow-hidden rounded-3xl border border-amber-100 bg-white shadow-md">
                                <div class="md:flex">
                                    <div class="relative md:w-2/5">
                                        <mytag:image fileName="${column.image}" altText="${column.title}" cssClass="h-64 w-full object-cover md:h-full" />
                                        <div class="absolute inset-x-6 top-6 flex flex-wrap gap-2">
                                            <span class="inline-flex items-center gap-2 rounded-full bg-white/90 px-4 py-1 text-xs font-semibold text-amber-700 shadow">
                                                <span class="text-base">📰</span>
                                                맛집 칼럼
                                            </span>
                                        </div>
                                    </div>

                                    <div class="flex flex-1 flex-col gap-6 p-8 md:p-10">
                                        <header class="space-y-3">
                                            <h1 class="text-3xl font-bold leading-snug text-slate-900 md:text-4xl">${column.title}</h1>
                                            <c:if test="${not empty column.summary}">
                                                <p class="rounded-2xl bg-amber-50 px-5 py-4 text-sm leading-relaxed text-amber-800">${column.summary}</p>
                                            </c:if>
                                        </header>

                                        <section class="grid gap-4 rounded-2xl border border-slate-100 bg-slate-50 px-6 py-5 text-sm text-slate-600 md:grid-cols-2">
                                            <div class="flex items-start gap-3">
                                                <span class="mt-0.5 inline-flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-white text-amber-600">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                        <path d="M13 7H7v6h6V7z" />
                                                        <path fill-rule="evenodd" d="M5 3a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2V5a2 2 0 00-2-2H5zm8 4V5H7v2h6z" clip-rule="evenodd" />
                                                    </svg>
                                                </span>
                                                <div>
                                                    <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">발행일</p>
                                                    <p class="mt-1 text-base font-semibold text-slate-700">
                                                        <fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd" />
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="flex items-start gap-3">
                                                <span class="mt-0.5 inline-flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-white text-amber-600">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                        <path fill-rule="evenodd" d="M10 3a4 4 0 00-4 4v1H5a1 1 0 00-1 1v7a1 1 0 001 1h10a1 1 0 001-1v-7a1 1 0 00-1-1h-1V7a4 4 0 00-4-4zm-2 5V7a2 2 0 114 0v1H8zm4 1H8v5h4V9z" clip-rule="evenodd" />
                                                    </svg>
                                                </span>
                                                <div>
                                                    <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">작성자</p>
                                                    <p class="mt-1 text-base font-semibold text-slate-700">${column.author}</p>
                                                </div>
                                            </div>
                                            <div class="flex items-start gap-3">
                                                <span class="mt-0.5 inline-flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-white text-amber-600">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                        <path d="M2 5a2 2 0 012-2h12a2 2 0 012 2v10a1 1 0 01-1.447.894L13 13.118l-4.553 2.776A1 1 0 017 15V6a1 1 0 011.553-.894L13 7.882l4.553-2.776A1 1 0 0119 5v10a2 2 0 01-2 2H4a2 2 0 01-2-2V5z" />
                                                    </svg>
                                                </span>
                                                <div>
                                                    <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">조회수</p>
                                                    <p class="mt-1 text-base font-semibold text-slate-700"><c:out value="${column.views}" default="0" /></p>
                                                </div>
                                            </div>
                                            <div class="flex items-start gap-3">
                                                <span class="mt-0.5 inline-flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-white text-amber-600">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                        <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 18.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                                    </svg>
                                                </span>
                                                <div>
                                                    <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">좋아요</p>
                                                    <p class="mt-1 text-base font-semibold text-slate-700"><c:out value="${column.likes}" default="0" /></p>
                                                </div>
                                            </div>
                                        </section>

                                        <div class="flex flex-wrap gap-3">
                                            <button id="column-like-btn-${column.id}" onclick="likeColumn(${column.id})" type="button" class="inline-flex items-center gap-2 rounded-full border border-amber-200 bg-white px-5 py-2.5 text-sm font-semibold text-amber-700 shadow-sm transition hover:border-amber-300 hover:text-amber-800">
                                                <span>❤️</span>
                                                <span id="like-count-${column.id}"><c:out value="${column.likes}" default="0" /></span>
                                            </button>
                                            <button type="button" onclick="shareColumn()" class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-slate-800">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                    <path fill-rule="evenodd" d="M15 8a3 3 0 11-5.197-2.09l-3.247-1.73a3 3 0 11-.905 1.78l3.247 1.73a3 3 0 105.36 2.773l3.248 1.73a3 3 0 11-.905 1.78l-3.248-1.73A3 3 0 0115 8z" clip-rule="evenodd" />
                                                </svg>
                                                링크 공유하기
                                            </button>
                                            <a href="${pageContext.request.contextPath}/column/list" class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-5 py-2.5 text-sm font-semibold text-slate-600 transition hover:border-amber-200 hover:text-amber-600">
                                                목록으로 돌아가기
                                            </a>
                                        </div>

                                        <c:if test="${not empty sessionScope.user and sessionScope.user.id == column.userId}">
                                            <div class="flex flex-wrap gap-3">
                                                <a href="${pageContext.request.contextPath}/column/edit?id=${column.id}" class="inline-flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-500 transition hover:border-slate-300 hover:text-slate-700">수정</a>
                                                <button type="button" onclick="deleteColumn(${column.id})" class="inline-flex items-center gap-2 rounded-full border border-red-200 px-4 py-2 text-xs font-semibold text-red-600 transition hover:border-red-300 hover:text-red-700">삭제</button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="border-t border-slate-100 bg-white p-8 md:p-10">
                                    <h2 class="text-xl font-semibold text-slate-900">칼럼 본문</h2>
                                    <div class="mt-5 rounded-2xl bg-slate-50 px-6 py-6 text-slate-600">
                                        <div class="prose prose-slate max-w-none prose-headings:mt-6 prose-headings:text-slate-900 prose-a:text-amber-600 hover:prose-a:text-amber-700">
                                            <div class="prose-content">
                                                <c:out value="${column.content}" escapeXml="false" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </article>

                            <c:if test="${not empty attachedRestaurants}">
                                <section class="mt-10 rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                                    <h2 class="text-xl font-semibold text-slate-900">소개된 맛집</h2>
                                    <div class="mt-4 space-y-4">
                                        <c:forEach var="r" items="${attachedRestaurants}" varStatus="status">
                                            <a href="${pageContext.request.contextPath}/restaurant/detail/${r.id}" class="flex items-center gap-4 rounded-2xl border border-slate-100 bg-slate-50 p-4 transition hover:border-amber-200 hover:bg-white">
                                                <c:choose>
                                                    <c:when test="${not empty r.image}">
                                                        <mytag:image fileName="${r.image}" altText="${r.name}" cssClass="h-16 w-16 flex-shrink-0 rounded-xl object-cover shadow-sm" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img id="attached-restaurant-img-${status.index}" src="https://placehold.co/64x64/e2e8f0/94a3b8?text=..." alt="${r.name}" class="h-16 w-16 flex-shrink-0 rounded-xl object-cover shadow-sm" data-name="${r.name}" data-address="${r.address}" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <p class="text-base font-semibold text-slate-900">${r.name}</p>
                                                    <p class="text-sm text-slate-500">${r.address}</p>
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </section>
                            </c:if>

                            <section class="mt-10 space-y-6">
                                <header>
                                    <h2 class="text-xl font-semibold text-slate-900">댓글 (<span id="comment-count">${commentCount}</span>)</h2>
                                    <p class="mt-1 text-sm text-slate-500">칼럼에 대한 의견을 남겨주세요. 따뜻한 피드백이 더 나은 콘텐츠를 만듭니다.</p>
                                </header>

                                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <textarea id="comment-content" rows="3" placeholder="따뜻한 댓글을 남겨주세요." class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm shadow-inner focus:border-amber-400 focus:outline-none focus:ring-2 focus:ring-amber-200"></textarea>
                                            <div class="mt-4 flex justify-end">
                                                <button id="submit-comment" type="button" class="inline-flex items-center gap-2 rounded-full bg-amber-500 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-amber-600">댓글 등록</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-center text-sm text-slate-500">댓글을 작성하려면 <a href="${pageContext.request.contextPath}/login" class="font-semibold text-amber-600 hover:text-amber-700">로그인</a>이 필요합니다.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div id="comments-list" class="space-y-4">
                                    <c:choose>
                                        <c:when test="${not empty comments}">
                                            <c:forEach var="comment" items="${comments}">
                                                <div class="rounded-3xl border border-slate-100 bg-white p-6 shadow-sm" data-comment-id="${comment.id}">
                                                    <div class="flex items-start gap-3">
                                                        <a href="${pageContext.request.contextPath}/feed/user/${comment.userId}" class="flex-shrink-0">
                                                            <mytag:image fileName="${comment.profileImage}" altText="${comment.author}" cssClass="h-10 w-10 rounded-full object-cover shadow" />
                                                        </a>
                                                        <div class="flex-1">
                                                            <div class="flex items-center justify-between">
                                                                <a href="${pageContext.request.contextPath}/feed/user/${comment.userId}" class="font-semibold text-slate-800 transition hover:text-amber-600">${comment.author}</a>
                                                                <div class="comment-actions flex items-center gap-2">
                                                                    <span class="text-xs text-slate-400">${comment.createdAt.toString().substring(0, 16).replace('T', ' ')}</span>
                                                                    <c:if test="${not empty sessionScope.user and sessionScope.user.id == comment.userId}">
                                                                        <button type="button" onclick="editComment(${comment.id})" class="text-xs font-semibold text-amber-600 transition hover:text-amber-700">수정</button>
                                                                        <button type="button" onclick="deleteComment(${comment.id})" class="text-xs font-semibold text-red-500 transition hover:text-red-600">삭제</button>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <p id="comment-content-${comment.id}" class="mt-2 text-sm leading-relaxed text-slate-600">${comment.content}</p>
                                                            <div class="mt-3 flex items-center gap-4">
                                                                <button id="comment-like-btn-${comment.id}" onclick="likeComment(${comment.id})" type="button" class="inline-flex items-center gap-1 text-xs font-semibold text-slate-500 transition hover:text-red-500">
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
                                            <div class="rounded-3xl border border-dashed border-slate-200 bg-white px-8 py-12 text-center text-sm text-slate-500">
                                                아직 댓글이 없습니다. 첫 번째 후기를 남겨보세요!
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </section>
                        </c:when>
                        <c:otherwise>
                            <section class="mt-12 flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-white/80 px-8 py-16 text-center">
                                <div class="text-5xl">📰</div>
                                <h2 class="mt-6 text-2xl font-bold text-slate-900">칼럼을 찾을 수 없습니다.</h2>
                                <p class="mt-2 text-sm text-slate-500">요청하신 칼럼이 존재하지 않거나 삭제되었습니다.</p>
                                <a href="${pageContext.request.contextPath}/column/list" class="mt-6 inline-flex items-center gap-2 rounded-full bg-amber-500 px-6 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-amber-600">
                                    칼럼 목록으로 돌아가기
                                </a>
                            </section>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        const COLUMN_ID = '<c:out value="${column.id}" default="" />';

        document.addEventListener('DOMContentLoaded', function() {
            const submitBtn = document.getElementById('submit-comment');
            if (submitBtn) {
                submitBtn.addEventListener('click', submitComment);
            }

            document.querySelectorAll('img[id^="attached-restaurant-img-"]').forEach(imgElement => {
                if (imgElement.src.includes('placehold.co')) {
                    const name = imgElement.dataset.name;
                    const address = imgElement.dataset.address;
                    if (name && address) {
                        const searchQuery = name + " " + (address || '').split(" ")[0];
                        fetch('${pageContext.request.contextPath}/search/image-proxy?query=' + encodeURIComponent(searchQuery))
                            .then(response => response.json())
                            .then(data => {
                                if (data && data.imageUrl) {
                                    imgElement.src = data.imageUrl;
                                }
                            }).catch(() => {});
                    }
                }
            });
        });

        function submitComment() {
            const contentElement = document.getElementById('comment-content');
            if (!contentElement) {
                return;
            }
            const content = contentElement.value.trim();
            if (!content) {
                window.alert('댓글 내용을 입력해주세요.');
                return;
            }

            if (!COLUMN_ID) {
                window.alert('칼럼 정보를 찾을 수 없습니다.');
                return;
            }

            const formData = new URLSearchParams();
            formData.append('columnId', COLUMN_ID);
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
                if (data.success) {
                    contentElement.value = '';
                    refreshComments();
                    window.alert('댓글이 등록되었습니다.');
                } else {
                    window.alert(data.message || '댓글 등록에 실패했습니다.');
                }
            })
            .catch(() => {
                window.alert('댓글 등록 중 네트워크 오류가 발생했습니다.');
            });
        }

        function deleteComment(commentId) {
            if (!window.confirm('댓글을 삭제하시겠습니까?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/api/column/comment/delete/' + commentId, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    refreshComments();
                    window.alert('댓글이 삭제되었습니다.');
                } else {
                    window.alert(data.message || '댓글 삭제에 실패했습니다.');
                }
            })
            .catch(() => {
                window.alert('댓글 삭제 중 오류가 발생했습니다.');
            });
        }

        function refreshComments() {
            location.reload();
        }

        let originalCommentContent = {};

        function editComment(commentId) {
            const commentElement = document.getElementById('comment-content-' + commentId);
            const currentContent = commentElement.textContent.trim();
            originalCommentContent[commentId] = currentContent;

            const textarea = document.createElement('textarea');
            textarea.id = 'edit-textarea-' + commentId;
            textarea.className = 'w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm focus:border-amber-400 focus:outline-none focus:ring-2 focus:ring-amber-200';
            textarea.rows = 3;
            textarea.value = currentContent;

            const buttonContainer = document.createElement('div');
            buttonContainer.className = 'mt-2 flex gap-2';

            const saveButton = document.createElement('button');
            saveButton.className = 'rounded-full bg-amber-500 px-4 py-2 text-xs font-semibold text-white shadow-sm hover:bg-amber-600';
            saveButton.textContent = '저장';
            saveButton.onclick = function() { saveComment(commentId); };

            const cancelButton = document.createElement('button');
            cancelButton.className = 'rounded-full border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-500 hover:border-slate-300 hover:text-slate-700';
            cancelButton.textContent = '취소';
            cancelButton.onclick = function() { cancelEdit(commentId); };

            buttonContainer.appendChild(saveButton);
            buttonContainer.appendChild(cancelButton);

            commentElement.innerHTML = '';
            commentElement.appendChild(textarea);
            commentElement.appendChild(buttonContainer);

            const actionButtons = commentElement.parentElement.querySelector('.comment-actions');
            if (actionButtons) {
                actionButtons.style.display = 'none';
            }

            textarea.focus();
        }

        function cancelEdit(commentId) {
            const commentElement = document.getElementById('comment-content-' + commentId);
            commentElement.innerHTML = '';
            commentElement.textContent = originalCommentContent[commentId];

            const actionButtons = commentElement.parentElement.querySelector('.comment-actions');
            if (actionButtons) {
                actionButtons.style.display = 'flex';
            }

            delete originalCommentContent[commentId];
        }

        function saveComment(commentId) {
            const textarea = document.getElementById('edit-textarea-' + commentId);
            if (!textarea) {
                window.alert('수정할 수 없습니다.');
                return;
            }

            const newContent = textarea.value.trim();
            if (!newContent) {
                window.alert('댓글 내용을 입력해주세요.');
                return;
            }

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
                body: JSON.stringify({ commentId: commentId, content: newContent })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('서버 응답 오류: ' + response.status);
                }
                return response.text().then(text => {
                    try {
                        return JSON.parse(text);
                    } catch (e) {
                        throw new Error('서버 응답을 처리할 수 없습니다.');
                    }
                });
            })
            .then(data => {
                if (data.success) {
                    const commentElement = document.getElementById('comment-content-' + commentId);
                    commentElement.innerHTML = '';
                    commentElement.textContent = newContent;

                    const actionButtons = commentElement.parentElement.querySelector('.comment-actions');
                    if (actionButtons) {
                        actionButtons.style.display = 'flex';
                    }

                    delete originalCommentContent[commentId];
                    window.alert('댓글이 수정되었습니다.');
                } else {
                    window.alert(data.message || '댓글 수정에 실패했습니다.');
                    if (saveButton) {
                        saveButton.disabled = false;
                        saveButton.textContent = '저장';
                    }
                }
            })
            .catch(() => {
                window.alert('댓글 수정 중 오류가 발생했습니다.');
                if (saveButton) {
                    saveButton.disabled = false;
                    saveButton.textContent = '저장';
                }
            });
        }

        function likeComment(commentId) {
            const buttonElement = document.getElementById('comment-like-btn-' + commentId);
            if (buttonElement && buttonElement.disabled) {
                return;
            }
            if (buttonElement) {
                buttonElement.disabled = true;
                buttonElement.style.opacity = '0.6';
            }

            fetch('${pageContext.request.contextPath}/api/column/comment/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ commentId: commentId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const likeElement = document.getElementById('comment-like-count-' + commentId);
                    if (likeElement) {
                        likeElement.textContent = data.likeCount;
                    }
                    if (buttonElement) {
                        if (data.isLiked) {
                            buttonElement.classList.add('text-red-500');
                            buttonElement.classList.remove('text-slate-500');
                        } else {
                            buttonElement.classList.add('text-slate-500');
                            buttonElement.classList.remove('text-red-500');
                        }
                    }
                } else {
                    window.alert(data.message || '좋아요 처리에 실패했습니다.');
                }
            })
            .catch(() => {
                window.alert('좋아요 처리 중 오류가 발생했습니다.');
            })
            .finally(() => {
                if (buttonElement) {
                    buttonElement.disabled = false;
                    buttonElement.style.opacity = '1';
                }
            });
        }

        function likeColumn(columnId) {
            const buttonElement = document.getElementById('column-like-btn-' + columnId);
            if (buttonElement && buttonElement.disabled) {
                return;
            }
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
                        likeElement.textContent = data.likes;
                    }
                    if (buttonElement) {
                        if (data.isLiked) {
                            buttonElement.classList.add('bg-amber-500/10');
                            buttonElement.classList.remove('bg-white');
                        } else {
                            buttonElement.classList.add('bg-white');
                            buttonElement.classList.remove('bg-amber-500/10');
                        }
                    }
                } else {
                    window.alert(data.message || '처리 중 오류가 발생했습니다.');
                }
            })
            .catch(() => {
                window.alert('좋아요 처리 중 오류가 발생했습니다.');
            })
            .finally(() => {
                if (buttonElement) {
                    buttonElement.disabled = false;
                    buttonElement.style.opacity = '1';
                }
            });
        }

        function shareColumn() {
            if (navigator.share) {
                navigator.share({
                    title: '<c:out value="${column.title}" />',
                    text: 'MEET LOG에서 흥미로운 칼럼을 확인해보세요!',
                    url: window.location.href
                }).catch(() => {
                    window.alert('공유에 실패했습니다. 다시 시도해주세요.');
                });
            } else {
                navigator.clipboard.writeText(window.location.href)
                    .then(() => window.alert('링크가 클립보드에 복사되었습니다.'))
                    .catch(() => window.alert('복사에 실패했습니다. 브라우저 권한을 확인해주세요.'));
            }
        }

        function deleteColumn(columnId) {
            if (window.confirm('정말로 이 칼럼을 삭제하시겠습니까? 되돌릴 수 없습니다.')) {
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
