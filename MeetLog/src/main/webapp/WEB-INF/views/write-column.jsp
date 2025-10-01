<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - 칼럼 작성</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src="https://cdn.tiny.cloud/1/${TINYMCE_API_KEY}/tinymce/7/tinymce.min.js"
	referrerpolicy="origin"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services"></script>
<style>
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
	transition: all 0.1s;
	cursor: pointer;
	z-index: 1;
}

.marker-overlay.highlight, .marker-overlay:hover {
	transform: translate(-50%, -100%) scale(1.05);
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
	width: 24px;
	height: 24px;
	border-radius: 50%;
	color: white;
	font-weight: bold;
	font-size: 13px;
	flex-shrink: 0;
	background-color: #3182ce;
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
	overflow: hidden;
	text-overflow: ellipsis;
}

.marker-category {
	font-size: 11px;
	color: #718096;
}

#map-modal {
	background-color: rgba(0, 0, 0, 0.6);
}

#modal-results-list {
	scrollbar-width: thin;
}

.modal-result-item:hover {
	background-color: #f0f7ff;
}

.modal-result-item.highlighted {
	background-color: #ebf8ff;
	border-left: 4px solid #3182ce;
}

.modal-result-item-image {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border-radius: 0.5rem;
	background-color: #e2e8f0;
}

