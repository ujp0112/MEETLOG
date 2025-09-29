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
                <div id="results-list" class="flex-grow overflow-y-auto p-2">
                </div>
            </div>

            <div id="map-panel" class="w-full md:w-2/3 lg:w-3/4 h-2/3 md:h-full">
                <div id="map" style="width:100%; height:100%;"></div>
            </div>
        </main>
    </div>

    <script type="text/javascript">
    // <![CDATA[
    
    const g = { markers: [], infowindows: [], listItems: [] };
    let map, ps;

    $(document).ready(function() {
        const keyword = "${fn:replace(keyword, '\'', '\\\'')}";
        const contextPath = "${pageContext.request.contextPath}";

        if (!keyword) {
            $('#result-count').text('검색어가 없습니다.');
            return;
        }

        const mapContainer = document.getElementById('map');
        const mapOption = {
            center: new kakao.maps.LatLng(37.566826, 126.97865),
            level: 8
        };
        map = new kakao.maps.Map(mapContainer, mapOption);
        ps = new kakao.maps.services.Places();
        ps.keywordSearch(keyword, (data, status) => placesSearchCB(data, status, contextPath));
    });

    function placesSearchCB(data, status, contextPath) {
        if (status === kakao.maps.services.Status.OK) {
            displayPlaces(data, contextPath);
            $('#result-count').text("총 " + data.length + "개의 결과를 찾았습니다.");
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            $('#result-count').text('검색 결과가 없습니다.');
        } else {
            $('#result-count').text('검색 중 오류가 발생했습니다.');
        }
    }

    function displayPlaces(places, contextPath) {
        const listEl = $('#results-list');
        const bounds = new kakao.maps.LatLngBounds();

        g.markers.forEach(marker => marker.setMap(null));
        g.listItems.forEach(item => item.remove());
        g.markers = []; g.listItems = []; g.infowindows = [];

        places.forEach((place, i) => {
            const placePosition = new kakao.maps.LatLng(place.y, place.x);
            const marker = new kakao.maps.Marker({ position: placePosition });
            marker.setMap(map);
            g.markers.push(marker);
            bounds.extend(placePosition);
            
            // [수정] '+' 연산자를 사용한 문자열 포맷팅
            const detailUrl = contextPath + "/searchRestaurant/external-detail?" +
                "name=" + encodeURIComponent(place.place_name) +
                "&address=" + encodeURIComponent(place.address_name) +
                "&phone=" + encodeURIComponent(place.phone) +
                "&category=" + encodeURIComponent(place.category_name) +
                "&lat=" + place.y + "&lng=" + place.x;

            // [수정] '+' 연산자를 사용한 HTML 문자열 생성
            const itemEl = $(
                '<div class="result-item cursor-pointer p-4 border-b border-gray-100 transition duration-300" data-index="' + i + '">' +
                    '<a href="' + detailUrl + '" class="block">' +
                        '<h3 class="font-bold text-lg text-blue-700">' + (i + 1) + '. ' + place.place_name + '</h3>' +
                        '<p class="text-gray-600 text-sm mt-1">' + (place.road_address_name || place.address_name) + '</p>' +
                        '<p class="text-gray-500 text-sm mt-1">' + place.category_name.split(' > ').pop() + '</p>' +
                        '<p class="text-blue-500 text-sm mt-1">' + (place.phone || '전화번호 정보 없음') + '</p>' +
                    '</a>' +
                '</div>'
            );
            
            listEl.append(itemEl);
            g.listItems.push(itemEl);
            
            const infowindow = new kakao.maps.InfoWindow({
                content: '<div style="padding:5px;font-size:12px; white-space:nowrap;">' + place.place_name + '</div>'
            });
            g.infowindows.push(infowindow);

            const eventHandlers = {
                mouseover: () => { infowindow.open(map, marker); highlightListItem(i, true); },
                mouseout: () => { infowindow.close(); highlightListItem(i, false); },
                click: () => { window.location.href = detailUrl; }
            };
            
            kakao.maps.event.addListener(marker, 'mouseover', eventHandlers.mouseover);
            kakao.maps.event.addListener(marker, 'mouseout', eventHandlers.mouseout);
            kakao.maps.event.addListener(marker, 'click', eventHandlers.click);
            
            itemEl.on('mouseover', eventHandlers.mouseover);
            itemEl.on('mouseout', eventHandlers.mouseout);
        });

        map.setBounds(bounds);
    }
    
    function highlightListItem(index, show) {
        $('.result-item').removeClass('highlighted');
        if (show && g.listItems[index]) {
            g.listItems[index].addClass('highlighted');
        }
    }
    
    // ]]>
    </script>
</body>
</html>

