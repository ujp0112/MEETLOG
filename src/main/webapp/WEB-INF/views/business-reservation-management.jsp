<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- 공통 헤더 포함 --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-8">
                    <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">예약 관리</h2>
                    <p class="text-slate-600">매장의 예약 현황을 확인하고 관리합니다.</p>
                </div>

                <!-- 예약 목록 -->
                <div class="bg-white rounded-xl shadow-lg">
                    <div class="p-6 border-b border-slate-200">
                        <h3 class="text-lg font-semibold text-slate-800">예약 목록</h3>
                    </div>
                    <div class="p-6">
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <div class="space-y-4">
                                    <c:forEach var="reservation" items="${reservations}">
                                        <div class="border border-slate-200 rounded-lg p-4 hover:bg-slate-50 transition-colors">
                                            <div class="flex items-center justify-between">
                                                <div class="flex-1">
                                                    <div class="flex items-center space-x-4">
                                                        <div>
                                                            <h4 class="font-medium text-slate-900">${reservation.customerName}</h4>
                                                            <p class="text-sm text-slate-600">예약 시간: ${reservation.reservationTime}</p>
                                                            <p class="text-sm text-slate-600">인원: ${reservation.partySize}명</p>
                                                        </div>
                                                        <div class="flex items-center">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                                                                <c:choose>
                                                                    <c:when test="${reservation.status == 'PENDING'}">bg-yellow-100 text-yellow-800</c:when>
                                                                    <c:when test="${reservation.status == 'CONFIRMED'}">bg-green-100 text-green-800</c:when>
                                                                    <c:when test="${reservation.status == 'COMPLETED'}">bg-blue-100 text-blue-800</c:when>
                                                                    <c:when test="${reservation.status == 'CANCELLED'}">bg-red-100 text-red-800</c:when>
                                                                    <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                                </c:choose>
                                                            ">
                                                                <c:choose>
                                                                    <c:when test="${reservation.status == 'PENDING'}">대기중</c:when>
                                                                    <c:when test="${reservation.status == 'CONFIRMED'}">확정</c:when>
                                                                    <c:when test="${reservation.status == 'COMPLETED'}">완료</c:when>
                                                                    <c:when test="${reservation.status == 'CANCELLED'}">취소</c:when>
                                                                    <c:otherwise>${reservation.status}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="flex space-x-2">
                                                    <button class="px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors">
                                                        확인
                                                    </button>
                                                    <button class="px-3 py-1 text-sm bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
                                                        취소
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <svg class="mx-auto h-12 w-12 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                    </svg>
                                    <h3 class="mt-2 text-sm font-medium text-slate-900">예약이 없습니다</h3>
                                    <p class="mt-1 text-sm text-slate-500">아직 등록된 예약이 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>

        <%-- 공통 푸터 포함 --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>
