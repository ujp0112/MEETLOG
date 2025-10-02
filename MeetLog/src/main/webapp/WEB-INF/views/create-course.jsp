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
    /* search-map.jsp의 커스텀 마커 스타일 */
    .marker-overlay { display: flex; align-items: center; background-color: white; border: 1px solid #ccc; border-radius: 999px; box-shadow: 0 2px 6px rgba(0,0,0,0.15); padding: 5px; position: relative; transform: translate(-50%, -100%); transition: all 0.1s ease-in-out; cursor: pointer; z-index: 1; }
    .marker-overlay.highlight, .marker-overlay:hover { transform: translate(-50%, -100%) scale(1.05); z-index: 10; border-color: #3182ce; box-shadow: 0 4px 12px rgba(0,0,0,0.2); }
    .marker-overlay::after { content: ''; position: absolute; bottom: -8px; left: 50%; transform: translateX(-50%); width: 0; height: 0; border-left: 8px solid transparent; border-right: 8px solid transparent; border-top: 8px solid white; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.15)); }
    .marker-overlay-number { display: flex; justify-content: center; align-items: center; width: 24px; height: 24px; border-radius: 50%; color: white; font-weight: bold; font-size: 13px; flex-shrink: 0; }
    .marker-overlay-info { padding: 0 8px 0 6px; white-space: nowrap; max-width: 150px; overflow: hidden; text-overflow: ellipsis; }
    .marker-overlay-title { font-weight: bold; font-size: 13px; color: #2d3748; overflow: hidden; text-overflow: ellipsis; }
    .marker-overlay-category { font-size: 10px; color: #718096; }
    .marker-kakao .marker-overlay-number { background-color: #3182ce; }
    .marker-kakao .marker-overlay-title { color: #2b6cb0; }
    .marker-db .marker-overlay-number { background: linear-gradient(135deg, #8b5cf6 0%, #d946ef 100%); font-size: 16px; }
    .marker-db .marker-overlay-title { color: #8b5cf6; }
    /* 리스트 아이템 스타일 */
    .result-item { transition: background-color 0.2s; }
    .result-item:hover { background-color: #f0f7ff; }
    .result-item.highlighted { background-color: #ebf8ff; border-left: 4px solid #3182ce; padding-left: calc(0.5rem - 4px); }
    /* search-map.jsp의 리스트 아이템 이미지 스타일 */
    .result-item-image {
        width: 64px; height: 64px; object-fit: cover;
        border-radius: 0.5rem; background-color: #e2e8f0;
    }

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
            <div class="flex-grow pt-4 flex flex-col">
                <div id="ranking-resto-content" class="tab-content active-content space-y-2 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="ranking-column-content" class="tab-content space-y-3 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="ranking-review-content" class="tab-content space-y-3 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="ranking-course-content" class="tab-content space-y-3 max-h-[calc(100vh-300px)] overflow-y-auto"></div>
                <div id="load-more-container" class="p-4 border-t text-center hidden">
                    <button id="load-more-btn" class="bg-blue-500 text-white font-bold py-2 px-6 rounded-full hover:bg-blue-600 transition duration-300 ease-in-out disabled:bg-gray-400 disabled:cursor-not-allowed">
                        더 보기
                    </button>
                </div>
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
                <label for="course-description" class="block text-sm font-medium text-slate-700 mb-1">코스 설명 *</label>
                <input type="text" id="course-description" name="description" placeholder="예: 성수동 핫플레이스 투어" class="w-full p-2 border rounded-md" required>
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
    let courseMarkers = [], kakaoPagination;
    const g = { overlays: [], listItems: [] }; // 마커와 리스트 아이템 관리 객체
    let coursePolyline = null;
    let courseCart = [];
    let isLoading = false;
    let isDbSearchEnd = false;
    let isKakaoSearchEnd = false;
    let currentPage = 1;
    let displayedDbIds = [];

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
                description: '${course.description}',
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
                document.getElementById('course-description').value = editCourse.description;
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

        $('#load-more-btn').on('click', function() {
            const hasMoreData = !isDbSearchEnd || !isKakaoSearchEnd;
            if (!isLoading && hasMoreData) {
                isLoading = true;
                $(this).text('불러오는 중...').prop('disabled', true);
                currentPage++;
                
                if (kakaoPagination && !isKakaoSearchEnd) {
                    kakaoPagination.nextPage(); // placesSearchCB가 자동으로 호출됨
                } else {
                    fetchDbAndDisplayCombined(currentPage, []);
                }
            }
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
        $('#ranking-resto-content').empty(); // 맛집 목록만 비움
        $('#load-more-container').addClass('hidden');
        clearSearchResults();
        currentPage = 1;
        isDbSearchEnd = false;
        isKakaoSearchEnd = false;
        displayedDbIds = [];

        // [수정] search-map.jsp와 동일하게 음식점(FD6) 카테고리 그룹으로 검색을 제한합니다.
        const searchOptions = {
            category_group_code: 'FD6',
            size: 10
        };

        ps.keywordSearch(keyword, placesSearchCB, searchOptions);

    }

    function placesSearchCB(data, status, pagination) {
        kakaoPagination = pagination;
        isKakaoSearchEnd = !pagination.hasNextPage;

        if (currentPage === 1) {
            $('#ranking-resto-content').empty();
            clearSearchResults();
            displayedDbIds = [];
            $('#load-more-container').addClass('hidden');

            if (status === kakao.maps.services.Status.OK && data.length > 0) {
                const bounds = new kakao.maps.LatLngBounds();
                data.forEach(place => bounds.extend(new kakao.maps.LatLng(place.y, place.x)));
                map.setBounds(bounds);
                fetchDbAndDisplayCombined(currentPage, data);
                // 리뷰와 코스도 같은 위치 기준으로 검색
                fetchNearbyReviews();
                fetchNearbyCourses();
            } else {
                fetchDbAndDisplayCombined(currentPage, []);
            }
        } else {
            fetchDbAndDisplayCombined(currentPage, data || []);
        }
    }

    function fetchDbAndDisplayCombined(page, kakaoDataForPage) {
        const center = map.getCenter();
        // [수정] 카테고리 파라미터를 제거하고 항상 전체 음식점을 검색하도록 변경
        let url = contextPath + '/search/db-restaurants?lat=' + center.getLat() + '&lng=' + center.getLng() + '&level=' + map.getLevel() + '&page=' + page + '&category=';
        if (displayedDbIds.length > 0) {
            url += "&excludeIds=" + displayedDbIds.join(',');
        }
        
        $.getJSON(url, function(dbData) {
            const dbPlaces = dbData || [];
            // [수정] DB 검색 결과가 페이지당 항목 수(10)보다 적을 때만 DB 검색이 끝난 것으로 간주합니다.
            const itemsPerPage = 10; 
            if (dbPlaces.length < itemsPerPage) isDbSearchEnd = true;

            // [추가] DB 맛집 ID를 기반으로 관련 칼럼을 검색합니다.
            const dbPlaceIds = dbPlaces.map(p => p.id);
            if (page === 1 && dbPlaceIds.length > 0) {
                // 기존의 지역명 기반 검색 대신, 맛집 ID 기반으로 칼럼을 가져옵니다.
                fetchColumnsByRestaurantIds(dbPlaceIds);
            }

            dbPlaces.forEach(p => displayedDbIds.push(p.id));
            const kakaoPlaces = kakaoDataForPage.filter(p => !displayedDbIds.includes(p.id));

            displayCombinedRestaurantResults(dbPlaces, kakaoPlaces);
        }).fail(function() {
            isDbSearchEnd = true;
            displayCombinedRestaurantResults([], kakaoDataForPage);
        }).always(function() {
            isLoading = false;
            $('#load-more-btn').text('더 보기').prop('disabled', false);
            const hasMoreData = !isDbSearchEnd || !isKakaoSearchEnd;
            if (hasMoreData) {
                $('#load-more-container').removeClass('hidden');
            } else {
                $('#load-more-container').addClass('hidden');
            }
        });
    }

    function displayCombinedRestaurantResults(dbPlaces, kakaoPlaces) {
        const container = $('#ranking-resto-content');

        // 첫 페이지일 때는 기존 내용을 모두 지움 (중복 방지)
        if (currentPage === 1) {
            container.empty();
        }

        if (currentPage === 1 && dbPlaces.length === 0 && kakaoPlaces.length === 0) {
            container.html('<p class="text-slate-400 text-center py-8">이 지역의 맛집 검색 결과가 없습니다.</p>');
            return;
        }

        dbPlaces.forEach((place, i) => {
            const placePosition = new kakao.maps.LatLng(place.latitude, place.longitude);
            const detailUrl = contextPath + "/restaurant/detail/" + place.id;
            // [수정] currentPage를 포함하여 고유 ID 생성
            const uniqueId = "db-" + currentPage + "-" + i;
            
            const overlay = addCustomMarker(placePosition, {
                type: 'db',
                name: place.name,
                category: place.category,
                index: g.listItems.length + 1,
                url: detailUrl
            });

            const imageUrl = place.image ? (place.image.startsWith('http') ? place.image : contextPath + '/images/' + place.image) : 'https://placehold.co/100x100/fee2e2/b91c1c?text=No+Image';

            const placeDataForCart = { id: 'db-' + place.id, name: place.name, address: place.address, lat: place.latitude, lng: place.longitude };
            const itemEl = $(
                '<div class="result-item p-2 border rounded-md flex items-center cursor-pointer gap-3" data-id="' + uniqueId + '">' +
                    '<a href="' + detailUrl + '" target="_blank">' +
                        '<img id="img-' + uniqueId + '" src="' + imageUrl + '" alt="' + place.name + '" class="result-item-image flex-shrink-0">' +
                    '</a>' +
                    '<div class="flex-grow min-w-0">' +
                        '<a href="' + detailUrl + '" target="_blank" class="font-bold truncate block">' + place.name + ' <span class="meetlog-badge">MEET LOG</span></a>' +
                        '<p class="text-xs text-slate-500 truncate">' + place.address + '</p>' +
                    '</div>' +
                    '<button class="add-btn text-sm bg-sky-500 text-white px-2 py-1 rounded-md whitespace-nowrap ml-auto">추가</button>' +
                '</div>'
            );
            
            itemEl.on('click', function(e) {
                if (!$(e.target).closest('a, .add-btn').length) {
                    map.panTo(placePosition);
                    highlightMarker(overlay, itemEl);
                }
            });
            itemEl.on('click', '.add-btn', (e) => { e.stopPropagation(); addPlaceToCart(placeDataForCart); }); // 추가 버튼은 그대로 유지
            
            container.append(itemEl);
            g.listItems.push({id: uniqueId, el: itemEl, overlay: overlay, position: placePosition});
        });
        
        kakaoPlaces.forEach((place, i) => {
            const placePosition = new kakao.maps.LatLng(place.y, place.x);
            const detailUrl = contextPath + "/searchRestaurant/external-detail?name=" + encodeURIComponent(place.place_name) + "&address=" + encodeURIComponent(place.address_name) + "&phone=" + encodeURIComponent(place.phone) + "&category=" + encodeURIComponent(place.category_name) + "&lat=" + place.y + "&lng=" + place.x;
            // [수정] currentPage를 포함하여 고유 ID 생성
            const uniqueId = "kakao-" + currentPage + "-" + i;

            const overlay = addCustomMarker(placePosition, {
                type: 'kakao',
                name: place.place_name,
                category: place.category_name.split(' > ').pop(),
                index: g.listItems.length + 1,
                url: detailUrl
            });

            const categoryName = place.category_name.split(' > ').pop();
            const placeholderUrl = "https://placehold.co/100x100/EBF8FF/3182CE?text=" + encodeURIComponent(categoryName);

            const placeDataForCart = { id: place.id, name: place.place_name, address: (place.road_address_name || place.address_name), lat: place.y, lng: place.x };
            const itemEl = $(
                '<div class="result-item p-2 border rounded-md flex items-center cursor-pointer gap-3" data-id="' + uniqueId + '">' +
                    '<a href="' + detailUrl + '" target="_blank">' +
                        '<img id="img-' + uniqueId + '" src="' + placeholderUrl + '" alt="' + place.place_name + '" class="result-item-image flex-shrink-0">' +
                    '</a>' +
                    '<div class="flex-grow min-w-0">' +
                        '<a href="' + detailUrl + '" target="_blank" class="font-bold truncate block">' + place.place_name + '</a>' +
                        '<p class="text-xs text-slate-500 truncate">' + (place.road_address_name || place.address_name) + '</p>' +
                    '</div>' +
                    '<button class="add-btn text-sm bg-sky-500 text-white px-2 py-1 rounded-md whitespace-nowrap ml-auto">추가</button>' +
                '</div>'
            );
            
            itemEl.on('click', function(e) {
                if (!$(e.target).closest('a, .add-btn').length) {
                    map.panTo(placePosition);
                    highlightMarker(overlay, itemEl);
                }
            });
            itemEl.on('click', '.add-btn', (e) => { e.stopPropagation(); addPlaceToCart(placeDataForCart); }); // 추가 버튼은 그대로 유지

            // [추가] search-map.jsp와 동일하게 이미지 프록시를 통해 이미지를 가져옵니다.
            // [수정] 클로저 문제를 해결하기 위해, setTimeout 콜백 함수가 실행될 때
            // 올바른 uniqueId와 place를 참조하도록 새로운 변수에 값을 복사합니다.
            const currentUniqueId = uniqueId;
            const currentPlace = place;
            setTimeout(function() {
                const searchQuery = currentPlace.place_name + " " + (currentPlace.road_address_name || currentPlace.address_name).split(" ")[0];
                $.getJSON(contextPath + "/search/image-proxy?query=" + encodeURIComponent(searchQuery), function(data) {
                    if (data && data.imageUrl) {
                        // 복사된 currentUniqueId를 사용하여 정확한 img 태그를 찾습니다.
                        $('#img-' + currentUniqueId).attr('src', data.imageUrl);
                    }
                });
            }, i * 100); // API 요청 부하를 줄이기 위해 지연 실행

            container.append(itemEl);
            g.listItems.push({id: uniqueId, el: itemEl, overlay: overlay, position: placePosition});
        });

        // [수정] 목록이 업데이트된 후, 항상 배지 숫자를 최신 상태로 갱신합니다.
        updateTabBadge('ranking-resto', g.listItems.length);
    }

     // [추가] 맛집 ID 목록으로 칼럼을 가져오는 함수
    async function fetchColumnsByRestaurantIds(restaurantIds) {
        const container = $('#ranking-column-content');
        container.html('<p class="text-slate-400 text-center py-8">칼럼 검색 중...</p>');
        try {
            const response = await fetch(contextPath + '/api/columns/by-restaurants?ids=' + restaurantIds.join(','));
            if (response.ok) {
                const data = await response.json();
                displayRankedColumns(data);
            } else {
                throw new Error('Server response was not ok.');
            }
        } catch (e) {
            console.error('칼럼 API 호출 에러:', e);
            container.html('<p class="text-red-500 text-center py-8">칼럼 로딩 실패</p>');
            updateTabBadge('ranking-column', 0);
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
            const imageUrl = col.image 
                ? (col.image.startsWith('http') ? col.image : contextPath + '/images/' + col.image) 
                : 'https://placehold.co/400x200/e2e8f0/94a3b8?text=No+Image';

            const itemHtml = 
                '<a href="' + contextPath + '/column/detail?id=' + col.id + '" target="_blank" class="block bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300">' +
                    // 썸네일 이미지 영역
                    '<div class="w-full h-32 bg-slate-200">' +
                        '<img src="' + imageUrl + '" alt="' + col.title + '" class="w-full h-full object-cover">' +
                    '</div>' +
                    // 텍스트 정보 영역
                    '<div class="block p-3 border rounded-md hover:shadow-md transition">' +
                        '<p class="font-bold text-base text-slate-800 truncate">' + col.title + '</p>' +
                        '<p class="text-sm text-slate-500 mt-1 truncate">' + col.content + '</p>' +
                        '<p class="text-xs text-slate-400 mt-1">by ' + col.author + '</p>' + // [수정] 작성자 필드를 올바르게 참조합니다.
                    '</div>' +
                '</a>'
            container.append(itemHtml);
        });
    }

    function fetchNearbyReviews() {
        const center = map.getCenter();
        const url = contextPath + '/search/nearby-reviews?lat=' + center.getLat() + '&lng=' + center.getLng() + '&level=' + map.getLevel() + '&page=1';

        $.getJSON(url, function(reviews) {
            displayNearbyReviews(reviews);
        }).fail(function() {
            displayNearbyReviews([]);
        });
    }

    function displayNearbyReviews(reviews) {
        const container = $('#ranking-review-content');
        container.empty();
        updateTabBadge('ranking-review', reviews.length);

        if (reviews.length === 0) {
            container.html('<p class="text-slate-400 text-center py-8">이 지역의 리뷰가 없습니다.</p>');
            return;
        }

        reviews.forEach(review => {
            const reviewUrl = contextPath + '/restaurant/detail/' + review.restaurantId + '#review-' + review.id;
            const profileImg = review.profileImage ? (contextPath + '/images/' + review.profileImage) : 'https://placehold.co/40x40/ccc/666?text=User';
            const ratingStars = '⭐'.repeat(review.rating);
            const truncatedContent = review.content.length > 80 ? review.content.substring(0, 80) + '...' : review.content;

            container.append(
                '<a href="' + reviewUrl + '" target="_blank" class="block p-3 border rounded-md hover:shadow-md transition">' +
                    '<div class="flex items-center gap-2 mb-2">' +
                        '<img src="' + profileImg + '" alt="' + review.author + '" class="w-8 h-8 rounded-full object-cover">' +
                        '<div class="flex-grow">' +
                            '<p class="font-bold text-sm">' + review.restaurantName + '</p>' +
                            '<p class="text-xs text-slate-500">' + review.author + ' · ' + ratingStars + '</p>' +
                        '</div>' +
                    '</div>' +
                    '<p class="text-sm text-slate-700">' + truncatedContent + '</p>' +
                '</a>'
            );
        });
    }

    function fetchNearbyCourses() {
        const center = map.getCenter();
        const url = contextPath + '/search/nearby-courses?lat=' + center.getLat() + '&lng=' + center.getLng() + '&level=' + map.getLevel() + '&page=1';

        $.getJSON(url, function(courses) {
            displayNearbyCourses(courses);
        }).fail(function() {
            displayNearbyCourses([]);
        });
    }

    function displayNearbyCourses(courses) {
        const container = $('#ranking-course-content');
        container.empty();
        updateTabBadge('ranking-course', courses.length);

        if (courses.length === 0) {
            container.html('<p class="text-slate-400 text-center py-8">이 지역의 코스가 없습니다.</p>');
            return;
        }

        courses.forEach(course => {
            const courseUrl = contextPath + '/course/detail?id=' + course.id;
            const thumbImg = course.previewImage ? (contextPath + '/images/' + course.previewImage) : 'https://placehold.co/80x80/e0f2fe/0891b2?text=Course';

            container.append(
                '<a href="' + courseUrl + '" target="_blank" class="block p-3 border rounded-md hover:shadow-md transition">' +
                    '<div class="flex gap-3">' +
                        '<img src="' + thumbImg + '" alt="' + course.title + '" class="w-20 h-20 rounded-md object-cover flex-shrink-0">' +
                        '<div class="flex-grow min-w-0">' +
                            '<p class="font-bold text-slate-800 truncate">' + course.title + '</p>' +
                            '<p class="text-xs text-slate-500 mt-1">by ' + course.author + '</p>' +
                            '<p class="text-xs text-slate-400 mt-1">👍 ' + course.likes + ' · 🍽️ ' + course.restaurantCount + '곳</p>' +
                        '</div>' +
                    '</div>' +
                '</a>'
            );
        });
    }

    function addCustomMarker(position, data) {
        const markerClass = data.type === 'db' ? 'marker-db' : 'marker-kakao';
        const markerIndex = data.type === 'db' ? '★' : data.index;

        const overlayEl = $(
            '<div class="marker-overlay ' + markerClass + '">' +
                '<div class="marker-overlay-number">' + markerIndex + '</div>' +
                '<div class="marker-overlay-info">' +
                    '<div class="marker-overlay-title" title="' + data.name + '">' + data.name + '</div>' +
                    '<div class="marker-overlay-category">' + data.category + '</div>' +
                '</div>' +
            '</div>'
        );

        overlayEl.on('click', () => window.open(data.url, '_blank'));

        const customOverlay = new kakao.maps.CustomOverlay({
            position: position,
            content: overlayEl[0],
            yAnchor: 1 
        });
        customOverlay.setMap(map);
        g.overlays.push(customOverlay);
        return customOverlay;
    }
    
    function clearSearchResults() {
        g.overlays.forEach(overlay => overlay.setMap(null));
        g.overlays = [];
        g.listItems = [];
    }

    function highlightMarker(targetOverlay, targetItemEl) {
        g.listItems.forEach(item => {
            item.el.removeClass('highlighted');
            $(item.overlay.getContent()).removeClass('highlight');
        });
        $(targetOverlay.getContent()).addClass('highlight');
        targetItemEl.addClass('highlighted');
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
        document.getElementById('course-description').value = '';
        document.getElementById('course-tags').value = '';
        document.getElementById('course-thumbnail').value = '';
    }

    function submitCourse() {
        const title = document.getElementById('course-title').value.trim();
        const description = document.getElementById('course-description').value.trim();
        if (!title) {
            alert('코스 제목을 입력해주세요.');
            return;
        }
        if (!description) {
            alert('설명을 입력해주세요.');
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
        formData.append('description', description);

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
