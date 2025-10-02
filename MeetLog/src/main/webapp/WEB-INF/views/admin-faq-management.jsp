<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - FAQ 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" value="faq" />
<div class="min-h-screen flex flex-col">
    <jsp:include page="/WEB-INF/views/admin/include/admin-navbar.jspf" />

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <div class="px-4 py-6 sm:px-0 space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">총 등록 FAQ</p>
                    <p class="text-2xl font-bold text-gray-900">${totalFaqs}</p>
                </div>
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">노출 중인 FAQ</p>
                    <p class="text-2xl font-bold text-emerald-600">${activeFaqs}</p>
                </div>
                <div class="bg-white shadow rounded-lg p-4">
                    <p class="text-sm text-gray-500">카테고리 수</p>
                    <p class="text-2xl font-bold text-blue-600">${fn:length(categories)}</p>
                </div>
            </div>

            <div class="bg-white shadow rounded-lg p-6">
                <h2 class="text-lg font-semibold text-gray-900 mb-4">FAQ 등록</h2>
                <form id="createFaqForm" method="post">
                    <input type="hidden" name="action" value="create" />
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">카테고리</label>
                            <input type="text" name="category" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" placeholder="예: 회원, 예약" required />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">표시 순서</label>
                            <input type="number" name="displayOrder" min="0" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" placeholder="숫자가 작을수록 상단에 노출" />
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700">질문</label>
                            <input type="text" name="question" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required />
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700">답변</label>
                            <textarea name="answer" rows="4" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required></textarea>
                        </div>
                    </div>
                    <div class="mt-4 flex justify-end">
                        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">등록하기</button>
                    </div>
                </form>
            </div>

            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="px-4 py-5 sm:px-6 flex items-center justify-between">
                    <div>
                        <h3 class="text-lg leading-6 font-medium text-gray-900">FAQ 목록</h3>
                        <p class="mt-1 max-w-2xl text-sm text-gray-500">등록된 FAQ를 수정하거나 노출 여부를 변경할 수 있습니다.</p>
                    </div>
                    <div>
                        <select id="categoryFilter" class="border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500">
                            <option value="">전체 카테고리</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}">${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="px-4 py-5 sm:px-6">
                    <div class="space-y-4" id="faqList">
                        <c:forEach var="faq" items="${faqs}">
                            <div class="border border-gray-200 rounded-lg p-4" data-category="${faq.category}">
                                <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
                                    <div class="flex-1">
                                        <div class="flex items-center gap-2 mb-2">
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-indigo-100 text-indigo-700">${faq.category}</span>
                                            <c:if test="${faq.active}">
                                                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold bg-emerald-100 text-emerald-700">노출</span>
                                            </c:if>
                                        </div>
                                        <h4 class="text-lg font-semibold text-gray-900">Q. ${faq.question}</h4>
                                        <p class="mt-2 text-gray-700 leading-relaxed">A. ${faq.answer}</p>
                                    </div>
                                    <div class="flex flex-col items-end space-y-2">
                                        <span class="text-sm text-gray-500">표시 순서: ${faq.displayOrder}</span>
                                        <div class="flex space-x-2">
                                            <button type="button"
                                                    class="px-3 py-2 bg-blue-600 text-white text-sm rounded hover:bg-blue-700"
                                                    data-faq-id="${faq.id}"
                                                    data-faq-category="${faq.category}"
                                                    data-faq-question="${fn:escapeXml(faq.question)}"
                                                    data-faq-answer="${fn:escapeXml(faq.answer)}"
                                                    data-faq-order="${faq.displayOrder}"
                                                    data-faq-active="${faq.active}"
                                                    onclick="openEditModalFromButton(this)">수정</button>
                                            <form method="post">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="id" value="${faq.id}" />
                                                <button type="submit" class="px-3 py-2 bg-red-500 text-white text-sm rounded hover:bg-red-600" onclick="return confirm('해당 FAQ를 삭제하시겠습니까?')">삭제</button>
                                            </form>
                                            <form method="post">
                                                <input type="hidden" name="action" value="toggleStatus" />
                                                <input type="hidden" name="id" value="${faq.id}" />
                                                <button type="submit" class="px-3 py-2 bg-gray-200 text-gray-700 text-sm rounded hover:bg-gray-300">
                                                    <c:choose>
                                                        <c:when test="${faq.active}">숨기기</c:when>
                                                        <c:otherwise>노출</c:otherwise>
                                                    </c:choose>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>

<!-- 수정 모달 -->
<div id="editModal" class="fixed inset-0 bg-black/40 hidden items-center justify-center">
    <div class="bg-white rounded-lg shadow-lg w-full max-w-2xl p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">FAQ 수정</h3>
        <form id="editFaqForm" method="post">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="id" id="editFaqId" />
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700">카테고리</label>
                    <input type="text" name="category" id="editFaqCategory" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required />
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700">표시 순서</label>
                    <input type="number" name="displayOrder" id="editFaqOrder" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700">질문</label>
                    <input type="text" name="question" id="editFaqQuestion" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required />
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700">답변</label>
                    <textarea name="answer" id="editFaqAnswer" rows="4" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required></textarea>
                </div>
                <div class="flex items-center space-x-2">
                    <input type="checkbox" id="editFaqActive" name="isActive" value="true" class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                    <label for="editFaqActive" class="text-sm text-gray-700">노출</label>
                </div>
            </div>
            <div class="mt-6 flex justify-end space-x-3">
                <button type="button" onclick="closeEditModal()" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">취소</button>
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">저장</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModalFromButton(button) {
        const dataset = button.dataset;
        document.getElementById('editFaqId').value = dataset.faqId;
        document.getElementById('editFaqCategory').value = dataset.faqCategory;
        document.getElementById('editFaqQuestion').value = dataset.faqQuestion;
        document.getElementById('editFaqAnswer').value = dataset.faqAnswer;
        document.getElementById('editFaqOrder').value = dataset.faqOrder || 0;
        document.getElementById('editFaqActive').checked = dataset.faqActive === 'true';
        document.getElementById('editModal').classList.remove('hidden');
        document.getElementById('editModal').classList.add('flex');
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
        document.getElementById('editModal').classList.remove('flex');
    }

    document.getElementById('categoryFilter').addEventListener('change', function() {
        const selected = this.value;
        document.querySelectorAll('#faqList > div').forEach(item => {
            if (!selected || item.dataset.category === selected) {
                item.classList.remove('hidden');
            } else {
                item.classList.add('hidden');
            }
        });
    });
</script>
</body>
</html>
