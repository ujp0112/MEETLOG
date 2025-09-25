<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Properties, java.io.FileInputStream"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - 새 가게 등록</title>
<script src="https://cdn.tailwindcss.com"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services&autoload=false"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
}

.form-input, .form-select {
	display: block;
	width: 100%;
	border-radius: 0.5rem;
	border: 1px solid #cbd5e1;
	padding: 0.75rem 1rem;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	background-image: none;
}

.form-input:focus, .form-select:focus {
	outline: 2px solid transparent;
	outline-offset: 2px;
	border-color: #38bdf8;
	box-shadow: 0 0 0 2px #7dd3fc;
}

.form-btn-primary {
	display: inline-flex;
	justify-content: center;
	border-radius: 0.5rem;
	background-color: #0284c7;
	padding: 0.75rem 1rem;
	font-weight: 600;
	color: white;
	transition: background-color 0.2s;
}

.form-btn-primary:hover {
	background-color: #0369a1;
}

.day-disabled {
	background-color: #f3f4f6 !important;
	opacity: 0.7;
}

.day-disabled select, .day-disabled button, .day-disabled input {
	cursor: not-allowed !important;
}
/* add-restaurant.jsp의 <style> 태그 안에 추가 */
.image-add-btn {
	width: 120px;
	height: 120px;
	border: 2px dashed #cbd5e1;
	border-radius: 0.5rem;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	color: #64748b;
	transition: all 0.2s;
}

.image-add-btn:hover {
	border-color: #38bdf8;
	color: #0284c7;
}

.plus-icon {
	font-size: 2.5rem;
	line-height: 1;
	font-weight: 300;
}

.add-text {
	font-size: 0.8rem;
	margin-top: 0.25rem;
	font-family: 'NanumGothic', sans-serif; /* 나눔고딕 폰트 적용 */
}
/* 아코디언(드롭다운) 스타일 */
.accordion-header {
	cursor: pointer;
	padding: 1rem;
	background-color: #f8fafc;
	border-radius: 0.5rem;
	transition: background-color 0.2s;
}

.accordion-header:hover {
	background-color: #f1f5f9;
}

.accordion-content {
	display: none; /* 기본적으로 숨김 */
	padding: 1.5rem;
	border: 1px solid #e2e8f0;
	border-top: none;
	border-radius: 0 0 0.5rem 0.5rem;
}
/* add-restaurant.jsp의 <style> 태그 안에 추가 */
.image-preview-wrapper {
	position: relative;
}

