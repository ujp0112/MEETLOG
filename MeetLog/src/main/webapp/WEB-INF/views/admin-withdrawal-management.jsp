<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="adminMenu" value="withdrawal" scope="request" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>출금 신청 관리 - MEET LOG Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .status-pending { background-color: #fef9c3; color: #a16207; }
        .status-approved { background-color: #dcfce7; color: #166534; }
        .status-rejected { background-color: #fee2e2; color: #991b1b; }
        .status-completed { background-color: #e0e7ff; color: #3730a3; }
    </style>
</head>
<body class="bg-gray-50">
    <div id="app" class="flex flex-col min-h-screen">
        <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

        <main class="flex-grow container mx-auto p-4 md:p-8">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-slate-800 mb-2">출금 신청 관리</h1>
                <p class="text-slate-600">사업자의 예약금 출금 신청을 검토하고 승인/거절/완료 처리할 수 있습니다.</p>
            </div>

            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                    <div class="text-2xl font-bold text-sky-600">${totalCount}</div>
                    <div class="text-sm text-slate-600">전체 신청</div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                    <div class="text-2xl font-bold text-yellow-600">${pendingCount}</div>
                    <div class="text-sm text-slate-600">대기중</div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                    <div class="text-2xl font-bold text-green-600">${approvedCount}</div>
                    <div class="text-sm text-slate-600">승인됨</div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                    <div class="text-2xl font-bold text-indigo-600">${completedCount}</div>
                    <div class="text-sm text-slate-600">완료됨</div>
                </div>
            </div>

            <!-- 필터링 -->
            <div class="bg-white p-6 rounded-xl shadow-lg mb-6">
                <form method="get" action="${pageContext.request.contextPath}/admin/withdrawals" class="flex gap-4 items-end">
                    <div class="flex-1">
                        <label class="block text-sm font-semibold text-slate-700 mb-2">상태</label>
                        <select name="status" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500">
                            <option value="">전체</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>대기중</option>
                            <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>승인됨</option>
                            <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>거절됨</option>
                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>완료됨</option>
                        </select>
                    </div>
                    <button type="submit" class="bg-sky-600 hover:bg-sky-700 text-white px-6 py-2 rounded-lg font-semibold transition-all">
                        검색
                    </button>
                </form>
            </div>

            <!-- 출금 신청 목록 -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <c:choose>
                    <c:when test="${not empty withdrawals}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-slate-200">
                                <thead class="bg-slate-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">신청 ID</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">사업자</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">신청 금액</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">은행 정보</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">신청 날짜</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">상태</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">작업</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-slate-200">
                                    <c:forEach items="${withdrawals}" var="withdrawal">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-slate-900">#${withdrawal.id}</td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-slate-900">${withdrawal.ownerName}</div>
                                                <div class="text-xs text-slate-500">${withdrawal.ownerEmail}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-sky-600">
                                                ${withdrawal.formattedRequestAmount}원
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm text-slate-900">${withdrawal.bankName}</div>
                                                <div class="text-xs text-slate-500">${withdrawal.accountNumber}</div>
                                                <div class="text-xs text-slate-500">${withdrawal.accountHolder}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-500">
                                                ${withdrawal.formattedCreatedAt}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full status-${withdrawal.status.toLowerCase()}">
                                                    ${withdrawal.statusInKorean}
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                                <c:choose>
                                                    <c:when test="${withdrawal.status == 'PENDING'}">
                                                        <button onclick="openApproveModal(${withdrawal.id}, '${withdrawal.ownerName}', ${withdrawal.requestAmount})"
                                                                class="bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded-md text-xs font-semibold mr-2">
                                                            승인
                                                        </button>
                                                        <button onclick="openRejectModal(${withdrawal.id}, '${withdrawal.ownerName}', ${withdrawal.requestAmount})"
                                                                class="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded-md text-xs font-semibold">
                                                            거절
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${withdrawal.status == 'APPROVED'}">
                                                        <button onclick="openCompleteModal(${withdrawal.id}, '${withdrawal.ownerName}', ${withdrawal.requestAmount})"
                                                                class="bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-1 rounded-md text-xs font-semibold">
                                                            완료 처리
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-slate-400 text-xs">처리 완료</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">💰</div>
                            <p class="text-slate-500">출금 신청이 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <!-- 승인 모달 -->
    <div id="approveModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50" style="display: none;">
        <div class="bg-white p-8 rounded-xl max-w-md w-full mx-4">
            <h3 class="text-xl font-bold text-slate-800 mb-4">출금 승인</h3>
            <p class="text-slate-600 mb-4">
                <span id="approveOwnerName"></span>님의 출금 신청 (<span id="approveAmount"></span>원)을 승인하시겠습니까?
            </p>
            <form id="approveForm" onsubmit="submitApprove(event)">
                <input type="hidden" id="approveWithdrawalId" name="withdrawalId">
                <div class="mb-4">
                    <label class="block text-sm font-semibold text-slate-700 mb-2">관리자 메모 (선택)</label>
                    <textarea id="approveMemo" name="adminMemo" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500" rows="3"></textarea>
                </div>
                <div class="flex space-x-3">
                    <button type="button" onclick="closeApproveModal()" class="flex-1 bg-slate-200 hover:bg-slate-300 text-slate-700 px-4 py-2 rounded-lg font-semibold">취소</button>
                    <button type="submit" class="flex-1 bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg font-semibold">승인</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 거절 모달 -->
    <div id="rejectModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50" style="display: none;">
        <div class="bg-white p-8 rounded-xl max-w-md w-full mx-4">
            <h3 class="text-xl font-bold text-slate-800 mb-4">출금 거절</h3>
            <p class="text-slate-600 mb-4">
                <span id="rejectOwnerName"></span>님의 출금 신청 (<span id="rejectAmount"></span>원)을 거절하시겠습니까?
            </p>
            <form id="rejectForm" onsubmit="submitReject(event)">
                <input type="hidden" id="rejectWithdrawalId" name="withdrawalId">
                <div class="mb-4">
                    <label class="block text-sm font-semibold text-slate-700 mb-2">거절 사유 (필수)</label>
                    <textarea id="rejectMemo" name="adminMemo" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500" rows="3" required></textarea>
                </div>
                <div class="flex space-x-3">
                    <button type="button" onclick="closeRejectModal()" class="flex-1 bg-slate-200 hover:bg-slate-300 text-slate-700 px-4 py-2 rounded-lg font-semibold">취소</button>
                    <button type="submit" class="flex-1 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-semibold">거절</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 완료 모달 -->
    <div id="completeModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50" style="display: none;">
        <div class="bg-white p-8 rounded-xl max-w-md w-full mx-4">
            <h3 class="text-xl font-bold text-slate-800 mb-4">출금 완료 처리</h3>
            <p class="text-slate-600 mb-4">
                <span id="completeOwnerName"></span>님의 출금 신청 (<span id="completeAmount"></span>원)을 완료 처리하시겠습니까?
            </p>
            <form id="completeForm" onsubmit="submitComplete(event)">
                <input type="hidden" id="completeWithdrawalId" name="withdrawalId">
                <div class="mb-4">
                    <label class="block text-sm font-semibold text-slate-700 mb-2">관리자 메모 (선택)</label>
                    <textarea id="completeMemo" name="adminMemo" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500" rows="3"></textarea>
                </div>
                <div class="flex space-x-3">
                    <button type="button" onclick="closeCompleteModal()" class="flex-1 bg-slate-200 hover:bg-slate-300 text-slate-700 px-4 py-2 rounded-lg font-semibold">취소</button>
                    <button type="submit" class="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg font-semibold">완료</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 승인 모달
        function openApproveModal(id, ownerName, amount) {
            document.getElementById('approveWithdrawalId').value = id;
            document.getElementById('approveOwnerName').textContent = ownerName;
            document.getElementById('approveAmount').textContent = new Intl.NumberFormat('ko-KR').format(amount);
            document.getElementById('approveModal').style.display = 'flex';
        }

        function closeApproveModal() {
            document.getElementById('approveModal').style.display = 'none';
            document.getElementById('approveForm').reset();
        }

        function submitApprove(event) {
            event.preventDefault();
            const withdrawalId = document.getElementById('approveWithdrawalId').value;
            const adminMemo = document.getElementById('approveMemo').value;

            fetch('${pageContext.request.contextPath}/admin/withdrawals/approve', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    withdrawalId: withdrawalId,
                    adminMemo: adminMemo
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('승인되었습니다.');
                    location.reload();
                } else {
                    alert('승인 처리 중 오류가 발생했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('승인 처리 중 오류가 발생했습니다.');
            });
        }

        // 거절 모달
        function openRejectModal(id, ownerName, amount) {
            document.getElementById('rejectWithdrawalId').value = id;
            document.getElementById('rejectOwnerName').textContent = ownerName;
            document.getElementById('rejectAmount').textContent = new Intl.NumberFormat('ko-KR').format(amount);
            document.getElementById('rejectModal').style.display = 'flex';
        }

        function closeRejectModal() {
            document.getElementById('rejectModal').style.display = 'none';
            document.getElementById('rejectForm').reset();
        }

        function submitReject(event) {
            event.preventDefault();
            const withdrawalId = document.getElementById('rejectWithdrawalId').value;
            const adminMemo = document.getElementById('rejectMemo').value;

            fetch('${pageContext.request.contextPath}/admin/withdrawals/reject', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    withdrawalId: withdrawalId,
                    adminMemo: adminMemo
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('거절되었습니다.');
                    location.reload();
                } else {
                    alert('거절 처리 중 오류가 발생했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('거절 처리 중 오류가 발생했습니다.');
            });
        }

        // 완료 모달
        function openCompleteModal(id, ownerName, amount) {
            document.getElementById('completeWithdrawalId').value = id;
            document.getElementById('completeOwnerName').textContent = ownerName;
            document.getElementById('completeAmount').textContent = new Intl.NumberFormat('ko-KR').format(amount);
            document.getElementById('completeModal').style.display = 'flex';
        }

        function closeCompleteModal() {
            document.getElementById('completeModal').style.display = 'none';
            document.getElementById('completeForm').reset();
        }

        function submitComplete(event) {
            event.preventDefault();
            const withdrawalId = document.getElementById('completeWithdrawalId').value;
            const adminMemo = document.getElementById('completeMemo').value;

            fetch('${pageContext.request.contextPath}/admin/withdrawals/complete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    withdrawalId: withdrawalId,
                    adminMemo: adminMemo
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('출금이 완료 처리되었습니다.');
                    location.reload();
                } else {
                    alert('완료 처리 중 오류가 발생했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('완료 처리 중 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>
