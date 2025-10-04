<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 빈 상태: 맞춤 추천 없을 때 (개선된 버전) -->
<div class="bg-gradient-to-br from-purple-50 to-pink-50 p-8 rounded-2xl shadow-lg text-center">
    <div class="text-5xl mb-4">✨</div>
    <h3 class="text-2xl font-bold text-slate-900 mb-3">
        맞춤 추천을 받아보세요!
    </h3>
    <p class="text-slate-700 mb-6 max-w-md mx-auto">
        <strong>3개 이상의 리뷰</strong>를 작성하면<br>
        AI가 ${user.nickname}님의 취향을 분석해 드립니다.
    </p>

    <!-- 진행 상황 표시 -->
    <div class="mb-6">
        <div class="flex justify-center items-center gap-2 mb-2">
            <c:set var="reviewCount" value="${userReviewCount != null ? userReviewCount : 0}" />
            <c:forEach begin="1" end="3" var="i">
                <div class="w-12 h-12 rounded-full flex items-center justify-center font-bold
                            ${reviewCount >= i ? 'bg-green-500 text-white' : 'bg-slate-200 text-slate-400'}">
                    ${reviewCount >= i ? '✓' : i}
                </div>
            </c:forEach>
        </div>
        <p class="text-sm text-slate-600">
            ${reviewCount}개 작성 완료, ${3 - reviewCount > 0 ? 3 - reviewCount : 0}개 남았어요!
        </p>
    </div>

    <!-- CTA 버튼 -->
    <div class="flex flex-col sm:flex-row gap-3 justify-center">
        <a href="${pageContext.request.contextPath}/restaurant/list"
           class="bg-purple-600 text-white px-6 py-3 rounded-lg font-bold hover:bg-purple-700 transition">
            리뷰 쓰러 가기
        </a>
        <a href="${pageContext.request.contextPath}/restaurant/list"
           class="bg-white text-purple-600 px-6 py-3 rounded-lg font-bold border-2 border-purple-600 hover:bg-purple-50 transition">
            둘러보기
        </a>
    </div>
</div>
