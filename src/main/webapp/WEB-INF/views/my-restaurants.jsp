<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<<<<<<< HEAD
=======
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 음식점 관리 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
<<<<<<< HEAD
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
=======
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
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
<<<<<<< HEAD
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl">
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-4xl font-bold gradient-text mb-2">내 음식점 관리</h1>
                        <p class="text-slate-600">등록된 음식점을 관리하고 운영 현황을 확인하세요</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/business/restaurants/add" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                        + 새 음식점 등록
                    </a>
                </div>
            </div>
            
            <!-- 음식점 목록 -->
=======
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">내 음식점 관리</h1>
                <a href="/restaurant/add" class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                    ➕ 새 음식점 등록
                </a>
            </div>
            
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
            <c:choose>
                <c:when test="${not empty myRestaurants}">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="restaurant" items="${myRestaurants}">
                            <div class="glass-card p-6 rounded-2xl card-hover">
<<<<<<< HEAD
                                <div class="flex items-start justify-between mb-4">
                                    <div class="flex-1">
                                        <h3 class="text-xl font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                        <p class="text-slate-600 text-sm mb-2">${restaurant.category} • ${restaurant.location}</p>
                                        <p class="text-slate-500 text-sm">${restaurant.address}</p>
                                    </div>
                                    <div class="flex items-center space-x-1 ml-4">
                                        <span class="text-yellow-400 text-lg">★</span>
                                        <span class="text-slate-700 font-semibold">${restaurant.rating}</span>
=======
                                <div class="relative mb-4">
                                    <img src="${not empty restaurant.image ? restaurant.image : 'https://placehold.co/400x200/3b82f6/ffffff?text=음식점+이미지'}" 
                                         alt="${restaurant.name}" class="w-full h-48 object-cover rounded-xl">
                                    <div class="absolute top-3 right-3">
                                        <span class="bg-white/90 text-slate-700 px-3 py-1 rounded-full text-sm font-semibold">
                                            ${restaurant.category}
                                        </span>
                                    </div>
                                </div>
                                
                                <h3 class="text-xl font-bold mb-2 text-slate-800">${restaurant.name}</h3>
                                <p class="text-slate-600 mb-4 flex items-center">
                                    <span class="mr-2">📍</span>
                                    ${restaurant.location}
                                </p>
                                
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center space-x-2">
                                        <div class="flex items-center">
                                            <c:forEach begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${restaurant.rating >= 4.5}">
                                                        <span class="text-yellow-400 text-lg">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 3.5}">
                                                        <span class="text-yellow-400 text-lg">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 2.5}">
                                                        <span class="text-yellow-400 text-lg">★</span>
                                                    </c:when>
                                                    <c:when test="${restaurant.rating >= 1.5}">
                                                        <span class="text-yellow-400 text-lg">★</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-slate-300 text-lg">☆</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <span class="text-slate-600 font-semibold">${restaurant.rating}</span>
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
                                        <span class="text-slate-500 text-sm">(${restaurant.reviewCount})</span>
                                    </div>
                                </div>
                                
<<<<<<< HEAD
                                <c:if test="${not empty restaurant.image}">
                                    <div class="mb-4">
                                        <img src="${pageContext.request.contextPath}/${restaurant.image}" 
                                             alt="${restaurant.name}" 
                                             class="w-full h-32 object-cover rounded-lg">
                                    </div>
                                </c:if>
                                
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}" 
                                       class="flex-1 bg-blue-50 text-blue-600 px-4 py-2 rounded-lg text-center text-sm font-semibold hover:bg-blue-100 transition-colors">
                                        상세보기
                                    </a>
                                    <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus" 
                                       class="flex-1 bg-green-50 text-green-600 px-4 py-2 rounded-lg text-center text-sm font-semibold hover:bg-green-100 transition-colors">
                                        메뉴 관리
                                    </a>
                                    <button onclick="deleteRestaurant(${restaurant.id})" 
                                            class="flex-1 bg-red-50 text-red-600 px-4 py-2 rounded-lg text-center text-sm font-semibold hover:bg-red-100 transition-colors">
                                        삭제
                                    </button>
=======
                                <div class="flex space-x-2">
                                    <a href="/restaurant/detail/${restaurant.id}" 
                                       class="flex-1 btn-secondary text-white py-2 px-4 rounded-xl font-semibold text-center">
                                        상세보기
                                    </a>
                                    <a href="/restaurant/edit/${restaurant.id}" 
                                       class="flex-1 btn-primary text-white py-2 px-4 rounded-xl font-semibold text-center">
                                        수정
                                    </a>
                                </div>
                                
                                <div class="mt-4 pt-4 border-t border-slate-200">
                                    <a href="/restaurant/delete/${restaurant.id}" 
                                       class="w-full btn-danger text-white py-2 px-4 rounded-xl font-semibold text-center block"
                                       onclick="return confirm('정말로 이 음식점을 삭제하시겠습니까?')">
                                        🗑️ 삭제
                                    </a>
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
<<<<<<< HEAD
                    <!-- 음식점이 없을 때 -->
                    <div class="glass-card p-12 rounded-3xl text-center">
                        <div class="text-6xl mb-4">🍽️</div>
                        <h3 class="text-2xl font-bold text-slate-800 mb-4">등록된 음식점이 없습니다</h3>
                        <p class="text-slate-600 mb-8">첫 번째 음식점을 등록하여 MEET LOG에서 홍보해보세요!</p>
                        <a href="${pageContext.request.contextPath}/business/restaurants/add" 
                           class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold text-lg">
                            음식점 등록하기
=======
                    <div class="text-center py-16">
                        <div class="text-8xl mb-6">🍽️</div>
                        <h3 class="text-2xl font-bold text-slate-600 mb-4">등록된 음식점이 없습니다</h3>
                        <p class="text-slate-500 mb-8">첫 번째 음식점을 등록해보세요!</p>
                        <a href="/restaurant/add" 
                           class="btn-primary text-white px-8 py-4 rounded-2xl font-semibold inline-block">
                            ➕ 음식점 등록하기
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
<<<<<<< HEAD
    <script>
        function deleteRestaurant(restaurantId) {
            if (confirm('정말로 이 음식점을 삭제하시겠습니까?')) {
                // 삭제 요청을 보내는 로직 (추후 구현)
                fetch('${pageContext.request.contextPath}/business/restaurants/delete/' + restaurantId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('삭제 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
            }
        }
        
        // 카드 호버 효과
        document.addEventListener('DOMContentLoaded', function() {
=======
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 카드 호버 효과
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
            document.querySelectorAll('.card-hover').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-4px)';
                    this.style.boxShadow = '0 20px 40px rgba(0, 0, 0, 0.15)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.1)';
                });
            });
        });
    </script>
</body>
</html>
