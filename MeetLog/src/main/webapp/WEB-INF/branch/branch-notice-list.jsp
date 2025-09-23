<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="pageSize" value="${requestScope.pageSize}" />
<c:set var="currentPage" value="${requestScope.currentPage}" />
<c:set var="totalCount" value="${requestScope.totalCount}" />
<c:set var="totalPages" value="${(totalCount + pageSize - 1) / pageSize}" />
<c:set var="hasPrev" value="${currentPage > 1}" />
<c:set var="hasNext" value="${currentPage < totalPages}" />
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}" />
<c:set var="nextPage" value="${hasNext ? (currentPage + 1) : totalPages}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>사내 공지</title>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
        <section class="panel" style="max-width: 1100px;">
            <div class="hd">
                <h1 id="pageTitle" class="title">사내 공지</h1>
            </div>
            <div class="bd">
                <div class="table-wrap">
                    <table class="sheet">
                        <thead>
                            <tr>
                                <th style="width: 80px">번호</th>
                                <th>제목</th>
                                <th style="width: 120px">조회수</th>
                                <th style="width: 150px">작성일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="n" items="${notices}">
                                <tr>
                                    <td>${n.id}</td>
                                    <td><a href="${contextPath}/branch/notice/view?id=${n.id}" style="text-decoration: none;">${fn:escapeXml(n.title)}</a></td>
                                    <td>${n.viewCount}</td>
                                    <td><fmt:formatDate value="${n.createdAt}" pattern="yyyy-MM-dd" /></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty notices}">
                                <tr><td colspan="4" style="text-align:center; padding: 48px; color: var(--muted);">등록된 공지사항이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <c:if test="${totalCount > 0}">
                    <div class="pager" id="mainPager">
                        <div class="left">
                             <span class="info">${totalCount}건 (페이지 ${currentPage} / <fmt:formatNumber value="${totalPages}" maxFractionDigits="0" />)</span>
                        </div>
                        <div class="right">
                            <div class="btn-group">
                                <a class="btn sm" href="?page=1" <c:if test="${not hasPrev}">disabled</c:if>>≪</a>
                                <a class="btn sm" href="?page=${prevPage}" <c:if test="${not hasPrev}">disabled</c:if>>‹</a>
                                <a class="btn sm" href="?page=${nextPage}" <c:if test="${not hasNext}">disabled</c:if>>›</a>
                                <a class="btn sm" href="?page=${totalPages}" <c:if test="${not hasNext}">disabled</c:if>>≫</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
    </div>
</body>
</html>