.delete-preview-btn {
	position: absolute;
	top: -8px;
	right: -8px;
	width: 24px;
	height: 24px;
	background-color: rgba(0, 0, 0, 0.6);
	color: white;
	border: 2px solid white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 14px;
	font-weight: bold;
	cursor: pointer;
	line-height: 1;
}
</style>
</head>
<body class="bg-gray-100">
	<div class="max-w-4xl mx-auto py-12 px-4">
		<div class="bg-white rounded-2xl shadow-xl p-8 md:p-12">
			<h1 class="text-3xl font-bold text-gray-900 mb-2">새 가게 등록</h1>
			<p class="text-gray-600 mb-8">MEET LOG에 등록하여 가게를 홍보하고 관리하세요.</p>
			<form id="restaurantForm" class="space-y-6">

				<%-- 기본 정보 --%>
				<div class="grid grid-cols-1 md:grid-cols-2 gap-6 border-t pt-6">
					<div>
						<label for="name" class="block text-sm font-medium text-gray-700">가게
							이름</label> <input type="text" id="name" name="name" required
							class="form-input mt-1">
					</div>
					<div>
						<label for="category"
							class="block text-sm font-medium text-gray-700">카테고리</label> <select
							id="category" name="category" required class="form-select mt-1">
							<option value="">선택하세요</option>
							<option value="한식">한식</option>
							<option value="중식">중식</option>
							<option value="일식">일식</option>
							<option value="양식">양식</option>
							<option value="아시안">아시안</option>
							<option value="카페">카페</option>
							<option value="주점">주점</option>
							<option value="기타">기타</option>
						</select>
					</div>
				</div>

				<%-- 주소 정보 --%>
				<div class="border-t pt-6 space-y-2">
					<label class="block text-sm font-medium text-gray-700">주소
						정보</label>
					<div class="flex items-center gap-2">
						<input type="text" id="address" name="address" required
							class="form-input" placeholder="오른쪽 '주소 검색' 버튼을 클릭하세요" readonly>
						<button type="button" id="searchAddressBtn"
							class="form-btn-primary whitespace-nowrap px-4 py-2 text-sm">주소
							검색</button>
					</div>
					<div>
						<label for="location"
							class="block text-sm font-medium text-gray-700 mt-2">지역
							(자동 입력)</label> <input type="text" id="location" name="location" required
							class="form-input mt-1 bg-gray-100" readonly>
					</div>
					<input type="text" id="detail_address" name="detail_address"
						class="form-input" placeholder="상세 주소를 입력하세요"> <input
						type="hidden" id="jibun_address" name="jibun_address"> <input
						type="hidden" id="latitude" name="latitude"> <input
						type="hidden" id="longitude" name="longitude">
				</div>

				<%-- 상세 정보 --%>
				<div class="border-t pt-6 space-y-6">
					<div>
						<label for="phone" class="block text-sm font-medium text-gray-700">전화번호</label>
						<input type="text" id="phone" name="phone" class="form-input mt-1"
							placeholder="예: 02-1234-5678">
					</div>
					<div>
						<label for="description"
							class="block text-sm font-medium text-gray-700">가게 설명</label>
						<textarea id="description" name="description" rows="4"
							class="form-input mt-1"
							placeholder="가게에 대한 상세한 설명을 입력해주세요. (예: 주차 정보, 가게 특징 등)"></textarea>
					</div>
					<div class="space-y-4 border-t pt-6">
						<%-- 브레이크 타임 --%>
						<div>
							<label for="break_time_text"
								class="block text-sm font-medium text-gray-700">브레이크 타임
								(고객 안내용)</label> <input type="text" id="break_time_text"
								name="break_time_text" class="form-input mt-1"
								placeholder="예: 15:00 ~ 17:00">
						</div>
						<div>
							<div class="accordion-header flex justify-between items-center">
								<h3 class="text-lg font-semibold text-gray-800">🕒 가게 대표
									운영시간 설정</h3>
								<span class="transform transition-transform duration-300">▼</span>
							</div>
							<div class="accordion-content space-y-4">
								<div id="main-hours-container" class="space-y-4">
									<c:forEach var="day" begin="1" end="7">
										<c:set var="dayNames" value="월요일,화요일,수요일,목요일,금요일,토요일,일요일" />
										<c:set var="dayName" value="${dayNames.split(',')[day - 1]}" />
										<div id="main_day_${day}_wrapper"
											class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300"
											data-day-index="${day}">
											<div class="flex items-center justify-between">
												<label class="font-semibold text-gray-800">${dayName}</label>
												<div>
													<input type="checkbox" id="main_is_closed_${day}"
														name="main_is_closed_${day}"
														class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
													<label for="main_is_closed_${day}" class="ml-2 text-sm">휴무</label>
												</div>
											</div>
											<div class="slots-container mt-2 space-y-2">
												<div class="time-slot flex items-center gap-2">
													<select name="main_day_${day}_open_1_ampm"
														class="time-select form-select w-24"><option
															value="am">오전</option>
														<option value="pm">오후</option></select> <select
														name="main_day_${day}_open_1_time"
														class="time-select form-select"><c:forEach
															var="h" begin="0" end="11">
															<c:forEach var="m" begin="0" end="30" step="30">
																<c:set var="hour" value="${h==0?12:h}" />
																<c:set var="timeValue"
																	value="${String.format('%02d:%02d',hour,m)}" />
																<option value="${timeValue}">${timeValue}</option>
															</c:forEach>
														</c:forEach></select> <input type="hidden" name="main_day_${day}_open_1"
														class="hidden-time-input"> <span>~</span> <select
														name="main_day_${day}_close_1_ampm"
														class="time-select form-select w-24"><option
															value="am">오전</option>
														<option value="pm" selected>오후</option></select> <select
														name="main_day_${day}_close_1_time"
														class="time-select form-select"><c:forEach
															var="h" begin="0" end="11">
															<c:forEach var="m" begin="0" end="30" step="30">
																<c:set var="hour" value="${h==0?12:h}" />
																<c:set var="timeValue"
																	value="${String.format('%02d:%02d',hour,m)}" />
																<option value="${timeValue}"
																	${h==10&&m==0?'selected':''}>${timeValue}</option>
															</c:forEach>
														</c:forEach></select> <input type="hidden" name="main_day_${day}_close_1"
														class="hidden-time-input">
												</div>
											</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</div>

					<div class="space-y-4 border-t pt-6">
						<%-- 2. 온라인 예약 시간 설정 --%>
						<div>
							<div class="accordion-header flex justify-between items-center">
								<h3 class="text-lg font-semibold text-gray-800">📅 온라인 예약
									시간 설정</h3>
								<span class="transform transition-transform duration-300">▼</span>
							</div>
							<div class="accordion-content">
								<%-- 기존 예약 시간 UI가 이 안으로 들어갑니다 --%>
								<div class="flex justify-between items-center mb-2">
									<p class="text-sm text-gray-600">온라인 예약을 받을 시간대를 설정합니다.</p>
									<button type="button" id="applyToAllBtn"
										class="text-sm bg-gray-200 px-3 py-1 rounded-md hover:bg-gray-300">월요일
										기준으로 전체 적용</button>
								</div>
								<div id="hours-container" class="space-y-4 mt-2">
									<%-- 여기에 기존의 예약 시간 설정 c:forEach 루프가 그대로 들어갑니다 --%>
									<c:forEach var="day" begin="1" end="7">
										<c:set var="dayNames" value="월요일,화요일,수요일,목요일,금요일,토요일,일요일" />
										<%-- ▼▼▼ [수정] status.index 대신 day-1을 사용하도록 변경 ▼▼▼ --%>
										<c:set var="dayName" value="${dayNames.split(',')[day - 1]}" />

										<div id="day_${day}_wrapper"
											class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300"
											data-day-index="${day}">
											<div class="flex items-center justify-between">
												<label class="font-semibold text-gray-800">${dayName}</label>
												<div>
													<input type="checkbox" id="is_closed_${day}"
														name="is_closed_${day}"
														class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
													<label for="is_closed_${day}" class="ml-2 text-sm">휴무</label>
												</div>
											</div>
											<div class="slots-container mt-2 space-y-2">
												<div class="time-slot flex items-center gap-2">
													<select name="day_${day}_open_1_ampm"
														class="time-select form-select w-24">
														<option value="am">오전</option>
														<option value="pm">오후</option>
													</select> <select name="day_${day}_open_1_time"
														class="time-select form-select">
														<c:forEach var="h" begin="0" end="11">
															<c:forEach var="m" begin="0" end="30" step="30">
																<c:set var="hour" value="${h == 0 ? 12 : h}" />
																<c:set var="timeValue"
																	value="${String.format('%02d:%02d', hour, m)}" />
																<option value="${timeValue}">${timeValue}</option>
															</c:forEach>
														</c:forEach>
													</select> <input type="hidden" name="day_${day}_open_1"
														class="hidden-time-input"> <span>~</span> <select
														name="day_${day}_close_1_ampm"
														class="time-select form-select w-24">
														<option value="am">오전</option>
														<option value="pm" selected>오후</option>
													</select> <select name="day_${day}_close_1_time"
														class="time-select form-select">
														<c:forEach var="h" begin="0" end="11">
															<c:forEach var="m" begin="0" end="30" step="30">
																<c:set var="hour" value="${h == 0 ? 12 : h}" />
																<c:set var="timeValue"
																	value="${String.format('%02d:%02d', hour, m)}" />
																<option value="${timeValue}"
																	${h == 10 && m == 0 ? 'selected' : ''}>${timeValue}</option>
															</c:forEach>
														</c:forEach>
													</select> <input type="hidden" name="day_${day}_close_1"
														class="hidden-time-input">
													<button type="button"
														class="add-slot-btn text-blue-600 text-sm font-semibold whitespace-nowrap">시간
														추가</button>
												</div>
											</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</div>
					<%-- 이미지 업로드 --%>
					<div>
						<label class="block text-sm font-medium text-gray-700">대표
							이미지 파일 (여러 개 선택 가능)</label>
						<%-- 실제 파일 input은 숨깁니다 --%>
						<input type="file" id="restaurantImage" name="restaurantImage"
							accept="image/*" multiple class="hidden">

						<div id="imagePreviewContainer"
							class="mt-4 flex flex-wrap gap-4 items-center">
							<%-- 이미지 미리보기는 여기에 동적으로 추가됩니다 --%>

							<%-- 이미지 추가 버튼 --%>
							<label for="restaurantImage" class="image-add-btn"> <span
								class="plus-icon">+</span> <span class="add-text">이미지 추가</span>
							</label>
						</div>
					</div>
				</div>

				<div class="flex justify-end space-x-4 border-t pt-6">
					<a href="${pageContext.request.contextPath}/business/restaurants"
						class="bg-gray-200 text-gray-800 px-6 py-2 rounded-md hover:bg-gray-300">취소</a>
					<button type="button" id="submitBtn"
						class="form-btn-primary px-6 py-2">가게 등록</button>
				</div>
			</form>
		</div>
	</div>
