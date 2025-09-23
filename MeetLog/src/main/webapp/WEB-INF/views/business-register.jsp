<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 사업자 등록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center py-8">

    <div class="max-w-2xl w-full space-y-8 p-4">
        <div>
            <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                사업자 등록
            </h2>
            <p class="mt-2 text-center text-sm text-gray-600">
                MEET LOG에 사업자로 등록하여 맛집을 관리하세요
            </p>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                ${errorMessage}
            </div>
        </c:if>
        
        <form class="mt-8 space-y-6" method="post">
            <div class="space-y-4 bg-white p-8 shadow-md rounded-lg">
                <div>
                    <label for="businessName" class="block text-sm font-medium text-gray-700">사업체명</label>
                    <input id="businessName" name="businessName" type="text" required 
                           class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="사업체명을 입력하세요">
                </div>
                
                <div>
                    <label for="ownerName" class="block text-sm font-medium text-gray-700">대표자명</label>
                    <input id="ownerName" name="ownerName" type="text" required 
                           class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="대표자명을 입력하세요">
                </div>
                
                <div>
                    <label for="businessNumber" class="block text-sm font-medium text-gray-700">사업자등록번호</label>
                    <input id="businessNumber" name="businessNumber" type="text" required 
                           class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="000-00-00000">
                </div>
                
                <div>
                    <label for="category" class="block text-sm font-medium text-gray-700">업종</label>
                    <select id="category" name="category" required 
                            class="mt-1 block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                        <option value="">업종을 선택하세요</option>
                        <option value="한식">한식</option>
                        <option value="일식">일식</option>
                        <option value="중식">중식</option>
                        <option value="양식">양식</option>
                        <option value="카페">카페</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                
                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700">주소</label>
                    <input id="address" name="address" type="text" required 
                           class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="주소를 입력하세요">
                </div>
                
                <div>
                    <label for="phone" class="block text-sm font-medium text-gray-700">전화번호</label>
                    <input id="phone" name="phone" type="tel" required 
                           class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="02-1234-5678">
                </div>
                
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700">이메일</label>
                    <input id="email" name="email" type="email" required 
                           class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                           placeholder="이메일을 입력하세요">
                </div>
                
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700">사업체 소개</label>
                    <textarea id="description" name="description" rows="4" 
                              class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" 
                              placeholder="사업체에 대한 간단한 소개를 작성해주세요"></textarea>
                </div>
            </div>

            <div>
                <button type="submit" 
                        class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    사업자 등록 신청
                </button>
            </div>
            
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/login" class="text-indigo-600 hover:text-indigo-500">
                    로그인 페이지로 돌아가기
                </a>
            </div>
        </form>
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>