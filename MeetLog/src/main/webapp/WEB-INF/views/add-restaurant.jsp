<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Properties, java.io.FileInputStream"%>
<%
String kakaoApiKey = "";
Properties properties = new Properties();
String path = application.getRealPath("/WEB-INF/api.properties");
try (FileInputStream fis = new FileInputStream(path)) {
	properties.load(fis);
	kakaoApiKey = properties.getProperty("kakao.api.key", "");
} catch (Exception e) {
	System.out.println("api.properties 파일을 읽는 중 오류 발생: " + e.getMessage());
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - 새 가게 등록</title>
<script src="https://cdn.tailwindcss.com"></script>
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
</style>
</head>
<body class="bg-gray-100">
	<div class="max-w-4xl mx-auto py-12 px-4">
		<div class="bg-white rounded-2xl shadow-xl p-8 md:p-12">
			<h1 class="text-3xl font-bold text-gray-900 mb-2">새 가게 등록</h1>
			<p class="text-gray-600 mb-8">MEET LOG에 등록하여 가게를 홍보하고 관리하세요.</p>

			<form id="restaurantForm"
				action="${pageContext.request.contextPath}/business/restaurants/add"
				method="post" enctype="multipart/form-data" class="space-y-6">

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
						type="hidden" id="latitude" name="latitude"><input
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

					<div>
						<label for="hours" class="block text-sm font-medium text-gray-700">영업
							시간 (고객 안내용)</label> <input type="text" id="hours" name="hours"
							class="form-input mt-1"
							placeholder="예: 매일 11:00 - 22:00 (브레이크타임 15:00-17:00)">
					</div>
					<div>
						<div class="flex justify-between items-center">
							<label class="block text-sm font-medium text-gray-700">예약
								시간 구성 (DB 저장용)</label>
							<button type="button" id="applyToAllBtn"
								class="text-sm bg-gray-200 px-3 py-1 rounded-md hover:bg-gray-300">월요일
								기준으로 전체 적용</button>
						</div>
						<div id="hours-container" class="space-y-4 mt-2">
							<%
							String[] days = {"월", "화", "수", "목", "금", "토", "일"};
							%>
							<%
							for (int i = 0; i < days.length; i++) {
								int dayIndex = i + 1;
							%>
							<div id="day_<%=dayIndex%>_wrapper"
								class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300"
								data-day-index="<%=dayIndex%>">
								<div class="flex items-center justify-between">
									<label class="font-semibold text-gray-800"><%=days[i]%>요일</label>
									<div>
										<input type="checkbox" id="is_closed_<%=dayIndex%>"
											name="is_closed_<%=dayIndex%>"
											class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
										<label for="is_closed_<%=dayIndex%>" class="ml-2 text-sm">휴무</label>
									</div>
								</div>
								<div class="slots-container mt-2 space-y-2">
									<div class="time-slot flex items-center gap-2">
										<select name="day_<%=dayIndex%>_open_1_ampm"
											class="time-select form-select w-24"><option
												value="am">오전</option>
											<option value="pm">오후</option></select> <select
											name="day_<%=dayIndex%>_open_1_time"
											class="time-select form-select">
											<%
											for (int h = 0; h < 12; h++) {
												for (int m = 0; m < 60; m += 30) {
													String time = String.format("%02d:%02d", (h == 0) ? 12 : h, m);
											%><option value="<%=time%>"><%=time%></option>
											<%
											}
											}
											%>
										</select> <input type="hidden" name="day_<%=dayIndex%>_open_1"
											class="hidden-time-input" value="09:00"> <span>~</span>
										<select name="day_<%=dayIndex%>_close_1_ampm"
											class="time-select form-select w-24"><option
												value="am">오전</option>
											<option value="pm" selected>오후</option></select> <select
											name="day_<%=dayIndex%>_close_1_time"
											class="time-select form-select">
											<%
											for (int h = 0; h < 12; h++) {
												for (int m = 0; m < 60; m += 30) {
													String time = String.format("%02d:%02d", (h == 0) ? 12 : h, m);
											%><option value="<%=time%>"
												<%=(h == 10 && m == 0) ? "selected" : ""%>><%=time%></option>
											<%
											}
											}
											%>
										</select> <input type="hidden" name="day_<%=dayIndex%>_close_1"
											class="hidden-time-input" value="22:00">
										<button type="button"
											class="add-slot-btn text-blue-600 text-sm font-semibold whitespace-nowrap">시간
											추가</button>
									</div>
								</div>
							</div>
							<%
							}
							%>
						</div>
					</div>
					<div>
						<label for="restaurantImage"
							class="block text-sm font-medium text-gray-700">대표 이미지 파일</label>
						<input type="file" id="restaurantImage" name="restaurantImage"
							accept="image/*"
							class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
						<img id="imagePreview" src="" alt="이미지 미리보기"
							class="mt-4 rounded-lg shadow-sm"
							style="display: none; max-width: 300px; max-height: 200px;">
					</div>
				</div>

				<div class="flex justify-end space-x-4 border-t pt-6">
					<a href="${pageContext.request.contextPath}/business/restaurants"
						class="bg-gray-200 text-gray-800 px-6 py-2 rounded-md hover:bg-gray-300">취소</a>
					<button type="submit" class="form-btn-primary px-6 py-2">가게
						등록</button>
				</div>
			</form>
		</div>
	</div>

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<script>
        $(document).ready(function() {
            const kakaoApiKey = "<%=kakaoApiKey%>";
             if (kakaoApiKey) {
                const scriptUrl = `//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services&autoload=false`;
                $.getScript(scriptUrl, function() {
                    kakao.maps.load(() => console.log("Kakao Maps API 로드 성공."));
                });
             } else {
                console.warn("Kakao API 키가 설정되지 않았습니다.");
             }

             /**
              * [최종 수정 1] hidden input 값을 업데이트하는 함수
              * 이름에 "open" 또는 "close"가 포함되어 있는지로 대상을 명확히 찾아 값을 설정합니다.
              */
             function updateHiddenTime($select) {
                 const $slot = $select.closest('.time-slot');
                 const selectName = $select.attr('name');

                 // 현재 변경된 select가 open용인지 close용인지 판단
                 const isForOpen = selectName.includes('_open_');

                 // 타입에 맞는 select와 hidden input을 명확하게 지정
                 const $ampmSelect = isForOpen ? $slot.find('select[name*="_open_"][name*="_ampm"]') : $slot.find('select[name*="_close_"][name*="_ampm"]');
                 const $timeSelect = isForOpen ? $slot.find('select[name*="_open_"][name*="_time"]') : $slot.find('select[name*="_close_"][name*="_time"]');
                 const $hiddenInput = isForOpen ? $slot.find('input.hidden-time-input[name*="_open_"]') : $slot.find('input.hidden-time-input[name*="_close_"]');

                 const ampm = $ampmSelect.val();
                 const time = $timeSelect.val();

                 if (!time) return;

                 let [hour, minute] = time.split(':').map(Number);
                 if (ampm === 'pm' && hour < 12) hour += 12;
                 if (ampm === 'am' && hour === 12) hour = 0;

                 const finalTime = String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0');

                 $hiddenInput.val(finalTime);
             }

            $('#searchAddressBtn').on('click', function() {
                new daum.Postcode({
                    oncomplete: function(data) {
                        $('#address').val(data.roadAddress);
                        $('#location').val(data.sigungu);
                        $('#jibun_address').val(data.jibunAddress);

                        if (window.kakao && kakao.maps.services) {
                            const geocoder = new kakao.maps.services.Geocoder();
                            geocoder.addressSearch(data.roadAddress, function(result, status) {
                                 if (status === kakao.maps.services.Status.OK) {
                                    $('#latitude').val(result[0].y);
                                    $('#longitude').val(result[0].x);
                                }
                            });
                        }
                     }
                }).open();
            });

            $('#hours-container').on('change', '.day-toggle-checkbox', function() {
                const $wrapper = $(this).closest('.day-wrapper');
                const isChecked = $(this).is(':checked');
                $wrapper.toggleClass('day-disabled', isChecked);
                $wrapper.find('select, button, input').not(this).prop('disabled', isChecked);
            });

            $('#hours-container').on('change', '.time-select', function() {
                updateHiddenTime($(this));
            });

            /**
             * [최종 수정 2] '시간 추가' 버튼 클릭 이벤트 핸들러
             * 복잡한 정규식 대신, name을 '_'로 분해하고 재조립하는 단순하고 확실한 방식으로 변경했습니다.
             */
            $('#hours-container').on('click', '.add-slot-btn', function() {
                const $slotsContainer = $(this).closest('.day-wrapper').find('.slots-container');
                const $firstSlot = $slotsContainer.find('.time-slot:first');
                const $newSlot = $firstSlot.clone();

                let maxIndex = 0;
                $slotsContainer.find('.time-slot').each(function() {
                    const name = $(this).find('select').first().attr('name');
                    const parts = name.split('_'); // 예: "day_1_open_1_time" -> ["day", "1", "open", "1", "time"]
                    const index = parseInt(parts[3], 10);
                    if (index > maxIndex) maxIndex = index;
                });
                const newIndex = maxIndex + 1;

                $newSlot.find('select, input').each(function() {
                    const oldName = $(this).attr('name');
                    if (oldName) {
                        const parts = oldName.split('_');
                        parts[3] = newIndex; // 슬롯 인덱스는 항상 4번째 요소
                        $(this).attr('name', parts.join('_'));
                    }
                });

                $newSlot.find('button').text('삭제').removeClass('add-slot-btn text-blue-600').addClass('remove-slot-btn text-red-600');
                $slotsContainer.append($newSlot);
                $newSlot.find('.time-select').trigger('change');
            });
            $('#hours-container').on('click', '.remove-slot-btn', function() {
                $(this).closest('.time-slot').remove();
            });

            // --- [복원된 코드] 월요일 기준으로 전체 적용 ---
            /**
 * [최종 수정 3] '월요일 기준으로 전체 적용' 버튼 클릭 이벤트 핸들러
 * '시간 추가'와 동일한 방식으로 이름 변경 로직을 수정하여 버그를 해결합니다.
 */
$('#applyToAllBtn').on('click', function() {
    const $mondayWrapper = $('#day_1_wrapper');
    const isClosed = $mondayWrapper.find('.day-toggle-checkbox').is(':checked');
    const mondaySlotsData = [];

    $mondayWrapper.find('.time-slot').each(function() {
        const $slot = $(this);
        mondaySlotsData.push({
            openAmpm: $slot.find('select[name*="_open_"][name*="_ampm"]').val(),
            openTime: $slot.find('select[name*="_open_"][name*="_time"]').val(),
            closeAmpm: $slot.find('select[name*="_close_"][name*="_ampm"]').val(),
            closeTime: $slot.find('select[name*="_close_"][name*="_time"]').val(),
        });
    });

    $('.day-wrapper').not('#day_1_wrapper').each(function() {
        const $currentWrapper = $(this);
        const dayIndex = $currentWrapper.data('day-index');
        const $slotsContainer = $currentWrapper.find('.slots-container');

        $currentWrapper.find('.day-toggle-checkbox').prop('checked', isClosed).trigger('change');

        if (!isClosed) {
            $slotsContainer.empty();
            const $templateSlot = $('#day_1_wrapper .time-slot:first').clone();

            if (mondaySlotsData.length > 0) {
                mondaySlotsData.forEach((data, index) => {
                    const $newSlot = $templateSlot.clone();
                    const newSlotIndex = index + 1;

                    $newSlot.find('select, input').each(function() {
                        const oldName = $(this).attr('name');
                        if (oldName) {
                            let parts = oldName.split('_');
                            parts[1] = dayIndex;       // 요일 인덱스 교체
                            parts[3] = newSlotIndex;   // 시간 슬롯 인덱스 교체
                            $(this).attr('name', parts.join('_'));
                        }
                    });

                    if (index > 0) {
                         $newSlot.find('button').text('삭제').removeClass('add-slot-btn text-blue-600').addClass('remove-slot-btn text-red-600');
                    } else {
                         $newSlot.find('button').text('시간 추가').removeClass('remove-slot-btn text-red-600').addClass('add-slot-btn text-blue-600');
                    }

                    $newSlot.find('select[name*="_open_"][name*="_ampm"]').val(data.openAmpm);
                    $newSlot.find('select[name*="_open_"][name*="_time"]').val(data.openTime);
                    $newSlot.find('select[name*="_close_"][name*="_ampm"]').val(data.closeAmpm);
                    $newSlot.find('select[name*="_close_"][name*="_time"]').val(data.closeTime);

                    $slotsContainer.append($newSlot);
                });
            }
        }
    });
    $('.time-select').trigger('change');
    alert('월요일 영업시간을 전체 요일에 적용했습니다.');
});

            $('#restaurantImage').on('change', function(event) {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        $('#imagePreview').attr('src', e.target.result).show();
                    };
                    reader.readAsDataURL(this.files[0]);
                }
            });
            
            $('#restaurantForm').on('submit', function(e) {
                // 전화번호 필드가 하나로 통합되어 값을 합치는 로직을 제거했습니다.
                
                $('.day-wrapper').each(function() {
                    if (!$(this).hasClass('day-disabled')) {
                        $(this).find('.time-slot').each(function() {
                            $(this).find('.time-select').trigger('change');
                        });
                    }
                 });
            });

            $('.time-select').trigger('change');
        });
    </script>
</body>
</html>