<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - 나에게 꼭 맞는 맛집</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

	<div id="app">
		<main>
			<section
				class="relative bg-sky-600 text-white text-center py-20 md:py-32 overflow-hidden">
				<div class="absolute inset-0">
					<img
						src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1974&auto=format&fit=crop"
						class="w-full h-full object-cover opacity-30" alt="맛있는 음식">
					<div
						class="absolute inset-0 bg-gradient-to-t from-slate-900 via-slate-900/60 to-transparent"></div>
				</div>
				<div class="relative container mx-auto px-4">
					<h1 class="text-4xl md:text-6xl font-bold mb-4">나에게 꼭 맞는 맛집,
						MEET LOG</h1>
					<p class="text-lg md:text-xl text-slate-300 mb-8 max-w-3xl mx-auto">
						수많은 정보 속에서 진짜 맛집을 찾기 힘드셨나요? MEET LOG가 당신의 완벽한 맛집 탐색을 도와드립니다.</p>
					<div>
						<a href="${pageContext.request.contextPath}/main"
							class="form-btn-primary text-lg px-8 py-3"> 둘러보기 </a> <a
							href="${pageContext.request.contextPath}/login"
							class="ml-4 text-white font-semibold hover:underline"> 로그인 </a>
					</div>
				</div>
			</section>

			<section class="py-16 bg-slate-50">
				<div class="container mx-auto px-4">
					<div class="text-center mb-12">
						<h2 class="text-3xl font-bold">MEET LOG의 특별한 기능</h2>
					</div>
					<div class="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
						<div class="bg-white p-8 rounded-xl shadow-lg">
							<div class="text-4xl mb-4">🔎</div>
							<h3 class="text-xl font-bold mb-2">정확한 맛집 추천</h3>
							<p class="text-slate-600 text-sm">빅데이터 기반으로 당신의 취향에 맞는 맛집을
								찾아드립니다.</p>
						</div>
						<div class="bg-white p-8 rounded-xl shadow-lg">
							<div class="text-4xl mb-4">📅</div>
							<h3 class="text-xl font-bold mb-2">간편한 예약</h3>
							<p class="text-slate-600 text-sm">마음에 드는 맛집을 발견했다면, 그 자리에서 바로
								예약까지 완료하세요.</p>
						</div>
						<div class="bg-white p-8 rounded-xl shadow-lg">
							<div class="text-4xl mb-4">🧑‍🤝‍🧑</div>
							<h3 class="text-xl font-bold mb-2">나만의 맛 칼럼니스트</h3>
							<p class="text-slate-600 text-sm">나와 입맛이 비슷한 사용자를 팔로우하고, 그들만의
								맛집 지도를 공유받으세요.</p>
						</div>
					</div>
				</div>
			</section>

			<section class="bg-white py-16">
				<div class="container mx-auto px-4 text-center">
					<h3 class="text-3xl font-bold">실패 없는 맛집 탐색을 시작해볼까요?</h3>
					<a href="${pageContext.request.contextPath}/register"
						class="mt-8 inline-block bg-sky-600 text-white font-bold py-4 px-10 rounded-full hover:bg-sky-700">
						무료로 회원가입 </a>
				</div>
			</section>
		</main>

		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	</div>

</body>
</html>