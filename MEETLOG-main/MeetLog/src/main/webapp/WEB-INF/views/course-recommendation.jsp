<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
    </style>
</head>
<body class="bg-slate-100">

    <div class="flex flex-col min-h-screen">
        <%-- 기존 JSP의 헤더 Include 방식을 유지합니다. --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <main class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                
                <div class="text-center mb-8">
                    <h2 class="text-3xl font-bold">🗺️ 모두의 코스 둘러보기</h2>
                    <p class="text-slate-500 mt-2">다른 사람들은 어떤 멋진 하루를 계획했을까요?</p>
                </div>
                
                <div class="mb-8 p-4 bg-white rounded-lg shadow-md">
                    <form action="${pageContext.request.contextPath}/course/search" method="GET">
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium">코스 검색</label>
                                <input type="text" name="query" placeholder="지역, 테마, 맛집 이름 등" class="mt-1 block w-full rounded-md border-slate-300">
                            </div>
                            <div>
                                <label class="block text-sm font-medium">지역</label>
                                <select name="area" class="mt-1 block w-full rounded-md border-slate-300">
                                    <option value="">전체</option>
                                    <option value="홍대">홍대</option>
                                    <option value="강남">강남</option>
                                </select>
                            </div>
                            <button type="submit" class="w-full bg-sky-600 text-white font-bold py-2.5 px-4 rounded-md hover:bg-sky-700">검색</button>
                        </div>
                    </form>
                </div>
                
                <div id="community-course-list" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 min-h-[500px]">
                    <c:forEach var="course" items="${communityCourses}">
                        <a href="${pageContext.request.contextPath}/course/detail?id=${course.id}" class="bg-white rounded-lg shadow-lg overflow-hidden transform hover:-translate-y-1 transition-transform duration-300 block">
                            <img src="${course.previewImage}" alt="${course.title}" class="w-full h-48 object-cover">
                            <div class="p-4">
                                <h3 class="text-lg font-bold truncate">${course.title}</h3>
                                <div class="flex flex-wrap gap-1 mt-2">
                                    <c:forEach var="tag" items="${course.tags}">
                                        <span class="text-xs font-semibold bg-sky-100 text-sky-700 px-2 py-1 rounded-full">${tag}</span>
                                    </c:forEach>
                                </div>
                                <div class="flex items-center justify-between mt-4 pt-4 border-t">
                                    <div class="flex items-center">
                                        <img src="${course.authorImage}" alt="${course.authorName}" class="w-8 h-8 rounded-full mr-2">
                                        <span class="text-sm font-semibold text-slate-700">${course.authorName}</span>
                                    </div>
                                    <span class="text-sm text-slate-500 flex items-center gap-1">
                                        <svg class="w-4 h-4 text-red-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"></path></svg>
                                        ${course.likes}
                                    </span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
                
                <footer class="mt-12 flex justify-center">
                    <%-- 
                      [참고] 
                      JS로 만들던 페이지네이션을 JSP Include로 변경했습니다.
                      프로젝트 구조에 'pagination.jsp'가 있는 것을 기반으로 추가했습니다.
                      필요한 데이터(Paging DTO 등)를 Servlet에서 넘겨줘야 합니다.
                    --%>
                    <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
                </footer>

                <hr class="my-16 border-t-2 border-dashed">

                <div class="flex justify-between items-center mb-8">
                    <div>
                        <h2 class="text-3xl font-bold">✨ 오늘의 추천코스</h2>
                        <p class="text-slate-500 mt-2">미식과 즐거움이 함께하는 완벽한 하루를 만나보세요.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/course/create" class="bg-sky-500 text-white font-bold py-2 px-5 rounded-full hover:bg-sky-600 whitespace-nowrap">
                        ➕ 나만의 코스 만들기
                    </a>
                </div>
                
                <div id="official-course-list" class="space-y-12">
                    <c:forEach var="course" items="${officialCourses}">
                        <a href="${pageContext.request.contextPath}/course/detail?id=${course.id}" class="block rounded-2xl transition-shadow hover:shadow-2xl">
                            <section class="bg-white p-6 rounded-2xl shadow-xl">
                                <h3 class="text-2xl font-bold">${course.title}</h3>
                                <div class="flex flex-wrap gap-2 mt-2 mb-6">
                                    <c:forEach var="tag" items="${course.tags}">
                                        <span class="text-xs font-semibold bg-sky-100 text-sky-700 px-2 py-1 rounded-full">${tag}</span>
                                    </c:forEach>
                                </div>
                                <div class="relative border-l-2 border-sky-200 pl-8 space-y-8">
                                    <c:forEach var="step" items="${course.steps}" varStatus="status">
                                        <div class="relative">
                                            <div class="absolute -left-10 top-2 w-4 h-4 bg-sky-500 rounded-full border-2 border-white"></div>
                                            <div class="flex items-start gap-4">
                                                <img src="${step.image}" class="w-24 h-24 rounded-lg object-cover shadow-md">
                                                <div>
                                                    <p class="text-sm text-slate-500">${status.count}. ${step.type}</p>
                                                    <h4 class="text-lg font-bold">${step.emoji} ${step.name}</h4>
                                                    <p class="text-sm text-slate-600 mt-1">${step.description}</p>
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
        
        <%-- 기존 JSP의 푸터 Include 방식을 유지합니다. --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
    
</body>
</html>