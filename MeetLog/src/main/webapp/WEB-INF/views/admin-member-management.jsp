<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    <c:set var="adminMenu" scope="request" value="members" />
    <div class="min-h-screen flex flex-col">
        <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">회원 관리</h2>

                <!-- 통계 카드 -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-blue-500 rounded-md p-3">
                                <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                                </svg>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">총 회원 수</dt>
                                    <dd class="text-2xl font-bold text-gray-900">${fn:length(users)}</dd>
                                </dl>
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
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">활성 회원</dt>
                                    <dd class="text-2xl font-bold text-gray-900">
                                        <c:set var="activeCount" value="0"/>
                                        <c:forEach var="user" items="${users}">
                                            <c:if test="${user.isActive}">
                                                <c:set var="activeCount" value="${activeCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${activeCount}
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-purple-500 rounded-md p-3">
                                <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">사업자 회원</dt>
                                    <dd class="text-2xl font-bold text-gray-900">
                                        <c:set var="businessCount" value="0"/>
                                        <c:forEach var="user" items="${users}">
                                            <c:if test="${user.userType == 'BUSINESS'}">
                                                <c:set var="businessCount" value="${businessCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${businessCount}
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-red-500 rounded-md p-3">
                                <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                                </svg>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">정지된 회원</dt>
                                    <dd class="text-2xl font-bold text-gray-900">
                                        <c:set var="suspendedCount" value="0"/>
                                        <c:forEach var="user" items="${users}">
                                            <c:if test="${!user.isActive}">
                                                <c:set var="suspendedCount" value="${suspendedCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${suspendedCount}
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 검색 및 필터 -->
                <div class="bg-white shadow rounded-lg p-4 mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">검색</label>
                            <input type="text" id="searchInput" placeholder="이름, 이메일 검색..."
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">회원 유형</label>
                            <select id="typeFilter" class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                                <option value="">전체</option>
                                <option value="NORMAL">일반</option>
                                <option value="BUSINESS">사업자</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">상태</label>
                            <select id="statusFilter" class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                                <option value="">전체</option>
                                <option value="active">활성</option>
                                <option value="suspended">정지</option>
                            </select>
                        </div>
                        <div class="flex items-end">
                            <button onclick="resetFilters()" class="w-full bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition">
                                초기화
                            </button>
                        </div>
                    </div>
                </div>

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
                        <c:forEach var="user" items="${users}">
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10">
                                                <div class="h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center">
                                                    <span class="text-sm font-medium text-gray-700">${fn:substring(user.nickname,0,1)}</span>
                                                </div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="flex items-center">
                                                    <p class="text-sm font-medium text-gray-900">${user.nickname}</p>
                                                    <c:if test="${user.userType == 'BUSINESS'}">
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                            사업자
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${!user.isActive}">
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                            정지됨
                                                        </span>
                                                    </c:if>
                                                </div>
                                                <p class="text-sm text-gray-500">${user.email}</p>
                                                <p class="text-sm text-gray-500">가입일: ${user.createdAt}</p>
                                            </div>
                                        </div>
                                        <div class="flex space-x-2">
                                            <c:if test="${user.isActive}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="suspend">
                                                    <input type="hidden" name="memberId" value="${user.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                                                        정지
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${!user.isActive}">
                                                <form method="post" class="inline">
                                                    <input type="hidden" name="action" value="activate">
                                                    <input type="hidden" name="memberId" value="${user.id}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                                        활성화
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="memberId" value="${user.id}">
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

    <script>
        // 검색 및 필터링 기능
        const searchInput = document.getElementById('searchInput');
        const typeFilter = document.getElementById('typeFilter');
        const statusFilter = document.getElementById('statusFilter');
        const userRows = document.querySelectorAll('ul > li');

        function applyFilters() {
            const searchTerm = searchInput.value.toLowerCase();
            const typeValue = typeFilter.value;
            const statusValue = statusFilter.value;

            userRows.forEach(row => {
                const nickname = row.querySelector('.text-sm.font-medium.text-gray-900')?.textContent.toLowerCase() || '';
                const email = row.querySelectorAll('.text-sm.text-gray-500')[0]?.textContent.toLowerCase() || '';
                const userType = row.querySelector('.bg-blue-100')?.textContent.includes('사업자') ? 'BUSINESS' : 'NORMAL';
                const isActive = !row.querySelector('.bg-red-100');

                let showRow = true;

                // 검색어 필터
                if (searchTerm && !nickname.includes(searchTerm) && !email.includes(searchTerm)) {
                    showRow = false;
                }

                // 유형 필터
                if (typeValue && userType !== typeValue) {
                    showRow = false;
                }

                // 상태 필터
                if (statusValue) {
                    if (statusValue === 'active' && !isActive) showRow = false;
                    if (statusValue === 'suspended' && isActive) showRow = false;
                }

                row.style.display = showRow ? '' : 'none';
            });
        }

        function resetFilters() {
            searchInput.value = '';
            typeFilter.value = '';
            statusFilter.value = '';
            applyFilters();
        }

        searchInput.addEventListener('input', applyFilters);
        typeFilter.addEventListener('change', applyFilters);
        statusFilter.addEventListener('change', applyFilters);
    </script>

</body>
</html>
