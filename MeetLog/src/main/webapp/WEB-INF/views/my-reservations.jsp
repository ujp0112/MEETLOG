<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 내 예약</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- Standardized header include path --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="mb-6 flex justify-between items-center">
                    <div>
                        <h2 class="text-2xl md:text-3xl font-bold mb-2">내 예약</h2>
                        <p class="text-slate-600">예약 내역을 관리하세요.</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <div class="space-y-4">
                                    <c:forEach var="reservation" items="${reservations}">
                                        <%-- Define status-specific variables for cleaner HTML --%>
                                        <c:set var="statusClass" value="bg-slate-100 text-slate-800" />
                                        <c:set var="statusText" value="${reservation.status}" />
                                        <c:if test="${reservation.status == 'CONFIRMED'}">
                                            <c:set var="statusClass" value="bg-green-100 text-green-800" />
                                            <c:set var="statusText" value="확정" />
                                        </c:if>
                                        <c:if test="${reservation.status == 'PENDING'}">
                                            <c:set var="statusClass" value="bg-yellow-100 text-yellow-800" />
                                            <c:set var="statusText" value="대기중" />
                                        </c:if>
                                        <c:if test="${reservation.status == 'CANCELLED'}">
                                            <c:set var="statusClass" value="bg-red-100 text-red-800" />
                                            <c:set var="statusText" value="취소됨" />
                                        </c:if>

                                        <div class="bg-white p-6 rounded-xl shadow-lg">
                                            <div class="flex items-start justify-between mb-4">
                                                <div class="flex-grow">
                                                    <div class="flex items-center mb-2">
                                                        <h3 class="text-lg font-bold text-slate-800 mr-3">예약 #${reservation.id}</h3>
                                                        <span class="px-2 py-1 text-xs rounded-full ${statusClass}">
                                                            ${statusText}
                                                        </span>
                                                    </div>
                                                    <p class="text-slate-600 text-sm mb-2">맛집 ID: ${reservation.restaurantId}</p>
                                                    <p class="text-slate-700 mb-2">예약 날짜: ${reservation.reservationTime}</p>
                                                    <p class="text-slate-700">인원: ${reservation.partySize}명</p>
                                                    <c:if test="${not empty reservation.specialRequests}">
                                                        <p class="text-slate-600 text-sm mt-2">특별 요청: ${reservation.specialRequests}</p>
                                                    </c:if>
                                                    <c:if test="${reservation.status == 'CANCELLED' && not empty reservation.cancelReason}">
                                                        <p class="text-red-600 text-sm mt-2">취소 사유: ${reservation.cancelReason}</p>
                                                        <c:if test="${reservation.cancelledAtAsDate ne null}">
                                                            <p class="text-xs text-slate-500 mt-1">취소일: <fmt:formatDate value="${reservation.cancelledAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                        </c:if>
                                                    </c:if>
                                                </div>
                                                <div class="text-right">
                                                    <p class="text-sm text-slate-500 mb-2">예약일: <fmt:formatDate value="${reservation.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                    <c:if test="${reservation.status == 'CONFIRMED'}">
                                                        <p class="text-sm text-green-600 font-medium">예약 확정됨</p>
                                                    </c:if>
                                                     <c:if test="${reservation.status == 'PENDING'}">
                                                        <p class="text-sm text-yellow-600 font-medium">승인 대기중</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="flex items-center justify-between pt-4 border-t border-slate-200">
                                                <div class="flex items-center space-x-2">
                                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${reservation.restaurantId}" 
                                                       class="text-sky-600 hover:text-sky-700 text-sm font-medium">맛집 보기</a>
                                                    <span class="text-slate-300">|</span>
                                                    <a href="${pageContext.request.contextPath}/reservation/detail/${reservation.id}" 
                                                       class="text-slate-600 hover:text-slate-700 text-sm font-medium">상세보기</a>
                                                </div>
                                                <div class="flex items-center space-x-2">
                                                    <c:if test="${reservation.status == 'PENDING' || reservation.status == 'CONFIRMED'}">
                                                        <button onclick="cancelReservation(${reservation.id})" 
                                                                class="text-red-600 hover:text-red-700 text-sm font-medium">취소</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">📅</div>
                                    <h3 class="text-xl font-bold text-slate-800 mb-2">예약 내역이 없습니다</h3>
                                    <p class="text-slate-600 mb-6">맛집을 예약해보세요!</p>
                                    <a href="${pageContext.request.contextPath}/main" 
                                       class="inline-block bg-sky-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-sky-700">
                                        맛집 둘러보기
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🔒</div>
                            <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                            <p class="text-slate-600 mb-6">예약을 관리하려면 로그인해주세요.</p>
                            <a href="${pageContext.request.contextPath}/login" 
                               class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                로그인하기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <%-- Replaced inline footer with a reusable component --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <div id="cancel-modal" class="fixed inset-0 z-50 hidden">
        <div class="absolute inset-0 bg-slate-900/50" data-cancel-overlay="true"></div>
        <div class="relative z-10 flex min-h-full items-center justify-center p-4">
            <div class="w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">
                <div class="flex items-start justify-between">
                    <div>
                        <h2 class="text-xl font-semibold text-slate-800">예약 취소</h2>
                        <p class="mt-1 text-sm text-slate-500">취소 사유를 입력한 후 확정해 주세요. (최대 500자)</p>
                    </div>
                    <button type="button" class="text-slate-400 hover:text-slate-600" data-cancel-close="true" aria-label="닫기">
                        &times;
                    </button>
                </div>

                <div class="mt-4">
                    <label for="cancel-reason" class="mb-2 block text-sm font-medium text-slate-700">취소 사유</label>
                    <textarea id="cancel-reason" rows="5" class="w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-sky-500 focus:outline-none focus:ring-2 focus:ring-sky-200" placeholder="예: 갑작스러운 일정 변경으로 방문이 어려워요."></textarea>
                    <div class="mt-2 flex items-center justify-between text-xs text-slate-500">
                        <span id="cancel-error" class="text-red-500"></span>
                        <span id="cancel-char-count">0 / 500</span>
                    </div>
                </div>

                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" class="rounded-lg border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600 hover:bg-slate-100" data-cancel-close="true">
                        돌아가기
                    </button>
                    <button type="button" id="cancel-confirm-btn" data-success-message="예약이 성공적으로 취소되었습니다." class="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-red-700 disabled:cursor-not-allowed disabled:opacity-50">
                        예약 취소 확정
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        (function() {
            const cancelModal = document.getElementById('cancel-modal');
            const cancelReasonField = document.getElementById('cancel-reason');
            const cancelConfirmBtn = document.getElementById('cancel-confirm-btn');
            const cancelError = document.getElementById('cancel-error');
            const cancelCharCount = document.getElementById('cancel-char-count');
            const cancelCloseButtons = document.querySelectorAll('[data-cancel-close]');
            let pendingReservationId = null;

            if (!cancelModal || !cancelReasonField || !cancelConfirmBtn) {
                return;
            }

            const successMessage = cancelConfirmBtn.dataset.successMessage || '예약이 취소되었습니다.';

            const setConfirmDisabled = (disabled) => {
                cancelConfirmBtn.disabled = disabled;
                cancelConfirmBtn.classList.toggle('cursor-not-allowed', disabled);
                cancelConfirmBtn.classList.toggle('opacity-50', disabled);
            };

            const updateCharCount = () => {
                const length = cancelReasonField.value.trim().length;
                cancelCharCount.textContent = `${length} / 500`;
                let disabled = false;
                if (length === 0) {
                    cancelError.textContent = '';
                    disabled = true;
                } else if (length > 500) {
                    cancelError.textContent = '취소 사유는 500자 이내로 입력해주세요.';
                    disabled = true;
                } else {
                    cancelError.textContent = '';
                }
                setConfirmDisabled(disabled);
            };

            const openCancelModal = (reservationId) => {
                pendingReservationId = reservationId;
                cancelReasonField.value = '';
                cancelError.textContent = '';
                updateCharCount();
                cancelModal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
                setTimeout(() => cancelReasonField.focus(), 50);
            };

            const closeCancelModal = () => {
                pendingReservationId = null;
                cancelModal.classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            };

            const submitCancellation = () => {
                const reason = cancelReasonField.value.trim();
                if (!pendingReservationId) {
                    return;
                }
                if (!reason) {
                    cancelError.textContent = '취소 사유를 입력해주세요.';
                    setConfirmDisabled(true);
                    cancelReasonField.focus();
                    cancelCharCount.textContent = '0 / 500';
                    return;
                }
                if (reason.length > 500) {
                    cancelError.textContent = '취소 사유는 500자 이내로 입력해주세요.';
                    setConfirmDisabled(true);
                    return;
                }

                const payload = new URLSearchParams();
                payload.append('reservationId', pendingReservationId);
                payload.append('cancelReason', reason);

                const originalText = cancelConfirmBtn.dataset.originalText || cancelConfirmBtn.textContent;
                cancelConfirmBtn.dataset.originalText = originalText;
                cancelConfirmBtn.textContent = '처리 중...';
                setConfirmDisabled(true);

                fetch('${pageContext.request.contextPath}/reservation/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: payload.toString()
                })
                .then(response => response.json().then(data => ({ ok: response.ok, body: data })))
                .then(({ ok, body }) => {
                    if (ok && body.success) {
                        closeCancelModal();
                        alert(successMessage);
                        location.reload();
                    } else {
                        cancelError.textContent = body.message || '예약 취소 중 오류가 발생했습니다.';
                        setConfirmDisabled(false);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    cancelError.textContent = '예약 취소 중 오류가 발생했습니다.';
                    setConfirmDisabled(false);
                })
                .finally(() => {
                    cancelConfirmBtn.textContent = cancelConfirmBtn.dataset.originalText || '예약 취소 확정';
                });
            };

            cancelReasonField.addEventListener('input', updateCharCount);
            cancelConfirmBtn.addEventListener('click', submitCancellation);
            cancelCloseButtons.forEach(button => button.addEventListener('click', closeCancelModal));
            cancelModal.addEventListener('click', (event) => {
                if (event.target.dataset.cancelOverlay === 'true') {
                    closeCancelModal();
                }
            });
            document.addEventListener('keydown', (event) => {
                if (event.key === 'Escape' && !cancelModal.classList.contains('hidden')) {
                    closeCancelModal();
                }
            });

            window.cancelReservation = openCancelModal;
        })();
    </script>
</body>
</html>
