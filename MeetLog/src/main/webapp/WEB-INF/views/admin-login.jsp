<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 관리자 로그인</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <div class="max-w-md w-full space-y-8 p-4">
        <div>
            <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                관리자 로그인
            </h2>
            <p class="mt-2 text-center text-sm text-gray-600">
                MEET LOG 관리자 시스템
            </p>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                ${errorMessage}
            </div>
        </c:if>
        
        <form class="mt-8 space-y-6" method="post">
            <div class="rounded-md shadow-sm -space-y-px">
                <div>
                    <label for="adminId" class="sr-only">관리자 이메일</label>
                    <input id="adminId" name="adminId" type="text" required 
                           class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="관리자 이메일">
                </div>
                <div>
                    <label for="password" class="sr-only">비밀번호</label>
                    <input id="password" name="password" type="password" required 
                           class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="비밀번호">
                </div>
            </div>

            <div>
                <button type="submit" 
                        class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    로그인
                </button>
            </div>
            
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/" class="text-indigo-600 hover:text-indigo-500">
                    메인 페이지로 돌아가기
                </a>
            </div>
        </form>
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>