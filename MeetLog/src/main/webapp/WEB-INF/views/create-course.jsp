<%@ page import="util.ApiKeyLoader" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    ApiKeyLoader.load(application);
    String kakaoApiKey = ApiKeyLoader.getApiKey("kakao.api.key");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 나만의 코스 만들기</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= kakaoApiKey %>&autoload=false..."></script>
</head>
<body class="bg-slate-100">

    <div id="app" class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                <form action="${pageContext.request.contextPath}/course/create" method="post" enctype="multipart/form-data">
                    <div class="mb-6">
                        <h2 class="text-3xl font-bold">🗺️ 나만의 코스 만들기</h2>
                        <p class="text-slate-500 mt-1">대화형으로 나만의 하루를 채워보세요.</p>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">
                        <div class="lg:col-span-3 bg-white p-6 rounded-2xl shadow-lg space-y-4">
                            <div>
                                <label for="search-input" class="block font-medium text-slate-700">장소 검색</label>
                                <div class="flex gap-2 mt-1">
                                    <input type="text" id="search-input" placeholder="첫 번째 장소를 검색해보세요" class="w-full p-2 border rounded-md">
                                    <button type="button" id="search-btn" class="bg-slate-700 text-white font-bold px-4 rounded-md hover:bg-slate-800 whitespace-nowrap">검색</button>
                                </div>
                            </div>
                            <div id="map" class="w-full h-[400px] rounded-lg border"></div>
                            <div>
                                <h3 class="font-bold text-lg mb-2">검색 결과</h3>
                                <div id="search-results" class="space-y-2 max-h-48 overflow-y-auto border p-2 rounded-md">
                                    <p class="text-slate-400 text-center py-8">검색 결과가 여기에 표시됩니다.</p>
                                </div>
                            </div>
                        </div>
                        <div class="lg:col-span-2 space-y-6">
                            <div class="bg-white p-6 rounded-2xl shadow-lg">
                                <h3 class="font-bold text-lg mb-2">📍 나의 코스</h3>
                                <div id="course-cart" class="space-y-3 min-h-[150px]">
                                    <p class="initial-message text-slate-400 text-center pt-12">검색 결과에서 장소를 추가하세요.</p>
                                </div>
                            </div>
                            <div class="bg-white p-6 rounded-2xl shadow-lg">
                                <h3 class="font-bold text-lg mb-2">🤖 다음 단계 추천</h3>
                                <div id="suggestions" class="space-y-2"></div>
                            </div>
                            <div class="bg-white p-6 rounded-2xl shadow-lg">
                                <div class="space-y-4">
                                    <h3 class="font-bold text-lg">코스 요약</h3>
                                    <div class="flex justify-between items-center text-slate-600">
                                        <span>총 시간</span>
                                        <span id="total-time" class="font-bold text-lg text-slate-800">0 분</span>
                                    </div>
                                    <div class="flex justify-between items-center text-slate-600">
                                        <span>총 비용</span>
                                        <span id="total-cost" class="font-bold text-lg text-slate-800">₩ 0</span>
                                    </div>
                                </div>
                                <div class="mt-6">
                                    <button type="submit" id="save-course-btn" class="w-full bg-sky-600 text-white font-bold py-3 rounded-lg hover:bg-sky-700">이 코스 최종 완성하기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </main>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        // [수정] DOMContentLoaded를 제거하고 kakao.maps.load 콜백만 사용합니다.
        kakao.maps.load(() => {
            const mapContainer = document.getElementById('map');
            const mapOption = { 
                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                level: 5 
            };
            const map = new kakao.maps.Map(mapContainer, mapOption);
            const ps = new kakao.maps.services.Places();
            
            let markers = []; // 마커들을 저장할 배열

            const searchInput = document.getElementById('search-input');
            const searchBtn = document.getElementById('search-btn');
            const searchResultsContainer = document.getElementById('search-results');
            const courseCartContainer = document.getElementById('course-cart');
            const suggestionsContainer = document.getElementById('suggestions');
            const totalTimeEl = document.getElementById('total-time');
            const totalCostEl = document.getElementById('total-cost');
            
            let courseCart = [];
            let currentSuggestionType = '맛집';

            // 검색 버튼 클릭 이벤트
            searchBtn.addEventListener('click', () => {
                const keyword = searchInput.value;
                if (!keyword.trim()) {
                    alert('검색어를 입력해주세요.');
                    return;
                }
                ps.keywordSearch(keyword, (data, status, pagination) => {
                    if (status === kakao.maps.services.Status.OK) {
                        displayPlaces(data);
                    } else {
                        searchResultsContainer.innerHTML = `<p class="text-slate-400 text-center py-8">검색 결과가 없습니다.</p>`;
                    }
                }); 
            });

            // 검색 결과를 지도와 목록에 표시하는 함수
            function displayPlaces(places) {
                removeMarkers(); // 기존 마커 제거
                searchResultsContainer.innerHTML = '';
                
                const bounds = new kakao.maps.LatLngBounds();

                places.forEach((place, i) => {
                    const placePosition = new kakao.maps.LatLng(place.y, place.x);
                    
                    // 지도에 마커 표시
                    const marker = new kakao.maps.Marker({
                        map: map,
                        position: placePosition
                    });
                    markers.push(marker);

                    // 검색 결과 목록에 아이템 추가
                    const resultEl = document.createElement('div');
                    resultEl.className = 'p-2 border rounded-md flex justify-between items-center cursor-pointer hover:bg-sky-50';
                    resultEl.innerHTML = `
                        <div>
                            <p class="font-bold">${place.place_name}</p>
                            <p class="text-xs text-slate-500">${place.road_address_name || place.address_name}</p>
                        </div>
                        <button class="add-btn text-sm bg-sky-500 text-white px-2 py-1 rounded-md whitespace-nowrap">추가</button>`;
                    
                    resultEl.querySelector('.add-btn').addEventListener('click', (e) => {
                        e.stopPropagation(); // 이벤트 버블링 방지
                        addPlaceToCart(place);
                    });
                    
                    searchResultsContainer.appendChild(resultEl);
                    bounds.extend(placePosition);
                });
                
                // 검색된 장소들이 모두 보이도록 지도의 범위를 재설정
                if(places.length > 0) {
                    map.setBounds(bounds);
                }
            }

            // 지도에서 기존 마커를 모두 제거하는 함수
            function removeMarkers() {
                for (let i = 0; i < markers.length; i++) {
                    markers[i].setMap(null);
                }   
                markers = [];
            }

            // 코스 카트에 장소 추가
            function addPlaceToCart(place) {
                const placeData = {
                    name: place.place_name,
                    type: currentSuggestionType,
                    lat: place.y,
                    lng: place.x,
                    time: 60,
                    cost: 15000
                };
                courseCart.push(placeData);
                
                renderCart();
                updateSummary();
                showNextSuggestions();
                
                searchResultsContainer.innerHTML = `<p class="text-slate-400 text-center py-8">다음 추천 장소를 검색하세요.</p>`;
                searchInput.value = '';
                removeMarkers();
            }

            // 카트 UI 렌더링
            function renderCart() {
                if (courseCart.length === 0) {
                     courseCartContainer.innerHTML = `<p class="initial-message text-slate-400 text-center pt-12">검색 결과에서 장소를 추가하세요.</p>`;
                     return;
                }
                
                courseCartContainer.innerHTML = '';
                courseCart.forEach((item, index) => {
                    const itemEl = document.createElement('div');
                    itemEl.className = 'p-3 border rounded-lg bg-slate-50';
                    itemEl.innerHTML = `<div class="flex justify-between items-center"><span class="font-bold">${index + 1}. ${item.type}: ${item.name}</span></div>`;
                    courseCartContainer.appendChild(itemEl);
                });
            }

            // 다음 단계 추천 UI 표시
            function showNextSuggestions() {
                suggestionsContainer.innerHTML = '';
                const lastItem = courseCart.length > 0 ? courseCart[courseCart.length - 1] : null;
                let nextSuggestions = [];

                if (!lastItem) {
                     searchInput.placeholder = `첫 번째 장소를 검색해보세요`;
                     return;
                }

                if (lastItem.type === '맛집') {
                    nextSuggestions = [{type: '카페', emoji: '☕'}, {type: '공원', emoji: '🌳'}];
                    suggestionsContainer.innerHTML += `<p class="text-sm text-slate-600">식사 후에는 역시...!</p>`;
                } else if (lastItem.type === '카페' || lastItem.type === '공원') {
                    nextSuggestions = [{type: '맛집', emoji: '🍝'}, {type: '즐길거리', emoji: '🎈'}];
                    suggestionsContainer.innerHTML += `<p class="text-sm text-slate-600">이제 뭘 해볼까요?</p>`;
                } else {
                     suggestionsContainer.innerHTML = `<p class="text-sm text-slate-600">코스가 완성된 것 같네요!</p>`;
                     return;
                }

                nextSuggestions.forEach(suggestion => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'w-full bg-slate-100 text-slate-700 font-semibold py-2 px-4 rounded-md text-sm border hover:bg-slate-200 text-left';
                    btn.textContent = `${suggestion.emoji} ${suggestion.type} 추가하기`;
                    btn.onclick = () => {
                        currentSuggestionType = suggestion.type;
                        searchInput.placeholder = `${lastItem.name} 주변 ${suggestion.type} 검색...`;
                        suggestionsContainer.innerHTML = `<p class="text-sm text-slate-500 font-semibold">'${suggestion.type}'를 검색해주세요!</p>`;
                    };
                    suggestionsContainer.appendChild(btn);
                });
            }

            // 요약 정보 업데이트
            function updateSummary() {
                const totalTime = courseCart.reduce((sum, item) => sum + item.time, 0);
                const totalCost = courseCart.reduce((sum, item) => sum + item.cost, 0);
                totalTimeEl.textContent = `${totalTime} 분`;
                totalCostEl.textContent = `₩ ${totalCost.toLocaleString()}`;
            }
            
            // 초기 상태 렌더링
            renderCart();
            showNextSuggestions();
        });
    </script>
</body>
</html>