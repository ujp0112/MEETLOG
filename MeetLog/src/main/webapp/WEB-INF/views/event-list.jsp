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
    <title>이벤트 - MEET LOG</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        .subtle-card { @apply rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8; }
        .search-hero-pill { @apply inline-flex items-center gap-2 rounded-full bg-emerald-100/80 px-3 py-1 text-xs font-semibold text-emerald-700; }
        .chip { @apply inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600 transition hover:border-emerald-400 hover:text-emerald-600; }
        .timeline-card { @apply relative overflow-hidden rounded-2xl border border-transparent bg-white p-5 shadow-sm transition hover:border-emerald-200 hover:shadow-md; }
        .timeline-dot { @apply absolute -left-[39px] mt-1 h-3 w-3 rounded-full border-4 border-slate-50 bg-slate-300 transition group-hover:border-emerald-100 group-hover:bg-emerald-500; }
    </style>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800">
    <div id="app" class="flex min-h-screen flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <c:set var="ongoingCount" value="${fn:length(ongoingEvents)}" />
            <c:set var="finishedCount" value="${fn:length(finishedEvents)}" />

            <!-- 히어로 섹션 -->
            <section class="border-b border-slate-200 bg-gradient-to-r from-slate-50 via-white to-emerald-50/70">
                <div class="mx-auto flex w-full max-w-6xl flex-col gap-8 px-6 py-12 md:flex-row md:items-center md:justify-between md:px-10">
                    <div class="max-w-3xl space-y-4">
                        <div class="flex flex-wrap gap-2">
                            <span class="search-hero-pill">
                                <span class="text-base">🎉</span>
                                Meet Log Events
                            </span>
                            <span class="search-hero-pill">진행 <c:out value="${ongoingCount}" default="0" />건</span>
                            <span class="search-hero-pill">종료 <c:out value="${finishedCount}" default="0" />건</span>
                        </div>
                        <h1 class="text-3xl font-bold leading-tight text-slate-900 md:text-4xl">지금 참여하면 좋은 이벤트를 한 번에 만나보세요</h1>
                        <p class="text-sm text-slate-600 md:text-base">
                            현재 진행 중인 프로모션과 지난 이벤트를 한 화면에 모았습니다. 관심 있는 이벤트를 놓치지 않도록 달력에 표시하고, 커뮤니티와 함께 즐거운 경험을 나눠보세요.
                        </p>
                    </div>
                </div>
            </section>

            <!-- 진행 중인 이벤트 섹션 -->
            <section class="mx-auto w-full max-w-6xl px-6 py-10 md:px-10">
                <div class="mb-8 flex flex-wrap items-end justify-between gap-4">
                    <div>
                        <h2 class="text-2xl font-bold text-slate-900 md:text-3xl">진행 중인 이벤트</h2>
                        <p class="mt-2 text-sm text-slate-500 md:text-base">현재 참여할 수 있는 이벤트를 확인하고 기간 내에 신청하세요.</p>
                    </div>
                    <span class="chip">총 <c:out value="${ongoingCount}" default="0" />건</span>
                </div>

                <c:choose>
                    <c:when test="${not empty ongoingEvents}">
                        <div class="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
                            <c:forEach var="event" items="${ongoingEvents}">
                                <article class="flex h-full flex-col overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
                                    <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="relative block">
                                        <mytag:image fileName="${event.image}" altText="${event.title}" cssClass="h-48 w-full object-cover transition duration-300 ease-out hover:scale-[1.02]" />
                                        <div class="absolute inset-x-4 bottom-4 flex flex-wrap gap-2">
                                            <span class="inline-flex items-center gap-1 rounded-full bg-white/90 px-3 py-1 text-xs font-semibold text-slate-700 shadow">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-3.5 w-3.5">
                                                    <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                                                </svg>
                                                <fmt:formatDate value="${event.startDate}" pattern="MM.dd"/> ~ <fmt:formatDate value="${event.endDate}" pattern="MM.dd"/>
                                            </span>
                                            <span class="inline-flex items-center gap-1 rounded-full bg-emerald-500 px-3 py-1 text-xs font-semibold text-white shadow">
                                                진행 중
                                            </span>
                                        </div>
                                    </a>
                                    <div class="flex flex-1 flex-col gap-5 p-6">
                                        <div class="space-y-2">
                                            <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}">
                                                <h3 class="line-clamp-2 text-lg font-bold leading-snug text-slate-900 transition hover:text-emerald-600">
                                                    ${event.title}
                                                </h3>
                                            </a>
                                            <p class="line-clamp-3 text-sm text-slate-500">${event.summary}</p>
                                        </div>
                                        <div class="mt-auto flex items-center justify-between border-t border-slate-100 pt-4 text-sm text-slate-500">
                                            <div class="flex items-center gap-3">
                                                <span class="inline-flex h-1 w-1 items-center justify-center rounded-full bg-emerald-50 text-emerald-500">
                                                    <!-- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                        <path d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 00-1-1H6zm9 8h-4v3h4v-3z" />
                                                    </svg> -->
                                                </span>
                                                <div class="leading-tight">
                                                    <p class="text-xs font-semibold text-slate-400">이벤트 기간</p>
                                                    <p class="text-xs font-medium text-slate-700">
                                                        <fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd"/> ~
                                                        <fmt:formatDate value="${event.endDate}" pattern="MM.dd"/>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-white/80 px-8 py-16 text-center">
                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-emerald-50 text-4xl"></div>
                            <h3 class="mt-6 text-xl font-bold text-slate-800">열려 있는 이벤트가 없습니다.</h3>
                            <p class="mt-2 text-sm text-slate-500">새로운 이벤트가 등록되면 가장 먼저 알려드릴게요.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- 종료된 이벤트 섹션 -->
            <section class="border-t border-slate-200 bg-gradient-to-b from-slate-50 to-white">
                <div class="mx-auto w-full max-w-6xl px-6 py-16 md:px-10">
                    <div class="mb-8 flex flex-wrap items-end justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-bold text-slate-900 md:text-3xl">종료된 이벤트</h2>
                            <p class="mt-2 text-sm text-slate-500 md:text-base">지난 이벤트의 혜택과 후기를 확인해 보세요.</p>
                        </div>
                        <span class="chip">총 <c:out value="${finishedCount}" default="0" />건</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty finishedEvents}">
                            <div class="relative space-y-6 border-l border-slate-200 pl-6">
                                <c:forEach var="event" items="${finishedEvents}">
                                    <article class="group">
                                        <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="block">
                                            <div class="timeline-card">
                                                <span class="timeline-dot"></span>
                                                <div class="flex flex-wrap items-center justify-between gap-3">
                                                    <div>
                                                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">
                                                            종료 <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/>
                                                        </p>
                                                        <h3 class="mt-1 text-lg font-semibold text-slate-800 transition group-hover:text-emerald-600">${event.title}</h3>
                                                    </div>
                                                    <span class="inline-flex items-center gap-1 text-sm font-semibold text-slate-400 transition group-hover:text-emerald-600">
                                                        다시 보기
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                                        </svg>
                                                    </span>
                                                </div>
                                                <p class="mt-3 line-clamp-2 text-sm text-slate-500">${event.summary}</p>
                                            </div>
                                        </a>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-white/80 px-8 py-16 text-center">
                                <div class="flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-4xl"></div>
                                <h3 class="mt-6 text-xl font-bold text-slate-800">아직 종료된 이벤트가 없습니다.</h3>
                                <p class="mt-2 text-sm text-slate-500">진행이 끝난 이벤트는 이곳에서 순차적으로 확인할 수 있어요.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
