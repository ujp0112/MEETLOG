<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약하기</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
    </style>
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-2xl mx-auto">
                    
                    <%-- 1. 로그인 여부 확인 --%>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <%-- 2. 예약할 맛집 정보가 있는지 확인 --%>
                            <c:choose>
                                <c:when test="${not empty restaurant}">
                                    <div class="mb-6">
                                        <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">예약하기</h2>
                                        <p class="text-slate-600">예약 정보를 정확히 입력해주세요.</p>
                                    </div>
                                    <div class="bg-white p-6 md:p-8 rounded-xl shadow-lg">
                                        <!-- 맛집 정보 표시 -->
                                        <div class="mb-6 p-4 bg-slate-50 rounded-lg border border-slate-200">
                                            <h3 class="text-lg font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                            <p class="text-slate-600 text-sm">${restaurant.category} • ${restaurant.location}</p>
                                            <p class="text-slate-600 text-sm mt-1">주소: ${restaurant.address}</p>
                                            <c:if test="${not empty restaurant.phone}">
                                                <p class="text-slate-600 text-sm mt-1">전화: ${restaurant.phone}</p>
                                            </c:if>
                                        </div>

                                        <!-- 서버에서 전달된 에러 메시지 표시 -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="mb-4 p-4 bg-red-100 border border-red-300 text-red-700 rounded-lg">
                                                ${errorMessage}
                                            </div>
                                        </c:if>

                                        <!-- 예약 폼 -->
                                        <form "${pageContext.request.contextPath}.do/reservation/create" method="post" class="space-y-6">
                                            <input type="hidden" name="restaurantId" value="${restaurant.id}">
                                            <input type="hidden" name="restaurantName" value="${restaurant.name}">
                                            
                                            <div>
                                                <label for="reservationDate" class="block text-sm font-medium text-slate-700 mb-2">예약 날짜</label>
                                                <input type="date" id="reservationDate" name="reservationDate" required class="form-input">
                                            </div>

                                            <div>
                                                <label for="reservationTime" class="block text-sm font-medium text-slate-700 mb-2">예약 시간</label>
                                                <select id="reservationTime" name="reservationTime" required class="form-input">
                                                    <option value="">시간을 선택하세요</option>
                                                    <option value="11:30">11:30</option> <option value="12:00">12:00</option> <option value="12:30">12:30</option>
                                                    <option value="13:00">13:00</option> <option value="13:30">13:30</option>
                                                    <option value="17:30">17:30</option> <option value="18:00">18:00</option> <option value="18:30">18:30</option>
                                                    <option value="19:00">19:00</option> <option value="19:30">19:30</option> <option value="20:00">20:00</option>
                                                </select>
                                            </div>

                                            <div>
                                                <label for="partySize" class="block text-sm font-medium text-slate-700 mb-2">인원 수</label>
                                                <select id="partySize" name="partySize" required class="form-input">
                                                    <option value="">인원을 선택하세요</option>
                                                    <c:forEach var="i" begin="1" end="10">
                                                        <option value="${i}">${i}명</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div>
                                                <label for="contactPhone" class="block text-sm font-medium text-slate-700 mb-2">연락처</label>
                                                <input type="tel" id="contactPhone" name="contactPhone" required class="form-input" placeholder="010-1234-5678">
                                            </div>

                                            <div>
                                                <label for="specialRequests" class="block text-sm font-medium text-slate-700 mb-2">요청사항 (선택)</label>
                                                <textarea id="specialRequests" name="specialRequests" rows="3" class="form-input" placeholder="알레르기, 좌석 선호도 등 요청사항을 남겨주세요."></textarea>
                                            </div>

                                            <div class="bg-blue-50 p-4 rounded-lg">
                                                <h4 class="font-medium text-blue-800 mb-2">📋 예약 안내</h4>
                                                <ul class="text-sm text-blue-700 list-disc list-inside space-y-1">
                                                    <li>예약은 최대 30일 이내 날짜만 가능합니다.</li>
                                                    <li>예약 시간 10분 전까지 도착해주세요.</li>
                                                    <li>예약 취소는 최소 2시간 전까지 '마이페이지'에서 가능합니다.</li>
                                                </ul>
                                            </div>

                                            <div class="flex justify-end space-x-3 pt-4">
                                                <a href="${pageContext.request.contextPath}/restaurant/detail?id=${restaurant.id}" class="form-btn-secondary">취소</a>
                                                <button type="submit" class="form-btn-primary">예약 신청하기</button>
                                            </div>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-20">
                                        <div class="text-6xl mb-4">🍽️</div>
                                        <h3 class="text-xl font-bold text-slate-800 mb-2">맛집 정보를 찾을 수 없습니다.</h3>
                                        <p class="text-slate-600 mb-6">URL이 정확한지 다시 확인해주세요.</p>
                                        <a href="${pageContext.request.contextPath}/" class="form-btn-primary">메인으로 돌아가기</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-20">
                                <div class="text-6xl mb-4">🔒</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다.</h2>
                                <p class="text-slate-600 mb-6">맛집을 예약하려면 먼저 로그인해주세요.</p>
                                <a href="${pageContext.request.contextPath}/login" class="form-btn-primary">로그인 페이지로 이동</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('reservationDate');
            if (dateInput) {
                // 오늘 날짜를 YYYY-MM-DD 형식으로 변환
                const today = new Date().toISOString().split('T')[0];
                
                // 30일 후 날짜를 YYYY-MM-DD 형식으로 변환
                const maxDate = new Date();
                maxDate.setDate(maxDate.getDate() + 30);
                const maxDateString = maxDate.toISOString().split('T')[0];

                // 예약 가능 날짜를 오늘부터 30일 후까지로 제한
                dateInput.min = today;
                dateInput.max = maxDateString;
            }

            const reservationForm = document.querySelector('form');
            if(reservationForm) {
                reservationForm.addEventListener('submit', function(e) {
                    const contactPhone = document.getElementById('contactPhone').value;
                    const phoneRegex = /^01[0-9]-\d{3,4}-\d{4}$/; // 010, 011, 016 등 포함

                    if (!phoneRegex.test(contactPhone)) {
                        e.preventDefault(); // 폼 제출 중단
                        alert('연락처를 올바른 형식으로 입력해주세요. (예: 010-1234-5678)');
                    }
                });
            }
        });
    </script>
</body>
</html>
