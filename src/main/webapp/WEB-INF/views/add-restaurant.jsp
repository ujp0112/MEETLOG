<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<<<<<<< HEAD
<%@ page import="java.util.Properties, java.io.FileInputStream" %>
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
=======
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
<<<<<<< HEAD
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
    <div class="max-w-4xl mx-auto py-12 px-4">
        <div class="bg-white rounded-2xl shadow-xl p-8 md:p-12">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">새 가게 등록</h1>
            <p class="text-gray-600 mb-8">MEET LOG에 등록하여 가게를 홍보하고 관리하세요.</p>

            <form id="restaurantForm" class="space-y-6">
                
                <%-- 기본 정보 --%>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 border-t pt-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700">가게 이름</label>
                        <input type="text" id="name" name="name" required class="form-input mt-1">
                    </div>
                    <div>
                        <label for="category" class="block text-sm font-medium text-gray-700">카테고리</label>
                        <select id="category" name="category" required class="form-select mt-1">
                            <option value="">선택하세요</option><option value="한식">한식</option><option value="중식">중식</option><option value="일식">일식</option><option value="양식">양식</option><option value="아시안">아시안</option><option value="카페">카페</option><option value="주점">주점</option><option value="기타">기타</option>
                        </select>
                    </div>
                </div>

                <%-- 주소 정보 --%>
                <div class="border-t pt-6 space-y-2">
                    <label class="block text-sm font-medium text-gray-700">주소 정보</label>
                    <div class="flex items-center gap-2">
                         <input type="text" id="address" name="address" required class="form-input" placeholder="오른쪽 '주소 검색' 버튼을 클릭하세요" readonly>
                         <button type="button" id="searchAddressBtn" class="form-btn-primary whitespace-nowrap px-4 py-2 text-sm">주소 검색</button>
                    </div>
                    <div>
                        <label for="location" class="block text-sm font-medium text-gray-700 mt-2">지역 (자동 입력)</label>
                        <input type="text" id="location" name="location" required class="form-input mt-1 bg-gray-100" readonly>
                    </div>
                    <input type="text" id="detail_address" name="detail_address" class="form-input" placeholder="상세 주소를 입력하세요">
                    <input type="hidden" id="latitude" name="latitude"><input type="hidden" id="longitude" name="longitude">
                </div>

                <%-- 영업 시간 정보 --%>
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
                            <% String[] days = {"월", "화", "수", "목", "금", "토", "일"}; %>
                            <% for(int i = 0; i < days.length; i++) { int dayIndex = i + 1; %>
                                <div id="day_<%= dayIndex %>_wrapper" class="day-wrapper p-4 border rounded-lg bg-gray-50 transition-all duration-300" data-day-index="<%= dayIndex %>">
                                    <div class="flex items-center justify-between">
                                        <label class="font-semibold text-gray-800"><%= days[i] %>요일</label>
                                        <div>
                                            <input type="checkbox" id="is_closed_<%= dayIndex %>" name="is_closed_<%= dayIndex %>" class="day-toggle-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                                            <label for="is_closed_<%= dayIndex %>" class="ml-2 text-sm">휴무</label>
                                        </div>
                                    </div>
                                    <div class="slots-container mt-2 space-y-2">
                                        <div class="time-slot flex items-center gap-2">
                                            <select name="day_<%= dayIndex %>_open_1_ampm" class="time-select form-select w-24"><option value="am">오전</option><option value="pm">오후</option></select>
                                            <select name="day_<%= dayIndex %>_open_1_time" class="time-select form-select">
                                                <% for(int h=0; h<12; h++) { for(int m=0; m<60; m+=30) { String time = String.format("%02d:%02d", (h==0)?12:h, m); %><option value="<%= time %>"><%= time %></option><% }} %>
                                            </select>
                                            <input type="hidden" name="day_<%= dayIndex %>_open_1" class="hidden-time-input">
                                            <span>~</span>
                                            <select name="day_<%= dayIndex %>_close_1_ampm" class="time-select form-select w-24"><option value="am">오전</option><option value="pm" selected>오후</option></select>
                                            <select name="day_<%= dayIndex %>_close_1_time" class="time-select form-select">
                                                 <% for(int h=0; h<12; h++) { for(int m=0; m<60; m+=30) { String time = String.format("%02d:%02d", (h==0)?12:h, m); %><option value="<%= time %>" <%= (h==10 && m==0) ? "selected" : "" %>><%= time %></option><% }} %>
                                            </select>
                                            <input type="hidden" name="day_<%= dayIndex %>_close_1" class="hidden-time-input">
                                            <button type="button" class="add-slot-btn text-blue-600 text-sm font-semibold whitespace-nowrap">시간 추가</button>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <div>
                        <label for="restaurantImage" class="block text-sm font-medium text-gray-700">대표 이미지 파일</label>
                        <input type="file" id="restaurantImage" name="restaurantImage" accept="image/*" class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                        <img id="imagePreview" src="" alt="이미지 미리보기" class="mt-4 rounded-lg shadow-sm" style="display:none; max-width:300px; max-height:200px;">
                    </div>
                </div>

                <div class="flex justify-end space-x-4 border-t pt-6">
                    <a href="${pageContext.request.contextPath}/business/restaurants" class="bg-gray-200 text-gray-800 px-6 py-2 rounded-md hover:bg-gray-300">취소</a>
                    <button type="submit" class="form-btn-primary px-6 py-2">가게 등록</button>
                </div>
            </form>
        </div>
    </div>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <script>
        $(document).ready(function() {

            const kakaoApiKey = "<%= kakaoApiKey %>";
            if (kakaoApiKey) {
                const scriptUrl = `//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services&autoload=false`;
                $.getScript(scriptUrl, function() {
                    kakao.maps.load(() => console.log("Kakao Maps API 로드 성공."));
                });
            } else {
                console.warn("Kakao API 키가 설정되지 않았습니다.");
            }

            function updateHiddenTime($select) {
                const $slot = $select.closest('.time-slot');
                const name = $select.attr('name').replace('_ampm', '').replace('_time', '');
                
                const ampm = $slot.find(`select[name='${name}_ampm']`).val();
                const time = $slot.find(`select[name='${name}_time']`).val();
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
                    this.name = this.name.replace(/_1$/, `_${newIndex}`);
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
                                    this.name = this.name.replace(/day_1/g, `day_${dayIndex}`).replace(/_1$/, `_${newIndex}`);
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
                    $('#phone').val(`${phone1}-${phone2}-${phone3}`);
                }
                $(this).attr('action', '${pageContext.request.contextPath}/business/restaurants/add');
                $(this).attr('method', 'post');
                $(this).attr('enctype', 'multipart/form-data');
            });

            $('.time-select').trigger('change');
        });
    </script>
