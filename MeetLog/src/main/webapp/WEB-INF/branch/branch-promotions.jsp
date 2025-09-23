<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>진행중인 프로모션</title>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
        <section class="panel" style="max-width: 1100px;">
            <div class="hd">
                <h1 class="title">진행/예정 프로모션</h1>
            </div>
            <div class="bd">
                <c:if test="${empty promotions}">
                    <div style="text-align:center; padding: 48px; color: var(--muted);">
                        <p>현재 진행중이거나 예정된 프로모션이 없습니다.</p>
                    </div>
                </c:if>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 20px;">
                    <c:forEach var="p" items="${promotions}">
                        <c:url var="viewUrl" value="/branch/promotion/view">
                            <c:param name="id" value="${p.id}" />
                        </c:url>
                        <a href="${viewUrl}" style="display: flex; gap: 16px; padding: 16px; border: 1px solid var(--border); border-radius: 14px; background: #fff; transition: .2s;" onmouseover="this.style.boxShadow='0 4px 12px rgba(0,0,0,.08)'" onmouseout="this.style.boxShadow='none'">
                            <%-- ▼▼▼ [수정] style 속성을 cssClass로 변경 ▼▼▼ --%>
                            <mytag:image fileName="${p.imgPath}" altText="${p.title}" cssClass="thumb" />
                            <div style="display: flex; flex-direction: column; overflow: hidden;">
                                <h3 style="margin: 0 0 8px 0; font-size: 16px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-weight: 700;">${p.title}</h3>
                                <p style="margin: 0; color: var(--muted); font-size: 13px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 3em;">${p.description}</p>
                                <p style="font-weight: 600; margin-top: auto; padding-top: 8px; color: var(--brand-700);">
                                    <fmt:formatDate value="${p.startDate}" pattern="MM.dd" /> ~ <fmt:formatDate value="${p.endDate}" pattern="MM.dd" />
                                </p>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>
    </div>
</body>
</html>