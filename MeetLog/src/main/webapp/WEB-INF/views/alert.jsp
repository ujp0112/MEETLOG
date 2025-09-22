<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 알림</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

    <div id="app" class="flex flex-col bg-slate-100 min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                <h2 class="text-3xl font-bold mb-8">🔔 알림</h2>
                
                <div class="space-y-4">
                    <c:forEach var="alert" items="${alerts}">
                        <div class="bg-white rounded-lg shadow-md p-6 ${alert.isRead ? 'opacity-60' : ''}">
                            <div class="flex items-start">
                                <div class="flex-shrink-0 pt-1">
                                    <c:if test="${!alert.isRead}">
                                        <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                                    </c:if>
                                </div>
                                <div class="ml-4 flex-1">
                                    <h3 class="text-lg font-medium text-gray-900 mb-2">${alert.title}</h3>
                                    <p class="text-gray-600 mb-2">${alert.content}</p>
                                    <p class="text-sm text-gray-500">
                                        <fmt:formatDate value="${alert.createdAt}" pattern="yyyy.MM.dd HH:mm"/>
                                    </p>
                                </div>
                                <c:if test="${!alert.isRead}">
                                    <button class="ml-4 text-sm text-blue-600 hover:text-blue-800">
                                        읽음
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${empty alerts}">
                    <div class="text-center py-12">
                        <div class="text-gray-400 text-6xl mb-4">🔔</div>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">알림이 없습니다</h3>
                        <p class="text-gray-500">새로운 알림이 오면 여기에 표시됩니다.</p>
                    </div>
                </c:if>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>