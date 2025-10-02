<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>쿠폰 생성 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="mb-8 space-y-2">
                <h1 class="text-3xl font-bold gradient-text">새 쿠폰 생성</h1>
                <p class="text-slate-600">고객에게 제공할 쿠폰을 생성하세요</p>
                <c:if test="${not empty selectedRestaurant}">
                    <div class="text-sm text-slate-500">
                        <span class="font-semibold text-slate-700">선택된 매장:</span>
                        <span class="ml-2 text-base text-slate-800">${selectedRestaurant.name}</span>
                    </div>
                </c:if>
            </div>
            
            <!-- 성공/에러 메시지 -->
            <c:if test="${not empty successMessage}">
                <div class="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-lg">
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 rounded-lg">
                    ${errorMessage}
                </div>
            </c:if>
            
            <!-- 쿠폰 생성 폼 -->
            <form action="${pageContext.request.contextPath}/coupon/create" method="post" class="space-y-6">
                <c:if test="${not empty ownedRestaurants}">
                    <div>
                        <label for="restaurantId" class="block text-sm font-medium text-slate-700 mb-2">쿠폰을 적용할 매장 *</label>
                        <select id="restaurantId" name="restaurantId" required
                                class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <c:forEach items="${ownedRestaurants}" var="restaurant">
                                <option value="${restaurant.id}" ${selectedRestaurant != null && restaurant.id == selectedRestaurant.id ? 'selected' : ''}>
                                    ${restaurant.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- 쿠폰명 -->
                    <div>
                        <label for="couponName" class="block text-sm font-medium text-slate-700 mb-2">쿠폰명 *</label>
                        <input type="text" id="couponName" name="couponName" required
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 신규 고객 10% 할인">
                    </div>
                    
                    <!-- 할인 유형 -->
                    <div>
                        <label for="discountType" class="block text-sm font-medium text-slate-700 mb-2">할인 유형 *</label>
                        <select id="discountType" name="discountType" required
                                class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <option value="">할인 유형을 선택하세요</option>
                            <option value="PERCENTAGE">퍼센트 할인</option>
                            <option value="FIXED">고정 금액 할인</option>
                        </select>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- 할인 값 -->
                    <div>
                        <label for="discountValue" class="block text-sm font-medium text-slate-700 mb-2">할인 값 *</label>
                        <input type="number" id="discountValue" name="discountValue" required min="1"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 10 (10% 또는 10원)">
                    </div>
                    
                    <!-- 최소 주문 금액 -->
                    <div>
                        <label for="minOrderAmount" class="block text-sm font-medium text-slate-700 mb-2">최소 주문 금액</label>
                        <input type="number" id="minOrderAmount" name="minOrderAmount" min="0"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 10000 (10000원 이상)">
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- 유효 시작일 -->
                    <div>
                        <label for="validFrom" class="block text-sm font-medium text-slate-700 mb-2">유효 시작일 *</label>
                        <input type="date" id="validFrom" name="validFrom" required
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>
                    
                    <!-- 유효 종료일 -->
                    <div>
                        <label for="validTo" class="block text-sm font-medium text-slate-700 mb-2">유효 종료일 *</label>
                        <input type="date" id="validTo" name="validTo" required
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>
                </div>
                
                <!-- 쿠폰 설명 -->
                <div>
                    <label for="description" class="block text-sm font-medium text-slate-700 mb-2">쿠폰 설명</label>
                    <textarea id="description" name="description" rows="4"
                              class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                              placeholder="쿠폰에 대한 상세 설명을 입력하세요"></textarea>
                </div>
                
                <!-- 사용 제한 -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="usageLimit" class="block text-sm font-medium text-slate-700 mb-2">사용 제한 (회)</label>
                        <input type="number" id="usageLimit" name="usageLimit" min="1"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 100 (100회 사용 가능)">
                    </div>
                    
                    <div>
                        <label for="perUserLimit" class="block text-sm font-medium text-slate-700 mb-2">사용자당 제한 (회)</label>
                        <input type="number" id="perUserLimit" name="perUserLimit" min="1"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 1 (사용자당 1회 사용 가능)">
                    </div>
                </div>
                
                <!-- 버튼 -->
                <div class="flex justify-end space-x-4 pt-6">
                    <a href="${pageContext.request.contextPath}/coupon-management" 
                       class="px-6 py-3 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors">
                        취소
                    </a>
                    <button type="submit" 
                            class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                        쿠폰 생성
                    </button>
                </div>
            </form>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 할인 유형에 따른 플레이스홀더 변경
        document.getElementById('discountType').addEventListener('change', function() {
            const discountValue = document.getElementById('discountValue');
            if (this.value === 'PERCENTAGE') {
                discountValue.placeholder = '예: 10 (10% 할인)';
            } else if (this.value === 'FIXED') {
                discountValue.placeholder = '예: 1000 (1000원 할인)';
            }
        });
        
        // 날짜 유효성 검사
        document.getElementById('validFrom').addEventListener('change', function() {
            const validTo = document.getElementById('validTo');
            validTo.min = this.value;
        });
    </script>
</body>
</html>
