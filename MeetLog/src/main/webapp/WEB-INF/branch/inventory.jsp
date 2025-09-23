<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="pageSize" value="10" />
<c:set var="currentPage" value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}" />
<c:set var="totalCount" value="${empty requestScope.totalCount ? 0 : requestScope.totalCount}" />
<c:set var="totalPages" value="${(totalCount + pageSize - 1) / pageSize}" />
<c:set var="shownCount" value="${empty inventories ? 0 : fn:length(inventories)}" />
<c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}" />
<c:set var="endIndex" value="${shownCount > 0 ? (startIndex + shownCount - 1) : 0}" />
<c:set var="hasPrev" value="${currentPage > 1}" />
<c:set var="hasNext" value="${currentPage < totalPages}" />
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}" />
<c:set var="nextPage" value="${hasNext ? (currentPage + 1) : totalPages}" />
<c:set var="baseUrl" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MEET LOG - 재고량</title>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
        <section class="panel">
            <div class="hd">
                <h1 class="title" id="pageTitle">재고량</h1>
            </div>
            <div class="bd">
                <div class="table-wrap" role="region" aria-label="재고 목록">
                    <table class="sheet" role="grid" id="inventoryTable">
                        <thead>
                            <tr>
                                <th style="width: 60px">이미지</th>
                                <th>재료명</th>
                                <th style="width: 100px">단위</th>
                                <th class="cell-num" style="width: 160px">현재 재고</th>
                                <th class="cell-num" style="width: 140px">안전 재고</th>
                                <th style="width: 140px">최근 변경일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="it" items="${inventories}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty it.imgPath}">
                                                <mytag:image fileName="${it.imgPath}" altText="${it.name}" cssClass="thumb" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="thumb" style="display: grid; place-items: center">📦</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${it.name}</td>
                                    <td>${it.unit}</td>
                                    <td class="cell-num"><fmt:formatNumber value="${it.qty}" /> <span style="color: #64748b">${it.unit}</span></td>
                                    <td class="cell-num">N/A</td>
                                    <td>N/A</td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty inventories}">
                                <tr><td colspan="6" style="text-align:center; padding: 48px; color: var(--muted);">재고 정보가 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalCount > 0}">
                    <div class="pager" id="mainPager">
                        <div class="left">
                            <span class="info">${startIndex}–${endIndex} / ${totalCount} (페이지 ${currentPage} / <fmt:formatNumber value='${totalPages}' maxFractionDigits='0' />)</span>
                        </div>
                        <div class="right">
                            <div class="btn-group">
                                <c:url var="firstUrl" value="${baseUrl}"><c:param name="page" value="1" /></c:url>
                                <c:url var="prevUrl" value="${baseUrl}"><c:param name="page" value="${prevPage}" /></c:url>
                                <c:url var="nextUrl" value="${baseUrl}"><c:param name="page" value="${nextPage}" /></c:url>
                                <c:url var="lastUrl" value="${baseUrl}"><c:param name="page" value="${totalPages}" /></c:url>
                                
                                <a class="btn sm" href="${firstUrl}" aria-disabled="${not hasPrev}">≪</a>
                                <a class="btn sm" href="${prevUrl}" aria-disabled="${not hasPrev}">‹</a>
                                <a class="btn sm" href="${nextUrl}" aria-disabled="${not hasNext}">›</a>
                                <a class="btn sm" href="${lastUrl}" aria-disabled="${not hasNext}">≫</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
    </div>
</body>
</html>