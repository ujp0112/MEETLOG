<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 이벤트 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <c:set var="adminMenu" value="event" />
    <div class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/admin/include/admin-navbar.jspf" />

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">이벤트 관리</h2>
                    <button class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                        새 이벤트 추가
                    </button>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="bg-white shadow overflow-hidden sm:rounded-md">
                    <div class="px-4 py-5 sm:px-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">이벤트 목록</h3>
                        <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 이벤트를 관리할 수 있습니다.</p>
                    </div>
                    <ul class="divide-y divide-gray-200">
                        <c:forEach var="event" items="${events}">
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-16 w-16">
                                                <div class="h-16 w-16 rounded-lg bg-gradient-to-r from-blue-500 to-purple-600 flex items-center justify-center">
                                                    <span class="text-white text-lg font-bold">🎉</span>
                                                </div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="flex items-center">
                                                    <p class="text-lg font-medium text-gray-900">${event.title}</p>
                                                    <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${event.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : event.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800'}">
                                                        ${event.status == 'ACTIVE' ? '진행중' : event.status == 'PENDING' ? '대기중' : '종료됨'}
                                                    </span>
                                                </div>
                                                <p class="text-sm text-gray-500">${event.description}</p>
                                                <div class="flex items-center mt-1">
                                                    <span class="text-sm text-gray-500">기간: ${event.startDate} ~ ${event.endDate}</span>
                                                    <span class="ml-4 text-sm text-gray-500">참여자: ${event.participantCount}명</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <button class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                수정
                                            </button>
                                            <c:if test="${event.status == 'PENDING'}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="activate">
                                                    <input type="hidden" name="eventId" value="${event.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                        활성화
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${event.status == 'ACTIVE'}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="deactivate">
                                                    <input type="hidden" name="eventId" value="${event.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
                                                        비활성화
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="eventId" value="${event.id}">
                                                <button type="submit" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                                        onclick="return confirm('정말로 이 이벤트를 삭제하시겠습니까?')">
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
