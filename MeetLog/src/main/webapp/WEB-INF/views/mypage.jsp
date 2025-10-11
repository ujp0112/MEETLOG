<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 마이페이지</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- The header path is standardized based on your first example --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
  
           <div class="container mx-auto p-4 md:p-8">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                   
                         <div class="lg:col-span-1">
                                <div class="bg-white p-6 rounded-xl shadow-lg">
                                    <div class="text-center">
                 
                                        <mytag:image fileName="${sessionScope.user.profileImage}" altText="프로필" cssClass="w-24 h-24 rounded-full mx-auto mb-4" />
                                        <h2 class="text-xl font-bold text-slate-800">${sessionScope.user.nickname}</h2>
    
                                         <p class="text-slate-600 text-sm">${sessionScope.user.email}</p>
                                        <div class="mt-4">
                     
                                         <span class="inline-block bg-sky-100 text-sky-800 text-xs px-2 py-1 rounded-full">
                                                ${sessionScope.user.userType == 'PERSONAL' ? '개인회원' : '기업회원'}
                
                                             </span>
                                        </div>
                                
                                     </div>
                                </div>
                            </div>

                            <div class="lg:col-span-3 space-y-6">
      
                                 <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-sky-600">${fn:length(myReviews)}</div>
                                        <div class="text-sm text-slate-600">작성한 리뷰</div>
                                    </div>
                                     <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                        <div class="text-2xl font-bold text-sky-600">${fn:length(myColumns)}</div>
                                         <div class="text-sm text-slate-600">작성한 칼럼</div>
                                    </div>
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-sky-600">${fn:length(myReservations)}</div>
                                        <div class="text-sm text-slate-600">예약 내역</div>
                                     </div>
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-green-600">${availableCouponCount}</div>
                                        <div class="text-sm text-slate-600">사용 가능한 쿠폰</div>
                                     </div>
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-purple-600">${myCoursesCount}</div>
                                        <div class="text-sm text-slate-600">만든 코스</div>
                                     </div>
                                </div>

                                <!-- <div class="bg-white p-6 rounded-xl shadow-lg">
                                    <h3 class="text-xl font-bold text-slate-800 mb-4">최근 활동</h3>
                                       <div class="space-y-4">
                                         <c:choose>
                                            <c:when test="${not empty myReviews}">
                                                
                                                 <%-- Loop through the first 3 reviews --%>
                                                <c:forEach items="${myReviews}" var="review" begin="0" end="2">
                                         
                                                     <div class="flex items-center p-3 bg-slate-50 rounded-lg">
                                                        <div class="text-2xl mr-3">📝</div>
                          
                                                         <div class="flex-grow">
                                                            <p class="font-medium text-slate-800">
       
                                                                                             <c:choose>
                                           
                                                                                                 <c:when test="${fn:length(review.content) > 50}">
                                                                        
                                                                                                     ${fn:substring(review.content, 0, 50)}...
                                                                    </c:when>
                              
                                                                                                     <c:otherwise>
                                                              
                                                                                                         ${review.content}
                                                                    </c:otherwise>
                      
                                                                                                 </c:choose>
                                                          
                                                               </p>
                                                            <p class="text-sm text-slate-500">${review.createdAt}</p>
                                    
                                                         </div>
                                                    </div>
                            
                                                 </c:forEach>
                                            </c:when>
                                    
                                                 <c:otherwise>
                                                <div class="text-center text-slate-500 py-8">
                                         
                                                     <div class="text-4xl mb-2">📝</div>
                                                    <p>아직 작성한 리뷰가 없습니다.</p>
                                
                                                 </div>
                                            </c:otherwise>
                                        
                                         </c:choose>
                                    </div>
                                </div> -->


                                 <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                    <a href="${pageContext.request.contextPath}/mypage/reviews"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">📝</div>
                                        <h4 class="font-bold text-slate-800">내 리뷰</h4>
                                         <p class="text-sm text-slate-600">작성한 리뷰 관리</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/mypage/columns"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                        <div class="text-3xl mb-2">📰</div>
                                         <h4 class="font-bold text-slate-800">내 칼럼</h4>
                                        <p class="text-sm text-slate-600">작성한 칼럼 관리</p>
                                     </a>
                                    <a href="${pageContext.request.contextPath}/mypage/reservations"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">📅</div>
                                        <h4 class="font-bold text-slate-800">예약 내역</h4>
                                         <p class="text-sm text-slate-600">예약 관리</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/mypage/coupons"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">🎫</div>
                                        <h4 class="font-bold text-slate-800">내 쿠폰</h4>
                                         <p class="text-sm text-slate-600">쿠폰 관리 및 사용</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/my-courses"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">🗺️</div>
                                        <h4 class="font-bold text-slate-800">내 코스</h4>
                                         <p class="text-sm text-slate-600">내가 만든 코스 관리</p>
                                    </a>

                                    <!-- 텔레그램 연결 카드 -->
                                    <div id="telegram-card" class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center cursor-pointer">
                                         <div class="text-3xl mb-2">💬</div>
                                        <h4 class="font-bold text-slate-800">텔레그램 알림</h4>
                                         <p id="telegram-status" class="text-sm text-slate-600">연결 확인 중...</p>
                                        <button id="telegram-connect-btn" class="hidden mt-3 bg-sky-600 text-white text-sm px-4 py-2 rounded-lg hover:bg-sky-700">
                                            연결하기
                                        </button>
                                        <button id="telegram-disconnect-btn" class="hidden mt-3 bg-red-600 text-white text-sm px-4 py-2 rounded-lg hover:bg-red-700">
                                            연결 해제
                                        </button>
                                    </div>

                                    <a href="${pageContext.request.contextPath}/mypage/settings"
                                         class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                        <div class="text-3xl mb-2">⚙️</div>
                                         <h4 class="font-bold text-slate-800">설정</h4>
                                        <p class="text-sm text-slate-600">계정 설정</p>
                                    </a>
                                 </div>
                            </div>
                        </div>
                    </c:when>
   
                     <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🔒</div>
                           
                             <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                            <p class="text-slate-600 mb-6">마이페이지를 이용하려면 로그인해주세요.</p>
                            <a href="${pageContext.request.contextPath}/login" 
                               class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                로그인하기
                            </a>
                        </div>
          
                     </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <%-- Replaced the inline footer with a reusable JSP include --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <!-- 텔레그램 QR 코드 모달 -->
    <div id="telegram-modal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl p-8 max-w-md w-full mx-4">
            <h3 class="text-xl font-bold text-slate-800 mb-4 text-center">텔레그램 알림 연결</h3>
            <div class="text-center mb-6">
                <p class="text-sm text-slate-600 mb-4">아래 QR 코드를 스캔하거나 버튼을 클릭하여 텔레그램 봇을 시작하세요.</p>
                <div id="qr-code" class="flex justify-center mb-4"></div>
                <a id="telegram-link" href="#" target="_blank" class="inline-block bg-sky-600 text-white px-6 py-3 rounded-lg hover:bg-sky-700">
                    텔레그램에서 열기
                </a>
            </div>
            <button id="close-modal" class="w-full bg-slate-300 text-slate-700 px-4 py-2 rounded-lg hover:bg-slate-400">
                닫기
            </button>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const telegramCard = document.getElementById('telegram-card');
        const telegramStatus = document.getElementById('telegram-status');
        const connectBtn = document.getElementById('telegram-connect-btn');
        const disconnectBtn = document.getElementById('telegram-disconnect-btn');
        const modal = document.getElementById('telegram-modal');
        const closeModal = document.getElementById('close-modal');
        const telegramLink = document.getElementById('telegram-link');
        const qrCodeDiv = document.getElementById('qr-code');

        let currentState = null;

        // 연결 상태 확인
        function checkTelegramStatus() {
            fetch('${pageContext.request.contextPath}/telegram/link')
                .then(res => res.json())
                .then(data => {
                    if (data.connected) {
                        telegramStatus.textContent = '연결됨 ✓';
                        telegramStatus.classList.remove('text-slate-600');
                        telegramStatus.classList.add('text-green-600');
                        connectBtn.classList.add('hidden');
                        disconnectBtn.classList.remove('hidden');
                        currentState = 'connected';
                    } else {
                        telegramStatus.textContent = '연결 안됨';
                        telegramStatus.classList.remove('text-green-600');
                        telegramStatus.classList.add('text-slate-600');
                        connectBtn.classList.remove('hidden');
                        disconnectBtn.classList.add('hidden');
                        currentState = 'disconnected';
                    }
                })
                .catch(err => {
                    console.error('상태 확인 실패:', err);
                    telegramStatus.textContent = '상태 확인 실패';
                });
        }

        // 연결하기 버튼 클릭
        connectBtn.addEventListener('click', function(e) {
            e.stopPropagation();

            fetch('${pageContext.request.contextPath}/telegram/link', { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        // QR 코드 생성
                        qrCodeDiv.innerHTML = '';
                        new QRCode(qrCodeDiv, {
                            text: data.deepLink,
                            width: 200,
                            height: 200
                        });

                        // 링크 설정
                        telegramLink.href = data.deepLink;

                        // 모달 표시
                        modal.classList.remove('hidden');
                    } else {
                        alert('연결 토큰 발급 실패: ' + (data.error || '알 수 없는 오류'));
                    }
                })
                .catch(err => {
                    console.error('연결 실패:', err);
                    alert('연결 요청 중 오류가 발생했습니다.');
                });
        });

        // 연결 해제 버튼 클릭
        disconnectBtn.addEventListener('click', function(e) {
            e.stopPropagation();

            if (!confirm('텔레그램 알림 연결을 해제하시겠습니까?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/telegram/link', { method: 'DELETE' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert('연결이 해제되었습니다.');
                        checkTelegramStatus();
                    } else {
                        alert('연결 해제 실패: ' + (data.error || data.message || '알 수 없는 오류'));
                    }
                })
                .catch(err => {
                    console.error('연결 해제 실패:', err);
                    alert('연결 해제 중 오류가 발생했습니다.');
                });
        });

        // 모달 닫기
        closeModal.addEventListener('click', function() {
            modal.classList.add('hidden');
            checkTelegramStatus(); // 상태 다시 확인
        });

        // 모달 배경 클릭 시 닫기
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.classList.add('hidden');
                checkTelegramStatus();
            }
        });

        // 초기 상태 확인
        checkTelegramStatus();
    });
    </script>
</body>
</html>