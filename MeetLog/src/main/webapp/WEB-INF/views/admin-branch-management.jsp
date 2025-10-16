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
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- jQuery (Select2 dependency) -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <%-- 공통 스타일시트나 커스텀 CSS가 있다면 여기에 추가 --%>
    <style>
        /* Select2 Tailwind 스타일 조정 */
        .select2-container--default .select2-selection--single {
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            height: 2.5rem;
            padding: 0.375rem 0.75rem;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 1.5rem;
            padding-left: 0;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 2.5rem;
        }
        .select2-container--default.select2-container--focus .select2-selection--single {
            border-color: #3b82f6;
            outline: 2px solid transparent;
            outline-offset: 2px;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .select2-dropdown {
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
        }
        .select2-search--dropdown .select2-search__field {
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            padding: 0.375rem 0.75rem;
        }
        .select2-results__option--highlighted {
            background-color: #3b82f6 !important;
        }
    </style>
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" scope="request" value="branch" />
<div class="min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <c:set var="subNavBase" value="px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition" />
        <c:set var="subNavActive" value="px-3 py-2 text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg border border-blue-100" />
        <div class="px-4 py-6 sm:px-0">
                    <div class="flex flex-col gap-4 mb-6">
                        <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                            <h2 class="text-2xl font-bold text-gray-900">지점 관리</h2>
                            <button onclick="openAddModal()" class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition">
                                새 지점 추가
                            </button>
                        </div>
                        <!-- <div class="flex flex-wrap items-center gap-2">
                            <a href="${pageContext.request.contextPath}/admin/branch-management"
                               class="${subNavActive}">지점 목록</a>
                            <a href="${pageContext.request.contextPath}/admin/branch-statistics"
                               class="${subNavBase}">지점 통계</a>
                        </div> -->
                    </div>

                    <!-- 회사 검색 필터 -->
                    <div class="bg-white shadow rounded-lg p-4 mb-6">
                        <div class="flex items-center gap-4">
                            <label class="text-sm font-medium text-gray-700">회사 선택:</label>
                            <select id="companyFilter" onchange="filterByCompany()" class="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                                <option value="">전체 회사</option>
                                <c:forEach var="company" items="${companies}">
                                    <option value="${company.id}" ${selectedCompanyId == company.id ? 'selected' : ''}>
                                        ${company.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty selectedCompanyId}">
                                <span class="text-sm text-gray-500">총 ${branches.size()}개 지점</span>
                            </c:if>
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
                                                        <p class="text-lg font-medium text-gray-900">${branch.branchName}</p>
                                                        <c:if test="${not empty branch.companyName}">
	                                                        <span class="ml-2 text-xs text-gray-500">(${branch.companyName})</span>
							                            </c:if>	
                                                        <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${branch.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                                            ${branch.status == 'ACTIVE' ? '운영중' : '휴업'}
                                                        </span>
                                                    </div>
                                                    <p class="text-sm text-gray-500">${branch.address}</p>
                                                    <div class="flex items-center mt-1">
                                                        <span class="text-sm text-gray-500">전화: ${branch.phone}</span>
                                                        <span class="ml-4 text-sm text-gray-500">지점장: ${branch.managerName}</span>
                                                        <span class="ml-4 text-sm text-gray-500">직원: ${branch.employeeCount}명</span>
                                                        <!-- <span class="ml-4 text-sm text-gray-500">월매출:
                                                            <fmt:formatNumber value="${branch.monthlyRevenue}" type="currency" currencySymbol="₩"/>
                                                        </span> -->
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="flex space-x-2">
                                                <button onclick="openEditModal(${branch.branchId}, '${branch.branchName}', '${branch.address}', '${branch.phone}', '${branch.managerName}')" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                    수정
                                                </button>
                                                <c:if test="${branch.status == 'INACTIVE'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="action" value="activate">
                                                        <input type="hidden" name="branchId" value="${branch.branchId}">
                                                        <input type="hidden" name="companyId" value="${selectedCompanyId}">
                                                        <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                            운영 시작
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${branch.status == 'ACTIVE'}">
                                                    <form method="post" class="inline">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="branchId" value="${branch.branchId}">
                                                        <input type="hidden" name="companyId" value="${selectedCompanyId}">
                                                        <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
                                                            휴업
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <form method="post" class="inline" onsubmit="return confirm('정말로 이 지점을 삭제하시겠습니까?')">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="branchId" value="${branch.branchId}">
                                                    <input type="hidden" name="companyId" value="${selectedCompanyId}">
                                                    <button type="submit" class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
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

<!-- 지점 추가 모달 -->
<div id="addModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden overflow-y-auto h-full w-full z-50">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">새 지점 추가</h3>
            <form method="post" action="${pageContext.request.contextPath}/admin/branch-management">
                <input type="hidden" name="action" value="add">

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">회사</label>
                    <select id="companySelect" name="companyId" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">회사 선택</option>
                        <c:forEach var="company" items="${companies}">
                            <option value="${company.id}" ${selectedCompanyId == company.id ? 'selected' : ''}>${company.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">지점명</label>
                    <input type="text" name="branchName" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">주소</label>
                    <input type="text" name="address" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">전화번호</label>
                    <input type="text" name="phone" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">지점장명</label>
                    <input type="text" name="managerName" class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="flex justify-end space-x-2 mt-5">
                    <button type="button" onclick="closeAddModal()" class="px-4 py-2 bg-gray-300 text-gray-700 rounded-md hover:bg-gray-400">
                        취소
                    </button>
                    <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">
                        추가
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 지점 수정 모달 -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden overflow-y-auto h-full w-full z-50">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">지점 수정</h3>
            <form method="post" action="${pageContext.request.contextPath}/admin/branch-management">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="branchId" id="editBranchId">
                <input type="hidden" name="companyId" value="${selectedCompanyId}">

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">지점명</label>
                    <input type="text" name="branchName" id="editBranchName" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">주소</label>
                    <input type="text" name="address" id="editAddress" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">전화번호</label>
                    <input type="text" name="phone" id="editPhone" required class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">지점장명</label>
                    <input type="text" name="managerName" id="editManagerName" class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="flex justify-end space-x-2 mt-5">
                    <button type="button" onclick="closeEditModal()" class="px-4 py-2 bg-gray-300 text-gray-700 rounded-md hover:bg-gray-400">
                        취소
                    </button>
                    <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">
                        수정
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Select2 초기화 - 필터 select
    $('#companyFilter').select2({
        placeholder: '전체 회사',
        allowClear: true,
        width: '300px',
        language: {
            noResults: function() {
                return '검색 결과가 없습니다.';
            },
            searching: function() {
                return '검색 중...';
            }
        }
    });

    // Select2 초기화 - 모달 내 select
    $('#companySelect').select2({
        placeholder: '회사 선택',
        dropdownParent: $('#addModal'),
        width: '100%',
        language: {
            noResults: function() {
                return '검색 결과가 없습니다.';
            },
            searching: function() {
                return '검색 중...';
            }
        }
    });
});

function filterByCompany() {
    const companyId = document.getElementById('companyFilter').value;
    const url = '${pageContext.request.contextPath}/admin/branch-management' + (companyId ? '?companyId=' + companyId : '');
    window.location.href = url;
}

function openAddModal() {
    document.getElementById('addModal').classList.remove('hidden');
    // Select2가 모달 내에서 제대로 작동하도록 재초기화
    setTimeout(function() {
        $('#companySelect').select2('open');
    }, 100);
}

function closeAddModal() {
    document.getElementById('addModal').classList.add('hidden');
}

function openEditModal(branchId, branchName, address, phone, managerName) {
    document.getElementById('editBranchId').value = branchId;
    document.getElementById('editBranchName').value = branchName;
    document.getElementById('editAddress').value = address;
    document.getElementById('editPhone').value = phone;
    document.getElementById('editManagerName').value = managerName || '';
    document.getElementById('editModal').classList.remove('hidden');
}

function closeEditModal() {
    document.getElementById('editModal').classList.add('hidden');
}

// 모달 외부 클릭 시 닫기
window.onclick = function(event) {
    const addModal = document.getElementById('addModal');
    const editModal = document.getElementById('editModal');
    if (event.target == addModal) {
        closeAddModal();
    } else if (event.target == editModal) {
        closeEditModal();
    }
}
</script>

</body>
</html>