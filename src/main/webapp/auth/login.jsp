<!-- File: webapp/auth/login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>로그인</title>
</head>
<body>
  <div class="page">
    <div class="shell" style="max-width:720px;margin:40px auto;padding:0 16px;">
      <h1 style="margin:0 0 16px 0;">로그인</h1>
      
      <!-- 메시지 -->
      <c:if test="${not empty requestScope.error}">
        <div style="margin-bottom:12px;color:#b91c1c;">${requestScope.error}</div>
      </c:if>
      <c:if test="${not empty requestScope.message}">
        <div style="margin-bottom:12px;color:#065f46;">${requestScope.message}</div>
      </c:if>

      <!-- HQ 로그인 -->
      <section style="border:1px solid #e5e7eb;border-radius:12px;padding:16px;margin-bottom:20px;">
        <h2 style="margin:0 0 10px 0;">본사(HQ) 로그인</h2>
        <form method="post" action="${contextPath}/auth/hq/login">
          <div style="display:grid;gap:10px">
            <label>이메일<br/><input type="email" name="email" required /></label>
            <label>비밀번호<br/><input type="password" name="password" required /></label>
            <button type="submit">로그인</button>
          </div>
        </form>
      </section>

      <!-- BRANCH 로그인 -->
      <section style="border:1px solid #e5e7eb;border-radius:12px;padding:16px;">
        <h2 style="margin:0 0 10px 0;">지점 로그인</h2>
        <form method="post" action="${contextPath}/auth/branch/login">
          <div style="display:grid;gap:10px">
            <label>이메일<br/><input type="email" name="email" required /></label>
            <label>비밀번호<br/><input type="password" name="password" required /></label>
            <button type="submit">로그인</button>
          </div>
        </form>
      </section>

      <div style="margin-top:16px;">
        <a href="${contextPath}/auth/register-branch.jsp">지점 회원가입</a>
        &nbsp;|&nbsp;
        <a href="${contextPath}/auth/register-hq.jsp">본사(HQ) 회원가입</a>
      </div>
    </div>
  </div>
</body>
</html>
