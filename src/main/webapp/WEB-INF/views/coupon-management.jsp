<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>쿠폰 관리 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="mb-8">
                <h1 class="text-3xl font-bold gradient-text mb-2">🎟️ 쿠폰 관리</h1>
                <p class="text-slate-600">고객에게 제공할 쿠폰을 생성하고 관리하세요</p>
            </div>
            
            <!-- 통계 카드 섹션 -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">총 쿠폰</p>
                            <p class="text-3xl font-bold text-slate-800">${totalCoupons}</p>
                        </div>
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">🎫</span>
                        </div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">활성 쿠폰</p>
                            <p class="text-3xl font-bold text-green-600">${activeCoupons}</p>
                        </div>
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">만료된 쿠폰</p>
                            <p class="text-3xl font-bold text-red-600">${expiredCoupons}</p>
                        </div>
                        <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">❌</span>
                        </div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl slide-up">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-slate-600 text-sm font-medium">사용된 쿠폰</p>
                            <p class="text-3xl font-bold text-purple-600">${usedCoupons}</p>
                        </div>
                        <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                            <span class="text-2xl">🎯</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 쿠폰 관리 섹션 -->
            <div class="glass-card p-6 rounded-2xl">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-slate-800">쿠폰 목록</h2>
                    <button onclick="createCoupon()" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                        + 새 쿠폰 생성
                    </button>
                </div>
                
                <c:choose>
                    <c:when test="${not empty coupons}">
                        <div class="space-y-4">
                            <!-- 쿠폰 목록이 여기에 표시됩니다 -->
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🎟️</div>
                            <h3 class="text-xl font-bold text-slate-600 mb-2">생성된 쿠폰이 없습니다</h3>
                            <p class="text-slate-500 mb-6">첫 번째 쿠폰을 생성하여 고객에게 혜택을 제공해보세요!</p>
                            <button onclick="createCoupon()" class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                                쿠폰 생성하기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function createCoupon() {
            // 쿠폰 생성 로직 (추후 구현)
            alert('쿠폰 생성 기능은 추후 구현될 예정입니다.');
        }
    </script>
</body>
</html>