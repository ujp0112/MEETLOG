<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 코스 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" scope="request" value="course" />
<div class="min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <c:set var="subNavBase" value="px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition" />
        <c:set var="subNavActive" value="px-3 py-2 text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg border border-blue-100" />
        <div class="px-4 py-6 sm:px-0">
            <div class="flex flex-col gap-4 mb-6">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <h2 class="text-2xl font-bold text-gray-900">코스 관리</h2>
                    <button class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition">
                        새 코스 추가
                    </button>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/course-management"
                       class="${subNavActive}">코스 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/course-reservation"
                       class="${subNavBase}">예약 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/reservation-statistics"
                       class="${subNavBase}">예약 통계</a>
                    <a href="${pageContext.request.contextPath}/admin/course-statistics"
                       class="${subNavBase}">코스 통계</a>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                            ${successMessage}
                        </div>
                    </c:if>
                    
                    <div class="bg-white shadow overflow-hidden sm:rounded-md">
                        <div class="px-4 py-5 sm:px-6">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">코스 목록</h3>
                            <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 코스를 관리할 수 있습니다.</p>
                        </div>
                        <ul class="divide-y divide-gray-200">
                            <c:forEach var="course" items="${courses}">
                                <li>
                                    <div class="px-4 py-4 sm:px-6">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-16 w-16">
                                                    <c:choose>
                                                        <c:when test="${not empty course.previewImage}">
                                                            <img src="${course.previewImage}" alt="${course.title}" class="h-16 w-16 rounded-lg object-cover">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="h-16 w-16 rounded-lg bg-gradient-to-r from-green-500 to-blue-600 flex items-center justify-center">
                                                                <span class="text-white text-lg font-bold">🚶</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="flex items-center gap-2">
                                                        <p class="text-lg font-medium text-gray-900">${course.title}</p>
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${course.type == 'OFFICIAL' ? 'bg-purple-100 text-purple-800' : 'bg-blue-100 text-blue-800'}">
                                                            ${course.type == 'OFFICIAL' ? '공식' : '커뮤니티'}
                                                        </span>
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${course.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : course.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800'}">
                                                            ${course.status == 'ACTIVE' ? '진행중' : course.status == 'PENDING' ? '대기중' : '종료됨'}
                                                        </span>
                                                    </div>
                                                    <p class="text-sm text-gray-500 mt-1">${course.description}</p>
                                                    <div class="flex items-center mt-1 text-xs text-gray-500">
                                                        <c:if test="${not empty course.authorName}">
                                                            <span>작성자: ${course.authorName}</span>
                                                            <span class="mx-2">•</span>
                                                        </c:if>
                                                        <span>예약: ${course.reservationCount}건</span>
                                                        <c:if test="${not empty course.area}">
                                                            <span class="mx-2">•</span>
                                                            <span>지역: ${course.area}</span>
                                                        </c:if>
                                                        <c:if test="${not empty course.duration}">
                                                            <span class="mx-2">•</span>
                                                            <span>소요: ${course.duration}</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="flex space-x-2">
                                                <button class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                    수정
                                                </button>
                                                <c:if test="${course.status == 'PENDING'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="action" value="activate">
                                                        <input type="hidden" name="courseId" value="${course.id}">
                                                        <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                            활성화
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${course.status == 'ACTIVE'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="courseId" value="${course.id}">
                                                        <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
                                                            비활성화
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="courseId" value="${course.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                                            onclick="return confirm('정말로 이 코스를 삭제하시겠습니까?')">
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