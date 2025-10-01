<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>"<c:out value="${keyword}"/>" 검색 결과 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services"></script>
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        #results-list { scrollbar-width: thin; scrollbar-color: #a0aec0 #edf2f7; }
        #results-list::-webkit-scrollbar { width: 6px; }
        #results-list::-webkit-scrollbar-track { background: #edf2f7; }
        #results-list::-webkit-scrollbar-thumb { background-color: #a0aec0; border-radius: 10px; border: 3px solid #edf2f7; }
        .result-item:hover { background-color: #f0f7ff; }
        .result-item.highlighted { background-color: #ebf8ff; border-right: 4px solid #3182ce; }
 	   	.meetlog-badge {
            background: linear-gradient(135deg, #8b5cf6 0%, #d946ef 100%);
            color: white; font-size: 0.7rem; font-weight: bold;
            padding: 2px 8px; border-radius: 9999px; margin-left: 8px;
        }
        .result-item-image {
            width: 80px; height: 80px; object-fit: cover;
            border-radius: 0.5rem; background-color: #e2e8f0;
        }
        
        /* Custom Marker (Overlay) Styles */
        .marker-overlay {
            display: flex;
            align-items: center;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 999px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
            padding: 6px;
            position: relative;
            transform: translate(-50%, -100%);
            transition: transform 0.1s ease-in-out, box-shadow 0.1s ease-in-out;
            cursor: pointer;
            z-index: 1;
        }
        .marker-overlay.highlight, .marker-overlay:hover {
            transform: translate(-50%, -100%) scale(1.05);
            z-index: 10;
            border-color: #3182ce;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .marker-overlay::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 0;
            border-left: 8px solid transparent;
            border-right: 8px solid transparent;
            border-top: 8px solid white;
            filter: drop-shadow(0 1px 1px rgba(0,0,0,0.15));
        }
        .marker-number {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            color: white;
            font-weight: bold;
            font-size: 14px;
            flex-shrink: 0;
        }
        .marker-info {
            padding: 0 10px 0 8px;
            white-space: nowrap;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .marker-title {
            font-weight: bold;
            font-size: 14px;
            color: #2d3748;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .marker-category {
            font-size: 11px;
            color: #718096;
        }

        .marker-kakao .marker-number { background-color: #3182ce; }
        .marker-kakao .marker-title { color: #2b6cb0; }
        .marker-db .marker-number { background-color: #c53030; font-size: 18px; }
        .marker-db .marker-title { color: #c53030; }

        /* Re-search Button Style */
        #research-button {
            position: absolute;
            top: 15px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 5;
            background-color: white;
            border: 1px solid #dbdbdb;
            border-radius: 9999px;
            padding: 8px 16px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #3182ce;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease-in-out;
        }
        #research-button:hover {
            background-color: #f7fafc;
            border-color: #a0aec0;
        }
        #research-button.hidden {
            display: none;
        }
    </style>
</head>
<body class="bg-gray-50">
    <div id="app" class="h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <main class="flex-grow flex flex-col md:flex-row overflow-hidden">
            <div id="result-panel" class="w-full md:w-1/3 lg:w-1/4 h-1/3 md:h-full flex flex-col border-r border-gray-200 bg-white">
                <div class="p-4 border-b">
                    <h1 class="text-xl font-bold text-gray-800">
                        "<span class="text-blue-600"><c:out value="${keyword}"/></span>" 검색 결과
                    </h1>
                    <p id="result-count" class="text-sm text-gray-500 mt-1">지도를 검색하고 있습니다...</p>
                </div>
                <div id="results-list" class="flex-grow overflow-y-auto p-2"></div>
                <%-- 💡 '더 보기' 버튼 컨테이너 추가 --%>
                <div id="load-more-container" class="p-4 border-t text-center hidden">
                    <button id="load-more-btn" class="bg-blue-500 text-white font-bold py-2 px-6 rounded-full hover:bg-blue-600 transition duration-300 ease-in-out disabled:bg-gray-400 disabled:cursor-not-allowed">
                        더 보기
                    </button>
                </div>
            </div>
            <div id="map-panel" class="w-full md:w-2/3 lg:w-3/4 h-2/3 md:h-full relative">
                <div id="map" style="width:100%; height:100%;"></div>
                <button id="research-button" class="hidden">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M11.534 7h3.932a.25.25 0 0 1 .192.41l-1.966 2.36a.25.25 0 0 1-.384 0l-1.966-2.36a.25.25 0 0 1 .192-.41zm-11 2h3.932a.25.25 0 0 0 .192-.41L2.692 6.23a.25.25 0 0 0-.384 0L.342 8.59A.25.25 0 0 0 .534 9z"/>
                        <path fill-rule="evenodd" d="M8 3c-1.552 0-2.94.707-3.857 1.818a.5.5 0 1 1-.771-.636A6.002 6.002 0 0 1 13.917 7H12.5A5.002 5.002 0 0 0 8 3zM3.143 8.182a.5.5 0 1 1 .771.636A5.002 5.002 0 0 0 12.5 13H11A6.002 6.002 0 0 1 2.083 9H3.5a.5.5 0 0 1 0-1H.5a.5.5 0 0 1-.5-.5V4a.5.5 0 0 1 1 0v2.143a.5.5 0 0 1-.143.357z"/>
                    </svg>
                    <span>이 지역에서 다시 검색</span>
                </button>
            </div>
        </main>
    </div>
    <script>
    const g = { overlays: [], listItems: [] };
    let map, ps, kakaoPagination;
    let isLoading = false;
    let isDbSearchEnd = false;
    let isKakaoSearchEnd = false;
    let currentPage = 1;
    let displayedDbIds = []; // 💡 이미 표시된 DB 맛집 ID를 저장할 배열

    $(document).ready(function() {
        const keyword = "<c:out value='${keyword}'/>";
        const contextPath = "${pageContext.request.contextPath}";
        const category = "<c:out value='${category}' default='전체'/>"; 
        
        if (!keyword && category === '전체') { 
            $('#result-count').text('검색어가 없습니다.'); 
            return; 
        }

        const mapContainer = document.getElementById('map');
        const mapOption = { center: new kakao.maps.LatLng(37.566826, 126.97865), level: 8 };
        map = new kakao.maps.Map(mapContainer, mapOption);
        ps = new kakao.maps.services.Places();
        
        let initialSearchKeyword = keyword;
        if ((category === '전체' || category === '') && keyword) {
            initialSearchKeyword = keyword + " 맛집";
        } else if (!keyword && category !== '전체' && category !== '') {
            initialSearchKeyword = category;
        }
        
        $('#result-panel h1').html('"<span class="text-blue-600">' + (keyword || category) + '</span>" 검색 결과');

        let searchOptions = {
            size: 10,
            category_group_code: 'FD6'
        };
        
        ps.keywordSearch(initialSearchKeyword, (data, status, pagination) => {
            if (status === kakao.maps.services.Status.ZERO_RESULT && initialSearchKeyword !== keyword) {
                 ps.keywordSearch(keyword, (retryData, retryStatus, retryPagination) => {
                    placesSearchCB(retryData, retryStatus, retryPagination, contextPath);
                }, searchOptions);
            } else {
                placesSearchCB(data, status, pagination, contextPath);
            }
        }, searchOptions);

        kakao.maps.event.addListener(map, 'dragend', function() {
            $('#research-button').removeClass('hidden');
        });

        $('#research-button').on('click', function() {
            $(this).addClass('hidden');
            $('#results-list').empty().scrollTop(0);
            $('#load-more-container').addClass('hidden'); // 💡 더 보기 버튼 숨기기
            g.overlays.forEach(overlay => overlay.setMap(null));
            g.overlays = [];
            g.listItems = [];
            currentPage = 1;
            isDbSearchEnd = false;
            isKakaoSearchEnd = false;
            displayedDbIds = []; // 💡 재검색 시, ID 목록 초기화

            let researchKeyword = category;
            if (category === '전체' || category === '') {
                researchKeyword = '음식점';
            }

            $('#result-panel h1').html('현재 지도에서 <span class="text-blue-600">"' + researchKeyword + '"</span> 검색 결과');
            
            const researchOptions = {
                size: 10,
                category_group_code: 'FD6',
                location: map.getCenter()
            };

            ps.keywordSearch(researchKeyword, (data, status, pagination) => {
                kakaoPagination = pagination;
                isKakaoSearchEnd = !pagination.hasNextPage;
                fetchDbAndDisplayCombined(1, data || [], contextPath, true);
            }, researchOptions);
        });

        // 💡 '더 보기' 버튼 클릭 이벤트 리스너 추가
        $('#load-more-btn').on('click', function() {
            const hasMoreData = !isDbSearchEnd || !isKakaoSearchEnd;
            if (!isLoading && hasMoreData) {
                isLoading = true;
                $(this).text('불러오는 중...').prop('disabled', true);
                currentPage++;
                
                if (!isKakaoSearchEnd) {
                    kakaoPagination.nextPage(); // placesSearchCB가 자동으로 호출됨
                } else {
                    // 카카오 검색은 끝났지만 DB 검색이 남은 경우
                    fetchDbAndDisplayCombined(currentPage, [], contextPath);
                }
            }
        });
    });

    function placesSearchCB(data, status, pagination, contextPath) {
        kakaoPagination = pagination;
        isKakaoSearchEnd = !pagination.hasNextPage;

        if (currentPage === 1) {
            $('#results-list').empty();
            g.overlays.forEach(overlay => overlay.setMap(null));
            g.listItems.forEach(item => item.el.remove());
            g.overlays = []; g.listItems = [];
            displayedDbIds = []; // 💡 초기 검색 시, ID 목록 초기화
            $('#load-more-container').addClass('hidden'); // 💡 초기 검색 시 버튼 숨기기

            if (status === kakao.maps.services.Status.OK && data.length > 0) {
                const firstPlace = data[0];
                const moveLatLon = new kakao.maps.LatLng(firstPlace.y, firstPlace.x);
                map.setCenter(moveLatLon);
                fetchDbAndDisplayCombined(currentPage, data, contextPath);
            } else {
                fetchDbAndDisplayCombined(currentPage, [], contextPath);
            }
        } else {
            // '더 보기'로 다음 페이지 데이터가 왔을 때
            fetchDbAndDisplayCombined(currentPage, data || [], contextPath);
        }
    }
    
    // 💡 무한 스크롤 리스너 제거
    // $('#results-list').on('scroll', function() { ... });

    function fetchDbAndDisplayCombined(page, kakaoDataForPage, contextPath, isResearch = false) {
        const center = map.getCenter();
        const level = map.getLevel();
        const category = "<c:out value='${category}' default='전체'/>";
        // 💡 제외할 ID 목록을 쿼리 파라미터로 추가
        let url = contextPath + "/search/db-restaurants?lat=" + center.getLat() + "&lng=" + center.getLng() + "&level=" + level + "&category=" + category + "&page=" + page;
        if (displayedDbIds.length > 0) {
            url += "&excludeIds=" + displayedDbIds.join(',');
        }
        
        let dbRestaurants = [];
        
        $.getJSON(url, function(data) {
            dbRestaurants = data;
            if (!dbRestaurants || dbRestaurants.length === 0) isDbSearchEnd = true;
            if (dbRestaurants && dbRestaurants.length > 0) displayDbPlaces(dbRestaurants, contextPath);

            // 💡 새로 받은 DB 맛집 ID를 목록에 추가
            if (dbRestaurants) {
                dbRestaurants.forEach(r => displayedDbIds.push(r.id));
            }

            const dbCount = dbRestaurants ? dbRestaurants.length : 0;
            const kakaoCountToShow = Math.min(10, 15 - dbCount);
            
            if (kakaoDataForPage.length > 0 && kakaoCountToShow > 0) {
                displayPlaces(kakaoDataForPage.slice(0, kakaoCountToShow), contextPath);
            }

        }).fail(function() {
            isDbSearchEnd = true;
            displayPlaces(kakaoDataForPage, contextPath);
        }).always(function() {
            isLoading = false;
            updateResultCount();
            
            // 💡 버튼 상태 업데이트 로직 추가
            $('#load-more-btn').text('더 보기').prop('disabled', false);
            const hasMoreData = !isDbSearchEnd || !isKakaoSearchEnd;
            if (hasMoreData) {
                $('#load-more-container').removeClass('hidden');
            } else {
                $('#load-more-container').addClass('hidden');
            }
            
            if (page === 1 && !isResearch && ( (kakaoDataForPage && kakaoDataForPage.length > 0) || (dbRestaurants && dbRestaurants.length > 0))) {
                 const bounds = new kakao.maps.LatLngBounds();
                 if(kakaoDataForPage) kakaoDataForPage.forEach(p => bounds.extend(new kakao.maps.LatLng(p.y, p.x)));
                 if(dbRestaurants) dbRestaurants.forEach(r => bounds.extend(new kakao.maps.LatLng(r.latitude, r.longitude)));
                 map.setBounds(bounds);
            }
        });
    }

    // 💡 마커 하이라이트 함수 추가
    function highlightMarker(targetOverlay, targetItemEl) {
        // 모든 기존 하이라이트 제거
        g.listItems.forEach(item => {
            item.el.removeClass('highlighted');
            if (item.overlay && item.overlay.getContent()) {
                $(item.overlay.getContent()).removeClass('highlight');
            }
        });

        // 새로운 대상만 하이라이트
        $(targetOverlay.getContent()).addClass('highlight');
        targetItemEl.addClass('highlighted');
    }
console.log("무라사키");
    function displayPlaces(places, contextPath) {
        const listEl = $('#results-list');
        places.forEach((place, i) => {
            const placePosition = new kakao.maps.LatLng(place.y, place.x);
            const detailUrl = contextPath + "/searchRestaurant/external-detail?name=" + encodeURIComponent(place.place_name) + "&address=" + encodeURIComponent(place.address_name) + "&phone=" + encodeURIComponent(place.phone) + "&category=" + encodeURIComponent(place.category_name) + "&lat=" + place.y + "&lng=" + place.x;
            const categoryName = place.category_name.split(' > ').pop();
            const uniqueId = "kakao-" + currentPage + "-" + i;

            const markerIndex = g.listItems.length + 1;
            
            const overlayEl = $(
                '<div class="marker-overlay marker-kakao">' +
                    '<div class="marker-number">' + markerIndex + '</div>' +
                    '<div class="marker-info">' +
                        '<div class="marker-title" title="' + place.place_name + '">' + place.place_name + '</div>' +
                        '<div class="marker-category">' + categoryName + '</div>' +
                    '</div>' +
                '</div>'
            );

            overlayEl.on('click', () => window.location.href = detailUrl);
            
            const customOverlay = new kakao.maps.CustomOverlay({
                position: placePosition,
                content: overlayEl[0],
                yAnchor: 1 
            });
            customOverlay.setMap(map);
            g.overlays.push(customOverlay);
            
            const placeholderUrl = "https://placehold.co/100x100/EBF8FF/3182CE?text=" + encodeURIComponent(categoryName);
            const errorImageUrl = "https://placehold.co/100x100/fecaca/991b1b?text=Error";

            // 💡 클릭 영역 분리를 위해 <a> 태그 제거 및 구조 변경
            const itemEl = $(
                '<div class="result-item p-3 border-b border-gray-100 transition flex items-center space-x-4" data-id="' + uniqueId + '">' +
                    '<a href="' + detailUrl + '">' +
                        '<img id="img-' + uniqueId + '" src="' + placeholderUrl + '" alt="' + place.place_name + '" class="result-item-image flex-shrink-0" onerror="this.onerror=null;this.src=\'' + errorImageUrl + '\';">' +
                    '</a>' +
                    '<div class="flex-grow">' +
                        '<h3 class="font-bold text-base text-blue-700">' +
                            '<a href="' + detailUrl + '" class="inline-block">' + place.place_name + '</a>' +
                        '</h3>' +
                        '<p class="text-gray-600 text-sm mt-1">' + (place.road_address_name || place.address_name) + '</p>' +
                        '<p class="text-gray-500 text-sm mt-1">' + categoryName + '</p>' +
                        '<p class="text-blue-500 text-sm mt-1">' + (place.phone || '전화번호 정보 없음') + '</p>' +
                    '</div>' +
                '</div>'
            );
            listEl.append(itemEl);
            g.listItems.push({id: uniqueId, el: itemEl, overlay: customOverlay, position: placePosition});

            // 💡 클릭 이벤트로 하이라이트 기능 변경
            itemEl.on('click', function(e) {
                if (e.target.tagName !== 'A' && e.target.tagName !== 'IMG' && e.target.tagName !== 'H3') {
                    map.panTo(placePosition);
                    highlightMarker(customOverlay, itemEl);
                }
            });

            setTimeout(function() {
                const searchQuery = place.place_name + " " + (place.road_address_name || place.address_name).split(" ")[0];
                $.getJSON(contextPath + "/search/image-proxy?query=" + encodeURIComponent(searchQuery), function(data) {
                    // This is the critical part.
                    // Ensure you are using data.imageUrl to access the URL string.
                    if (data && data.imageUrl) {
                        $('#img-' + uniqueId).attr('src', data.imageUrl);
                    }
                });
            }, i * 100); 

            // 💡 mouseover/mouseout 이벤트 제거
        });
    }

    function displayDbPlaces(dbRestaurants, contextPath) {
        const listEl = $('#results-list');
        dbRestaurants.forEach((r, i) => {
            const placePosition = new kakao.maps.LatLng(r.latitude, r.longitude);
            const detailUrl = contextPath + "/restaurant/detail/" + r.id;
            const categoryName = r.category || '';
            const uniqueId = "db-" + currentPage + "-" + i;

            const overlayEl = $(
                '<div class="marker-overlay marker-db">' +
                    '<div class="marker-number">★</div>' +
                    '<div class="marker-info">' +
                        '<div class="marker-title" title="' + r.name + '">' + r.name + '</div>' +
                        '<div class="marker-category">' + categoryName + '</div>' +
                    '</div>' +
                '</div>'
            );
            
            overlayEl.on('click', () => window.location.href = detailUrl);
            
            const customOverlay = new kakao.maps.CustomOverlay({
                position: placePosition,
                content: overlayEl[0],
                yAnchor: 1 
            });
            customOverlay.setMap(map);
            g.overlays.push(customOverlay);

            let imageUrl = '';
            if (r.image && r.image.trim() !== '') {
                imageUrl = r.image.startsWith('http') ? r.image : contextPath + '/images/' + r.image;
            } else {
                imageUrl = "https://placehold.co/100x100/fee2e2/b91c1c?text=" + encodeURIComponent(categoryName);
            }
            const errorImageUrl = "https://placehold.co/100x100/fecaca/991b1b?text=Error";
            
            // 💡 클릭 영역 분리를 위해 <a> 태그 제거 및 구조 변경
            const itemEl = $(
                '<div class="result-item p-3 border-b border-gray-100 transition flex items-center space-x-4" data-id="' + uniqueId + '">' +
                    '<a href="' + detailUrl + '">' +
                        '<img src="' + imageUrl + '" alt="' + r.name + '" class="result-item-image flex-shrink-0" onerror="this.onerror=null;this.src=\'' + errorImageUrl + '\';">' +
                    '</a>' +
                    '<div class="flex-grow">' +
                        '<h3 class="font-bold text-base text-red-700">' +
                            '<a href="' + detailUrl + '" class="inline-block">' + r.name + '</a>' + '<span class="meetlog-badge">MEET LOG</span>' +
                        '</h3>' +
                        '<p class="text-gray-600 text-sm mt-1">' + r.address + '</p>' +
                        '<p class="text-gray-500 text-sm mt-1">' + categoryName + '</p>' +
                        '<p class="text-red-500 text-sm mt-1">' + (r.phone || '전화번호 정보 없음') + '</p>' +
                    '</div>' +
                '</div>'
            );
            listEl.prepend(itemEl);
            g.listItems.unshift({id: uniqueId, el: itemEl, overlay: customOverlay, position: placePosition});
            
            // 💡 클릭 이벤트로 하이라이트 기능 변경
            itemEl.on('click', function(e) {
                if (e.target.tagName !== 'A' && e.target.tagName !== 'IMG' && e.target.tagName !== 'H3' && e.target.tagName !== 'SPAN') {
                    map.panTo(placePosition);
                    highlightMarker(customOverlay, itemEl);
                }
            });
            // 💡 mouseover/mouseout 이벤트 제거
        });
    }
    
    function updateResultCount() {
        const currentCount = $('#results-list .result-item').length;
        $('#result-count').text("현재 " + currentCount + "개 결과 표시 중");
    }
    </script>
</body>
</html>
