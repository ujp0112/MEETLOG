<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 공지사항</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

    <div id="app" class="flex flex-col bg-slate-100 min-h-screen">
        <%-- 1. 공통 헤더 포함 (경로 표준화) --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                <h2 class="text-3xl font-bold mb-8">📢 공지사항</h2>
                
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">제목</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">작성일</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="notice" items="${notices}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <c:if test="${notice.isImportant}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 mr-2">
                                                        중요
                                                    </span>
                                                </c:if>
                                                <span class="text-sm font-medium text-gray-900">${notice.title}</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty notices}">
                                    <tr>
                                        <td colspan="2" class="text-center py-12 text-gray-500">
                                            등록된 공지사항이 없습니다.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <%-- 2. 공통 푸터 포함 (경로 표준화) --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <!-- 3. 공통 로딩 오버레이 포함 -->
    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>