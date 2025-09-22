<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 아이디/비밀번호 찾기</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        /* 탭 활성화 스타일 */
        .tab-active {
            border-color: #0ea5e9; /* sky-500 */
            color: #0f172a; /* slate-900 */
        }
    </style>
</head>
<body class="bg-slate-100">
    <main class="flex items-center justify-center min-h-screen p-4">
        <div class="w-full max-w-md bg-white rounded-2xl shadow-lg p-8 space-y-6">
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/" class="inline-block">
                    <h1 class="text-3xl font-bold text-sky-600 mb-2">MEET LOG</h1>
                </a>
                <h2 class="text-2xl font-bold text-slate-800">계정 찾기</h2>
            </div>

            <!-- 성공/에러 메시지 표시 영역 -->
            <c:if test="${not empty successMessage}">
                <div class="p-4 bg-green-50 border border-green-200 text-green-700 rounded-lg text-sm">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="p-4 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">${errorMessage}</div>
            </c:if>

            <!-- 탭 메뉴 -->
            <div class="border-b border-slate-200">
                <nav class="-mb-px flex space-x-6" id="search-tabs">
                    <button data-tab="findId" class="tab-active py-3 px-1 border-b-2 font-semibold text-sm">아이디 찾기</button>
                    <button data-tab="findPw" class="py-3 px-1 border-b-2 border-transparent text-slate-500 hover:text-slate-700 font-semibold text-sm">비밀번호 찾기</button>
                </nav>
            </div>

            <!-- 아이디 찾기 폼 -->
            <div id="findId-content">
                <form "${pageContext.request.contextPath}.do/find-account" method="post" class="space-y-5">
                    <input type="hidden" name="action" value="findId">
                    <div>
                        <label for="nickname" class="block text-sm font-medium text-slate-700">닉네임</label>
                        <input type="text" id="nickname" name="nickname" required
                               class="form-input mt-1"
                               placeholder="가입 시 사용한 닉네임을 입력하세요">
                    </div>
                    <div>
                        <button type="submit" class="form-btn-primary w-full">아이디 찾기</button>
                    </div>
                </form>
            </div>

            <!-- 비밀번호 찾기 폼 (초기에는 숨김) -->
            <div id="findPw-content" class="hidden">
                <form "${pageContext.request.contextPath}.do/find-account" method="post" class="space-y-5">
                    <input type="hidden" name="action" value="findPw">
                    <div>
                        <label for="email" class="block text-sm font-medium text-slate-700">이메일</p>
                        <input type="email" id="email" name="email" required
                               class="form-input mt-1"
                               placeholder="가입 시 사용한 이메일을 입력하세요">
                    </div>
                     <div>
                        <button type="submit" class="form-btn-primary w-full">임시 비밀번호 발급</button>
                    </div>
                </form>
            </div>

            <div class="text-center pt-4">
                <a href="${pageContext.request.contextPath}/login" class="text-sm font-medium text-sky-600 hover:text-sky-500">
                    로그인 페이지로 돌아가기
                </a>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tabs = document.querySelectorAll('#search-tabs button');
            const findIdContent = document.getElementById('findId-content');
            const findPwContent = document.getElementById('findPw-content');

            tabs.forEach(clickedTab => {
                clickedTab.addEventListener('click', () => {
                    // 모든 탭의 활성 스타일 초기화
                    tabs.forEach(tab => {
                        tab.classList.remove('tab-active');
                        tab.classList.add('text-slate-500', 'border-transparent');
                    });
                    
                    // 클릭된 탭에만 활성 스타일 적용
                    clickedTab.classList.add('tab-active');
                    clickedTab.classList.remove('text-slate-500', 'border-transparent');
                    
                    // 탭에 맞는 컨텐츠 보여주기
                    if (clickedTab.dataset.tab === 'findId') {
                        findIdContent.classList.remove('hidden');
                        findPwContent.classList.add('hidden');
                    } else {
                        findIdContent.classList.add('hidden');
                        findPwContent.classList.remove('hidden');
                    }
                });
            });
        });
    </script>
</body>
</html>
