<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서버 오류 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
    <div class="glass-card p-12 rounded-3xl text-center max-w-md w-full">
        <div class="text-8xl mb-6">⚠️</div>
        <h1 class="text-4xl font-bold gradient-text mb-4">500</h1>
        <h2 class="text-2xl font-bold text-slate-800 mb-4">서버 오류가 발생했습니다</h2>
        <p class="text-slate-600 mb-8">요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.</p>
        
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
                <p class="text-red-700 text-sm">${errorMessage}</p>
            </div>
        </c:if>
        
        <div class="space-y-3">
            <a href="${pageContext.request.contextPath}/main" 
               class="block w-full bg-sky-500 text-white font-semibold py-3 px-6 rounded-2xl hover:bg-sky-600 transition">
                🏠 메인으로 돌아가기
            </a>
            <button onclick="history.back()" 
                    class="block w-full bg-slate-100 text-slate-700 font-semibold py-3 px-6 rounded-2xl hover:bg-slate-200 transition">
                ← 이전 페이지로
            </button>
        </div>
    </div>
</body>
</html>
