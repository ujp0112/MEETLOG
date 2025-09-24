<%-- /webapp/WEB-INF/tags/image.tag --%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 이 태그가 외부로부터 받을 값들을 정의합니다 (파라미터). --%>
<%@ attribute name="fileName" required="true" type="java.lang.String" description="DB에 저장된 이미지 파일명" %>
<%@ attribute name="altText" required="true" type="java.lang.String" description="이미지 대체 텍스트" %>
<%@ attribute name="cssClass" required="false" type="java.lang.String" description="적용할 CSS 클래스" %>

<%-- -------------------- 이미지 경로 처리 로직 (이제 여기에만 존재!) -------------------- --%>
<c:set var="imageFileName" value="${fileName}" />

<c:choose>
    <%-- 1. http로 시작하는 외부 URL 주소인 경우 --%>
    <c:when test="${not empty imageFileName and fn:startsWith(imageFileName, 'http')}">
        <c:set var="imageUrl" value="${imageFileName}" />
    </c:when>
    <%-- 2. 우리가 업로드한 파일인 경우 (ImageServlet 호출) --%>
    <c:when test="${not empty imageFileName}">
        <c:set var="imageUrl" value="${pageContext.request.contextPath}/images/${imageFileName}" />
    </c:when>
    <%-- 3. 이미지가 없는 경우 보여줄 기본 이미지 --%>
    <c:otherwise>
        <c:set var="imageUrl" value="https://placehold.co/600x400/e0e7ff/4338ca?text=No+Image" />
    </c:otherwise>
</c:choose>

<%-- 최종적으로 생성된 URL을 img 태그에 적용 --%>
<img src="${imageUrl}" alt="${altText}" class="${cssClass}">