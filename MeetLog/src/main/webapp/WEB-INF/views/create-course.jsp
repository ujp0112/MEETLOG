<%@ page buffer="32kb" %>
<%@ page import="util.ApiKeyLoader"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko" class="h-full">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - 지역 정보 & 코스 만들기</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services"></script>
<style>
    .tab-btn { padding: 10px 16px; border-bottom: 3px solid transparent; font-weight: 600; color: #64748b; transition: all 0.2s; cursor: pointer; }
    .tab-btn.active-tab { border-bottom-color: #0284c7; color: #0284c7; }
    .tab-content { display: none; }
    .tab-content.active-content { display: block; }
    .course-sidebar { width: 380px; transition: width 0.3s ease-in-out; }
    .course-item-connector { position: absolute; bottom: -20px; left: 27px; width: 2px; height: 20px; background-color: #cbd5e1; }
    .course-item-connector::after { content: '▼'; position: absolute; bottom: -12px; left: 50%; transform: translateX(-50%); font-size: 12px; color: #94a3b8; }
    .marker-number { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -65%); font-size: 12px; font-weight: bold; color: white; text-shadow: -1px 0 #000, 0 1px #000, 1px 0 #000, 0 -1px #000; }
    .result-badge {
        background-color: #e0f2fe; color: #0c4a6e; font-size: 11px; font-weight: bold;
        padding: 2px 6px; border-radius: 10px; margin-left: 6px;
    }
    .meetlog-badge {
        background: linear-gradient(135deg, #8b5cf6 0%, #d946ef 100%);
        color: white; font-size: 0.7rem; font-weight: bold;
        padding: 2px 8px; border-radius: 9999px; margin-left: 8px; display: inline-block;
    }
</style>
</head>
<body class="h-full bg-slate-50">

<div id="app" class="h-full flex flex-col">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <main class="flex-grow flex">
        <div class="w-[450px] bg-white shadow-lg flex flex-col p-4 overflow-y-auto">
            <div class="p-2">
                <h2 class="text-2xl font-bold">🗺️ 지역 정보 둘러보기</h2>
                <p class="text-slate-500 mt-1">궁금한 지역을 검색하고 최고의 정보를 만나보세요.</p>
            </div>
            <div class="p-2">
                <label for="search-input" class="block font-medium text-slate-700">지역 검색</label>
                <div class="flex gap-2 mt-1">
                    <input type="text" id="search-input" placeholder="예: 강남역, 성수동" class="w-full p-2 border rounded-md">
                    <button type="button" id="search-btn" class="bg-slate-700 text-white font-bold px-4 rounded-md hover:bg-slate-800 whitespace-nowrap">검색</button>
                </div>
            </div>
            <div class="flex border-b mt-4 flex-wrap">
                <button type="button" class="tab-btn active-tab" data-tab="ranking-resto">👑 맛집</button>
                <button type="button" class="tab-btn" data-tab="ranking-column">✍️ 칼럼</button>
                <button type="button" class="tab-btn" data-tab="ranking-review">✨ 리뷰</button>
                <button type="button" class="tab-btn" data-tab="ranking-course">🚗 코스</button>
            </div>
            <div class="flex-grow pt-4">
                <div id="ranking-resto-content" class="tab-content active-content space-y-2 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="ranking-column-content" class="tab-content space-y-3 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="ranking-review-content" class="tab-content space-y-3 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="ranking-course-content" class="tab-content space-y-3 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
            </div>
        </div>
        <div id="map" class="flex-grow h-full"></div>
        <div id="course-sidebar" class="course-sidebar bg-white shadow-2xl flex flex-col border-l">
            <form id="course-form" action="${pageContext.request.contextPath}/course/create" method="post" enctype="multipart/form-data" class="h-full flex flex-col">
                <input type="hidden" name="courseData" id="courseDataInput">
                <div class="p-6 border-b"><h3 class="font-bold text-xl">📍 나의 코스</h3><p class="text-slate-500 mt-1 text-sm">맛집, 명소를 추가해 하루를 계획하세요.</p></div>
                <div id="course-cart-sidebar" class="flex-grow p-4 space-y-4 overflow-y-auto"><p class="initial-message text-slate-400 text-center pt-12">좌측 검색 결과에서<br/>장소를 추가하세요.</p></div>
                <div class="mt-auto p-4 space-y-4 border-t bg-slate-50">
                    <div>
                        <h3 class="font-bold text-lg">코스 요약</h3>
                        <div class="flex justify-between items-center text-slate-600 mt-2"><span>총 시간</span> <span id="total-time" class="font-bold text-lg text-slate-800">0 분</span></div>
                        <div class="flex justify-between items-center text-slate-600 mt-1"><span>총 비용</span> <span id="total-cost" class="font-bold text-lg text-slate-800">₩ 0</span></div>
                    </div>
                    <button type="submit" id="save-course-btn" class="w-full bg-sky-600 text-white font-bold py-3 rounded-lg hover:bg-sky-700 disabled:bg-slate-300" disabled>코스 완성하기</button>
                </div>
            </form>
        </div>
    </main>
</div>

<!-- 코스 저장 모달 -->
<div id="save-modal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg p-6 w-full max-w-md mx-4">
        <h3 class="text-xl font-bold mb-4">코스 저장</h3>
        <div class="space-y-4">
            <div>
                <label for="course-title" class="block text-sm font-medium text-slate-700 mb-1">코스 제목 *</label>
                <input type="text" id="course-title" name="title" placeholder="예: 성수동 핫플레이스 투어" class="w-full p-2 border rounded-md" required>
            </div>
            <div>
                <label for="course-tags" class="block text-sm font-medium text-slate-700 mb-1">태그 (쉼표로 구분)</label>
                <input type="text" id="course-tags" name="tags" placeholder="예: 성수동, 데이트, 카페" class="w-full p-2 border rounded-md">
            </div>
            <div>
                <label for="course-thumbnail" class="block text-sm font-medium text-slate-700 mb-1">썸네일 이미지 (선택)</label>
                <input type="file" id="course-thumbnail" name="thumbnail" accept="image/*" class="w-full p-2 border rounded-md">
            </div>
        </div>
        <div class="flex gap-2 mt-6">
            <button type="button" onclick="closeSaveModal()" class="flex-1 px-4 py-2 bg-slate-200 text-slate-700 rounded-md hover:bg-slate-300">취소</button>
            <button type="button" onclick="submitCourse()" class="flex-1 px-4 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700">완성하기</button>
        </div>
    </div>
</div>

<script>
    const contextPath = "<%= request.getContextPath() %>";
    let map, ps;
    let searchMarkers = [], courseMarkers = [];
    let coursePolyline = null;
    let courseCart = [];

    $(document).ready(function() {
        const mapContainer = document.getElementById('map');
        const mapOption = { center: new kakao.maps.LatLng(37.566826, 126.97865), level: 5 };
        map = new kakao.maps.Map(mapContainer, mapOption);
        ps = new kakao.maps.services.Places();

        // 수정 모드일 경우 기존 데이터 로드
        <c:if test="${isEditMode && not empty course && not empty steps}">
            // 코스 정보 로드
            const editCourse = {
                id: ${course.id},
                title: '${course.title}',
                tags: <c:if test="${not empty course.tags}">[<c:forEach var="tag" items="${course.tags}" varStatus="status">'${tag}'<c:if test="${!status.last}">,</c:if></c:forEach>]</c:if><c:if test="${empty course.tags}">[]</c:if>
            };

            // 스텝 데이터를 courseCart에 추가
            <c:forEach var="step" items="${steps}">
                courseCart.push({
                    id: null,
                    name: '${step.name}',
                    address: '${step.address != null ? step.address : ""}',
                    lat: ${step.latitude != null ? step.latitude : 0},
                    lng: ${step.longitude != null ? step.longitude : 0},
                    type: '${step.type}',
                    time: ${step.time},
                    cost: ${step.cost}
                });
            </c:forEach>

            // UI 업데이트
            if (courseCart.length > 0) {
                renderCourseSidebar();
                updateCourseOnMap();
                updateSummary();
            }
        </c:if>

        $('#search-btn').on('click', performSearch);
        $('#search-input').on('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); performSearch(); } });

        // 폼 제출 이벤트 막고 모달 띄우기
        $('#course-form').on('submit', function(e) {
            e.preventDefault();
            if (courseCart.length === 0) {
                alert('코스에 장소를 추가해주세요.');
                return;
            }
            openSaveModal();

            // 수정 모드일 경우 기존 정보 미리 입력
            <c:if test="${isEditMode && not empty course}">
                document.getElementById('course-title').value = editCourse.title;
                if (editCourse.tags && editCourse.tags.length > 0) {
                    document.getElementById('course-tags').value = editCourse.tags.join(', ');
                }
            </c:if>
        });

        $('.tab-btn').on('click', function() {
            $('.tab-btn').removeClass('active-tab');
            $(this).addClass('active-tab');
            const tabName = $(this).data('tab');
            $('.tab-content').removeClass('active-content');
            $('#' + tabName + '-content').addClass('active-content');
        });

        renderCourseSidebar();
    });

    function performSearch() {
        const keyword = $('#search-input').val().trim();
        if (!keyword) {
            alert('검색어를 입력해주세요.');
            return;
        }
        
        $('.tab-content').html('<p class="text-slate-400 text-center py-8">검색 중...</p>');
        removeSearchMarkers();
        
        ps.keywordSearch(keyword, (kakaoData, status) => {
            if (status === kakao.maps.services.Status.OK) {
                const bounds = new kakao.maps.LatLngBounds();
                kakaoData.forEach(place => bounds.extend(new kakao.maps.LatLng(place.y, place.x)));
                map.setBounds(bounds);
                fetchDbAndDisplayCombined(kakaoData);
            } else {
                fetchDbAndDisplayCombined([]);
            }
        });

        fetchRankedData('columns', keyword, displayRankedColumns);
    }

    function fetchDbAndDisplayCombined(kakaoPlaces) {
        const center = map.getCenter();
        const url = contextPath + '/search/db-restaurants?lat=' + center.getLat() + '&lng=' + center.getLng() + '&level=' + map.getLevel() + '&page=1';
        
        $.getJSON(url, function(dbPlaces) {
            const dbPlaceIds = new Set(dbPlaces.map(p => p.id));
            const filteredKakaoPlaces = kakaoPlaces.filter(p => !dbPlaceIds.has(p.id));
            displayCombinedRestaurantResults(dbPlaces, filteredKakaoPlaces);
        }).fail(function() {
            displayCombinedRestaurantResults([], kakaoPlaces);
        });
    }

    function displayCombinedRestaurantResults(dbPlaces, kakaoPlaces) {
        const container = $('#ranking-resto-content');
        container.empty();
        removeSearchMarkers();
        
        const totalCount = dbPlaces.length + kakaoPlaces.length;
        updateTabBadge('ranking-resto', totalCount);

        if (totalCount === 0) {
            container.html('<p class="text-slate-400 text-center py-8">이 지역의 맛집 검색 결과가 없습니다.</p>');
            return;
        }

        dbPlaces.forEach(place => {
            const placePosition = new kakao.maps.LatLng(place.latitude, place.longitude);
            const markerImage = new kakao.maps.MarkerImage('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png', new kakao.maps.Size(33, 36));
            addMarker(placePosition, markerImage);
            const placeDataForCart = { id: 'db-' + place.id, name: place.name, address: place.address, lat: place.latitude, lng: place.longitude };
            const itemEl = $('<div class="p-2 border rounded-md flex justify-between items-center cursor-pointer hover:bg-sky-50"><div class="flex items-center"><div><p class="font-bold">' + place.name + ' <span class="meetlog-badge">MEET LOG</span></p><p class="text-xs text-slate-500">' + place.address + '</p></div></div><button class="add-btn text-sm bg-sky-500 text-white px-2 py-1 rounded-md whitespace-nowrap">추가</button></div>');
            itemEl.on('click', '.add-btn', (e) => { e.stopPropagation(); addPlaceToCart(placeDataForCart); });
            itemEl.on('click', () => map.setCenter(placePosition));
            container.append(itemEl);
        });
        
        kakaoPlaces.forEach(place => {
            const placePosition = new kakao.maps.LatLng(place.y, place.x);
            addMarker(placePosition);
            const placeDataForCart = { id: place.id, name: place.place_name, address: (place.road_address_name || place.address_name), lat: place.y, lng: place.x };
            const itemEl = $('<div class="p-2 border rounded-md flex justify-between items-center cursor-pointer hover:bg-sky-50"><div class="flex items-center"><div><p class="font-bold">' + place.place_name + '</p><p class="text-xs text-slate-500">' + (place.road_address_name || place.address_name) + '</p></div></div><button class="add-btn text-sm bg-sky-500 text-white px-2 py-1 rounded-md whitespace-nowrap">추가</button></div>');
            itemEl.on('click', '.add-btn', (e) => { e.stopPropagation(); addPlaceToCart(placeDataForCart); });
            itemEl.on('click', () => map.setCenter(placePosition));
            container.append(itemEl);
        });
    }

    async function fetchRankedData(type, keyword, displayFunction) {
        const container = $('#ranking-' + type + '-content');
        try {
            // [수정] 템플릿 리터럴을 문자열 더하기로 변경
            const response = await fetch(contextPath + '/api/' + type + '/rank?region=' + encodeURIComponent(keyword));
            if (response.ok) {
                const data = await response.json();
                displayFunction(data);
            } else {
                throw new Error('Server response was not ok.');
            }
        } catch (e) {
            console.error(type + ' 랭킹 API 호출 에러:', e);
            container.html('<p class="text-red-500 text-center py-8">' + type + ' 로딩 실패</p>');
            updateTabBadge('ranking-' + type, 0);
        }
    }

    function displayRankedColumns(columns) {
        const container = $('#ranking-column-content');
        container.empty();
        updateTabBadge('ranking-column', columns.length);
        if (columns.length === 0) {
            container.html('<p class="text-slate-400 text-center py-8">이 지역의 베스트 칼럼이 없습니다.</p>');
            return;
        }
        columns.forEach(col => {
            container.append('<a href="' + contextPath + '/column/detail?id=' + col.id + '" target="_blank" class="block p-3 border rounded-md hover:shadow-md transition"><p class="font-bold text-lg text-slate-800">' + col.title + '</p><p class="text-sm text-slate-500 mt-1 truncate">' + col.contentSnippet + '</p><p class="text-xs text-slate-400 mt-2">by ' + col.authorNickname + '</p></a>');
        });
    }

    function addMarker(position, image) {
        const marker = new kakao.maps.Marker({ map: map, position: position, image: image });
        searchMarkers.push(marker);
    }
    
    function removeSearchMarkers() {
        searchMarkers.forEach(marker => marker.setMap(null));
        searchMarkers = [];
    }

    function updateTabBadge(tabName, count) {
        const tabButton = $('.tab-btn[data-tab="' + tabName + '"]');
        tabButton.find('.result-badge').remove();
        if (count > 0) {
            tabButton.append('<span class="result-badge">' + count + '</span>');
        }
    }

    function addPlaceToCart(place) {
        // 이름으로 중복 체크 (id가 없을 수 있음)
        if (courseCart.some(item => item.name === place.name && item.address === place.address)) {
            alert("이미 코스에 추가된 장소입니다.");
            return;
        }
        const placeData = {
            id: place.id || null,
            name: place.name,
            address: place.address,
            lat: place.lat,
            lng: place.lng,
            type: place.type || 'RESTAURANT',
            time: 60,
            cost: 10000
        };
        courseCart.push(placeData);
        renderCourseSidebar();
        updateCourseOnMap();
        updateSummary();
    }
        
    function renderCourseSidebar() {
        const container = $('#course-cart-sidebar');
        if (courseCart.length === 0) {
            container.html('<p class="initial-message text-slate-400 text-center pt-12">좌측 검색 결과에서<br/>장소를 추가하세요.</p>');
            $('#save-course-btn').prop('disabled', true);
            return;
        }
        container.empty();
        courseCart.forEach((item, index) => {
            const isLastItem = index === courseCart.length - 1;
            const itemEl = $('<div class="p-3 rounded-lg bg-slate-50 relative"><div class="flex justify-between items-start"><div class="flex items-start gap-3"><span class="font-bold text-lg text-sky-600 mt-1">' + (index + 1) + '</span><div><p class="font-bold text-slate-800">' + item.name + '</p><p class="text-xs text-slate-500">' + (item.address || '') + '</p></div></div><button class="remove-btn text-sm text-red-500 font-semibold whitespace-nowrap">삭제</button></div><div class="flex gap-4 text-sm mt-3 pl-8"><div class="flex-1"><label class="font-medium text-xs">시간(분)</label><input type="number" class="time-input w-full p-1 border rounded-md mt-1" value="' + item.time + '" step="10" min="0"></div><div class="flex-1"><label class="font-medium text-xs">비용(원)</label><input type="number" class="cost-input w-full p-1 border rounded-md mt-1" value="' + item.cost + '" step="1000" min="0"></div></div>' + (!isLastItem ? '<div class="course-item-connector"></div>' : '') + '</div>');
            itemEl.on('click', '.remove-btn', () => removePlaceFromCart(index));
            itemEl.on('input', '.time-input', function() { courseCart[index].time = parseInt($(this).val()) || 0; updateSummary(); });
            itemEl.on('input', '.cost-input', function() { courseCart[index].cost = parseInt($(this).val()) || 0; updateSummary(); });
            container.append(itemEl);
        });
        $('#save-course-btn').prop('disabled', false);
    }

    function removePlaceFromCart(indexToRemove) {
        courseCart.splice(indexToRemove, 1);
        renderCourseSidebar();
        updateCourseOnMap();
        updateSummary();
    }

    function updateCourseOnMap() {
        courseMarkers.forEach(marker => marker.setMap(null));
        courseMarkers = [];
        if (coursePolyline) coursePolyline.setMap(null);
        if (courseCart.length === 0) return;
        
        const path = [];
        const bounds = new kakao.maps.LatLngBounds();
        courseCart.forEach((place, index) => {
            const position = new kakao.maps.LatLng(place.lat, place.lng);
            path.push(position);
            bounds.extend(position);
            const content = '<div style="position: relative;"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png" style="width: 36px; height: 37px;"><span class="marker-number">' + (index + 1) + '</span></div>';
            const marker = new kakao.maps.CustomOverlay({ position: position, content: content, yAnchor: 1.2 });
            marker.setMap(map);
            courseMarkers.push(marker);
        });
        
        if (path.length > 1) {
            coursePolyline = new kakao.maps.Polyline({ path: path, strokeWeight: 4, strokeColor: '#1E90FF', strokeOpacity: 0.8, strokeStyle: 'solid' });
            coursePolyline.setMap(map);
        }
        if (courseCart.length > 0) map.setBounds(bounds);
    }

    function updateSummary() {
        const totalTime = courseCart.reduce((sum, item) => sum + item.time, 0);
        const totalCost = courseCart.reduce((sum, item) => sum + item.cost, 0);
        const hours = Math.floor(totalTime / 60);
        const minutes = totalTime % 60;
        let timeString = (hours > 0 ? hours + '시간 ' : '') + (minutes > 0 || hours === 0 ? minutes + '분' : '');
        $('#total-time').text(timeString.trim() || '0 분');
        $('#total-cost').text('₩ ' + totalCost.toLocaleString());
    }

    function openSaveModal() {
        document.getElementById('save-modal').classList.remove('hidden');
    }

    function closeSaveModal() {
        document.getElementById('save-modal').classList.add('hidden');
        document.getElementById('course-title').value = '';
        document.getElementById('course-tags').value = '';
        document.getElementById('course-thumbnail').value = '';
    }

    function submitCourse() {
        const title = document.getElementById('course-title').value.trim();
        if (!title) {
            alert('코스 제목을 입력해주세요.');
            return;
        }

        // 코스에 장소가 있는지 확인
        if (courseCart.length === 0) {
            alert('코스에 장소를 추가해주세요.');
            closeSaveModal();
            return;
        }

        // 모든 step의 데이터가 유효한지 검증
        for (let i = 0; i < courseCart.length; i++) {
            const place = courseCart[i];
            if (!place.name || !place.name.trim()) {
                alert(`${i + 1}번째 장소의 이름이 없습니다.`);
                return;
            }
            if (isNaN(place.time) || place.time < 0) {
                alert(`${i + 1}번째 장소의 시간이 유효하지 않습니다.`);
                return;
            }
            if (isNaN(place.cost) || place.cost < 0) {
                alert(`${i + 1}번째 장소의 비용이 유효하지 않습니다.`);
                return;
            }
        }

        const formData = new FormData();
        formData.append('title', title);

        const tags = document.getElementById('course-tags').value.trim();
        if (tags) {
            formData.append('tags', tags);
        }

        const thumbnailFile = document.getElementById('course-thumbnail').files[0];
        if (thumbnailFile) {
            formData.append('thumbnail', thumbnailFile);
        }

        // 코스 데이터 추가 (각 step을 개별 파라미터로)
        courseCart.forEach((place, index) => {
            const stepNum = index + 1;
            formData.append('step_name_' + stepNum, place.name);
            formData.append('step_type_' + stepNum, place.type || 'RESTAURANT');
            formData.append('step_time_' + stepNum, Math.max(0, parseInt(place.time) || 0));
            formData.append('step_cost_' + stepNum, Math.max(0, parseInt(place.cost) || 0));
            formData.append('step_latitude_' + stepNum, place.lat || 0);
            formData.append('step_longitude_' + stepNum, place.lng || 0);
            formData.append('step_address_' + stepNum, place.address || '');
        });

        // 수정 모드일 경우 코스 ID 추가
        <c:if test="${isEditMode && not empty course}">
            formData.append('courseId', ${course.id});
        </c:if>

        // 폼 제출
        const form = document.getElementById('course-form');
        <c:choose>
            <c:when test="${isEditMode}">
                const action = contextPath + '/course/edit';
            </c:when>
            <c:otherwise>
                const action = form.action;
            </c:otherwise>
        </c:choose>

        // 로딩 표시
        const submitBtn = document.querySelector('#save-modal button[onclick="submitCourse()"]');
        const originalText = submitBtn.textContent;
        submitBtn.disabled = true;
        submitBtn.textContent = '저장 중...';

        fetch(action, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (response.redirected) {
                window.location.href = response.url;
            } else if (response.ok) {
                return response.text().then(text => {
                    // 응답 본문을 확인해서 에러 메시지가 있는지 체크
                    if (text.includes('error') || text.includes('Error')) {
                        throw new Error('서버에서 에러가 발생했습니다.');
                    }
                    // 성공했지만 리다이렉트가 안된 경우 수동으로 이동
                    window.location.href = contextPath + '/course/list';
                });
            } else {
                throw new Error('코스 저장 실패 (HTTP ' + response.status + ')');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('코스 저장 중 오류가 발생했습니다: ' + error.message);
            submitBtn.disabled = false;
            submitBtn.textContent = originalText;
        });
    }
</script>
</body>
</html>

