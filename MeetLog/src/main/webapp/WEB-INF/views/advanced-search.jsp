<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="util.LocalDateTimeAdapter" %>
<%
    Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
        .create();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>통합 검색 - MEET LOG</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_API_KEY}&libraries=services"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        .search-hero-pill { @apply inline-flex items-center gap-2 rounded-full bg-indigo-100/80 px-3 py-1 text-xs font-semibold text-indigo-700; }
        .subtle-card { @apply rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8; }
        .chip { @apply inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600 transition hover:border-indigo-400 hover:text-indigo-600; }
    </style>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }

        .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }

        /* 타입별 그라데이션 배경 */
        .gradient-bg-restaurants { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); }
        .gradient-bg-reviews { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); }
        .gradient-bg-reservations { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        .gradient-bg-columns { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }

        /* 검색 타입 탭 스타일 */
        .search-tab {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            border: 2px solid transparent;
        }

        .search-tab:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.12);
        }

        /* 활성화된 검색 타입 탭 */
        .search-tab-active {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.15);
            border-color: currentColor;
        }

        .search-tab-active.type-restaurants {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border-color: #3b82f6;
        }
        .search-tab-active.type-reviews {
            background: linear-gradient(135deg, #faf5ff 0%, #f3e8ff 100%);
            border-color: #8b5cf6;
        }
        .search-tab-active.type-reservations {
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            border-color: #10b981;
        }
        .search-tab-active.type-columns {
            background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
            border-color: #f59e0b;
        }

        .search-tab-active h3 { font-weight: 700; }

        .search-tab-active.type-restaurants h3,
        .search-tab-active.type-restaurants p { color: #1e40af; }
        .search-tab-active.type-reviews h3,
        .search-tab-active.type-reviews p { color: #6d28d9; }
        .search-tab-active.type-reservations h3,
        .search-tab-active.type-reservations p { color: #047857; }
        .search-tab-active.type-columns h3,
        .search-tab-active.type-columns p { color: #b45309; }

        /* 필터 카드 */
        .filter-card {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.06);
            transition: all 0.25s ease;
            border: 1px solid #e2e8f0;
        }

        .filter-card:hover {
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.12);
            transform: translateY(-2px);
        }

        .filter-card label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            color: #334155;
            margin-bottom: 10px;
        }

        .filter-card input,
        .filter-card select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            background: white;
        }

        .filter-card input:focus,
        .filter-card select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* 활성 필터 칩 */
        .filter-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            color: #1e40af;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            animation: slideIn 0.3s ease;
        }

        .filter-chip button {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: rgba(30, 64, 175, 0.15);
            color: #1e40af;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.2s ease;
        }

        .filter-chip button:hover {
            background: rgba(30, 64, 175, 0.25);
            transform: scale(1.1);
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-10px); }
            to { opacity: 1; transform: translateX(0); }
        }

        /* 검색 버튼 */
        .btn-search {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 16px 40px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 1.05rem;
            border: none;
            cursor: pointer;
            box-shadow: 0 12px 30px rgba(37, 99, 235, 0.25);
            transition: all 0.3s ease;
            min-width: 160px;
        }

        .btn-search:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 40px rgba(37, 99, 235, 0.35);
        }

        .btn-search:active {
            transform: translateY(-1px);
        }

        .btn-reset {
            background: white;
            color: #64748b;
            padding: 16px 32px;
            border-radius: 14px;
            font-weight: 600;
            font-size: 1rem;
            border: 2px solid #e2e8f0;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 120px;
        }

        .btn-reset:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
            transform: translateY(-2px);
        }

        /* 카드 호버 효과 */
        .card-hover {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-hover:hover {
            transform: translateY(-6px);
            box-shadow: 0 25px 55px rgba(15, 23, 42, 0.12);
        }

        /* 폼 전환 애니메이션 */
        .search-section {
            animation: fadeInUp 0.4s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 아이콘 래퍼 */
        .icon-wrapper {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            flex-shrink: 0;
            transition: all 0.3s ease;
        }

        /* 스티키 검색 버튼 (모바일) */
        @media (max-width: 768px) {
            .search-actions-sticky {
                position: sticky;
                bottom: 0;
                background: white;
                border-top: 1px solid #e2e8f0;
                padding: 16px;
                box-shadow: 0 -4px 12px rgba(15, 23, 42, 0.08);
                z-index: 10;
            }
        }

        /* 결과 카운트 배지 */
        .result-badge {
            background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.95rem;
        }

        /* 로딩 스피너 */
        .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* 빈 상태 일러스트레이션 */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }

        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        /* 터치 친화적 크기 (모바일) */
        @media (max-width: 768px) {
            .search-tab {
                padding: 20px !important;
            }

            .filter-card input,
            .filter-card select {
                padding: 14px 16px;
                font-size: 16px; /* iOS 줌 방지 */
            }

            .btn-search,
            .btn-reset {
                padding: 18px 32px;
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <!-- 히어로 섹션 -->
    <section class="border-b border-slate-200 bg-gradient-to-r from-slate-50 via-white to-blue-50/70">
        <div class="mx-auto flex w-full max-w-6xl flex-col gap-8 px-6 py-12 md:px-10">
            <div class="max-w-4xl space-y-4">
                <span class="inline-flex items-center gap-2 rounded-full bg-blue-100/80 px-3 py-1 text-xs font-semibold text-blue-700">
                    <span class="text-base">🔍</span>
                    Meet Log Search
                </span>
                <h1 class="text-3xl font-bold leading-tight text-slate-900 md:text-4xl">통합 검색</h1>
                <p class="text-sm text-slate-600 md:text-base">
                    음식점, 리뷰, 예약 순위, 칼럼을 하나의 화면에서 찾아보세요. 다양한 필터로 원하는 정보를 빠르게 검색할 수 있습니다.
                </p>
            </div>
        </div>
    </section>

    <main class="container mx-auto px-4 py-8 md:px-6 lg:px-8 max-w-6xl">
        <input type="hidden" id="activeSearchType" value="${empty searchType ? 'restaurants' : searchType}" />

        <div class="space-y-8">
            <!-- 검색 타입 선택 섹션 -->
            <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                <header class="mb-6 text-center">
                    <h2 class="text-xl font-bold text-slate-900">검색 카테고리 선택</h2>
                    <p class="mt-2 text-sm text-slate-500">원하는 검색 유형을 선택하고 상세 조건을 설정하세요.</p>
                </header>

                <!-- 검색 타입 선택 탭 -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4" role="tablist" aria-label="검색 타입 선택">
                    <button type="button"
                            class="search-tab type-restaurants w-full text-left bg-slate-50 rounded-2xl p-5 flex items-center gap-4 transition hover:shadow-md ${searchType == 'restaurants' ? 'search-tab-active' : ''}"
                            data-type="restaurants"
                            id="tab-restaurants"
                            onclick="setSearchType('restaurants')"
                            role="tab"
                            aria-selected="${searchType == 'restaurants' ? 'true' : 'false'}"
                            aria-controls="form-restaurants">
                        <div class="icon-wrapper bg-blue-100 text-blue-600">🍽️</div>
                        <div>
                            <h3 class="text-base md:text-lg font-bold text-slate-800">음식점</h3>
                            <p class="text-xs md:text-sm text-slate-500 mt-1">맛집 찾기</p>
                        </div>
                    </button>

                    <button type="button"
                            class="search-tab type-reviews w-full text-left bg-slate-50 rounded-2xl p-5 flex items-center gap-4 transition hover:shadow-md ${searchType == 'reviews' ? 'search-tab-active' : ''}"
                            data-type="reviews"
                            id="tab-reviews"
                            onclick="setSearchType('reviews')"
                            role="tab"
                            aria-selected="${searchType == 'reviews' ? 'true' : 'false'}"
                            aria-controls="form-reviews">
                        <div class="icon-wrapper bg-purple-100 text-purple-600">📝</div>
                        <div>
                            <h3 class="text-base md:text-lg font-bold text-slate-800">리뷰</h3>
                            <p class="text-xs md:text-sm text-slate-500 mt-1">평점·키워드</p>
                        </div>
                    </button>

                    <button type="button"
                            class="search-tab type-reservations w-full text-left bg-slate-50 rounded-2xl p-5 flex items-center gap-4 transition hover:shadow-md ${searchType == 'reservations' ? 'search-tab-active' : ''}"
                            data-type="reservations"
                            id="tab-reservations"
                            onclick="setSearchType('reservations')"
                            role="tab"
                            aria-selected="${searchType == 'reservations' ? 'true' : 'false'}"
                            aria-controls="form-reservations">
                        <div class="icon-wrapper bg-emerald-100 text-emerald-600">📅</div>
                        <div>
                            <h3 class="text-base md:text-lg font-bold text-slate-800">예약 순위</h3>
                            <p class="text-xs md:text-sm text-slate-500 mt-1">인기 음식점</p>
                        </div>
                    </button>

                    <button type="button"
                            class="search-tab type-columns w-full text-left bg-slate-50 rounded-2xl p-5 flex items-center gap-4 transition hover:shadow-md ${searchType == 'columns' ? 'search-tab-active' : ''}"
                            data-type="columns"
                            id="tab-columns"
                            onclick="setSearchType('columns')"
                            role="tab"
                            aria-selected="${searchType == 'columns' ? 'true' : 'false'}"
                            aria-controls="form-columns">
                        <div class="icon-wrapper bg-orange-100 text-orange-600">📰</div>
                        <div>
                            <h3 class="text-base md:text-lg font-bold text-slate-800">칼럼</h3>
                            <p class="text-xs md:text-sm text-slate-500 mt-1">맛집 스토리</p>
                        </div>
                    </button>
                </div>
            </div>

            <!-- 검색 필터 영역 -->
            <div class="glass-card p-6 md:p-8 rounded-3xl">
                <!-- 적용된 필터 표시 영역 -->
                <div id="active-filters" class="mb-6 hidden" role="region" aria-live="polite">
                    <div class="flex items-center justify-between mb-3">
                        <h3 class="text-sm font-bold text-slate-700 flex items-center gap-2">
                            <span>✓</span> 적용된 필터
                        </h3>
                        <button type="button"
                                onclick="resetForm()"
                                class="text-xs text-blue-600 hover:text-blue-800 font-semibold"
                                aria-label="모든 필터 초기화">
                            전체 초기화
                        </button>
                    </div>
                    <div id="filter-chips" class="flex flex-wrap gap-2"></div>
                </div>

                <!-- 음식점 검색 폼 -->
                <div class="search-section" data-type="restaurants" id="form-restaurants" role="tabpanel" aria-labelledby="tab-restaurants">
                    <form action="${pageContext.request.contextPath}/search" method="post">
                        <input type="hidden" name="type" value="restaurants" />
                        <input type="hidden" name="submitted" value="true" />

                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
                            <!-- 키워드 필터 -->
                            <div class="filter-card md:col-span-2 lg:col-span-3">
                                <label for="restaurant-keyword">
                                    <span>🔍</span> 키워드
                                </label>
                                <input type="text"
                                       id="restaurant-keyword"
                                       name="keyword"
                                       value="${empty searchParams.keyword ? '' : searchParams.keyword}"
                                       placeholder="맛집 이름, 지역, 메뉴 등을 입력하세요"
                                       aria-describedby="keyword-help" />
                                <p id="keyword-help" class="sr-only">검색하고 싶은 음식점의 이름이나 위치를 입력하세요</p>
                            </div>

                            <!-- 음식 종류 필터 -->
                            <div class="filter-card">
                                <label for="restaurant-category">
                                    <span>🍜</span> 음식 종류
                                </label>
                                <select name="category" id="restaurant-category">
                                    <option value="">전체</option>
                                    <option value="한식" ${searchParams.category == '한식' ? 'selected' : ''}>한식</option>
                                    <option value="양식" ${searchParams.category == '양식' ? 'selected' : ''}>양식</option>
                                    <option value="일식" ${searchParams.category == '일식' ? 'selected' : ''}>일식</option>
                                    <option value="중식" ${searchParams.category == '중식' ? 'selected' : ''}>중식</option>
                                    <option value="카페" ${searchParams.category == '카페' ? 'selected' : ''}>카페</option>
                                    <option value="디저트" ${searchParams.category == '디저트' ? 'selected' : ''}>디저트</option>
                                </select>
                            </div>

                            <!-- 가격대 필터 -->
                            <div class="filter-card">
                                <label for="restaurant-price">
                                    <span>💰</span> 가격대 (1인)
                                </label>
                                <select name="price" id="restaurant-price">
                                    <option value="">전체</option>
                                    <option value="1" ${searchParams.price == '1' ? 'selected' : ''}>~1만원</option>
                                    <option value="2" ${searchParams.price == '2' ? 'selected' : ''}>1~2만원</option>
                                    <option value="3" ${searchParams.price == '3' ? 'selected' : ''}>2~4만원</option>
                                    <option value="4" ${searchParams.price == '4' ? 'selected' : ''}>4만원 이상</option>
                                </select>
                            </div>

                            <!-- 주차 여부 필터 -->
                            <div class="filter-card">
                                <label for="restaurant-parking">
                                    <span>🅿️</span> 주차 여부
                                </label>
                                <select name="parking" id="restaurant-parking">
                                    <option value="">전체</option>
                                    <option value="true" ${searchParams.parking == 'true' ? 'selected' : ''}>가능</option>
                                    <option value="false" ${searchParams.parking == 'false' ? 'selected' : ''}>불가</option>
                                </select>
                            </div>
                        </div>

                        <input type="hidden" name="sortBy" value="${empty searchParams.sortBy ? '' : searchParams.sortBy}" />

                        <!-- 검색 버튼 -->
                        <div class="flex flex-col sm:flex-row gap-3 justify-center items-center">
                            <button type="button"
                                    onclick="resetForm()"
                                    class="btn-reset w-full sm:w-auto"
                                    aria-label="검색 필터 초기화">
                                <span>🔄</span> 초기화
                            </button>
                            <button type="submit"
                                    class="btn-search w-full sm:w-auto"
                                    aria-label="음식점 검색 실행">
                                <span>🔍</span> 검색하기
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 리뷰 검색 폼 -->
                <div class="search-section" data-type="reviews" id="form-reviews" role="tabpanel" aria-labelledby="tab-reviews">
                    <form action="${pageContext.request.contextPath}/search" method="post">
                        <input type="hidden" name="type" value="reviews" />
                        <input type="hidden" name="submitted" value="true" />

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                            <!-- 키워드 필터 -->
                            <div class="filter-card md:col-span-2">
                                <label for="review-keyword">
                                    <span>🔍</span> 키워드
                                </label>
                                <input type="text"
                                       id="review-keyword"
                                       name="keyword"
                                       value="${empty searchParams.keyword ? '' : searchParams.keyword}"
                                       placeholder="리뷰 내용, 작성자, 음식점 이름 등" />
                            </div>

                            <!-- 최소 평점 -->
                            <div class="filter-card">
                                <label for="review-min-rating">
                                    <span>⭐</span> 최소 평점
                                </label>
                                <select name="minRating" id="review-min-rating">
                                    <option value="">전체</option>
                                    <option value="5" ${searchParams.minRating == '5' ? 'selected' : ''}>5점</option>
                                    <option value="4" ${searchParams.minRating == '4' ? 'selected' : ''}>4점 이상</option>
                                    <option value="3" ${searchParams.minRating == '3' ? 'selected' : ''}>3점 이상</option>
                                    <option value="2" ${searchParams.minRating == '2' ? 'selected' : ''}>2점 이상</option>
                                    <option value="1" ${searchParams.minRating == '1' ? 'selected' : ''}>1점 이상</option>
                                </select>
                            </div>

                            <!-- 최대 평점 -->
                            <div class="filter-card">
                                <label for="review-max-rating">
                                    <span>⭐</span> 최대 평점
                                </label>
                                <select name="maxRating" id="review-max-rating">
                                    <option value="">전체</option>
                                    <option value="5" ${searchParams.maxRating == '5' ? 'selected' : ''}>5점</option>
                                    <option value="4" ${searchParams.maxRating == '4' ? 'selected' : ''}>4점 이하</option>
                                    <option value="3" ${searchParams.maxRating == '3' ? 'selected' : ''}>3점 이하</option>
                                    <option value="2" ${searchParams.maxRating == '2' ? 'selected' : ''}>2점 이하</option>
                                    <option value="1" ${searchParams.maxRating == '1' ? 'selected' : ''}>1점 이하</option>
                                </select>
                            </div>

                            <!-- 시작 날짜 -->
                            <div class="filter-card">
                                <label for="review-start-date">
                                    <span>📅</span> 시작 날짜
                                </label>
                                <input type="date"
                                       id="review-start-date"
                                       name="startDate"
                                       value="${empty searchParams.startDate ? '' : searchParams.startDate}" />
                            </div>

                            <!-- 종료 날짜 -->
                            <div class="filter-card">
                                <label for="review-end-date">
                                    <span>📅</span> 종료 날짜
                                </label>
                                <input type="date"
                                       id="review-end-date"
                                       name="endDate"
                                       value="${empty searchParams.endDate ? '' : searchParams.endDate}" />
                            </div>
                        </div>

                        <!-- 검색 버튼 -->
                        <div class="flex flex-col sm:flex-row gap-3 justify-center items-center">
                            <button type="button"
                                    onclick="resetForm()"
                                    class="btn-reset w-full sm:w-auto">
                                <span>🔄</span> 초기화
                            </button>
                            <button type="submit"
                                    class="btn-search w-full sm:w-auto">
                                <span>🔍</span> 검색하기
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 예약 순위 검색 폼 -->
                <div class="search-section" data-type="reservations" id="form-reservations" role="tabpanel" aria-labelledby="tab-reservations">
                    <form action="${pageContext.request.contextPath}/search" method="post">
                        <input type="hidden" name="type" value="reservations" />
                        <input type="hidden" name="submitted" value="true" />

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                            <!-- 시작 날짜 -->
                            <div class="filter-card">
                                <label for="reservation-start-date">
                                    <span>📅</span> 시작 날짜
                                </label>
                                <input type="date"
                                       id="reservation-start-date"
                                       name="startDate"
                                       value="${empty searchParams.startDate ? '' : searchParams.startDate}" />
                            </div>

                            <!-- 종료 날짜 -->
                            <div class="filter-card">
                                <label for="reservation-end-date">
                                    <span>📅</span> 종료 날짜
                                </label>
                                <input type="date"
                                       id="reservation-end-date"
                                       name="endDate"
                                       value="${empty searchParams.endDate ? '' : searchParams.endDate}" />
                            </div>
                        </div>

                        <!-- 검색 버튼 -->
                        <div class="flex flex-col sm:flex-row gap-3 justify-center items-center">
                            <button type="button"
                                    onclick="resetForm()"
                                    class="btn-reset w-full sm:w-auto">
                                <span>🔄</span> 초기화
                            </button>
                            <button type="submit"
                                    class="btn-search w-full sm:w-auto">
                                <span>🔍</span> 검색하기
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 칼럼 검색 폼 -->
                <div class="search-section" data-type="columns" id="form-columns" role="tabpanel" aria-labelledby="tab-columns">
                    <form action="${pageContext.request.contextPath}/search" method="post">
                        <input type="hidden" name="type" value="columns" />
                        <input type="hidden" name="submitted" value="true" />

                        <div class="grid grid-cols-1 gap-4 mb-6">
                            <!-- 키워드 필터 -->
                            <div class="filter-card">
                                <label for="column-keyword">
                                    <span>🔍</span> 키워드
                                </label>
                                <input type="text"
                                       id="column-keyword"
                                       name="keyword"
                                       value="${empty searchParams.keyword ? '' : searchParams.keyword}"
                                       placeholder="칼럼 내용, 작성자, 제목 등" />
                            </div>
                        </div>

                        <!-- 검색 버튼 -->
                        <div class="flex flex-col sm:flex-row gap-3 justify-center items-center">
                            <button type="button"
                                    onclick="resetForm()"
                                    class="btn-reset w-full sm:w-auto">
                                <span>🔄</span> 초기화
                            </button>
                            <button type="submit"
                                    class="btn-search w-full sm:w-auto">
                                <span>🔍</span> 검색하기
                            </button>
                        </div>
                    </form>
                </div>
            </div>


            <!-- 검색 결과 영역 -->
            <c:choose>
                <c:when test="${searchType == 'restaurants'}">
                    <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8 border-b border-slate-100 pb-4">
                            <h2 class="text-2xl font-bold text-slate-900 md:text-3xl">음식점 검색 결과</h2>
                            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600">
                                총 ${totalResults != null ? totalResults : 0}건
                            </span>
                        </div>

                        <!-- JavaScript에 의해 동적으로 채워질 컨테이너 -->
                        <div id="restaurant-results-list" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>

                        <!-- 결과 없음 메시지 -->
                        <div id="no-restaurant-results" class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center" style="display: none;">
                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-blue-50 text-4xl">🔍</div>
                            <p class="mt-6 text-xl font-bold text-slate-800">조건에 맞는 음식점이 없습니다</p>
                            <p class="mt-2 text-sm text-slate-500">필터를 조정하거나 다른 키워드로 검색해보세요</p>
                        </div>

                        <!-- 더 보기 버튼 -->
                        <div id="load-more-container" class="mt-8 text-center" style="display: none;">
                            <button id="load-more-btn"
                                    class="btn-search disabled:opacity-50 disabled:cursor-not-allowed">
                                더 보기
                            </button>
                        </div>

                        <!-- 기존 페이지네이션 -->
                        <c:if test="${totalPages > 1 and empty searchParams.keyword}">
                            <div class="mt-8 flex justify-center">
                                <!-- 페이지네이션 UI -->
                            </div>
                        </c:if>
                    </div>
                </c:when>

                <c:when test="${searchType == 'reviews'}">
                    <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8 border-b border-slate-100 pb-4">
                            <h2 class="text-2xl font-bold text-slate-900 md:text-3xl">리뷰 검색 결과</h2>
                            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600">
                                총 ${searchResults != null ? searchResults.size() : 0}건
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <div class="space-y-4">
                                    <c:forEach var="review" items="${searchResults}">
                                        <div class="overflow-hidden rounded-2xl border border-slate-100 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-lg">
                                            <div class="flex justify-between items-start mb-4">
                                                <div class="flex items-center space-x-4">
                                                    <div class="w-12 h-12 bg-gradient-to-br from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                                        ${fn:length(review.author) > 0 ? fn:substring(review.author, 0, 1) : 'R'}
                                                    </div>
                                                    <div>
                                                        <h3 class="font-bold text-slate-800">${review.author}</h3>
                                                        <p class="text-slate-500 text-sm">${review.restaurantName}</p>
                                                    </div>
                                                </div>
                                                <div class="text-right">
                                                    <div class="flex items-center justify-end space-x-1 text-yellow-400 mb-1">
                                                        <c:forEach begin="1" end="${review.rating}">
                                                            <span>★</span>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="text-slate-600 text-sm">${review.createdAt}</span>
                                                </div>
                                            </div>
                                            <p class="text-slate-700 leading-relaxed">
                                                <c:choose>
                                                    <c:when test="${fn:length(review.content) > 180}">
                                                        ${fn:substring(review.content, 0, 180)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${review.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-purple-50 text-4xl">📝</div>
                                            <p class="mt-6 text-xl font-bold text-slate-800">조건에 맞는 리뷰가 없습니다</p>
                                            <p class="mt-2 text-sm text-slate-500">다른 조건으로 검색해보세요</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-4xl">🔍</div>
                                            <p class="mt-6 text-base text-slate-600">검색 조건을 입력한 뒤 검색 버튼을 눌러보세요</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:when test="${searchType == 'reservations'}">
                    <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8 border-b border-slate-100 pb-4">
                            <h2 class="text-2xl font-bold text-slate-900 md:text-3xl">예약 검색 결과</h2>
                            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600">
                                총 ${searchResults != null ? searchResults.size() : 0}건
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <div class="space-y-4">
                                    <c:forEach var="reservation" items="${searchResults}">
                                        <div class="overflow-hidden rounded-2xl border border-slate-100 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-lg flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                                            <div>
                                                <h3 class="text-lg font-semibold text-slate-800">${reservation.restaurantName}</h3>
                                                <p class="text-slate-600 text-sm">예약자: ${reservation.customerName} · 인원: ${reservation.partySize}명</p>
                                            </div>
                                            <div class="flex items-center gap-4">
                                                <div class="text-right">
                                                    <p class="text-slate-500 text-sm">${reservation.reservationTime}</p>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold ${reservation.status == 'CONFIRMED' ? 'bg-green-100 text-green-700' : reservation.status == 'PENDING' ? 'bg-yellow-100 text-yellow-700' : reservation.status == 'CANCELLED' ? 'bg-red-100 text-red-700' : 'bg-slate-100 text-slate-600'}">
                                                        ${reservation.status}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-emerald-50 text-4xl">📅</div>
                                            <p class="mt-6 text-xl font-bold text-slate-800">조건에 맞는 예약 내역이 없습니다</p>
                                            <p class="mt-2 text-sm text-slate-500">다른 기간으로 검색해보세요</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-4xl">🔍</div>
                                            <p class="mt-6 text-base text-slate-600">검색 조건을 입력한 뒤 검색 버튼을 눌러보세요</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:when test="${searchType == 'columns'}">
                    <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
                        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8 border-b border-slate-100 pb-4">
                            <h2 class="text-2xl font-bold text-slate-900 md:text-3xl">칼럼 검색 결과</h2>
                            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-medium text-slate-600">
                                총 ${searchResults != null ? searchResults.size() : 0}건
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach var="column" items="${searchResults}">
                                        <div class="overflow-hidden rounded-2xl border border-slate-100 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-lg">
                                            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-4">
                                                <div>
                                                    <h3 class="text-xl font-bold text-slate-800">${column.title}</h3>
                                                    <p class="text-slate-500 text-sm">작성자: ${column.author}</p>
                                                </div>
                                                <p class="text-slate-500 text-sm">${column.createdAt}</p>
                                            </div>
                                            <p class="text-slate-700 leading-relaxed mb-4">
                                                <c:choose>
                                                    <c:when test="${column.content != null && fn:length(column.content) > 200}">
                                                        ${fn:substring(column.content, 0, 200)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${column.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="flex items-center justify-between text-sm text-slate-500 mb-4">
                                                <span>조회수 ${column.views}</span>
                                                <span>좋아요 ${column.likes}</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/column/detail?id=${column.id}"
                                               class="btn-search inline-block text-center w-full py-3 text-sm">
                                                칼럼 보기
                                            </a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${submitted}">
                                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-orange-50 text-4xl">📰</div>
                                            <p class="mt-6 text-xl font-bold text-slate-800">조건에 맞는 칼럼이 없습니다</p>
                                            <p class="mt-2 text-sm text-slate-500">다른 키워드로 검색해보세요</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="flex flex-col items-center justify-center rounded-3xl border border-dashed border-slate-200 bg-slate-50/80 px-8 py-16 text-center">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-4xl">🔍</div>
                                            <p class="mt-6 text-base text-slate-600">검색 조건을 입력한 뒤 검색 버튼을 눌러보세요</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="glass-card p-8 rounded-3xl text-center">
                        <div class="empty-state">
                            <div class="empty-state-icon">👆</div>
                            <p class="text-slate-600">검색 유형을 선택하고 조건을 입력해 주세요</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        const contextPath = "${pageContext.request.contextPath}";
        let currentPage = 1;
        let kakaoPagination = null;
        let isLoading = false;
        let isDbSearchEnd = false;
        let isKakaoSearchEnd = false;
        let currentSearchCoords = null;
        let currentSearchCategory = '';
        let dbResultCount = 0;
        let extResultCount = 0;

        function setSearchType(type) {
            const hiddenTypeField = document.getElementById('activeSearchType');
            if (hiddenTypeField) {
                hiddenTypeField.value = type;
            }

            // 탭 활성화 상태 업데이트
            document.querySelectorAll('.search-tab').forEach(btn => {
                const isActive = btn.dataset.type === type;
                btn.classList.toggle('search-tab-active', isActive);
                btn.classList.toggle('type-' + btn.dataset.type, isActive);
                btn.setAttribute('aria-selected', isActive);
            });

            // 폼 섹션 표시/숨김
            document.querySelectorAll('.search-section').forEach(section => {
                const isActive = section.dataset.type === type;
                section.style.display = isActive ? 'block' : 'none';
                section.setAttribute('aria-hidden', !isActive);

                const typeInput = section.querySelector('input[name="type"]');
                if (typeInput) {
                    typeInput.value = section.dataset.type;
                }
            });

            // 필터 상태 업데이트
            updateActiveFilters();
        }

        function resetForm() {
            const activeType = document.getElementById('activeSearchType').value || 'restaurants';
            const activeSection = document.querySelector('.search-section[data-type="' + activeType + '"]');
            if (!activeSection) return;

            const form = activeSection.querySelector('form');
            if (form) {
                form.reset();
                const typeInput = form.querySelector('input[name="type"]');
                if (typeInput) {
                    typeInput.value = activeType;
                }
            }

            // 필터 칩 초기화
            updateActiveFilters();
        }

        // 적용된 필터를 시각적으로 표시
        function updateActiveFilters() {
            const filterChipsContainer = document.getElementById('filter-chips');
            const activeFiltersSection = document.getElementById('active-filters');
            filterChipsContainer.innerHTML = '';

            const form = document.querySelector('.search-section[style*="display: block"] form');
            if (!form) return;

            const filters = [];
            const formData = new FormData(form);

            formData.forEach((value, key) => {
                if (key !== 'type' && key !== 'submitted' && key !== 'sortBy' && value && value.trim() !== '') {
                    let label = key;
                    switch(key) {
                        case 'keyword': label = '키워드'; break;
                        case 'category': label = '카테고리'; break;
                        case 'price': label = '가격대'; break;
                        case 'parking': label = '주차'; break;
                        case 'minRating': label = '최소 평점'; break;
                        case 'maxRating': label = '최대 평점'; break;
                        case 'startDate': label = '시작일'; break;
                        case 'endDate': label = '종료일'; break;
                    }

                    // 값 표시 최적화
                    let displayValue = value;
                    if (key === 'parking') displayValue = value === 'true' ? '가능' : '불가';
                    if (key === 'price') {
                        const priceLabels = {'1': '~1만원', '2': '1~2만원', '3': '2~4만원', '4': '4만원 이상'};
                        displayValue = priceLabels[value] || value;
                    }

                    filters.push({ label, value: displayValue, key });
                }
            });

            if (filters.length > 0) {
                activeFiltersSection.classList.remove('hidden');
                filters.forEach(filter => {
                    const chip = document.createElement('span');
                    chip.className = 'filter-chip';
                    chip.innerHTML =
                        '<span>' + filter.label + ': ' + filter.value + '</span>' +
                        '<button ' +
                            'type="button" ' +
                            'onclick="removeFilter(\'' + filter.key + '\')" ' +
                            'aria-label="' + filter.label + ' 필터 제거">' +
                            '×' +
                        '</button>';
                    filterChipsContainer.appendChild(chip);
                });
            } else {
                activeFiltersSection.classList.add('hidden');
            }
        }

        function removeFilter(key) {
            const form = document.querySelector('.search-section[style*="display: block"] form');
            if (!form) return;

            const input = form.querySelector('[name="' + key + '"]');
            if (input) {
                if (input.tagName === 'SELECT') {
                    input.selectedIndex = 0;
                } else {
                    input.value = '';
                }
            }
            updateActiveFilters();
        }

        document.addEventListener('DOMContentLoaded', function () {
            const initialType = document.getElementById('activeSearchType').value || 'restaurants';
            setSearchType(initialType);

            // 초기 필터 상태 표시
            updateActiveFilters();

            // 모든 입력 필드에 change 이벤트 리스너 추가
            document.querySelectorAll('.search-section input, .search-section select').forEach(input => {
                input.addEventListener('change', updateActiveFilters);
                input.addEventListener('input', updateActiveFilters);
            });

            // 검색 폼 제출 이벤트 리스너 추가
            const searchForm = document.getElementById('form-restaurants').querySelector('form');
            searchForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const keyword = this.elements.keyword.value;
                const category = this.elements.category.value;
                performAjaxSearch(keyword, category);
            });

            // 더 보기 버튼 클릭 이벤트
            document.getElementById('load-more-btn').addEventListener('click', function() {
                if (!isLoading && (!isDbSearchEnd || !isKakaoSearchEnd)) {
                    isLoading = true;
                    this.innerHTML = '<span class="spinner"></span>';
                    this.disabled = true;
                    currentPage++;
                    if (kakaoPagination && !isKakaoSearchEnd) {
                        kakaoPagination.nextPage();
                    } else {
                        fetchDbResults(currentPage, currentSearchCoords, currentSearchCategory);
                    }
                }
            });

            // 검색 결과 컨테이너 초기화
            document.getElementById('restaurant-results-list').innerHTML = '';
            document.getElementById('no-restaurant-results').style.display = 'none';

            // 검색 결과가 있을 경우 렌더링
            const dbRestaurants = <%= gson.toJson(request.getAttribute("restaurants") != null ? request.getAttribute("restaurants") : new java.util.ArrayList<>()) %>;
            if (dbRestaurants.length > 0) {
                displayDbPlaces(dbRestaurants, contextPath);
            }

            // 장소 키워드 검색 로직
            const keyword = "${searchParams.keyword}";
            const category = "${searchParams.category}";
            const submitted = "${submitted}" === "true";

            if (submitted && keyword && keyword.trim() !== "") {
                performAjaxSearch(keyword, category);
            }

            // 페이지네이션으로 전달된 외부 결과 렌더링
            const externalRestaurants = <%= gson.toJson(request.getAttribute("externalRestaurants") != null ? request.getAttribute("externalRestaurants") : new java.util.ArrayList<>()) %>;
            if (externalRestaurants.length > 0) {
                displayPlaces(externalRestaurants, contextPath);
            }
        });

        function placesSearchCB(data, status, pagination) {
            const kakaoData = (status === kakao.maps.services.Status.OK) ? data : [];
            kakaoPagination = pagination;
            isKakaoSearchEnd = !pagination.hasNextPage;

            fetchDbResults(currentPage, currentSearchCoords, currentSearchCategory, function() {
                if (kakaoData.length > 0) {
                    const kakaoPlaces = kakaoData.map(function(p) { return ({
                        place_name: p.place_name, address_name: p.address_name,
                        road_address_name: p.road_address_name, phone: p.phone,
                        category_name: p.category_name, x: p.x, y: p.y
                    }); });
                    displayPlaces(kakaoPlaces, contextPath);
                }
                updateLoadMoreButtonState();
            });
        }

        function fetchDbResults(page, coords, category, callback) {
            if (isDbSearchEnd || !coords) {
                if (callback) callback();
                return;
            }

            const dbSearchUrl = contextPath + "/search/db-restaurants?lat=" + coords.lat + "&lng=" + coords.lng + "&level=8&category=" + (category || '전체') + "&page=" + page;
            fetch(dbSearchUrl)
                .then(response => response.json())
                .then(dbData => {
                    if (dbData && dbData.length > 0) {
                        displayDbPlaces(dbData, contextPath);
                    } else {
                        isDbSearchEnd = true;
                    }
                })
                .catch(() => { isDbSearchEnd = true; })
                .finally(() => {
                    if (callback) callback();
                });
        }

        function updateLoadMoreButtonState() {
            isLoading = false;
            const loadMoreBtn = document.getElementById('load-more-btn');
            const loadMoreContainer = document.getElementById('load-more-container');

            loadMoreBtn.textContent = '더 보기';
            loadMoreBtn.disabled = false;

            if (!isDbSearchEnd || !isKakaoSearchEnd) {
                loadMoreContainer.style.display = 'block';
            } else {
                loadMoreContainer.style.display = 'none';
                if (document.getElementById('restaurant-results-list').children.length === 0) {
                    document.getElementById('no-restaurant-results').style.display = 'block';
                }
            }
        }

        function performAjaxSearch(keyword, category) {
            if (!keyword || keyword.trim() === "") return;

            currentPage = 1;
            isDbSearchEnd = false;
            isKakaoSearchEnd = false;
            kakaoPagination = null;
            currentSearchCoords = null;
            dbResultCount = 0;
            extResultCount = 0;
            currentSearchCategory = category;
            document.getElementById('restaurant-results-list').innerHTML = '';
            document.getElementById('no-restaurant-results').style.display = 'none';
            document.getElementById('load-more-container').style.display = 'none';

            const newUrl = contextPath + "/search?type=restaurants&submitted=true&keyword=" + encodeURIComponent(keyword) + "&category=" + encodeURIComponent(category);
            history.pushState({keyword, category}, '', newUrl);

            const ps = new kakao.maps.services.Places();

            ps.keywordSearch(keyword, function(data, status) {
                if (status === kakao.maps.services.Status.OK && data.length > 0) {
                    const place = data[0];
                    currentSearchCoords = { lat: place.y, lng: place.x };

                    const externalSearchOptions = {
                        category_group_code: 'FD6',
                        location: new kakao.maps.LatLng(place.y, place.x),
                        radius: 2000
                    };
                    ps.keywordSearch(category || '맛집', placesSearchCB, externalSearchOptions);
                } else {
                    isKakaoSearchEnd = true;
                    fetchDbResults(1, null, category, updateLoadMoreButtonState);
                }
            });
        }

        function displayPlaces(places, contextPath) {
            const listEl = document.getElementById('restaurant-results-list');
            places.forEach((place, i) => {
                const placeName = place.place_name || place.name;
                const addressName = place.address_name || place.address;
                const phone = place.phone || '';
                const categoryName = place.category_name || place.category || '';
                const lat = place.y || place.latitude;
                const lng = place.x || place.longitude;

                if (document.querySelector('[data-place-name="' + placeName + '"]')) return;

                const detailUrl = contextPath + "/searchRestaurant/external-detail?name=" + encodeURIComponent(placeName) + "&address=" + encodeURIComponent(addressName) + "&phone=" + encodeURIComponent(phone) + "&category=" + encodeURIComponent(categoryName) + "&lat=" + lat + "&lng=" + lng;
                const uniqueId = "ext-" + extResultCount;
                extResultCount++;
                const placeholderUrl = "https://placehold.co/400x250/e2e8f0/94a3b8?text=Image";
                const errorImageUrl = "https://placehold.co/400x250/fecaca/991b1b?text=Error";

                const itemHtml =
                    '<div class="bg-white rounded-2xl overflow-hidden card-hover">' +
                        '<a href="' + detailUrl + '">' +
                            '<div class="h-48 w-full overflow-hidden" data-place-name="' + placeName + '">' +
                                '<img id="img-' + uniqueId + '" src="' + placeholderUrl + '" alt="' + placeName + '" class="w-full h-full object-cover" ' +
                                     'onerror="this.onerror=null;this.src=\'' + errorImageUrl + '\';" loading="lazy">' +
                            '</div>' +
                        '</a>' +
                        '<div class="p-6 space-y-3">' +
                            '<div class="flex items-center justify-between">' +
                                '<span class="px-3 py-1 rounded-full bg-purple-50 text-purple-600 text-xs font-semibold">외부 검색 결과</span>' +
                                '<span class="text-sm text-slate-500">' + (place.road_address_name || addressName).split(' ')[0] + '</span>' +
                            '</div>' +
                            '<h3 class="text-xl font-bold text-slate-800">' + placeName + '</h3>' +
                            '<div class="flex items-center space-x-2 text-sm">' +
                                '<span class="text-slate-500">' + (categoryName.split(' > ').pop()) + '</span>' +
                            '</div>' +
                            '<div class="flex items-center justify-between">' +
                                '<span class="text-slate-500 text-sm">' + (phone || '전화번호 정보 없음') + '</span>' +
                            '</div>' +
                            '<a href="' + detailUrl + '" class="btn-search text-center block w-full py-3 text-sm">상세 보기</a>' +
                        '</div>' +
                    '</div>';
                listEl.insertAdjacentHTML('beforeend', itemHtml);

                setTimeout(() => {
                    const searchQuery = placeName + " " + (addressName ? addressName.split(' ')[0] : '');
                    fetch(contextPath + "/search/image-proxy?query=" + encodeURIComponent(searchQuery))
                        .then(response => response.json())
                        .then(data => {
                            if (data && data.imageUrl) {
                                document.getElementById("img-" + uniqueId).src = data.imageUrl;
                            }
                        });
                }, i * 150);
            });
        }

        function displayDbPlaces(dbRestaurants, contextPath) {
            const listEl = document.getElementById('restaurant-results-list');
            dbRestaurants.forEach((r, i) => {
                const restaurantName = r.name;
                const uniqueId = "db-" + dbResultCount;
                dbResultCount++;
                if (document.querySelector('[data-place-name="' + restaurantName + '"]')) return;

                const detailUrl = contextPath + "/restaurant/detail/" + r.id;
                let imageUrl = 'https://placehold.co/400x250/e2e8f0/94a3b8?text=Loading...';
                if (r.image && r.image.trim() !== '') {
                    imageUrl = r.image.startsWith('http') ? r.image : contextPath + "/images/" + r.image;
                }

                const itemHtml =
                    '<div class="bg-white rounded-2xl overflow-hidden card-hover">' +
                        '<a href="' + detailUrl + '">' +
                            '<div class="h-48 w-full overflow-hidden" data-place-name="' + restaurantName + '">' +
                                '<img id="img-' + uniqueId + '" src="' + imageUrl + '" alt="' + r.name + '" class="w-full h-full object-cover" onerror="this.onerror=null;this.src=\'https://placehold.co/400x250/fecaca/991b1b?text=Error\';" loading="lazy">' +
                            '</div>' +
                        '</a>' +
                        '<div class="p-6 space-y-3">' +
                            '<div class="flex items-center justify-between">' +
                                '<span class="px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-semibold">' + (r.category || '') + '</span>' +
                                '<span class="text-sm text-slate-500">' + (r.location || '') + '</span>' +
                            '</div>' +
                            '<h3 class="text-xl font-bold text-slate-800">' + r.name + '</h3>' +
                            '<div class="flex items-center space-x-2 text-sm">' +
                                '<div class="flex space-x-1 text-yellow-400">' +
                                    '<span>★</span>'.repeat(Math.floor(r.rating || 0)) +
                                '</div>' +
                                '<span class="font-semibold text-slate-700">' + (r.rating || 0).toFixed(1) + '</span>' +
                                '<span class="text-slate-500">(' + (r.reviewCount || 0) + '개 리뷰)</span>' +
                            '</div>' +
                            '<div class="flex items-center justify-between">' +
                                '<span class="text-slate-500 text-sm">주차 ' + (r.parking ? '가능' : '불가') + '</span>' +
                                '<span class="text-slate-500 text-sm">찜 ' + (r.likes || 0) + '</span>' +
                            '</div>' +
                            '<a href="' + detailUrl + '" class="btn-search text-center block w-full py-3 text-sm">상세 보기</a>' +
                        '</div>' +
                    '</div>';
                listEl.insertAdjacentHTML('beforeend', itemHtml);

                if (!r.image || r.image.trim() === '') {
                    setTimeout(() => {
                        const searchQuery = r.name + " " + (r.address ? r.address.split(' ')[0] : '');
                        fetch(contextPath + "/search/image-proxy?query=" + encodeURIComponent(searchQuery))
                            .then(response => response.json())
                            .then(data => {
                                if (data && data.imageUrl) {
                                    document.getElementById("img-" + uniqueId).src = data.imageUrl;
                                }
                            });
                    }, i * 150);
                }
            });
        }
    </script>
</body>
</html>
