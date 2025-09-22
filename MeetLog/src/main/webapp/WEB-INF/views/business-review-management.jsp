<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 리뷰 관리</title>
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
                    <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">리뷰 관리</h2>
                    <p class="text-slate-600">매장에 대한 고객 리뷰를 확인하고 관리합니다.</p>
                </div>

                <!-- 리뷰 목록 -->
                <div class="bg-white rounded-xl shadow-lg">
                    <div class="p-6 border-b border-slate-200">
                        <h3 class="text-lg font-semibold text-slate-800">리뷰 목록</h3>
                    </div>
                    <div class="p-6">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <div class="space-y-6">
                                    <c:forEach var="review" items="${reviews}">
                                        <div class="border border-slate-200 rounded-lg p-6 hover:bg-slate-50 transition-colors">
                                            <div class="flex items-start justify-between">
                                                <div class="flex-1">
                                                    <div class="flex items-center space-x-3 mb-3">
                                                        <h4 class="font-medium text-slate-900">${review.customerName}</h4>
                                                        <div class="flex items-center">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <span class="text-sm ${i <= review.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                                            </c:forEach>
                                                            <span class="ml-2 text-sm text-slate-600">${review.rating}/5</span>
                                                        </div>
                                                        <span class="text-sm text-slate-500">${review.createdAt}</span>
                                                    </div>
                                                    <p class="text-slate-700 leading-relaxed">${review.content}</p>
                                                </div>
                                                <div class="flex space-x-2 ml-4">
                                                    <button class="px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors">
                                                        답글
                                                    </button>
                                                    <button class="px-3 py-1 text-sm bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
                                                        숨김
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <svg class="mx-auto h-12 w-12 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                                    </svg>
                                    <h3 class="mt-2 text-sm font-medium text-slate-900">리뷰가 없습니다</h3>
                                    <p class="mt-1 text-sm text-slate-500">아직 등록된 리뷰가 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>

        <%-- 공통 푸터 포함 --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
