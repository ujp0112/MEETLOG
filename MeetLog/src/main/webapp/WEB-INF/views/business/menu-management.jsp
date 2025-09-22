<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메뉴 관리 - MEET LOG</title>
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
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">메뉴 관리</h1>
                <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                    ➕ 새 메뉴 추가
                </button>
            </div>
            
            <div class="space-y-6">
                <c:forEach var="restaurant" items="${myRestaurants}">
                    <div class="glass-card p-6 rounded-2xl card-hover">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xl font-bold text-slate-800">${restaurant.name}</h2>
                            <span class="text-slate-500">${restaurant.category}</span>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty restaurant.menuList}">
                                <div class="space-y-3">
                                    <c:forEach var="menu" items="${restaurant.menuList}">
                                        <div class="flex items-center justify-between p-4 bg-slate-50 rounded-xl">
                                            <div class="flex-1">
                                                <h3 class="font-bold text-slate-800">${menu.name}</h3>
                                                <c:if test="${not empty menu.description}">
                                                    <p class="text-slate-600 text-sm mt-1">${menu.description}</p>
                                                </c:if>
                                            </div>
                                            <div class="flex items-center space-x-4">
                                                <span class="text-lg font-bold text-sky-600">
                                                    <fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="₩" />
                                                </span>
                                                <c:if test="${menu.popular}">
                                                    <span class="text-xs bg-red-500 text-white px-2 py-1 rounded-full">인기</span>
                                                </c:if>
                                                <div class="flex space-x-2">
                                                    <button onclick="openEditMenuModal(${menu.id}, '${menu.name}', ${menu.price}, '${menu.description}', ${menu.popular})" 
                                                            class="btn-secondary text-white px-4 py-2 rounded-lg text-sm">수정</button>
                                                    <form method="post" action="${pageContext.request.contextPath}/business/menu/delete" style="display: inline;">
                                                        <input type="hidden" name="menuId" value="${menu.id}">
                                                        <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')" 
                                                                class="btn-danger text-white px-4 py-2 rounded-lg text-sm">삭제</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-8">
                                    <div class="text-4xl mb-4">🍽️</div>
                                    <p class="text-slate-600">등록된 메뉴가 없습니다</p>
                                    <button onclick="openAddMenuModal(${restaurant.id})" 
                                            class="btn-primary text-white px-4 py-2 rounded-lg text-sm mt-4">메뉴 추가</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <!-- 메뉴 추가/수정 모달 -->
    <div id="menuModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-2xl p-8 w-full max-w-md">
                <h3 class="text-2xl font-bold text-slate-800 mb-6" id="modalTitle">새 메뉴 추가</h3>
                
                <form id="menuForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="menuId" name="menuId">
                    <input type="hidden" id="restaurantId" name="restaurantId">
                    
                    <div class="space-y-4">
                        <div>
                            <label for="menuName" class="block text-sm font-medium text-slate-700 mb-2">메뉴 이름</label>
                            <input type="text" id="menuName" name="menuName" required 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>
                        
                        <div>
                            <label for="menuPrice" class="block text-sm font-medium text-slate-700 mb-2">가격 (원)</label>
                            <input type="number" id="menuPrice" name="menuPrice" required 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>
                        
                        <div>
                            <label for="menuDescription" class="block text-sm font-medium text-slate-700 mb-2">설명</label>
                            <textarea id="menuDescription" name="menuDescription" rows="3"
                                      class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"></textarea>
                        </div>
                        
                        <div>
                            <label class="flex items-center">
                                <input type="checkbox" id="menuPopular" name="popular" class="mr-2">
                                <span class="text-sm font-medium text-slate-700">인기 메뉴로 설정</span>
                            </label>
                        </div>
                        
                        <div>
                            <label for="menuImage" class="block text-sm font-medium text-slate-700 mb-2">메뉴 이미지</label>
                            <input type="file" id="menuImage" name="menuImage" accept="image/*"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>
                    </div>
                    
                    <div class="flex justify-end space-x-4 mt-6">
                        <button type="button" onclick="closeMenuModal()" 
                                class="px-6 py-3 bg-slate-200 text-slate-700 rounded-lg hover:bg-slate-300">
                            취소
                        </button>
                        <button type="submit" class="btn-primary text-white px-6 py-3 rounded-lg">
                            저장
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function openAddMenuModal(restaurantId) {
            document.getElementById('modalTitle').textContent = '새 메뉴 추가';
            document.getElementById('menuForm').action = '${pageContext.request.contextPath}/business/menu/add';
            document.getElementById('menuForm').reset();
            document.getElementById('restaurantId').value = restaurantId;
            document.getElementById('menuModal').classList.remove('hidden');
        }
        
        function openEditMenuModal(menuId, name, price, description, popular) {
            document.getElementById('modalTitle').textContent = '메뉴 수정';
            document.getElementById('menuForm').action = '${pageContext.request.contextPath}/business/menu/update';
            document.getElementById('menuId').value = menuId;
            document.getElementById('menuName').value = name;
            document.getElementById('menuPrice').value = price;
            document.getElementById('menuDescription').value = description || '';
            document.getElementById('menuPopular').checked = popular;
            document.getElementById('menuModal').classList.remove('hidden');
        }
        
        function closeMenuModal() {
            document.getElementById('menuModal').classList.add('hidden');
        }
        
        // 모달 외부 클릭 시 닫기
        document.getElementById('menuModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeMenuModal();
            }
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            // 카드 호버 효과
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
