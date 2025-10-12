<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 맛집 칼럼</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        .subtle-card { @apply rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8; }
        .search-hero-pill { @apply inline-flex items-center gap-2 rounded-full bg-amber-100/80 px-3 py-1 text-xs font-semibold text-amber-700; }
        .search-input { @apply w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm shadow-inner focus:border-amber-400 focus:outline-none focus:ring-2 focus:ring-amber-200; }
        .search-cta { @apply inline-flex items-center gap-2 rounded-full bg-slate-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-slate-800; }
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

        <main class="flex-grow">
            <section class="border-b border-slate-200 bg-gradient-to-r from-slate-50 via-white to-amber-50/70">
                <div class="mx-auto flex w-full max-w-6xl flex-col gap-8 px-6 py-12 md:flex-row md:items-center md:justify-between md:px-10">
                    <div class="max-w-3xl space-y-4">
                        <span class="search-hero-pill">
                            <span class="text-base">🍽️</span>
                            Meet Log Column
                        </span>
                        <h1 class="text-3xl font-bold leading-tight text-slate-900 md:text-4xl">모두가 함께하는 미식 칼럼 모음</h1>
                        <p class="text-sm text-slate-600 md:text-base">
                            미식가들이 남긴 인사이트를 모았습니다. 지역별 이야기부터 숨은 맛집의 비하인드까지, 오늘의 식사를 위한 영감을 얻어보세요.
                        </p>
                    </div>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/column/write"
                           class="inline-flex items-center gap-2 self-start rounded-full bg-amber-500 px-6 py-3 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-amber-600">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4">
                                <path fill-rule="evenodd" d="M3.5 9a.5.5 0 01.5-.5H9V3a1 1 0 112 0v5.5h5.5a.5.5 0 110 1H11V15a1 1 0 11-2 0v-5.5H4a.5.5 0 01-.5-.5z" clip-rule="evenodd" />
                            </svg>
                            새 칼럼 작성하기
                        </a>
                    </c:if>
                </div>
            </section>

            <section class="mx-auto w-full max-w-6xl px-6 py-10 md:px-10">
                <div class="subtle-card">
                    <form action="${pageContext.request.contextPath}/column/list" method="get" class="space-y-6">
                        <header class="space-y-3 text-center">
                            <h2 class="text-xl font-bold text-slate-900">관심 있는 칼럼을 빠르게 찾아보세요</h2>
                            <p class="text-sm text-slate-500">키워드로 검색하고, 미식가들의 이야기 속에서 오늘의 맛집 영감을 얻어보세요.</p>
                        </header>

                        <div class="flex flex-col items-center gap-4 md:flex-row md:justify-center md:gap-6">
                            <div class="w-full max-w-2xl">
                                <input type="text" name="keyword" value="${param.keyword}"
                                       placeholder="칼럼 제목, 작가명, 맛집 이름 등"
                                       class="search-input" />
                            </div>
                            <button type="submit" class="search-cta">
                                칼럼 검색
                            </button>
                        </div>
                    </form>
                </div>

                <c:choose>
                    <c:when test="${not empty columns}">
                        <div class="mt-10 grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3">
                            <c:forEach var="column" items="${columns}">
                                <article class="flex h-full flex-col overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-lg">
                                    <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}" class="relative block">
                                        <mytag:image fileName="${column.image}" altText="${column.title}" cssClass="h-48 w-full object-cover transition duration-300 ease-out hover:scale-[1.02]" />
                                        <div class="absolute inset-x-4 bottom-4 flex flex-wrap gap-2">
                                            <span class="inline-flex items-center gap-1 rounded-full bg-white/90 px-3 py-1 text-xs font-semibold text-slate-600 shadow">칼럼</span>
                                        </div>
                                    </a>
                                    <div class="flex flex-1 flex-col gap-5 p-6">
                                        <div class="space-y-2">
                                            <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}">
                                                <h2 class="line-clamp-2 text-lg font-bold leading-snug text-slate-900 transition hover:text-amber-600">
                                                    ${column.title}
                                                </h2>
                                            </a>
                                        </div>
                                        <div class="mt-auto flex items-center justify-between border-t border-slate-100 pt-4 text-sm text-slate-500">
                                            <div class="flex items-center gap-3">
                                                <mytag:image fileName="${column.profileImage}" altText="${column.author}" cssClass="h-10 w-10 rounded-full object-cover" />
                                                <div class="leading-tight">
                                                    <a href="${pageContext.request.contextPath}/feed/user/${column.userId}" class="font-semibold text-slate-700 transition hover:text-amber-600">${column.author}</a>
                                                    <p class="text-xs text-slate-400">칼럼니스트</p>
                                                </div>
                                            </div>
                                            <span class="text-xs font-medium text-slate-400">
                                                <c:choose>
                                                    <c:when test="${column.createdAt != null}">
                                                        <fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd" />
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="mt-10 flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-white/80 px-8 py-16 text-center">
                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-amber-50 text-4xl">📰</div>
                            <c:choose>
                                <c:when test="${not empty param.keyword}">
                                    <h3 class="mt-6 text-xl font-bold text-slate-800">'${param.keyword}'에 대한 검색 결과가 없습니다.</h3>
                                    <p class="mt-2 text-sm text-slate-500">다른 키워드로 다시 검색해보세요.</p>
                                </c:when>
                                <c:otherwise>
                                    <h3 class="mt-6 text-xl font-bold text-slate-800">아직 등록된 칼럼이 없습니다.</h3>
                                    <p class="mt-2 text-sm text-slate-500">첫 번째 맛집 칼럼을 작성하고 미식 경험을 공유해보세요.</p>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/column/write"
                                   class="mt-6 inline-flex items-center gap-2 rounded-full bg-amber-500 px-6 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-amber-600">
                                    지금 칼럼 쓰기
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
