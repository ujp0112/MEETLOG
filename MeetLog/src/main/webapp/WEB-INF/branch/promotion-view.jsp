<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로모션: ${fn:escapeXml(promotion.title)}</title>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
        <section class="panel" style="max-width: 900px;">
            <div class="hd">
                <h1 class="title">${fn:escapeXml(promotion.title)}</h1>
            </div>
            <div class="bd">
                <div class="promo-images" style="margin-bottom: 24px;">
                    <c:forEach var="image" items="${promotion.images}">
                         <%-- ▼▼▼ [수정] style 속성을 제거하고 cssClass 사용 ▼▼▼ --%>
                         <mytag:image fileName="${image.filePath}" altText="프로모션 이미지" cssClass="promo-image" />
                    </c:forEach>
                </div>

                <div class="promo-content" style="white-space: pre-wrap; line-height: 1.7;">
                    ${fn:escapeXml(promotion.description)}
                </div>

                <c:if test="${not empty promotion.files}">
                   <hr style="border:0; border-top:1px solid var(--border); margin: 24px 0;">
                    <h4 style="font-size: 16px; font-weight: 700;">첨부파일</h4>
                    <div class="file-list">
                        <c:forEach var="file" items="${promotion.files}">
                            <p>
                                <a href="${contextPath}/files/${file.filePath}" download="${fn:escapeXml(file.originalFilename)}" style="color: var(--brand-700); text-decoration: underline;">
                                    ${fn:escapeXml(file.originalFilename)}
                                </a>
                            </p>
                        </c:forEach>
                    </div>
                </c:if>

                <div class="actions" style="display:flex; justify-content: flex-end; padding-top:20px; border-top:1px solid var(--border); margin-top:20px;">
                    <a href="${contextPath}/${fn:toLowerCase(sessionScope.businessUser.role)}/promotion" class="btn">목록으로</a>
                </div>
            </div>
        </section>
    </div>
    
    <%-- 공통 헤더에 이미 스타일이 있지만, 이 페이지 전용 스타일을 위해 추가 --%>
    <style>
        .promo-image {
            width: 100%; 
            height: auto;
            border-radius: 12px; 
            margin-bottom: 10px;
        }
    </style>
</body>
</html>