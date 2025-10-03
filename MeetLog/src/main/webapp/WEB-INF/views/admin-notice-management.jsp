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

    <c:set var="adminMenu" scope="request" value="notice" />
    <div class="min-h-screen flex flex-col">
        <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
            <div class="px-4 py-6 sm:px-0">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">공지사항 관리</h2>
                    <button onclick="openAddModal()" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                        새 공지사항 작성
                    </button>
                </div>

                <div id="successMessage" class="hidden bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6"></div>
                <div id="errorMessage" class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6"></div>

                <div class="bg-white shadow overflow-hidden sm:rounded-md">
                    <div class="px-4 py-5 sm:px-6 flex justify-between items-center">
                        <div>
                            <h3 class="text-lg leading-6 font-medium text-gray-900">공지사항 목록</h3>
                            <p class="mt-1 max-w-2xl text-sm text-gray-500">총 ${totalNotices}개의 공지사항이 있습니다.</p>
                        </div>
                    </div>
                    <ul class="divide-y divide-gray-200">
                        <c:choose>
                            <c:when test="${empty notices}">
                                <li class="px-4 py-8 text-center text-sm text-gray-500">
                                    등록된 공지사항이 없습니다.
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="notice" items="${notices}">
                                    <li id="notice-${notice.id}">
                                        <div class="px-4 py-4 sm:px-6">
                                            <div class="flex items-center justify-between">
                                                <div class="flex items-center flex-1">
                                                    <div class="flex-shrink-0 h-12 w-12">
                                                        <div class="h-12 w-12 rounded-lg bg-blue-100 flex items-center justify-center">
                                                            <span class="text-blue-600 text-lg">📢</span>
                                                        </div>
                                                    </div>
                                                    <div class="ml-4 flex-1">
                                                        <p class="text-lg font-medium text-gray-900">${notice.title}</p>
                                                        <p class="text-sm text-gray-500 mt-1 line-clamp-2">${notice.content}</p>
                                                        <span class="text-xs text-gray-400 mt-1 inline-block">
                                                            <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/>
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="flex space-x-2 ml-4">
                                                    <button onclick="openEditModal(${notice.id}, '${notice.title}', `${notice.content}`)"
                                                            class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                        수정
                                                    </button>
                                                    <button onclick="deleteNotice(${notice.id})"
                                                            class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-red-700 bg-white hover:bg-red-50">
                                                        삭제
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />

    <!-- 추가 모달 -->
    <div id="addModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-2/3 lg:w-1/2 shadow-lg rounded-md bg-white">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-medium text-gray-900">새 공지사항 작성</h3>
                <button onclick="closeAddModal()" class="text-gray-400 hover:text-gray-500">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
            <form id="addForm" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700">제목 *</label>
                    <input type="text" id="addTitle" required
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700">내용 *</label>
                    <textarea id="addContent" required rows="6"
                              class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500"></textarea>
                </div>
                <div class="flex justify-end space-x-3 pt-4">
                    <button type="button" onclick="closeAddModal()"
                            class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                        취소
                    </button>
                    <button type="submit"
                            class="px-4 py-2 bg-blue-500 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-600">
                        등록
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 수정 모달 -->
    <div id="editModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-2/3 lg:w-1/2 shadow-lg rounded-md bg-white">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-medium text-gray-900">공지사항 수정</h3>
                <button onclick="closeEditModal()" class="text-gray-400 hover:text-gray-500">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
            <form id="editForm" class="space-y-4">
                <input type="hidden" id="editId">
                <div>
                    <label class="block text-sm font-medium text-gray-700">제목 *</label>
                    <input type="text" id="editTitle" required
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700">내용 *</label>
                    <textarea id="editContent" required rows="6"
                              class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500"></textarea>
                </div>
                <div class="flex justify-end space-x-3 pt-4">
                    <button type="button" onclick="closeEditModal()"
                            class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                        취소
                    </button>
                    <button type="submit"
                            class="px-4 py-2 bg-blue-500 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-600">
                        수정
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById('addModal').classList.remove('hidden');
        }
        function closeAddModal() {
            document.getElementById('addModal').classList.add('hidden');
            document.getElementById('addForm').reset();
        }
        function openEditModal(id, title, content) {
            document.getElementById('editId').value = id;
            document.getElementById('editTitle').value = title;
            document.getElementById('editContent').value = content;
            document.getElementById('editModal').classList.remove('hidden');
        }
        function closeEditModal() {
            document.getElementById('editModal').classList.add('hidden');
            document.getElementById('editForm').reset();
        }

        document.getElementById('addForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const title = document.getElementById('addTitle').value;
            const content = document.getElementById('addContent').value;

            const formData = new URLSearchParams();
            formData.append('action', 'create');
            formData.append('title', title);
            formData.append('content', content);

            const response = await fetch('${pageContext.request.contextPath}/admin/notice-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData
            });
            const result = await response.json();

            if (result.success) {
                showMessage(result.message, 'success');
                closeAddModal();
                setTimeout(() => location.reload(), 1000);
            } else {
                showMessage(result.message, 'error');
            }
        });

        document.getElementById('editForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const id = document.getElementById('editId').value;
            const title = document.getElementById('editTitle').value;
            const content = document.getElementById('editContent').value;

            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('id', id);
            formData.append('title', title);
            formData.append('content', content);

            const response = await fetch('${pageContext.request.contextPath}/admin/notice-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData
            });
            const result = await response.json();

            if (result.success) {
                showMessage(result.message, 'success');
                closeEditModal();
                setTimeout(() => location.reload(), 1000);
            } else {
                showMessage(result.message, 'error');
            }
        });

        async function deleteNotice(id) {
            if (!confirm('정말로 이 공지사항을 삭제하시겠습니까?')) return;

            const formData = new URLSearchParams();
            formData.append('action', 'delete');
            formData.append('id', id);

            const response = await fetch('${pageContext.request.contextPath}/admin/notice-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData
            });
            const result = await response.json();

            if (result.success) {
                showMessage(result.message, 'success');
                document.getElementById('notice-' + id).remove();
                setTimeout(() => location.reload(), 1000);
            } else {
                showMessage(result.message, 'error');
            }
        }

        function showMessage(message, type) {
            const successEl = document.getElementById('successMessage');
            const errorEl = document.getElementById('errorMessage');

            if (type === 'success') {
                successEl.textContent = message;
                successEl.classList.remove('hidden');
                errorEl.classList.add('hidden');
            } else {
                errorEl.textContent = message;
                errorEl.classList.remove('hidden');
                successEl.classList.add('hidden');
            }

            setTimeout(() => {
                successEl.classList.add('hidden');
                errorEl.classList.add('hidden');
            }, 3000);
        }
    </script>

</body>
</html>
