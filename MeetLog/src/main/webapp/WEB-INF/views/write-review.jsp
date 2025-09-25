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
    <style>
        .image-add-btn { cursor: pointer; display: flex; flex-direction: column; justify-content: center; align-items: center; width: 100px; height: 100px; border: 2px dashed #cbd5e1; border-radius: 0.5rem; color: #64748b; transition: background-color 0.2s, border-color 0.2s; }
        .image-add-btn:hover { background-color: #f1f5f9; border-color: #94a3b8; }
        .image-add-btn .plus-icon { font-size: 2.5rem; font-weight: 200; line-height: 1; }
        .image-add-btn .add-text { font-size: 0.8rem; margin-top: 0.25rem; }
        .preview-image-container { position: relative; width: 100px; height: 100px; }
        .preview-image { width: 100%; height: 100%; object-fit: cover; border-radius: 0.5rem; border: 1px solid #e2e8f0; }
        .delete-preview-btn { position: absolute; top: -0.5rem; right: -0.5rem; width: 1.5rem; height: 1.5rem; background-color: #ef4444; color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 0.8rem; font-weight: bold; cursor: pointer; border: 2px solid white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-2xl mx-auto">
                    <div class="mb-6">
                        <h2 class="text-2xl md:text-3xl font-bold mb-2">리뷰 작성</h2>
                        <p class="text-slate-600">맛집에 대한 솔직한 리뷰를 작성해주세요.</p>
                    </div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:choose>
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

                                        <form action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data" class="space-y-6">
                                            <input type="hidden" name="restaurantId" value="${restaurant.id}">

                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-3">전체 평점</label>
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
                                            
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h4 class="text-lg font-semibold text-slate-800 mb-4">상세 평점</h4>
                                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                    <div>
                                                        <label class="block text-sm font-medium text-slate-700 mb-2">맛</label>
                                                        <div class="flex items-center space-x-1" id="taste-rating-container">
                                                            <input type="hidden" name="tasteRating" id="tasteRating" value="5" required>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 taste-star" data-rating="1">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 taste-star" data-rating="2">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 taste-star" data-rating="3">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 taste-star" data-rating="4">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 taste-star" data-rating="5">★</button>
                                                            <span class="ml-2 text-sm text-slate-600" id="taste-rating-text">5점</span>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <label class="block text-sm font-medium text-slate-700 mb-2">서비스</label>
                                                        <div class="flex items-center space-x-1" id="service-rating-container">
                                                            <input type="hidden" name="serviceRating" id="serviceRating" value="5" required>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 service-star" data-rating="1">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 service-star" data-rating="2">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 service-star" data-rating="3">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 service-star" data-rating="4">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 service-star" data-rating="5">★</button>
                                                            <span class="ml-2 text-sm text-slate-600" id="service-rating-text">5점</span>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <label class="block text-sm font-medium text-slate-700 mb-2">분위기</label>
                                                        <div class="flex items-center space-x-1" id="atmosphere-rating-container">
                                                            <input type="hidden" name="atmosphereRating" id="atmosphereRating" value="5" required>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 atmosphere-star" data-rating="1">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 atmosphere-star" data-rating="2">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 atmosphere-star" data-rating="3">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 atmosphere-star" data-rating="4">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 atmosphere-star" data-rating="5">★</button>
                                                            <span class="ml-2 text-sm text-slate-600" id="atmosphere-rating-text">5점</span>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <label class="block text-sm font-medium text-slate-700 mb-2">가격</label>
                                                        <div class="flex items-center space-x-1" id="price-rating-container">
                                                            <input type="hidden" name="priceRating" id="priceRating" value="5" required>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 price-star" data-rating="1">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 price-star" data-rating="2">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 price-star" data-rating="3">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 price-star" data-rating="4">★</button>
                                                            <button type="button" class="text-2xl text-yellow-400 hover:text-yellow-500 price-star" data-rating="5">★</button>
                                                            <span class="ml-2 text-sm text-slate-600" id="price-rating-text">5점</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="bg-blue-50 p-4 rounded-lg">
                                                <h4 class="text-lg font-semibold text-slate-800 mb-4">방문 정보</h4>
                                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                                    <div>
                                                        <label for="visitDate" class="block text-sm font-medium text-slate-700 mb-2">방문 날짜</label>
                                                        <input type="date" id="visitDate" name="visitDate" class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                                    </div>
                                                    <div>
                                                        <label for="partySize" class="block text-sm font-medium text-slate-700 mb-2">인원수</label>
                                                        <select id="partySize" name="partySize" class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                                            <option value="1">1명</option>
                                                            <option value="2" selected>2명</option>
                                                            <option value="3">3명</option>
                                                            <option value="4">4명</option>
                                                            <option value="5">5명 이상</option>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label for="visitPurpose" class="block text-sm font-medium text-slate-700 mb-2">방문 목적</label>
                                                        <select id="visitPurpose" name="visitPurpose" class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                                            <option value="일반">일반</option>
                                                            <option value="데이트">데이트</option>
                                                            <option value="비즈니스">비즈니스</option>
                                                            <option value="가족모임">가족모임</option>
                                                            <option value="친구모임">친구모임</option>
                                                            <option value="혼밥">혼밥</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">사진 첨부 (최대 5장)</label>
                                                <div class="mt-2">
                                                    <input type="file" id="images" name="images" accept="image/*" multiple class="hidden">
                                                    <div id="imagePreviewContainer" class="flex flex-wrap gap-4 items-center">
                                                        <label for="images" class="image-add-btn">
                                                            <span class="plus-icon">+</span>
                                                            <span class="add-text">이미지 추가</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div>
                                                <label for="content" class="block text-sm font-medium text-slate-700 mb-2">리뷰 내용</label>
                                                <textarea id="content" name="content" rows="6" required
                                                          class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500"
                                                          placeholder="맛집에 대한 솔직한 리뷰를 작성해주세요."></textarea>
                                                <p class="text-sm text-slate-500 mt-1">최소 10자 이상 작성해주세요.</p>
                                            </div>

                                            <div class="flex justify-end space-x-3">
                                                <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}" class="px-6 py-2 border border-slate-300 rounded-md text-slate-700 hover:bg-slate-50">취소</a>
                                                <button type="submit" class="px-6 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700">리뷰 작성</button>
                                            </div>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-12"><div class="text-6xl mb-4">❌</div><h3 class="text-xl font-bold text-slate-800 mb-2">맛집 정보를 찾을 수 없습니다</h3><p class="text-slate-600 mb-6">잘못된 맛집 정보입니다.</p><a href="${pageContext.request.contextPath}/main" class="inline-block bg-sky-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-sky-700">메인으로 돌아가기</a></div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12"><div class="text-6xl mb-4">🔒</div><h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2><p class="text-slate-600 mb-6">리뷰를 작성하려면 로그인해주세요.</p><a href="${pageContext.request.contextPath}/login" class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">로그인하기</a></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // ... (이전 답변의 별점 및 이미지 미리보기 JavaScript 코드 전체를 여기에 붙여넣으세요) ...
        // 평점 초기화 로직
        const today = new Date().toISOString().split('T')[0];
        const visitDateInput = document.getElementById('visitDate');
        if (visitDateInput) {
            visitDateInput.value = today;
        }
        
        // 별점 로직
        function setupRating(containerId, starClass, inputId, textId) {
            const container = document.getElementById(containerId);
            if (!container) return;
            const stars = container.querySelectorAll('.' + starClass);
            const input = document.getElementById(inputId);
            const text = document.getElementById(textId);
            function updateStars(rating) {
                stars.forEach((s, i) => {
                    s.classList.toggle('text-yellow-400', i < rating);
                    s.classList.toggle('text-gray-300', i >= rating);
                });
            }
            stars.forEach((star, index) => {
                star.addEventListener('click', () => {
                    const rating = index + 1;
                    input.value = rating;
                    text.textContent = rating + '점';
                    updateStars(rating);
                });
            });
            container.addEventListener('mouseleave', () => {
                const currentRating = parseInt(input.value, 10);
                updateStars(currentRating);
            });
            stars.forEach((star, index) => {
                 star.addEventListener('mouseenter', () => {
                    const hoverRating = index + 1;
                    updateStars(hoverRating);
                });
            });
        }
        
        setupRating('rating-container', 'rating-star', 'rating', 'rating-text');
        setupRating('taste-rating-container', 'taste-star', 'tasteRating', 'taste-rating-text');
        setupRating('service-rating-container', 'service-star', 'serviceRating', 'service-rating-text');
        setupRating('atmosphere-rating-container', 'atmosphere-star', 'atmosphereRating', 'atmosphere-rating-text');
        setupRating('price-rating-container', 'price-star', 'priceRating', 'price-rating-text');

        // 이미지 미리보기 로직
        const fileInput = document.getElementById('images');
        const previewContainer = document.getElementById('imagePreviewContainer');
        const addBtn = document.querySelector('.image-add-btn');
        const dataTransfer = new DataTransfer();
        const MAX_FILES = 5;
        fileInput.addEventListener('change', (e) => {
            const newFiles = Array.from(e.target.files);
            if (dataTransfer.files.length + newFiles.length > MAX_FILES) {
                alert(`이미지는 최대 ${MAX_FILES}개까지 업로드할 수 있습니다.`);
                return;
            }
            newFiles.forEach(file => {
                dataTransfer.items.add(file);
                const reader = new FileReader();
                reader.onload = () => { createPreview(file, reader.result); };
                reader.readAsDataURL(file);
            });
            fileInput.files = dataTransfer.files;
            updateAddBtnVisibility();
        });
        function createPreview(file, src) {
            const container = document.createElement('div');
            container.className = 'preview-image-container';
            const img = document.createElement('img');
            img.src = src;
            img.className = 'preview-image';
            const deleteBtn = document.createElement('span');
            deleteBtn.className = 'delete-preview-btn';
            deleteBtn.textContent = 'X';
            deleteBtn.addEventListener('click', () => {
                const newFiles = new DataTransfer();
                Array.from(dataTransfer.files).forEach(f => {
                    if (f !== file) { newFiles.items.add(f); }
                });
                dataTransfer.clearData();
                Array.from(newFiles.files).forEach(f => dataTransfer.items.add(f));
                fileInput.files = dataTransfer.files;
                container.remove();
                updateAddBtnVisibility();
            });
            container.appendChild(img);
            container.appendChild(deleteBtn);
            previewContainer.insertBefore(container, addBtn);
        }
        function updateAddBtnVisibility() {
            if (dataTransfer.files.length >= MAX_FILES) {
                addBtn.style.display = 'none';
            } else {
                addBtn.style.display = 'flex';
            }
        }
    });
    </script>
</body>
</html>