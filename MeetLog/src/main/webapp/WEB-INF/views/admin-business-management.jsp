<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 업체 관리</title>
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
                    <a href="${pageContext.request.contextPath}/admin/business-management" class="text-blue-600 font-medium">업체 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/report-management" class="text-gray-700 hover:text-gray-900">신고 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/faq-management" class="text-gray-700 hover:text-gray-900">FAQ 관리</a>
                    <a href="${pageContext.request.contextPath}/logout" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">로그아웃</a>
                </div>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <div class="px-4 py-6 sm:px-0">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">입점 업체 관리</h2>

            <c:if test="${not empty successMessage}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                    ${successMessage}
                </div>
            </c:if>

            <c:set var="approvedCount" value="0" />
            <c:set var="pendingCount" value="0" />
            <c:set var="suspendedCount" value="0" />
            <c:forEach var="business" items="${businesses}">
                <c:if test="${business.status == 'APPROVED'}">
                    <c:set var="approvedCount" value="${approvedCount + 1}" />
                </c:if>
                <c:if test="${business.status == 'PENDING'}">
                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                </c:if>
                <c:if test="${business.status == 'SUSPENDED'}">
                    <c:set var="suspendedCount" value="${suspendedCount + 1}" />
                </c:if>
            </c:forEach>

            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">총 등록 업체</p>
                    <p class="text-2xl font-bold text-gray-900">${fn:length(businesses)}</p>
                </div>
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">승인 완료</p>
                    <p class="text-2xl font-bold text-emerald-600">${approvedCount}</p>
                </div>
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">승인 대기</p>
                    <p class="text-2xl font-bold text-yellow-600">${pendingCount}</p>
                </div>
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">정지 업체</p>
                    <p class="text-2xl font-bold text-red-500">${suspendedCount}</p>
                </div>
            </div>

            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="px-4 py-5 sm:px-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">업체 목록</h3>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">입점 신청 현황과 상태를 관리할 수 있습니다.</p>
                </div>
                <div class="px-4 py-5 sm:px-6 overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">업체명</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">대표자</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">카테고리</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">지역</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">신청일</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                            <th class="px-6 py-3"></th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="business" items="${businesses}">
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="text-sm font-semibold text-gray-900">${business.businessName}</div>
                                    <div class="text-sm text-gray-500">${business.email}</div>
                                    <div class="text-sm text-gray-500">리뷰 ${business.reviewCount}건</div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">${business.ownerName}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">${business.category}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">${business.location}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">${business.createdAt}</td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${business.status == 'APPROVED'}">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-emerald-100 text-emerald-800">승인</span>
                                        </c:when>
                                        <c:when test="${business.status == 'PENDING'}">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">대기</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">정지</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <form method="post" class="inline-flex space-x-2">
                                        <input type="hidden" name="businessId" value="${business.id}" />
                                        <c:choose>
                                            <c:when test="${business.status == 'PENDING'}">
                                                <button type="submit" name="action" value="approve" class="px-3 py-2 bg-blue-600 text-white text-sm rounded hover:bg-blue-700">승인</button>
                                                <button type="submit" name="action" value="reject" class="px-3 py-2 bg-gray-200 text-gray-700 text-sm rounded hover:bg-gray-300">거부</button>
                                            </c:when>
                                            <c:when test="${business.status == 'APPROVED'}">
                                                <button type="submit" name="action" value="suspend" class="px-3 py-2 bg-red-500 text-white text-sm rounded hover:bg-red-600">정지</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" name="action" value="approve" class="px-3 py-2 bg-emerald-500 text-white text-sm rounded hover:bg-emerald-600">재승인</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>
</body>
</html>
