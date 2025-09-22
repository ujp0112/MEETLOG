<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MEET LOG - 지점 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
    </style>
</head>
<body class="bg-gray-50">

    <%@ include file="/WEB-INF/layout/header.jspf" %>

    <main class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-3xl font-bold text-gray-800 mb-2">🏪 지점 관리</h1>
            <p class="text-gray-500 mb-8">새로 가입을 신청한 지점을 승인하거나 거절할 수 있습니다.</p>

            <div class="bg-white p-6 md:p-8 rounded-2xl shadow-md">
                <h2 class="text-xl font-semibold text-gray-700 mb-6 border-b pb-4">신규 지점 추가 요청</h2>
    
                <c:choose>
                    <c:when test="${not empty pendingBranches}">
                        <div class="space-y-4">
                            <c:forEach var="branchUser" items="${pendingBranches}">
                                <div class="flex flex-col sm:flex-row sm:items-center justify-between p-4 border rounded-lg hover:bg-gray-50 transition-colors">
                                    
                                    <div class="mb-3 sm:mb-0">
                                        <p class="font-bold text-lg text-gray-800">${branchUser.businessName}</p>
                                        <div class="text-sm text-gray-500 mt-1 space-x-3">
                                            <span>대표자: ${branchUser.ownerName}</span>
                                            <span>|</span>
                                            <span>이메일: ${branchUser.email}</span>
                                        </div>
                                    </div>
                                    
                                    <div class="flex-shrink-0 flex space-x-2">
                                        <form action="${pageContext.request.contextPath}/hq/branch-management" method="post" class="inline">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="userId" value="${branchUser.userId}">
                                            <button type="submit" class="bg-sky-500 text-white text-sm font-bold py-2 px-4 rounded-md hover:bg-sky-600 transition-colors">승인</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/hq/branch-management" method="post" class="inline">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="userId" value="${branchUser.userId}">
                                            <button type="submit" class="bg-red-500 text-white text-sm font-bold py-2 px-4 rounded-md hover:bg-red-600 transition-colors">거절</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-gray-500 py-10">
                            <p>현재 승인을 기다리는 지점이 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </main>

</body>
</html>