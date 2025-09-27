<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${storage.name} - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-2px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl fade-in">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/wishlist" 
                           class="text-slate-600 hover:text-blue-600 p-2 rounded-lg hover:bg-white/50">
                            ← 돌아가기
                        </a>
                        <div>
                            <h1 class="text-4xl font-bold gradient-text">${storage.name}</h1>
                            <p class="text-slate-600 mt-1">
                                📁 ${fn:length(storageItems)}개의 아이템이 저장되어 있습니다
                            </p>
                        </div>
                    </div>
                    <div class="flex space-x-3">
                        <button data-storage-id="${storage.storageId}" 
                                data-storage-name="${storage.name}" 
                                data-storage-color="${storage.colorClass}"
                                class="edit-storage-btn text-slate-600 hover:text-blue-600 p-3 rounded-xl hover:bg-white/50">
                            ✏️ 폴더 수정
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- 아이템 목록 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <c:choose>
                    <c:when test="${not empty storageItems}">
                        <!-- 필터 탭 -->
                        <div class="flex space-x-4 mb-6">
                            <button onclick="filterItems('ALL')" class="filter-btn active px-4 py-2 rounded-lg font-medium transition-colors">
                                전체 (${fn:length(storageItems)})
                            </button>
                            <button onclick="filterItems('RESTAURANT')" class="filter-btn px-4 py-2 rounded-lg font-medium transition-colors">
                                음식점 (<span id="restaurant-count">0</span>)
                            </button>
                            <button onclick="filterItems('COURSE')" class="filter-btn px-4 py-2 rounded-lg font-medium transition-colors">
                                코스 (<span id="course-count">0</span>)
                            </button>
                            <button onclick="filterItems('COLUMN')" class="filter-btn px-4 py-2 rounded-lg font-medium transition-colors">
                                칼럼 (<span id="column-count">0</span>)
                            </button>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" id="items-container">
                            <c:forEach var="item" items="${storageItems}">
                                <div class="item-card card-hover rounded-2xl overflow-hidden bg-white shadow-lg" data-type="${item.itemType}">
                                    <!-- 아이템 이미지 -->
                                    <div class="relative h-48 overflow-hidden">
                                        <c:choose>
                                            <c:when test="${not empty item.imageUrl}">
                                                <mytag:image fileName="${item.imageUrl}" altText="${item.title}" cssClass="w-full h-full object-cover" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-full bg-gradient-to-br from-slate-200 to-slate-300 flex items-center justify-center">
                                                    <c:choose>
                                                        <c:when test="${item.itemType == 'RESTAURANT'}">🍽️</c:when>
                                                        <c:when test="${item.itemType == 'COURSE'}">🗺️</c:when>
                                                        <c:when test="${item.itemType == 'COLUMN'}">📰</c:when>
                                                        <c:otherwise>📄</c:otherwise>
                                                    </c:choose>
                                                    <span class="text-4xl"></span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- 타입 배지 -->
                                        <div class="absolute top-3 left-3">
                                            <span class="px-3 py-1 rounded-full text-xs font-semibold text-white
                                                <c:choose>
                                                    <c:when test="${item.itemType == 'RESTAURANT'}">bg-orange-500</c:when>
                                                    <c:when test="${item.itemType == 'COURSE'}">bg-green-500</c:when>
                                                    <c:when test="${item.itemType == 'COLUMN'}">bg-purple-500</c:when>
                                                    <c:otherwise>bg-gray-500</c:otherwise>
                                                </c:choose>">
                                                <c:choose>
                                                    <c:when test="${item.itemType == 'RESTAURANT'}">맛집</c:when>
                                                    <c:when test="${item.itemType == 'COURSE'}">코스</c:when>
                                                    <c:when test="${item.itemType == 'COLUMN'}">칼럼</c:when>
                                                    <c:otherwise>${item.itemType}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        
                                        <!-- 삭제 버튼 -->
                                        <button data-storage-id="${storage.storageId}" 
                                                data-item-type="${item.itemType}" 
                                                data-content-id="${item.contentId}"
                                                class="remove-item-btn absolute top-3 right-3 w-8 h-8 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors">
                                            ×
                                        </button>
                                    </div>
                                    
                                    <!-- 아이템 정보 -->
                                    <div class="p-6">
                                        <h3 class="text-lg font-bold text-slate-800 mb-2 line-clamp-2">${item.title}</h3>

                                        <c:if test="${not empty item.description}">
                                            <p class="text-slate-600 text-sm mb-3 line-clamp-2">
                                                ${item.description}
                                            </p>
                                        </c:if>

                                        <!-- 추가 정보 -->
                                        <div class="flex justify-between items-center text-sm text-slate-500 mb-4">
                                            <c:if test="${not empty item.authorName}">
                                                <span>👤 ${item.authorName}</span>
                                            </c:if>
                                            <c:if test="${not empty item.additionalInfo}">
                                                <span>${item.additionalInfo}</span>
                                            </c:if>
                                            <c:if test="${not empty item.createdAt}">
                                                <span class="ml-auto">
                                                    ${item.createdAt.toString().substring(0, 10)}
                                                </span>
                                            </c:if>
                                        </div>

                                        <!-- 바로가기 버튼 -->
                                        <c:choose>
                                            <c:when test="${item.itemType == 'RESTAURANT'}">
                                                <a href="${pageContext.request.contextPath}${item.linkUrl}"
                                                   class="block w-full bg-orange-100 hover:bg-orange-200 text-orange-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                                    맛집 보기
                                                </a>
                                            </c:when>
                                            <c:when test="${item.itemType == 'COURSE'}">
                                                <a href="${pageContext.request.contextPath}${item.linkUrl}"
                                                   class="block w-full bg-green-100 hover:bg-green-200 text-green-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                                    코스 보기
                                                </a>
                                            </c:when>
                                            <c:when test="${item.itemType == 'COLUMN'}">
                                                <a href="${pageContext.request.contextPath}${item.linkUrl}"
                                                   class="block w-full bg-purple-100 hover:bg-purple-200 text-purple-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                                    칼럼 보기
                                                </a>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">📂</div>
                            <h3 class="text-xl font-bold text-slate-800 mb-2">아직 저장된 아이템이 없습니다</h3>
                            <p class="text-slate-600 mb-6">맛집, 코스, 칼럼을 찾아서 이 폴더에 저장해보세요!</p>
                            <div class="flex justify-center space-x-4">
                                <a href="${pageContext.request.contextPath}/restaurant/list" 
                                   class="bg-orange-100 hover:bg-orange-200 text-orange-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                    맛집 찾기
                                </a>
                                <a href="${pageContext.request.contextPath}/course/list" 
                                   class="bg-green-100 hover:bg-green-200 text-green-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                    코스 찾기
                                </a>
                                <a href="${pageContext.request.contextPath}/column/list" 
                                   class="bg-purple-100 hover:bg-purple-200 text-purple-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                    칼럼 보기
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <!-- 폴더 수정 모달 -->
    <div id="storageModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="glass-card p-8 rounded-3xl w-full max-w-md mx-4">
            <h3 class="text-2xl font-bold gradient-text mb-6">폴더 수정</h3>
            
            <form id="storageForm">
                <input type="hidden" id="storageId" name="storageId">
                <input type="hidden" name="action" value="updateStorage">
                
                <div class="mb-6">
                    <label for="storageName" class="block text-sm font-medium text-slate-700 mb-2">폴더 이름</label>
                    <input type="text" id="storageName" name="name" 
                           class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="폴더 이름을 입력하세요" maxlength="50" required>
                </div>
                
                <div class="mb-6">
                    <label class="block text-sm font-medium text-slate-700 mb-3">폴더 색상</label>
                    <div class="grid grid-cols-4 gap-3">
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-blue-100" class="sr-only">
                            <div class="w-12 h-12 bg-blue-100 rounded-lg border-2 border-transparent hover:border-blue-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-green-100" class="sr-only">
                            <div class="w-12 h-12 bg-green-100 rounded-lg border-2 border-transparent hover:border-green-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-purple-100" class="sr-only">
                            <div class="w-12 h-12 bg-purple-100 rounded-lg border-2 border-transparent hover:border-purple-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-pink-100" class="sr-only">
                            <div class="w-12 h-12 bg-pink-100 rounded-lg border-2 border-transparent hover:border-pink-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-yellow-100" class="sr-only">
                            <div class="w-12 h-12 bg-yellow-100 rounded-lg border-2 border-transparent hover:border-yellow-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-orange-100" class="sr-only">
                            <div class="w-12 h-12 bg-orange-100 rounded-lg border-2 border-transparent hover:border-orange-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-red-100" class="sr-only">
                            <div class="w-12 h-12 bg-red-100 rounded-lg border-2 border-transparent hover:border-red-500 transition-colors"></div>
                        </label>
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-gray-100" class="sr-only">
                            <div class="w-12 h-12 bg-gray-100 rounded-lg border-2 border-transparent hover:border-gray-500 transition-colors"></div>
                        </label>
                    </div>
                </div>
                
                <div class="flex space-x-4">
                    <button type="button" onclick="closeStorageModal()" 
                            class="flex-1 bg-slate-200 text-slate-700 py-3 px-4 rounded-xl font-semibold hover:bg-slate-300 transition-colors">
                        취소
                    </button>
                    <button type="submit" 
                            class="flex-1 btn-primary text-white py-3 px-4 rounded-xl font-semibold">
                        수정하기
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        let currentFilter = 'ALL';
        
        // 페이지 로드 시 카운트 계산 및 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
            updateItemCounts();
            updateColorSelection();
            
            // 폴더 수정 버튼 이벤트 리스너
            document.querySelectorAll('.edit-storage-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const storageId = this.getAttribute('data-storage-id');
                    const name = this.getAttribute('data-storage-name');
                    const colorClass = this.getAttribute('data-storage-color');
                    editStorage(storageId, name, colorClass);
                });
            });
            
            // 아이템 삭제 버튼 이벤트 리스너
            document.querySelectorAll('.remove-item-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const storageId = this.getAttribute('data-storage-id');
                    const itemType = this.getAttribute('data-item-type');
                    const contentId = this.getAttribute('data-content-id');
                    removeFromStorage(storageId, itemType, contentId);
                });
            });
        });
        
        function updateItemCounts() {
            const items = document.querySelectorAll('.item-card');
            let restaurantCount = 0, courseCount = 0, columnCount = 0;
            
            items.forEach(item => {
                const type = item.dataset.type;
                if (type === 'RESTAURANT') restaurantCount++;
                else if (type === 'COURSE') courseCount++;
                else if (type === 'COLUMN') columnCount++;
            });
            
            document.getElementById('restaurant-count').textContent = restaurantCount;
            document.getElementById('course-count').textContent = courseCount;
            document.getElementById('column-count').textContent = columnCount;
        }
        
        function filterItems(type) {
            currentFilter = type;
            const items = document.querySelectorAll('.item-card');
            const buttons = document.querySelectorAll('.filter-btn');
            
            // 버튼 활성화 상태 업데이트
            buttons.forEach(btn => btn.classList.remove('active', 'bg-blue-100', 'text-blue-700'));
            event.target.classList.add('active', 'bg-blue-100', 'text-blue-700');
            
            // 아이템 필터링
            items.forEach(item => {
                if (type === 'ALL' || item.dataset.type === type) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        function editStorage(storageId, name, colorClass) {
            document.getElementById('storageId').value = storageId;
            document.getElementById('storageName').value = name;
            document.querySelector('input[name="colorClass"][value="' + colorClass + '"]').checked = true;
            updateColorSelection();
            document.getElementById('storageModal').classList.remove('hidden');
            document.getElementById('storageModal').classList.add('flex');
        }
        
        function closeStorageModal() {
            document.getElementById('storageModal').classList.add('hidden');
            document.getElementById('storageModal').classList.remove('flex');
        }
        
        function removeFromStorage(storageId, itemType, contentId) {
            if (confirm('이 아이템을 폴더에서 제거하시겠습니까?')) {
                const params = new URLSearchParams();
                params.append('action', 'removeItem');
                params.append('storageId', storageId);
                params.append('itemType', itemType);
                params.append('contentId', contentId);

                fetch('${pageContext.request.contextPath}/wishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: params.toString()
                })
                .then(async response => {
                    let data = null;
                    try {
                        data = await response.json();
                    } catch (err) {
                        console.error('JSON 파싱 실패:', err);
                    }

                    if (response.ok && data && data.success) {
                        window.location.reload();
                    } else {
                        alert((data && data.message) || '아이템 제거에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function updateColorSelection() {
            document.querySelectorAll('input[name="colorClass"]').forEach(radio => {
                const div = radio.nextElementSibling;
                if (radio.checked) {
                    div.classList.add('border-blue-500', 'ring-2', 'ring-blue-200');
                } else {
                    div.classList.remove('border-blue-500', 'ring-2', 'ring-blue-200');
                }
            });
        }
        
        // 폼 제출 처리
        document.getElementById('storageForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const params = new URLSearchParams();
            formData.forEach((value, key) => {
                params.append(key, value);
            });
            
            fetch('${pageContext.request.contextPath}/wishlist', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params.toString()
            }).then(async response => {
                let data = null;
                try {
                    data = await response.json();
                } catch (err) {
                    console.error('JSON 파싱 실패:', err);
                }

                if (response.ok && data && data.success) {
                    window.location.reload();
                } else {
                    alert((data && data.message) || '오류가 발생했습니다.');
                }
            }).catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        });
        
        // 색상 선택 이벤트 리스너
        document.querySelectorAll('input[name="colorClass"]').forEach(radio => {
            radio.addEventListener('change', updateColorSelection);
        });
        
        // 모달 외부 클릭 시 닫기
        document.getElementById('storageModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeStorageModal();
            }
        });
        
        // 필터 버튼 초기 설정
        document.querySelector('.filter-btn').classList.add('bg-blue-100', 'text-blue-700');
    </script>
</body>
</html>
