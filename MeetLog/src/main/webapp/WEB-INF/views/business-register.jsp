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
        .form-input, .form-select, .form-textarea { display: block; width: 100%; border-radius: 0.5rem; border: 1px solid #cbd5e1; padding: 0.75rem 1rem; margin-top: 0.25rem; }
        .form-input:focus, .form-select:focus, .form-textarea:focus { outline: 2px solid transparent; outline-offset: 2px; border-color: #38bdf8; box-shadow: 0 0 0 2px #7dd3fc; }
        .form-btn-primary { display: inline-flex; width: 100%; justify-content: center; border-radius: 0.5rem; background-color: #0284c7; padding: 0.75rem 1rem; font-weight: 600; color: white; }
        .form-btn-primary:hover { background-color: #0369a1; }
        .tab-active { border-color: #0284c7; color: #0284c7; }
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
            
            <div class="border-b border-slate-200 mb-6">
                <nav class="-mb-px flex space-x-6" id="register-tabs">
                    <button data-tab="hq" class="tab-active py-3 px-1 border-b-2 font-semibold text-sm">HQ 회원</button>
                    <button data-tab="branch" class="py-3 px-1 border-b-2 border-transparent text-slate-500 hover:text-slate-700 font-semibold text-sm">지점 회원</button>
                    <button data-tab="individual" class="py-3 px-1 border-b-2 border-transparent text-slate-500 hover:text-slate-700 font-semibold text-sm">개인 사업자 회원</button>
                </nav>
            </div>
            <div id="register-hq-content">
                <form class="space-y-5" action="${pageContext.request.contextPath}/business-register" method="post">
                    <input type="hidden" name="userType" value="BUSINESS_HQ">
                    <div>
                        <label for="hqBusinessName" class="block text-sm font-medium text-slate-700">사업체명 (본사)</label>
                        <div class="mt-1 flex rounded-md shadow-sm">
	                        <input id="hqBusinessName" name="businessName" type="text" required class="form-input rounded-none rounded-l-md" placeholder="상호명을 입력하세요">
	                        <button type="button" id="checkNicknameBtnHq"
	                                class="relative -ml-px inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-r-md text-slate-700 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-1 focus:ring-sky-500 focus:border-sky-500" style="white-space:nowrap;">
	                            중복 확인
	                        </button>
                        </div>
                        <p id="nicknameMessageHq" class="mt-2 text-sm"></p>
                    </div>
                    <div>
                        <label for="hqOwnerName" class="block text-sm font-medium text-slate-700">대표자명</label>
                        <input id="hqOwnerName" name="ownerName" type="text" required class="form-input" placeholder="대표자명을 입력하세요">
                    </div>
                    <div>
                        <label for="hqBusinessNumber" class="block text-sm font-medium text-slate-700">사업자등록번호</label>
                        <input id="hqBusinessNumber" name="businessNumber" type="text" required class="form-input" placeholder="'-' 포함 10자리">
                    </div>
                    <div>
                        <label for="hqCategory" class="block text-sm font-medium text-slate-700">업종</label>
                        <select id="hqCategory" name="category" required class="form-select">
                            <option value="">업종을 선택하세요</option>
                            <option value="한식">한식</option>
                            <option value="일식">일식</option>
                            <option value="중식">중식</option>
                            <option value="양식">양식</option>
                            <option value="카페">카페</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                    <div>
                        <label for="hqAddress" class="block text-sm font-medium text-slate-700">주소</label>
                        <input id="hqAddress" name="address" type="text" required class="form-input" placeholder="주소를 입력하세요">
                    </div>
                    <div>
                        <label for="hqPhone" class="block text-sm font-medium text-slate-700">전화번호</label>
                        <input id="hqPhone" name="phone" type="tel" required class="form-input" placeholder="02-1234-5678">
                    </div>
                    <div>
                        <label for="hqEmail" class="block text-sm font-medium text-slate-700">로그인 이메일</label>
                        <div class="mt-1 flex rounded-md shadow-sm">
                            <input id="hqEmail" name="email" type="email" required class="form-input rounded-none rounded-l-md" placeholder="로그인 시 사용할 이메일">
                            <button type="button" id="sendVerificationBtnHq"
                                    class="relative -ml-px inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-r-md text-slate-700 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-1 focus:ring-sky-500 focus:border-sky-500">
                                인증번호 발송
                            </button>
                        </div>
                        <p id="emailMessageHq" class="mt-2 text-sm"></p>
                    </div>
                    <div id="verificationCodeGroupHq" class="hidden">
                        <label for="verificationCodeHq" class="block text-sm font-medium text-slate-700">인증번호</label>
                        <input type="text" id="verificationCodeHq" name="verificationCode" required class="form-input" placeholder="이메일로 받은 인증번호 6자리를 입력하세요">
                    </div>

                    <div>
                        <label for="hqPassword" class="block text-sm font-medium text-slate-700">비밀번호</label>
                        <input id="hqPassword" name="password" type="password" required class="form-input" placeholder="영문, 숫자 포함 8자 이상">
                    </div>
                    <div>
                        <label for="hqConfirmPassword" class="block text-sm font-medium text-slate-700">비밀번호 확인</label>
                        <input id="hqConfirmPassword" name="confirmPassword" type="password" required class="form-input" placeholder="비밀번호를 다시 입력하세요">
                    </div>
                    <div>
                        <label for="hqDescription" class="block text-sm font-medium text-slate-700">사업체 소개</label>
                        <textarea id="hqDescription" name="description" rows="3" class="form-textarea" placeholder="사업체에 대한 간단한 소개를 작성해주세요"></textarea>
                    </div>
                    <div>
                        <button type="submit" class="form-btn-primary">가입 신청</button>
                    </div>
                </form>
            </div>
            <div id="register-branch-content" class="hidden">
                <form class="space-y-5" action="${pageContext.request.contextPath}/business-register" method="post">
                    <input type="hidden" name="userType" value="BUSINESS_BRANCH">
                    <div>
                        <label for="hqId" class="block text-sm font-medium text-slate-700">본사(HQ) 식별자 (이메일 또는 ID)</label>
                        <input id="hqId" name="hqId" type="text" required class="form-input" placeholder="가입된 본사 식별자를 입력하세요">
                    </div>
                    <div>
                        <label for="branchBusinessName" class="block text-sm font-medium text-slate-700">사업체명 (지점명)</label>
                        <div class="mt-1 flex rounded-md shadow-sm">
	                        <input id="branchBusinessName" name="businessName" type="text" required class="form-input rounded-none rounded-l-md" placeholder="상호명(지점명)을 입력하세요">
	                        <button type="button" id="checkNicknameBtnBranch"
	                                class="relative -ml-px inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-r-md text-slate-700 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-1 focus:ring-sky-500 focus:border-sky-500">
	                            중복 확인
	                        </button>
                        </div>
                        <p id="nicknameMessageBranch" class="mt-2 text-sm"></p>
                    </div>
                    <div>
                        <label for="branchOwnerName" class="block text-sm font-medium text-slate-700">대표자명</label>
                        <input id="branchOwnerName" name="ownerName" type="text" required class="form-input" placeholder="대표자명을 입력하세요">
                    </div>
                    <div>
                        <label for="branchBusinessNumber" class="block text-sm font-medium text-slate-700">사업자등록번호</label>
                        <input id="branchBusinessNumber" name="businessNumber" type="text" required class="form-input" placeholder="'-' 포함 10자리">
                    </div>
                     <div>
                        <label for="branchCategory" class="block text-sm font-medium text-slate-700">업종</label>
                        <select id="branchCategory" name="category" required class="form-select">
                            <option value="">업종을 선택하세요</option>
                            <option value="한식">한식</option>
                            <option value="일식">일식</option>
                            <option value="중식">중식</option>
                            <option value="양식">양식</option>
                            <option value="카페">카페</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                    <div>
                        <label for="branchAddress" class="block text-sm font-medium text-slate-700">주소</label>
                        <input id="branchAddress" name="address" type="text" required class="form-input" placeholder="주소를 입력하세요">
                    </div>
                    <div>
                        <label for="branchPhone" class="block text-sm font-medium text-slate-700">전화번호</label>
                        <input id="branchPhone" name="phone" type="tel" required class="form-input" placeholder="02-1234-5678">
                    </div>
                    <div>
                        <label for="branchEmail" class="block text-sm font-medium text-slate-700">로그인 이메일</label>
                        <div class="mt-1 flex rounded-md shadow-sm">
                            <input id="branchEmail" name="email" type="email" required class="form-input rounded-none rounded-l-md" placeholder="로그인 시 사용할 이메일">
                            <button type="button" id="sendVerificationBtnBranch"
                                    class="relative -ml-px inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-r-md text-slate-700 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-1 focus:ring-sky-500 focus:border-sky-500">
                                인증번호 발송
                            </button>
                        </div>
                        <p id="emailMessageBranch" class="mt-2 text-sm"></p>
                    </div>
                    <div id="verificationCodeGroupBranch" class="hidden">
                        <label for="verificationCodeBranch" class="block text-sm font-medium text-slate-700">인증번호</label>
                        <input type="text" id="verificationCodeBranch" name="verificationCode" required class="form-input" placeholder="이메일로 받은 인증번호 6자리를 입력하세요">
                    </div>
                    <div>
                        <label for="branchPassword" class="block text-sm font-medium text-slate-700">비밀번호</label>
                        <input id="branchPassword" name="password" type="password" required class="form-input" placeholder="영문, 숫자 포함 8자 이상">
                    </div>
                    <div>
                        <label for="branchConfirmPassword" class="block text-sm font-medium text-slate-700">비밀번호 확인</label>
                        <input id="branchConfirm-password" name="confirmPassword" type="password" required class="form-input" placeholder="비밀번호를 다시 입력하세요">
                    </div>
                    <div>
                        <label for="branchDescription" class="block text-sm font-medium text-slate-700">사업체 소개</label>
                        <textarea id="branchDescription" name="description" rows="3" class="form-textarea" placeholder="사업체에 대한 간단한 소개를 작성해주세요"></textarea>
                    </div>
                    <div>
                        <button type="submit" class="form-btn-primary">가입 신청</button>
                    </div>
                </form>
            </div>
            <div id="register-individual-content" class="hidden">
                <form class="space-y-5" action="${pageContext.request.contextPath}/business-register" method="post">
                    <input type="hidden" name="userType" value="BUSINESS_INDIVIDUAL">
                    <div>
                        <label for="individualBusinessName" class="block text-sm font-medium text-slate-700">사업체명 (개인 사업자명)</label>
                        <div class="mt-1 flex rounded-md shadow-sm">
	                        <input id="individualBusinessName" name="businessName" type="text" required class="form-input rounded-none rounded-l-md" placeholder="상호명을 입력하세요">
	                        <button type="button" id="checkNicknameBtnIndividual"
	                                class="relative -ml-px inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-r-md text-slate-700 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-1 focus:ring-sky-500 focus:border-sky-500">
	                            중복 확인
	                        </button>
                        </div>
                        <p id="nicknameMessageIndividual" class="mt-2 text-sm"></p>
                    </div>
                    <div>
                        <label for="individualOwnerName" class="block text-sm font-medium text-slate-700">대표자명</label>
                        <input id="individualOwnerName" name="ownerName" type="text" required class="form-input" placeholder="대표자명을 입력하세요">
                    </div>
                    <div>
                        <label for="individualBusinessNumber" class="block text-sm font-medium text-slate-700">사업자등록번호</label>
                        <input id="individualBusinessNumber" name="businessNumber" type="text" required class="form-input" placeholder="'-' 포함 10자리">
                    </div>
                    <div>
                        <label for="individualCategory" class="block text-sm font-medium text-slate-700">업종</label>
                        <select id="individualCategory" name="category" required class="form-select">
                            <option value="">업종을 선택하세요</option>
                            <option value="한식">한식</option>
                            <option value="일식">일식</option>
                            <option value="중식">중식</option>
                            <option value="양식">양식</option>
                            <option value="카페">카페</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                    <div>
                        <label for="individualAddress" class="block text-sm font-medium text-slate-700">주소</label>
                        <input id="individualAddress" name="address" type="text" required class="form-input" placeholder="주소를 입력하세요">
                    </div>
                    <div>
                        <label for="individualPhone" class="block text-sm font-medium text-slate-700">전화번호</label>
                        <input id="individualPhone" name="phone" type="tel" required class="form-input" placeholder="02-1234-5678">
                    </div>
                    <div>
                        <label for="individualEmail" class="block text-sm font-medium text-slate-700">로그인 이메일</label>
                        <div class="mt-1 flex rounded-md shadow-sm">
                            <input id="individualEmail" name="email" type="email" required class="form-input rounded-none rounded-l-md" placeholder="로그인 시 사용할 이메일">
                            <button type="button" id="sendVerificationBtnIndividual"
                                    class="relative -ml-px inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-r-md text-slate-700 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-1 focus:ring-sky-500 focus:border-sky-500">
                                인증번호 발송
                            </button>
                        </div>
                        <p id="emailMessageIndividual" class="mt-2 text-sm"></p>
                    </div>
                    <div id="verificationCodeGroupIndividual" class="hidden">
                        <label for="verificationCodeIndividual" class="block text-sm font-medium text-slate-700">인증번호</label>
                        <input type="text" id="verificationCodeIndividual" name="verificationCode" required class="form-input" placeholder="이메일로 받은 인증번호 6자리를 입력하세요">
                    </div>
                    <div>
                        <label for="individualPassword" class="block text-sm font-medium text-slate-700">비밀번호</label>
                        <input id="individualPassword" name="password" type="password" required class="form-input" placeholder="영문, 숫자 포함 8자 이상">
                    </div>
                    <div>
                        <label for="individualConfirmPassword" class="block text-sm font-medium text-slate-700">비밀번호 확인</label>
                        <input id="individualConfirmPassword" name="confirmPassword" type="password" required class="form-input" placeholder="비밀번호를 다시 입력하세요">
                    </div>
                    <div>
                        <label for="individualDescription" class="block text-sm font-medium text-slate-700">사업체 소개</label>
                        <textarea id="individualDescription" name="description" rows="3" class="form-textarea" placeholder="사업체에 대한 간단한 소개를 작성해주세요"></textarea>
                    </div>
                    <div>
                        <button type="submit" class="form-btn-primary">가입 신청</button>
                    </div>
                </form>
            </div>
            
            <div class="text-center text-sm mt-6">
                <a href="${pageContext.request.contextPath}/login" class="font-medium text-sky-600 hover:text-sky-500">
                	이미 계정이 있으신가요? 로그인
                </a>
            </div>
        </div>
    </main>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tabs = document.querySelectorAll('#register-tabs button');
            const hqContent = document.getElementById('register-hq-content');
            const branchContent = document.getElementById('register-branch-content');
            const individualContent = document.getElementById('register-individual-content');
            tabs.forEach(clickedTab => {
                clickedTab.addEventListener('click', () => {
                    tabs.forEach(tab => {
                        tab.classList.remove('tab-active');
                        tab.classList.add('text-slate-500', 'border-transparent');
                    });
                    
                    clickedTab.classList.add('tab-active');
                    clickedTab.classList.remove('text-slate-500', 'border-transparent');
                    if (clickedTab.dataset.tab === 'hq') {
                        hqContent.classList.remove('hidden');
                        branchContent.classList.add('hidden');
                        individualContent.classList.add('hidden');
                    } else if (clickedTab.dataset.tab === 'branch') {
                        hqContent.classList.add('hidden');
                        individualContent.classList.add('hidden');
                        branchContent.classList.remove('hidden');
                    } else {
                    	hqContent.classList.add('hidden');
                        branchContent.classList.add('hidden');
                        individualContent.classList.remove('hidden');
                    }
                });
            });

            // --- 이메일 인증 스크립트 ---
            const handleSendVerification = async (emailInput, messageEl, codeGroupEl, buttonEl) => {
                const email = emailInput.value;
                if (!email) {
                    messageEl.textContent = '이메일을 입력해주세요.';
                    messageEl.className = 'mt-2 text-sm text-red-600';
                    return;
                }

                buttonEl.disabled = true;
                buttonEl.textContent = '전송 중...';

                try {
                    const response = await fetch('${pageContext.request.contextPath}/verify-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'email=' + encodeURIComponent(email)
                    });

                    const result = await response.json();
                    messageEl.textContent = result.message;

                    if (response.ok) {
                        messageEl.className = 'mt-2 text-sm text-green-600';
                        codeGroupEl.classList.remove('hidden');
                    } else {
                        messageEl.className = 'mt-2 text-sm text-red-600';
                        buttonEl.disabled = false;
                        buttonEl.textContent = '인증번호 발송';
                    }
                } catch (error) {
                    console.error('Error:', error);
                    messageEl.textContent = '오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                    messageEl.className = 'mt-2 text-sm text-red-600';
                    buttonEl.disabled = false;
                    buttonEl.textContent = '인증번호 발송';
                }
            };

            // HQ 회원
            document.getElementById('sendVerificationBtnHq').addEventListener('click', () => {
                handleSendVerification(
                    document.getElementById('hqEmail'),
                    document.getElementById('emailMessageHq'),
                    document.getElementById('verificationCodeGroupHq'),
                    document.getElementById('sendVerificationBtnHq')
                );
            });

            // 지점 회원
            document.getElementById('sendVerificationBtnBranch').addEventListener('click', () => {
                handleSendVerification(document.getElementById('branchEmail'), document.getElementById('emailMessageBranch'), document.getElementById('verificationCodeGroupBranch'), document.getElementById('sendVerificationBtnBranch'));
            });

            // 개인 사업자 회원
            document.getElementById('sendVerificationBtnIndividual').addEventListener('click', () => {
                handleSendVerification(document.getElementById('individualEmail'), document.getElementById('emailMessageIndividual'), document.getElementById('verificationCodeGroupIndividual'), document.getElementById('sendVerificationBtnIndividual'));
            });

            // --- 닉네임 중복 확인 스크립트 ---
            const handleCheckNickname = async (nicknameInput, messageEl, buttonEl) => {
                const nickname = nicknameInput.value;
                if (!nickname) {
                    messageEl.textContent = '사업체명을 입력해주세요.';
                    messageEl.className = 'mt-2 text-sm text-red-600';
                    return;
                }

                buttonEl.disabled = true;
                buttonEl.textContent = '확인 중...';

                try {
                    const response = await fetch('${pageContext.request.contextPath}/check-nickname', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'nickname=' + encodeURIComponent(nickname)
                    });

                    const result = await response.json();
                    messageEl.textContent = result.message;

                    if (response.ok) {
                        messageEl.className = 'mt-2 text-sm text-green-600';
                    } else {
                        messageEl.className = 'mt-2 text-sm text-red-600';
                    }
                } catch (error) {
                    console.error('Error:', error);
                    messageEl.textContent = '오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                    messageEl.className = 'mt-2 text-sm text-red-600';
                } finally {
                    buttonEl.disabled = false;
                    buttonEl.textContent = '중복 확인';
                }
            };

            // HQ 회원 닉네임(사업체명) 중복 확인
            document.getElementById('checkNicknameBtnHq').addEventListener('click', () => {
                handleCheckNickname(document.getElementById('hqBusinessName'), document.getElementById('nicknameMessageHq'), document.getElementById('checkNicknameBtnHq'));
            });

            // 지점 회원 닉네임(사업체명) 중복 확인
            document.getElementById('checkNicknameBtnBranch').addEventListener('click', () => {
                handleCheckNickname(document.getElementById('branchBusinessName'), document.getElementById('nicknameMessageBranch'), document.getElementById('checkNicknameBtnBranch'));
            });

            // 개인 사업자 회원 닉네임(사업체명) 중복 확인
            document.getElementById('checkNicknameBtnIndividual').addEventListener('click', () => {
                handleCheckNickname(document.getElementById('individualBusinessName'), document.getElementById('nicknameMessageIndividual'), document.getElementById('checkNicknameBtnIndividual'));
            });
        });
    </script>
</body>
</html>