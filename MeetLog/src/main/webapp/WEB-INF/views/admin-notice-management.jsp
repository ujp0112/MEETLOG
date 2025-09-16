<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 공지사항 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <div class="min-h-screen flex flex-col">
        <nav class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <h1 class="text-xl font-bold text-gray-900">MEET LOG 관리자</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-gray-700 hover:text-gray-900">대시보드</a>
                        <a href="${pageContext.request.contextPath}/admin/member-management" class="text-gray-700 hover:text-gray-900">회원 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/business-management" class="text-gray-700 hover:text-gray-900">업체 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/event-management" class="text-gray-700 hover:text-gray-900">이벤트 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/notice-management" class="text-blue-600 font-medium">공지사항</a>
                        <a href="${pageContext.request.contextPath}/admin/faq-management" class="text-gray-700 hover:text-gray-900">FAQ</a>
                        <a href="${pageContext.request.contextPath}/admin/inquiry-management" class="text-gray-700 hover:text-gray-900">문의 관리</a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">공지사항 관리</h2>
                    <button class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                        새 공지사항 작성
                    </button>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="bg-white shadow overflow-hidden sm:rounded-md">
                    <div class="px-4 py-5 sm:px-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">공지사항 목록</h3>
                        <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 공지사항을 관리할 수 있습니다.</p>
                    </div>
                    <ul class="divide-y divide-gray-200">
                        <c:forEach var="notice" items="${notices}">
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-12 w-12">
                                                <div class="h-12 w-12 rounded-lg bg-blue-100 flex items-center justify-center">
                                                    <span class="text-blue-600 text-lg">📢</span>
                                                </div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="flex items-center">
                                                    <p class="text-lg font-medium text-gray-900">${notice.title}</p>
                                                    <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${notice.status == 'PUBLISHED' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                                        ${notice.status == 'PUBLISHED' ? '발행됨' : '임시저장'}
                                                    </span>
                                                </div>
                                                <p class="text-sm text-gray-500">${notice.content}</p>
                                                <div class="flex items-center mt-1">
                                                    <span class="text-sm text-gray-500">카테고리: ${notice.category}</span>
                                                    <span class="ml-4 text-sm text-gray-500">작성일: <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/></span>
                                                    <span class="ml-4 text-sm text-gray-500">조회수: ${notice.viewCount}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <button class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                수정
                                            </button>
                                            <c:if test="${notice.status == 'DRAFT'}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="publish">
                                                    <input type="hidden" name="noticeId" value="${notice.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                        발행
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${notice.status == 'PUBLISHED'}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="unpublish">
                                                    <input type="hidden" name="noticeId" value="${notice.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
                                                        발행 취소
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="noticeId" value="${notice.id}">
                                                <button type="submit" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                                        onclick="return confirm('정말로 이 공지사항을 삭제하시겠습니까?')">
                                                    삭제
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>