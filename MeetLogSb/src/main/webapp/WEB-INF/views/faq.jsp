<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - FAQ</title>
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
                <h2 class="text-3xl font-bold mb-8">❓ 자주 묻는 질문</h2>
                
                <div class="space-y-4">
                    <c:forEach var="faq" items="${faqs}">
                        <div class="bg-white rounded-lg shadow-md">
                            <div class="p-6">
                                <div class="flex items-start">
                                    <div class="flex-shrink-0">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                            ${faq.category}
                                        </span>
                                    </div>
                                    <div class="ml-4 flex-1">
                                        <h3 class="text-lg font-medium text-gray-900 mb-2">Q. ${faq.question}</h3>
                                        <p class="text-gray-600">A. ${faq.answer}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${empty faqs}">
                    <div class="text-center py-12">
                        <div class="text-gray-400 text-6xl mb-4">❓</div>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">등록된 질문이 없습니다</h3>
                        <p class="text-gray-500">궁금한 점은 1:1 문의를 이용해주세요.</p>
                    </div>
                </c:if>
                
                <div class="mt-8 text-center">
                    <p class="text-gray-600 mb-4">원하는 답변을 찾지 못하셨나요?</p>
                    <a href="${pageContext.request.contextPath}/inquiry" 
                       class="inline-block bg-blue-500 text-white px-6 py-3 rounded hover:bg-blue-600 transition-colors">
                        1:1 문의하기
                    </a>
                </div>
            </div>
        </main>

        <%-- 2. 공통 푸터 포함 (경로 표준화) --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <!-- 3. 공통 로딩 오버레이 포함 -->
    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>