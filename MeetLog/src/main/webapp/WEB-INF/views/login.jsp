<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 로그인</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        /* 탭 활성화 시 적용될 스타일 */
        .tab-active {
            border-color: #0ea5e9; /* sky-500 */
            color: #0f172a; /* slate-900 */
        }
    </style>
</head>
<body class="bg-slate-50">
    <main class="flex items-center justify-center min-h-screen p-4">
        <div class="w-full max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 bg-white rounded-2xl shadow-xl overflow-hidden">
            
            <!-- 왼쪽 홍보 패널 (모바일에서는 숨김) -->
            <div class="hidden md:flex flex-col justify-center p-12 bg-sky-600 text-white">
                <a href="${pageContext.request.contextPath}/"><h1 class="text-4xl font-bold">MEET LOG</h1></a>
                <p class="mt-4 text-lg text-sky-100">로그인하고 나만의 맛집 지도와 미식 여정을 기록해보세요!</p>
                <div class="mt-8">
                    <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&auto=format&fit=crop&q=60" class="rounded-lg shadow-lg" alt="A vibrant restaurant scene">
                </div>
            </div>

            <!-- 오른쪽 로그인 폼 -->
            <div class="p-8 md:p-12 flex flex-col justify-center">
                <h2 class="text-3xl font-bold text-slate-800 mb-6">로그인</h2>

                <!-- 성공/에러 메시지 표시 -->
                <c:if test="${not empty successMessage}">
                    <div class="mb-4 p-3 bg-green-50 border border-green-200 text-green-700 text-sm rounded-lg">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 text-sm rounded-lg">${errorMessage}</div>
                </c:if>

                <!-- 탭 메뉴 -->
                <div class="border-b border-slate-200 mb-6">
                    <nav class="-mb-px flex space-x-6" id="login-tabs">
                        <button data-tab="personal" class="tab-active py-3 px-1 border-b-2 font-semibold text-sm">개인 회원</button>
                        <button data-tab="business" class="py-3 px-1 border-b-2 border-transparent text-slate-500 hover:text-slate-700 font-semibold text-sm">기업 회원</button>
                    </nav>
                </div>

                <!-- 개인 회원 로그인 폼 -->
                <div id="login-personal-content">
                    <form "${pageContext.request.contextPath}.do/login" method="post" class="space-y-5">
                        <input type="hidden" name="userType" value="PERSONAL">
                        <div>
                            <label for="personal-email" class="block text-sm font-medium text-slate-700">이메일</label>
                            <input type="email" id="personal-email" name="email" class="form-input mt-1" required>
                        </div>
                        <div>
                            <label for="personal-password" class="block text-sm font-medium text-slate-700">비밀번호</label>
                            <input type="password" id="personal-password" name="password" class="form-input mt-1" required>
                        </div>
                        <div>
                            <button type="submit" class="form-btn-primary w-full">로그인</button>
                        </div>
                    </form>
                </div>

                <!-- 기업 회원 로그인 폼 (초기에는 숨김) -->
                <div id="login-business-content" class="hidden">
                    <form "${pageContext.request.contextPath}.do/login" method="post" class="space-y-5">
                        <input type="hidden" name="userType" value="BUSINESS">
                        <div>
                            <label for="business-email" class="block text-sm font-medium text-slate-700">사업자 이메일</label>
                            <input type="email" id="business-email" name="email" class="form-input mt-1" required>
                        </div>
                        <div>
                            <label for="business-password" class="block text-sm font-medium text-slate-700">비밀번호</label>
                            <input type="password" id="business-password" name="password" class="form-input mt-1" required>
                        </div>
                        <div>
                            <button type="submit" class="form-btn-primary w-full">기업 로그인</button>
                        </div>
                    </form>
                </div>

                <div class="text-center text-sm text-slate-500 mt-6">
                    <a href="${pageContext.request.contextPath}/find-account" class="font-medium text-sky-600 hover:text-sky-500">아이디/비밀번호 찾기</a>
                </div>

                <div class="mt-6">
                    <div class="relative">
                        <div class="absolute inset-0 flex items-center"><div class="w-full border-t border-slate-200"></div></div>
                        <div class="relative flex justify-center text-sm"><span class="px-2 bg-white text-slate-400">또는</span></div>
                    </div>
                    <div class="mt-6 flex justify-center gap-4">
                        <a href="#" class="w-12 h-12 inline-flex items-center justify-center rounded-full bg-[#03C75A] hover:opacity-90" title="네이버로 로그인"><svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24"><path d="M16.273 12.845h-3.847V8.53h3.847v4.315zM17.155 6H6.845a.845.845 0 00-.845.845v10.31a.845.845 0 00.845.845h10.31a.845.845 0 00.845-.845V6.845A.845.845 0 0017.155 6zM13.31 15.47H9.463V8.53h5.59v2.158H13.31v4.782z"/></svg></a>
                        <a href="#" class="w-12 h-12 inline-flex items-center justify-center rounded-full bg-[#FEE500] hover:opacity-90" title="카카오로 로그인"><svg class="w-6 h-6" fill="#191919" viewBox="0 0 24 24"><path d="M12.4,12.3c0-1.8-1-3.2-2.3-3.2c-1.4,0-2.4,1.4-2.4,3.2c0,1.8,1,3.2,2.4,3.2C11.4,15.5,12.4,14.1,12.4,12.3 M18.4,12.3 c0-1.8-1-3.2-2.4-3.2c-1.4,0-2.4,1.4-2.4,3.2c0,1.8,1,3.2,2.4,3.2C17.4,15.5,18.4,14.1,18.4,12.3 M6.2,2.2C2.8,2.2,0,4.4,0,7.2 c0,2,1.7,3.6,4,4.1l-1,3.8l2.9-2.2c0.4,0,0.8,0.1,1.2,0.1c3.4,0,6.2-2.2,6.2-5C13.2,4.4,10,2.2,6.2,2.2 M24,7.2c0-2.8-2.8-5-6.2-5 c-3.4,0-6.2,2.2-6.2,5c0,2.1,1.8,3.9,4.3,4.8l-0.8,3.1l2.8-2.1c0.6,0.1,1.2,0.2,1.9,0.2C21.2,13,24,10.2,24,7.2"/></svg></a>
                        <a href="#" class="w-12 h-12 inline-flex items-center justify-center rounded-full border border-slate-200 hover:bg-slate-50" title="Google로 로그인"><svg class="w-6 h-6" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/><path fill="none" d="M1 1h22v22H1z"/></svg></a>
                    </div>
                </div>

                <div class="text-center text-sm text-slate-500 mt-8">
                    <p>아직 회원이 아니신가요? <a id="signup-link" href="${pageContext.request.contextPath}/register" class="font-bold text-sky-600 hover:text-sky-500">회원가입</a></p>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tabs = document.querySelectorAll('#login-tabs button');
            const personalContent = document.getElementById('login-personal-content');
            const businessContent = document.getElementById('login-business-content');
            const signupLink = document.getElementById('signup-link');

            tabs.forEach(clickedTab => {
                clickedTab.addEventListener('click', () => {
                    // 모든 탭 스타일 초기화
                    tabs.forEach(tab => {
                        tab.classList.remove('tab-active');
                        tab.classList.add('text-slate-500', 'border-transparent');
                    });
                    
                    // 클릭된 탭에 활성 스타일 적용
                    clickedTab.classList.add('tab-active');
                    clickedTab.classList.remove('text-slate-500', 'border-transparent');
                    
                    // 탭에 맞는 폼 보여주기 및 회원가입 링크 변경
                    if (clickedTab.dataset.tab === 'personal') {
                        personalContent.classList.remove('hidden');
                        businessContent.classList.add('hidden');
                        signupLink.href = '${pageContext.request.contextPath}/register';
                    } else {
                        personalContent.classList.add('hidden');
                        businessContent.classList.remove('hidden');
                        signupLink.href = '${pageContext.request.contextPath}/register?type=business'; // 기업회원 가입 페이지로 링크 변경
                    }
                });
            });
        });
    </script>
</body>
</html>
