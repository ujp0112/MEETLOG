<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - 내 가게 목록</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
}
</style>
</head>
<body class="bg-gray-100">

	<header class="bg-white shadow-sm">
		<div
			class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8 flex justify-between items-center">
			<a href="${pageContext.request.contextPath}/"
				class="text-2xl font-bold text-sky-600">MEET LOG</a> <a
				href="${pageContext.request.contextPath}/logout"
				class="text-sm font-medium text-gray-600 hover:text-gray-900">로그아웃</a>
		</div>
	</header>

	<main class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
		<div class="flex justify-between items-center mb-8">
			<h1 class="text-3xl font-bold text-gray-900">내 가게 목록</h1>
			<a href="${pageContext.request.contextPath}/business/restaurants/add"
				class="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700">
				+ 새 가게 등록하기 </a>
		</div>

		<div>
			<c:choose>
				<c:when test="${not empty myRestaurants}">
					<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
						<c:forEach var="restaurant" items="${myRestaurants}">
							<a
								href="${pageContext.request.contextPath}/business/dashboard?id=${restaurant.id}"
								class="block bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
								<%-- [수정] 이미지 표시 로직을 태그로 교체 --%>
                                <mytag:image fileName="${restaurant.image}" altText="${restaurant.name}" cssClass="h-40 w-full object-cover" />
								<div class="p-5">
									<h3 class="text-xl font-bold text-gray-900 truncate">${restaurant.name}</h3>
									<p class="mt-1 text-sm text-gray-600">${restaurant.category}
										• ${restaurant.location}</p>
									<p class="mt-2 text-xs text-gray-500 truncate">${restaurant.address}</p>
								</div>
							</a>
						</c:forEach>
					</div>
				</c:when>

				<c:otherwise>
					<div class="text-center bg-white shadow-md rounded-lg p-12">
						<h3 class="mt-2 text-lg font-medium text-gray-900">아직 등록된 가게가
							없습니다.</h3>
						<p class="mt-1 text-sm text-gray-500">'새 가게 등록하기' 버튼을 눌러 첫 가게를
							등록해보세요.</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>
</body>
</html>