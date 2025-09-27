<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 내 칼럼 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        @layer utilities {
            .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
            .line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
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
                        <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">내 칼럼 관리</h2>
                        <p class="text-slate-600">작성하신 칼럼을 수정하거나 삭제할 수 있습니다.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/column/write" 
                       class="form-btn-primary shrink-0">
                        새 칼럼 작성
                    </a>
                </div>

                <c:choose>
                    <%-- 1. myColumns 데이터가 있는 경우, 목록을 표시 --%>
                    <c:when test="${not empty myColumns}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="column" items="${myColumns}">
                                <div class="bg-white rounded-xl shadow-lg overflow-hidden flex flex-col">
                                    <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}">
                                        <img src="${not empty column.image ? column.image : 'https://placehold.co/400x250/e2e8f0/64748b?text=MEET+LOG'}" 
                                             alt="${column.title}" class="w-full h-48 object-cover">
                                    </a>
                                    <div class="p-5 flex flex-col flex-grow">
                                        <h3 class="text-lg font-bold text-slate-800 mb-2 line-clamp-2 h-14">${column.title}</h3>
                                        <div class="flex items-center justify-between text-xs text-slate-500 mb-4">
                                            <span>
                                                <c:choose>
                                                    <c:when test="${column.createdAt != null}">
                                                        ${column.createdAt.toString().substring(0, 10).replace('-', '.')}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <div class="flex items-center space-x-3">
                                                <span>👁️ <fmt:formatNumber value="${column.views}" type="number" /></span>
                                                <span>❤️ <fmt:formatNumber value="${column.likes}" type="number" /></span>
                                            </div>
                                        </div>
                                        <div class="mt-auto pt-4 border-t border-slate-100 flex items-center justify-between">
                                            <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}" class="form-btn-secondary text-sm">자세히 보기</a>
                                            <div class="flex items-center space-x-2">
                                                <a href="${pageContext.request.contextPath}/column/edit?id=${column.id}" class="text-slate-500 hover:text-slate-700 text-sm font-medium">수정</a>
                                                <span class="text-slate-300">|</span>
                                                <button onclick="deleteColumn(${column.id})" class="text-red-500 hover:text-red-700 text-sm font-medium">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <%-- 2. myColumns 데이터가 없는 경우, 안내 메시지 표시 --%>
                    <c:otherwise>
                        <div class="text-center py-20 bg-white rounded-xl shadow-lg">
                            <div class="text-6xl mb-4">📰</div>
                            <h3 class="text-xl font-bold text-slate-800 mb-2">아직 작성한 칼럼이 없습니다.</h3>
                            <p class="text-slate-600 mb-6">나만 아는 맛집 이야기를 공유하고 칼럼니스트가 되어보세요!</p>
                            <a href="${pageContext.request.contextPath}/column/write" 
                               class="form-btn-primary inline-block">
                                첫 칼럼 작성하기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function deleteColumn(columnId) {
            if (confirm('정말로 이 칼럼을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                // POST 요청을 보내기 위한 form 동적 생성
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/column/delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = columnId;
                form.appendChild(idInput);
                
                // CSRF 토큰 등이 필요하다면 여기에 추가
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
