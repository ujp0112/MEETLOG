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
</head>
<body class="bg-slate-50 text-slate-800">
    <div class="flex min-h-screen flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="bg-gradient-to-b from-slate-100 via-white to-white">
                <div class="mx-auto w-full max-w-5xl px-6 py-10 md:px-10">
                    <jsp:useBean id="now" class="java.util.Date" />

                    <a href="${pageContext.request.contextPath}/event/list"
                       class="inline-flex items-center gap-2 text-sm font-semibold text-slate-500 transition hover:text-sky-600">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                            <path fill-rule="evenodd" d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H16a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />
                        </svg>
                        이벤트 목록으로 돌아가기
                    </a>

                    <article class="mt-6 overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-md">
                        <div class="md:flex">
                            <div class="relative md:w-2/5">
                                <mytag:image fileName="${event.image}" altText="${event.title} 썸네일"
                                             cssClass="h-64 w-full object-cover md:h-full" />
                                <div class="absolute inset-x-6 top-6 flex flex-wrap gap-2">
                                    <span class="inline-flex items-center gap-2 rounded-full bg-white/90 px-4 py-1 text-xs font-semibold text-slate-600 shadow">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                            <path fill-rule="evenodd" d="M5 2a1 1 0 00-1 1v2H3a2 2 0 00-2 2v1h18V7a2 2 0 00-2-2h-1V3a1 1 0 00-1-1H5zm13 7H2v7a2 2 0 002 2h12a2 2 0 002-2V9zM6 12a1 1 0 112 0 1 1 0 01-2 0zm6-1a1 1 0 000 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
                                        </svg>
                                        이벤트 진행 안내
                                    </span>
                                </div>
                            </div>

                            <div class="flex flex-1 flex-col gap-6 p-8 md:p-10">
                                <header class="space-y-3">
                                    <h1 class="text-3xl font-bold leading-snug text-slate-900 md:text-4xl">${event.title}</h1>
                                    <c:if test="${not empty event.summary}">
                                        <p class="rounded-2xl bg-sky-50 px-5 py-4 text-sm leading-relaxed text-sky-700">
                                            ${event.summary}
                                        </p>
                                    </c:if>
                                </header>

                                <section class="grid gap-4 rounded-2xl border border-slate-100 bg-slate-50 px-6 py-5 text-sm text-slate-600 md:grid-cols-2">
                                    <div class="flex items-start gap-3">
                                        <span class="mt-0.5 inline-flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-white text-sky-600">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v9a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm-2 7h12v6H4V9z" clip-rule="evenodd" />
                                            </svg>
                                        </span>
                                        <div>
                                            <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">이벤트 기간</p>
                                            <p class="mt-1 text-base font-semibold text-slate-700">
                                                <fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd"/> ~
                                                <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="flex items-start gap-3">
                                        <span class="mt-0.5 inline-flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-white text-sky-600">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                <path d="M8.257 3.099c.366-1.247 2.12-1.247 2.486 0l.592 2.019a1 1 0 00.95.69h2.123c1.31 0 1.851 1.68.79 2.46l-1.718 1.255a1 1 0 00-.364 1.118l.656 2.218c.378 1.279-1.048 2.334-2.137 1.555l-1.774-1.3a1 1 0 00-1.176 0l-1.774 1.3c-1.089.779-2.515-.276-2.137-1.555l.656-2.218a1 1 0 00-.364-1.118L4.3 8.268c-1.06-.78-.52-2.46.79-2.46h2.122a1 1 0 00.951-.69l.593-2.019z" />
                                            </svg>
                                        </span>
                                        <div>
                                            <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">진행 상태</p>
                                            <c:choose>
                                                <c:when test="${not empty event.endDate and event.endDate.time lt now.time}">
                                                    <p class="mt-1 inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1 text-sm font-semibold text-slate-500">
                                                        종료된 이벤트
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="mt-1 inline-flex items-center gap-2 rounded-full bg-sky-100 px-3 py-1 text-sm font-semibold text-sky-600">
                                                        진행 중
                                                    </p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </section>

                                <div class="flex flex-wrap gap-3">
                                    <button type="button" onclick="shareEvent()"
                                            class="inline-flex items-center gap-2 rounded-full bg-sky-500 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-sky-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                            <path d="M13 7a3 3 0 10-2.83-4H10a3 3 0 102.83 4H13zm-5 6a3 3 0 10-2.83-4H5a3 3 0 102.83 4H8zm8 2a3 3 0 10-2.83 4H13a3 3 0 102.83-4H16zm-2.535-9.273l-5 2.5a3.003 3.003 0 010 2.545l5 2.5a1 1 0 11-.894 1.788l-5-2.5a3.003 3.003 0 010-2.545l5-2.5a1 1 0 11.894 1.788z" />
                                        </svg>
                                        이벤트 공유하기
                                    </button>

                                    <a href="${pageContext.request.contextPath}/event/list"
                                       class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-5 py-2.5 text-sm font-semibold text-slate-600 transition hover:border-sky-200 hover:text-sky-600">
                                        목록으로 돌아가기
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="border-t border-slate-100 bg-white p-8 md:p-10">
                            <h2 class="text-xl font-semibold text-slate-900">이벤트 상세 안내</h2>
                            <div class="mt-5 rounded-2xl bg-slate-50 px-6 py-6 text-slate-600">
                                <div class="prose prose-slate max-w-none prose-headings:mt-6 prose-headings:text-slate-900 prose-a:text-sky-600 hover:prose-a:text-sky-700"
                                     style="white-space: pre-wrap;">
                                    ${event.content}
                                </div>
                            </div>
                        </div>
                    </article>
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
                navigator.clipboard.writeText(window.location.href).then(() => {
                    window.alert('이벤트 링크가 복사되었습니다. 필요한 곳에 붙여넣어 보세요.');
                }).catch(() => {
                    window.alert('복사에 실패했습니다. 브라우저 클립보드 권한을 확인해주세요.');
                });
            }
        }
    </script>
</body>
</html>
