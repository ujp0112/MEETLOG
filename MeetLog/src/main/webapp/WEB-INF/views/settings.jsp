<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
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
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
                                        
                                        <%-- [MERGE CONFLICT RESOLVED] 오류 및 성공 메시지 블록 모두 반영 --%>
                                        <c:if test="${not empty sessionScope.errorMessage}">
                                            <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
                                                ${sessionScope.errorMessage}
                                            </div>
                                            <c:remove var="errorMessage" scope="session"/>
                                        </c:if>
                                        <c:if test="${not empty sessionScope.successMessage}">
                                            <div class="mb-4 p-4 bg-green-100 border border-green-400 text-green-700 rounded">
                                                ${sessionScope.successMessage}
                                            </div>
                                            <c:remove var="successMessage" scope="session"/>
                                        </c:if>

                                        <form action="${pageContext.request.contextPath}/mypage/settings" method="post" enctype="multipart/form-data" class="space-y-4">
                                            <input type="hidden" name="action" value="updateProfile">
                                            <input type="hidden" name="existingProfileImage" value="${sessionScope.user.profileImage}">
                                            
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">프로필 이미지</label>
                                                <div class="flex items-center space-x-4">
                                                    <mytag:image fileName="${sessionScope.user.profileImage}" altText="프로필" cssClass="w-16 h-16 rounded-full" />
                                                    <input type="file" name="profileImage" id="imageUpload" accept="image/*"
                                                            class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
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
                                            <button type="button" id="export-data-btn" onclick="exportData()" class="w-full text-left text-slate-600 hover:text-slate-800 text-sm">
                                                📥 데이터 내보내기
                                            </button>
                                            <button type="button" id="delete-account-btn" onclick="deleteAccount()" class="w-full text-left text-red-600 hover:text-red-800 text-sm">
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
        const contextPath = '${pageContext.request.contextPath}';
        $(document).ready(function() {
            $('#imageUpload').on('change', function(event) {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const previewImage = $('form[action*="updateProfile"] img');
                        if(previewImage.length > 0) {
                            previewImage.attr('src', e.target.result);
                        }
                    };
                    reader.readAsDataURL(this.files[0]);
                }
            });
        });
        function exportData() {
            const button = document.getElementById('export-data-btn');
            if (button) {
                button.disabled = true;
                button.classList.add('opacity-60', 'cursor-not-allowed');
                setTimeout(() => {
                    button.disabled = false;
                    button.classList.remove('opacity-60', 'cursor-not-allowed');
                }, 1500);
            }
            window.location.href = contextPath + '/mypage/settings/export';
        }
        function deleteAccount() {
            if (confirm('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                if (confirm('모든 데이터가 영구적으로 삭제됩니다. 계속하시겠습니까?')) {
                    const button = document.getElementById('delete-account-btn');
                    if (button) {
                        button.disabled = true;
                        button.classList.add('opacity-60', 'cursor-not-allowed');
                    }

                    fetch(contextPath + '/mypage/settings', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                        },
                        body: new URLSearchParams({ action: 'deleteAccount' })
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('서버 응답이 올바르지 않습니다.');
                        }
                        return response.json();
                    })
                    .then(result => {
                        if (result.success) {
                            const redirectUrl = result.redirect || (contextPath + '/');
                            window.location.href = redirectUrl;
                        } else {
                            alert(result.message || '계정 삭제에 실패했습니다.');
                        }
                    })
                    .catch(error => {
                        console.error('계정 삭제 실패:', error);
                        alert('계정 삭제 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    })
                    .finally(() => {
                        if (button) {
                            button.disabled = false;
                            button.classList.remove('opacity-60', 'cursor-not-allowed');
                        }
                    });
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
