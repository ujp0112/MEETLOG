<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 개인정보처리방침</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- Replaced the hardcoded header with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-4xl mx-auto bg-white rounded-xl shadow-lg p-8">
                    <h1 class="text-3xl font-bold text-slate-800 mb-8">개인정보처리방침</h1>
                    
                    <div class="prose max-w-none">
                        <h2 class="text-xl font-bold text-slate-800 mb-4">제1조 (개인정보의 처리목적)</h2>
                        <p class="text-slate-700 mb-6">
                            MEET LOG(이하 "회사")는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.
                        </p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>회원 가입 및 관리</li>
                            <li>서비스 제공 및 계약 이행</li>
                            <li>고객 상담 및 불만 처리</li>
                            <li>마케팅 및 광고에의 활용</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제2조 (개인정보의 처리 및 보유기간)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제3조 (처리하는 개인정보의 항목)</h2>
                        <p class="text-slate-700 mb-4">회사는 다음의 개인정보 항목을 처리하고 있습니다:</p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>필수항목: 이메일, 닉네임, 비밀번호</li>
                            <li>선택항목: 프로필 이미지, 연락처</li>
                            <li>자동수집항목: IP주소, 쿠키, 접속기록, 서비스 이용기록</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제4조 (개인정보의 제3자 제공)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 정보주체의 개인정보를 제1조(개인정보의 처리목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보보호법 제17조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제5조 (개인정보처리의 위탁)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다:
                        </p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>위탁받는 자: AWS (Amazon Web Services)</li>
                            <li>위탁하는 업무의 내용: 클라우드 서버 운영 및 데이터 저장</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제6조 (정보주체의 권리·의무 및 행사방법)</h2>
                        <p class="text-slate-700 mb-4">정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다:</p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>개인정보 처리현황 통지요구</li>
                            <li>개인정보 열람요구</li>
                            <li>개인정보 정정·삭제요구</li>
                            <li>개인정보 처리정지요구</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제7조 (개인정보의 파기)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다. 정보주체로부터 동의받은 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)에 옮기거나 보관장소를 달리하여 보존합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제8조 (개인정보의 안전성 확보조치)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다:
                        </p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>관리적 조치: 내부관리계획 수립·시행, 정기적 직원 교육 등</li>
                            <li>기술적 조치: 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 개인정보의 암호화, 보안프로그램 설치</li>
                            <li>물리적 조치: 전산실, 자료보관실 등의 접근통제</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제9조 (개인정보보호책임자)</h2>
                        <p class="text-slate-700 mb-4">회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보보호책임자를 지정하고 있습니다:</p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>개인정보보호책임자: MEET LOG 개발팀</li>
                            <li>연락처: privacy@meetlog.com</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제10조 (권익침해 구제방법)</h2>
                        <p class="text-slate-700 mb-6">
                            정보주체는 개인정보침해신고센터, 개인정보 분쟁조정위원회, 정보보호마크인증위원회 등에 개인정보 침해신고나 분쟁조정을 신청할 수 있습니다.
                        </p>

                        <div class="mt-8 pt-6 border-t border-slate-200">
                            <p class="text-sm text-slate-500">
                                이 개인정보처리방침은 2025년 1월 1일부터 시행됩니다.<br>
                                문의사항이 있으시면 개인정보보호책임자에게 연락해주세요.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <%-- Replaced the hardcoded footer with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>