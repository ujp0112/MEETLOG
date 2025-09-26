<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - ${isEditMode ? '가게 정보 수정' : '새 가게 등록'}</title>
<script src="https://cdn.tailwindcss.com"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services&autoload=false"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
/* (이전과 동일한 CSS 스타일) */
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
}

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
	display: none;
	padding: 1.5rem;
	border: 1px solid #e2e8f0;
	border-top: none;
	border-radius: 0 0 0.5rem 0.5rem;
}

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
			<h1 class="text-3xl font-bold text-gray-900 mb-2">${isEditMode ? '가게 정보 수정' : '새 가게 등록'}</h1>
			<p class="text-gray-600 mb-8">${isEditMode ? fn:escapeXml(restaurant.name) += '의 정보를 수정합니다.' : 'MEET LOG에 등록하여 가게를 홍보하고 관리하세요.'}</p>

			<form id="restaurantForm" class="space-y-6">
				<c:if test="${isEditMode}">
					<input type="hidden" name="restaurantId" value="${restaurant.id}">
				</c:if>

				<%-- 기본 정보 --%>
				<div class="grid grid-cols-1 md:grid-cols-2 gap-6 border-t pt-6">
					<div>
						<label for="name" class="block text-sm font-medium text-gray-700">가게
							이름</label> <input type="text" id="name" name="name" required
							class="form-input mt-1" value="${restaurant.name}">
					</div>
					<div>
						<label for="category"
							class="block text-sm font-medium text-gray-700">카테고리</label> <select
							id="category" name="category" required class="form-select mt-1">
							<option value="">선택하세요</option>
							<optgroup label="한식">
								<option value="고기/구이"
									${restaurant.category == '고기/구이' ? 'selected' : ''}>고기/구이</option>
								<option value="찌개/전골"
									${restaurant.category == '찌개/전골' ? 'selected' : ''}>찌개/전골</option>
								<option value="백반/국밥"
									${restaurant.category == '백반/국밥' ? 'selected' : ''}>백반/국밥</option>
								<option value="족발/보쌈"
									${restaurant.category == '족발/보쌈' ? 'selected' : ''}>족발/보쌈</option>
								<option value="분식"
									${restaurant.category == '분식' ? 'selected' : ''}>분식</option>
								<option value="한식 기타"
									${restaurant.category == '한식 기타' ? 'selected' : ''}>한식
									기타</option>
							</optgroup>
							<optgroup label="일식">
								<option value="스시/오마카세"
									${restaurant.category == '스시/오마카세' ? 'selected' : ''}>스시/오마카세</option>
								<option value="라멘/돈부리"
									${restaurant.category == '라멘/돈부리' ? 'selected' : ''}>라멘/돈부리</option>
								<option value="돈까스/튀김"
									${restaurant.category == '돈까스/튀김' ? 'selected' : ''}>돈까스/튀김</option>
								<option value="이자카야"
									${restaurant.category == '이자카야' ? 'selected' : ''}>이자카야</option>
								<option value="일식 기타"
									${restaurant.category == '일식 기타' ? 'selected' : ''}>일식
									기타</option>
							</optgroup>
							<optgroup label="중식">
								<option value="중식"
									${restaurant.category == '중식' ? 'selected' : ''}>중식</option>
							</optgroup>
							<optgroup label="양식">
								<option value="이탈리안"
									${restaurant.category == '이탈리안' ? 'selected' : ''}>이탈리안</option>
								<option value="프렌치"
									${restaurant.category == '프렌치' ? 'selected' : ''}>프렌치</option>
								<option value="스테이크/바베큐"
									${restaurant.category == '스테이크/바베큐' ? 'selected' : ''}>스테이크/바베큐</option>
								<option value="햄버거/피자"
									${restaurant.category == '햄버거/피자' ? 'selected' : ''}>햄버거/피자</option>
								<option value="양식 기타"
									${restaurant.category == '양식 기타' ? 'selected' : ''}>양식
									기타</option>
							</optgroup>
							<optgroup label="아시안">
								<option value="태국/베트남"
									${restaurant.category == '태국/베트남' ? 'selected' : ''}>태국/베트남</option>
								<option value="인도/중동"
									${restaurant.category == '인도/중동' ? 'selected' : ''}>인도/중동</option>
								<option value="아시안 기타"
									${restaurant.category == '아시안 기타' ? 'selected' : ''}>아시안
									기타</option>
							</optgroup>
							<optgroup label="카페 & 주점">
								<option value="카페"
									${restaurant.category == '카페' ? 'selected' : ''}>카페</option>
								<option value="베이커리/디저트"
									${restaurant.category == '베이커리/디저트' ? 'selected' : ''}>베이커리/디저트</option>
								<option value="주점"
									${restaurant.category == '주점' ? 'selected' : ''}>주점</option>
							</optgroup>
							<optgroup label="기타">
								<option value="퓨전/세계음식"
									${restaurant.category == '퓨전/세계음식' ? 'selected' : ''}>퓨전/세계음식</option>
								<option value="기타"
									${restaurant.category == '기타' ? 'selected' : ''}>기타</option>
							</optgroup>
						</select>
					</div>
				</div>

				<%-- [수정] 주소 정보 (상세주소 복원) --%>
				<div class="border-t pt-6 space-y-2">
					<label class="block text-sm font-medium text-gray-700">주소
						정보</label>
					<div class="flex items-center gap-2">
						<input type="text" id="address" name="address" required
							class="form-input" placeholder="오른쪽 '주소 검색' 버튼을 클릭하세요" readonly
							value="${restaurant.address}">
						<button type="button" id="searchAddressBtn"
							class="form-btn-primary whitespace-nowrap px-4 py-2 text-sm">주소
							검색</button>
					</div>
					<div>
						<label for="location"
							class="block text-sm font-medium text-gray-700 mt-2">지역
							(자동 입력)</label> <input type="text" id="location" name="location" required
							class="form-input mt-1 bg-gray-100" readonly
							value="${restaurant.location}">
					</div>
					<input type="text" id="detail_address" name="detail_address"
						class="form-input" placeholder="상세 주소를 입력하세요">
					<%-- 상세주소 복원 --%>
					<input type="hidden" id="jibun_address" name="jibun_address"
						value="${restaurant.jibunAddress}"> <input type="hidden"
						id="latitude" name="latitude" value="${restaurant.latitude}">
					<input type="hidden" id="longitude" name="longitude"
						value="${restaurant.longitude}">
				</div>

				<%-- [수정] 상세 정보 및 운영시간 구조 정리 --%>
				<div class="border-t pt-6 space-y-6">
					<div>
						<label for="phone" class="block text-sm font-medium text-gray-700">전화번호</label>
						<input type="text" id="phone" name="phone" class="form-input mt-1"
							placeholder="예: 02-1234-5678" value="${restaurant.phone}">
					</div>
					<div>
						<label for="description"
							class="block text-sm font-medium text-gray-700">가게 설명</label>
						<textarea id="description" name="description" rows="4"
							class="form-input mt-1"
							placeholder="가게에 대한 상세한 설명을 입력해주세요. (예: 주차 정보, 가게 특징 등)">${restaurant.description}</textarea>
					</div>
					<%-- <div>
						<input type="checkbox" id="parking" name="parking" value="true" class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500" ${restaurant.parking ? 'checked' : ''}>
                        <label for="parking" class="ml-2 text-sm font-medium text-gray-700">주차 가능</label>
					</div> --%>
					<div>
						<label for="break_time_text"
							class="block text-sm font-medium text-gray-700">브레이크 타임
							(고객 안내용)</label> <input type="text" id="break_time_text"
							name="break_time_text" class="form-input mt-1"
							placeholder="예: 15:00 ~ 17:00"
							value="${restaurant.breakTimeText}">
					</div>
				</div>

				<%-- 운영 시간 / 예약 시간 설정 --%>
				<div class="space-y-4 border-t pt-6">
					<%-- 대표 운영시간 --%>
					<div>
						<div class="accordion-header flex justify-between items-center">
							<h3 class="text-lg font-semibold text-gray-800">🕒 가게 대표
								운영시간 설정</h3>
							<span class="transform transition-transform duration-300">▼</span>
						</div>
						<div class="accordion-content space-y-4">
							<div id="main-hours-container" class="space-y-4">
								<%-- JS로 동적 생성 --%>
							</div>
						</div>
					</div>
					<%-- 온라인 예약 시간 --%>
					<div>
						<div class="accordion-header flex justify-between items-center">
							<h3 class="text-lg font-semibold text-gray-800">📅 온라인 예약 시간
								설정</h3>
							<span class="transform transition-transform duration-300">▼</span>
						</div>
						<div class="accordion-content">
							<div class="flex justify-between items-center mb-2">
								<p class="text-sm text-gray-600">온라인 예약을 받을 시간대를 설정합니다.</p>
								<button type="button" id="applyToAllBtn"
									class="text-sm bg-gray-200 px-3 py-1 rounded-md hover:bg-gray-300">월요일
									기준으로 전체 적용</button>
							</div>
							<div id="hours-container" class="space-y-4 mt-2">
								<%-- JS로 동적 생성 --%>
							</div>
						</div>
					</div>
				</div>

				<%-- 이미지 업로드 --%>
				<div>
					<label class="block text-sm font-medium text-gray-700">대표
						이미지 파일 (여러 개 선택 가능)</label> <input type="file" id="restaurantImage"
						name="restaurantImage" accept="image/*" multiple class="hidden">
					<div id="imagePreviewContainer"
						class="mt-4 flex flex-wrap gap-4 items-center">
						<label for="restaurantImage" class="image-add-btn"> <span
							class="plus-icon">+</span> <span class="add-text">이미지 추가</span>
						</label>
					</div>
				</div>

				<div class="flex justify-end space-x-4 border-t pt-6">
					<a href="${pageContext.request.contextPath}/business/restaurants"
						class="bg-gray-200 text-gray-800 px-6 py-2 rounded-md hover:bg-gray-300">취소</a>
					<button type="button" id="submitBtn"
						class="form-btn-primary px-6 py-2">${isEditMode ? '가게 수정' : '가게 등록'}</button>
				</div>
			</form>
		</div>
	</div>

	<%-- body 태그 맨 아래, 기존 <script>...</script>를 모두 지우고 아래 코드로 교체 --%>
	<script>
	//--- 전역 변수 ---
	var uploadedFiles = [];
	var filesToDelete = [];
	var isEditMode = ${isEditMode eq true};
	var restaurantData = isEditMode ? JSON.parse('${restaurantJson}') : null;
	var existingOperatingHours = isEditMode ? JSON.parse('${operatingHoursJson}') : [];
	
	// --- 페이지 로드 완료 후 실행 ---
	$(document).ready(function() {
	    if (isEditMode) {
	        console.log("수정 모드 데이터:", restaurantData);
	        console.log("수정모드 오퍼레이팅 아워", existingOperatingHours);
	        initializeEditForm();
	    } else {
	        buildTimeSlots('main-hours-container', 1, false);
	        buildTimeSlots('hours-container', 1, true);
	    }
	    kakao.maps.load(() => console.log("Kakao Maps API가 준비되었습니다."));

        // --- 이벤트 핸들러 바인딩 ---

        // 주소 검색
        $('#searchAddressBtn').on('click', function() {
            new daum.Postcode({
                oncomplete: function(data) {
                    $('#address').val(data.roadAddress);
                    $('#location').val(data.sigungu);
                    $('#jibun_address').val(data.jibunAddress);
                    $('#detail_address').prop('disabled', false).val('').focus();
                    var geocoder = new kakao.maps.services.Geocoder();
                    geocoder.addressSearch(data.roadAddress, function(result, status) {
                        if (status === kakao.maps.services.Status.OK) {
                            $('#latitude').val(result[0].y);
                            $('#longitude').val(result[0].x);
                        }
                    });
                }
            }).open();
        });

        // 이미지 추가
        $('#restaurantImage').on('change', function(event) {
            var newFiles = Array.from(event.target.files);
            newFiles.forEach(function(file) {
                file.uniqueId = 'file_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
                uploadedFiles.push(file);
                var reader = new FileReader();
                reader.onload = function(e) {
                    var previewHtml =
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

        // 이미지 삭제
        $('#imagePreviewContainer').on('click', '.delete-preview-btn', function() {
            var wrapper = $(this).closest('.image-preview-wrapper');
            var fileId = wrapper.data('file-id');
            var isExisting = wrapper.data('existing-file') === true;
            if (isExisting) {
                filesToDelete.push(fileId);
            } else {
                uploadedFiles = uploadedFiles.filter(function(file) { return file.uniqueId !== fileId; });
            }
            wrapper.remove();
        });

        // 폼 제출
        $('#submitBtn').on('click', function() {
            $('.time-select').trigger('change');
            var form = document.getElementById('restaurantForm');
            var formData = new FormData(form);
            uploadedFiles.forEach(function(file) {
                formData.append('restaurantImage', file);
            });
            if (filesToDelete.length > 0) {
                formData.append('filesToDelete', filesToDelete.join(','));
            }
            
         // --- ▼▼▼ [추가] 남아있는 기존 이미지 목록 전송 ▼▼▼ ---
            if (isEditMode) {
                var remainingImages = [];
                $('.image-preview-wrapper[data-existing-file="true"]').each(function() {
                    remainingImages.push($(this).data('file-id'));
                });
                formData.append('existingImages', remainingImages.join(','));
            }
            // --- ▲▲▲ [추가] 끝 ▲▲▲ ---
            
            var url = isEditMode ?
                '${pageContext.request.contextPath}/business/restaurants/update' :
                '${pageContext.request.contextPath}/business/restaurants/add';
            fetch(url, {
                method: 'POST',
                body: formData
            })
            .then(function(response) {
                if (response.ok) {
                    window.location.href = '${pageContext.request.contextPath}/business/restaurants';
                } else {
                    return response.text().then(function(text) { throw new Error(text || '서버 오류') });
                }
            })
            .catch(function(error) {
                alert('처리 중 오류가 발생했습니다: ' + error.message);
            });
        });

        // 휴무 체크박스
        $('body').on('change', '.day-toggle-checkbox', function() {
            var $wrapper = $(this).closest('.day-wrapper');
            var isChecked = $(this).is(':checked');
            $wrapper.toggleClass('day-disabled', isChecked);
            $wrapper.find('select, button, input').not(this).prop('disabled', isChecked);
        });

        // 시간 Select 변경
        $('body').on('change', '.time-select', function() {
            updateHiddenTime($(this));
        });

        // 온라인 예약: 시간 추가
        $('#hours-container').on('click', '.add-slot-btn', function() {
    var $wrapper = $(this).closest('.day-wrapper');
    var dayIndex = $wrapper.data('day-index');
    var slotCount = $wrapper.find('.time-slot').length;
    var newSlotIndex = slotCount + 1;
    var firstSlotHtml = $wrapper.find('.time-slot').first().html();
    var newSlotHtml = '<div class="time-slot flex items-center gap-2">' + firstSlotHtml + '</div>';
    
    // [수정] 정규표현식을 더 정교하게 변경하여 요일(day_1)이 아닌 슬롯 인덱스(_1)만 치환하도록 함
    var finalHtml = newSlotHtml.replace(/_open_1/g, '_open_' + newSlotIndex)
    .replace(/_close_1/g, '_close_' + newSlotIndex)
    .replace('시간 추가', '삭제')
    .replace('add-slot-btn', 'remove-slot-btn text-red-500');

$wrapper.find('.slots-container').append(finalHtml);
});

        // 온라인 예약: 시간 삭제
        $('#hours-container').on('click', '.remove-slot-btn', function() {
            $(this).closest('.time-slot').remove();
        });

     // 온라인 예약: 전체 적용
        $('#applyToAllBtn').on('click', function() {
            if (!confirm('월요일의 설정을 다른 모든 요일에 덮어씌우시겠습니까?')) return;

            var $mondayWrapper = $('#day_1_wrapper');
            var mondayIsClosed = $mondayWrapper.find('.day-toggle-checkbox').is(':checked');

            // 1. 월요일의 시간 슬롯에 설정된 값들을 배열에 저장
            var mondaySlotsData = [];
            if (!mondayIsClosed) {
                $mondayWrapper.find('.time-slot').each(function() {
                    var slotData = {
                        open_ampm: $(this).find('select[name*="_open_"][name*="_ampm"]').val(),
                        open_time: $(this).find('select[name*="_open_"][name*="_time"]').val(),
                        close_ampm: $(this).find('select[name*="_close_"][name*="_ampm"]').val(),
                        close_time: $(this).find('select[name*="_close_"][name*="_time"]').val()
                    };
                    mondaySlotsData.push(slotData);
                });
            }

            // 2. 화요일부터 일요일까지 순회하며 월요일의 설정 적용
            for (var i = 2; i <= 7; i++) {
                var $otherDayWrapper = $('#day_' + i + '_wrapper');
                
                // 휴무 상태 적용
                $otherDayWrapper.find('.day-toggle-checkbox').prop('checked', mondayIsClosed).trigger('change');
                
                if (!mondayIsClosed) {
                    var $slotsContainer = $otherDayWrapper.find('.slots-container');
                    
                    // 먼저, 슬롯 개수를 월요일과 동일하게 맞춤
                    while ($slotsContainer.find('.time-slot').length < mondaySlotsData.length) {
                        // 슬롯이 부족하면 '시간 추가' 버튼을 눌러 추가
                        $otherDayWrapper.find('.add-slot-btn').last().trigger('click');
                    }
                    while ($slotsContainer.find('.time-slot').length > mondaySlotsData.length) {
                        // 슬롯이 너무 많으면 마지막 슬롯부터 삭제
                        $slotsContainer.find('.time-slot').last().remove();
                    }

                    // 각 슬롯의 시간 값을 월요일과 동일하게 설정
                    $slotsContainer.find('.time-slot').each(function(index) {
                        var slotData = mondaySlotsData[index];
                        $(this).find('select[name*="_open_"][name*="_ampm"]').val(slotData.open_ampm);
                        $(this).find('select[name*="_open_"][name*="_time"]').val(slotData.open_time);
                        $(this).find('select[name*="_close_"][name*="_ampm"]').val(slotData.close_ampm);
                        $(this).find('select[name*="_close_"][name*="_time"]').val(slotData.close_time);
                    });
                }
            }

            alert('월요일 설정을 모든 요일에 적용했습니다.');
            // 마지막으로 모든 hidden input 값을 업데이트
            $('.time-select').trigger('change');
        });

        // 아코디언
        $('.accordion-header').on('click', function() {
            $(this).find('span').toggleClass('rotate-180');
            $(this).next('.accordion-content').slideToggle(300);
        });
    });

	// --- 헬퍼 함수 정의 ---

    // [수정] buildDay 함수를 buildTimeSlots 밖으로 이동
    function buildDay(dayIndex, containerId, slotCount, showAddButton) {
        var dayNames = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
        var dayName = dayNames[dayIndex - 1];
        var slotsHtml = '';
        for (var i = 1; i <= slotCount; i++) {
            var isFirstSlot = i === 1;
            var buttonHtml = showAddButton ? '<button type="button" class="' + (isFirstSlot ? 'add-slot-btn' : 'remove-slot-btn text-red-500') + ' text-blue-600 text-sm font-semibold whitespace-nowrap">' + (isFirstSlot ? '시간 추가' : '삭제') + '</button>' : '';
            var prefix = containerId === 'main-hours-container' ? 'main_' : '';
            slotsHtml +=
                '<div class="time-slot flex items-center gap-2">' +
                    '<select name="' + prefix + 'day_' + dayIndex + '_open_' + i + '_ampm" class="time-select form-select w-24"><option value="am">오전</option><option value="pm">오후</option></select>' +
                    '<select name="' + prefix + 'day_' + dayIndex + '_open_' + i + '_time" class="time-select form-select">' + generateTimeOptions() + '</select>' +
                    '<input type="hidden" name="' + prefix + 'day_' + dayIndex + '_open_' + i + '" class="hidden-time-input">' +
                    '<span>~</span>' +
                    '<select name="' + prefix + 'day_' + dayIndex + '_close_' + i + '_ampm" class="time-select form-select w-24"><option value="am">오전</option><option value="pm" selected>오후</option></select>' +
                    '<select name="' + prefix + 'day_' + dayIndex + '_close_' + i + '_time" class="time-select form-select">' + generateTimeOptions(true) + '</select>' +
                    '<input type="hidden" name="' + prefix + 'day_' + dayIndex + '_close_' + i + '" class="hidden-time-input">' +
                    buttonHtml +
                '</div>';
        }
        var prefix = containerId === 'main-hours-container' ? 'main_' : '';
        return (
            '<div id="' + prefix + 'day_' + dayIndex + '_wrapper" class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300" data-day-index="' + dayIndex + '">' +
                '<div class="flex items-center justify-between">' +
                    '<label class="font-semibold text-gray-800">' + dayName + '</label>' +
                    '<div>' +
                        '<input type="checkbox" id="' + prefix + 'is_closed_' + dayIndex + '" name="' + prefix + 'is_closed_' + dayIndex + '" class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">' +
                        '<label for="' + prefix + 'is_closed_' + dayIndex + '" class="ml-2 text-sm">휴무</label>' +
                    '</div>' +
                '</div>' +
                '<div class="slots-container mt-2 space-y-2">' + slotsHtml + '</div>' +
            '</div>'
        );
    }

 // buildTimeSlots 함수 전체를 이 코드로 교체해주세요.
    function buildTimeSlots(containerId, slotCount, showAddButton, dayToBuild) {
        var container = $('#' + containerId);
        
        // [수정] buildDay 함수를 호출할 때 모든 파라미터를 정확하게 전달합니다.
        if (dayToBuild) {
            var prefix = containerId === 'main-hours-container' ? 'main_' : '';
            $('#' + prefix + 'day_' + dayToBuild + '_wrapper', container.parent()).replaceWith(buildDay(dayToBuild, containerId, slotCount, showAddButton));
        } else {
            var finalHtml = '';
            for (var i = 1; i <= 7; i++) {
                finalHtml += buildDay(i, containerId, slotCount, showAddButton);
            }
            container.html(finalHtml);
        }
    }
    function initializeEditForm() {
        // 이미지 미리보기 초기화
        var existingImages = [];
        if (restaurantData.image) existingImages.push(restaurantData.image);
        if (restaurantData.additionalImages) existingImages.push.apply(existingImages, restaurantData.additionalImages);
        existingImages.forEach(function(fileName) {
            if (!fileName) return;
            var previewHtml =
                '<div class="image-preview-wrapper" data-file-id="' + fileName + '" data-existing-file="true">' +
                '    <img src="${pageContext.request.contextPath}/images/' + fileName + '" class="rounded-lg shadow-sm" style="width: 120px; height: 120px; object-fit: cover;">' +
                '    <button type="button" class="delete-preview-btn">×</button>' +
                '</div>';
            $('.image-add-btn').before(previewHtml);
        });
        
        // 상세주소 및 주차여부 값 채우기
        $('#address').val(restaurantData.address);
        $('#detail_address').val("").prop('disabled', true); // 상세주소는 비활성화
        if(restaurantData.parking) {
            $('#parking').prop('checked', true);
        }

        // 대표 운영시간 초기화
        buildTimeSlots('main-hours-container', 1, false);
        var operatingDays = (restaurantData.operatingDays || "").split(',');
        var operatingTimes = (restaurantData.operatingTimesText || "").split(',');
        var allDays = ["월", "화", "수", "목", "금", "토", "일"];
        allDays.forEach(function(dayName, index) {
            var dayIndex = index + 1;
            var opTimeIndex = operatingDays.indexOf(dayName);
            var timeString = operatingTimes[opTimeIndex];
            if (opTimeIndex > -1 && timeString && timeString.includes('~')) {
                var parts = timeString.split('~');
                setSelectTime('main_day_' + dayIndex + '_open_1', parts[0]);
                setSelectTime('main_day_' + dayIndex + '_close_1', parts[1]);
            } else {
                $('#main_is_closed_' + dayIndex).prop('checked', true).trigger('change');
            }
        });

        // 온라인 예약 시간 초기화
        var hoursByDay = {};
        existingOperatingHours.forEach(function(oh) {
            if (!hoursByDay[oh.dayOfWeek]) hoursByDay[oh.dayOfWeek] = [];
            hoursByDay[oh.dayOfWeek].push(oh);
        });
        
     // [수정] 온라인 예약 시간 UI를 그리는 로직 수정
        var hoursContainer = $('#hours-container');
        hoursContainer.empty(); // 컨테이너를 먼저 비움
        for (var dayIndex = 1; dayIndex <= 7; dayIndex++) {
            var hours = hoursByDay[dayIndex];
            var slotCount = (hours && hours.length > 0) ? hours.length : 1;
            
         // 이제 buildDay 함수를 직접 호출할 수 있음
            hoursContainer.append(buildDay(dayIndex, 'hours-container', slotCount, true));
            
            if (hours && hours.length > 0) {
                hours.forEach(function(slot, slotIndex) {
                    var currentSlotIndex = slotIndex + 1;
                    setSelectTime('day_' + dayIndex + '_open_' + currentSlotIndex, slot.openingTime);
                    setSelectTime('day_' + dayIndex + '_close_' + currentSlotIndex, slot.closingTime);
                });
            } else {
                $('#is_closed_' + dayIndex).prop('checked', true).trigger('change');
            }
        }
        
        $('.time-select').trigger('change');
    }


    function setSelectTime(namePrefix, time24) {
        if (!time24 || time24.length < 5) return;
        var timeParts = time24.split(':');
        var hour = parseInt(timeParts[0], 10);
        var minute = parseInt(timeParts[1], 10);
        var ampm = hour >= 12 ? 'pm' : 'am';
        if (hour > 12) hour -= 12;
        if (hour === 0) hour = 12;
        var time12 = String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0');
        $('select[name="' + namePrefix + '_ampm"]').val(ampm);
        $('select[name="' + namePrefix + '_time"]').val(time12);
    }

    function updateHiddenTime($select) {
        var $slot = $select.closest('.time-slot');
        if ($slot.length === 0) return;
        var selectName = $select.attr('name');
        var isForOpen = selectName.indexOf('_open_') > -1;
        var $ampmSelect = isForOpen ? $slot.find('select[name*="_open_"][name*="_ampm"]') : $slot.find('select[name*="_close_"][name*="_ampm"]');
        var $timeSelect = isForOpen ? $slot.find('select[name*="_open_"][name*="_time"]') : $slot.find('select[name*="_close_"][name*="_time"]');
        var $hiddenInput = isForOpen ? $slot.find('input.hidden-time-input[name*="_open_"]') : $slot.find('input.hidden-time-input[name*="_close_"]');
        var ampm = $ampmSelect.val();
        var time = $timeSelect.val();
        if (!time) return;
        var timeParts = time.split(':');
        var hour = parseInt(timeParts[0], 10);
        var minute = parseInt(timeParts[1], 10);
        if (ampm === 'pm' && hour < 12) hour += 12;
        if (ampm === 'am' && hour === 12) hour = 0;
        $hiddenInput.val(String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0'));
    };

    function buildTimeSlots(containerId, slotCount, showAddButton, dayToBuild) {
        var buildDay = function(dayIndex) {
            var dayNames = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
            var dayName = dayNames[dayIndex - 1];
            var slotsHtml = '';
            for (var i = 1; i <= slotCount; i++) {
                var isFirstSlot = i === 1;
                var buttonHtml = showAddButton ? '<button type="button" class="' + (isFirstSlot ? 'add-slot-btn' : 'remove-slot-btn text-red-500') + ' text-blue-600 text-sm font-semibold whitespace-nowrap">' + (isFirstSlot ? '시간 추가' : '삭제') + '</button>' : '';
                var prefix = containerId === 'main-hours-container' ? 'main_' : '';
                slotsHtml +=
                    '<div class="time-slot flex items-center gap-2">' +
                        '<select name="' + prefix + 'day_' + dayIndex + '_open_' + i + '_ampm" class="time-select form-select w-24"><option value="am">오전</option><option value="pm">오후</option></select>' +
                        '<select name="' + prefix + 'day_' + dayIndex + '_open_' + i + '_time" class="time-select form-select">' + generateTimeOptions() + '</select>' +
                        '<input type="hidden" name="' + prefix + 'day_' + dayIndex + '_open_' + i + '" class="hidden-time-input">' +
                        '<span>~</span>' +
                        '<select name="' + prefix + 'day_' + dayIndex + '_close_' + i + '_ampm" class="time-select form-select w-24"><option value="am">오전</option><option value="pm" selected>오후</option></select>' +
                        '<select name="' + prefix + 'day_' + dayIndex + '_close_' + i + '_time" class="time-select form-select">' + generateTimeOptions(true) + '</select>' +
                        '<input type="hidden" name="' + prefix + 'day_' + dayIndex + '_close_' + i + '" class="hidden-time-input">' +
                        buttonHtml +
                    '</div>';
            }
            var prefix = containerId === 'main-hours-container' ? 'main_' : '';
            return (
                '<div id="' + prefix + 'day_' + dayIndex + '_wrapper" class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300" data-day-index="' + dayIndex + '">' +
                    '<div class="flex items-center justify-between">' +
                        '<label class="font-semibold text-gray-800">' + dayName + '</label>' +
                        '<div>' +
                            '<input type="checkbox" id="' + prefix + 'is_closed_' + dayIndex + '" name="' + prefix + 'is_closed_' + dayIndex + '" class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">' +
                            '<label for="' + prefix + 'is_closed_' + dayIndex + '" class="ml-2 text-sm">휴무</label>' +
                        '</div>' +
                    '</div>' +
                    '<div class="slots-container mt-2 space-y-2">' + slotsHtml + '</div>' +
                '</div>'
            );
        };
        var container = $('#' + containerId);
        if (dayToBuild) {
            var prefix = containerId === 'main-hours-container' ? 'main_' : '';
            $('#' + prefix + 'day_' + dayToBuild + '_wrapper', container.parent()).replaceWith(buildDay(dayToBuild));
        } else {
            var finalHtml = '';
            for (var i = 1; i <= 7; i++) {
                finalHtml += buildDay(i);
            }
            container.html(finalHtml);
        }
    }

    function generateTimeOptions(isCloseTime) {
        var options = '';
        for (var h = 0; h < 12; h++) {
            for (var m = 0; m < 60; m += 30) {
                var hour = h === 0 ? 12 : h;
                var timeValue = String(hour).padStart(2, '0') + ':' + String(m).padStart(2, '0');
                var selected = isCloseTime && h === 10 && m === 0 ? 'selected' : '';
                options += '<option value="' + timeValue + '" ' + selected + '>' + timeValue + '</option>';
            }
        }
        return options;
    }
</script>
</body>
</html>