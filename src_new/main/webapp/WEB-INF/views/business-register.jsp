<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 사업자 회원가입</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .form-input { display: block; width: 100%; border-radius: 0.5rem; border: 1px solid #cbd5e1; padding: 0.75rem 1rem; }
        .form-input:focus { outline: 2px solid transparent; outline-offset: 2px; border-color: #38bdf8; box-shadow: 0 0 0 2px #7dd3fc; }
        .form-btn-primary { display: inline-flex; width: 100%; justify-content: center; border-radius: 0.5rem; background-color: #0284c7; padding: 0.75rem 1rem; font-weight: 600; color: white; }
        .form-btn-primary:hover { background-color: #0369a1; }
    </style>
</head>
<body class="bg-slate-50">

    <main class="flex items-center justify-center min-h-screen p-4">
        <div class="w-full max-w-lg bg-white p-8 md:p-12 rounded-2xl shadow-xl">
            
            <div class="text-center mb-8">
                <a href="${pageContext.request.contextPath}/" class="text-3xl font-bold text-sky-600">MEET LOG</a>
                <h2 class="mt-4 text-2xl font-bold text-slate-800">사업자 회원가입</h2>
                <p class="mt-2 text-sm text-gray-600">MEET LOG 파트너가 되어 맛집을 관리하세요.</p>
            </div>
            
            <c:if test="${not empty errorMessage}">
                <div class="mb-4 p-3 bg-red-50 text-red-700 text-sm rounded-lg">${errorMessage}</div>
            </c:if>
            
            <form class="space-y-5" action="${pageContext.request.contextPath}/register" method="post">
                
                <input type="hidden" name="userType" value="BUSINESS">
                
                <div>
                    <label for="businessName" class="block text-sm font-medium text-slate-700">사업체명</label>
                    <input id="businessName" name="businessName" type="text" required class="form-input mt-1" placeholder="상호명을 입력하세요">
                </div>
                
                <div>
                    <label for="ownerName" class="block text-sm font-medium text-slate-700">대표자명</label>
                    <input id="ownerName" name="ownerName" type="text" required class="form-input mt-1" placeholder="대표자명을 입력하세요">
                </div>
                
                <div>
                    <label for="businessNumber" class="block text-sm font-medium text-slate-700">사업자등록번호</label>
                    <input id="businessNumber" name="businessNumber" type="text" required class="form-input mt-1" placeholder="'-' 포함 10자리">
                </div>
                
                <div>
                    <label for="email" class="block text-sm font-medium text-slate-700">로그인 이메일</label>
                    <input id="email" name="email" type="email" required class="form-input mt-1" placeholder="로그인 시 사용할 이메일">
                </div>
                 <div>
                    <label for="password" class="block text-sm font-medium text-slate-700">비밀번호</label>
                    <input id="password" name="password" type="password" required class="form-input mt-1" placeholder="영문, 숫자 포함 8자 이상">
                </div>

                <div>
                    <button type="submit" class="form-btn-primary">가입 신청</button>
                </div>
                
                <div class="text-center text-sm">
                    <a href="${pageContext.request.contextPath}/login" class="font-medium text-sky-600 hover:text-sky-500">
                        이미 계정이 있으신가요? 로그인
                    </a>
                </div>
            </form>
        </div>
    </main>

</body>
</html>