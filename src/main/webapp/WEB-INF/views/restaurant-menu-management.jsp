<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메뉴 관리 - ${restaurant.name} - MEET LOG</title>
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
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-bold gradient-text mb-2">🍽️ 메뉴 관리</h1>
                        <p class="text-slate-600">${restaurant.name}의 메뉴를 관리하세요</p>
                    </div>
                    <button onclick="addMenu()" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                        + 새 메뉴 추가
                    </button>
                </div>
            </div>
            
            <!-- 음식점 정보 카드 -->
            <div class="glass-card p-6 rounded-2xl mb-6">
                <div class="flex items-center space-x-4">
                    <img src="${not empty restaurant.image ? restaurant.image : 'https://placehold.co/80x80/3b82f6/ffffff?text=음식점'}" 
                         alt="${restaurant.name}" class="w-20 h-20 rounded-lg object-cover">
                    <div>
                        <h2 class="text-2xl font-bold text-slate-800">${restaurant.name}</h2>
                        <p class="text-slate-600">${restaurant.category} • ${restaurant.location}</p>
                        <p class="text-slate-500 text-sm">${restaurant.address}</p>
                    </div>
                </div>
            </div>
            
            <!-- 메뉴 목록 -->
            <div class="glass-card p-6 rounded-2xl">
                <h3 class="text-xl font-bold text-slate-800 mb-6">메뉴 목록</h3>
                
                <c:choose>
                    <c:when test="${not empty menus}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="menu" items="${menus}">
                                <div class="border border-slate-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                                    <div class="mb-4">
                                        <img src="${not empty menu.image ? menu.image : 'https://placehold.co/300x200/3b82f6/ffffff?text=메뉴+이미지'}" 
                                             alt="${menu.name}" class="w-full h-32 object-cover rounded-lg">
                                    </div>
                                    
                                    <h4 class="text-lg font-semibold text-slate-800 mb-2">${menu.name}</h4>
                                    <p class="text-slate-600 text-sm mb-2">${menu.description}</p>
                                    <p class="text-lg font-bold text-blue-600 mb-4">
                                        ${menu.price}원
                                    </p>
                                    
                                    <div class="flex space-x-2">
                                        <button onclick="editMenu(${menu.id})" 
                                                class="flex-1 bg-blue-50 text-blue-600 px-3 py-2 rounded-lg text-sm font-semibold hover:bg-blue-100 transition-colors">
                                            수정
                                        </button>
                                        <button onclick="deleteMenu(${menu.id})" 
                                                class="flex-1 bg-red-50 text-red-600 px-3 py-2 rounded-lg text-sm font-semibold hover:bg-red-100 transition-colors">
                                            삭제
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🍽️</div>
                            <h3 class="text-xl font-bold text-slate-600 mb-2">등록된 메뉴가 없습니다</h3>
                            <p class="text-slate-500 mb-6">첫 번째 메뉴를 추가해보세요!</p>
                            <button onclick="addMenu()" class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                                메뉴 추가하기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function addMenu() {
            // 메뉴 추가 로직 (추후 구현)
            alert('메뉴 추가 기능은 추후 구현될 예정입니다.');
        }
        
        function editMenu(menuId) {
            // 메뉴 수정 로직 (추후 구현)
            alert('메뉴 수정 기능은 추후 구현될 예정입니다. (메뉴 ID: ' + menuId + ')');
        }
        
        function deleteMenu(menuId) {
            if (confirm('정말로 이 메뉴를 삭제하시겠습니까?')) {
                // 메뉴 삭제 로직 (추후 구현)
                alert('메뉴 삭제 기능은 추후 구현될 예정입니다. (메뉴 ID: ' + menuId + ')');
            }
        }
    </script>
</body>
</html>
