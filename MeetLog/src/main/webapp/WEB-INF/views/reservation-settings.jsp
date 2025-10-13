<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${restaurant.name}예약설정- MEET LOG</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<!-- Flatpickr for date picker -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
<!-- Icons -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">

<style>
* {
	font-family: 'Noto Sans KR', sans-serif;
}

.glass-card {
	background: rgba(255, 255, 255, 0.9);
	backdrop-filter: blur(20px);
	border: 1px solid rgba(255, 255, 255, 0.2);
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.gradient-text {
	background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.slide-up {
	animation: slideUp 0.6s ease-out;
}

@
keyframes slideUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.toggle-switch {
	appearance: none;
	width: 48px;
	height: 24px;
	background: #cbd5e1;
	border-radius: 12px;
	position: relative;
	cursor: pointer;
	transition: all 0.3s ease;
}

.toggle-switch:checked {
	background: #3b82f6;
}

.toggle-switch::before {
	content: '';
	position: absolute;
	width: 20px;
	height: 20px;
	border-radius: 50%;
	background: white;
	top: 2px;
	left: 2px;
	transition: all 0.3s ease;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.toggle-switch:checked::before {
	transform: translateX(24px);
}

.time-slot {
	transition: all 0.2s ease;
}

.time-slot:hover {
	transform: scale(1.05);
}

.time-slot.selected {
	background: linear-gradient(135deg, #3b82f6, #1d4ed8);
	color: white;
}

.flatpickr-calendar {
	box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px
		rgba(0, 0, 0, 0.04);
	border-radius: 12px;
	border: none;
}
</style>
</head>
<body class="bg-slate-100">
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<main class="container mx-auto p-4 md:p-8 max-w-6xl">
		<!-- 헤더 -->
		<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
			<div class="flex items-center gap-3 mb-4">
				<a href="${pageContext.request.contextPath}/business/restaurants"
					class="text-slate-500 hover:text-sky-600 transition-colors flex items-center gap-2">
					<i class="fas fa-arrow-left"></i> 내 음식점 관리
				</a>
			</div>
			<div class="flex items-center gap-4 mb-4">
				<div
					class="w-16 h-16 rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white text-2xl">
					<i class="fas fa-utensils"></i>
				</div>
				<div>
					<h1 class="text-3xl font-bold gradient-text">${restaurant.name}</h1>
					<p class="text-slate-600">예약 시스템 설정</p>
				</div>
			</div>
			<div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
				<div class="flex items-center gap-2 text-blue-800">
					<i class="fas fa-info-circle"></i> <span class="font-semibold">알림</span>
				</div>
				<p class="text-blue-700 mt-1">고객이 온라인으로 예약할 수 있도록 상세한 설정을
					구성해보세요. 설정 후 바로 적용됩니다.</p>
			</div>
		</div>

		<form id="reservationSettingsForm"
			action="${pageContext.request.contextPath}/reservation-settings/${restaurant.id}/save"
			method="post">

			<!-- Hidden inputs to ensure all day time values are always sent -->
			<input type="hidden" name="mondayStart"
				value="${reservationSettings.monday_start != null ? reservationSettings.monday_start : '09:00'}">
			<input type="hidden" name="mondayEnd"
				value="${reservationSettings.monday_end != null ? reservationSettings.monday_end : '22:00'}">
			<input type="hidden" name="tuesdayStart"
				value="${reservationSettings.tuesday_start != null ? reservationSettings.tuesday_start : '09:00'}">
			<input type="hidden" name="tuesdayEnd"
				value="${reservationSettings.tuesday_end != null ? reservationSettings.tuesday_end : '22:00'}">
			<input type="hidden" name="wednesdayStart"
				value="${reservationSettings.wednesday_start != null ? reservationSettings.wednesday_start : '09:00'}">
			<input type="hidden" name="wednesdayEnd"
				value="${reservationSettings.wednesday_end != null ? reservationSettings.wednesday_end : '22:00'}">
			<input type="hidden" name="thursdayStart"
				value="${reservationSettings.thursday_start != null ? reservationSettings.thursday_start : '09:00'}">
			<input type="hidden" name="thursdayEnd"
				value="${reservationSettings.thursday_end != null ? reservationSettings.thursday_end : '22:00'}">
			<input type="hidden" name="fridayStart"
				value="${reservationSettings.friday_start != null ? reservationSettings.friday_start : '09:00'}">
			<input type="hidden" name="fridayEnd"
				value="${reservationSettings.friday_end != null ? reservationSettings.friday_end : '22:00'}">
			<input type="hidden" name="saturdayStart"
				value="${reservationSettings.saturday_start != null ? reservationSettings.saturday_start : '09:00'}">
			<input type="hidden" name="saturdayEnd"
				value="${reservationSettings.saturday_end != null ? reservationSettings.saturday_end : '22:00'}">
			<input type="hidden" name="sundayStart"
				value="${reservationSettings.sunday_start != null ? reservationSettings.sunday_start : '09:00'}">
			<input type="hidden" name="sundayEnd"
				value="${reservationSettings.sunday_end != null ? reservationSettings.sunday_end : '22:00'}">

			<!-- 기본 설정 -->
			<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
				<h2
					class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
					<i class="fas fa-toggle-on text-blue-500"></i> 기본 설정
				</h2>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
					<!-- 예약 활성화 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<i class="fas fa-calendar-check text-green-500 text-xl"></i>
								<div>
									<h3 class="font-semibold text-slate-800">예약 시스템 활성화</h3>
									<p class="text-sm text-slate-600">고객이 온라인으로 예약할 수 있습니다</p>
								</div>
							</div>
							<input type="checkbox" name="reservationEnabled"
								class="toggle-switch"
								${reservationSettings.reservation_enabled ? 'checked' : ''}>
						</div>
					</div>

					<!-- 자동 승인 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<i class="fas fa-check-circle text-blue-500 text-xl"></i>
								<div>
									<h3 class="font-semibold text-slate-800">예약 자동 승인</h3>
									<p class="text-sm text-slate-600">예약 요청을 자동으로 승인합니다</p>
								</div>
							</div>
							<input type="checkbox" name="autoAccept" class="toggle-switch"
								${reservationSettings.auto_accept ? 'checked' : ''}>
						</div>
					</div>
				</div>
			</div>

			<!-- 예약 조건 설정 -->
			<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
				<h2
					class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
					<i class="fas fa-users text-purple-500"></i> 예약 조건 설정
				</h2>

				<div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
					<!-- 최소 인원 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<label class="block text-sm font-semibold text-slate-700 mb-3">
							<i class="fas fa-user-minus text-orange-500 mr-2"></i> 최소 예약 인원
						</label> <input type="number" name="minPartySize" min="1" max="20"
							value="${reservationSettings.min_party_size != null ? reservationSettings.min_party_size : 1}"
							class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
						<p class="text-xs text-slate-500 mt-2">명 이상 예약 가능</p>
					</div>

					<!-- 최대 인원 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<label class="block text-sm font-semibold text-slate-700 mb-3">
							<i class="fas fa-user-plus text-green-500 mr-2"></i> 최대 예약 인원
						</label> <input type="number" name="maxPartySize" min="1" max="50"
							value="${reservationSettings.max_party_size != null ? reservationSettings.max_party_size : 10}"
							class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
						<p class="text-xs text-slate-500 mt-2">명 이하 예약 가능</p>
					</div>

					<!-- 예약 가능 일수 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<label class="block text-sm font-semibold text-slate-700 mb-3">
							<i class="fas fa-calendar-alt text-blue-500 mr-2"></i> 예약 가능 기간
						</label> <input type="number" name="advanceBookingDays" min="1" max="365"
							value="${reservationSettings.advance_booking_days != null ? reservationSettings.advance_booking_days : 30}"
							class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
						<p class="text-xs text-slate-500 mt-2">일 전까지 예약 가능</p>
					</div>

					<!-- 최소 예약 시간 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<label class="block text-sm font-semibold text-slate-700 mb-3">
							<i class="fas fa-clock text-red-500 mr-2"></i> 최소 예약 시간
						</label> <input type="number" name="minAdvanceHours" min="1" max="72"
							value="${reservationSettings.min_advance_hours != null ? reservationSettings.min_advance_hours : 2}"
							class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
						<p class="text-xs text-slate-500 mt-2">시간 전까지 예약 가능</p>
					</div>
					
					<!-- ▼▼▼ [수정] 예약 타임 간격 설정 (위치를 여기로 이동) ▼▼▼ -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<label for="time-slot-interval" class="block text-sm font-semibold text-slate-700 mb-3">
							<i class="fas fa-hourglass-half text-indigo-500 mr-2"></i> 예약 시간 간격
						</label>
						<select id="time-slot-interval" name="timeSlotInterval" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
							<option value="5" ${reservationSettings.time_slot_interval == 5 ? 'selected' : ''}>5분</option>
							<option value="10" ${reservationSettings.time_slot_interval == 10 ? 'selected' : ''}>10분</option>
							<option value="15" ${reservationSettings.time_slot_interval == 15 ? 'selected' : ''}>15분</option>
							<option value="30" ${reservationSettings.time_slot_interval == 30 ? 'selected' : ''}>30분</option>
							<option value="60" ${reservationSettings.time_slot_interval == 60 || empty reservationSettings.time_slot_interval ? 'selected' : ''}>1시간 (기본)</option>
							<option value="120" ${reservationSettings.time_slot_interval == 120 ? 'selected' : ''}>2시간</option>
						</select>
						<p class="text-xs text-slate-500 mt-2">예약 시간 버튼의 간격을 설정합니다.</p>
					</div>
				</div>
				
			</div>

			<!-- 예약금 설정 -->
			<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
				<h2
					class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
					<i class="fas fa-receipt text-amber-500"></i> 예약금 설정
				</h2>

				<div class="space-y-6">
					<div
						class="bg-white p-6 rounded-xl border border-slate-200 flex items-center justify-between">
						<div class="flex items-center gap-3">
							<i class="fas fa-shield-check text-amber-500 text-xl"></i>
							<div>
								<h3 class="font-semibold text-slate-800">예약금(선결제) 사용</h3>
								<p class="text-sm text-slate-600">노쇼 방지를 위해 예약 시 선결제 금액을
									설정합니다.</p>
							</div>
						</div>
						<input type="checkbox" name="depositRequired"
							class="toggle-switch"
							${reservationSettings.deposit_required ? 'checked' : ''}>
					</div>

					<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
						<div class="bg-white p-6 rounded-xl border border-slate-200">
							<label class="block text-sm font-semibold text-slate-700 mb-3">
								<i class="fas fa-won-sign text-green-500 mr-2"></i> 예약금 금액
							</label>
							<div class="flex items-center gap-2">
								<input type="number" name="depositAmount" min="0" step="1"
									value="${reservationSettings.deposit_amount != null ? reservationSettings.deposit_amount : ''}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									placeholder="0"> <span class="text-sm text-slate-600">원</span>
							</div>
							<p class="text-xs text-slate-500 mt-2">0원 입력 시 예약금이 청구되지
								않습니다.</p>
						</div>

						<div
							class="md:col-span-2 bg-white p-6 rounded-xl border border-slate-200">
							<label class="block text-sm font-semibold text-slate-700 mb-3">
								<i class="fas fa-comment-dots text-blue-500 mr-2"></i> 예약금 안내 문구
							</label>
							<textarea name="depositDescription" rows="4"
								class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
								placeholder="예) 예약 확정 시 10,000원의 예약금이 결제됩니다. 방문 후 최종 금액에서 차감됩니다.">${reservationSettings.deposit_description}</textarea>
							<p class="text-xs text-slate-500 mt-2">고객이 결제 과정에서 확인할 수 있는
								안내 문구입니다.</p>
						</div>
					</div>

					<div class="bg-amber-50 p-4 rounded-lg border border-amber-200">
						<h4 class="font-medium text-amber-800 mb-2">💡 예약금 운영 가이드</h4>
						<ul class="text-sm text-amber-700 list-disc list-inside space-y-1">
							<li>네이버페이 결제 완료 시 예약이 확정 상태로 전환됩니다.</li>
							<li>환불 정책은 예약금 안내 문구에 명확히 기재해주세요.</li>
							<li>예약금 결제 내역은 업주 관리 페이지에서 확인할 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>

			<!-- 운영 시간 설정 -->
			<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
				<h2
					class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
					<i class="fas fa-business-time text-indigo-500"></i> 요일별 운영 시간
				</h2>

				<div class="flex justify-end mb-4">
					<button type="button" id="enable-all-days-btn"
						class="bg-blue-500 hover:bg-blue-600 text-white text-sm font-semibold px-4 py-2 rounded-lg shadow-md transition-all duration-200 ease-in-out transform hover:scale-105">
						<i class="fas fa-check-double mr-2"></i>모든 요일 활성화
					</button>
				</div>

				<div class="space-y-4">
					<!-- 월요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-red-500 rounded-lg flex items-center justify-center text-white font-bold">
									월</div>
								<div>
									<h3 class="font-semibold text-slate-800">월요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<!-- DEBUG: monday_enabled=[${reservationSettings.monday_enabled}] -->
							<input type="checkbox" name="mondayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.monday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.monday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="mondayStartVisible"
									value="${reservationSettings.monday_start != null ? reservationSettings.monday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=mondayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="mondayEndVisible"
									value="${reservationSettings.monday_end != null ? reservationSettings.monday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=mondayEnd]').value = this.value">
							</div>
						</div>
					</div>

					<!-- 화요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-orange-500 rounded-lg flex items-center justify-center text-white font-bold">
									화</div>
								<div>
									<h3 class="font-semibold text-slate-800">화요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<input type="checkbox" name="tuesdayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.tuesday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.tuesday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="tuesdayStartVisible"
									value="${reservationSettings.tuesday_start != null ? reservationSettings.tuesday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=tuesdayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="tuesdayEndVisible"
									value="${reservationSettings.tuesday_end != null ? reservationSettings.tuesday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=tuesdayEnd]').value = this.value">
							</div>
						</div>
					</div>

					<!-- 수요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-yellow-500 rounded-lg flex items-center justify-center text-white font-bold">
									수</div>
								<div>
									<h3 class="font-semibold text-slate-800">수요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<input type="checkbox" name="wednesdayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.wednesday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.wednesday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="wednesdayStartVisible"
									value="${reservationSettings.wednesday_start != null ? reservationSettings.wednesday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=wednesdayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="wednesdayEndVisible"
									value="${reservationSettings.wednesday_end != null ? reservationSettings.wednesday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=wednesdayEnd]').value = this.value">
							</div>
						</div>
					</div>

					<!-- 목요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-green-500 rounded-lg flex items-center justify-center text-white font-bold">
									목</div>
								<div>
									<h3 class="font-semibold text-slate-800">목요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<input type="checkbox" name="thursdayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.thursday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.thursday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="thursdayStartVisible"
									value="${reservationSettings.thursday_start != null ? reservationSettings.thursday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=thursdayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="thursdayEndVisible"
									value="${reservationSettings.thursday_end != null ? reservationSettings.thursday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=thursdayEnd]').value = this.value">
							</div>
						</div>
					</div>

					<!-- 금요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center text-white font-bold">
									금</div>
								<div>
									<h3 class="font-semibold text-slate-800">금요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<input type="checkbox" name="fridayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.friday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.friday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="fridayStartVisible"
									value="${reservationSettings.friday_start != null ? reservationSettings.friday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=fridayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="fridayEndVisible"
									value="${reservationSettings.friday_end != null ? reservationSettings.friday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=fridayEnd]').value = this.value">
							</div>
						</div>
					</div>

					<!-- 토요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-indigo-500 rounded-lg flex items-center justify-center text-white font-bold">
									토</div>
								<div>
									<h3 class="font-semibold text-slate-800">토요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<input type="checkbox" name="saturdayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.saturday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.saturday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="saturdayStartVisible"
									value="${reservationSettings.saturday_start != null ? reservationSettings.saturday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=saturdayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="saturdayEndVisible"
									value="${reservationSettings.saturday_end != null ? reservationSettings.saturday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=saturdayEnd]').value = this.value">
							</div>
						</div>
					</div>

					<!-- 일요일 -->
					<div class="bg-white p-6 rounded-xl border border-slate-200">
						<div class="flex items-center justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 bg-purple-500 rounded-lg flex items-center justify-center text-white font-bold">
									일</div>
								<div>
									<h3 class="font-semibold text-slate-800">일요일</h3>
									<p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
								</div>
							</div>
							<input type="checkbox" name="sundayEnabled"
								class="toggle-switch day-toggle"
								${reservationSettings.sunday_enabled ? 'checked' : ''}>
						</div>

						<div
							class="grid grid-cols-2 gap-4 day-times ${reservationSettings.sunday_enabled ? '' : 'hidden'}">
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">시작
									시간</label> <input type="time" name="sundayStartVisible"
									value="${reservationSettings.sunday_start != null ? reservationSettings.sunday_start : '09:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=sundayStart]').value = this.value">
							</div>
							<div>
								<label class="block text-sm font-medium text-slate-700 mb-2">종료
									시간</label> <input type="time" name="sundayEndVisible"
									value="${reservationSettings.sunday_end != null ? reservationSettings.sunday_end : '22:00'}"
									class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
									onchange="document.querySelector('input[name=sundayEnd]').value = this.value">
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- 예약 불가 날짜 설정 -->
			<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
				<h2
					class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
					<i class="fas fa-calendar-times text-red-500"></i> 예약 불가 날짜 설정
				</h2>

				<div class="bg-white p-6 rounded-xl border border-slate-200">
					<div class="mb-4">
						<label class="block text-sm font-semibold text-slate-700 mb-3">
							<i class="fas fa-ban text-red-500 mr-2"></i> 휴무일 또는 특별한 날짜 선택
						</label>
						<p class="text-sm text-slate-600 mb-4">여러 날짜를 선택할 수 있습니다. 선택된
							날짜는 예약이 불가능합니다.</p>
						<input type="text" id="blackoutDates" name="blackoutDates"
							placeholder="날짜를 선택하세요..." readonly
							class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 cursor-pointer"
							value="${reservationSettings.blackout_dates != null ? reservationSettings.blackout_dates : ''}">
					</div>
					<div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
						<div class="flex items-center gap-2 text-yellow-800">
							<i class="fas fa-lightbulb"></i> <span class="font-semibold">팁</span>
						</div>
						<p class="text-yellow-700 text-sm mt-1">정기 휴무일이나 특별 행사로 인한
							휴무일을 미리 설정하면 고객 혼란을 방지할 수 있습니다.</p>
					</div>
				</div>
			</div>

			<!-- 특별 안내사항 -->
			<div class="glass-card p-6 rounded-2xl mb-6 slide-up">
				<h2
					class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
					<i class="fas fa-comment-alt text-teal-500"></i> 특별 안내사항
				</h2>

				<div class="bg-white p-6 rounded-xl border border-slate-200">
					<label class="block text-sm font-semibold text-slate-700 mb-3">
						<i class="fas fa-pen text-teal-500 mr-2"></i> 고객에게 전달할 메시지
					</label>
					<textarea name="specialNotes" rows="4"
						placeholder="예약 시 고객에게 안내할 특별한 사항을 입력하세요. (예: 주차 안내, 복장 규정, 특별 요청사항 등)"
						class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 resize-none">${reservationSettings.special_notes != null ? reservationSettings.special_notes : ''}</textarea>
					<p class="text-xs text-slate-500 mt-2">이 메시지는 예약 확인 시 고객에게
						표시됩니다.</p>
				</div>
			</div>

			<!-- 저장 버튼 -->
			<div class="flex justify-center">
				<button type="submit"
					class="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center gap-3">
					<i class="fas fa-save"></i> 설정 저장하기
				</button>
			</div>
		</form>
	</main>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

	<script>
        // JSP의 날짜 데이터를 자바스크립트 변수로 미리 저장합니다.
        var initialBlackoutDates = '${reservationSettings.blackout_dates}';
    </script>

	<script>
        // JSP 변수를 JavaScript로 전달
        var contextPath = '${pageContext.request.contextPath}';
        var restaurantId = '${restaurant.id}';

        // 요일별 토글 처리
        document.addEventListener('DOMContentLoaded', function() {
        	// 1. HTML 요소 선택
            // 메인 토글: '예약 시스템 활성화' 스위치
            const mainToggle = document.querySelector('input[name="reservationEnabled"]');

            // 요일별 설정 컨테이너들: 각 요일의 설정 전체를 감싸는 부모 div 요소들
            // 각 요일 토글('.day-toggle')을 기준으로 가장 가까운 부모 컨테이너를 찾습니다.
            const daySettingContainers = Array.from(document.querySelectorAll('.day-toggle')).map(toggle => 
                toggle.closest('.bg-white.p-6.rounded-xl.border.border-slate-200')
            );
            
            /**
             * @param {boolean} isEnabled - 메인 토글의 활성화 여부 (true: 켬, false: 끔)
             * 요일별 설정 영역 전체의 활성/비활성 상태를 업데이트하는 함수
             */
            function updateDaySettingsState(isEnabled) {
                // 모든 요일별 설정 컨테이너를 순회합니다.
                daySettingContainers.forEach(container => {
                    if (isEnabled) {
                        // 🟢 메인 토글이 켜졌을 때:
                        // 회색 오버레이 효과를 제거하고 모든 입력 필드를 활성화합니다.
                        container.style.opacity = '1';
                        container.style.pointerEvents = 'auto';
                        
                        // 컨테이너 내부의 모든 input(checkbox, time)을 찾아 disabled 속성을 제거합니다.
                        container.querySelectorAll('input').forEach(input => {
                            input.disabled = false;
                        });
                    } else {
                        // 🔴 메인 토글이 꺼졌을 때:
                        // 회색으로 비활성화된 것처럼 보이게 하고, 클릭(상호작용)을 막습니다.
                        container.style.opacity = '0.5';
                        container.style.pointerEvents = 'none';

                        // 컨테이너 내부의 모든 input(checkbox, time)을 찾아 disabled 속성을 추가합니다.
                        container.querySelectorAll('input').forEach(input => {
                            input.disabled = true;
                        });
                    }
                });
            }

            // 2. 이벤트 리스너 연결
            // 메인 토글의 상태가 변경될 때마다(클릭할 때마다) updateDaySettingsState 함수를 호출합니다.
            if (mainToggle) {
                mainToggle.addEventListener('change', function() {
                    // this.checked는 현재 토글의 on(true)/off(false) 상태를 의미합니다.
                    updateDaySettingsState(this.checked);
                });

                // 3. 페이지 최초 로드 시 실행
                // 페이지가 처음 열렸을 때 메인 토글의 초기 상태를 반영하기 위해 함수를 한 번 실행해줍니다.
                updateDaySettingsState(mainToggle.checked);
            }
            
         // 1. 새로 추가한 '모든 요일 활성화' 버튼과 각 요일의 토글 스위치들을 선택합니다.
            const enableAllDaysBtn = document.querySelector('#enable-all-days-btn');
            const allDayToggles = document.querySelectorAll('.day-toggle');

            // 2. 버튼에 'click' 이벤트 리스너를 추가합니다.
            if (enableAllDaysBtn && allDayToggles.length > 0) {
                enableAllDaysBtn.addEventListener('click', function() {
                    
                    // 3. 모든 요일 토글들을 순회하면서 상태를 변경합니다.
                    allDayToggles.forEach(toggle => {
                        // 스위치를 'on' 상태로 변경합니다.
                        toggle.checked = true;

                        // 4. 중요: UI(시간 입력창 표시)를 업데이트하기 위해 'change' 이벤트를 강제로 발생시킵니다.
                        // 이렇게 해야 스위치를 직접 클릭한 것처럼 시간 입력창이 나타납니다.
                        toggle.dispatchEvent(new Event('change'));
                    });
                });
            }
        	
            const dayToggles = document.querySelectorAll('.day-toggle');

            dayToggles.forEach(toggle => {
                toggle.addEventListener('change', function() {
                    const dayTimes = this.closest('.bg-white').querySelector('.day-times');
                    if (this.checked) {
                        dayTimes.style.display = 'grid';
                    } else {
                        dayTimes.style.display = 'none';
                    }
                });
            });

            // 블랙아웃 날짜 달력 설정
            flatpickr("#blackoutDates", {
                mode: "multiple",
                dateFormat: "Y-m-d",
                locale: "ko",
                minDate: "today",
                inline: false,
                altInput: true,
                altFormat: "Y년 m월 d일",
                defaultDate: initialBlackoutDates ? initialBlackoutDates.split(',') : [],
                allowInput: false,
                clickOpens: true,
                appendTo: document.body,
                onChange: function(selectedDates, dateStr, instance) {
                    console.log("Selected dates:", dateStr);
                }
            });

            const depositToggle = document.querySelector('input[name="depositRequired"]');
            const depositAmountInput = document.querySelector('input[name="depositAmount"]');
            const depositDescription = document.querySelector('textarea[name="depositDescription"]');

            if (depositToggle && depositAmountInput && depositDescription) {
                const normalizeDepositValue = () => {
                    if (!depositToggle.checked) {
                        return;
                    }
                    const parsed = parseInt(depositAmountInput.value || '0', 10);
                    if (Number.isNaN(parsed) || parsed < 0) {
                        depositAmountInput.value = '';
                    } else {
                        depositAmountInput.value = parsed.toString();
                    }
                };

                const syncDepositFields = (initial) => {
                    const enabled = depositToggle.checked;
                    depositAmountInput.readOnly = !enabled;
                    depositDescription.readOnly = !enabled;
                    depositAmountInput.classList.toggle('cursor-not-allowed', !enabled);
                    depositDescription.classList.toggle('cursor-not-allowed', !enabled);
                    depositAmountInput.closest('div.bg-white').classList.toggle('opacity-50', !enabled);
                    depositDescription.closest('div.bg-white').classList.toggle('opacity-50', !enabled);
                    if (!enabled && !initial) {
                        depositAmountInput.value = '';
                        depositDescription.value = '';
                    }
                    if (enabled) {
                        normalizeDepositValue();
                    }
                };

                syncDepositFields(true);
                depositToggle.addEventListener('change', () => syncDepositFields(false));
                depositAmountInput.addEventListener('blur', normalizeDepositValue);
            }
        });

        // 폼 제출 처리 - 수정된 버전
        const reservationForm = document.getElementById('reservationSettingsForm');
        reservationForm.addEventListener('submit', function(e) {
            e.preventDefault();

            console.log('폼 제출 시작');

            // 체크박스 상태 직접 확인
            console.log('=== 직접 체크박스 상태 확인 ===');
            const mondayCheckbox = document.querySelector('input[name="mondayEnabled"]');
            const tuesdayCheckbox = document.querySelector('input[name="tuesdayEnabled"]');
            console.log('월요일 체크박스:', mondayCheckbox, '체크 상태:', mondayCheckbox ? mondayCheckbox.checked : 'not found');
            console.log('화요일 체크박스:', tuesdayCheckbox, '체크 상태:', tuesdayCheckbox ? tuesdayCheckbox.checked : 'not found');

            // 시간 필드 직접 확인
            console.log('=== 시간 필드 직접 확인 ===');
            const mondayStartVisible = document.querySelector('input[name="mondayStartVisible"]');
            const mondayEndVisible = document.querySelector('input[name="mondayEndVisible"]');
            const tuesdayStartVisible = document.querySelector('input[name="tuesdayStartVisible"]');
            const tuesdayEndVisible = document.querySelector('input[name="tuesdayEndVisible"]');

            console.log('월요일 시작:', mondayStartVisible ? mondayStartVisible.value : 'not found');
            console.log('월요일 종료:', mondayEndVisible ? mondayEndVisible.value : 'not found');
            console.log('화요일 시작:', tuesdayStartVisible ? tuesdayStartVisible.value : 'not found');
            console.log('화요일 종료:', tuesdayEndVisible ? tuesdayEndVisible.value : 'not found');

            // 폼 데이터를 직접 수집
            const formData = new FormData();

            // 기본 설정들
            const reservationEnabled = document.querySelector('input[name="reservationEnabled"]');
            const autoAccept = document.querySelector('input[name="autoAccept"]');

            formData.append('reservationEnabled', reservationEnabled ? reservationEnabled.checked.toString() : 'false');
            formData.append('autoAccept', autoAccept ? autoAccept.checked.toString() : 'false');
            const depositToggle = document.querySelector('input[name="depositRequired"]');
            const depositAmount = document.querySelector('input[name="depositAmount"]');
            const depositDescription = document.querySelector('textarea[name="depositDescription"]');
            formData.append('depositRequired', depositToggle ? depositToggle.checked.toString() : 'false');
            formData.append('depositAmount', depositAmount ? depositAmount.value : '');
            formData.append('depositDescription', depositDescription ? depositDescription.value : '');

            console.log('기본 설정:', {
                reservationEnabled: reservationEnabled ? reservationEnabled.checked : false,
                autoAccept: autoAccept ? autoAccept.checked : false
            });

            // 요일별 설정 직접 수집
            const dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

            // 먼저 보이는 필드에서 숨겨진 필드로 값 복사
            dayNames.forEach(day => {
                const visibleStart = document.querySelector('input[name="' + day + 'StartVisible"]');
                const visibleEnd = document.querySelector('input[name="' + day + 'EndVisible"]');
                const hiddenStart = document.querySelector('input[name="' + day + 'Start"]');
                const hiddenEnd = document.querySelector('input[name="' + day + 'End"]');

                // 보이는 필드가 있고 값이 있으면 숨겨진 필드에 복사
                if (visibleStart && visibleStart.value && hiddenStart) {
                    hiddenStart.value = visibleStart.value;
                    console.log(day + ' 시작 시간 업데이트: ' + visibleStart.value);
                }
                if (visibleEnd && visibleEnd.value && hiddenEnd) {
                    hiddenEnd.value = visibleEnd.value;
                    console.log(day + ' 종료 시간 업데이트: ' + visibleEnd.value);
                }
            });

            // 요일별 데이터 수집
            dayNames.forEach(day => {
                const dayEnabled = document.querySelector('input[name="' + day + 'Enabled"]');
                const hiddenStart = document.querySelector('input[name="' + day + 'Start"]');
                const hiddenEnd = document.querySelector('input[name="' + day + 'End"]');

                const enabledValue = dayEnabled ? dayEnabled.checked.toString() : 'false';
                const startValue = hiddenStart ? hiddenStart.value : '09:00';
                const endValue = hiddenEnd ? hiddenEnd.value : '22:00';

                formData.append(day + 'Enabled', enabledValue);
                formData.append(day + 'Start', startValue);
                formData.append(day + 'End', endValue);

                console.log(day + ':', {
                    enabled: enabledValue,
                    start: startValue,
                    end: endValue
                });
            });

            // 기타 설정들
            const minPartySize = document.querySelector('input[name="minPartySize"]');
            const maxPartySize = document.querySelector('input[name="maxPartySize"]');
            const advanceBookingDays = document.querySelector('input[name="advanceBookingDays"]');
            const minAdvanceHours = document.querySelector('input[name="minAdvanceHours"]');
            const specialNotes = document.querySelector('textarea[name="specialNotes"]');
            const blackoutDates = document.querySelector('input[name="blackoutDates"]');

            if (minPartySize) formData.append('minPartySize', minPartySize.value || '1');
            if (maxPartySize) formData.append('maxPartySize', maxPartySize.value || '10');
            if (advanceBookingDays) formData.append('advanceBookingDays', advanceBookingDays.value || '30');
            if (minAdvanceHours) formData.append('minAdvanceHours', minAdvanceHours.value || '2');
            if (specialNotes) formData.append('specialNotes', specialNotes.value || '');
            if (blackoutDates) formData.append('blackoutDates', blackoutDates.value || '');

            // FormData 크기 확인
            console.log('FormData 항목 수:', Array.from(formData.entries()).length);

            // 전송할 데이터 확인
            console.log('=== 전송할 데이터 ===');
            let count = 0;
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
                count++;
            }
            console.log('총 ' + count + '개 항목 전송');

            // URLSearchParams 기반으로 전체 데이터 재구성 (서버 단에서 FormData 파라미터 인식 문제 대응)
            if (true) {
                console.log('URLSearchParams 기반으로 전송 데이터를 구성합니다.');
                const params = new URLSearchParams();

                params.set('reservationEnabled', reservationEnabled ? reservationEnabled.checked.toString() : 'false');
                params.set('autoAccept', autoAccept ? autoAccept.checked.toString() : 'false');
                params.set('depositRequired', depositToggle ? depositToggle.checked.toString() : 'false');
                params.set('depositAmount', depositAmount ? depositAmount.value : '');
                params.set('depositDescription', depositDescription ? depositDescription.value : '');

                // 요일별 체크박스 직접 처리
                params.set('mondayEnabled', mondayCheckbox ? mondayCheckbox.checked.toString() : 'false');
                params.set('tuesdayEnabled', tuesdayCheckbox ? tuesdayCheckbox.checked.toString() : 'false');

                // 나머지 요일들
                const wednesdayCheckbox = document.querySelector('input[name="wednesdayEnabled"]');
                const thursdayCheckbox = document.querySelector('input[name="thursdayEnabled"]');
                const fridayCheckbox = document.querySelector('input[name="fridayEnabled"]');
                const saturdayCheckbox = document.querySelector('input[name="saturdayEnabled"]');
                const sundayCheckbox = document.querySelector('input[name="sundayEnabled"]');

                params.set('wednesdayEnabled', wednesdayCheckbox ? wednesdayCheckbox.checked.toString() : 'false');
                params.set('thursdayEnabled', thursdayCheckbox ? thursdayCheckbox.checked.toString() : 'false');
                params.set('fridayEnabled', fridayCheckbox ? fridayCheckbox.checked.toString() : 'false');
                params.set('saturdayEnabled', saturdayCheckbox ? saturdayCheckbox.checked.toString() : 'false');
                params.set('sundayEnabled', sundayCheckbox ? sundayCheckbox.checked.toString() : 'false');

                // 시간 설정들 - 앞서 찾은 요소들 재사용
                params.set('mondayStart', mondayStartVisible ? mondayStartVisible.value : '09:00');
                params.set('mondayEnd', mondayEndVisible ? mondayEndVisible.value : '22:00');
                params.set('tuesdayStart', tuesdayStartVisible ? tuesdayStartVisible.value : '09:00');
                params.set('tuesdayEnd', tuesdayEndVisible ? tuesdayEndVisible.value : '22:00');

                // 나머지 요일들 (체크 안 된 요일들은 기본값)
                const wednesdayStartVisible = document.querySelector('input[name="wednesdayStartVisible"]');
                const wednesdayEndVisible = document.querySelector('input[name="wednesdayEndVisible"]');
                const thursdayStartVisible = document.querySelector('input[name="thursdayStartVisible"]');
                const thursdayEndVisible = document.querySelector('input[name="thursdayEndVisible"]');
                const fridayStartVisible = document.querySelector('input[name="fridayStartVisible"]');
                const fridayEndVisible = document.querySelector('input[name="fridayEndVisible"]');
                const saturdayStartVisible = document.querySelector('input[name="saturdayStartVisible"]');
                const saturdayEndVisible = document.querySelector('input[name="saturdayEndVisible"]');
                const sundayStartVisible = document.querySelector('input[name="sundayStartVisible"]');
                const sundayEndVisible = document.querySelector('input[name="sundayEndVisible"]');

                params.set('wednesdayStart', wednesdayStartVisible ? wednesdayStartVisible.value : '09:00');
                params.set('wednesdayEnd', wednesdayEndVisible ? wednesdayEndVisible.value : '22:00');
                params.set('thursdayStart', thursdayStartVisible ? thursdayStartVisible.value : '09:00');
                params.set('thursdayEnd', thursdayEndVisible ? thursdayEndVisible.value : '22:00');
                params.set('fridayStart', fridayStartVisible ? fridayStartVisible.value : '09:00');
                params.set('fridayEnd', fridayEndVisible ? fridayEndVisible.value : '22:00');
                params.set('saturdayStart', saturdayStartVisible ? saturdayStartVisible.value : '09:00');
                params.set('saturdayEnd', saturdayEndVisible ? saturdayEndVisible.value : '22:00');
                params.set('sundayStart', sundayStartVisible ? sundayStartVisible.value : '09:00');
                params.set('sundayEnd', sundayEndVisible ? sundayEndVisible.value : '22:00');

                console.log('시간 값 확인:', {
                    mondayEnd: mondayEndVisible ? mondayEndVisible.value : 'not found',
                    tuesdayEnd: tuesdayEndVisible ? tuesdayEndVisible.value : 'not found'
                });

                // 기타 설정들
                const minPartySize = document.querySelector('input[name="minPartySize"]');
                const maxPartySize = document.querySelector('input[name="maxPartySize"]');
                const advanceBookingDays = document.querySelector('input[name="advanceBookingDays"]');
                const minAdvanceHours = document.querySelector('input[name="minAdvanceHours"]');
                const specialNotes = document.querySelector('textarea[name="specialNotes"]');
                const blackoutDates = document.querySelector('input[name="blackoutDates"]');
                const timeSlotInterval = document.querySelector('select[name="timeSlotInterval"]');

                if (minPartySize) params.set('minPartySize', minPartySize.value || '1');
                if (maxPartySize) params.set('maxPartySize', maxPartySize.value || '10');
                if (advanceBookingDays) params.set('advanceBookingDays', advanceBookingDays.value || '30');
                if (minAdvanceHours) params.set('minAdvanceHours', minAdvanceHours.value || '2');
                if (specialNotes) params.set('specialNotes', specialNotes.value || '');
                if (blackoutDates) params.set('blackoutDates', blackoutDates.value || '');
                if (timeSlotInterval) params.set('timeSlotInterval', timeSlotInterval.value || '30');

                console.log('URLSearchParams 데이터:', params.toString());

                // 버튼 상태 관리
                const submitBtn = this.querySelector('button[type="submit"]');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>저장 중...';
                submitBtn.disabled = true;

                // URLSearchParams로 전송
                fetch(contextPath + '/reservation-settings/' + restaurantId + '/save', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('success', '예약 설정이 성공적으로 저장되었습니다! 잠시 후 내 음식점 목록으로 이동합니다.');
                     // 2초 후에 페이지 이동
                        setTimeout(() => {
                            window.location.href = contextPath + '/business/restaurants';
                        }, 2000);
                    } else {
                        showNotification('error', '설정 저장 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('error', '네트워크 오류로 저장에 실패했습니다.');
                })
                .finally(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                });
                return; // FormData 전송을 건너뜀
            }

            // 로딩 상태 표시
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>저장 중...';
            submitBtn.disabled = true;

            fetch(contextPath + '/reservation-settings/' + restaurantId + '/save', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('success', '예약 설정이 성공적으로 저장되었습니다!');
                } else {
                    showNotification('error', '설정 저장 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('error', '네트워크 오류로 저장에 실패했습니다.');
            })
            .finally(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });

        // 알림 표시 함수
        function showNotification(type, message) {
            const notification = document.createElement('div');
            const baseClasses = 'fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transform transition-all duration-300';
            const typeClasses = type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white';
            notification.className = baseClasses + ' ' + typeClasses;

            const iconClass = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
            notification.innerHTML =
                '<div class="flex items-center gap-3">' +
                    '<i class="fas ' + iconClass + '"></i>' +
                    '<span>' + message + '</span>' +
                '</div>';

            document.body.appendChild(notification);

            // 애니메이션
            setTimeout(() => notification.classList.add('translate-x-0'), 100);

            // 3초 후 제거
            setTimeout(() => {
                notification.classList.add('translate-x-full');
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }
    </script>
</body>
</html>
