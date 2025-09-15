<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 맛집 칼럼</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        /* 여러 줄 말줄임 처리를 위한 Tailwind CSS 플러그인 설정 (실제 프로젝트에서는 tailwind.config.js에 추가) */
        @layer utilities {
            .line-clamp-2 {
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
            .line-clamp-3 {
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
        }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8 flex justify-between items-center">
                    <div>
                        <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">맛집 칼럼</h2>
                        <p class="text-slate-600">전문가들의 생생한 맛집 이야기를 만나보세요.</p>
                    </div>
                    <%-- 로그인한 사용자에게만 '칼럼 작성' 버튼이 보이도록 처리 --%>
                    <c:if test="${not empty sessionScope.user}">
	                    <a href="${pageContext.request.contextPath}/column/write" 
	                       class="bg-sky-600 text-white font-bold py-2 px-5 rounded-lg hover:bg-sky-700 transition-colors">
	                        칼럼 작성
	                    </a>
                    </c:if>
                </div>

                <c:choose>
                    <%-- columns 리스트에 데이터가 하나라도 있는 경우 --%>
                    <c:when test="${not empty columns}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="column" items="${columns}">
                                <div class="bg-white rounded-xl shadow-lg overflow-hidden group transform hover:-translate-y-1 transition-all duration-300">
                                    <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}">
                                        <div class="overflow-hidden">
                                             <img src="${not empty column.image ? column.image : 'https://placehold.co/400x250/e2e8f0/64748b?text=MEET+LOG'}"
                                                 alt="${column.title}" class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300">
                                        </div>
                                    </a>
                                    <div class="p-5">
                                        <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}">
	                                        <h3 class="text-lg font-bold text-slate-800 mb-2 line-clamp-2 h-14 group-hover:text-sky-600 transition-colors">${column.title}</h3>
                                        </a>
                                        
                                        <div class="flex items-center justify-between text-sm text-slate-500 mt-4 pt-4 border-t border-slate-100">
                                            <div class="flex items-center space-x-2">
                                                <img src="${not empty column.authorImage ? column.authorImage : 'https://placehold.co/24x24/94a3b8/ffffff?text=A'}" 
                                                     class="w-6 h-6 rounded-full object-cover" alt="${column.author}">
                                                <span>${column.author}</span>
                                            </div>
                                            <span><fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd" /></span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <%-- columns 리스트가 비어있는 경우 --%>
                    <c:otherwise>
                        <div class="col-span-full text-center py-20">
                            <div class="text-6xl mb-4">📰</div>
                            <h3 class="text-xl font-bold text-slate-800 mb-2">아직 작성된 칼럼이 없습니다.</h3>
                            <p class="text-slate-600 mb-6">첫 번째 맛집 칼럼을 작성해보세요!</p>
                             <c:if test="${not empty sessionScope.user}">
	                            <a href="${pageContext.request.contextPath}/column/write" 
	                               class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700 transition-colors">
	                                첫 칼럼 작성하기
	                            </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
