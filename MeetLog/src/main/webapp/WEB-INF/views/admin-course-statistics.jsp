<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 코스 통계</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-100">
<c:set var="adminMenu" scope="request" value="course" />
<div class="min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/admin/include/admin-navbar.jspf" %>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">
        <c:set var="subNavBase" value="px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition" />
        <c:set var="subNavActive" value="px-3 py-2 text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg border border-blue-100" />
        <div class="px-4 py-6 sm:px-0">
            <div class="flex flex-col gap-4 mb-6">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <h2 class="text-2xl font-bold text-gray-900">코스 통계</h2>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/course-management"
                       class="${subNavBase}">코스 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/course-reservation"
                       class="${subNavBase}">예약 관리</a>
                    <a href="${pageContext.request.contextPath}/admin/reservation-statistics"
                       class="${subNavBase}">예약 통계</a>
                    <a href="${pageContext.request.contextPath}/admin/course-statistics"
                       class="${subNavActive}">코스 통계</a>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5 flex items-center">
                        <div class="flex-shrink-0">
                            <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center text-white text-lg">
                                👥
                            </div>
                        </div>
                        <div class="ml-5">
                            <dt class="text-sm font-medium text-gray-500">총 회원 수</dt>
                            <dd class="text-xl font-semibold text-gray-900">${dashboardData.totalUsers}</dd>
                        </div>
                    </div>
                </div>
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5 flex items-center">
                        <div class="flex-shrink-0">
                            <div class="w-10 h-10 bg-green-500 rounded-lg flex items-center justify-center text-white text-lg">
                                🏪
                            </div>
                        </div>
                        <div class="ml-5">
                            <dt class="text-sm font-medium text-gray-500">등록된 맛집</dt>
                            <dd class="text-xl font-semibold text-gray-900">${dashboardData.totalRestaurants}</dd>
                        </div>
                    </div>
                </div>
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5 flex items-center">
                        <div class="flex-shrink-0">
                            <div class="w-10 h-10 bg-yellow-500 rounded-lg flex items-center justify-center text-white text-lg">
                                ⭐
                            </div>
                        </div>
                        <div class="ml-5">
                            <dt class="text-sm font-medium text-gray-500">총 리뷰 수</dt>
                            <dd class="text-xl font-semibold text-gray-900">${dashboardData.totalReviews}</dd>
                        </div>
                    </div>
                </div>
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-5 flex items-center">
                        <div class="flex-shrink-0">
                            <div class="w-10 h-10 bg-purple-500 rounded-lg flex items-center justify-center text-white text-lg">
                                📅
                            </div>
                        </div>
                        <div class="ml-5">
                            <dt class="text-sm font-medium text-gray-500">총 예약 수</dt>
                            <dd class="text-xl font-semibold text-gray-900">${dashboardData.totalReservations}</dd>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white shadow rounded-lg mb-8">
                <div class="px-4 py-5 sm:p-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">월별 사용자 트렌드</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="p-4 bg-gray-50 rounded-lg">
                            <p class="text-sm text-gray-500">신규 가입자</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.monthlyNewUsers}</p>
                        </div>
                        <div class="p-4 bg-gray-50 rounded-lg">
                            <p class="text-sm text-gray-500">활성 사용자</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.activeUsers}</p>
                        </div>
                        <div class="p-4 bg-gray-50 rounded-lg">
                            <p class="text-sm text-gray-500">재방문율</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.returnRate}%</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white shadow rounded-lg mb-8">
                <div class="px-4 py-5 sm:p-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">인기 맛집 Top 3</h3>
                    <div class="space-y-4">
                        <c:forEach var="restaurant" items="${popularRestaurants}" varStatus="status">
                            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                <div class="flex items-center">
                                    <span class="text-lg font-bold text-gray-900 mr-4">${status.index + 1}</span>
                                    <div>
                                        <p class="text-sm font-semibold text-gray-900">${restaurant.name}</p>
                                        <p class="text-xs text-gray-500">예약 ${restaurant.reservationCount}건 • 리뷰 ${restaurant.reviewCount}건</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="text-sm font-semibold text-gray-900">평점 ${restaurant.rating}</p>
                                    <p class="text-xs text-gray-500">최근 7일 +${restaurant.reservationGrowth}%</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="bg-white shadow rounded-lg mb-8">
                <div class="px-4 py-5 sm:p-6">
                    <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">사용자 활동 요약</h3>
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                        <div class="p-4 bg-gray-50 rounded-lg text-center">
                            <p class="text-sm text-gray-500">작성된 리뷰</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.reviewsToday}</p>
                        </div>
                        <div class="p-4 bg-gray-50 rounded-lg text-center">
                            <p class="text-sm text-gray-500">생성된 코스</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.coursesCreatedToday}</p>
                        </div>
                        <div class="p-4 bg-gray-50 rounded-lg text-center">
                            <p class="text-sm text-gray-500">저장된 위시리스트</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.wishlistSaves}</p>
                        </div>
                        <div class="p-4 bg-gray-50 rounded-lg text-center">
                            <p class="text-sm text-gray-500">신규 팔로우</p>
                            <p class="text-2xl font-semibold text-gray-900">${dashboardData.newFollows}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>

<jsp:include page="/WEB-INF/views/common/loading.jsp" />

</body>
</html>
