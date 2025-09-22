<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 관리 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-secondary { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .rating-stars { filter: drop-shadow(0 2px 4px rgba(251, 191, 36, 0.3)); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">리뷰 관리</h1>
                <div class="flex space-x-4">
                    <select class="px-4 py-2 border-2 border-slate-200 rounded-xl focus:border-blue-500 focus:outline-none">
                        <option>전체</option>
                        <option>5점</option>
                        <option>4점</option>
                        <option>3점</option>
                        <option>2점</option>
                        <option>1점</option>
                    </select>
                    <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                        📊 리뷰 통계
                    </button>
                </div>
            </div>
            
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="review" items="${reviews}">
                            <div class="glass-card p-6 rounded-2xl card-hover">
                                <div class="flex justify-between items-start mb-4">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                            ${review.author.charAt(0)}
                                        </div>
                                        <div>
                                            <h3 class="font-bold text-slate-800">${review.author}</h3>
                                            <p class="text-slate-600 text-sm">${review.restaurantName}</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <div class="flex items-center space-x-2 mb-2">
                                            <div class="rating-stars flex space-x-1">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <span class="text-yellow-400 text-lg">★</span>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <span class="text-slate-300 text-lg">☆</span>
                                                </c:forEach>
                                            </div>
                                            <span class="text-slate-700 font-semibold">${review.rating}</span>
                                        </div>
                                        <p class="text-slate-500 text-sm">${review.createdAt}</p>
                                    </div>
                                </div>
                                
                                <p class="text-slate-700 leading-relaxed mb-4">${review.content}</p>
                                
                                <!-- 상세 평점 표시 -->
                                <c:if test="${review.tasteRating > 0}">
                                    <div class="p-4 bg-slate-50 rounded-xl mb-4">
                                        <h5 class="text-sm font-semibold text-slate-700 mb-3">상세 평점</h5>
                                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">맛:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.tasteRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.tasteRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">서비스:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.serviceRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.serviceRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">분위기:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.atmosphereRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.atmosphereRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-slate-600">가격:</span>
                                                <div class="flex space-x-1">
                                                    <c:forEach begin="1" end="${review.priceRating}">
                                                        <span class="text-yellow-400">★</span>
                                                    </c:forEach>
                                                    <c:forEach begin="${review.priceRating + 1}" end="5">
                                                        <span class="text-slate-300">☆</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- 답글 작성 폼 -->
                                <div class="mt-4">
                                    <form method="post" action="${pageContext.request.contextPath}/business/review/add-reply" class="flex space-x-2">
                                        <input type="hidden" name="reviewId" value="${review.id}">
                                        <input type="text" name="content" placeholder="리뷰에 답글을 작성하세요..." 
                                               class="flex-1 px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                        <button type="submit" class="btn-secondary text-white px-6 py-2 rounded-lg">
                                            답글 작성
                                        </button>
                                    </form>
                                </div>
                                
                                <div class="flex items-center justify-between mt-4">
                                    <div class="flex items-center space-x-4">
                                        <button class="text-sky-600 hover:text-sky-700 text-sm font-semibold flex items-center space-x-1">
                                            <span>❤️</span>
                                            <span>${review.likes}</span>
                                        </button>
                                    </div>
                                    <div class="flex space-x-2">
                                        <c:if test="${review.rating <= 2}">
                                            <button class="btn-danger text-white px-4 py-2 rounded-lg text-sm">신고</button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">⭐</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">리뷰가 없습니다</h3>
                            <p class="text-slate-500">아직 리뷰가 없습니다. 음식점을 홍보해보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 필터링 기능
        document.querySelector('select').addEventListener('change', function() {
            const selectedRating = this.value;
            const reviewCards = document.querySelectorAll('.glass-card');
            
            reviewCards.forEach(card => {
                if (selectedRating === '전체') {
                    card.style.display = 'block';
                } else {
                    const rating = card.querySelector('.rating-stars').children.length;
                    if (rating.toString() === selectedRating) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                }
            });
        });
        
        // 답글 작성 폼 제출
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const content = this.querySelector('input[name="content"]').value;
                if (content.trim() === '') {
                    alert('답글 내용을 입력해주세요.');
                    return;
                }
                // 실제 답글 작성 로직은 서버에서 처리
                alert('답글이 작성되었습니다.');
                this.querySelector('input[name="content"]').value = '';
            });
        });
    </script>
</body>
</html>