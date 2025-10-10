<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 내 문의 내역</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex flex-col">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="max-w-4xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <div class="px-4 py-6 sm:px-0">
            <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-900">내 문의 내역</h2>
                <a href="${pageContext.request.contextPath}/inquiry" class="px-4 py-2 bg-blue-500 text-white rounded-md text-sm font-semibold hover:bg-blue-600 transition">
                    새 문의 작성하기
                </a>
            </div>

            <!-- 문의 목록 -->
            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">카테고리</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">제목</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">등록일</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="inquiry" items="${inquiries}">
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${inquiry.category}</td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        <div class="max-w-xs truncate" title="${inquiry.subject}">${inquiry.subject}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${inquiry.status == 'PENDING'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">답변 대기</span>
                                            </c:when>
                                            <c:when test="${inquiry.status == 'RESOLVED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">답변 완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">${inquiry.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <fmt:formatDate value="${inquiry.createdAt}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <button onclick="showInquiryDetail(${inquiry.id})" class="text-blue-600 hover:text-blue-900">상세보기</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty inquiries}">
                                <tr>
                                    <td colspan="5" class="px-6 py-8 text-center text-gray-500">
                                        작성한 문의가 없습니다.
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

<script>
function showInquiryDetail(inquiryId) {
    fetch('${pageContext.request.contextPath}/my-inquiries?action=detail&id=' + inquiryId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success === false) {
                alert(data.message);
                return;
            }

            var content =
                '<div class="space-y-4">' +
                    '<div>' +
                        '<p class="text-sm text-gray-600">제목</p>' +
                        '<p class="text-base font-medium">' + data.subject + '</p>' +
                    '</div>' +
                    '<div>' +
                        '<p class="text-sm text-gray-600">문의 내용</p>' +
                        '<div class="text-base whitespace-pre-wrap p-4 bg-gray-50 rounded-md mt-1">' + data.content + '</div>' +
                    '</div>';

            if (data.reply) {
                content +=
                    '<div>' +
                        '<p class="text-sm text-gray-600">답변 내용</p>' +
                        '<div class="text-base whitespace-pre-wrap bg-blue-50 p-4 rounded-md mt-1">' + data.reply + '</div>' +
                    '</div>';
            } else {
                content +=
                    '<div>' +
                        '<p class="text-sm text-gray-600">답변 내용</p>' +
                        '<div class="text-base whitespace-pre-wrap bg-yellow-50 p-4 rounded-md mt-1 text-yellow-700">아직 답변이 등록되지 않았습니다.</div>' +
                    '</div>';
            }

            content += '<div><p class="text-sm text-gray-600">등록일</p><p class="text-base">' + new Date(data.createdAt).toLocaleString() + '</p></div>';
            content += '</div>';

            document.getElementById('inquiryDetailContent').innerHTML = content;
            document.getElementById('inquiryDetailModal').classList.remove('hidden');
        })
        .catch(error => {
            console.error('Error:', error);
            alert('문의 상세 정보를 불러오는데 실패했습니다.');
        });
}

function closeDetailModal() {
    document.getElementById('inquiryDetailModal').classList.add('hidden');
}
</script>

</body>
</html>