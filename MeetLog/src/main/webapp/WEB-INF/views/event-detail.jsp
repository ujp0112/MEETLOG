<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.title} - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        body { font-family: 'Noto Sans KR', sans-serif; }
        .chip { @apply inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-semibold text-slate-600; }
        .chip-on-dark { @apply inline-flex items-center gap-2 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold text-white/80; }
        .section-title { @apply text-xl font-bold text-slate-900 md:text-2xl; }
        .section-sub { @apply mt-1 text-sm text-slate-500 md:text-base; }
        .stat-card { @apply rounded-2xl border border-slate-200 bg-white p-6 shadow-sm md:p-7; }
        .subtle-card { @apply rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8; }
        .meta-label { @apply text-xs font-semibold uppercase tracking-wide text-slate-400; }
        .meta-value { @apply mt-1 text-base font-semibold text-slate-900; }
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
            <jsp:useBean id="now" class="java.util.Date" />
            <c:set var="heroImage" value="${event.image}" />
            <c:set var="isEnded" value="${not empty event.endDate and event.endDate.time lt now.time}" />
            <c:set var="statusLabel" value="진행 중" />
            <c:set var="statusDescription" value="이벤트에 참여할 수 있어요." />
            <c:if test="${isEnded}">
                <c:set var="statusLabel" value="종료된 이벤트" />
                <c:set var="statusDescription" value="이 이벤트는 종료되었지만 내용을 다시 확인할 수 있어요." />
            </c:if>

            <div class="mx-auto w-full max-w-6xl px-4 py-10 md:px-6 md:py-14">
                <div class="space-y-12">
                    <a href="${pageContext.request.contextPath}/event/list" class="inline-flex items-center gap-2 text-sm font-semibold text-slate-500 transition hover:text-sky-600">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                            <path fill-rule="evenodd" d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H16a1 1 0 010 2H5.414l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />
                        </svg>
                        이벤트 목록으로 돌아가기
                    </a>

                    <section class="overflow-hidden rounded-3xl bg-white shadow-xl">
                        <div class="relative h-72 md:h-80">
                            <c:choose>
                                <c:when test="${not empty heroImage}">
                                    <mytag:image fileName="${heroImage}" altText="${event.title}" cssClass="absolute inset-0 h-full w-full object-cover" />
                                </c:when>
                                <c:otherwise>
                                    <div class="absolute inset-0 bg-gradient-to-br from-sky-300 via-slate-600 to-slate-900"></div>
                                </c:otherwise>
                            </c:choose>
                            <div class="absolute inset-0 bg-gradient-to-br from-slate-950/80 via-slate-900/40 to-sky-900/20"></div>
                            <div class="relative z-10 flex h-full flex-col justify-between gap-6 p-8 md:p-10">
                                <div class="flex flex-wrap gap-2">
                                    <span class="chip-on-dark">Meet Log Events</span>
                                    <c:choose>
                                        <c:when test="${isEnded}">
                                            <span class="chip-on-dark inline-flex items-center gap-2">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-3.5 w-3.5">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm-1-5a1 1 0 112 0v1a1 1 0 11-2 0v-1zm0-6a1 1 0 112 0v4a1 1 0 01-2 0V7z" clip-rule="evenodd" />
                                                </svg>
                                                종료된 이벤트
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="chip-on-dark inline-flex items-center gap-2">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-3.5 w-3.5">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.707a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                                </svg>
                                                진행 중
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="chip-on-dark inline-flex items-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-4 w-4">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 6.75h7.5m-7.5 3h7.5m-7.5 3h7.5M3.375 5.25a1.125 1.125 0 011.125-1.125h15a1.125 1.125 0 011.125 1.125v13.5a1.125 1.125 0 01-1.125 1.125h-15A1.125 1.125 0 013.375 18.75V5.25z" />
                                        </svg>
                                        <fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd" /> ~ <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd" />
                                    </span>
                                </div>
                                <div class="space-y-4 text-white">
                                    <h1 class="text-3xl font-extrabold leading-tight md:text-4xl">${event.title}</h1>
                                    <c:if test="${not empty event.summary}">
                                        <p class="text-base leading-relaxed text-white/80 md:text-lg">${event.summary}</p>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <div class="flex flex-wrap items-center gap-3 border-t border-slate-100 bg-white/95 px-6 py-5 md:px-8">
                            <button type="button" onclick="shareEvent()" class="flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-600 transition hover:border-sky-300 hover:text-sky-600">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                    <path d="M13 7a3 3 0 10-2.83-4H10a3 3 0 102.83 4H13zm-5 6a3 3 0 10-2.83-4H5a3 3 0 102.83 4H8zm8 2a3 3 0 10-2.83 4H13a3 3 0 102.83-4H16zm-2.535-9.273l-5 2.5a3.003 3.003 0 010 2.545l5 2.5a1 1 0 11-.894 1.788l-5-2.5a3.003 3.003 0 010-2.545l5-2.5a1 1 0 11.894 1.788z" />
                                </svg>
                                이벤트 공유하기
                            </button>
                            <a href="${pageContext.request.contextPath}/event/list" class="flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:border-sky-300 hover:text-sky-600">
                                목록으로 돌아가기
                            </a>
                            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold text-slate-500">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-4 w-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a4.5 4.5 0 107.5 0m-7.5 0h7.5m-10.5-6h13.5m-4.5-6h6M3.75 6h6" />
                                </svg>
                                ${statusDescription}
                            </span>
                            <c:choose>
                                <c:when test="${isEnded}">
                                    <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold text-slate-500">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm-1-5a1 1 0 112 0v1a1 1 0 11-2 0v-1zm0-6a1 1 0 112 0v4a1 1 0 01-2 0V7z" clip-rule="evenodd" />
                                        </svg>
                                        종료됨
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center gap-2 rounded-full border border-emerald-200 bg-emerald-50 px-4 py-2 text-xs font-semibold text-emerald-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.707a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                        </svg>
                                        참여 가능
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <div class="grid gap-10 lg:grid-cols-[minmax(0,2.5fr)_minmax(0,1fr)]">
                        <section class="subtle-card space-y-5">
                            <div>
                                <h2 class="section-title">이벤트 상세 안내</h2>
                                <p class="section-sub">이벤트 참여 방법과 혜택을 꼼꼼히 확인해 보세요.</p>
                            </div>
                            <div class="rounded-2xl bg-slate-50/60 p-6">
                                <div class="prose-content">
                                    <c:out value="${event.content}" escapeXml="false" />
                                </div>
                            </div>
                        </section>

                        <aside class="space-y-6">
                            <section class="stat-card space-y-4">
                                <div>
                                    <h3 class="text-lg font-semibold text-slate-900">이벤트 한눈에 보기</h3>
                                    <p class="text-sm text-slate-500">핵심 정보를 정리했습니다.</p>
                                </div>
                                <div class="space-y-4">
                                    <div>
                                        <p class="meta-label">진행 상태</p>
                                        <p class="meta-value">
                                            ${statusLabel}
                                        </p>
                                        <p class="mt-1 text-xs text-slate-500">${statusDescription}</p>
                                    </div>
                                    <div>
                                        <p class="meta-label">시작일</p>
                                        <p class="meta-value"><fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd" /></p>
                                    </div>
                                    <div>
                                        <p class="meta-label">종료일</p>
                                        <p class="meta-value"><fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd" /></p>
                                    </div>
                                </div>
                            </section>

                            <c:if test="${not empty event.summary}">
                                <section class="stat-card space-y-3">
                                    <h3 class="text-lg font-semibold text-slate-900">요약 안내</h3>
                                    <p class="text-sm leading-relaxed text-slate-600">${event.summary}</p>
                                </section>
                            </c:if>

                            <section class="stat-card space-y-4">
                                <h3 class="text-lg font-semibold text-slate-900">다른 이벤트도 둘러보기</h3>
                                <p class="text-sm text-slate-500">새로운 이벤트와 혜택을 계속 확인해 보세요.</p>
                                <a href="${pageContext.request.contextPath}/event/list" class="inline-flex items-center justify-center gap-2 rounded-full bg-sky-500 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-sky-600">
                                    이벤트 목록 보기
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-4 w-4">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                                    </svg>
                                </a>
                            </section>
                        </aside>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function shareEvent() {
            if (navigator.share) {
                navigator.share({
                    title: document.title,
                    text: 'MEET LOG에서 진행하는 특별한 이벤트를 확인해보세요!',
                    url: window.location.href
                }).catch(() => {
                    window.alert('공유에 실패했습니다. 다시 시도해주세요.');
                });
            } else {
                navigator.clipboard.writeText(window.location.href)
                    .then(() => {
                        window.alert('이벤트 링크가 복사되었습니다. 필요한 곳에 붙여넣어 보세요.');
                    })
                    .catch(() => {
                        window.alert('복사에 실패했습니다. 브라우저 클립보드 권한을 확인해주세요.');
                    });
            }
        }
    </script>
</body>
</html>
