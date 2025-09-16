<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 1:1 문의</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

    <div id="app" class="flex flex-col bg-slate-100 min-h-screen">
        <%-- 1. 공통 헤더 포함 (경로 표준화) --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                <h2 class="text-3xl font-bold mb-8">💬 1:1 문의</h2>
                
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6 max-w-2xl mx-auto">
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6 max-w-2xl mx-auto">
                        ${errorMessage}
                    </div>
                </c:if>
                
                <div class="max-w-2xl mx-auto">
                    <div class="bg-white rounded-lg shadow-md p-8">
                        <form method="post" "${pageContext.request.contextPath}.do/inquiry">
                            <div class="mb-6">
                                <label for="category" class="block text-sm font-medium text-gray-700 mb-2">문의 유형</label>
                                <select id="category" name="category" required 
                                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                    <option value="">선택해주세요</option>
                                    <option value="account">계정 관련</option>
                                    <option value="reservation">예약 관련</option>
                                    <option value="review">리뷰 관련</option>
                                    <option value="payment">결제 관련</option>
                                    <option value="technical">기술적 문제</option>
                                    <option value="other">기타</option>
                                </select>
                            </div>
                            
                            <div class="mb-6">
                                <label for="subject" class="block text-sm font-medium text-gray-700 mb-2">제목</label>
                                <input type="text" id="subject" name="subject" required
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                       placeholder="문의 제목을 입력해주세요">
                            </div>
                            
                            <div class="mb-6">
                                <label for="content" class="block text-sm font-medium text-gray-700 mb-2">내용</label>
                                <textarea id="content" name="content" rows="8" required
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                          placeholder="문의 내용을 자세히 입력해주세요"></textarea>
                            </div>
                            
                            <div class="flex justify-end space-x-4">
                                <button type="button" onclick="history.back()" 
                                        class="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50">
                                    취소
                                </button>
                                <button type="submit" 
                                        class="px-6 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">
                                    문의하기
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <%-- 2. 공통 푸터 포함 (경로 표준화) --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>