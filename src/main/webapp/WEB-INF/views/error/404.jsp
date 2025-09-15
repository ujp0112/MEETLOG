<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 페이지를 찾을 수 없습니다</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-slate-100">
    <div class="min-h-screen flex items-center justify-center">
        <div class="text-center">
            <h1 class="text-9xl font-bold text-sky-600">404</h1>
            <h2 class="text-2xl font-bold text-slate-800 mb-4">페이지를 찾을 수 없습니다</h2>
            <p class="text-slate-600 mb-8">요청하신 페이지가 존재하지 않거나 이동되었을 수 있습니다.</p>
            <a href="${pageContext.request.contextPath}/main" 
               class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700 transition-colors">
                메인 페이지로 돌아가기
            </a>
        </div>
    </div>
</body>
</html>
