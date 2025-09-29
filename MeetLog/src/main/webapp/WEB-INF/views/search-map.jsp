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
            border-radius: 999px; /* Rounded pill shape */
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
            padding: 6px;
            position: relative;
            transform: translate(-50%, -100%); /* Center above the point */
            transition: transform 0.1s ease-in-out, box-shadow 0.1s ease-in-out;
            cursor: pointer;
            z-index: 1; /* 💡 Make sure overlay is above map tiles */
        }
        .marker-overlay.highlight, .marker-overlay:hover {
            transform: translate(-50%, -100%) scale(1.05); /* Slightly enlarge on hover */
            z-index: 10;
            border-color: #3182ce;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .marker-overlay::after { /* The pointer */
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

        /* Kakao (Blue) Style */
        .marker-kakao .marker-number {
            background-color: #3182ce; /* blue-600 */
        }
        .marker-kakao .marker-title {
             color: #2b6cb0; /* blue-700 */
        }

        /* DB (Red/MEETLOG) Style */
        .marker-db .marker-number {
            background-color: #c53030; /* red-700 */
            font-size: 18px;
        }
        .marker-db .marker-title {
            color: #c53030;
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
            </div>
            <div id="map-panel" class="w-full md:w-2/3 lg:w-3/4 h-2/3 md:h-full">
                <div id="map" style="width:100%; height:100%;"></div>
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

    $(document).ready(function() {
        const keyword = "<c:out value='${keyword}'/>";
        const contextPath = "${pageContext.request.contextPath}";
        const category = "<c:out value='${category}'/>"; 
        
        if (!keyword) { $('#result-count').text('검색어가 없습니다.'); return; }

        const mapContainer = document.getElementById('map');
        const mapOption = { center: new kakao.maps.LatLng(37.566826, 126.97865), level: 8 };
        map = new kakao.maps.Map(mapContainer, mapOption);
        ps = new kakao.maps.services.Places();
        
        let finalKeyword = keyword;
        let searchOptions = {
            size: 10,
            category_group_code: 'FD6'
        };
        
        if (category === '전체') {
            finalKeyword = keyword + " 맛집";
        }
        
        ps.keywordSearch(finalKeyword, (data, status, pagination) => {
            if (status === kakao.maps.services.Status.ZERO_RESULT && finalKeyword !== keyword) {
                 ps.keywordSearch(keyword, (retryData, retryStatus, retryPagination) => {
                    placesSearchCB(retryData, retryStatus, retryPagination, contextPath);
                }, searchOptions);
            } else {
                placesSearchCB(data, status, pagination, contextPath);
            }
        }, searchOptions);
    });

    function placesSearchCB(data, status, pagination, contextPath) {
        kakaoPagination = pagination;
        isKakaoSearchEnd = !pagination.hasNextPage;

        if (currentPage === 1) {
            $('#results-list').empty();
            g.overlays.forEach(overlay => overlay.setMap(null));
            g.listItems.forEach(item => item.el.remove());
            g.overlays = []; g.listItems = [];

            if (status === kakao.maps.services.Status.OK && data.length > 0) {
                const firstPlace = data[0];
                const moveLatLon = new kakao.maps.LatLng(firstPlace.y, firstPlace.x);
                map.setCenter(moveLatLon);
                fetchDbAndDisplayCombined(currentPage, data, contextPath);
            } else {
                fetchDbAndDisplayCombined(currentPage, [], contextPath);
            }
        } else {
            fetchDbAndDisplayCombined(currentPage, data || [], contextPath);
        }
    }
    
    $('#results-list').on('scroll', function() {
        const isScrollAtBottom = $(this).scrollTop() + $(this).innerHeight() >= this.scrollHeight - 100;
        const hasMoreData = !isDbSearchEnd || !isKakaoSearchEnd;

        if (isScrollAtBottom && !isLoading && hasMoreData) {
            isLoading = true;
            currentPage++;
            $('#results-list').append('<div id="loading-spinner" class="text-center p-4">결과를 더 불러오는 중...</div>');
            
            if (!isKakaoSearchEnd) {
                kakaoPagination.nextPage(); 
            } else {
                fetchDbAndDisplayCombined(currentPage, [], "${pageContext.request.contextPath}");
            }
        }
    });

    function fetchDbAndDisplayCombined(page, kakaoDataForPage, contextPath) {
        const center = map.getCenter();
        const level = map.getLevel();
        const category = "<c:out value='${category}'/>";
        const url = contextPath + "/search/db-restaurants?lat=" + center.getLat() + "&lng=" + center.getLng() + "&level=" + level + "&category=" + category + "&page=" + page;
        
        let dbRestaurants = [];
        
        $.getJSON(url, function(data) {
            dbRestaurants = data;
            if (!dbRestaurants || dbRestaurants.length === 0) isDbSearchEnd = true;
            if (dbRestaurants && dbRestaurants.length > 0) displayDbPlaces(dbRestaurants, contextPath);
            
            const dbCount = dbRestaurants ? dbRestaurants.length : 0;
            const kakaoCountToShow = Math.min(10, 15 - dbCount);
            
            if (kakaoDataForPage.length > 0 && kakaoCountToShow > 0) {
                displayPlaces(kakaoDataForPage.slice(0, kakaoCountToShow), contextPath);
            }

        }).fail(function() {
            isDbSearchEnd = true;
            displayPlaces(kakaoDataForPage, contextPath);
        }).always(function() {
            $('#loading-spinner').remove();
            isLoading = false;
            updateResultCount();
            
            if (page === 1 && ( (kakaoDataForPage && kakaoDataForPage.length > 0) || (dbRestaurants && dbRestaurants.length > 0))) {
                 const bounds = new kakao.maps.LatLngBounds();
                 if(kakaoDataForPage) kakaoDataForPage.forEach(p => bounds.extend(new kakao.maps.LatLng(p.y, p.x)));
                 if(dbRestaurants) dbRestaurants.forEach(r => bounds.extend(new kakao.maps.LatLng(r.latitude, r.longitude)));
                 map.setBounds(bounds);
            }
        });
    }

    function displayPlaces(places, contextPath) {
        const listEl = $('#results-list');
        places.forEach((place, i) => {
            const placePosition = new kakao.maps.LatLng(place.y, place.x);
            const detailUrl = contextPath + "/searchRestaurant/external-detail?name=" + encodeURIComponent(place.place_name) + "&address=" + encodeURIComponent(place.address_name) + "&phone=" + encodeURIComponent(place.phone) + "&category=" + encodeURIComponent(place.category_name) + "&lat=" + place.y + "&lng=" + place.x;
            const categoryName = place.category_name.split(' > ').pop();
            const uniqueId = "kakao-" + currentPage + "-" + i;

            const markerIndex = g.listItems.filter(item => item.id.startsWith('kakao-')).length + g.listItems.filter(item => item.id.startsWith('db-')).length + 1;
            
            // 💡 1. Changed to string concatenation format
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

            const itemEl = $(
                '<div class="result-item cursor-pointer p-3 border-b border-gray-100 transition" data-id="' + uniqueId + '">' +
                    '<a href="' + detailUrl + '" class="flex items-center space-x-4">' +
                        '<img id="img-' + uniqueId + '" src="' + placeholderUrl + '" alt="' + place.place_name + '" class="result-item-image flex-shrink-0" onerror="this.onerror=null;this.src=\'' + errorImageUrl + '\';">' +
                        '<div class="flex-grow">' +
                            '<h3 class="font-bold text-base text-blue-700">' + place.place_name + '</h3>' +
                            '<p class="text-gray-600 text-sm mt-1">' + (place.road_address_name || place.address_name) + '</p>' +
                            '<p class="text-gray-500 text-sm mt-1">' + categoryName + '</p>' +
                            '<p class="text-blue-500 text-sm mt-1">' + (place.phone || '전화번호 정보 없음') + '</p>' +
                        '</div>' +
                    '</a>' +
                '</div>'
            );
            listEl.append(itemEl);
            g.listItems.push({id: uniqueId, el: itemEl, overlay: customOverlay, position: placePosition});

            setTimeout(function() {
                const searchQuery = place.place_name + " " + place.address_name.split(" ")[0];
                $.getJSON(contextPath + "/search/image-proxy?query=" + encodeURIComponent(searchQuery), function(imageUrl) {
                    if (imageUrl) $('#img-' + uniqueId).attr('src', imageUrl);
                });
            }, i * 100);

            itemEl.on('mouseover', () => {
                map.panTo(placePosition);
                overlayEl.addClass('highlight');
            }).on('mouseout', () => {
                overlayEl.removeClass('highlight');
            });
        });
    }

    function displayDbPlaces(dbRestaurants, contextPath) {
        const listEl = $('#results-list');
        dbRestaurants.forEach((r, i) => {
            const placePosition = new kakao.maps.LatLng(r.latitude, r.longitude);
            const detailUrl = contextPath + "/restaurant/detail/" + r.id;
            const categoryName = r.category || '';
            const uniqueId = "db-" + currentPage + "-" + i;

            // 💡 1. Changed to string concatenation format
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
            
            const itemEl = $(
                '<div class="result-item cursor-pointer p-3 border-b border-gray-100 transition" data-id="' + uniqueId + '">' +
                    '<a href="' + detailUrl + '" class="flex items-center space-x-4">' +
                        '<img src="' + imageUrl + '" alt="' + r.name + '" class="result-item-image flex-shrink-0" onerror="this.onerror=null;this.src=\'' + errorImageUrl + '\';">' +
                        '<div class="flex-grow">' +
                            '<h3 class="font-bold text-base text-red-700">' + r.name + '<span class="meetlog-badge">MEET LOG</span></h3>' +
                            '<p class="text-gray-600 text-sm mt-1">' + r.address + '</p>' +
                            '<p class="text-gray-500 text-sm mt-1">' + categoryName + '</p>' +
                            '<p class="text-red-500 text-sm mt-1">' + (r.phone || '전화번호 정보 없음') + '</p>' +
                        '</div>' +
                    '</a>' +
                '</div>'
            );
            listEl.prepend(itemEl);
            g.listItems.unshift({id: uniqueId, el: itemEl, overlay: customOverlay, position: placePosition});
            
            itemEl.on('mouseover', () => {
                map.panTo(placePosition);
                overlayEl.addClass('highlight');
            }).on('mouseout', () => {
                overlayEl.removeClass('highlight');
            });
        });
    }
    
    function updateResultCount() {
        const currentCount = $('#results-list .result-item').length;
        $('#result-count').text("현재 " + currentCount + "개 결과 표시 중");
    }
    </script>
</body>
</html>

