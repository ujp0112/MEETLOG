<!-- File: webapp/auth/register-hq.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>본사(HQ) 회원가입</title>
</head>
<body>
  <div class="page">
    <div class="shell" style="max-width:720px;margin:40px auto;padding:0 16px;">
      <h1 style="margin:0 0 16px 0;">본사(HQ) 회원가입</h1>

      <c:if test="${not empty requestScope.error}">
        <div style="margin-bottom:12px;color:#b91c1c;">${requestScope.error}</div>
      </c:if>
      <c:if test="${not empty requestScope.message}">
        <div style="margin-bottom:12px;color:#065f46;">${requestScope.message}</div>
      </c:if>

      <form method="post" action="${contextPath}/auth/hq/register">
        <div style="display:grid;gap:12px">
          <label>회사명(본사명)<br/>
            <input type="text" name="companyName" required />
          </label>

          <label>관리자 이메일(로그인용)<br/>
            <input type="email" name="email" required />
          </label>

          <label>비밀번호<br/>
            <input type="password" name="password" required minlength="6" />
          </label>

          <label>비밀번호 확인<br/>
            <input type="password" name="passwordConfirm" required minlength="6" />
          </label>

          <button type="submit">가입하기</button>
        </div>
      </form>

      <div style="margin-top:16px;">
        <a href="${contextPath}/auth/login.jsp">로그인으로 돌아가기</a>
      </div>
    </div>
  </div>
</body>
</html>
