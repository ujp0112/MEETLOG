<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 회원가입</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <main class="page-content flex items-center justify-center py-12 min-h-screen">
        <div class="w-full max-w-md p-8 space-y-8 bg-white rounded-2xl shadow-lg">
            <div>
                 <a href="${pageContext.request.contextPath}/main" class="block text-center text-4xl font-bold text-sky-600 mb-2">MEET LOG</a>
                <h2 class="text-center text-2xl font-bold text-slate-900">회원가입</h2>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="p-4 bg-red-100 border border-red-400 text-red-700 rounded">
                    ${errorMessage}
                 </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="p-4 bg-green-100 border border-green-400 text-green-700 rounded">
                    ${successMessage}
                </div>
             </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="mt-8 space-y-6">
                <input type="hidden" name="userType" value="PERSONAL">
                <div class="space-y-4">
                    <div>
                         <label for="email" class="text-sm font-medium text-slate-700">이메일 주소</label>
                        <input type="email" id="email" name="email" required 
                               class="mt-1 relative block w-full px-3 py-3 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500" 
                                placeholder="example@email.com">
                    </div>
                    <div>
                        <label for="nickname" class="text-sm font-medium text-slate-700">닉네임</label>
                         <input type="text" id="nickname" name="nickname" required 
                               class="mt-1 relative block w-full px-3 py-3 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500" 
                               placeholder="멋진 닉네임을 입력하세요">
                     </div>
                    <div>
                        <label for="password" class="text-sm font-medium text-slate-700">비밀번호</label>
                        <input type="password" id="password" name="password" required 
                                class="mt-1 relative block w-full px-3 py-3 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500" 
                               placeholder="영문, 숫자 포함 8자 이상">
                    </div>
                     <div>
                        <label for="confirmPassword" class="text-sm font-medium text-slate-700">비밀번호 확인</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required 
                               class="mt-1 relative block w-full px-3 py-3 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500" 
                               placeholder="비밀번호를 한번 더 입력해주세요">
                    </div>
                </div>
                <div class="space-y-3">
                     <div class="flex items-start">
                        <div class="flex items-center h-5">
                            <input type="checkbox" id="agreeAll" class="h-4 w-4 text-sky-600 focus:ring-sky-500 border-slate-300 rounded">
                         </div>
                        <div class="ml-3 text-sm">
                            <label for="agreeAll" class="font-bold text-slate-800">전체 약관에 동의합니다.</label>
                        </div>
                     </div>
                    <hr>
                    <div class="flex items-start">
                        <div class="flex items-center h-5">
                            
                             <input type="checkbox" id="agreeTerms" name="agreeTerms" required 
                                   class="h-4 w-4 text-sky-600 focus:ring-sky-500 border-slate-300 rounded">
                        </div>
                        <div class="ml-3 text-sm">
     
                             <label for="agreeTerms" class="text-slate-600">
                                [필수] <a href="${pageContext.request.contextPath}/service" class="font-medium text-sky-600 hover:underline">서비스 이용약관</a>
                            </label>
         
                         </div>
                    </div>
                    <div class="flex items-start">
                        <div class="flex items-center h-5">
                
                             <input type="checkbox" id="agreePrivacy" name="agreePrivacy" required 
                                   class="h-4 w-4 text-sky-600 focus:ring-sky-500 border-slate-300 rounded">
                        </div>
                   
                         <div class="ml-3 text-sm">
                            <label for="agreePrivacy" class="text-slate-600">
                                [필수] <a href="${pageContext.request.contextPath}/privacy" class="font-medium text-sky-600 hover:underline">개인정보처리방침</a>
                          
                             </label>
                        </div>
                    </div>
                </div>
                <div>
                    <button type="submit" class="w-full flex justify-center py-3 px-4 border-transparent text-sm font-bold rounded-md text-white bg-sky-600 hover:bg-sky-700">가입하기</button>
                </div>
            </form>

            <div class="text-center text-sm text-slate-500">
                <p>이미 계정이 있으신가요? <a href="${pageContext.request.contextPath}/login" class="font-bold text-sky-600 hover:text-sky-500">로그인</a></p>
            </div>

            <div class="mt-6 pt-6 border-t border-slate-200">
                <div class="text-center text-sm text-slate-500">
                    <p>혹시 기업 회원이신가요? <a href="${pageContext.request.contextPath}/business-register" class="font-bold text-sky-600 hover:text-sky-500">사업자 회원가입</a></p>
                </div>
            </div>

        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const agreeAllCheckbox = document.getElementById('agreeAll');
            const agreeTermsCheckbox = document.getElementById('agreeTerms');
            const agreePrivacyCheckbox = document.getElementById('agreePrivacy');

            agreeAllCheckbox.addEventListener('change', function() {
                agreeTermsCheckbox.checked = this.checked;
                 agreePrivacyCheckbox.checked = this.checked;
            });

            [agreeTermsCheckbox, agreePrivacyCheckbox].forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    if (!this.checked) {
                         agreeAllCheckbox.checked = false;
                    } else if (agreeTermsCheckbox.checked && agreePrivacyCheckbox.checked) {
                        agreeAllCheckbox.checked = true;
                    }
                 });
            });
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');

            confirmPasswordInput.addEventListener('input', function() {
                if (passwordInput.value !== this.value) {
                    this.setCustomValidity('비밀번호가 일치하지 않습니다.');
                } else {
                    this.setCustomValidity('');
                 }
            });
        });
    </script>
</body>
</html>