</body>
</html>
=======
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 새 가게 등록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-secondary { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="max-w-4xl mx-auto">
            <div class="glass-card p-8 rounded-3xl fade-in">
                <h1 class="text-4xl font-bold gradient-text mb-6 text-center">새 가게 등록</h1>
                <p class="text-slate-600 text-center mb-8">음식점 정보를 입력하여 MEET LOG에 등록하세요</p>
                
                <form action="${pageContext.request.contextPath}/restaurant/add" method="post" enctype="multipart/form-data" class="space-y-8">
            
                    <c:if test="${not empty errorMessage}">
                        <div class="bg-red-100 text-red-700 p-4 rounded-lg border border-red-200">
                            <div class="flex items-center">
                                <span class="text-red-500 mr-2">⚠️</span>
                                <span>${errorMessage}</span>
                            </div>
                        </div>
                    </c:if>

                    <!-- 기본 정보 섹션 -->
                    <div class="space-y-6">
                        <h2 class="text-2xl font-bold text-slate-800 border-b border-slate-200 pb-2">기본 정보</h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="name" class="block text-sm font-medium text-slate-700 mb-2">가게 이름 *</label>
                                <input type="text" id="name" name="name" required 
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                       placeholder="예: 고미정">
                            </div>
                            
                            <div>
                                <label for="category" class="block text-sm font-medium text-slate-700 mb-2">카테고리 *</label>
                                <select id="category" name="category" required 
                                        class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all">
                                    <option value="">카테고리를 선택하세요</option>
                                    <option value="한식">한식</option>
                                    <option value="중식">중식</option>
                                    <option value="일식">일식</option>
                                    <option value="양식">양식</option>
                                    <option value="카페">카페</option>
                                    <option value="디저트">디저트</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="location" class="block text-sm font-medium text-slate-700 mb-2">지역 *</label>
                                <input type="text" id="location" name="location" required 
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                       placeholder="예: 강남구, 홍대">
                            </div>
                            
                            <div>
                                <label for="phone" class="block text-sm font-medium text-slate-700 mb-2">전화번호</label>
                                <input type="tel" id="phone" name="phone" 
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                       placeholder="예: 02-1234-5678">
                            </div>
                        </div>
                        
                        <div>
                            <label for="address" class="block text-sm font-medium text-slate-700 mb-2">상세 주소 *</label>
                            <input type="text" id="address" name="address" required 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                   placeholder="예: 서울시 강남구 테헤란로 123">
                        </div>
                    </div>

                    <!-- 영업 정보 섹션 -->
                    <div class="space-y-6">
                        <h2 class="text-2xl font-bold text-slate-800 border-b border-slate-200 pb-2">영업 정보</h2>
                        
                        <div>
                            <label for="hours" class="block text-sm font-medium text-slate-700 mb-2">영업 시간</label>
                            <input type="text" id="hours" name="hours" 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                   placeholder="예: 매일 11:00 - 22:00 (브레이크타임 15:00-17:00)">
                        </div>
                        
                        <div>
                            <label for="description" class="block text-sm font-medium text-slate-700 mb-2">가게 설명</label>
                            <textarea id="description" name="description" rows="4" 
                                      class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all resize-none"
                                      placeholder="가게의 특징이나 추천 메뉴를 소개해주세요"></textarea>
                        </div>
                    </div>

                    <!-- 이미지 업로드 섹션 -->
                    <div class="space-y-6">
                        <h2 class="text-2xl font-bold text-slate-800 border-b border-slate-200 pb-2">이미지</h2>
                        
                        <div>
                            <label for="image" class="block text-sm font-medium text-slate-700 mb-2">가게 이미지</label>
                            <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-dashed border-slate-300 rounded-lg hover:border-slate-400 transition-colors">
                                <div class="space-y-1 text-center">
                                    <svg class="mx-auto h-12 w-12 text-slate-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                                        <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <div class="flex text-sm text-slate-600">
                                        <label for="image" class="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-blue-500">
                                            <span>이미지 업로드</span>
                                            <input id="image" name="image" type="file" accept="image/*" class="sr-only">
                                        </label>
                                        <p class="pl-1">또는 드래그 앤 드롭</p>
                                    </div>
                                    <p class="text-xs text-slate-500">PNG, JPG, GIF 최대 10MB</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 제출 버튼 -->
                    <div class="flex justify-center space-x-4 pt-8">
                        <a href="${pageContext.request.contextPath}/restaurant/my" 
                           class="btn-secondary text-white px-8 py-3 rounded-xl font-semibold">
                            취소
                        </a>
                        <button type="submit" 
                                class="btn-primary text-white px-8 py-3 rounded-xl font-semibold">
                            가게 등록
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 폼 검증
        document.getElementById('name').addEventListener('input', function() {
            if (this.value.length < 2) {
                this.setCustomValidity('가게 이름은 2글자 이상 입력해주세요.');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // 전화번호 형식 검증
        document.getElementById('phone').addEventListener('input', function() {
            const phoneRegex = /^[0-9-+().\s]+$/;
            if (this.value && !phoneRegex.test(this.value)) {
                this.setCustomValidity('올바른 전화번호 형식을 입력해주세요.');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // 이미지 미리보기
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const uploadArea = document.querySelector('.border-dashed');
                    uploadArea.innerHTML = `
                        <div class="text-center">
                            <img src="${e.target.result}" alt="미리보기" class="mx-auto h-32 w-32 object-cover rounded-lg">
                            <p class="mt-2 text-sm text-slate-600">${file.name}</p>
                            <button type="button" onclick="document.getElementById('image').value=''; location.reload();" 
                                    class="mt-2 text-sm text-red-600 hover:text-red-500">제거</button>
                        </div>
                    `;
                };
                reader.readAsDataURL(file);
            }
        });
        
        // 폼 제출 시 로딩 상태
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = document.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '등록 중...';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
