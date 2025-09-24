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
    <style>
        :root { --bg:#f6faf8; --surface:#ffffff; --border:#e5e7eb; --muted:#6b7280; --title:#0f172a; --primary:#2f855a; --brand-700: #2f855a; }
        html, body { height:100%; }
        body { margin:0; background:var(--bg); color:var(--title); font:14px/1.45 system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,"Apple SD Gothic Neo","Noto Sans KR",sans-serif; }
        a { text-decoration: none; color: inherit; }
        
        main { max-width: 980px; margin: 20px auto; padding: 0 20px; }
        .panel { background:var(--surface); border:1px solid var(--border); border-radius:16px; box-shadow:0 8px 20px rgba(16,24,40,.05); }
        .panel .hd { display:flex; align-items:center; gap:10px; padding:16px 18px; border-bottom:1px solid var(--border); }
        .panel .bd { padding:16px 18px; }
        .panel .ft { display:flex; justify-content:flex-end; padding: 12px 18px; border-top:1px solid var(--border); background: #f9fafb; border-radius: 0 0 16px 16px;}
        .title { margin:0; font-size:20px; font-weight:800; }

        .btn { display: inline-flex; appearance:none; border:1px solid var(--border); background:#fff; padding:10px 14px; border-radius:999px; font-weight:700; cursor:pointer; text-decoration:none; color:#111827; }
        .btn:hover { background:#f8fafc; }
        
        .promo-images { margin-bottom: 24px; }
        .promo-image {
            width: 100%; 
            height: auto;
            border-radius: 12px; 
            margin-bottom: 10px;
            border: 1px solid var(--border);
        }
        .promo-content {
            white-space: pre-wrap;
            line-height: 1.7;
            color: #334155;
            font-size: 15px;
            padding: 10px 0;
        }
        .divider {
            border: 0;
            border-top: 1px solid var(--border);
            margin: 24px 0;
        }
        .attachment-list h4 {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--title);
        }
        .attachment-list a {
            color: var(--brand-700);
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%-- 역할에 따라 다른 헤더를 include 합니다 --%>
    <c:choose>
        <c:when test="${sessionScope.businessUser.role eq 'HQ'}">
            <%@ include file="/WEB-INF/layout/header.jspf"%>
        </c:when>
        <c:otherwise>
            <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
        </c:otherwise>
    </c:choose>
    
    <main>
        <section class="panel">
            <div class="hd">
                <h1 class="title">${fn:escapeXml(promotion.title)}</h1>
            </div>
    
            <div class="bd">
                <div class="promo-images">
                    <c:forEach var="image" items="${promotion.images}">
                         <mytag:image fileName="${image.filePath}" altText="프로모션 이미지" cssClass="promo-image" />
                    </c:forEach>
                </div>
                <div class="promo-content">
                    ${fn:escapeXml(promotion.description)}
                </div>
                <c:if test="${not empty promotion.files}">
                   <hr class="divider">
                    <div class="attachment-list">
                        <h4>첨부파일</h4>
                        <c:forEach var="file" items="${promotion.files}">
                            <p>
                                <a href="${contextPath}/files/${file.filePath}" download="${fn:escapeXml(file.originalFilename)}">
                                    ${fn:escapeXml(file.originalFilename)}
                                </a>
                            </p>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
            <div class="ft">
                 <a href="${contextPath}/${fn:toLowerCase(sessionScope.businessUser.role)}/promotion" class="btn">목록으로</a>
            </div>
        </section>
    </main>
</body>
</html>