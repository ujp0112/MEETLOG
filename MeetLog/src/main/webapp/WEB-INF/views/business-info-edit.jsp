<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 매장 정보 수정</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- 공통 헤더 포함 --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8">
                    <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">매장 정보 수정</h2>
                    <p class="text-slate-600">매장의 기본 정보를 수정할 수 있습니다.</p>
                </div>

                <!-- 매장 정보 수정 폼 -->
                <div class="bg-white rounded-xl shadow-lg">
                    <div class="p-6 border-b border-slate-200">
                        <h3 class="text-lg font-semibold text-slate-800">매장 정보</h3>
                    </div>
                    <div class="p-6">
                        <form action="${pageContext.request.contextPath}/business/info-edit" method="post" class="space-y-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- 매장명 -->
                                <div>
                                    <label for="restaurantName" class="block text-sm font-medium text-slate-700 mb-2">매장명</label>
                                    <input type="text" id="restaurantName" name="restaurantName" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                           placeholder="매장명을 입력하세요" required>
                                </div>

                                <!-- 사업자등록번호 -->
                                <div>
                                    <label for="businessNumber" class="block text-sm font-medium text-slate-700 mb-2">사업자등록번호</label>
                                    <input type="text" id="businessNumber" name="businessNumber" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                           placeholder="000-00-00000" required>
                                </div>

                                <!-- 카테고리 -->
                                <div>
                                    <label for="category" class="block text-sm font-medium text-slate-700 mb-2">카테고리</label>
                                    <select id="category" name="category" 
                                            class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                                        <option value="">카테고리를 선택하세요</option>
                                        <option value="한식">한식</option>
                                        <option value="중식">중식</option>
                                        <option value="일식">일식</option>
                                        <option value="양식">양식</option>
                                        <option value="카페">카페</option>
                                        <option value="기타">기타</option>
                                    </select>
                                </div>

                                <!-- 전화번호 -->
                                <div>
                                    <label for="phone" class="block text-sm font-medium text-slate-700 mb-2">전화번호</label>
                                    <input type="tel" id="phone" name="phone" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                           placeholder="000-0000-0000" required>
                                </div>
                            </div>

                            <!-- 주소 -->
                            <div>
                                <label for="address" class="block text-sm font-medium text-slate-700 mb-2">주소</label>
                                <input type="text" id="address" name="address" 
                                       class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                       placeholder="매장 주소를 입력하세요" required>
                            </div>

                            <!-- 매장 설명 -->
                            <div>
                                <label for="description" class="block text-sm font-medium text-slate-700 mb-2">매장 설명</label>
                                <textarea id="description" name="description" rows="4" 
                                          class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                          placeholder="매장에 대한 간단한 설명을 입력하세요"></textarea>
                            </div>

                            <!-- 운영시간 -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="openTime" class="block text-sm font-medium text-slate-700 mb-2">오픈 시간</label>
                                    <input type="time" id="openTime" name="openTime" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label for="closeTime" class="block text-sm font-medium text-slate-700 mb-2">마감 시간</label>
                                    <input type="time" id="closeTime" name="closeTime" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>

                            <!-- 버튼 -->
                            <div class="flex justify-end space-x-4 pt-6">
                                <button type="button" onclick="history.back()" 
                                        class="px-6 py-2 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors">
                                    취소
                                </button>
                                <button type="submit" 
                                        class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                    저장
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <%-- 공통 푸터 포함 --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
