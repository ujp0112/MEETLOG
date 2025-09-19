<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MEET LOG - 새 가게 등록</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="max-w-2xl mx-auto py-8 px-4">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">새 가게 등록</h1>
        <form action="${pageContext.request.contextPath}/business/restaurants/add" method="post" class="bg-white shadow-md rounded-lg p-8 space-y-6">
            
            <c:if test="${not empty errorMessage}">
                <div class="bg-red-100 text-red-700 p-3 rounded">${errorMessage}</div>
            </c:if>

            <div>
                <label for="name" class="block text-sm font-medium text-gray-700">가게 이름</label>
                <input type="text" id="name" name="name" required class="mt-1 block w-full border border-gray-300 rounded-md p-2">
            </div>
            <div>
                <label for="category" class="block text-sm font-medium text-gray-700">카테고리</label>
                <input type="text" id="category" name="category" required class="mt-1 block w-full border border-gray-300 rounded-md p-2">
            </div>
            <div>
                <label for="location" class="block text-sm font-medium text-gray-700">지역</label>
                <input type="text" id="location" name="location" required class="mt-1 block w-full border border-gray-300 rounded-md p-2">
            </div>
            <div>
                <label for="address" class="block text-sm font-medium text-gray-700">주소</label>
                <input type="text" id="address" name="address" required class="mt-1 block w-full border border-gray-300 rounded-md p-2">
            </div>
            <div>
                <label for="phone" class="block text-sm font-medium text-gray-700">전화번호</label>
                <input type="text" id="phone" name="phone" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
            </div>
            <div>
                <label for="hours" class="block text-sm font-medium text-gray-700">영업 시간 (안내용)</label>
                <input type="text" id="hours" name="hours" class="mt-1 block w-full border border-gray-300 rounded-md p-2" placeholder="예: 매일 11:00 - 22:00 (브레이크타임 15:00-17:00)">
            </div>
            <div>
                <label for="description" class="block text-sm font-medium text-gray-700">가게 설명</label>
                <textarea id="description" name="description" rows="4" class="mt-1 block w-full border border-gray-300 rounded-md p-2"></textarea>
            </div>
            <div class="flex justify-end space-x-4">
                <a href="${pageContext.request.contextPath}/business/restaurants" class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300">취소</a>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">가게 등록</button>
            </div>
        </form>
    </div>
</body>
</html>