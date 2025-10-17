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
<style>
* {
	font-family: 'Noto Sans KR', sans-serif;
}
/* ▼▼▼ [추가] search-map.jsp의 커스텀 마커 스타일 ▼▼▼ */
.marker-overlay {
	display: flex;
	align-items: center;
	background-color: white;
	border: 1px solid #ccc;
	border-radius: 999px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
	padding: 6px 10px;
	position: relative;
	transform: translate(-50%, -100%);
	transition: transform 0.1s ease-in-out, box-shadow 0.1s ease-in-out;
	cursor: pointer;
	z-index: 1;
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

.marker-title {
	font-weight: bold;
	font-size: 14px;
	color: #2d3748;
	white-space: nowrap;
}

.marker-start .marker-title {
	color: #2b6cb0; /* 출발지 텍스트 색상 (파란색) */
}

.marker-end .marker-title {
	color: #c53030; /* 도착지 텍스트 색상 (빨간색) */
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
					<h1 class="text-xl font-bold text-gray-800">경로 안내</h1>
					<p class="text-sm text-gray-500 mt-1">
						도착지: <span class="font-semibold text-blue-600"><c:out
								value="${query}" /></span>
					</p>
				</div>
				<div class="p-4">
					<form id="route-form" onsubmit="return false;">
						<label for="start-point"
							class="block text-sm font-medium text-gray-700">출발지</label>
						<div class="mt-1 flex rounded-md shadow-sm">
							<input type="text" name="start-point" id="start-point"
								class="focus:ring-blue-500 focus:border-blue-500 block w-full rounded-none rounded-l-md sm:text-sm border-gray-300 p-2 border"
								placeholder="예: 서울역">
							<button type="submit"
								class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 hover:bg-gray-100">
								검색</button>
						</div>
						<p class="text-xs text-gray-500 mt-1">'현재 위치'로 설정하려면 비워두세요.</p>
					</form>
				</div>

				<div id="route-info"
					class="p-4 border-t border-gray-200 text-center text-gray-500 flex-grow">
					경로 정보를 불러오는 중입니다...</div>
				<div class="p-4">
					<button id="show-route-on-kakao-map"
						class="w-full bg-yellow-400 text-black font-bold py-2 px-4 rounded hover:bg-yellow-500">
						카카오맵에서 대중교통 길찾기</button>
				</div>

			</aside>
			<section class="w-full md:w-2/3 lg:w-3/4 h-3/5 md:h-full relative">
				<div id="map" style="width: 100%; height: 100%;"></div>
			</section>
		</main>
	</div>

	<script>
$(document).ready(function() {
    // --- 기본 설정 및 전역 변수 ---
    const mapContainer = document.getElementById('map');
    const mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.97865),
        level: 5
    };
    const map = new kakao.maps.Map(mapContainer, mapOption);
    const ps = new kakao.maps.services.Places();

    let startMarker = null, endMarker = null, routeLine = null;
    let startCoords = null, endCoords = null;
    const destinationQuery = "<c:out value='${query}'/>";

    // --- 페이지 시작 로직 ---
    if (destinationQuery) {
        ps.keywordSearch(destinationQuery, (data, status) => {
            if (status === kakao.maps.services.Status.OK) {
                const place = data[0];
                endCoords = new kakao.maps.LatLng(place.y, place.x);
                $('#start-point').val('현재 위치');
                getCurrentLocationAndFindRoute();
            } else {
                $('#route-info').html('도착지 정보를 찾을 수 없습니다.');
            }
        });
    } else {
        $('#route-info').html('도착지 정보가 없습니다.');
    }

    // --- 이벤트 핸들러 ---
    $('#route-form').on('submit', function(e) {
        e.preventDefault();
        const startQuery = $('#start-point').val();
        if (!startQuery || startQuery === '현재 위치') {
            getCurrentLocationAndFindRoute();
            return;
        }
        ps.keywordSearch(startQuery, (data, status) => {
            if (status === kakao.maps.services.Status.OK) {
                const place = data[0];
                startCoords = new kakao.maps.LatLng(place.y, place.x);
                findAndDrawRoute(startCoords, endCoords);
            } else {
                $('#route-info').html(`'${startQuery}'에 대한 검색 결과가 없습니다.`);
            }
        });
    });

    $('#show-route-on-kakao-map').on('click', function() {
        // 목적지 정보가 있는지 확인
        if (!endCoords) {
            alert("도착지 정보가 없습니다.");
            return;
        }

        const endName = destinationQuery;
        const encodedEndName = encodeURIComponent(endName);

        // 목적지만 지정하는 'link/to' URL 형식 사용 (WGS84 좌표계 사용)
        const url = "https://map.kakao.com/link/to/" + encodedEndName + "," + endCoords.getLat() + "," + endCoords.getLng();

        window.open(url, '_blank');
    });
    // --- 핵심 기능 함수 ---
    function getCurrentLocationAndFindRoute() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(position => {
                startCoords = new kakao.maps.LatLng(position.coords.latitude, position.coords.longitude);
                findAndDrawRoute(startCoords, endCoords);
            }, () => {
                 $('#route-info').html('현재 위치를 가져올 수 없습니다. 출발지를 직접 입력해주세요.');
            });
        } else {
            $('#route-info').html('Geolocation을 지원하지 않는 브라우저입니다.');
        }
    }
    
    function findAndDrawRoute(start, end) {
        if (!start || !end) {
            $('#route-info').html('출발지 또는 도착지 좌표 정보가 올바르지 않습니다.');
            return;
        }
        
        clearMap();

        // ▼▼▼ [수정] 기본 마커를 커스텀 오버레이로 변경 ▼▼▼
        // 출발지 마커
        startMarker = new kakao.maps.CustomOverlay({
            position: start,
            content: '<div class="marker-overlay marker-start"><div class="marker-title">출발지</div></div>',
            yAnchor: 1
        });

        // 도착지 마커
        endMarker = new kakao.maps.CustomOverlay({
            position: end,
            content: '<div class="marker-overlay marker-end"><div class="marker-title">도착지</div></div>',
            yAnchor: 1
        });
        
        startMarker.setMap(map);
        endMarker.setMap(map);
        const bounds = new kakao.maps.LatLngBounds();
        bounds.extend(start);
        bounds.extend(end);
        map.setBounds(bounds);

        const origin = start.getLng() + "," + start.getLat();
        const destination = end.getLng() + "," + end.getLat();

        $.ajax({
            type: "POST",
            url: "/MeetLog/route/find",
            data: { origin: origin, destination: destination },
            dataType: "json",
            success: function(data) {
                if (data.routes && data.routes.length > 0) {
                    const route = data.routes[0];
                    const summary = route.summary;
                    const duration = Math.round(summary.duration / 60);
                    const distance = (summary.distance / 1000).toFixed(1);
                    routeLine = new kakao.maps.Polyline({
                        path: route.sections[0].roads.flatMap(road => 
                            road.vertexes.reduce((acc, _, i, arr) => {
                                if (i % 2 === 0) acc.push(new kakao.maps.LatLng(arr[i + 1], arr[i]));
                                return acc;
                            }, [])
                        ),
                        strokeWeight: 5, strokeColor: '#1E90FF', strokeOpacity: 0.8, strokeStyle: 'solid'
                    });
                    routeLine.setMap(map);
                    $('#route-info').html(
                    	    `<div class='text-left p-2 text-blue-600 font-semibold'>
                    	        <p>경로가 표시되었습니다.</p>
                    	    </div>`
                    	);
                } else {
                    $('#route-info').html('경로를 찾을 수 없습니다.<br>(오류: ' + (data.error_message || data.msg || '알 수 없는 오류') + ')');
                }
            },
            error: function() {
                $('#route-info').html('서버와 통신 중 오류가 발생했습니다.');
            }
        });
    }

    function clearMap() {
        if (startMarker) startMarker.setMap(null);
        if (endMarker) endMarker.setMap(null);
        if (routeLine) routeLine.setMap(null);
    }
});
</script>
</body>
</html>