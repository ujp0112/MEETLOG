<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 추천 코스</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style type="text/tailwindcss">
        .page-btn { @apply w-8 h-8 flex items-center justify-center rounded-md border text-sm font-medium transition-colors; }
        .page-btn-active { @apply bg-sky-600 text-white border-sky-600; }
        .page-btn-inactive { @apply bg-white text-slate-600 border-slate-300 hover:bg-slate-50; }

        .chip { @apply inline-flex items-center gap-1 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600 transition hover:border-sky-400 hover:text-sky-600; }
        .section-title { @apply text-2xl md:text-3xl font-black text-slate-900; }
        .section-sub { @apply mt-2 text-sm text-slate-500 md:text-base; }
    </style>
</head>
<body class="bg-slate-50">

    <div class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="mx-auto w-full max-w-7xl px-4 py-10 md:px-6 md:py-14">

                <div class="relative overflow-hidden rounded-3xl bg-white shadow-lg">
                    <div class="absolute inset-0 bg-gradient-to-r from-sky-500/10 via-white to-transparent"></div>
                    <div class="relative flex flex-col gap-6 px-6 py-10 md:flex-row md:items-center md:justify-between md:px-10">
                        <div class="max-w-2xl">
                            <p class="inline-flex items-center gap-2 text-sm font-semibold uppercase tracking-wide text-sky-500">
                                <span class="text-lg">🗺️</span> 모두의 코스 둘러보기
                            </p>
                            <h1 class="mt-3 text-3xl font-black text-slate-900 md:text-4xl">다른 사람들의 미식 루트를 탐험해보세요</h1>
                            <p class="mt-4 text-sm text-slate-500 md:text-base">지역과 테마별로 취향이 맞는 코스를 찾고, 마음에 드는 일정은 내 코스로 저장할 수 있어요.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/course/create" class="inline-flex items-center gap-2 rounded-full bg-sky-500 px-6 py-3 text-sm font-semibold text-white shadow-lg shadow-sky-500/30 transition hover:-translate-y-0.5 hover:bg-sky-600">
                            ➕ 나만의 코스 만들기
                        </a>
                    </div>
                </div>

                <div class="mt-10 rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                    <form action="${pageContext.request.contextPath}/course/search" method="GET" class="space-y-6">
                        <div class="flex flex-wrap items-center justify-between gap-4">
                            <div>
                                <h2 class="section-title text-xl">코스 검색</h2>
                                <p class="section-sub">지역/테마/키워드로 원하는 일정을 쉽게 찾으세요.</p>
                            </div>
                        </div>
                        <div class="grid gap-4 md:grid-cols-[minmax(0,2fr)_minmax(0,1fr)_minmax(0,1fr)]">
                            <div>
                                <input type="text" name="query" placeholder="지역, 테마, 맛집 이름 등" class="mt-2 w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm shadow-inner focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200" />
                            </div>
                            <div class="flex items-end">
                                <button type="submit" class="w-full rounded-2xl bg-sky-500 px-4 py-3 text-sm font-semibold text-white shadow-lg shadow-sky-500/40 transition hover:-translate-y-0.5 hover:bg-sky-600">코스 검색</button>
                            </div>
                        </div>
                    </form>
                </div>

                <section class="mt-12">
                    <div class="flex flex-wrap items-end justify-between gap-4">
                        <div>
                            <h2 class="section-title">모두의 코스</h2>
                            <p class="section-sub">다양한 사용자가 공유한 최신 코스를 확인해 보세요.</p>
                        </div>
                        <div class="flex gap-2 text-xs text-slate-400">
                            <span class="chip">최신순</span>
                            <span class="chip">좋아요순</span>
                            <span class="chip">팔로우 코스</span>
                        </div>
                    </div>

                    <div id="community-course-list" class="mt-8 grid min-h-[420px] gap-8 sm:grid-cols-2 xl:grid-cols-3">
                    <c:forEach var="course" items="${communityCourses}">
                        <a href="${pageContext.request.contextPath}/course/detail?id=${course.id}" class="group relative block overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
                            <div class="relative">
                                <mytag:image fileName="${course.previewImage}" altText="${course.title}" cssClass="h-48 w-full object-cover transition duration-500 group-hover:scale-105" />
                                <div class="absolute inset-x-0 bottom-0 flex items-center justify-between bg-gradient-to-t from-slate-950/80 via-slate-900/10 to-transparent px-5 pb-4 pt-16 text-white">
                                    <h3 class="text-lg font-semibold">${course.title}</h3>
                                    <span class="flex items-center gap-1 text-xs font-medium">
                                        <svg class="h-4 w-4 text-rose-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"></path></svg>
                                        ${course.likes}
                                    </span>
                                </div>
                            </div>
                            <div class="space-y-4 p-5">
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="tag" items="${course.tags}">
                                        <span class="chip">${tag}</span>
                                    </c:forEach>
                                </div>
                                <div class="flex items-center justify-between border-t border-slate-100 pt-4 text-xs text-slate-500">
                                    <div class="flex items-center gap-3 text-sm text-slate-600">
                                        <mytag:image fileName="${course.profileImage}" altText="${course.author}" cssClass="h-9 w-9 rounded-full border border-slate-200" />
                                        <span class="font-semibold text-slate-700">${course.author}</span>
                                    </div>
                                    <span class="flex items-center gap-1 text-slate-400">
                                        <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                        <fmt:formatDate value="${course.createdAt}" pattern="yyyy.MM.dd" />
                                    </span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
                </section>

                <footer class="mt-12 flex justify-center">
                    <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
                </footer>

                <div class="mt-16 rounded-3xl bg-gradient-to-r from-sky-600 via-sky-500 to-indigo-500 px-8 py-12 text-white shadow-lg">
                    <div class="flex flex-col gap-8 lg:flex-row lg:items-center lg:justify-between">
                        <div class="max-w-xl">
                            <p class="text-sm uppercase tracking-wide text-white/70">Meet Log Pick</p>
                            <h2 class="mt-3 text-3xl font-black md:text-4xl">오늘의 추천 코스</h2>
                            <p class="mt-4 text-sm text-white/80 md:text-base">미식 전문가가 선택한 루트를 따라 완벽한 하루를 경험해 보세요. 인기 지역과 신규 오픈 맛집을 한 번에 만날 수 있어요.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/course/create" class="inline-flex items-center gap-2 rounded-full bg-white px-6 py-3 text-sm font-semibold text-slate-900 shadow-lg shadow-slate-900/20 transition hover:-translate-y-0.5">
                            추천 코스 더 보기
                        </a>
                    </div>
                </div>

                <div id="official-course-list" class="mt-12 space-y-10">
                    <c:forEach var="course" items="${officialCourses}">
                        <a href="${pageContext.request.contextPath}/course/detail?id=${course.id}" class="block overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-md transition hover:-translate-y-1 hover:shadow-xl">
                            <section class="flex flex-col gap-8 p-6 md:flex-row md:gap-12 md:p-8">
                                <div class="md:w-72">
                                    <c:set var="coverImage" value="" />
                                    <c:if test="${not empty course.steps}">
                                        <c:set var="coverImage" value="${course.steps[0].image}" />
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${not empty coverImage}">
                                            <div class="relative overflow-hidden rounded-2xl bg-slate-100">
                                                <mytag:image fileName="${coverImage}" altText="${course.title}" cssClass="h-60 w-full object-cover" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="flex h-60 items-center justify-center rounded-2xl bg-slate-100 text-sm font-medium text-slate-400">
                                                이미지 미등록
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-1">
                                    <h3 class="text-2xl font-bold text-slate-900">${course.title}</h3>
                                    <div class="mt-3 flex flex-wrap gap-2">
                                    <c:forEach var="tag" items="${course.tags}">
                                        <span class="chip">${tag}</span>
                                    </c:forEach>
                                </div>
                                    <div class="mt-6 space-y-6 border-l-2 border-slate-200 pl-6">
                                    <c:forEach var="step" items="${course.steps}" varStatus="status">
                                        <div class="relative pl-6">
                                            <div class="absolute -left-9 top-3 h-4 w-4 rounded-full border-2 border-white bg-sky-500 shadow"></div>
                                            <div class="flex items-start gap-4">
                                                <mytag:image fileName="${step.image}" altText="${step.name}" cssClass="h-24 w-24 rounded-xl object-cover shadow" />
                                                <div>
                                                    <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">${status.count}. ${step.type}</p>
                                                    <h4 class="mt-1 text-lg font-bold text-slate-900">${step.emoji} ${step.name}</h4>
                                                    <p class="mt-2 text-sm text-slate-600">${step.description}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </section>
                        </a>
                    </c:forEach>
                </div>

            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

</body>
</html>
