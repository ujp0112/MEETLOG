<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Hero Section: 가치 제안 + 빠른 검색 -->
<section class="relative bg-gradient-to-br from-sky-50 via-blue-50 to-indigo-100 py-20 mb-16 overflow-hidden"
         aria-labelledby="hero-title">

    <!-- 배경 장식 -->
    <div class="absolute inset-0 opacity-10">
        <div class="absolute top-10 left-10 w-72 h-72 bg-sky-400 rounded-full blur-3xl"></div>
        <div class="absolute bottom-10 right-10 w-96 h-96 bg-purple-400 rounded-full blur-3xl"></div>
    </div>

    <div class="container mx-auto px-4 relative z-10">
        <div class="text-center max-w-4xl mx-auto">
            <!-- 메인 헤드라인 -->
            <h2 id="hero-title" class="text-4xl md:text-6xl font-black text-slate-900 mb-6 leading-tight">
                나만의 맛집,<br class="md:hidden">
                <span class="text-sky-600">기록하고 공유</span>하세요
            </h2>

            <!-- 서브 헤드라인 -->
            <p class="text-xl md:text-2xl text-slate-700 mb-10 leading-relaxed">
                <c:choose>
                    <c:when test="${not empty user}">
                        <strong>${user.nickname}님</strong>, 오늘은 어떤 맛집을 찾으시나요?
                    </c:when>
                    <c:otherwise>
                        지금 가장 핫한 맛집을 찾아보세요
                    </c:otherwise>
                </c:choose>
            </p>

            <!-- 검색 폼 -->
            <form action="${pageContext.request.contextPath}/restaurant/list"
                  method="get"
                  class="mb-6"
                  role="search"
                  aria-label="빠른 맛집 검색"
                  onsubmit="return handleFormSubmit(event, this)">

                <div class="flex flex-col md:flex-row gap-3 max-w-3xl mx-auto">
                    <!-- 검색 입력창 -->
                    <div class="flex-1">
                        <label for="heroKeyword" class="sr-only">맛집 검색 키워드</label>
                        <input type="text"
                               id="heroKeyword"
                               name="keyword"
                               placeholder="지역, 음식 종류로 검색 (예: 강남 일식)"
                               class="w-full px-6 py-4 text-lg rounded-full border-2 border-sky-300
                                      focus:border-sky-500 focus:ring-4 focus:ring-sky-200
                                      transition shadow-sm"
                               autocomplete="off"
                               aria-label="맛집 검색 키워드 입력">
                    </div>

                    <!-- 검색 버튼 -->
                    <button type="submit"
                            class="px-10 py-4 bg-sky-600 text-white text-lg font-bold
                                   rounded-full hover:bg-sky-700 transition
                                   shadow-lg hover:shadow-xl transform hover:scale-105
                                   focus:ring-4 focus:ring-sky-300">
                        검색하기
                    </button>
                </div>
            </form>

            <!-- 보조 CTA -->
            <div class="flex flex-wrap justify-center gap-4 text-sm">
                <a href="${pageContext.request.contextPath}/searchRestaurant?keyword=&category=전체"
                   class="inline-flex items-center gap-2 text-sky-700 font-semibold
                          hover:text-sky-800 transition group js-header-map-btn">
                    <svg class="w-5 h-5 transform group-hover:scale-110 transition" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z"/>
                    </svg>
                    지도로 주변 맛집 찾기
                </a>

                <span class="text-slate-400">|</span>

                <button type="button"
                        id="advancedSearchToggle"
                        onclick="toggleAdvancedSearch()"
                        aria-expanded="false"
                        aria-controls="advancedSearchSection"
                        class="inline-flex items-center gap-2 text-slate-700 font-semibold
                               hover:text-slate-900 transition group">
                    <svg class="w-5 h-5 transform group-hover:rotate-180 transition" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M3 3a1 1 0 000 2h11a1 1 0 100-2H3zM3 7a1 1 0 000 2h5a1 1 0 000-2H3zM3 11a1 1 0 100 2h4a1 1 0 100-2H3z"/>
                    </svg>
                    상세 검색 옵션
                </button>
            </div>
        </div>
    </div>
</section>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // 헤더에 있는 모든 '지도 검색' 버튼(데스크톱, 모바일)을 선택합니다.
    const headerMapBtns = document.querySelectorAll('.js-header-map-btn');

    headerMapBtns.forEach(btn => {
        btn.addEventListener('click', function(event) {
            event.preventDefault(); // a 태그의 기본 링크 이동을 막습니다.

            const originalBtnText = this.textContent.trim();
            // 로딩 상태로 변경 (링크는 textContent 대신 innerHTML을 사용할 수 있음)
            //this.innerHTML = '위치 찾는 중...'; 
            //this.style.pointerEvents = 'none'; // 중복 클릭 방지

            // 위치 정보를 가지고 검색 페이지로 이동하는 함수
            const performHeaderSearch = (lat, lng) => {
                const params = new URLSearchParams();
                
                // 헤더에서 클릭 시 특정 키워드는 없으므로 비워둡니다.
                // (search-map.jsp에서 키워드가 비어있고 좌표가 있으면 '맛집'으로 검색합니다)
                params.append('keyword', ''); 
                params.append('category', '전체');

                if (lat && lng) {
                    params.append('lat', lat);
                    params.append('lng', lng);
                }

                const searchUrl = "${pageContext.request.contextPath}/searchRestaurant?" + params.toString();
                window.location.href = searchUrl;
            };

            // 브라우저의 Geolocation API를 사용하여 현재 위치를 요청합니다.
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    // 성공 시: 알아낸 좌표로 검색 함수 실행
                    (position) => {
                        performHeaderSearch(position.coords.latitude, position.coords.longitude);
                    },
                    // 실패 시: 사용자에게 알리고 버튼 상태를 복구
                    (error) => {
                        console.error("Geolocation error:", error.message);
                        alert("위치 정보를 가져올 수 없습니다. OS나 브라우저의 위치 서비스가 켜져 있는지 확인해주세요.");
                        this.innerHTML = originalBtnText; // 원래 텍스트로 복구
                        this.style.pointerEvents = 'auto'; // 클릭 다시 활성화
                    },
                    { timeout: 8000 } // 8초 타임아웃
                );
            } else {
                alert("이 브라우저에서는 위치 정보 기능을 사용할 수 없습니다.");
                this.innerHTML = originalBtnText; // 버튼 상태 복구
                this.style.pointerEvents = 'auto';
            }
        });
    });
});
</script>
