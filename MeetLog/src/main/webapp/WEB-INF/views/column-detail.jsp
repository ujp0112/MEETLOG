<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - <c:out value="${column.title}" default="칼럼 상세" /></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        body { font-family: 'Noto Sans KR', sans-serif; }
        .chip { @apply inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/80 px-3 py-1 text-xs font-semibold text-slate-600; }
        .chip-on-dark { @apply inline-flex items-center gap-2 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold text-white/80; }
        .section-title { @apply text-xl font-bold text-slate-900 md:text-2xl; }
        .section-sub { @apply mt-1 text-sm text-slate-500 md:text-base; }
        .stat-card { @apply rounded-2xl border border-slate-200 bg-white p-6 shadow-sm md:p-7; }
        .meta-label { @apply text-xs font-semibold uppercase tracking-wide text-slate-400; }
        .meta-value { @apply mt-1 text-base font-semibold text-slate-900; }
        .comment-bubble { @apply rounded-2xl border border-slate-200 bg-white/60 p-5 shadow-sm transition hover:border-amber-200; }
        .subtle-card { @apply rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8; }
        .prose-content { @apply whitespace-pre-wrap leading-relaxed text-slate-600; }
    </style>
    <style>
        .prose-content img {
            max-width: 100%;
            height: auto;
            margin-top: 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 25px -15px rgba(15, 23, 42, 0.35);
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-800">
    <div id="app" class="flex min-h-screen flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow bg-slate-50">
            <div class="mx-auto w-full max-w-6xl px-4 py-10 md:px-6 md:py-14">
                <a href="${pageContext.request.contextPath}/column/list" class="inline-flex items-center gap-2 text-sm font-semibold text-slate-500 transition hover:text-amber-600">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                        <path fill-rule="evenodd" d="M12.293 16.707a1 1 0 010-1.414L15.586 12H4a1 1 0 010-2h11.586l-3.293-3.293a1 1 0 111.414-1.414l5 5a1 1 0 010 1.414l-5 5a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                    </svg>
                    칼럼 목록으로 돌아가기
                </a>

                <c:choose>
                    <c:when test="${not empty column}">
                        <c:set var="heroImage" value="${column.image}" />
                        <c:set var="authorImageUrl" value="" />
                        <c:if test="${not empty column.profileImage}">
                            <c:choose>
                                <c:when test="${fn:startsWith(column.profileImage, 'http')}">
                                    <c:set var="authorImageUrl" value="${column.profileImage}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="authorImageUrl" value="${pageContext.request.contextPath}/${column.profileImage}" />
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <c:set var="commentCountValue" value="${commentCount}" />

                        <div id="column-detail-container" class="mt-6 space-y-12">
                            <section class="overflow-hidden rounded-3xl bg-white shadow-xl">
                                <div class="relative h-72 md:h-80">
                                    <c:choose>
                                        <c:when test="${not empty heroImage}">
                                            <mytag:image fileName="${heroImage}" altText="${column.title}" cssClass="absolute inset-0 h-full w-full object-cover" />
                                        </c:when>
                                        <c:otherwise>
                                            <div class="absolute inset-0 bg-gradient-to-br from-amber-300 via-amber-600 to-slate-800"></div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="absolute inset-0 bg-gradient-to-br from-slate-950/80 via-slate-900/30 to-slate-900/10"></div>
                                    <div class="relative z-10 flex h-full flex-col justify-between gap-6 p-8 md:p-10">
                                        <div class="flex flex-wrap gap-2">
                                            <span class="chip-on-dark">맛집 칼럼</span>
                                            <c:if test="${not empty column.createdAt}">
                                                <span class="chip-on-dark">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-3.5 w-3.5">
                                                        <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm-1 6h10v8H5V8z" clip-rule="evenodd" />
                                                        <path d="M7 10h2v2H7v-2z" />
                                                    </svg>
                                                    <fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd" />
                                                </span>
                                            </c:if>
                                        </div>
                                        <div class="space-y-5 text-white">
                                            <h1 class="text-3xl font-extrabold leading-tight md:text-4xl"><c:out value="${column.title}" /></h1>
                                            <c:if test="${not empty column.summary}">
                                                <p class="text-base leading-relaxed text-white/80 md:text-lg"><c:out value="${column.summary}" /></p>
                                            </c:if>
                                            <div class="flex flex-wrap items-center gap-4 text-sm text-white/80">
                                                <c:if test="${not empty column.author}">
                                                    <div class="flex items-center gap-3">
                                                        <c:choose>
                                                            <c:when test="${not empty authorImageUrl}">
                                                                <img src="${authorImageUrl}" alt="${column.author}" class="h-10 w-10 rounded-full border-2 border-white/40 object-cover" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-white/40 bg-white/20 text-sm font-semibold text-white/80">
                                                                    <c:out value="${fn:substring(column.author, 0, 1)}" />
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div>
                                                            <c:choose>
                                                                <c:when test="${not empty column.userId}">
                                                                    <a href="${pageContext.request.contextPath}/feed/user/${column.userId}" class="font-semibold text-white transition hover:text-amber-200">${column.author}</a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="font-semibold text-white">${column.author}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <p class="text-xs uppercase tracking-wide text-white/60">칼럼 작성자</p>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty column.createdAt}">
                                                    <span class="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-xs font-semibold text-white/80">
                                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-4 w-4">
                                                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                        </svg>
                                                        업데이트 <fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd HH:mm" />
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex flex-wrap items-center gap-3 border-t border-slate-100 bg-white/95 px-6 py-5 md:px-8">
                                    <button type="button" onclick="shareColumn()" class="flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:border-amber-300 hover:text-amber-600">
                                        <svg class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 8a3 3 0 10-5.995.176L9 8a3 3 0 10.001 6 3 3 0 005.995-.176L15 14a3 3 0 100-6z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M9.197 9.743l5.605-3.202M9.205 14.557l5.59 3.145" />
                                        </svg>
                                        공유하기
                                    </button>
                                    <button type="button" id="column-like-btn-${column.id}" onclick="likeColumn(${column.id})" class="inline-flex items-center gap-2 rounded-full border border-amber-200 bg-white px-5 py-2.5 text-sm font-semibold text-amber-700 shadow-sm transition hover:border-amber-300 hover:text-amber-800">
                                        <span>❤️</span>
                                        <span id="like-count-${column.id}"><c:out value="${column.likes}" default="0" /></span>
                                    </button>
                                    <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold text-slate-500">
                                        <svg class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        조회 <fmt:formatNumber value="${column.views}" type="number" />
                                    </span>
                                    <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold text-slate-500">
                                        <svg class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M7 8h10M7 12h6m7-1a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                        댓글 <c:out value="${commentCountValue}" default="0" />
                                    </span>
                                    <c:if test="${not empty sessionScope.user and sessionScope.user.id == column.userId}">
                                        <div class="ml-auto flex flex-wrap items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/column/edit?id=${column.id}" class="inline-flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-500 transition hover:border-slate-300 hover:text-slate-700">수정</a>
                                            <button type="button" onclick="deleteColumn(${column.id})" class="inline-flex items-center gap-2 rounded-full border border-red-200 px-4 py-2 text-xs font-semibold text-red-600 transition hover:border-red-300 hover:text-red-700">삭제</button>
                                        </div>
                                    </c:if>
                                </div>
                            </section>

                            <div class="grid gap-10 lg:grid-cols-[minmax(0,2.5fr)_minmax(0,1fr)]">
                                <div class="space-y-10">
                                    <section class="subtle-card space-y-5">
                                        <div>
                                            <h2 class="section-title">칼럼 본문</h2>
                                            <p class="section-sub">맛집 이야기를 천천히 읽어보세요.</p>
                                        </div>
                                        <div class="rounded-2xl bg-slate-50/60 p-6">
                                            <div class="prose-content">
                                                <c:out value="${column.content}" escapeXml="false" />
                                            </div>
                                        </div>
                                    </section>

                                    <c:if test="${not empty attachedRestaurants}">
                                        <section class="subtle-card space-y-5">
                                            <div class="flex items-center justify-between">
                                                <div>
                                                    <h2 class="section-title">소개된 맛집</h2>
                                                    <p class="section-sub">칼럼에서 소개한 장소를 정리했어요.</p>
                                                </div>
                                                <span class="chip">총 <c:out value="${fn:length(attachedRestaurants)}" />곳</span>
                                            </div>
                                            <div class="grid gap-4 md:grid-cols-2">
                                                <c:forEach var="r" items="${attachedRestaurants}" varStatus="status">
                                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${r.id}" class="flex items-center gap-4 rounded-2xl border border-slate-100 bg-slate-50 p-4 transition hover:-translate-y-0.5 hover:border-amber-200 hover:bg-white">
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

                                    <section class="subtle-card space-y-6" id="comment-section">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <h2 class="section-title">댓글</h2>
                                                <p class="section-sub">칼럼에 대한 당신의 생각을 들려주세요.</p>
                                            </div>
                                            <span class="rounded-full bg-slate-100 px-4 py-1 text-sm font-semibold text-slate-500"><c:out value="${commentCountValue}" default="0" />개</span>
                                        </div>

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
                                                        <div class="comment-bubble" data-comment-id="${comment.id}">
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
                                </div>

                                <aside class="space-y-6">
                                    <section class="stat-card space-y-5">
                                        <div>
                                            <h3 class="text-lg font-semibold text-slate-900">칼럼 한눈에 보기</h3>
                                            <p class="text-sm text-slate-500">핵심 정보를 요약했어요.</p>
                                        </div>
                                        <div class="space-y-4">
                                            <c:if test="${not empty column.author}">
                                                <div>
                                                    <p class="meta-label">작성자</p>
                                                    <p class="meta-value">${column.author}</p>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty column.createdAt}">
                                                <div>
                                                    <p class="meta-label">발행일</p>
                                                    <p class="meta-value"><fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd" /></p>
                                                </div>
                                            </c:if>
                                            <div>
                                                <p class="meta-label">조회수</p>
                                                <p class="meta-value"><fmt:formatNumber value="${column.views}" type="number" /></p>
                                            </div>
                                            <div>
                                                <p class="meta-label">좋아요</p>
                                                <p class="meta-value"><c:out value="${column.likes}" default="0" /></p>
                                            </div>
                                            <div>
                                                <p class="meta-label">댓글</p>
                                                <p class="meta-value"><c:out value="${commentCountValue}" default="0" /></p>
                                            </div>
                                        </div>
                                    </section>

                                    <section class="stat-card space-y-4">
                                        <h3 class="text-lg font-semibold text-slate-900">다른 칼럼도 찾아보기</h3>
                                        <p class="text-sm text-slate-500">더 많은 이야기와 맛집을 발견해보세요.</p>
                                        <a href="${pageContext.request.contextPath}/column/list" class="inline-flex items-center justify-center gap-2 rounded-full bg-amber-500 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-amber-600">
                                            목록 보기
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-4 w-4">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                                            </svg>
                                        </a>
                                    </section>
                                </aside>
                            </div>
                        </div>
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
