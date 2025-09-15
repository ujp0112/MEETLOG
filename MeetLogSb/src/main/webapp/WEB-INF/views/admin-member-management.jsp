<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 회원 관리</title>
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
                        <a href="${pageContext.request.contextPath}/admin/member-management" class="text-blue-600 font-medium">회원 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/business-management" class="text-gray-700 hover:text-gray-900">업체 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/report-management" class="text-gray-700 hover:text-gray-900">신고 관리</a>
                        <a href="${pageContext.request.contextPath}/admin/cs-management" class="text-gray-700 hover:text-gray-900">고객센터</a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">회원 관리</h2>
                
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="bg-white shadow overflow-hidden sm:rounded-md">
                    <div class="px-4 py-5 sm:px-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">회원 목록</h3>
                        <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 모든 회원을 관리할 수 있습니다.</p>
                    </div>
                    <ul class="divide-y divide-gray-200">
                        <c:forEach var="member" items="${members}">
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10">
                                                <div class="h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center">
                                                    <span class="text-sm font-medium text-gray-700">${member.nickname.charAt(0)}</span>
                                                </div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="flex items-center">
                                                    <p class="text-sm font-medium text-gray-900">${member.nickname}</p>
                                                    <c:if test="${member.userType == 'BUSINESS'}">
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                            사업자
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${!member.isActive}">
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                            정지됨
                                                        </span>
                                                    </c:if>
                                                </div>
                                                <p class="text-sm text-gray-500">${member.email}</p>
                                                <p class="text-sm text-gray-500">가입일: <fmt:formatDate value="${member.createdAt}" pattern="yyyy.MM.dd"/> | 리뷰 수: ${member.reviewCount}</p>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <c:if test="${member.isActive}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="suspend">
                                                    <input type="hidden" name="memberId" value="${member.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                                                        정지
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${!member.isActive}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="activate">
                                                    <input type="hidden" name="memberId" value="${member.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                                        활성화
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="memberId" value="${member.id}">
                                                <button type="submit" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                                        onclick="return confirm('정말로 이 회원을 삭제하시겠습니까?')">
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