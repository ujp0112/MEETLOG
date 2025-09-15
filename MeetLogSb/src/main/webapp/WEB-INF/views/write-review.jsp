<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 리뷰 작성</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-2xl mx-auto">
                    <div class="mb-6">
                        <h2 class="text-2xl md:text-3xl font-bold mb-2">리뷰 작성</h2>
                        <p class="text-slate-600">맛집에 대한 솔직한 리뷰를 작성해주세요.</p>
                    </div>

                    <c:choose>
                        <%-- Check 1: Is user logged in? --%>
                        <c:when test="${not empty sessionScope.user}">
                            <c:choose>
                                <%-- Check 2: Is restaurant data available? --%>
                                <c:when test="${not empty restaurant}">
                                    <div class="bg-white p-6 rounded-xl shadow-lg">
                                        <div class="mb-6 p-4 bg-slate-50 rounded-lg">
                                            <h3 class="text-lg font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                            <p class="text-slate-600 text-sm">${restaurant.category} • ${restaurant.location}</p>
                                        </div>

                                        <c:if test="${not empty errorMessage}">
                                            <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
                                                ${errorMessage}
                                            </div>
                                        </c:if>

                                        <form "${pageContext.request.contextPath}.do/review" method="post" class="space-y-6">
                                            <input type="hidden" name="action" value="create">
                                            <input type="hidden" name="restaurantId" value="${restaurant.id}">
                                            <input type="hidden" name="userId" value="${sessionScope.user.id}">
                                            <input type="hidden" name="author" value="${sessionScope.user.nickname}">

                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-3">평점</label>
                                                <div class="flex items-center space-x-2" id="rating-container">
                                                    <input type="hidden" name="rating" id="rating" value="5" required>
                                                    <button type="button" class="text-3xl text-yellow-400 hover:text-yellow-500 rating-star" data-rating="1">★</button>
                                                    <button type="button" class="text-3xl text-yellow-400 hover:text-yellow-500 rating-star" data-rating="2">★</button>
                                                    <button type="button" class="text-3xl text-yellow-400 hover:text-yellow-500 rating-star" data-rating="3">★</button>
                                                    <button type="button" class="text-3xl text-yellow-400 hover:text-yellow-500 rating-star" data-rating="4">★</button>
                                                    <button type="button" class="text-3xl text-yellow-400 hover:text-yellow-500 rating-star" data-rating="5">★</button>
                                                    <span class="ml-2 text-slate-600" id="rating-text">5점</span>
                                                </div>
                                            </div>

                                            <div>
                                                <label for="content" class="block text-sm font-medium text-slate-700 mb-2">리뷰 내용</label>
                                                <textarea id="content" name="content" rows="6" required
                                                          class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500"
                                                          placeholder="맛집에 대한 솔직한 리뷰를 작성해주세요. 음식의 맛, 서비스, 분위기 등에 대해 자유롭게 작성하세요."></textarea>
                                                <p class="text-sm text-slate-500 mt-1">최소 10자 이상 작성해주세요.</p>
                                            </div>

                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">영수증 인증 (선택사항)</label>
                                                <div class="border-2 border-dashed border-slate-300 rounded-lg p-6 text-center">
                                                    <div class="text-4xl mb-2">🧾</div>
                                                    <p class="text-slate-600 mb-2">영수증을 업로드하면 더 신뢰할 수 있는 리뷰가 됩니다.</p>
                                                    <input type="file" accept="image/*" class="hidden" id="receipt-upload">
                                                    <button type="button" onclick="document.getElementById('receipt-upload').click()" 
                                                            class="text-sky-600 hover:text-sky-700 text-sm font-medium">
                                                        영수증 업로드
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="flex justify-end space-x-3">
                                                <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}" 
                                                   class="px-6 py-2 border border-slate-300 rounded-md text-slate-700 hover:bg-slate-50">
                                                    취소
                                                </a>
                                                <button type="submit" class="px-6 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700">
                                                    리뷰 작성
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-12">
                                        <div class="text-6xl mb-4">❌</div>
                                        <h3 class="text-xl font-bold text-slate-800 mb-2">맛집 정보를 찾을 수 없습니다</h3>
                                        <p class="text-slate-600 mb-6">잘못된 맛집 정보입니다.</p>
                                        <a href="${pageContext.request.contextPath}/main" 
                                           class="inline-block bg-sky-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-sky-700">
                                            메인으로 돌아가기
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12">
                                <div class="text-6xl mb-4">🔒</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                                <p class="text-slate-600 mb-6">리뷰를 작성하려면 로그인해주세요.</p>
                                <a href="${pageContext.request.contextPath}/login" 
                                   class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                    로그인하기
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        
        <%-- Replaced inline footer with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        // This client-side script remains the same as it contains no JSP code.
        document.addEventListener('DOMContentLoaded', function() {
            const ratingStars = document.querySelectorAll('.rating-star');
            const ratingInput = document.getElementById('rating');
            const ratingText = document.getElementById('rating-text');

            ratingStars.forEach((star, index) => {
                star.addEventListener('click', () => {
                    const rating = index + 1;
                    ratingInput.value = rating;
                    ratingText.textContent = rating + '점';
                    
                    ratingStars.forEach((s, i) => {
                        s.classList.toggle('text-yellow-400', i < rating);
                        s.classList.toggle('text-gray-300', i >= rating);
                    });
                });

                star.addEventListener('mouseenter', () => {
                    const rating = index + 1;
                    ratingStars.forEach((s, i) => {
                        s.classList.toggle('text-yellow-400', i < rating);
                        s.classList.toggle('text-gray-300', i >= rating);
                    });
                });
            });

            // Form validation on submit
            document.querySelector('form').addEventListener('submit', function(e) {
                const content = document.getElementById('content').value.trim();
                if (content.length < 10) {
                    e.preventDefault();
                    alert('리뷰 내용을 10자 이상 작성해주세요.');
                    return false;
                }
            });
        });
    </script>
</body>
</html>