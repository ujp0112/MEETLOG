<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>약속 장소 확인 - MEET LOG</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">

<%-- ▼▼▼ [수정] search-map.jsp의 스타일시트 적용 ▼▼▼ --%>
<style>
* {
	font-family: 'Noto Sans KR', sans-serif;
	line-height: 1.7;
}

h1, h2, h3 {
	line-height: 1.4;
	letter-spacing: -0.02em;
}

p, span, li {
	word-break: keep-all;
	overflow-wrap: break-word;
}

#results-list {
	scrollbar-width: thin;
	scrollbar-color: #a0aec0 #edf2f7;
}

#results-list::-webkit-scrollbar {
	width: 6px;
}

#results-list::-webkit-scrollbar-track {
	background: #edf2f7;
}

#results-list::-webkit-scrollbar-thumb {
	background-color: #a0aec0;
	border-radius: 10px;
}

.result-item:hover {
	background-color: #f0f7ff;
}

.result-item.highlighted {
	background-color: #ebf8ff;
	border-left: 4px solid #3182ce;
	padding-left: calc(0.75rem - 4px);
}

.result-item-image {
	width: 72px;
	height: 72px;
	object-fit: cover;
	border-radius: 0.5rem;
	background-color: #e2e8f0;
}

.marker-overlay {
	display: flex;
	align-items: center;
	background-color: white;
	border: 1px solid #ccc;
	border-radius: 999px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
	padding: 6px;
	position: relative;
	transform: translate(-50%, -100%);
	transition: transform 0.1s ease-in-out, box-shadow 0.1s ease-in-out;
	cursor: pointer;
	z-index: 1;
}

.marker-overlay.highlight, .marker-overlay:hover {
	transform: translate(-50%, -100%) scale(1.1);
	z-index: 10;
	border-color: #3182ce;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
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
	filter: drop-shadow(0 1px 1px rgba(0, 0, 0, 0.15));
}

.marker-number {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 28px;
	height: 28px;
	border-radius: 50%;
	color: white;
	background-color: #3182ce;
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
	color: #2b6cb0;
}

