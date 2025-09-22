<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메뉴 추가 - ${restaurant.name}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen">
        <!-- 헤더 -->
        <header class="bg-white shadow-sm border-b">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center h-16">
                    <div class="flex items-center">
                        <a href="/MeetLog/business/restaurants/${restaurant.id}/menus" class="text-gray-600 hover:text-gray-900">
                            ← 메뉴 관리로 돌아가기
                        </a>
                    </div>
                    <h1 class="text-xl font-semibold text-gray-900">새 메뉴 추가</h1>
                </div>
            </div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="max-w-2xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="bg-white shadow rounded-lg">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h2 class="text-lg font-medium text-gray-900">${restaurant.name} - 메뉴 추가</h2>
                </div>
                
                <form action="/MeetLog/business/restaurants/${restaurant.id}/menus" method="POST" enctype="multipart/form-data" class="px-6 py-4">
                    <div class="space-y-6">
                        <!-- 메뉴명 -->
                        <div>
                            <label for="name" class="block text-sm font-medium text-gray-700">메뉴명 *</label>
                            <input type="text" id="name" name="name" required
                                   class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                        </div>

                        <!-- 설명 -->
                        <div>
                            <label for="description" class="block text-sm font-medium text-gray-700">설명</label>
                            <textarea id="description" name="description" rows="3"
                                      class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"></textarea>
                        </div>

                        <!-- 가격 -->
                        <div>
                            <label for="price" class="block text-sm font-medium text-gray-700">가격 (원) *</label>
                            <input type="text" id="price" name="price" required
                                   class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                        </div>

                        <!-- 카테고리 -->
                        <div>
                            <label for="category" class="block text-sm font-medium text-gray-700">카테고리</label>
                            <select id="category" name="category"
                                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="">카테고리 선택</option>
                                <option value="메인">메인</option>
                                <option value="사이드">사이드</option>
                                <option value="음료">음료</option>
                                <option value="디저트">디저트</option>
                                <option value="기타">기타</option>
                            </select>
                        </div>

                        <!-- 이미지 -->
                        <div>
                            <label for="image" class="block text-sm font-medium text-gray-700">메뉴 이미지</label>
                            <input type="file" id="image" name="image" accept="image/*"
                                   class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                        </div>

                        <!-- 재고 수량 -->
                        <div>
                            <label for="stock" class="block text-sm font-medium text-gray-700">재고 수량</label>
                            <input type="number" id="stock" name="stock" min="0"
                                   class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                        </div>

                        <!-- 활성화 상태 -->
                        <div>
                            <div class="flex items-center">
                                <input type="checkbox" id="isActive" name="isActive" value="true" checked
                                       class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                <label for="isActive" class="ml-2 block text-sm text-gray-900">
                                    메뉴 활성화 (체크 해제 시 메뉴가 비활성화됩니다)
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- 버튼 -->
                    <div class="mt-8 flex justify-end space-x-3">
                        <a href="/MeetLog/business/restaurants/${restaurant.id}/menus"
                           class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                            취소
                        </a>
                        <button type="submit"
                                class="bg-blue-600 py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                            메뉴 추가
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
