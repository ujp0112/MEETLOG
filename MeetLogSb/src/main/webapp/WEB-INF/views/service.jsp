<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 이용약관</title>
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
                    <h1 class="text-3xl font-bold text-slate-800 mb-8">이용약관</h1>
                    
                    <div class="prose max-w-none">
                        <h2 class="text-xl font-bold text-slate-800 mb-4">제1조 (목적)</h2>
                        <p class="text-slate-700 mb-6">
                            이 약관은 MEET LOG(이하 "회사")가 제공하는 맛집 추천 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제2조 (정의)</h2>
                        <p class="text-slate-700 mb-4">이 약관에서 사용하는 용어의 정의는 다음과 같습니다:</p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>"서비스"란 회사가 제공하는 맛집 정보, 리뷰, 예약 등의 서비스를 의미합니다.</li>
                            <li>"이용자"란 서비스에 접속하여 이 약관에 따라 서비스를 이용하는 회원 및 비회원을 의미합니다.</li>
                            <li>"회원"이란 서비스에 개인정보를 제공하여 회원등록을 한 자로서, 서비스의 정보를 지속적으로 제공받으며 서비스를 계속적으로 이용할 수 있는 자를 의미합니다.</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제3조 (약관의 효력 및 변경)</h2>
                        <p class="text-slate-700 mb-6">
                            이 약관은 서비스를 이용하고자 하는 모든 이용자에 대하여 그 효력을 발생합니다. 회사는 필요하다고 인정되는 경우 이 약관을 변경할 수 있으며, 변경된 약관은 서비스 내 공지사항을 통해 공지합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제4조 (서비스의 제공)</h2>
                        <p class="text-slate-700 mb-4">회사는 다음과 같은 서비스를 제공합니다:</p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>맛집 정보 제공 및 검색 서비스</li>
                            <li>리뷰 작성 및 조회 서비스</li>
                            <li>맛집 예약 서비스</li>
                            <li>칼럼 작성 및 조회 서비스</li>
                            <li>기타 회사가 정하는 서비스</li>
                        </ul>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제5조 (서비스의 중단)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다. 이 경우 회사는 제9조에 정한 방법으로 이용자에게 통지합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제6조 (회원가입)</h2>
                        <p class="text-slate-700 mb-6">
                            이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다. 회사는 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제7조 (회원 탈퇴 및 자격 상실 등)</h2>
                        <p class="text-slate-700 mb-6">
                            회원은 회사에 언제든지 탈퇴를 요청할 수 있으며 회사는 즉시 회원탈퇴를 처리합니다. 회원이 다음 각 호의 사유에 해당하는 경우, 회사는 회원자격을 제한 및 정지시킬 수 있습니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제8조 (개인정보보호)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 관련법령이 정하는 바에 따라서 이용자 등록정보를 포함한 이용자의 개인정보를 보호하기 위해 노력합니다. 이용자의 개인정보보호에 관해서는 관련법령 및 회사가 정하는 개인정보처리방침에 정한 바에 의합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제9조 (회사의 의무)</h2>
                        <p class="text-slate-700 mb-6">
                            회사는 법령과 이 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 이 약관이 정하는 바에 따라 지속적이고, 안정적으로 서비스를 제공하는데 최선을 다하여야 합니다.
                        </p>

                        <h2 class="text-xl font-bold text-slate-800 mb-4">제10조 (이용자의 의무)</h2>
                        <p class="text-slate-700 mb-4">이용자는 다음 행위를 하여서는 안 됩니다:</p>
                        <ul class="list-disc list-inside text-slate-700 mb-6 space-y-2">
                            <li>신청 또는 변경시 허위 내용의 등록</li>
                            <li>타인의 정보 도용</li>
                            <li>회사가 게시한 정보의 변경</li>
                            <li>회사가 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시</li>
                            <li>회사 기타 제3자의 저작권 등 지적재산권에 대한 침해</li>
                            <li>회사 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위</li>
                            <li>외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 서비스에 공개 또는 게시하는 행위</li>
                        </ul>

                        <div class="mt-8 pt-6 border-t border-slate-200">
                            <p class="text-sm text-slate-500">
                                이 약관은 2025년 1월 1일부터 시행됩니다.<br>
                                문의사항이 있으시면 고객센터로 연락해주세요.
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