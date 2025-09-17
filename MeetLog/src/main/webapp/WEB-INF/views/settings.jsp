<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- [추가] LocalDateTime 포맷을 위한 import --%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 설정</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-4xl mx-auto">
                    <div class="mb-6">
                        <h2 class="text-2xl md:text-3xl font-bold mb-2">설정</h2>
                        <p class="text-slate-600">계정 정보를 관리하세요.</p>
                    </div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                                <div class="lg:col-span-2 space-y-6">
                                    <div class="bg-white p-6 rounded-xl shadow-lg">
                                        <h3 class="text-xl font-bold text-slate-800 mb-4">프로필 정보</h3>
                                        
                                        <c:if test="${not empty errorMessage}">
                                            <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
                                                ${errorMessage}
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty successMessage}">
                                            <div class="mb-4 p-4 bg-green-100 border border-green-400 text-green-700 rounded">
                                                ${successMessage}
                                            </div>
                                        </c:if>

                                        <form action="${pageContext.request.contextPath}/mypage/settings" method="post" class="space-y-4">
                                            <input type="hidden" name="action" value="updateProfile">
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">프로필 이미지</label>
                                                <div class="flex items-center space-x-4">
                                                    <img src="${not empty sessionScope.user.profileImage ?
 sessionScope.user.profileImage : 'https://placehold.co/100x100/94a3b8/ffffff?text=U'}"
                                                         class="w-16 h-16 rounded-full" alt="프로필">
                                                    <input type="url" name="profileImage" 
                                                           value="${sessionScope.user.profileImage}"
                                                           class="flex-1 px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500"
                                                           placeholder="이미지 URL을 입력하세요">
                                                </div>
                                            </div>
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">닉네임</label>
                                                <input type="text" name="nickname" value="${sessionScope.user.nickname}" required
                                                       class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                            </div>
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">이메일</label>
                                                <input type="email" value="${sessionScope.user.email}" disabled
                                                       class="w-full px-3 py-2 border border-slate-300 rounded-md bg-slate-100 text-slate-500">
                                                <p class="text-sm text-slate-500 mt-1">이메일은 변경할 수 없습니다.</p>
                                            </div>
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">회원 유형</label>
                                                <input type="text" value="${sessionScope.user.userType == 'PERSONAL' ? '개인회원' : '기업회원'}" disabled
                                                       class="w-full px-3 py-2 border border-slate-300 rounded-md bg-slate-100 text-slate-500">
                                            </div>
                                            
                                            <button type="submit" class="w-full bg-sky-600 text-white font-bold py-2 px-4 rounded-md hover:bg-sky-700">
                                                프로필 수정
                                            </button>
                                        </form>
                                    </div>

                                    <div class="bg-white p-6 rounded-xl shadow-lg">
                                        <h3 class="text-xl font-bold text-slate-800 mb-4">비밀번호 변경</h3>
                                        
                                        <form action="${pageContext.request.contextPath}/mypage/settings" method="post" class="space-y-4">
                                            <input type="hidden" name="action" value="changePassword">
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">현재 비밀번호</label>
                                                <input type="password" name="currentPassword" required
                                                       class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                            </div>
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">새 비밀번호</label>
                                                <input type="password" name="newPassword" required
                                                       class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                            </div>
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">새 비밀번호 확인</label>
                                                <input type="password" name="confirmPassword" required
                                                       class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500">
                                            </div>
                                            
                                            <button type="submit" class="w-full bg-slate-600 text-white font-bold py-2 px-4 rounded-md hover:bg-slate-700">
                                                비밀번호 변경
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <div class="space-y-6">
                                    <div class="bg-white p-6 rounded-xl shadow-lg">
                                        <h3 class="text-lg font-bold text-slate-800 mb-4">계정 정보</h3>
                                        <div class="space-y-3 text-sm">
                                            <div class="flex justify-between">
                                                <span class="text-slate-600">가입일:</span>
                                                <span class="text-slate-800">
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user.createdAt}">
                                                            <%-- [수정] fmt:formatDate -> EL 표현식으로 변경 --%>
                                                            ${sessionScope.user.createdAt.format(DateTimeFormatter.ofPattern('yyyy.MM.dd'))}
                                                        </c:when>
                                                        <c:otherwise>정보 없음</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-slate-600">마지막 로그인:</span>
                                                <span class="text-slate-800">방금 전</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="bg-white p-6 rounded-xl shadow-lg">
                                        <h3 class="text-lg font-bold text-slate-800 mb-4">계정 관리</h3>
                                        <div class="space-y-3">
                                            <button onclick="exportData()" class="w-full text-left text-slate-600 hover:text-slate-800 text-sm">
                                                📥 데이터 내보내기
                                            </button>
                                            <button onclick="deleteAccount()" class="w-full text-left text-red-600 hover:text-red-800 text-sm">
                                                🗑️ 계정 삭제
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12">
                                <div class="text-6xl mb-4">🔒</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                                <p class="text-slate-600 mb-6">설정을 관리하려면 로그인해주세요.</p>
                                <a href="${pageContext.request.contextPath}/login" 
                                   class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                    로그인하기
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function exportData() {
            alert('데이터 내보내기 기능은 준비 중입니다.');
        }

        function deleteAccount() {
            if (confirm('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                if (confirm('모든 데이터가 영구적으로 삭제됩니다. 계속하시겠습니까?')) {
                    alert('계정 삭제 기능은 준비 중입니다.');
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const newPasswordInput = document.querySelector('input[name="newPassword"]');
            const confirmPasswordInput = document.querySelector('input[name="confirmPassword"]');

            if (confirmPasswordInput) {
                 confirmPasswordInput.addEventListener('input', function() {
                    if (newPasswordInput.value !== this.value) {
                        this.setCustomValidity('비밀번호가 일치하지 않습니다.');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }
        });
    </script>
</body>
</html>