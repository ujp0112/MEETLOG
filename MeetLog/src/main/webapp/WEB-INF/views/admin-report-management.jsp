<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 신고 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" scope="request" value="report" />
<div class="min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <div class="px-4 py-6 sm:px-0">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">신고 관리</h2>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-blue-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                            </svg>
                        </div>
                        <div class="ml-4">
                            <p class="text-sm font-medium text-gray-500">전체 신고</p>
                            <p class="text-2xl font-bold text-gray-900">${statistics.total}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-yellow-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="ml-4">
                            <p class="text-sm font-medium text-gray-500">대기 중</p>
                            <p class="text-2xl font-bold text-gray-900">${statistics.pending}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="ml-4">
                            <p class="text-sm font-medium text-gray-500">처리 완료</p>
                            <p class="text-2xl font-bold text-gray-900">${statistics.processed}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 bg-gray-500 rounded-md p-3">
                            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </div>
                        <div class="ml-4">
                            <p class="text-sm font-medium text-gray-500">기각됨</p>
                            <p class="text-2xl font-bold text-gray-900">${statistics.dismissed}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 상태별 탭 -->
            <div class="mb-6">
                <div class="border-b border-gray-200">
                    <nav class="-mb-px flex space-x-8">
                        <a href="?status=" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${empty currentStatus ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            전체 (${statistics.total})
                        </a>
                        <a href="?status=PENDING" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'PENDING' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            대기 중 (${statistics.pending})
                        </a>
                        <a href="?status=PROCESSED" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'PROCESSED' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            처리 완료 (${statistics.processed})
                        </a>
                        <a href="?status=DISMISSED" class="whitespace-nowrap pb-4 px-1 border-b-2 font-medium text-sm ${currentStatus == 'DISMISSED' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}">
                            기각됨 (${statistics.dismissed})
                        </a>
                    </nav>
                </div>
            </div>

            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="px-4 py-5 sm:px-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">접수된 신고 목록</h3>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">신고된 콘텐츠를 검토하고 조치할 수 있습니다.</p>
                </div>
                <div class="px-4 py-5 sm:px-6">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">신고 ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">신고자</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">신고 대상</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">사유</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${empty reports}">
                                    <tr>
                                        <td colspan="6" class="px-6 py-8 text-center text-sm text-gray-500">
                                            신고 내역이 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="report" items="${reports}">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">#${report.reportId}</td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">${report.reporterNickname}</div>
                                                <div class="text-sm text-gray-500">${report.createdAt}</div>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm text-gray-900">
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                                                        ${report.reportedType}
                                                    </span>
                                                    <c:if test="${not empty report.reportedUserNickname}">
                                                        <span class="ml-2">${report.reportedUserNickname}</span>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm text-gray-700 max-w-xs truncate">${report.reason}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <c:choose>
                                                    <c:when test="${report.status == 'PENDING'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">대기</span>
                                                    </c:when>
                                                    <c:when test="${report.status == 'PROCESSED'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-emerald-100 text-emerald-800">조치 완료</span>
                                                    </c:when>
                                                    <c:when test="${report.status == 'DISMISSED'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">기각됨</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <c:if test="${report.status == 'PENDING'}">
                                                    <form method="post" class="inline-flex space-x-2">
                                                        <input type="hidden" name="reportId" value="${report.reportId}" />
                                                        <button type="submit" name="action" value="process"
                                                                onclick="return confirm('이 신고를 처리 완료로 변경하시겠습니까?')"
                                                                class="px-3 py-1.5 bg-blue-600 text-white text-xs rounded hover:bg-blue-700">
                                                            조치 완료
                                                        </button>
                                                        <button type="submit" name="action" value="dismiss"
                                                                onclick="return confirm('이 신고를 기각하시겠습니까?')"
                                                                class="px-3 py-1.5 bg-gray-200 text-gray-700 text-xs rounded hover:bg-gray-300">
                                                            기각
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${report.status != 'PENDING'}">
                                                    <span class="text-xs text-gray-500">
                                                        <c:if test="${not empty report.processedByNickname}">
                                                            처리자: ${report.processedByNickname}
                                                        </c:if>
                                                    </span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>
</body>
</html>
