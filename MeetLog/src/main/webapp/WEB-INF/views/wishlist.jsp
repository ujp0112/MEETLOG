<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내가 찜한 목록 - MEET LOG</title>
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
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-4xl font-bold gradient-text mb-2">내가 찜한 목록</h1>
                        <p class="text-slate-600">나만의 찜 폴더로 맛집, 코스, 칼럼을 정리해보세요</p>
                    </div>
                    <button onclick="openCreateStorageModal()" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                        📁 새 폴더 만들기
                    </button>
                </div>
            </div>
            
            <!-- 저장소 목록 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6">내 찜 폴더</h2>
                
                <c:choose>
                    <c:when test="${not empty storages}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="storage" items="${storages}">
                                <div class="card-hover rounded-2xl p-6 ${storage.colorClass} border border-white/20">
                                    <div class="flex justify-between items-start mb-4">
                                        <div class="flex-1">
                                            <h3 class="text-xl font-bold text-slate-800 mb-2">${storage.name}</h3>
                                            <p class="text-slate-600 text-sm">
                                                <span class="inline-flex items-center">
                                                    📁 ${storage.itemCount}개 아이템
                                                </span>
                                            </p>
                                        </div>
                                        <div class="flex space-x-2">
                                            <button data-storage-id="${storage.storageId}" 
                                                    data-storage-name="${storage.name}" 
                                                    data-storage-color="${storage.colorClass}"
                                                    class="edit-storage-btn text-slate-600 hover:text-blue-600 p-2 rounded-lg hover:bg-white/50">
                                                ✏️
                                            </button>
                                            <c:if test="${storage.itemCount == 0}">
                                                <button data-storage-id="${storage.storageId}"
                                                        class="delete-storage-btn text-slate-600 hover:text-red-600 p-2 rounded-lg hover:bg-white/50">
                                                    🗑️
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <a href="${pageContext.request.contextPath}/wishlist/storage/${storage.storageId}" 
                                       class="block w-full bg-white/30 hover:bg-white/50 text-slate-800 text-center py-3 px-4 rounded-xl font-semibold transition-colors">
                                        폴더 열기
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">📁</div>
                            <h3 class="text-xl font-bold text-slate-800 mb-2">아직 찜 폴더가 없습니다</h3>
                            <p class="text-slate-600 mb-6">새 폴더를 만들어서 좋아하는 콘텐츠를 정리해보세요!</p>
                            <button onclick="openCreateStorageModal()" class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                                첫 번째 폴더 만들기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <!-- 폴더 생성/수정 모달 -->
    <div id="storageModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="glass-card p-8 rounded-3xl w-full max-w-md mx-4">
            <h3 id="modalTitle" class="text-2xl font-bold gradient-text mb-6">새 폴더 만들기</h3>
            
            <form id="storageForm">
                <input type="hidden" id="storageId" name="storageId">
                <input type="hidden" id="action" name="action" value="createStorage">
                
                <div class="mb-6">
                    <label for="storageName" class="block text-sm font-medium text-slate-700 mb-2">폴더 이름</label>
                    <input type="text" id="storageName" name="name" 
                           class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="예: 가고싶은 맛집" maxlength="50" required>
                </div>
                
                <div class="mb-6">
                    <label class="block text-sm font-medium text-slate-700 mb-3">폴더 색상</label>
                    <div class="grid grid-cols-4 gap-3">
                        <label class="cursor-pointer">
                            <input type="radio" name="colorClass" value="bg-blue-100" class="sr-only" checked>
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
                        <span id="submitText">폴더 만들기</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function openCreateStorageModal() {
            document.getElementById('modalTitle').textContent = '새 폴더 만들기';
            document.getElementById('submitText').textContent = '폴더 만들기';
            document.getElementById('action').value = 'createStorage';
            document.getElementById('storageId').value = '';
            document.getElementById('storageName').value = '';
            document.querySelector('input[name="colorClass"][value="bg-blue-100"]').checked = true;
            updateColorSelection();
            document.getElementById('storageModal').classList.remove('hidden');
            document.getElementById('storageModal').classList.add('flex');
        }
        
        function editStorage(storageId, name, colorClass) {
            document.getElementById('modalTitle').textContent = '폴더 수정';
            document.getElementById('submitText').textContent = '수정하기';
            document.getElementById('action').value = 'updateStorage';
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
        
        function deleteStorage(storageId) {
            if (confirm('정말로 이 폴더를 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/wishlist';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteStorage';
                
                const storageIdInput = document.createElement('input');
                storageIdInput.type = 'hidden';
                storageIdInput.name = 'storageId';
                storageIdInput.value = storageId;
                
                form.appendChild(actionInput);
                form.appendChild(storageIdInput);
                document.body.appendChild(form);
                form.submit();
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
        
        // 초기 색상 선택 표시 및 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
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
            
            // 폴더 삭제 버튼 이벤트 리스너
            document.querySelectorAll('.delete-storage-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const storageId = this.getAttribute('data-storage-id');
                    deleteStorage(storageId);
                });
            });
        });
    </script>
</body>
</html>
