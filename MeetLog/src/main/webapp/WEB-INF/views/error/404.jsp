<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>페이지를 찾을 수 없음 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
    <div class="glass-card p-12 rounded-3xl text-center max-w-md w-full">
        <div class="text-8xl mb-6">🔍</div>
        <h1 class="text-4xl font-bold gradient-text mb-4">404</h1>
        <h2 class="text-2xl font-bold text-slate-800 mb-4">페이지를 찾을 수 없습니다</h2>
        <p class="text-slate-600 mb-8">요청하신 페이지가 존재하지 않거나 이동되었을 수 있습니다.</p>
        
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
=======
    <title>MEET LOG - 페이지를 찾을 수 없습니다</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
>>>>>>> origin/my-feature