<%-- body 태그 맨 아래, 기존 <script>...</script>를 모두 지우고 아래 코드로 교체 --%>
<script>
    // --- 전역 변수: 업로드할 파일들을 관리하는 배열 ---
    let uploadedFiles = [];

    $(document).ready(function() {
        // --- Kakao Maps API 초기화 ---
        kakao.maps.load(() => console.log("Kakao Maps API가 준비되었습니다."));

        // --- 주소 검색 ---
        $('#searchAddressBtn').on('click', function() {
            new daum.Postcode({
                oncomplete: function(data) {
                    $('#address').val(data.roadAddress);
                    $('#location').val(data.sigungu);
                    $('#jibun_address').val(data.jibunAddress);
                    const geocoder = new kakao.maps.services.Geocoder();
                    geocoder.addressSearch(data.roadAddress, function(result, status) {
                        if (status === kakao.maps.services.Status.OK) {
                            $('#latitude').val(result[0].y);
                            $('#longitude').val(result[0].x);
                        }
                    });
                }
            }).open();
        });

        // --- 이미지 처리 ---
        // 1. 이미지 추가
        $('#restaurantImage').on('change', function(event) {
            const newFiles = Array.from(event.target.files);
            newFiles.forEach(file => {
                file.uniqueId = 'file_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
                uploadedFiles.push(file);
                const reader = new FileReader();
                reader.onload = function(e) {
                    // [수정] JSP EL과 충돌하지 않는 문자열 더하기 방식으로 변경
                    const previewHtml =
                        '<div class="image-preview-wrapper" data-file-id="' + file.uniqueId + '">' +
                        '    <img src="' + e.target.result + '" class="rounded-lg shadow-sm" style="width: 120px; height: 120px; object-fit: cover;">' +
                        '    <button type="button" class="delete-preview-btn">×</button>' +
                        '</div>';
                        
                    $('.image-add-btn').before(previewHtml);
                };
                reader.readAsDataURL(file);
            });
            $(this).val('');
        });

        // 2. 이미지 삭제
        $('#imagePreviewContainer').on('click', '.delete-preview-btn', function() {
            const wrapper = $(this).closest('.image-preview-wrapper');
            const fileIdToRemove = wrapper.data('file-id');
            uploadedFiles = uploadedFiles.filter(file => file.uniqueId !== fileIdToRemove);
            wrapper.remove();
        });

        // --- 폼 제출 (비동기 Fetch) ---
        $('#submitBtn').on('click', function() {
            $('.time-select').trigger('change');
            const form = document.getElementById('restaurantForm');
            const formData = new FormData(form);
			console.log(uploadedFiles);
            uploadedFiles.forEach(file => {
                formData.append('restaurantImage', file);
            });

            fetch('${pageContext.request.contextPath}/business/restaurants/add', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    window.location.href = '${pageContext.request.contextPath}/business/restaurants';
                } else {
                    return response.text().then(text => { throw new Error(text || '서버 오류') });
                }
            })
            .catch(error => {
                alert('가게 등록 중 오류가 발생했습니다: ' + error.message);
            });
        });

        // --- 운영시간/예약시간 공통 로직 ---
        const updateHiddenTime = ($select) => {
            const $slot = $select.closest('.time-slot');
            if ($slot.length === 0) return;
            const selectName = $select.attr('name');
            const isForOpen = selectName.includes('_open_');
            const $ampmSelect = isForOpen ? $slot.find('select[name*="_open_"][name*="_ampm"]') : $slot.find('select[name*="_close_"][name*="_ampm"]');
            const $timeSelect = isForOpen ? $slot.find('select[name*="_open_"][name*="_time"]') : $slot.find('select[name*="_close_"][name*="_time"]');
            const $hiddenInput = isForOpen ? $slot.find('input.hidden-time-input[name*="_open_"]') : $slot.find('input.hidden-time-input[name*="_close_"]');
            const ampm = $ampmSelect.val();
            const time = $timeSelect.val();
            if (!time) return;
            let [hour, minute] = time.split(':').map(Number);
            if (ampm === 'pm' && hour < 12) hour += 12;
            if (ampm === 'am' && hour === 12) hour = 0;
            $hiddenInput.val(String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0'));
        };

        $('.day-toggle-checkbox').on('change', function() {
            const $wrapper = $(this).closest('.day-wrapper');
            const isChecked = $(this).is(':checked');
            $wrapper.toggleClass('day-disabled', isChecked);
            $wrapper.find('select, button, input').not(this).prop('disabled', isChecked);
        });

        $('body').on('change', '.time-select', function() {
            updateHiddenTime($(this));
        });

        // --- [채움] 온라인 예약 시간 추가 ---
        $('#hours-container').on('click', '.add-slot-btn', function() {
            const $wrapper = $(this).closest('.day-wrapper');
            const dayIndex = $wrapper.data('day-index');
            const slotCount = $wrapper.find('.time-slot').length;
            const newSlotIndex = slotCount + 1;
            const firstSlotHtml = $wrapper.find('.time-slot').first().html();
            const newSlotHtml = `<div class="time-slot flex items-center gap-2">${firstSlotHtml}</div>`;
            
            // name 속성의 인덱스를 새 인덱스로 변경
            const finalHtml = newSlotHtml.replace(/_1/g, `_${newSlotIndex}`)
                                          .replace('시간 추가', '삭제')
                                          .replace('add-slot-btn', 'remove-slot-btn text-red-500');
            
            $wrapper.find('.slots-container').append(finalHtml);
        });

        // --- [채움] 온라인 예약 시간 삭제 ---
        $('#hours-container').on('click', '.remove-slot-btn', function() {
            $(this).closest('.time-slot').remove();
        });

        // --- [채움] 전체 요일 적용 ---
        $('#applyToAllBtn').on('click', function() {
            const $mondayWrapper = $('#day_1_wrapper');
            const mondayIsClosed = $mondayWrapper.find('.day-toggle-checkbox').is(':checked');
            const mondaySlotsHtml = $mondayWrapper.find('.slots-container').html();

            if (!confirm('월요일의 설정을 다른 모든 요일에 덮어씌우시겠습니까?')) {
                return;
            }

            for (let i = 2; i <= 7; i++) {
                const $otherDayWrapper = $('#day_' + i + '_wrapper');
                $otherDayWrapper.find('.day-toggle-checkbox').prop('checked', mondayIsClosed).trigger('change');
                if (!mondayIsClosed) {
                    const otherDaySlotsHtml = mondaySlotsHtml.replace(/day_1/g, 'day_' + i);
                    $otherDayWrapper.find('.slots-container').html(otherDaySlotsHtml);
                }
            }
            alert('월요일 설정을 모든 요일에 적용했습니다.');
            // 변경된 select 값에 대해 hidden input 값 업데이트
            $('.time-select').trigger('change');
        });

        // --- 아코디언 메뉴 ---
        $('.accordion-header').on('click', function() {
            $(this).find('span').toggleClass('rotate-180');
            $(this).next('.accordion-content').slideToggle(300);
        });

        // 페이지 로드 시 hidden input 초기값 설정
        $('.time-select').trigger('change');
    });
</script>

</body>
</html>