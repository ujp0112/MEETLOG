<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 문의 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" scope="request" value="inquiry" />
<div class="min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <div class="px-4 py-6 sm:px-0">
            <div class="flex flex-col gap-4 mb-6">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <h2 class="text-2xl font-bold text-gray-900">문의 관리</h2>
                </div>
            </div>

            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-12 h-12 bg-blue-500 rounded-md flex items-center justify-center">
                                    <span class="text-white text-xl font-medium">📋</span>
                                </div>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">총 문의</dt>
                                    <dd class="text-2xl font-bold text-gray-900">${totalInquiries}</dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-12 h-12 bg-yellow-500 rounded-md flex items-center justify-center">
                                    <span class="text-white text-xl font-medium">⏳</span>
                                </div>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">대기 중</dt>
                                    <dd class="text-2xl font-bold text-gray-900">${pendingCount}</dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-12 h-12 bg-green-500 rounded-md flex items-center justify-center">
                                    <span class="text-white text-xl font-medium">✅</span>
                                </div>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">처리 완료</dt>
                                    <dd class="text-2xl font-bold text-gray-900">${resolvedCount}</dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                    ${successMessage}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                    ${errorMessage}
                </div>
            </c:if>

            <!-- 문의 목록 -->
            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">문의 목록</h3>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">사용자가 등록한 1:1 문의 내역입니다.</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">번호</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">작성자</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">제목</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">등록일</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="inquiry" items="${inquiries}" varStatus="status">
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${inquiry.inquiryId}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${inquiry.userName}</td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        <div class="max-w-xs truncate" title="${inquiry.subject}">${inquiry.subject}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${inquiry.status == 'PENDING'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">대기 중</span>
                                            </c:when>
                                            <c:when test="${inquiry.status == 'IN_PROGRESS'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">처리 중</span>
                                            </c:when>
                                            <c:when test="${inquiry.status == 'RESOLVED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">${inquiry.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <fmt:formatDate value="${inquiry.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <button onclick="showInquiryDetail(${inquiry.inquiryId})" class="text-blue-600 hover:text-blue-900 mr-3">상세보기</button>
                                        <c:if test="${inquiry.status != 'RESOLVED'}">
                                            <button onclick="showReplyForm(${inquiry.inquiryId})" class="text-green-600 hover:text-green-900">답변</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty inquiries}">
                                <tr>
                                    <td colspan="6" class="px-6 py-8 text-center text-gray-500">
                                        등록된 문의가 없습니다.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>

<!-- 문의 상세 모달 -->
<div id="inquiryDetailModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
    <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">문의 상세</h3>
            <div id="inquiryDetailContent" class="mt-2 px-7 py-3">
                <!-- 동적으로 내용이 채워집니다 -->
            </div>
            <div class="flex justify-end mt-4">
                <button onclick="closeDetailModal()" class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 답변 작성 모달 -->
<div id="replyModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
    <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">답변 작성</h3>
            <form id="replyForm" method="post" action="${pageContext.request.contextPath}/admin/inquiry-management">
                <input type="hidden" name="action" value="reply">
                <input type="hidden" name="inquiryId" id="replyInquiryId">
                <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-bold mb-2">답변 내용</label>
                    <textarea name="reply" rows="6" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"></textarea>
                </div>
                <div class="flex justify-end gap-2">
                    <button type="button" onclick="closeReplyModal()" class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">취소</button>
                    <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">답변 등록</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function showInquiryDetail(inquiryId) {
    fetch('${pageContext.request.contextPath}/admin/inquiry-management?action=detail&id=' + inquiryId)
        .then(response => response.json())
        .then(data => {
            const content = `
                <div class="space-y-4">
                    <div>
                        <p class="text-sm text-gray-600">작성자</p>
                        <p class="text-base font-medium">${'${data.userName}'}</p>
                    </div>
                    <div>
                        <p class="text-sm text-gray-600">제목</p>
                        <p class="text-base font-medium">${'${data.subject}'}</p>
                    </div>
                    <div>
                        <p class="text-sm text-gray-600">문의 내용</p>
                        <p class="text-base whitespace-pre-wrap">${'${data.content}'}</p>
                    </div>
                    ${'${data.reply ? `<div><p class="text-sm text-gray-600">답변</p><p class="text-base whitespace-pre-wrap bg-blue-50 p-4 rounded">${data.reply}</p></div>` : ""}'}
                    <div>
                        <p class="text-sm text-gray-600">등록일</p>
                        <p class="text-base">${'${data.createdAt}'}</p>
                    </div>
                </div>
            `;
            document.getElementById('inquiryDetailContent').innerHTML = content;
            document.getElementById('inquiryDetailModal').classList.remove('hidden');
        })
        .catch(error => {
            console.error('Error:', error);
            alert('문의 상세 정보를 불러오는데 실패했습니다.');
        });
}

function showReplyForm(inquiryId) {
    document.getElementById('replyInquiryId').value = inquiryId;
    document.getElementById('replyModal').classList.remove('hidden');
}

function closeDetailModal() {
    document.getElementById('inquiryDetailModal').classList.add('hidden');
}

function closeReplyModal() {
    document.getElementById('replyModal').classList.add('hidden');
    document.getElementById('replyForm').reset();
}
</script>

</body>
</html>
