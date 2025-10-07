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
											<div class="mb-6 p-4 bg-amber-50 border border-amber-200 rounded-lg">
												<h4 class="text-sm font-semibold text-amber-800">예약금 안내</h4>
												<p class="text-2xl font-bold text-amber-600 mt-2">
													<fmt:formatNumber value="${depositAmount}" pattern="#,###" />원
												</p>
												<c:if test="${not empty depositDescription}">
													<p class="text-sm text-amber-700 mt-2">${depositDescription}</p>
												</c:if>
												<p class="text-xs text-amber-700 mt-3">결제는 예약 제출 후 네이버페이로 진행됩니다.</p>
											</div>
										</c:if>

										<!-- 서버에서 전달된 에러 메시지 표시 -->
										<c:if test="${not empty errorMessage}">
											<div
												class="mb-4 p-4 bg-red-100 border border-red-300 text-red-700 rounded-lg">
												${errorMessage}</div>
										</c:if>

										<!-- 예약 폼 -->
										<form
											action="${pageContext.request.contextPath}/reservation/create" method="post"
											class="space-y-6"
											data-fetch-url="${pageContext.request.contextPath}/reservation"
											data-initial-time="${param.reservationTime}">
											<input type="hidden" name="restaurantId"
												value="${restaurant.id}"> <input type="hidden"
												name="restaurantName" value="${restaurant.name}">

											<div>
												<label for="reservationDate"
													class="block text-sm font-medium text-slate-700 mb-2">예약
													날짜</label>
												<%-- [수정] param.reservationDate 값을 기본값으로 설정 --%>
												<input type="date" id="reservationDate"
													name="reservationDate" value="${param.reservationDate}"
													required class="form-input">
											</div>

											<div>
												<label for="reservationTime"
													class="block text-sm font-medium text-slate-700 mb-2">예약
													시간</label> <select id="reservationTime" name="reservationTime"
													required class="form-input">
													<%-- [수정] 아래의 option들을 동적으로 생성 --%>
													<c:choose>
														<c:when test="${not empty timeSlots}">
															<option value="">시간을 선택하세요</option>

															<%-- "오전", "점심", "저녁" 그룹화를 위한 변수 설정 --%>
															<c:set var="lastCategory" value="" />

															<c:forEach var="time" items="${timeSlots}">
																<%-- JSTL로 시간 비교를 위해 LocalTime 객체 생성 --%>
																<c:set var="currentTime"
																	value="${LocalTime.parse(time)}" />


																<option value="${time}"
																	${param.reservationTime == time ? 'selected' : ''}>${time}</option>

																<c:set var="lastCategory" value="${currentCategory}" />
															</c:forEach>
														</c:when>
														<c:otherwise>
															<option value="">선택 가능한 시간이 없습니다.</option>
														</c:otherwise>
													</c:choose>
												</select>
												<p id="timeSlotMessage" class="text-sm text-red-600 mt-2 hidden"></p>
											</div>

											<div>
												<label for="partySize"
													class="block text-sm font-medium text-slate-700 mb-2">인원
													수</label> <select id="partySize" name="partySize" required
													class="form-input">
													<option value="">인원을 선택하세요</option>
													<c:forEach var="i" begin="1" end="10">
														<%-- [수정] param.partySize 값과 일치하는 옵션을 'selected'로 설정 --%>
														<option value="${i}"
															${param.partySize == i ? 'selected' : ''}>${i}명</option>
													</c:forEach>
												</select>
											</div>

											<div>
												<label for="contactPhone"
													class="block text-sm font-medium text-slate-700 mb-2">연락처</label>
												<input type="tel" id="contactPhone" name="contactPhone"
													required class="form-input" placeholder="010-1234-5678">
											</div>

											<div>
											    <label class="block text-sm font-medium text-slate-700 mb-2">세부 요청사항 (선택)</label>
											    <div class="space-y-2" id="requests-container">
											        <%-- 요청사항 버튼들 --%>
											        <button type="button" class="request-btn" data-target="allergy-input">🍤&nbsp; 알러지 정보 추가</button>
											        <button type="button" class="request-btn" data-target="seat-input">🪑&nbsp; 좌석 요청 추가</button>
											        <button type="button" class="request-btn" data-target="other-input">🗒️&nbsp; 기타 특이사항 추가</button>
											        
											        <%-- 숨겨진 입력창들 --%>
											        <div id="allergy-input" class="request-input-wrapper hidden">
											            <input type="text" class="form-input request-input" data-key="알러지" placeholder="예: 갑각류, 견과류 알러지가 있습니다.">
											        </div>
											        <div id="seat-input" class="request-input-wrapper hidden">
											            <input type="text" class="form-input request-input" data-key="좌석 요청" placeholder="예: 창가 쪽 자리로 부탁드립니다.">
											        </div>
											        <div id="other-input" class="request-input-wrapper hidden">
											            <textarea class="form-input request-input" data-key="특이사항" rows="3" placeholder="예: 아이와 함께 방문합니다. 아기 의자 부탁드려요."></textarea>
											        </div>
											    </div>
											    <%-- 최종적으로 조합된 요청사항이 저장될 hidden input --%>
											    <input type="hidden" id="specialRequests" name="specialRequests">
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
													href="${pageContext.request.contextPath}/restaurant/detail?id=${restaurant.id}"
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
        // --- ▼▼▼ [수정] 모든 스크립트를 이 안으로 통합 ▼▼▼ ---

        // 1. 공통으로 사용할 변수 선언
        const reservationForm = document.querySelector('form');
        const dateInput = document.getElementById('reservationDate');
        const timeSelect = document.getElementById('reservationTime');
        const timeMessage = document.getElementById('timeSlotMessage');
        const restaurantInput = document.querySelector('input[name="restaurantId"]');
        const fetchUrl = reservationForm ? reservationForm.dataset.fetchUrl : '';
        const initialSelectedTime = reservationForm ? reservationForm.dataset.initialTime : '';

        // 2. 예약 가능 날짜 제한 로직
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
                const raw = await response.text();
                let data;
                try {
                    data = raw ? JSON.parse(raw) : {};
                } catch (parseError) {
                    throw new Error('시간 슬롯 응답 파싱 실패');
                }
                if (!response.ok) {
                    throw new Error(data && (data.message || data.error) ? data.message || data.error : '시간 정보 요청 실패');
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

                if (timeMessage) {
                    const message = data.message || data.error || '';
                    if (message) {
                        timeMessage.textContent = message;
                        timeMessage.classList.remove('hidden');
                    }
                }

                timeSelect.disabled = slots.length === 0;
            } catch (error) {
                timeSelect.innerHTML = '';
                const option = document.createElement('option');
                option.value = '';
                option.textContent = '시간 정보를 불러오지 못했습니다.';
                timeSelect.appendChild(option);
                if (timeMessage) {
                    timeMessage.textContent = error && error.message ? error.message : '시간 정보를 불러오는 중 오류가 발생했습니다.';
                    timeMessage.classList.remove('hidden');
                }
            }
        }

        if (dateInput) {
            loadTimeSlots(dateInput.value, initialSelectedTime);
            dateInput.addEventListener('change', function() {
                loadTimeSlots(this.value, '');
            });
        }

        // 3. 세부 요청사항 UI 스크립트
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

        // 4. 폼 제출 시 유효성 검사 및 요청사항 조합 로직
        if (reservationForm) {
            reservationForm.addEventListener('submit', function(e) {
                // 연락처 유효성 검사
                const contactPhone = document.getElementById('contactPhone').value;
                const phoneRegex = /^01[0-9]-\d{3,4}-\d{4}$/;
                if (!phoneRegex.test(contactPhone)) {
                    e.preventDefault();
                    alert('연락처를 올바른 형식으로 입력해주세요. (예: 010-1234-5678)');
                    return; // 검사 실패 시 더 이상 진행하지 않음
                }

                // 요청사항 조합
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
        // --- ▲▲▲ [수정] 통합 끝 ▲▲▲ ---
    });
</script>
</body>
</html>
