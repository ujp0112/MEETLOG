<!-- File: webapp/auth/register-branch.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>지점 회원가입</title>
</head>
<body>
  <div class="page">
    <div class="shell" style="max-width:720px;margin:40px auto;padding:0 16px;">
      <h1 style="margin:0 0 16px 0;">지점 회원가입</h1>

      <p style="color:#475569;margin:8px 0 16px 0;">
        ※ 실제 운영에서는 본사(HQ)의 지점 승인 절차를 거치지만, 지금은 생략합니다.<br/>
        본사(HQ) 계정의 <b>이메일 또는 ID</b>를 입력하면 해당 본사 소속으로 지점이 등록됩니다.
      </p>

      <c:if test="${not empty requestScope.error}">
        <div style="margin-bottom:12px;color:#b91c1c;">${requestScope.error}</div>
      </c:if>
      <c:if test="${not empty requestScope.message}">
        <div style="margin-bottom:12px;color:#065f46;">${requestScope.message}</div>
      </c:if>

      <form method="post" action="${contextPath}/auth/branch/register">
        <div style="display:grid;gap:12px">
          <label>본사(HQ) 식별자 (이메일 또는 ID)<br/>
            <input type="text" name="hqIdentifier" placeholder="hq-admin@example.com 또는 12345" required />
          </label>

          <label>지점명<br/>
            <input type="text" name="branchName" required />
          </label>

          <hr/>

          <label>지점 사용자 이메일(로그인용)<br/>
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
        <a href="${contextPath}/login.jsp">로그인으로 돌아가기</a>
      </div>
    </div>
  </div>
</body>
</html>
