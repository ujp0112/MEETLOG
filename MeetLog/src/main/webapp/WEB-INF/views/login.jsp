<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - 로그인</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
}

.tab-active {
	border-color: #0ea5e9;
	color: #0f172a;
}

.form-input {
	display: block;
	width: 100%;
	border-radius: 0.5rem;
	border: 1px solid #cbd5e1;
	padding: 0.75rem 1rem;
	box-shadow: 0 1px 2px 0 rgb(0 0 0/ 0.05);
}

.form-input:focus {
	outline: 2px solid transparent;
	outline-offset: 2px;
	border-color: #38bdf8;
	box-shadow: 0 0 0 2px #7dd3fc;
}

.form-btn-primary {
	display: inline-flex;
	width: 100%;
	justify-content: center;
	border-radius: 0.5rem;
	background-color: #0284c7;
	padding: 0.75rem 1rem;
	font-size: 0.875rem;
	font-weight: 600;
	color: white;
	box-shadow: 0 1px 2px 0 rgb(0 0 0/ 0.05);
}

.form-btn-primary:hover {
	background-color: #0369a1;
}
/* 소셜 로그인 버튼 공통 스타일 */
.social-btn-container {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	border-radius: 0.5rem; /* 버튼 모서리 둥글게 */
	padding: 0.625rem 1rem; /* 상하 10px, 좌우 16px 패딩 */
	font-size: 0.95rem; /* 폰트 크기 */
	font-weight: 500;
	box-shadow: 0 1px 2px 0 rgb(0 0 0/ 0.05); /* 그림자 효과 */
	border: 1px solid #E2E8F0; /* 기본 테두리 색상 */
	transition: opacity 0.2s; /* 호버 시 부드러운 전환 */
	height: 48px; /* 버튼 높이 고정 (더 크게 보이도록) */
	cursor: pointer; /* 클릭 가능한 요소임을 나타냄 */
	text-decoration: none; /* 링크 밑줄 제거 */
}

.social-btn-container:hover {
	opacity: 0.9;
}

.social-btn-container img {
	height: 45px; /* 이미지 높이를 버튼 높이에 맞춤 */
	width: 200px; /* 너비는 비율 유지 */
	display: block; /* 이미지 정렬을 위해 */
}

