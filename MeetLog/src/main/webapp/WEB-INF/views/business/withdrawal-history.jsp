<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>출금 신청 내역 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .status-pending { background-color: #fef9c3; color: #a16207; }
        .status-approved { background-color: #dcfce7; color: #166534; }
        .status-rejected { background-color: #fee2e2; color: #991b1b; }
        .status-completed { background-color: #e0e7ff; color: #3730a3; }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl">
            <div class="mb-8">
                <div class="flex items-center gap-4 mb-4">
                    <a href="${pageContext.request.contextPath}/business/reservation-management"
                       class="text-slate-500 hover:text-sky-600 transition-colors">
                        ← 예약 관리로 돌아가기
                    </a>
                </div>
                <h1 class="text-3xl font-bold gradient-text">출금 신청 내역</h1>
                <p class="text-slate-600 mt-2">나의 출금 신청 내역을 확인할 수 있습니다.</p>
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

            <!-- 출금 신청 목록 -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <c:choose>
                    <c:when test="${not empty withdrawals}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-slate-200">
                                <thead class="bg-slate-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">신청 ID</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">신청 금액</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">은행 정보</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">신청 날짜</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">상태</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">관리자 메모</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-slate-200">
                                    <c:forEach items="${withdrawals}" var="withdrawal">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-slate-900">#${withdrawal.id}</td>
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
                                                <c:if test="${withdrawal.status == 'APPROVED' || withdrawal.status == 'COMPLETED'}">
                                                    <div class="text-xs text-slate-500 mt-1">
                                                        처리: ${withdrawal.formattedProcessedAt}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-slate-600">
                                                <c:choose>
                                                    <c:when test="${not empty withdrawal.adminMemo}">
                                                        ${withdrawal.adminMemo}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-slate-400">-</span>
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
                            <p class="text-slate-500">출금 신청 내역이 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
