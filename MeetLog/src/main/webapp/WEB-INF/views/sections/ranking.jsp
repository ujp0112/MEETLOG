<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>

<!-- 실시간 맛집 랭킹 섹션 -->
<section class="mb-12" aria-labelledby="ranking-title">
    <h2 id="ranking-title" class="text-2xl md:text-3xl font-bold mb-6">
        실시간 맛집 랭킹 TOP 10
    </h2>
    <div class="flex space-x-4 overflow-x-auto pb-4 -mx-4 px-4 horizontal-scroll"
         role="region"
         aria-label="실시간 맛집 랭킹 목록">
        <c:choose>
            <c:when test="${not empty topRankedRestaurants}">
                <c:forEach var="r" items="${topRankedRestaurants}" varStatus="status">
                    <a href="${pageContext.request.contextPath}/restaurant/detail/${r.id}"
                       class="flex-shrink-0 w-60 bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 transition-transform duration-300 group"
                       aria-label="${status.count}위 맛집 ${r.name}, ${r.location} 위치, 평점 ${r.rating}점">
                        <div class="relative">
                            <mytag:image fileName="${r.image}"
                                       altText="${status.count}위 맛집 ${r.name}"
                                       cssClass="w-full h-36 object-cover group-hover:opacity-90 transition-opacity" />
                            <div class="absolute top-2 left-2 bg-black bg-opacity-60 text-white text-lg font-bold w-8 h-8 flex items-center justify-center rounded-full shadow-lg"
                                 aria-label="${status.count}위">
                                <span aria-hidden="true">${status.count}</span>
                            </div>
                            <div class="absolute bottom-0 left-0 right-0 p-3 bg-gradient-to-t from-black/70 to-transparent">
                                <h3 class="text-white text-lg font-bold truncate">${r.name}</h3>
                                <p class="text-white text-sm opacity-90">${r.location}</p>
                            </div>
                        </div>
                        <div class="p-3">
                            <p class="text-sm text-slate-600 truncate">
                                ❤️ <fmt:formatNumber value="${r.likes}" type="number" />명이 좋아해요
                            </p>
                            <div class="text-base font-bold text-sky-600 mt-2">
                                ⭐ ${r.rating}점
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="text-slate-500 py-8">인기 맛집 정보를 불러오고 있습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</section>
