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
                <h1 class="text-3xl font-bold gradient-text mb-2">쿠폰 관리</h1>
                <p class="text-slate-600">고객에게 제공할 쿠폰을 생성하고 관리하세요</p>
            </div>

            <c:if test="${not empty ownedRestaurants}">
                <div class="mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <div class="text-sm text-slate-500">
                        <span class="font-semibold text-slate-700">선택된 매장:</span>
                        <span class="ml-2 text-base text-slate-800">${selectedRestaurant.name}</span>
                    </div>
                    <div class="flex items-center gap-3">
                        <label for="restaurantSelector" class="text-sm text-slate-600">다른 매장 선택</label>
                        <select id="restaurantSelector" onchange="switchRestaurant(this.value)"
                                class="px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <c:forEach items="${ownedRestaurants}" var="restaurant">
                                <option value="${restaurant.id}" ${restaurant.id == selectedRestaurant.id ? 'selected' : ''}>
                                    ${restaurant.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </c:if>

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
                <c:url var="createCouponUrl" value="/coupon/create">
                    <c:if test="${not empty selectedRestaurant}">
                        <c:param name="restaurantId" value="${selectedRestaurant.id}" />
                    </c:if>
                </c:url>

                <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
                    <h2 class="text-2xl font-bold text-slate-800">쿠폰 목록</h2>
                    <a href="${createCouponUrl}" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold inline-flex items-center justify-center">
                        + 새 쿠폰 생성
                    </a>
                </div>

                <!-- 필터 버튼 그룹 -->
                <c:if test="${not empty coupons}">
                    <div class="mb-6 flex flex-wrap gap-2">
                        <button onclick="filterCoupons('all')"
                                class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-blue-600 text-white"
                                data-filter="all">
                            전체 (${totalCoupons})
                        </button>
                        <button onclick="filterCoupons('available')"
                                class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                data-filter="available">
                            🟢 사용 가능
                        </button>
                        <button onclick="filterCoupons('notStarted')"
                                class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                data-filter="notStarted">
                            🟡 시작 전
                        </button>
                        <button onclick="filterCoupons('expired')"
                                class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                data-filter="expired">
                            🔴 만료됨
                        </button>
                        <button onclick="filterCoupons('inactive')"
                                class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                data-filter="inactive">
                            ⚫ 비활성
                        </button>
                        <button onclick="filterCoupons('depleted')"
                                class="filter-btn px-4 py-2 rounded-lg font-medium transition-all bg-slate-100 text-slate-700 hover:bg-slate-200"
                                data-filter="depleted">
                            🟠 소진됨
                        </button>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty coupons}">
                        <div id="couponList" class="space-y-4">
                            <c:forEach items="${coupons}" var="coupon">
                                <c:set var="couponStatus" value="available" />
                                <c:if test="${coupon.notStarted}">
                                    <c:set var="couponStatus" value="notStarted" />
                                </c:if>
                                <c:if test="${coupon.expired}">
                                    <c:set var="couponStatus" value="expired" />
                                </c:if>
                                <c:if test="${not coupon.active}">
                                    <c:set var="couponStatus" value="inactive" />
                                </c:if>
                                <c:if test="${not empty coupon.usageLimit && coupon.usageCount >= coupon.usageLimit}">
                                    <c:set var="couponStatus" value="depleted" />
                                </c:if>

                                <div class="coupon-card glass-card p-6 rounded-2xl border border-slate-100 shadow-sm" data-status="${couponStatus}">
                                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                                        <div class="flex-1">
                                            <div class="flex items-center gap-2 mb-2">
                                                <span class="text-xs font-semibold text-slate-400">#${coupon.id}</span>

                                                <!-- 쿠폰 상태 배지 -->
                                                <c:choose>
                                                    <c:when test="${coupon.available}">
                                                        <span class="text-xs font-semibold px-2 py-1 rounded-full bg-green-100 text-green-700">사용 가능</span>
                                                    </c:when>
                                                    <c:when test="${coupon.notStarted}">
                                                        <span class="text-xs font-semibold px-2 py-1 rounded-full bg-yellow-100 text-yellow-700">시작 전</span>
                                                    </c:when>
                                                    <c:when test="${coupon.expired}">
                                                        <span class="text-xs font-semibold px-2 py-1 rounded-full bg-red-100 text-red-700">만료됨</span>
                                                    </c:when>
                                                    <c:when test="${not coupon.active}">
                                                        <span class="text-xs font-semibold px-2 py-1 rounded-full bg-slate-200 text-slate-600">비활성</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:if test="${not empty coupon.usageLimit && coupon.usageCount >= coupon.usageLimit}">
                                                            <span class="text-xs font-semibold px-2 py-1 rounded-full bg-orange-100 text-orange-700">소진됨</span>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${not empty coupon.discountType}">
                                                    <span class="text-xs font-semibold px-2 py-1 rounded-full bg-blue-100 text-blue-700">
                                                        <c:choose>
                                                            <c:when test="${coupon.discountType == 'PERCENTAGE'}">
                                                                ${coupon.discountValue}% 할인
                                                            </c:when>
                                                            <c:when test="${coupon.discountType == 'FIXED'}">
                                                                ${coupon.discountValue}원 할인
                                                            </c:when>
                                                        </c:choose>
                                                    </span>
                                                </c:if>
                                            </div>
                                            <h3 class="text-xl font-bold text-slate-800 mb-2">${coupon.title}</h3>
                                            <p class="text-slate-600 mb-3">${empty coupon.description ? '설명 정보가 없습니다.' : coupon.description}</p>
                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm text-slate-600">
                                                <c:if test="${not empty coupon.validFrom && not empty coupon.validTo}">
                                                    <div class="flex items-center gap-2">
                                                        <span class="text-slate-500">📅 유효기간:</span>
                                                        <span class="font-medium">
                                                            <fmt:formatDate value="${coupon.validFrom}" pattern="yyyy-MM-dd"/> ~
                                                            <fmt:formatDate value="${coupon.validTo}" pattern="yyyy-MM-dd"/>
                                                        </span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty coupon.minOrderAmount && coupon.minOrderAmount > 0}">
                                                    <div class="flex items-center gap-2">
                                                        <span class="text-slate-500">💰 최소주문:</span>
                                                        <span class="font-medium">${coupon.minOrderAmount}원 이상</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty coupon.usageLimit}">
                                                    <div class="flex items-center gap-2">
                                                        <span class="text-slate-500">🎫 총 사용:</span>
                                                        <span class="font-medium">${coupon.usageCount} / ${coupon.usageLimit}회</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty coupon.perUserLimit}">
                                                    <div class="flex items-center gap-2">
                                                        <span class="text-slate-500">👤 인당제한:</span>
                                                        <span class="font-medium">${coupon.perUserLimit}회</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <c:if test="${not empty coupon.createdAt}">
                                                <div class="mt-2 text-xs text-slate-400">
                                                    생성일: <fmt:formatDate value="${coupon.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="flex items-center gap-3 self-end md:self-center">
                                            <button onclick="openEditModal(${coupon.id})"
                                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                                수정
                                            </button>
                                            <c:if test="${coupon.active}">
                                                <button onclick="deactivateCoupon(${coupon.id}, ${selectedRestaurant.id})"
                                                        class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                                                    비활성화
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🎟️</div>
                            <h3 class="text-xl font-bold text-slate-600 mb-2">생성된 쿠폰이 없습니다</h3>
                            <p class="text-slate-500 mb-6">첫 번째 쿠폰을 생성하여 고객에게 혜택을 제공해보세요!</p>
                            <a href="${createCouponUrl}" class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold inline-flex items-center justify-center">
                                쿠폰 생성하기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <!-- 쿠폰 수정 모달 -->
    <div id="editModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 overflow-y-auto">
        <div class="bg-white rounded-2xl p-8 max-w-2xl w-full mx-4 my-8">
            <h2 class="text-2xl font-bold text-slate-800 mb-6">쿠폰 수정</h2>
            <form id="editForm" method="POST" action="${pageContext.request.contextPath}/coupon-management" class="space-y-6">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="couponId" id="editCouponId">
                <input type="hidden" name="restaurantId" value="${selectedRestaurant.id}">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- 쿠폰명 -->
                    <div>
                        <label for="editCouponName" class="block text-sm font-medium text-slate-700 mb-2">쿠폰명 *</label>
                        <input type="text" id="editCouponName" name="couponName" required
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 신규 고객 10% 할인">
                    </div>

                    <!-- 할인 유형 -->
                    <div>
                        <label for="editDiscountType" class="block text-sm font-medium text-slate-700 mb-2">할인 유형 *</label>
                        <select id="editDiscountType" name="discountType" required
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
                        <label for="editDiscountValue" class="block text-sm font-medium text-slate-700 mb-2">할인 값 *</label>
                        <input type="number" id="editDiscountValue" name="discountValue" required min="1"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 10 (10% 또는 10원)">
                    </div>

                    <!-- 최소 주문 금액 -->
                    <div>
                        <label for="editMinOrderAmount" class="block text-sm font-medium text-slate-700 mb-2">최소 주문 금액</label>
                        <input type="number" id="editMinOrderAmount" name="minOrderAmount" min="0"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 10000 (10000원 이상)">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- 유효 시작일 -->
                    <div>
                        <label for="editValidFrom" class="block text-sm font-medium text-slate-700 mb-2">유효 시작일 *</label>
                        <input type="date" id="editValidFrom" name="validFrom" required
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>

                    <!-- 유효 종료일 -->
                    <div>
                        <label for="editValidTo" class="block text-sm font-medium text-slate-700 mb-2">유효 종료일 *</label>
                        <input type="date" id="editValidTo" name="validTo" required
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>
                </div>

                <!-- 쿠폰 설명 -->
                <div>
                    <label for="editDescription" class="block text-sm font-medium text-slate-700 mb-2">쿠폰 설명</label>
                    <textarea id="editDescription" name="description" rows="4"
                              class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                              placeholder="쿠폰에 대한 상세 설명을 입력하세요"></textarea>
                </div>

                <!-- 사용 제한 -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="editUsageLimit" class="block text-sm font-medium text-slate-700 mb-2">사용 제한 (회)</label>
                        <input type="number" id="editUsageLimit" name="usageLimit" min="1"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 100 (100회 사용 가능)">
                    </div>

                    <div>
                        <label for="editPerUserLimit" class="block text-sm font-medium text-slate-700 mb-2">사용자당 제한 (회)</label>
                        <input type="number" id="editPerUserLimit" name="perUserLimit" min="1"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                               placeholder="예: 1 (사용자당 1회 사용 가능)">
                    </div>
                </div>

                <div class="flex gap-3 pt-4">
                    <button type="submit" class="flex-1 bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                        수정
                    </button>
                    <button type="button" onclick="closeEditModal()" class="flex-1 bg-slate-200 text-slate-700 py-3 rounded-lg hover:bg-slate-300 transition-colors font-semibold">
                        취소
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchRestaurant(restaurantId) {
            if (!restaurantId) {
                return;
            }
            const url = new URL(window.location.href);
            url.searchParams.set('restaurantId', restaurantId);
            window.location.href = url.toString();
        }

        function openEditModal(couponId) {
            // AJAX로 쿠폰 데이터 가져오기
            fetch('${pageContext.request.contextPath}/coupon-management?action=getCoupon&couponId=' + couponId)
                .then(response => response.json())
                .then(coupon => {
                    document.getElementById('editCouponId').value = coupon.id;
                    document.getElementById('editCouponName').value = coupon.title || '';
                    document.getElementById('editDescription').value = coupon.description || '';
                    document.getElementById('editDiscountType').value = coupon.discountType || '';
                    document.getElementById('editDiscountValue').value = coupon.discountValue || '';
                    document.getElementById('editMinOrderAmount').value = coupon.minOrderAmount || '';

                    // Date 처리 - 안전하게 처리
                    if (coupon.validFrom) {
                        // 이미 YYYY-MM-DD 형식인 경우 그대로 사용
                        if (typeof coupon.validFrom === 'string' && coupon.validFrom.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            document.getElementById('editValidFrom').value = coupon.validFrom;
                        } else {
                            const validFrom = new Date(coupon.validFrom);
                            if (!isNaN(validFrom.getTime())) {
                                document.getElementById('editValidFrom').value = validFrom.toISOString().split('T')[0];
                            }
                        }
                    } else {
                        document.getElementById('editValidFrom').value = '';
                    }

                    if (coupon.validTo) {
                        // 이미 YYYY-MM-DD 형식인 경우 그대로 사용
                        if (typeof coupon.validTo === 'string' && coupon.validTo.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            document.getElementById('editValidTo').value = coupon.validTo;
                        } else {
                            const validTo = new Date(coupon.validTo);
                            if (!isNaN(validTo.getTime())) {
                                document.getElementById('editValidTo').value = validTo.toISOString().split('T')[0];
                            }
                        }
                    } else {
                        document.getElementById('editValidTo').value = '';
                    }

                    document.getElementById('editUsageLimit').value = coupon.usageLimit || '';
                    document.getElementById('editPerUserLimit').value = coupon.perUserLimit || '';

                    // 할인 유형에 따른 플레이스홀더 업데이트
                    updateDiscountValuePlaceholder();

                    document.getElementById('editModal').classList.remove('hidden');
                })
                .catch(error => {
                    console.error('쿠폰 정보 로딩 실패:', error);
                    alert('쿠폰 정보를 불러오는데 실패했습니다.');
                });
        }

        function updateDiscountValuePlaceholder() {
            const discountType = document.getElementById('editDiscountType').value;
            const discountValue = document.getElementById('editDiscountValue');
            if (discountType === 'PERCENTAGE') {
                discountValue.placeholder = '예: 10 (10% 할인)';
            } else if (discountType === 'FIXED') {
                discountValue.placeholder = '예: 1000 (1000원 할인)';
            }
        }

        // 할인 유형 변경 이벤트
        document.getElementById('editDiscountType').addEventListener('change', updateDiscountValuePlaceholder);

        // 날짜 유효성 검사
        document.getElementById('editValidFrom').addEventListener('change', function() {
            const validTo = document.getElementById('editValidTo');
            validTo.min = this.value;
        });

        function closeEditModal() {
            document.getElementById('editModal').classList.add('hidden');
        }

        function deactivateCoupon(couponId, restaurantId) {
            if (!confirm('이 쿠폰을 비활성화하시겠습니까?')) {
                return;
            }

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/coupon-management';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'deactivate';

            const couponIdInput = document.createElement('input');
            couponIdInput.type = 'hidden';
            couponIdInput.name = 'couponId';
            couponIdInput.value = couponId;

            const restaurantIdInput = document.createElement('input');
            restaurantIdInput.type = 'hidden';
            restaurantIdInput.name = 'restaurantId';
            restaurantIdInput.value = restaurantId;

            form.appendChild(actionInput);
            form.appendChild(couponIdInput);
            form.appendChild(restaurantIdInput);

            document.body.appendChild(form);
            form.submit();
        }

        // 모달 외부 클릭시 닫기
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });

        // 쿠폰 필터링 함수
        function filterCoupons(status) {
            const couponCards = document.querySelectorAll('.coupon-card');
            const filterButtons = document.querySelectorAll('.filter-btn');

            // 모든 버튼의 active 상태 제거
            filterButtons.forEach(btn => {
                btn.classList.remove('bg-blue-600', 'text-white');
                btn.classList.add('bg-slate-100', 'text-slate-700', 'hover:bg-slate-200');
            });

            // 클릭된 버튼을 active 상태로 변경
            const activeBtn = document.querySelector(`[data-filter="${status}"]`);
            if (activeBtn) {
                activeBtn.classList.remove('bg-slate-100', 'text-slate-700', 'hover:bg-slate-200');
                activeBtn.classList.add('bg-blue-600', 'text-white');
            }

            // 쿠폰 카드 필터링
            let visibleCount = 0;
            couponCards.forEach(card => {
                if (status === 'all') {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    if (card.dataset.status === status) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                }
            });

            // 필터링 결과가 없을 때 메시지 표시
            const couponList = document.getElementById('couponList');
            let noResultMsg = document.getElementById('noResultMessage');

            if (visibleCount === 0) {
                if (!noResultMsg) {
                    noResultMsg = document.createElement('div');
                    noResultMsg.id = 'noResultMessage';
                    noResultMsg.className = 'text-center py-12 text-slate-500';
                    noResultMsg.innerHTML = '<div class="text-4xl mb-3">🔍</div><p class="text-lg font-medium">해당 상태의 쿠폰이 없습니다.</p>';
                    couponList.appendChild(noResultMsg);
                }
                noResultMsg.style.display = 'block';
            } else {
                if (noResultMsg) {
                    noResultMsg.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>
