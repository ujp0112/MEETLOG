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
        body { font-family: 'Noto Sans KR', sans-serif; }
        .chip { @apply inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-semibold text-slate-600; }
        .chip-on-dark { @apply inline-flex items-center gap-2 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold text-white/80; }
        .section-title { @apply text-xl font-bold text-slate-900 md:text-2xl; }
        .section-sub { @apply mt-1 text-sm text-slate-500 md:text-base; }
        .stat-card { @apply rounded-2xl border border-slate-200 bg-white p-6 shadow-sm md:p-7; }
        .subtle-card { @apply rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8; }
        .event-card { @apply flex h-full flex-col overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-lg; }
        .timeline-card { @apply relative overflow-hidden rounded-2xl border border-transparent bg-white p-5 shadow-sm transition hover:border-sky-200 hover:shadow-md; }
        .timeline-dot { @apply absolute -left-[39px] mt-1 h-3 w-3 rounded-full border-4 border-slate-50 bg-slate-300 transition group-hover:border-sky-100 group-hover:bg-sky-500; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800">
    <div id="app" class="flex min-h-screen flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow bg-slate-50">
            <c:set var="ongoingCount" value="${fn:length(ongoingEvents)}" />
            <c:set var="finishedCount" value="${fn:length(finishedEvents)}" />

            <div class="mx-auto w-full max-w-6xl px-4 py-10 md:px-6 md:py-14">
                <div class="space-y-16">
                    <section class="overflow-hidden rounded-3xl bg-white shadow-xl">
                        <div class="relative">
                            <div class="absolute inset-0 bg-gradient-to-br from-sky-600 via-slate-900 to-slate-800"></div>
                            <div class="relative z-10 grid gap-10 p-8 text-white md:p-12 lg:grid-cols-[minmax(0,2fr)_minmax(0,1fr)] lg:items-start">
                                <div class="space-y-6">
                                    <div class="flex flex-wrap gap-2">
                                        <span class="chip-on-dark">Meet Log Events</span>
                                        <span class="chip-on-dark">진행 <c:out value="${ongoingCount}" default="0" />건</span>
                                        <span class="chip-on-dark">종료 <c:out value="${finishedCount}" default="0" />건</span>
                                    </div>
                                    <div class="space-y-4">
                                        <h1 class="text-3xl font-extrabold leading-tight md:text-4xl">지금 참여하면 좋은 이벤트를 한 번에 만나보세요</h1>
                                        <p class="text-base text-white/80 md:text-lg">현재 진행 중인 프로모션과 지난 이벤트를 한 화면에 모았습니다. 관심 있는 이벤트를 놓치지 않도록 달력에 표시하고, 커뮤니티와 함께 즐거운 경험을 나눠보세요.</p>
                                    </div>
                                    <div class="flex flex-wrap gap-3 text-sm text-white/80">
                                        <span class="chip-on-dark">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                <path fill-rule="evenodd" d="M5 2a1 1 0 00-1 1v2H3a2 2 0 00-2 2v1h18V7a2 2 0 00-2-2h-1V3a1 1 0 00-1-1H5zm13 7H2v7a2 2 0 002 2h12a2 2 0 002-2V9zM6 12a1 1 0 112 0 1 1 0 01-2 0zm6-1a1 1 0 000 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
                                            </svg>
                                            기간 한정 혜택 모음
                                        </span>
                                        <span class="chip-on-dark">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                <path d="M12 18a1 1 0 001-1v-2.382l.276-.276a4 4 0 000-5.656l-.894-.894a2 2 0 010-2.828l.894-.894a4 4 0 000-5.656L12 .586A2 2 0 009.172.586l-.894.894a4 4 0 000 5.656l.894.894a2 2 0 010 2.828l-.894.894a4 4 0 000 5.656l.276.276V17a1 1 0 001 1h2z" />
                                            </svg>
                                            커뮤니티 참여 포인트
                                        </span>
                                        <span class="chip-on-dark">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                <path fill-rule="evenodd" d="M10 2a1 1 0 01.894.553l1.562 3.124 3.447.501a1 1 0 01.554 1.705l-2.49 2.426.588 3.429a1 1 0 01-1.45 1.054L10 13.347l-3.105 1.695a1 1 0 01-1.45-1.054l.588-3.429-2.49-2.426a1 1 0 01.554-1.705l3.447-.501 1.562-3.124A1 1 0 0110 2z" clip-rule="evenodd" />
                                            </svg>
                                            우수 참여자 리워드
                                        </span>
                                    </div>
                                </div>
                                <div class="space-y-4 rounded-3xl border border-white/20 bg-white/10 p-6 backdrop-blur">
                                    <p class="text-sm font-semibold text-white/90">이벤트 활용 팁</p>
                                    <ul class="space-y-3 text-sm leading-relaxed text-white/80">
                                        <li class="flex gap-3">
                                            <span class="inline-flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-white/20 text-xs font-semibold text-white/90">1</span>
                                            관심 이벤트를 찜하면 종료 전 알림을 받을 수 있어요.
                                        </li>
                                        <li class="flex gap-3">
                                            <span class="inline-flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-white/20 text-xs font-semibold text-white/90">2</span>
                                            지난 이벤트에서도 상세 정보를 다시 확인할 수 있습니다.
                                        </li>
                                        <li class="flex gap-3">
                                            <span class="inline-flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-white/20 text-xs font-semibold text-white/90">3</span>
                                            링크를 공유해 친구와 함께 참여를 즐겨보세요.
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="ongoing-events" class="space-y-6">
                        <div class="flex flex-wrap items-center justify-between gap-4">
                            <div>
                                <h2 class="section-title">진행 중인 이벤트</h2>
                                <p class="section-sub">현재 참여할 수 있는 이벤트를 확인하고 기간 내에 신청하세요.</p>
                            </div>
                            <span class="chip">총 <c:out value="${ongoingCount}" default="0" />건</span>
                        </div>

                        <c:if test="${empty ongoingEvents}">
                            <div class="subtle-card text-center">
                                <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-slate-400">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-8 w-8">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6.75L17.25 8.25" />
                                    </svg>
                                </div>
                                <p class="mt-4 text-lg font-semibold text-slate-700">열려 있는 이벤트가 없습니다.</p>
                                <p class="mt-2 text-sm text-slate-500">새로운 이벤트가 등록되면 가장 먼저 알려드릴게요.</p>
                            </div>
                        </c:if>

                        <div class="grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3">
                            <c:forEach var="event" items="${ongoingEvents}">
                                <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="group h-full">
                                    <article class="event-card">
                                        <div class="relative">
                                            <mytag:image fileName="${event.image}" altText="${event.title}" cssClass="h-48 w-full object-cover" />
                                            <div class="absolute inset-x-4 bottom-4 flex flex-wrap gap-2">
                                                <span class="inline-flex items-center gap-1 rounded-full bg-white/90 px-3 py-1 text-xs font-semibold text-slate-700 shadow">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-3.5 w-3.5">
                                                        <path d="M10 2a7 7 0 100 14 7 7 0 000-14zm1 7a1 1 0 01-1 1H6a1 1 0 110-2h3V5a1 1 0 112 0v4z" />
                                                    </svg>
                                                    <fmt:formatDate value="${event.startDate}" pattern="MM.dd"/> ~ <fmt:formatDate value="${event.endDate}" pattern="MM.dd"/>
                                                </span>
                                                <span class="inline-flex items-center gap-1 rounded-full bg-sky-500 px-3 py-1 text-xs font-semibold text-white shadow">
                                                    진행 중
                                                </span>
                                            </div>
                                        </div>
                                        <div class="flex flex-1 flex-col gap-4 p-6">
                                            <div class="space-y-2">
                                                <h3 class="line-clamp-2 text-lg font-bold leading-snug text-slate-900">${event.title}</h3>
                                                <p class="line-clamp-3 text-sm text-slate-500">${event.summary}</p>
                                            </div>
                                            <div class="mt-auto flex items-center justify-between text-sm text-slate-400">
                                                <div class="flex items-center gap-2">
                                                    <span class="inline-flex h-9 w-9 items-center justify-center rounded-full bg-sky-50 text-sky-500">
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
                                                            <path d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 00-1-1H6zm9 8h-4v3h4v-3z" />
                                                        </svg>
                                                    </span>
                                                    <div>
                                                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">기간</p>
                                                        <p class="text-sm font-medium text-slate-700">
                                                            <fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd"/> ~
                                                            <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/>
                                                        </p>
                                                    </div>
                                                </div>
                                                <span class="inline-flex items-center gap-1 text-sm font-semibold text-sky-500 transition group-hover:text-sky-600">
                                                    자세히 보기
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                        <path fill-rule="evenodd" d="M12.293 3.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 9H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                    </svg>
                                                </span>
                                            </div>
                                        </div>
                                    </article>
                                </a>
                            </c:forEach>
                        </div>
                    </section>

                    <section id="finished-events" class="space-y-6">
                        <div class="flex flex-wrap items-center justify-between gap-4">
                            <div>
                                <h2 class="section-title">종료된 이벤트</h2>
                                <p class="section-sub">지난 이벤트의 혜택과 후기를 확인해 보세요.</p>
                            </div>
                            <span class="chip">총 <c:out value="${finishedCount}" default="0" />건</span>
                        </div>

                        <c:if test="${empty finishedEvents}">
                            <div class="subtle-card text-center">
                                <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-slate-400">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-8 w-8">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0A9 9 0 1112 3a9 9 0 019 9z" />
                                    </svg>
                                </div>
                                <p class="mt-4 text-lg font-semibold text-slate-700">아직 종료된 이벤트가 없습니다.</p>
                                <p class="mt-2 text-sm text-slate-500">진행이 끝난 이벤트는 이곳에서 순차적으로 확인할 수 있어요.</p>
                            </div>
                        </c:if>

                        <div class="relative border-l border-slate-200 pl-6">
                            <c:forEach var="event" items="${finishedEvents}">
                                <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="group block">
                                    <article class="timeline-card">
                                        <span class="timeline-dot"></span>
                                        <div class="flex flex-wrap items-center justify-between gap-3">
                                            <div>
                                                <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">
                                                    종료 <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/>
                                                </p>
                                                <h3 class="mt-1 text-lg font-semibold text-slate-800">${event.title}</h3>
                                            </div>
                                            <span class="inline-flex items-center gap-1 text-sm font-semibold text-slate-400 transition group-hover:text-sky-600">
                                                다시 보기
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                                    <path fill-rule="evenodd" d="M4.293 9.293a1 1 0 011.414 0L9 12.586l5.293-5.293a1 1 0 111.414 1.414l-6 6a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                </svg>
                                            </span>
                                        </div>
                                        <p class="mt-3 line-clamp-2 text-sm text-slate-500">${event.summary}</p>
                                    </article>
                                </a>
                            </c:forEach>
                        </div>
                    </section>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
