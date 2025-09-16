<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Page</title>
</head>
<body>
    <h1>Test Page - 서버가 정상 작동합니다!</h1>
    <p>현재 시간: <%= new java.util.Date() %></p>
    <p>Context Path: <%= request.getContextPath() %></p>
    <p>Request URI: <%= request.getRequestURI() %></p>
</body>
</html>
