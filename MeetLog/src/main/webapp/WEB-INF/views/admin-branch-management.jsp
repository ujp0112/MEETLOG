<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 지점 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <%-- 공통 스타일시트나 커스텀 CSS가 있다면 여기에 추가 --%>
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" value="branch" />
<div class="min-h-screen flex flex-col">
    <jsp:include page="/WEB-INF/views/admin/include/admin-navbar.jspf" />

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <c:set var="subNavBase" value="px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition" />
        <c:set var="subNavActive" value="px-3 py-2 text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg border border-blue-100" />
        <div class="px-4 py-6 sm:px-0">
                    <div class="flex flex-col gap-4 mb-6">
                        <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                            <h2 class="text-2xl font-bold text-gray-900">지점 관리</h2>
                            <button class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition">
                                새 지점 추가
                            </button>
                        </div>
                        <div class="flex flex-wrap items-center gap-2">
                            <a href="${pageContext.request.contextPath}/admin/branch-management"
                               class="${subNavActive}">지점 목록</a>
                            <a href="${pageContext.request.contextPath}/admin/branch-statistics"
                               class="${subNavBase}">지점 통계</a>
                        </div>
                    </div>
                    
                    <c:if test="${not empty successMessage}">
                        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                            ${successMessage}
                        </div>
                    </c:if>
                    
                    <div class="bg-white shadow overflow-hidden sm:rounded-md">
                        <div class="px-4 py-5 sm:px-6">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">지점 목록</h3>
                            <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 지점을 관리할 수 있습니다.</p>
                        </div>
                        <ul class="divide-y divide-gray-200">
                            <c:forEach var="branch" items="${branches}">
                                <li>
                                    <div class="px-4 py-4 sm:px-6">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-16 w-16">
                                                    <div class="h-16 w-16 rounded-lg bg-gradient-to-r from-indigo-500 to-purple-600 flex items-center justify-center">
                                                        <span class="text-white text-lg font-bold">🏢</span>
                                                    </div>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="flex items-center">
                                                        <p class="text-lg font-medium text-gray-900">${branch.name}</p>
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${branch.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : branch.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800'}">
                                                            ${branch.status == 'ACTIVE' ? '운영중' : branch.status == 'PENDING' ? '준비중' : '휴업'}
                                                        </span>
                                                    </div>
                                                    <p class="text-sm text-gray-500">${branch.address}</p>
                                                    <div class="flex items-center mt-1">
                                                        <span class="text-sm text-gray-500">전화: ${branch.phone}</span>
                                                        <span class="ml-4 text-sm text-gray-500">지점장: ${branch.manager}</span>
                                                        <span class="ml-4 text-sm text-gray-500">직원: ${branch.employeeCount}명</span>
                                                        <span class="ml-4 text-sm text-gray-500">월매출: 
                                                            <fmt:formatNumber value="${branch.monthlyRevenue}" type="currency" currencySymbol="₩"/>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="flex space-x-2">
                                                <button class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                    수정
                                                </button>
                                                <c:if test="${branch.status == 'PENDING'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="action" value="activate">
                                                        <input type="hidden" name="branchId" value="${branch.id}">
                                                        <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                            운영 시작
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${branch.status == 'ACTIVE'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="branchId" value="${branch.id}">
                                                        <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
                                                            휴업
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="branchId" value="${branch.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                                            onclick="return confirm('정말로 이 지점을 삭제하시겠습니까?')">
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