<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 새 가게 등록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .form-input, .form-select { display: block; width: 100%; border-radius: 0.5rem; border: 1px solid #cbd5e1; padding: 0.75rem 1rem; -webkit-appearance: none; -moz-appearance: none; appearance: none; background-image: none; }
        .form-input:focus, .form-select:focus { outline: 2px solid transparent; outline-offset: 2px; border-color: #38bdf8; box-shadow: 0 0 0 2px #7dd3fc; }
        .form-btn-primary { display: inline-flex; justify-content: center; border-radius: 0.5rem; background-color: #0284c7; padding: 0.75rem 1rem; font-weight: 600; color: white; transition: background-color 0.2s; }
        .form-btn-primary:hover { background-color: #0369a1; }
        .day-disabled { background-color: #f3f4f6 !important; opacity: 0.7; }
        .day-disabled select, .day-disabled button, .day-disabled input { cursor: not-allowed !important; }
    </style>
</head>
<body class="bg-gray-100">
    <!-- 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="max-w-4xl mx-auto py-12 px-4">
        <div class="bg-white rounded-2xl shadow-xl p-8 md:p-12">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">새 가게 등록</h1>
            <p class="text-gray-600 mb-8">MEET LOG에 등록하여 가게를 홍보하고 관리하세요.</p>

            <form id="restaurantForm" class="space-y-6">
                <!-- 기본 정보 -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 border-t pt-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700">가게 이름</label>
                        <input type="text" id="name" name="name" required="" class="form-input mt-1">
                    </div>
                    <div>
                        <label for="category" class="block text-sm font-medium text-gray-700">카테고리</label>
                        <select id="category" name="category" required="" class="form-select mt-1">
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

                <!-- 주소 정보 -->
                <div class="border-t pt-6 space-y-2">
                    <label class="block text-sm font-medium text-gray-700">주소 정보</label>
                    <div class="flex items-center gap-2">
                         <input type="text" id="address" name="address" required="" class="form-input" placeholder="오른쪽 '주소 검색' 버튼을 클릭하세요" readonly="">
                         <button type="button" id="searchAddressBtn" class="form-btn-primary whitespace-nowrap px-4 py-2 text-sm">주소 검색</button>
                    </div>
                    <div>
                        <label for="location" class="block text-sm font-medium text-gray-700 mt-2">지역 (자동 입력)</label>
                        <input type="text" id="location" name="location" required="" class="form-input mt-1 bg-gray-100" readonly="">
                    </div>
                    <input type="text" id="detail_address" name="detail_address" class="form-input" placeholder="상세 주소를 입력하세요">
                    <input type="hidden" id="latitude" name="latitude">
                    <input type="hidden" id="longitude" name="longitude">
                </div>

                <!-- 전화번호 -->
                <div class="border-t pt-6 space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">전화번호</label>
                        <div class="flex gap-2 mt-1">
                            <input type="text" id="phone1" maxlength="4" class="form-input text-center" oninput="this.value = this.value.replace(/[^0-9]/g, '');"><span>-</span>
                            <input type="text" id="phone2" maxlength="4" class="form-input text-center" oninput="this.value = this.value.replace(/[^0-9]/g, '');"><span>-</span>
                            <input type="text" id="phone3" maxlength="4" class="form-input text-center" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                        </div>
                        <input type="hidden" id="phone" name="phone">
                    </div>
                    <div>
                        <label for="hours" class="block text-sm font-medium text-gray-700">영업 시간 (고객 안내용)</label>
                        <input type="text" id="hours" name="hours" class="form-input mt-1" placeholder="예: 매일 11:00 - 22:00 (브레이크타임 15:00-17:00)">
                    </div>
                    <div>
                        <div class="flex justify-between items-center">
                            <label class="block text-sm font-medium text-gray-700">예약 시간 구성</label>
                            <button type="button" id="applyToAllBtn" class="text-sm bg-gray-200 px-3 py-1 rounded-md hover:bg-gray-300">월요일 기준으로 전체 적용</button>
                        </div>
                        <div id="hours-container" class="space-y-4 mt-2">
                            <!-- 월요일부터 일요일까지 -->
                            <c:forEach var="day" begin="1" end="7" varStatus="status">
                                <c:set var="dayNames" value="월요일,화요일,수요일,목요일,금요일,토요일,일요일" />
                                <c:set var="dayName" value="${dayNames.split(',')[status.index]}" />
                                
                                <div id="day_${day}_wrapper" class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300" data-day-index="${day}">
                                    <div class="flex items-center justify-between">
                                        <label class="font-semibold text-gray-800">${dayName}</label>
                                        <div>
                                            <input type="checkbox" id="is_closed_${day}" name="is_closed_${day}" class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                                            <label for="is_closed_${day}" class="ml-2 text-sm">휴무</label>
                                        </div>
                                    </div>
                                    <div class="slots-container mt-2 space-y-2">
                                        <div class="time-slot flex items-center gap-2">
                                            <select name="day_${day}_open_1_ampm" class="time-select form-select w-24">
                                                <option value="am">오전</option>
                                                <option value="pm">오후</option>
                                            </select>
                                            <select name="day_${day}_open_1_time" class="time-select form-select">
                                                <option value="12:00">12:00</option>
                                                <option value="12:30">12:30</option>
                                                <option value="01:00">01:00</option>
                                                <option value="01:30">01:30</option>
                                                <option value="02:00">02:00</option>
                                                <option value="02:30">02:30</option>
                                                <option value="03:00">03:00</option>
                                                <option value="03:30">03:30</option>
                                                <option value="04:00">04:00</option>
                                                <option value="04:30">04:30</option>
                                                <option value="05:00">05:00</option>
                                                <option value="05:30">05:30</option>
                                                <option value="06:00">06:00</option>
                                                <option value="06:30">06:30</option>
                                                <option value="07:00">07:00</option>
                                                <option value="07:30">07:30</option>
                                                <option value="08:00">08:00</option>
                                                <option value="08:30">08:30</option>
                                                <option value="09:00">09:00</option>
                                                <option value="09:30">09:30</option>
                                                <option value="10:00">10:00</option>
                                                <option value="10:30">10:30</option>
                                                <option value="11:00">11:00</option>
                                                <option value="11:30">11:30</option>
                                            </select>
                                            <input type="hidden" name="day_${day}_open_1" class="hidden-time-input">
                                            <span>~</span>
                                            <select name="day_${day}_close_1_ampm" class="time-select form-select w-24">
                                                <option value="am">오전</option>
                                                <option value="pm" selected="">오후</option>
                                            </select>
                                            <select name="day_${day}_close_1_time" class="time-select form-select">
                                                <option value="12:00">12:00</option>
                                                <option value="12:30">12:30</option>
                                                <option value="01:00">01:00</option>
                                                <option value="01:30">01:30</option>
                                                <option value="02:00">02:00</option>
                                                <option value="02:30">02:30</option>
                                                <option value="03:00">03:00</option>
                                                <option value="03:30">03:30</option>
                                                <option value="04:00">04:00</option>
                                                <option value="04:30">04:30</option>
                                                <option value="05:00">05:00</option>
                                                <option value="05:30">05:30</option>
                                                <option value="06:00">06:00</option>
                                                <option value="06:30">06:30</option>
                                                <option value="07:00">07:00</option>
                                                <option value="07:30">07:30</option>
                                                <option value="08:00">08:00</option>
                                                <option value="08:30">08:30</option>
                                                <option value="09:00">09:00</option>
                                                <option value="09:30">09:30</option>
                                                <option value="10:00" selected="">10:00</option>
                                                <option value="10:30">10:30</option>
                                                <option value="11:00">11:00</option>
                                                <option value="11:30">11:30</option>
                                            </select>
                                            <input type="hidden" name="day_${day}_close_1" class="hidden-time-input">
                                            <button type="button" class="add-slot-btn text-blue-600 text-sm font-semibold whitespace-nowrap">시간 추가</button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div>
                        <label for="restaurantImage" class="block text-sm font-medium text-gray-700">대표 이미지 파일</label>
                        <input type="file" id="restaurantImage" name="restaurantImage" accept="image/*" class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                        <img id="imagePreview" src="" alt="이미지 미리보기" class="mt-4 rounded-lg shadow-sm" style="display:none; max-width:300px; max-height:200px;">
                    </div>
                </div>

                <div class="flex justify-end space-x-4 border-t pt-6">
                    <a href="/MeetLog/business/restaurants" class="bg-gray-200 text-gray-800 px-6 py-2 rounded-md hover:bg-gray-300">취소</a>
                    <button type="submit" class="form-btn-primary px-6 py-2">가게 등록</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 풋터 포함 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <script>
        $(document).ready(function() {
            const kakaoApiKey = "002cda6a5f1ab9f97f163f26a0af6e66";
            if (kakaoApiKey) {
                const scriptUrl = `//dapi.kakao.com/v2/maps/sdk.js?appkey=\${kakaoApiKey}&libraries=services&autoload=false`;
                $.getScript(scriptUrl, function() {
                    kakao.maps.load(() => console.log("Kakao Maps API 로드 성공."));
                });
            } else {
                console.warn("Kakao API 키가 설정되지 않았습니다.");
            }

            function updateHiddenTime($select) {
                const $slot = $select.closest('.time-slot');
                const name = $select.attr('name').replace('_ampm', '').replace('_time', '');
                
                const ampm = $slot.find(`select[name='\${name}_ampm']`).val();
                const time = $slot.find(`select[name='\${name}_time']`).val();
                
                // time이 undefined이거나 빈 문자열인 경우 처리
                if (!time || time === '') {
                    return;
                }
                
                let [hour, minute] = time.split(':').map(Number);

                if (ampm === 'pm' && hour < 12) hour += 12;
                if (ampm === 'am' && hour === 12) hour = 0;
                
                // [수정] JSP EL 충돌을 피하기 위해 \${...}로 이스케이프 처리
                $slot.find(`input[name='\${name}']`).val(`\${String(hour).padStart(2, '0')}:\${String(minute).padStart(2, '0')}`);
            }

            $('#searchAddressBtn').on('click', function() {
                new daum.Postcode({
                    oncomplete: function(data) {
                        $('#address').val(data.roadAddress);
                        $('#location').val(data.sigungu);

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
            
            $('#hours-container').on('click', '.add-slot-btn', function() {
                const $slotsContainer = $(this).closest('.day-wrapper').find('.slots-container');
                const $firstSlot = $slotsContainer.find('.time-slot:first');
                const $newSlot = $firstSlot.clone();
                
                const newIndex = $slotsContainer.children().length + 1;
                $newSlot.find('select, input').each(function() {
                    this.name = this.name.replace(/_1$/, `_\${newIndex}`);
                });
                $newSlot.find('button').text('삭제').removeClass('add-slot-btn text-blue-600').addClass('remove-slot-btn text-red-600');
                
                $slotsContainer.append($newSlot);
            });

            $('#hours-container').on('click', '.remove-slot-btn', function() {
                $(this).closest('.time-slot').remove();
            });
            
            $('#applyToAllBtn').on('click', function() {
                const $mondayWrapper = $('#day_1_wrapper');
                const isClosed = $mondayWrapper.find('.day-toggle-checkbox').is(':checked');
                
                // 월요일의 모든 시간 슬롯 데이터를 객체 배열로 저장
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

                // 화요일부터 일요일까지 적용
                $('.day-wrapper').not('#day_1_wrapper').each(function() {
                    const $currentWrapper = $(this);
                    const dayIndex = $currentWrapper.data('day-index');
                    const $slotsContainer = $currentWrapper.find('.slots-container');
                    
                    $currentWrapper.find('.day-toggle-checkbox').prop('checked', isClosed).trigger('change');

                    if (!isClosed) {
                        $slotsContainer.empty(); // 기존 슬롯 삭제
                        const $templateSlot = $('#day_1_wrapper .time-slot:first');

                        if (mondaySlotsData.length > 0) {
                             mondaySlotsData.forEach((data, index) => {
                                const $newSlot = $templateSlot.clone();
                                const newIndex = index + 1;

                                $newSlot.find('select, input').each(function() {
                                    this.name = this.name.replace(/day_1/g, `day_\${dayIndex}`).replace(/_1$/, `_\${newIndex}`);
                                });

                                if (index > 0) {
                                    $newSlot.find('button').text('삭제').removeClass('add-slot-btn text-blue-600').addClass('remove-slot-btn text-red-600');
                                } else {
                                     $newSlot.find('button').text('시간 추가').removeClass('remove-slot-btn text-red-600').addClass('add-slot-btn text-blue-600');
                                }

                                // 저장된 데이터로 값 설정
                                $newSlot.find('select[name*="_open_"][name*="_ampm"]').val(data.openAmpm);
                                $newSlot.find('select[name*="_open_"][name*="_time"]').val(data.openTime);
                                $newSlot.find('select[name*="_close_"][name*="_ampm"]').val(data.closeAmpm);
                                $newSlot.find('select[name*="_close_"][name*="_time"]').val(data.closeTime);
                                
                                $slotsContainer.append($newSlot);
                            });
                        }
                    }
                });
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
                const phone1 = $('#phone1').val();
                const phone2 = $('#phone2').val();
                const phone3 = $('#phone3').val();
                if (phone1 && phone2 && phone3) {
                    $('#phone').val(`\${phone1}-\${phone2}-\${phone3}`);
                }
                $(this).attr('action', '/MeetLog/business/restaurants/add');
                $(this).attr('method', 'post');
                $(this).attr('enctype', 'multipart/form-data');
            });

            $('.time-select').trigger('change');
        });
    </script>
</body>
</html>