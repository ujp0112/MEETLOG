<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="pageSize" value="10" />
<c:set var="currentPage" value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}" />
<c:set var="totalCount" value="${empty requestScope.totalCount ? 0 : requestScope.totalCount}" />
<c:set var="totalPages" value="${(totalCount + pageSize - 1) / pageSize}" />
<c:set var="shownCount" value="${empty orders ? 0 : fn:length(orders)}" />
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
    <title>MEET LOG - 발주 기록</title>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf" %>
    <div class="container">
        <section class="panel" style="max-width: 1100px;">
            <div class="hd">
                <h1 class="title" id="pageTitle">발주 기록</h1>
            </div>
            <div class="bd">
                <div class="table-wrap">
                    <table class="sheet" id="ordersHistoryTable">
                        <thead>
                            <tr>
                                <th style="width: 120px">발주 No.</th>
                                <th>품명</th>
                                <th class="cell-num" style="width: 120px">총 가격</th>
                                <th style="width: 140px">발주일</th>
                                <th style="width: 120px">상태</th>
                                <th style="width: 160px">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr data-id="${o.id}" data-status="${fn:escapeXml(o.status)}">
                                    <td>#<c:out value='${o.id}' /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.itemCount > 1}">${o.mainItemName} 외 ${o.itemCount - 1}건</c:when>
                                            <c:otherwise>${o.mainItemName}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="cell-num"><fmt:formatNumber value="${o.totalPrice}" />원</td>
                                    <td><fmt:formatDate value="${o.orderedAt}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status eq 'APPROVED'}"><span class="badge" style="background-color: #ecfdf5; color: #065f46; border-color: #a7f3d0;">검수완료</span></c:when>
                                            <c:when test="${o.status eq 'RECEIVED'}"><span class="badge" style="background-color: #eff6ff; color: #1e40af; border-color: #bfdbfe;">입고완료</span></c:when>
                                            <c:otherwise><span class="badge" style="background-color: #f1f5f9; color: #475569; border-color: #e2e8f0;">요청중</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="btn sm" data-action="open-detail" data-id="${o.id}">상세보기</button>
                                        <c:if test="${o.status eq 'APPROVED'}">
                                            <button type="button" class="btn sm" data-action="receive" data-id="${o.id}">입고처리</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr><td colspan="6" style="text-align:center; padding: 48px; color: var(--muted);">발주 기록이 없습니다.</td></tr>
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
                                <a class="btn sm" href="${firstUrl}" <c:if test="${not hasPrev}">disabled</c:if>>≪</a>
                                <a class="btn sm" href="${prevUrl}" <c:if test="${not hasPrev}">disabled</c:if>>‹</a>
                                <a class="btn sm" href="${nextUrl}" <c:if test="${not hasNext}">disabled</c:if>>›</a>
                                <a class="btn sm" href="${lastUrl}" <c:if test="${not hasNext}">disabled</c:if>>≫</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
    </div>
    
    </body>
</html>