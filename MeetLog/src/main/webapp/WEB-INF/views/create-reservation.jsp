<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - 예약하기</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
}

.form-input {
	width: 100%;
	padding: 0.75rem;
	border: 1px solid #cbd5e1;
	border-radius: 0.5rem;
	transition: border-color 0.2s;
}

.form-input:focus {
	border-color: #3b82f6;
	outline: none;
	box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.3);
}

.form-btn-primary {
	background-color: #3b82f6;
	color: white;
	padding: 0.75rem 1.5rem;
	border-radius: 0.5rem;
	font-weight: 500;
	text-align: center;
	transition: background-color 0.2s;
}

.form-btn-primary:hover {
	background-color: #2563eb;
}

.form-btn-secondary {
	background-color: #e2e8f0;
	color: #475569;
	padding: 0.75rem 1.5rem;
	border-radius: 0.5rem;
	font-weight: 500;
	text-align: center;
	transition: background-color 0.2s;
}

.form-btn-secondary:hover {
	background-color: #cbd5e1;
}

.request-btn {
	display: inline-flex;
	align-items: center;
	background-color: #f1f5f9; /* slate-100 */
	color: #475569; /* slate-600 */
	padding: 0.5rem 1rem;
	border-radius: 9999px; /* rounded-full */
	font-size: 0.875rem;
	font-weight: 500;
	border: 1px solid #e2e8f0; /* slate-200 */
	transition: all 0.2s ease-in-out;
}

.request-btn:hover {
	background-color: #e2e8f0; /* slate-200 */
	border-color: #cbd5e1; /* slate-300 */
}

.request-btn.active {
	background-color: #e0f2fe; /* sky-100 */
	color: #0c4a6e; /* sky-800 */
	border-color: #7dd3fc; /* sky-300 */
}

