<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 새 가게 등록</title>
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
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="max-w-4xl mx-auto">
            <div class="glass-card p-8 rounded-3xl fade-in">
                <h1 class="text-4xl font-bold gradient-text mb-6 text-center">새 가게 등록</h1>
                <p class="text-slate-600 text-center mb-8">음식점 정보를 입력하여 MEET LOG에 등록하세요</p>
                
                <form action="${pageContext.request.contextPath}/restaurant/add" method="post" enctype="multipart/form-data" class="space-y-8">
            
                    <c:if test="${not empty errorMessage}">
                        <div class="bg-red-100 text-red-700 p-4 rounded-lg border border-red-200">
                            <div class="flex items-center">
                                <span class="text-red-500 mr-2">⚠️</span>
                                <span>${errorMessage}</span>
                            </div>
                        </div>
                    </c:if>

                    <!-- 기본 정보 섹션 -->
                    <div class="space-y-6">
                        <h2 class="text-2xl font-bold text-slate-800 border-b border-slate-200 pb-2">기본 정보</h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="name" class="block text-sm font-medium text-slate-700 mb-2">가게 이름 *</label>
                                <input type="text" id="name" name="name" required 
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                       placeholder="예: 고미정">
                            </div>
                            
                            <div>
                                <label for="category" class="block text-sm font-medium text-slate-700 mb-2">카테고리 *</label>
                                <select id="category" name="category" required 
                                        class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all">
                                    <option value="">카테고리를 선택하세요</option>
                                    <option value="한식">한식</option>
                                    <option value="중식">중식</option>
                                    <option value="일식">일식</option>
                                    <option value="양식">양식</option>
                                    <option value="카페">카페</option>
                                    <option value="디저트">디저트</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="location" class="block text-sm font-medium text-slate-700 mb-2">지역 *</label>
                                <input type="text" id="location" name="location" required 
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                       placeholder="예: 강남구, 홍대">
                            </div>
                            
                            <div>
                                <label for="phone" class="block text-sm font-medium text-slate-700 mb-2">전화번호</label>
                                <input type="tel" id="phone" name="phone" 
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                       placeholder="예: 02-1234-5678">
                            </div>
                        </div>
                        
                        <div>
                            <label for="address" class="block text-sm font-medium text-slate-700 mb-2">상세 주소 *</label>
                            <input type="text" id="address" name="address" required 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                   placeholder="예: 서울시 강남구 테헤란로 123">
                        </div>
                    </div>

                    <!-- 영업 정보 섹션 -->
                    <div class="space-y-6">
                        <h2 class="text-2xl font-bold text-slate-800 border-b border-slate-200 pb-2">영업 정보</h2>
                        
                        <div>
                            <label for="hours" class="block text-sm font-medium text-slate-700 mb-2">영업 시간</label>
                            <input type="text" id="hours" name="hours" 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                   placeholder="예: 매일 11:00 - 22:00 (브레이크타임 15:00-17:00)">
                        </div>
                        
                        <div>
                            <label for="description" class="block text-sm font-medium text-slate-700 mb-2">가게 설명</label>
                            <textarea id="description" name="description" rows="4" 
                                      class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all resize-none"
                                      placeholder="가게의 특징이나 추천 메뉴를 소개해주세요"></textarea>
                        </div>
                    </div>

                    <!-- 이미지 업로드 섹션 -->
                    <div class="space-y-6">
                        <h2 class="text-2xl font-bold text-slate-800 border-b border-slate-200 pb-2">이미지</h2>
                        
                        <div>
                            <label for="image" class="block text-sm font-medium text-slate-700 mb-2">가게 이미지</label>
                            <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-dashed border-slate-300 rounded-lg hover:border-slate-400 transition-colors">
                                <div class="space-y-1 text-center">
                                    <svg class="mx-auto h-12 w-12 text-slate-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                                        <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <div class="flex text-sm text-slate-600">
                                        <label for="image" class="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-blue-500">
                                            <span>이미지 업로드</span>
                                            <input id="image" name="image" type="file" accept="image/*" class="sr-only">
                                        </label>
                                        <p class="pl-1">또는 드래그 앤 드롭</p>
                                    </div>
                                    <p class="text-xs text-slate-500">PNG, JPG, GIF 최대 10MB</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 제출 버튼 -->
                    <div class="flex justify-center space-x-4 pt-8">
                        <a href="${pageContext.request.contextPath}/restaurant/my" 
                           class="btn-secondary text-white px-8 py-3 rounded-xl font-semibold">
                            취소
                        </a>
                        <button type="submit" 
                                class="btn-primary text-white px-8 py-3 rounded-xl font-semibold">
                            가게 등록
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 폼 검증
        document.getElementById('name').addEventListener('input', function() {
            if (this.value.length < 2) {
                this.setCustomValidity('가게 이름은 2글자 이상 입력해주세요.');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // 전화번호 형식 검증
        document.getElementById('phone').addEventListener('input', function() {
            const phoneRegex = /^[0-9-+().\s]+$/;
            if (this.value && !phoneRegex.test(this.value)) {
                this.setCustomValidity('올바른 전화번호 형식을 입력해주세요.');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // 이미지 미리보기
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const uploadArea = document.querySelector('.border-dashed');
                    uploadArea.innerHTML = `
                        <div class="text-center">
                            <img src="${e.target.result}" alt="미리보기" class="mx-auto h-32 w-32 object-cover rounded-lg">
                            <p class="mt-2 text-sm text-slate-600">${file.name}</p>
                            <button type="button" onclick="document.getElementById('image').value=''; location.reload();" 
                                    class="mt-2 text-sm text-red-600 hover:text-red-500">제거</button>
                        </div>
                    `;
                };
                reader.readAsDataURL(file);
            }
        });
        
        // 폼 제출 시 로딩 상태
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = document.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '등록 중...';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>