.attached-restaurant-item {
	display: flex;
	align-items: center;
	padding: 8px;
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	background-color: #f8fafc;
}
</style>
</head>
<body class="bg-slate-100">
	<div id="app" class="flex flex-col min-h-screen">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<main class="flex-grow">
			<div class="container mx-auto p-4 md:p-8">
				<div class="max-w-4xl mx-auto">
					<div class="mb-6">
						<h2 class="text-2xl md:text-3xl font-bold mb-2">
							<c:choose>
								<c:when test="${isEditMode}">칼럼 수정</c:when>
								<c:otherwise>칼럼 작성</c:otherwise>
							</c:choose>
						</h2>
						<p class="text-slate-600">
							<c:choose>
								<c:when test="${isEditMode}">칼럼을 수정해주세요.</c:when>
								<c:otherwise>맛집에 대한 칼럼을 작성해주세요.</c:otherwise>
							</c:choose>
						</p>
					</div>
					<c:choose>
						<c:when test="${not empty sessionScope.user}">
							<div class="bg-white p-6 rounded-xl shadow-lg">
								<form
									action="${pageContext.request.contextPath}/column/<c:choose><c:when test='${isEditMode}'>edit</c:when><c:otherwise>write</c:otherwise></c:choose>"
									method="post" enctype="multipart/form-data" class="space-y-6">
									<c:if test="${isEditMode}">
										<input type="hidden" name="columnId" value="${column.id}">
									</c:if>
									<input type="hidden" name="userId"
										value="${sessionScope.user.id}">
									<div>
										<label for="title"
											class="block text-sm font-medium text-slate-700 mb-2">제목</label><input
											type="text" id="title" name="title" required
											class="w-full px-3 py-2 border border-slate-300 rounded-md"
											placeholder="칼럼 제목을 입력하세요"
											value="<c:if test='${isEditMode}'>${column.title}</c:if>">
									</div>
									<div>
										<label for="imageUpload"
											class="block text-sm font-medium text-slate-700 mb-2">썸네일
											이미지</label><input type="file" id="imageUpload" name="thumbnail"
											accept="image/*"
											class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
										<c:if test="${isEditMode and not empty column.image}">
											<div class="mt-4">
												<p class="text-sm text-slate-600 mb-2">현재 이미지:</p>
												<img
													src="${pageContext.request.contextPath}/uploads/${column.image}"
													alt="현재 썸네일" class="rounded-lg shadow-sm"
													style="max-width: 300px; max-height: 200px;">
											</div>
										</c:if>
										<img id="imagePreview" src="" alt="이미지 미리보기"
											class="mt-4 rounded-lg shadow-sm"
											style="display: none; max-width: 300px; max-height: 200px;">
									</div>
									<div>
										<label for="content-editor"
											class="block text-sm font-medium text-slate-700 mb-2">내용</label>
										<textarea id="content-editor" name="content"><c:if
												test="${isEditMode}">${column.content}</c:if></textarea>
										<p class="text-sm text-slate-500 mt-1">최소 100자 이상 작성해주세요.</p>
									</div>
									<div>
										<label class="block text-sm font-medium text-slate-700 mb-2">맛집
											첨부</label>
										<div id="attached-restaurants-list" class="space-y-2 mb-3"></div>
										<input type="hidden" id="attached-restaurants-input"
											name="attachedRestaurants" value="">
										<button type="button" id="open-map-modal-btn"
											class="w-full px-4 py-2 border-2 border-dashed border-slate-300 rounded-md text-slate-600 hover:bg-slate-50">+
											맛집 추가하기</button>
									</div>
									<div class="bg-slate-50 p-4 rounded-lg">
										<h4 class="font-medium text-slate-800 mb-2">📝 작성 팁</h4>
										<ul class="text-sm text-slate-600 space-y-1">
											<li>• 맛집의 특징과 분위기를 생생하게 묘사해주세요</li>
											<li>• 추천 메뉴와 가격 정보를 포함해주세요</li>
											<li>• 방문 시간대나 주차 정보 등 실용적인 정보를 추가해주세요</li>
											<li>• 개인적인 경험과 감상을 솔직하게 표현해주세요</li>
										</ul>
									</div>
									<div class="flex justify-end space-x-3">
										<a href="${pageContext.request.contextPath}/column"
											class="px-6 py-2 border border-slate-300 rounded-md text-slate-700 hover:bg-slate-50">취소</a>
										<button type="submit"
											class="px-6 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700">
											<c:choose>
												<c:when test="${isEditMode}">칼럼 수정</c:when>
												<c:otherwise>칼럼 발행</c:otherwise>
											</c:choose>
										</button>
									</div>
								</form>
							</div>
						</c:when>
						<c:otherwise>
							<%-- 수정: 깨졌던 '로그인 필요' CSS 복구 --%>
							<div class="text-center py-12">
								<div class="text-6xl mb-4">🔒</div>
								<h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이
									필요합니다</h2>
								<p class="text-slate-600 mb-6">칼럼을 작성하려면 로그인해주세요.</p>
								<a href="${pageContext.request.contextPath}/login"
									class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">로그인하기</a>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	</div>

	<div id="map-modal"
		class="fixed inset-0 z-50 flex items-center justify-center hidden">
		<div
			class="bg-white rounded-lg shadow-2xl w-full max-w-4xl h-[90vh] flex flex-col">
			<div class="p-3 border-b flex justify-between items-center">
				<h3 class="text-lg font-bold">지도에서 맛집 검색</h3>
				<button type="button" id="close-map-modal-btn" class="text-2xl px-2">&times;</button>
			</div>
			<div class="flex-grow flex flex-col md:flex-row overflow-hidden">
				<div id="modal-result-panel"
					class="w-full md:w-1/3 h-1/3 md:h-full flex flex-col border-r bg-white">
					<div class="p-3 border-b">
						<div class="flex space-x-2">
							<input type="text" id="modal-search-keyword"
								placeholder="맛집 이름, 지역 검색"
								class="flex-grow px-3 py-2 border border-slate-300 rounded-md">
							<button type="button" id="modal-search-btn"
								class="px-4 py-2 bg-sky-600 text-white rounded-md">검색</button>
						</div>
					</div>
					<div id="modal-results-list" class="flex-grow overflow-y-auto">
						<p class="p-4 text-slate-500 text-center">검색어를 입력해주세요.</p>
					</div>
				</div>
				<div id="modal-map-panel" class="w-full md:w-2/3 h-2/3 md:h-full">
					<div id="modal-map" style="width: 100%; height: 100%;"></div>
				</div>
			</div>
		</div>
	</div>

	<script>
    $(document).ready(function() {
        tinymce.init({ selector: 'textarea#content-editor', plugins: 'image link lists media table wordcount', toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | indent outdent | bullist numlist | link image media | table', height: 500, images_upload_handler: (blobInfo) => new Promise((resolve, reject) => { const formData = new FormData(); formData.append('file', blobInfo.blob(), blobInfo.filename()); fetch('${pageContext.request.contextPath}/api/column/image-upload', { method: 'POST', body: formData }).then(response => response.ok ? response.json() : Promise.reject(`HTTP error! status: ${response.status}`)).then(json => json && json.location ? resolve(json.location) : Promise.reject('Invalid JSON response')).catch(error => reject('Upload failed: ' + error.message)); }), content_style: 'body{font-family:"Noto Sans KR",sans-serif}img{max-width:100%;height:auto}' });
        $('#imageUpload').on('change', function(event) { if (this.files && this.files[0]) { const reader = new FileReader(); reader.onload = e => $('#imagePreview').attr('src', e.target.result).show(); reader.readAsDataURL(this.files[0]); } });
        $('form').on('submit', function(e) { tinymce.triggerSave(); if ($('#title').val().trim().length < 2) { e.preventDefault(); alert('제목을 2자 이상 입력해주세요.'); return false; } if (tinymce.get('content-editor').getContent({ format: 'text' }).trim().length < 100) { e.preventDefault(); alert('내용을 100자 이상 작성해주세요.'); return false; } });

        const attachedRestaurants = new Map();
        const contextPath = "${pageContext.request.contextPath}";
        <c:if test="${isEditMode and not empty attachedRestaurants}"><c:forEach var="r" items="${attachedRestaurants}">attachedRestaurants.set(${r.id}, { id: ${r.id}, name: "${r.name}", address: "${r.address}" });</c:forEach></c:if>
        function updateAttachedList() { const listEl = $('#attached-restaurants-list'); listEl.empty(); const ids = []; attachedRestaurants.forEach(r => { if (r && typeof r.id === 'number') { listEl.append(`<div class="attached-restaurant-item" data-id="${r.id}"><div class="flex-grow"><p class="font-bold text-slate-800">${r.name}</p><p class="text-sm text-slate-500">${r.address}</p></div><button type="button" class="remove-restaurant-btn ml-4 text-red-500 font-bold">삭제</button></div>`); ids.push(r.id); } }); $('#attached-restaurants-input').val(ids.join(',')); }
        updateAttachedList();
        $('#attached-restaurants-list').on('click', '.remove-restaurant-btn', function() { attachedRestaurants.delete($(this).closest('.attached-restaurant-item').data('id')); updateAttachedList(); });
        
        let modalMap, modalPs, modalOverlays = [];
        $('#open-map-modal-btn').on('click', function() { $('#map-modal').removeClass('hidden'); if (!modalMap) { const mapContainer = document.getElementById('modal-map'); const mapOption = { center: new kakao.maps.LatLng(37.566826, 126.97865), level: 5 }; modalMap = new kakao.maps.Map(mapContainer, mapOption); modalPs = new kakao.maps.services.Places(); } else { modalMap.relayout(); } });
        $('#close-map-modal-btn').on('click', () => $('#map-modal').addClass('hidden'));
        $('#modal-search-btn').on('click', searchOnModalMap);
        $('#modal-search-keyword').on('keydown', e => { if (e.key === 'Enter') searchOnModalMap(); });
        function searchOnModalMap() { const keyword = $('#modal-search-keyword').val(); if (!keyword.trim()) return; modalPs.keywordSearch(keyword, (data, status) => { if (status === kakao.maps.services.Status.OK) { displayModalResults(data); } else { $('#modal-results-list').html('<p class="p-4 text-slate-500 text-center">검색 결과가 없습니다.</p>'); } }, { category_group_code: 'FD6' }); }
        
        function displayModalResults(places) {
            const listEl = $('#modal-results-list'); listEl.empty(); modalOverlays.forEach(o => o.setMap(null)); modalOverlays = []; const bounds = new kakao.maps.LatLngBounds();
            places.forEach((place, i) => {
                const placePosition = new kakao.maps.LatLng(place.y, place.x);
                const categoryName = place.category_name.split(' > ').pop();
                const address = place.road_address_name || place.address_name;
                const location = address.split(' ').slice(0, 2).join(' ');
                
                const overlayEl = $(`<div class="marker-overlay"><div class="marker-number">${i + 1}</div><div class="marker-info"><div class="marker-title" title="${place.place_name}">${place.place_name}</div><div class="marker-category">${categoryName}</div></div></div>`);
                const customOverlay = new kakao.maps.CustomOverlay({ position: placePosition, content: overlayEl[0], yAnchor: 1 });
                customOverlay.setMap(modalMap); modalOverlays.push(customOverlay);
                
                const itemEl = $(`
                    <div class="modal-result-item p-3 border-b flex items-center space-x-3 cursor-pointer" data-index="${i}">
                        <img src="https://placehold.co/70x70/EBF8FF/3182CE?text=${i + 1}" alt="${place.place_name}" class="modal-result-item-image flex-shrink-0">
                        <div class="flex-grow">
                            <h3 class="font-bold text-base text-blue-700">${place.place_name}</h3>
                            <p class="text-gray-600 text-sm mt-1">${address}</p>
                        </div>
                        <button class="add-restaurant-btn px-4 py-2 bg-sky-600 text-white text-sm rounded-md hover:bg-sky-700 flex-shrink-0"
                                data-kakao-id="${place.id}" data-name="${place.place_name}" data-address="${address}"
                                data-location="${location}" data-phone="${place.phone}" data-category="${place.category_name}"
                                data-lat="${place.y}" data-lng="${place.x}">추가</button>
                    </div>`);
                listEl.append(itemEl);
                bounds.extend(placePosition);

                itemEl.on('click', function(e) {
                    if (!$(e.target).is('.add-restaurant-btn')) {
                        modalMap.panTo(placePosition);
                        $('.marker-overlay').removeClass('highlight'); $(customOverlay.getContent()).addClass('highlight');
                        $('.modal-result-item').removeClass('highlighted'); $(this).addClass('highlighted');
                    }
                });
            });
            modalMap.setBounds(bounds);
        }

        $('#modal-results-list').on('click', '.add-restaurant-btn', function() {
            const btn = $(this); btn.prop('disabled', true).text('...');
            const restaurantData = { kakaoPlaceId: btn.data('kakao-id'), name: btn.data('name'), address: btn.data('address'), location: btn.data('location'), phone: btn.data('phone'), category: btn.data('category'), lat: btn.data('lat'), lng: btn.data('lng') };
            $.ajax({
                url: contextPath + '/api/restaurant/find-or-create', type: 'POST', data: restaurantData,
                success: function(dbRestaurant) { if (dbRestaurant && dbRestaurant.id) { if(attachedRestaurants.has(dbRestaurant.id)) { alert('이미 추가된 맛집입니다.'); return; } attachedRestaurants.set(dbRestaurant.id, dbRestaurant); updateAttachedList(); alert('맛집이 추가되었습니다.'); $('#map-modal').addClass('hidden'); } else { alert('맛집 정보 처리에 실패했습니다.'); } },
                error: function() { alert('맛집 추가 중 오류가 발생했습니다.'); },
                complete: function() { btn.prop('disabled', false).text('추가'); }
            });
        });
    });
    </script>
</body>
</html>