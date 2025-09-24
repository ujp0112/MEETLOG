<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<title>공지: ${fn:escapeXml(notice.title)}</title>
<style>
    .notice-image-gallery {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 16px;
        margin-bottom: 24px;
    }
    .notice-image {
        width: 100%;
        height: auto;
        border-radius: 12px;
        border: 1px solid var(--border);
    }
    .notice-content {
        white-space: pre-wrap;
        line-height: 1.7;
        overflow-wrap: break-word;
        color: #334155;
    }
    .attachment-list h4 {
        margin-bottom: 8px;
    }
    .attachment-list a {
        color: var(--brand-700);
        text-decoration: underline;
        font-weight: 500;
    }
</style>
</head>
<body>
	<%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
		<main>
			<section class="panel" style="max-width: 900px;">
				<div class="hd">
					<h1 class="title">${fn:escapeXml(notice.title)}</h1>
				</div>
				<div class="bd">
					<%-- 이미지 갤러리 --%>
					<div class="notice-image-gallery">
						<c:forEach var="image" items="${notice.images}">
							<mytag:image fileName="${image.filePath}" altText="공지 이미지"
								cssClass="notice-image" />
						</c:forEach>
					</div>

					<%-- 공지 내용 --%>
					<div class="notice-content">
						${fn:escapeXml(notice.content)}
                    </div>

					<%-- 첨부파일 목록 --%>
					<c:if test="${not empty notice.files}">
						<hr class="divider">
						<div class="attachment-list">
                            <h4>첨부파일</h4>
                            <c:forEach var="file" items="${notice.files}">
                                <p>
                                    <a href="${contextPath}${file.filePath}"
                                        download="${fn:escapeXml(file.originalFilename)}">${fn:escapeXml(file.originalFilename)}</a>
                                </p>
                            </c:forEach>
                        </div>
					</c:if>
				</div>
                <div class="ft">
                    <a href="${contextPath}/branch/notice" class="btn">목록으로</a>
                </div>
			</section>
		</main>
    </div>
</body>
</html>