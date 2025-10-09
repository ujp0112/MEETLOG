<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 비로그인 사용자용 로그인 유도 섹션 -->
<section class="my-16 bg-gradient-to-r from-purple-100 to-pink-100 p-12 rounded-2xl text-center shadow-lg">
    <div class="max-w-2xl mx-auto">
        <div class="text-5xl mb-4">🎯</div>
        <h2 class="text-3xl font-bold text-slate-900 mb-4">
            맞춤 추천을 받아보세요!
        </h2>
        <p class="text-lg text-slate-700 mb-6">
            AI가 분석한 나만의 취향 기반 맛집 추천을 받으려면<br>
            로그인이 필요합니다.
        </p>

        <!-- 혜택 안내 -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8 text-left">
            <div class="bg-white p-4 rounded-lg">
                <div class="text-2xl mb-2">🤖</div>
                <h3 class="font-bold text-slate-900 mb-1">AI 맞춤 추천</h3>
                <p class="text-sm text-slate-600">취향 분석 기반 맛집 추천</p>
            </div>
            <div class="bg-white p-4 rounded-lg">
                <div class="text-2xl mb-2">❤️</div>
                <h3 class="font-bold text-slate-900 mb-1">찜하기 & 팔로우</h3>
                <p class="text-sm text-slate-600">마음에 드는 맛집 저장</p>
            </div>
            <div class="bg-white p-4 rounded-lg">
                <div class="text-2xl mb-2">📝</div>
                <h3 class="font-bold text-slate-900 mb-1">리뷰 작성</h3>
                <p class="text-sm text-slate-600">나만의 맛집 기록 공유</p>
            </div>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 justify-center">
            <a href="${pageContext.request.contextPath}/login"
               class="inline-block bg-purple-600 text-white px-8 py-4 rounded-full font-bold text-lg
                      hover:bg-purple-700 transition shadow-lg hover:shadow-xl transform hover:scale-105">
                로그인하고 시작하기 →
            </a>
            <a href="${pageContext.request.contextPath}/register"
               class="inline-block bg-white text-purple-600 px-8 py-4 rounded-full font-bold text-lg
                      border-2 border-purple-600 hover:bg-purple-50 transition">
                회원가입
            </a>
        </div>
    </div>
</section>
