<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메뉴 수정 - ${menu.name} - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .card { background-color: white; border-radius: 0.75rem; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); padding: 1.5rem; }
        .btn-primary { background-color: #0284c7; color: white; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 600; transition: background-color 0.2s; }
        .btn-primary:hover { background-color: #0369a1; }
        .btn-secondary { background-color: #6b7280; color: white; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 600; transition: background-color 0.2s; }
        .btn-secondary:hover { background-color: #4b5563; }
    </style>
</head>
<body class="bg-gray-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <div class="max-w-2xl mx-auto py-12 px-4">
        <!-- 헤더 -->
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">메뉴 수정</h1>
                <p class="text-gray-600 mt-2">${restaurant.name} - ${menu.name}</p>
            </div>
            <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus" class="btn-secondary">← 메뉴 관리로 돌아가기</a>
        </div>

        <!-- 폼 -->
        <div class="card">
            <c:if test="${not empty errorMessage}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                    ${errorMessage}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus/edit/${menu.id}" 
                  enctype="multipart/form-data" class="space-y-6">
                
                <!-- 현재 이미지 -->
                <c:if test="${not empty menu.image}">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">현재 이미지</label>
                        <img src="${pageContext.request.contextPath}/${menu.image}" alt="${menu.name} 이미지" class="w-32 h-32 object-cover rounded-lg border">
                    </div>
                </c:if>

                <!-- 메뉴명 -->
                <div>
                    <label for="name" class="block text-sm font-medium text-gray-700 mb-2">메뉴명 *</label>
                    <input type="text" id="name" name="name" value="${menu.name}" required
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>

                <!-- 가격 -->
                <div>
                    <label for="price" class="block text-sm font-medium text-gray-700 mb-2">가격 *</label>
                    <input type="text" id="price" name="price" value="${menu.price}" placeholder="예: 15,000원" required
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>

                <!-- 설명 -->
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700 mb-2">메뉴 설명</label>
                    <textarea id="description" name="description" rows="3"
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              placeholder="메뉴에 대한 자세한 설명을 입력해주세요.">${menu.description}</textarea>
                </div>

                <!-- 인기 메뉴 여부 -->
                <div class="flex items-center">
                    <input type="checkbox" id="popular" name="popular" value="true" ${menu.popular ? 'checked' : ''}
                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="popular" class="ml-2 block text-sm text-gray-700">
                        인기 메뉴로 설정
                    </label>
                </div>

                <!-- 이미지 업로드 -->
                <div>
                    <label for="menuImage" class="block text-sm font-medium text-gray-700 mb-2">새 이미지 업로드 (선택사항)</label>
                    <input type="file" id="menuImage" name="menuImage" accept="image/*"
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <p class="text-sm text-gray-500 mt-1">새 이미지를 업로드하면 기존 이미지가 교체됩니다. (JPG, PNG, GIF, 최대 10MB)</p>
                </div>

                <!-- 미리보기 -->
                <div id="imagePreview" class="hidden">
                    <label class="block text-sm font-medium text-gray-700 mb-2">새 이미지 미리보기</label>
                    <img id="previewImg" src="" alt="미리보기" class="w-32 h-32 object-cover rounded-lg border">
                </div>

                <!-- 버튼 -->
                <div class="flex justify-end space-x-3 pt-6">
                    <a href="${pageContext.request.contextPath}/business/restaurants/${restaurant.id}/menus" 
                       class="btn-secondary">취소</a>
                    <button type="submit" class="btn-primary">메뉴 수정</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 이미지 미리보기 기능
        document.getElementById('menuImage').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                    document.getElementById('imagePreview').classList.remove('hidden');
                };
                reader.readAsDataURL(file);
            } else {
                document.getElementById('imagePreview').classList.add('hidden');
            }
        });
    </script>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
