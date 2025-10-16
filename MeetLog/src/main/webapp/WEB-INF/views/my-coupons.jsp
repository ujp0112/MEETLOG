<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 내 쿠폰 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .coupon-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow: hidden;
        }
        .coupon-card::before {
            content: '';
            position: absolute;
            right: -20px;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            z-index: 1;
        }
        .coupon-card::after {
            content: '';
            position: absolute;
            left: -20px;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            z-index: 1;
        }
        .used-coupon {
            background: linear-gradient(135deg, #a0a0a0 0%, #757575 100%);
            opacity: 0.7;
        }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8">
                    <div class="flex items-center gap-4 mb-4">
                        <a href="${pageContext.request.contextPath}/mypage"
                           class="text-slate-500 hover:text-sky-600 transition-colors">
                            ← 마이페이지로 돌아가기
                        </a>
                    </div>
                    <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">내 쿠폰 관리</h2>
                    <p class="text-slate-600">보유하신 쿠폰을 확인하고 사용할 수 있습니다.</p>
                </div>

                <!-- 쿠폰 통계 -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                        <div class="text-2xl font-bold text-sky-600">${totalCouponCount}</div>
                        <div class="text-sm text-slate-600">전체 쿠폰</div>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                        <div class="text-2xl font-bold text-green-600">${availableCouponCount}</div>
                        <div class="text-sm text-slate-600">사용 가능</div>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                        <div class="text-2xl font-bold text-gray-600">${usedCouponCount}</div>
                        <div class="text-sm text-slate-600">사용 완료</div>
                    </div>
                </div>

                <!-- 탭 메뉴 -->
                <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div class="border-b border-slate-200">
                        <nav class="-mb-px flex">
                            <button onclick="showTab('all')" id="tab-all"
                                    class="tab-button py-4 px-6 border-b-2 border-sky-500 text-sky-600 font-medium">
                                전체 쿠폰 (${totalCouponCount})
                            </button>
                            <button onclick="showTab('available')" id="tab-available"
                                    class="tab-button py-4 px-6 border-b-2 border-transparent text-slate-500 hover:text-slate-700">
                                사용 가능 (${availableCouponCount})
                            </button>
                            <button onclick="showTab('used')" id="tab-used"
                                    class="tab-button py-4 px-6 border-b-2 border-transparent text-slate-500 hover:text-slate-700">
                                사용 완료 (${usedCouponCount})
                            </button>
                        </nav>
                    </div>

                    <!-- 전체 쿠폰 -->
                    <div id="content-all" class="tab-content p-6">
                        <c:choose>
                            <c:when test="${not empty allCoupons}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach items="${allCoupons}" var="coupon">
                                        <div class="coupon-card ${coupon.used ? 'used-coupon' : ''} text-white p-6 rounded-xl shadow-lg">
                                            <div class="relative z-10">
                                                <div class="flex justify-between items-start mb-4">
                                                    <div class="text-sm opacity-90">${coupon.restaurantName}</div>
                                                    <div class="text-xs bg-white bg-opacity-20 px-2 py-1 rounded-full">
                                                        ${coupon.used ? '사용완료' : '사용가능'}
                                                    </div>
                                                </div>
                                                <h3 class="text-lg font-bold mb-2">${coupon.title}</h3>
                                                <p class="text-sm opacity-90 mb-4">${coupon.description}</p>
                                                <div class="flex justify-between items-end">
                                                    <div class="text-xs opacity-80">
                                                        <div>받은 날짜: ${coupon.formattedReceivedAt}</div>
                                                        <c:if test="${coupon.used}">
                                                            <div>사용 날짜: ${coupon.formattedUsedAt}</div>
                                                        </c:if>
                                                    </div>
                                                    <c:if test="${not coupon.used}">
                                                        <button onclick="useCoupon(${coupon.id})"
                                                                class="bg-white text-purple-600 px-4 py-2 rounded-lg font-medium hover:bg-opacity-90 transition-all">
                                                            사용하기
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
                                    <div class="text-6xl mb-4">🎫</div>
                                    <p class="text-slate-500">보유한 쿠폰이 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 사용 가능한 쿠폰 -->
                    <div id="content-available" class="tab-content p-6 hidden">
                        <c:choose>
                            <c:when test="${not empty availableCoupons}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach items="${availableCoupons}" var="coupon">
                                        <div class="coupon-card text-white p-6 rounded-xl shadow-lg">
                                            <div class="relative z-10">
                                                <div class="flex justify-between items-start mb-4">
                                                    <div class="text-sm opacity-90">${coupon.restaurantName}</div>
                                                    <div class="text-xs bg-white bg-opacity-20 px-2 py-1 rounded-full">사용가능</div>
                                                </div>
                                                <h3 class="text-lg font-bold mb-2">${coupon.title}</h3>
                                                <p class="text-sm opacity-90 mb-4">${coupon.description}</p>
                                                <div class="flex justify-between items-end">
                                                    <div class="text-xs opacity-80">
                                                        받은 날짜: ${coupon.formattedReceivedAt}
                                                    </div>
                                                    <button onclick="useCoupon(${coupon.id})"
                                                            class="bg-white text-purple-600 px-4 py-2 rounded-lg font-medium hover:bg-opacity-90 transition-all">
                                                        사용하기
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">🎫</div>
                                    <p class="text-slate-500">사용 가능한 쿠폰이 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 사용한 쿠폰 -->
                    <div id="content-used" class="tab-content p-6 hidden">
                        <c:choose>
                            <c:when test="${not empty usedCoupons}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach items="${usedCoupons}" var="coupon">
                                        <div class="coupon-card used-coupon text-white p-6 rounded-xl shadow-lg">
                                            <div class="relative z-10">
                                                <div class="flex justify-between items-start mb-4">
                                                    <div class="text-sm opacity-90">${coupon.restaurantName}</div>
                                                    <div class="text-xs bg-white bg-opacity-20 px-2 py-1 rounded-full">사용완료</div>
                                                </div>
                                                <h3 class="text-lg font-bold mb-2">${coupon.title}</h3>
                                                <p class="text-sm opacity-90 mb-4">${coupon.description}</p>
                                                <div class="text-xs opacity-80">
                                                    <div>받은 날짜: ${coupon.formattedReceivedAt}</div>
                                                    <div>사용 날짜: ${coupon.formattedUsedAt}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">🎫</div>
                                    <p class="text-slate-500">사용한 쿠폰이 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function showTab(tabName) {
            // 모든 탭 버튼 비활성화
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('border-sky-500', 'text-sky-600');
                button.classList.add('border-transparent', 'text-slate-500');
            });

            // 모든 탭 컨텐츠 숨기기
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.add('hidden');
            });

            // 선택된 탭 활성화
            document.getElementById('tab-' + tabName).classList.remove('border-transparent', 'text-slate-500');
            document.getElementById('tab-' + tabName).classList.add('border-sky-500', 'text-sky-600');

            // 선택된 컨텐츠 표시
            document.getElementById('content-' + tabName).classList.remove('hidden');
        }

        function useCoupon(couponId) {
            if (confirm('이 쿠폰을 사용하시겠습니까? 사용 후에는 되돌릴 수 없습니다.')) {
                // 쿠폰 사용 요청
                fetch('${pageContext.request.contextPath}/mypage/coupons/use', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'couponId=' + couponId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('쿠폰이 사용되었습니다.');
                        location.reload();
                    } else {
                        alert('쿠폰 사용 중 오류가 발생했습니다: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('쿠폰 사용 중 오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>