.request-input-wrapper {
	padding-top: 0.5rem;
}
</style>
</head>
<body class="bg-slate-100">
	<div id="app" class="flex flex-col min-h-screen">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />

		<main class="flex-grow">
			<%
			// 서블릿에서 전달된 값을 스크립틀릿 변수로 받습니다.
			String reservationDate = (String) request.getAttribute("reservationDate");
			String reservationTime = (String) request.getAttribute("reservationTime");
			String partySize = (String) request.getAttribute("partySize");
			java.util.List<String> timeSlots = (java.util.List<String>) request.getAttribute("timeSlots");

			// JSP 페이지에서 Null 오류가 발생하지 않도록 기본값을 설정합니다.
			if (reservationDate == null)
				reservationDate = java.time.LocalDate.now().toString();
			if (reservationTime == null)
				reservationTime = "";
			if (partySize == null)
				partySize = "";
			if (timeSlots == null)
				timeSlots = new java.util.ArrayList<>();
			%>

			<div class="container mx-auto p-4 md:p-8">
				<div class="max-w-2xl mx-auto">

					<c:choose>
						<c:when test="${not empty sessionScope.user}">
							<c:choose>
								<c:when test="${not empty restaurant}">
									<div class="mb-6">
										<h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">예약하기</h2>
										<p class="text-slate-600">예약 정보를 정확히 입력해주세요.</p>
									</div>
									<div class="bg-white p-6 md:p-8 rounded-xl shadow-lg">
										<div
											class="mb-6 p-4 bg-slate-50 rounded-lg border border-slate-200">
											<h3 class="text-lg font-bold text-slate-800 mb-2">${restaurant.name}</h3>
											<p class="text-slate-600 text-sm">${restaurant.category}
												• ${restaurant.location}</p>
											<p class="text-slate-600 text-sm mt-1">주소:
												${restaurant.address}</p>
											<c:if test="${not empty restaurant.phone}">
												<p class="text-slate-600 text-sm mt-1">전화:
													${restaurant.phone}</p>
											</c:if>
										</div>

										<c:if test="${depositRequired}">
											<div
												class="mb-6 p-4 bg-amber-50 border border-amber-200 rounded-lg">
												<h4 class="text-sm font-semibold text-amber-800">예약금 안내</h4>
												<p class="text-2xl font-bold text-amber-600 mt-2">
													<fmt:formatNumber value="${depositAmount}" pattern="#,###" />
													원
												</p>
												<c:if test="${not empty depositDescription}">
													<p class="text-sm text-amber-700 mt-2">${depositDescription}</p>
												</c:if>
												<p class="text-xs text-amber-700 mt-3">결제는 예약 제출 후
													네이버페이로 진행됩니다.</p>
											</div>
										</c:if>

										<c:if test="${not empty errorMessage}">
											<div
												class="mb-4 p-4 bg-red-100 border border-red-300 text-red-700 rounded-lg">${errorMessage}</div>
										</c:if>

										<form
											action="${pageContext.request.contextPath}/reservation/create"
											method="post" class="space-y-6"
											data-fetch-url="${pageContext.request.contextPath}/reservation"
											data-initial-time="<%= reservationTime %>">
											<input type="hidden" name="restaurantId"
												value="${restaurant.id}"> <input type="hidden"
												name="restaurantName" value="${restaurant.name}">

											<div>
												<label for="reservationDate"
													class="block text-sm font-medium text-slate-700 mb-2">예약
													날짜</label> <input type="date" id="reservationDate"
													name="reservationDate" value="<%=reservationDate%>"
													required class="form-input">
											</div>

											<div>
												<label for="reservationTime"
													class="block text-sm font-medium text-slate-700 mb-2">예약
													시간</label> <select id="reservationTime" name="reservationTime"
													required class="form-input">
													<%
													if (!timeSlots.isEmpty()) {
													%>
													<option value="">시간을 선택하세요</option>
													<%
													for (String time : timeSlots) {
													%>
													<%-- 현재 시간이 선택된 시간과 일치하면 'selected' 속성을 추가합니다. --%>
													<option value="<%=time%>"
														<%=time.equals(reservationTime) ? "selected" : ""%>><%=time%></option>
													<%
													}
													%>
													<%
													} else {
													%>
													<%-- 선택 가능한 시간은 없지만, 이전 페이지에서 넘어온 시간이 있다면 그 값이라도 표시해줍니다. --%>
													<%
													if (reservationTime != null && !reservationTime.isEmpty()) {
													%>
													<option value="<%=reservationTime%>" selected><%=reservationTime%></option>
													<%
													}
													%>
													<option value="" disabled>선택 가능한 시간이 없습니다.</option>
													<%
													}
													%>
												</select>
												<p id="timeSlotMessage"
													class="text-sm text-red-600 mt-2 hidden"></p>
											</div>

											<div>
												<label for="partySize"
													class="block text-sm font-medium text-slate-700 mb-2">인원
													수</label> <select id="partySize" name="partySize" required
													class="form-input">
													<option value="">인원을 선택하세요</option>
													<%
													for (int i = 1; i <= 10; i++) {
													%>
													<%-- 현재 인원수가 선택된 인원수와 일치하면 'selected' 속성을 추가합니다. --%>
													<option value="<%=i%>"
														<%=String.valueOf(i).equals(partySize) ? "selected" : ""%>><%=i%>명
													</option>
													<%
													}
													%>
												</select>
											</div>

											<div>
												<label for="contactPhone"
													class="block text-sm font-medium text-slate-700 mb-2">연락처</label>
												<c:choose>
													<c:when test="${not empty sessionScope.user.phone}">
														<input type="tel" id="contactPhone" name="contactPhone"
															required
															class="form-input bg-slate-100 cursor-not-allowed"
															value="${sessionScope.user.phone}" readonly>
													</c:when>
													<c:otherwise>
														<input type="tel" id="contactPhone" name="contactPhone"
															required class="form-input" placeholder="010-1234-5678">
													</c:otherwise>
												</c:choose>
											</div>

											<div>
												<label class="block text-sm font-medium text-slate-700 mb-2">세부
													요청사항 (선택)</label>
												<div class="space-y-2" id="requests-container">
													<button type="button" class="request-btn"
														data-target="allergy-input">🍤&nbsp; 알러지 정보 추가</button>
													<button type="button" class="request-btn"
														data-target="seat-input">🪑&nbsp; 좌석 요청 추가</button>
													<button type="button" class="request-btn"
														data-target="other-input">🗒️&nbsp; 기타 특이사항 추가</button>
													<div id="allergy-input"
														class="request-input-wrapper hidden">
														<input type="text" class="form-input request-input"
															data-key="알러지" placeholder="예: 갑각류, 견과류 알러지가 있습니다.">
													</div>
													<div id="seat-input" class="request-input-wrapper hidden">
														<input type="text" class="form-input request-input"
															data-key="좌석 요청" placeholder="예: 창가 쪽 자리로 부탁드립니다.">
													</div>
													<div id="other-input" class="request-input-wrapper hidden">
														<textarea class="form-input request-input" data-key="특이사항"
															rows="3" placeholder="예: 아이와 함께 방문합니다. 아기 의자 부탁드려요."></textarea>
													</div>
												</div>
												<input type="hidden" id="specialRequests"
													name="specialRequests">
											</div>

											<div class="bg-blue-50 p-4 rounded-lg">
												<h4 class="font-medium text-blue-800 mb-2">📋 예약 안내</h4>
												<ul
													class="text-sm text-blue-700 list-disc list-inside space-y-1">
													<li>예약은 최대 30일 이내 날짜만 가능합니다.</li>
													<li>예약 시간 10분 전까지 도착해주세요.</li>
													<li>예약 취소는 최소 2시간 전까지 '마이페이지'에서 가능합니다.</li>
												</ul>
											</div>

											<div class="flex justify-end space-x-3 pt-4">
												<a
													href="${pageContext.request.contextPath}/restaurant-detail/${restaurant.id}"
													class="form-btn-secondary">취소</a>
												<button type="submit" class="form-btn-primary">예약
													신청하기</button>
											</div>
										</form>
									</div>
								</c:when>
								<c:otherwise>
									<div class="text-center py-20">
										<div class="text-6xl mb-4">🍽️</div>
										<h3 class="text-xl font-bold text-slate-800 mb-2">맛집 정보를
											찾을 수 없습니다.</h3>
										<p class="text-slate-600 mb-6">URL이 정확한지 다시 확인해주세요.</p>
										<a href="${pageContext.request.contextPath}/"
											class="form-btn-primary">메인으로 돌아가기</a>
									</div>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<div class="text-center py-20">
								<div class="text-6xl mb-4">🔒</div>
								<h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이
									필요합니다.</h2>
								<p class="text-slate-600 mb-6">맛집을 예약하려면 먼저 로그인해주세요.</p>
								<a href="${pageContext.request.contextPath}/login"
									class="form-btn-primary">로그인 페이지로 이동</a>
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
        // 1. 공통으로 사용할 변수 선언
        const reservationForm = document.querySelector('form');
        const dateInput = document.getElementById('reservationDate');
        const timeSelect = document.getElementById('reservationTime');
        const timeMessage = document.getElementById('timeSlotMessage');
        const restaurantInput = document.querySelector('input[name="restaurantId"]');
        const contactPhoneInput = document.getElementById('contactPhone');
        
        const fetchUrl = reservationForm ? reservationForm.dataset.fetchUrl : '';
        // [ ✨ 수정 ✨ ] 'param' 대신 'requestScope'에서 값을 가져오도록 변경하여 안정성 확보
        const initialSelectedTime = reservationForm ? reservationForm.dataset.initialTime : '${reservationTime}';

        // 2. [ ✨ 신규 ✨ ] 연락처 자동 입력 기능
        // 서블릿에서 전달된 사용자의 전화번호 값을 가져옵니다.
        const userPhone = '${sessionScope.user.phone}'; 

        if (contactPhoneInput) {
            // 사용자 전화번호가 있고('null' 이나 빈 문자열이 아님), 입력창이 존재할 경우
            if (userPhone && userPhone.trim() !== '' && userPhone !== 'null') {
                contactPhoneInput.value = userPhone; // 값을 설정
                contactPhoneInput.readOnly = true;   // 읽기 전용으로 변경
                contactPhoneInput.classList.add('bg-slate-100', 'cursor-not-allowed'); // 스타일 변경
            }
        }

        // 3. 예약 가능 날짜 제한 로직 (기존과 동일)
        if (dateInput) {
            const today = new Date().toISOString().split('T')[0];
            const maxDate = new Date();
            maxDate.setDate(maxDate.getDate() + 30);
            const maxDateString = maxDate.toISOString().split('T')[0];
            dateInput.min = today;
            dateInput.max = maxDateString;
            if (!dateInput.value) {
                dateInput.value = today;
            }
        }

        // 4. AJAX로 예약 가능 시간 불러오는 함수
        async function loadTimeSlots(date, preferredTime) {
            if (!fetchUrl || !restaurantInput || !timeSelect || !date) {
                return;
            }
            const params = new URLSearchParams();
            params.append('action', 'getTimeSlots');
            params.append('restaurantId', restaurantInput.value);
            params.append('date', date);

            timeSelect.innerHTML = '<option value="">시간을 불러오는 중...</option>';
            timeSelect.disabled = true;
            if (timeMessage) {
                timeMessage.textContent = '';
                timeMessage.classList.add('hidden');
            }

            try {
                const response = await fetch(fetchUrl, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                });
                const data = await response.json();
                
                if (!response.ok) {
                    throw new Error(data.message || data.error || '시간 정보 요청 실패');
                }
                const slots = Array.isArray(data.timeSlots) ? data.timeSlots : [];

                timeSelect.innerHTML = '';
                const placeholder = document.createElement('option');
                placeholder.value = '';
                placeholder.textContent = slots.length > 0 ? '시간을 선택하세요' : '선택 가능한 시간이 없습니다.';
                timeSelect.appendChild(placeholder);

                slots.forEach(slot => {
                    const option = document.createElement('option');
                    option.value = slot;
                    option.textContent = slot;
                    if (preferredTime && preferredTime === slot) {
                        option.selected = true;
                    }
                    timeSelect.appendChild(option);
                });

                if (timeMessage && data.message) {
                    timeMessage.textContent = data.message;
                    timeMessage.classList.remove('hidden');
                }
                timeSelect.disabled = slots.length === 0;

            } catch (error) {
                timeSelect.innerHTML = '<option value="">시간 정보를 불러오지 못했습니다.</option>';
                if (timeMessage) {
                    timeMessage.textContent = error.message || '시간 정보를 불러오는 중 오류가 발생했습니다.';
                    timeMessage.classList.remove('hidden');
                }
            }
        }

        // 5. 날짜 변경 시 시간 다시 불러오기 (기존과 동일)
        if (dateInput) {
            loadTimeSlots(dateInput.value, initialSelectedTime);
            dateInput.addEventListener('change', function() {
                loadTimeSlots(this.value, '');
            });
        }

        // 6. 세부 요청사항 UI 스크립트 (기존과 동일)
        const requestButtons = document.querySelectorAll('.request-btn');
		const requestInputs = document.querySelectorAll('.request-input');
		const finalRequestsInput = document.getElementById('specialRequests');

		requestButtons.forEach(button => {
		    button.addEventListener('click', function() {
		        const targetId = this.dataset.target;
		        const targetWrapper = document.getElementById(targetId);
		        targetWrapper.classList.toggle('hidden');
		        this.classList.toggle('active');
		        if (!targetWrapper.classList.contains('hidden')) {
		            targetWrapper.querySelector('.form-input').focus();
		        }
		    });
		});

        // 7. 폼 제출 시 유효성 검사 및 요청사항 조합 로직
        if (reservationForm) {
            reservationForm.addEventListener('submit', function(e) {
                // [ ✨ 수정 ✨ ] 연락처가 읽기 전용이 아닐 때만 유효성 검사 실행
                if (contactPhoneInput && !contactPhoneInput.readOnly) {
                    const phoneRegex = /^01[0-9]-\d{3,4}-\d{4}$/;
                    if (!phoneRegex.test(contactPhoneInput.value)) {
                        e.preventDefault();
                        alert('연락처를 올바른 형식으로 입력해주세요. (예: 010-1234-5678)');
                        return;
                    }
                }

                // 요청사항 조합 (기존과 동일)
                let requests = [];
		        requestInputs.forEach(input => {
		            const wrapper = input.parentElement;
		            if (!wrapper.classList.contains('hidden') && input.value.trim() !== '') {
		                requests.push(input.dataset.key + ': ' + input.value.trim());
		            }
		        });
		        finalRequestsInput.value = requests.join(', ');
            });
        }
    });
</script>
</body>
</html>