.marker-category {
	font-size: 11px;
	color: #4a5568;
}
</style>
</head>
<body class="bg-gray-50">
	<div class="h-screen flex flex-col">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<main class="flex-grow flex flex-col md:flex-row overflow-hidden">
			<aside
				class="w-full md:w-1/3 lg:w-1/4 h-2/5 md:h-full flex flex-col border-r border-gray-200 bg-white">
				<div class="p-4 border-b">
					<h1 class="text-xl font-bold text-gray-800">
						"<span class="text-blue-600"><c:out value="${query}" /></span>"
					</h1>
					<p class="text-sm text-gray-500 mt-1">약속 장소 검색 결과입니다.</p>
				</div>
				<ul id="results-list" class="flex-grow overflow-y-auto p-2">
					<li id="no-result" class="text-center p-8 text-gray-500 hidden">검색
						결과가 없습니다.</li>
				</ul>
			</aside>
			<section class="w-full md:w-2/3 lg:w-3/4 h-3/5 md:h-full relative">
				<div id="map" style="width: 100%; height: 100%;"></div>
			</section>
		</main>
	</div>

	<script>
        $(document).ready(function() {
            const mapContainer = document.getElementById('map');
            const mapOption = {
                center: new kakao.maps.LatLng(37.566826, 126.97865),
                level: 3
            };
            const map = new kakao.maps.Map(mapContainer, mapOption);
            const ps = new kakao.maps.services.Places();
            const contextPath = "${pageContext.request.contextPath}";
            
            // 전역 상태를 관리할 객체
            let mapElements = []; // { el, overlay }

            const searchQuery = "<c:out value='${query}'/>";

            if (searchQuery) {
                ps.keywordSearch(searchQuery, placesSearchCB);
            } else {
                $('#no-result').removeClass('hidden');
            }

            function placesSearchCB(data, status, pagination) {
                if (status === kakao.maps.services.Status.OK) {
                    displayPlaces(data);

                    if (data.length > 0) {
                        const firstPlace = data[0];
                        const position = new kakao.maps.LatLng(firstPlace.y, firstPlace.x);
                        map.setCenter(position);
                        
                        // 첫 번째 장소 마커와 리스트 강조
                        setTimeout(() => {
                           if(mapElements[0]) {
                               highlightElements(mapElements[0].overlay, mapElements[0].el);
                           }
                        }, 100);
                    }
                } else {
                    $('#no-result').removeClass('hidden');
                }
            }

            function displayPlaces(places) {
                const listEl = $('#results-list');
                listEl.empty();
                mapElements = []; // 목록 초기화

                places.forEach((place, i) => {
                    const placePosition = new kakao.maps.LatLng(place.y, place.x);
                    
                    const { overlay, el: itemEl } = createListItemAndMarker(place, i, contextPath);

                    // 목록과 마커에 상호작용(hover) 이벤트 추가
                    itemEl.on('mouseover', () => highlightElements(overlay, itemEl));
                    $(overlay.getContent()).on('mouseover', () => highlightElements(overlay, itemEl));

                    itemEl.on('mouseout', () => clearAllHighlights());
                    $(overlay.getContent()).on('mouseout', () => clearAllHighlights());
                    
                    // 클릭 시 지도를 해당 위치로 이동
                    itemEl.on('click', () => map.panTo(placePosition));
                    $(overlay.getContent()).on('click', () => map.panTo(placePosition));
                    
                    listEl.append(itemEl);
                    mapElements.push({ el: itemEl, overlay: overlay });
                });
            }

            function createListItemAndMarker(place, i, contextPath) {
                const categoryName = place.category_name.split(' > ').pop();
                const uniqueId = "place-" + i;
                const placeholderUrl = "https://placehold.co/80x80/EBF8FF/3182CE?text=?";

                // 1. 지도에 표시될 커스텀 마커(오버레이) 생성
                const overlayEl = $(
                    '<div class="marker-overlay">' +
                        '<div class="marker-number">' + (i + 1) + '</div>' +
                        '<div class="marker-info">' +
                            '<div class="marker-title" title="' + place.place_name + '">' + place.place_name + '</div>' +
                            '<div class="marker-category">' + categoryName + '</div>' +
                        '</div>' +
                    '</div>'
                );
                
                const customOverlay = new kakao.maps.CustomOverlay({
                    position: new kakao.maps.LatLng(place.y, place.x),
                    content: overlayEl[0],
                    yAnchor: 1 
                });
                customOverlay.setMap(map);

                // 2. 왼쪽 목록에 표시될 리스트 아이템 생성
                const itemEl = $(
                    '<li class="result-item p-3 border-b border-gray-100 transition cursor-pointer">' +
                        '<div class="flex items-center space-x-4">' +
                            '<img id="img-' + uniqueId + '" src="' + placeholderUrl + '" alt="' + place.place_name + '" class="result-item-image flex-shrink-0">' +
                            '<div class="flex-grow">' +
                                '<h3 class="font-bold text-base text-blue-700">' + place.place_name + '</h3>' +
                                '<p class="text-gray-600 text-sm mt-1">' + (place.road_address_name || place.address_name) + '</p>' +
                                '<p class="text-blue-500 text-sm mt-1">' + (place.phone || '전화번호 정보 없음') + '</p>' +
                            '</div>' +
                        '</div>' +
                    '</li>'
                );

                // 3. 썸네일 이미지 비동기 로드 (search-map.jsp와 동일한 로직)
                const searchQuery = place.place_name + " " + (place.road_address_name || place.address_name).split(" ")[0];
                $.getJSON(contextPath + "/search/image-proxy?query=" + encodeURIComponent(searchQuery), function(data) {
                    if (data && data.imageUrl) {
                        $('#img-' + uniqueId).attr('src', data.imageUrl);
                    }
                });

                return { overlay: customOverlay, el: itemEl };
            }

            // 하이라이트 관련 함수
            function clearAllHighlights() {
                mapElements.forEach(item => {
                    item.el.removeClass('highlighted');
                    $(item.overlay.getContent()).removeClass('highlight');
                });
            }

            function highlightElements(overlay, el) {
                clearAllHighlights(); // 먼저 모든 하이라이트 제거
                el.addClass('highlighted');
                $(overlay.getContent()).addClass('highlight');
            }
        });
    </script>
</body>
</html>