/* 네이버 버튼 전용 스타일 */
.btn-naver-full {
	background-color: #03C75A;
	border-color: #03C75A;
}
/* 카카오 버튼 전용 스타일 */
.btn-kakao-full {
	background-color: #FEE500;
	border-color: #FEE500;
}
/* 구글 버튼 전용 스타일 */
.btn-google-full {
	background-color: #f2f2f2; /* 구글은 흰색 배경 */
	border-color: #E2E8F0; /* slate-200 테두리 */
}
</style>
</head>
<body class="bg-slate-50">
	<main class="flex items-center justify-center min-h-screen p-4">
		<div
			class="w-full max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 bg-white rounded-2xl shadow-xl overflow-hidden">

			<div
				class="hidden md:flex flex-col justify-center p-12 bg-sky-600 text-white">
				<a href="${pageContext.request.contextPath}/"><h1
						class="text-4xl font-bold">MEET LOG</h1></a>
				<p class="mt-4 text-lg text-sky-100">로그인하고 나만의 맛집 지도와 미식 여정을
					기록해보세요!</p>
				<div class="mt-8">
					<img
						src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&auto=format&fit=crop&q=60"
						class="rounded-lg shadow-lg" alt="A vibrant restaurant scene">
				</div>
			</div>

			<div class="p-8 md:p-12 flex flex-col justify-center">
				<h2 class="text-3xl font-bold text-slate-800 mb-6">로그인</h2>
				<c:if test="${not empty successMessage}">
					<div
						class="mb-4 p-3 bg-green-50 border border-green-200 text-green-700 text-sm rounded-lg">${successMessage}</div>
				</c:if>
				<c:if test="${not empty errorMessage}">
					<div
						class="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 text-sm rounded-lg">${errorMessage}</div>
				</c:if>

				<div class="border-b border-slate-200 mb-6">
					<nav class="-mb-px flex space-x-6" id="login-tabs">
						<button data-tab="personal"
							class="tab-active py-3 px-1 border-b-2 font-semibold text-sm">개인
							회원</button>
						<button data-tab="business"
							class="py-3 px-1 border-b-2 border-transparent text-slate-500 hover:text-slate-700 font-semibold text-sm">기업
							회원</button>
					</nav>
				</div>

				<div id="login-personal-content">
					<form action="${pageContext.request.contextPath}/login"
						method="post" class="space-y-5">
						<c:set var="redirectUrlValue"
							value="${not empty sessionScope.redirectUrl ? sessionScope.redirectUrl : requestScope.redirectUrl}" />
						<c:if test="${not empty redirectUrlValue}">
							<input type="hidden" name="redirectUrl"
								value="<c:out value='${redirectUrlValue}' />" />
						</c:if>
						<input type="hidden" name="userType" value="PERSONAL">
						<div>
							<label for="personal-email"
								class="block text-sm font-medium text-slate-700">이메일</label> <input
								type="email" id="personal-email" name="email"
								class="form-input mt-1" required>
						</div>
						<div>
							<label for="personal-password"
								class="block text-sm font-medium text-slate-700">비밀번호</label> <input
								type="password" id="personal-password" name="password"
								class="form-input mt-1" required>
						</div>
						<div>
							<button type="submit" class="form-btn-primary w-full">로그인</button>
						</div>
					</form>
				</div>

				<div id="login-business-content" class="hidden">
					<form action="${pageContext.request.contextPath}/login"
						method="post" class="space-y-5">
						<c:set var="redirectUrlValue"
							value="${not empty sessionScope.redirectUrl ? sessionScope.redirectUrl : requestScope.redirectUrl}" />
						<c:if test="${not empty redirectUrlValue}">
							<input type="hidden" name="redirectUrl"
								value="<c:out value='${redirectUrlValue}' />" />
						</c:if>
						<input type="hidden" name="userType" value="BUSINESS">
						<div>
							<label for="business-email"
								class="block text-sm font-medium text-slate-700">이메일</label> <input
								type="email" id="business-email" name="email"
								class="form-input mt-1" required>
						</div>
						<div>
							<label for="business-password"
								class="block text-sm font-medium text-slate-700">비밀번호</label> <input
								type="password" id="business-password" name="password"
								class="form-input mt-1" required>
						</div>
						<div>
							<button type="submit" class="form-btn-primary w-full">기업
								로그인</button>
						</div>
					</form>
				</div>

				<div class="text-center text-sm text-slate-500 mt-6">
					<a href="${pageContext.request.contextPath}/find-account"
						class="font-medium text-sky-600 hover:text-sky-500">아이디/비밀번호
						찾기</a>
				</div>

				<div class="mt-6" id="social-login-section">
					<%-- [수정] ID 추가 --%>
					<div class="relative">
						<div class="absolute inset-0 flex items-center">
							<div class="w-full border-t border-slate-200"></div>
						</div>
						<div class="relative flex justify-center text-sm">
							<span class="px-2 bg-white text-slate-400">또는</span>
						</div>
					</div>
					<div class="mt-6 space-y-3">
						<a href="${pageContext.request.contextPath}/auth/login/naver"
							class="social-btn-container btn-naver-full" title="네이버로 로그인">
							<img
							src="${pageContext.request.contextPath}/img/btn_naver_logo.png"
							alt="네이버로 로그인">
						</a> <a href="${pageContext.request.contextPath}/auth/login/kakao"
							class="social-btn-container btn-kakao-full" title="카카오로 로그인">
							<img src="${pageContext.request.contextPath}/img/kakao_login.png"
							alt="카카오로 로그인">
						</a> <a href="${pageContext.request.contextPath}/auth/login/google"
							class="social-btn-container btn-google-full" title="Google로 로그인">
							<img
							src="${pageContext.request.contextPath}/img/btn_google_logo.svg"
							alt="Google로 로그인">
						</a>
					</div>
				</div>

				<div class="text-center text-sm text-slate-500 mt-8">
					<p>
						아직 회원이 아니신가요? <a id="signup-link"
							href="${pageContext.request.contextPath}/register"
							class="font-bold text-sky-600 hover:text-sky-500">회원가입</a>
					</p>
				</div>
			</div>

		</div>
	</main>
	<script>
    document.addEventListener('DOMContentLoaded', function () {
        const tabs = document.querySelectorAll('#login-tabs button');
        const personalContent = document.getElementById('login-personal-content');
        const businessContent = document.getElementById('login-business-content');
        const signupLink = document.getElementById('signup-link');
        const socialLoginSection = document.getElementById('social-login-section'); // [추가] 소셜 로그인 영역 변수

        tabs.forEach(clickedTab => {
            clickedTab.addEventListener('click', () => {
                tabs.forEach(tab => {
                    tab.classList.remove('tab-active');
                    tab.classList.add('text-slate-500', 'border-transparent');
                });

                clickedTab.classList.add('tab-active');
				clickedTab.classList.remove('text-slate-500', 'border-transparent');

                if (clickedTab.dataset.tab === 'personal') {
                    personalContent.classList.remove('hidden');
					businessContent.classList.add('hidden');
                    socialLoginSection.classList.remove('hidden'); // [추가] 개인 탭 클릭 시 소셜 로그인 보이기
                    signupLink.href = '${pageContext.request.contextPath}/register';
                } else {
                    personalContent.classList.add('hidden');
					businessContent.classList.remove('hidden');
                    socialLoginSection.classList.add('hidden'); // [추가] 기업 탭 클릭 시 소셜 로그인 숨기기
                    signupLink.href = '${pageContext.request.contextPath}/business-register';
                }
            });
        });
    });
</script>
</body>
</html>