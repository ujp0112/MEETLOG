<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 전체 페이지가 1개 이상일 때만 페이지네이션을 표시합니다. --%>
<c:if test="${totalPages > 1}">

    <%-- 페이지 번호 표시 범위를 계산합니다. (현재 페이지 기준 앞뒤 2개) --%>
    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}" />
    <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" />

    <div class="flex justify-center items-center space-x-2 mt-8">
        <c:choose>
            <c:when test="${currentPage > 1}">
                <a href="${baseUrl}?page=${currentPage - 1}" class="pagination-link">이전</a>
            </c:when>
            <c:otherwise>
                <span class="pagination-disabled">이전</span>
            </c:otherwise>
        </c:choose>

        <c:if test="${startPage > 1}">
            <a href="${baseUrl}?page=1" class="pagination-link">1</a>
            <c:if test="${startPage > 2}">
                <span class="pagination-ellipsis">...</span>
            </c:if>
        </c:if>

        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="pagination-active">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="${baseUrl}?page=${i}" class="pagination-link">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${endPage < totalPages}">
            <c:if test="${endPage < totalPages - 1}">
                <span class="pagination-ellipsis">...</span>
            </c:if>
            <a href="${baseUrl}?page=${totalPages}" class="pagination-link">${totalPages}</a>
        </c:if>

        <c:choose>
            <c:when test="${currentPage < totalPages}">
                <a href="${baseUrl}?page=${currentPage + 1}" class="pagination-link">다음</a>
            </c:when>
            <c:otherwise>
                <span class="pagination-disabled">다음</span>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="text-center text-sm text-slate-500 mt-4">
        페이지 ${currentPage} / ${totalPages}
    </div>
</c:if>