<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 예약 상세</title>
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
                <div class="max-w-2xl mx-auto">
                    <c:choose>
                        <c:when test="${not empty reservation}">
                            <%-- Set status-specific variables for cleaner HTML --%>
                            <c:set var="statusClass" value="bg-slate-500 text-white" />
                            <c:set var="statusText" value="${reservation.status}" />
                            <c:if test="${reservation.status == 'CONFIRMED'}">
                                <c:set var="statusClass" value="bg-green-500 text-white" />
                                <c:set var="statusText" value="확정" />
                            </c:if>
                            <c:if test="${reservation.status == 'PENDING'}">
                                <c:set var="statusClass" value="bg-yellow-500 text-white" />
                                <c:set var="statusText" value="대기중" />
                            </c:if>
                            <c:if test="${reservation.status == 'CANCELLED'}">
                                <c:set var="statusClass" value="bg-red-500 text-white" />
                                <c:set var="statusText" value="취소됨" />
                            </c:if>
                            
                            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                                <div class="bg-sky-600 text-white p-6">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <h1 class="text-2xl font-bold">예약 #${reservation.id}</h1>
                                            <p class="text-sky-100 mt-1">예약 상세 정보</p>
                                        </div>
                                        <div class="text-right">
                                            <span class="px-3 py-1 text-sm rounded-full ${statusClass}">
                                                ${statusText}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="p-6">
                                    <div class="mb-6">
                                        <h2 class="text-lg font-bold text-slate-800 mb-3">맛집 정보</h2>
                                        <div class="bg-slate-50 p-4 rounded-lg">
                                            <c:choose>
                                                <c:when test="${not empty restaurant}">
                                                    <h3 class="font-semibold text-slate-800 mb-2">${restaurant.name}</h3>
                                                    <p class="text-slate-600 text-sm mb-1">${restaurant.category} • ${restaurant.location}</p>
                                                    <p class="text-slate-600 text-sm mb-1">주소: ${restaurant.address}</p>
                                                    <c:if test="${not empty restaurant.phone}">
                                                        <p class="text-slate-600 text-sm">전화: ${restaurant.phone}</p>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-slate-600">맛집 정보를 불러올 수 없습니다.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="mb-6">
                                        <h2 class="text-lg font-bold text-slate-800 mb-3">예약 정보</h2>
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">예약 날짜</h3>
                                                <p class="text-slate-800"><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></p>
                                            </div>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">예약 시간</h3>
                                                <p class="text-slate-800">${reservation.reservationTimeStr}</p>
                                            </div>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">인원 수</h3>
                                                <p class="text-slate-800">${reservation.partySize}명</p>
                                            </div>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <h3 class="font-medium text-slate-700 mb-2">연락처</h3>
                                                <p class="text-slate-800">${reservation.contactPhone}</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty reservation.specialRequests}">
                                        <div class="mb-6">
                                            <h2 class="text-lg font-bold text-slate-800 mb-3">특별 요청사항</h2>
                                            <div class="bg-slate-50 p-4 rounded-lg">
                                                <p class="text-slate-700">${reservation.specialRequests}</p>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${reservation.depositRequired}">
                                        <div class="mb-6">
                                            <h2 class="text-lg font-bold text-slate-800 mb-3">예약금 정보</h2>
                                            <div class="p-4 rounded-lg border ${reservation.paymentStatus == 'PAID' ? 'bg-emerald-50 border-emerald-200' : reservation.paymentStatus == 'PENDING' ? 'bg-amber-50 border-amber-200' : 'bg-red-50 border-red-200'}">
                                                <div class="flex items-start justify-between">
                                                    <div class="flex-1">
                                                        <h3 class="font-medium text-slate-700 mb-1">예약금 금액</h3>
                                                        <p class="text-2xl font-bold ${reservation.paymentStatus == 'PAID' ? 'text-emerald-700' : reservation.paymentStatus == 'PENDING' ? 'text-amber-700' : 'text-red-700'}">
                                                            <fmt:formatNumber value="${reservation.depositAmount}" pattern="#,##0"/>원
                                                        </p>
                                                        <c:if test="${not empty reservation.paymentProvider}">
                                                            <p class="text-sm text-slate-600 mt-2">결제 수단: ${reservation.paymentProvider}</p>
                                                        </c:if>
                                                        <c:if test="${not empty reservation.paymentOrderId}">
                                                            <p class="text-xs text-slate-500 mt-1">주문번호: ${reservation.paymentOrderId}</p>
                                                        </c:if>
                                                    </div>
                                                    <div class="text-right">
                                                        <c:choose>
                                                            <c:when test="${reservation.paymentStatus == 'PAID'}">
                                                                <span class="inline-block px-3 py-1 rounded-full text-sm font-semibold text-emerald-700 bg-emerald-100">결제 완료</span>
                                                                <c:if test="${reservation.paymentApprovedAt != null}">
                                                                    <p class="text-xs text-emerald-700 mt-2">
                                                                        승인: <fmt:formatDate value="${reservation.paymentApprovedAtAsDate}" pattern="yyyy-MM-dd HH:mm" />
                                                                    </p>
                                                                </c:if>
                                                            </c:when>
                                                            <c:when test="${reservation.paymentStatus == 'PENDING'}">
                                                                <span class="inline-block px-3 py-1 rounded-full text-sm font-semibold text-amber-700 bg-amber-100">결제 대기</span>
                                                                <p class="text-xs text-amber-700 mt-2">결제를 완료해주세요</p>
                                                            </c:when>
                                                            <c:when test="${reservation.paymentStatus == 'FAILED'}">
                                                                <span class="inline-block px-3 py-1 rounded-full text-sm font-semibold text-red-700 bg-red-100">결제 실패</span>
                                                                <p class="text-xs text-red-700 mt-2">다시 시도해주세요</p>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-block px-3 py-1 rounded-full text-sm font-semibold text-slate-700 bg-slate-100">${reservation.paymentStatus}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="mb-6">
                                        <h2 class="text-lg font-bold text-slate-800 mb-3">예약 일정</h2>
                                        <div class="space-y-2 text-sm">
                                            <div class="flex justify-between">
                                                <span class="text-slate-600">예약 신청:</span>
                                                <span class="text-slate-800"><fmt:formatDate value="${reservation.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                                            </div>
                                            <c:if test="${not empty reservation.updatedAt}">
                                                <div class="flex justify-between">
                                                    <span class="text-slate-600">마지막 수정:</span>
                                                    <span class="text-slate-800"><fmt:formatDate value="${reservation.updatedAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <c:if test="${reservation.status == 'CANCELLED'}">
                                        <div class="mb-6">
                                            <h2 class="text-lg font-bold text-slate-800 mb-3">취소 정보</h2>
                                            <div class="bg-slate-50 p-4 rounded-lg space-y-2">
                                                <c:if test="${not empty reservation.cancelReason}">
                                                    <p class="text-slate-700"><span class="font-semibold">사유:</span> ${reservation.cancelReason}</p>
                                                </c:if>
                                                <c:if test="${reservation.cancelledAtAsDate ne null}">
                                                    <p class="text-slate-600 text-sm">취소일: <fmt:formatDate value="${reservation.cancelledAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="flex justify-between items-center pt-6 border-t border-slate-200">
                                        <a href="${pageContext.request.contextPath}/mypage/reservations" class="text-slate-600 hover:text-slate-800 text-sm font-medium">
                                            ← 예약 목록으로 돌아가기
                                        </a>
                                        
                                        <%-- Show cancel button only if the user is the owner and the status is cancellable --%>
                                        <c:if test="${not empty sessionScope.user and sessionScope.user.id == reservation.userId and (reservation.status == 'PENDING' or reservation.status == 'CONFIRMED')}">
                                            <div class="flex space-x-3">
                                                <button onclick="cancelReservation(${reservation.id})" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 text-sm">
                                                    예약 취소
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12">
                                <div class="text-6xl mb-4">📅</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">예약을 찾을 수 없습니다</h2>
                                <p class="text-slate-600 mb-6">요청하신 예약이 존재하지 않거나 삭제되었습니다.</p>
                                <a href="${pageContext.request.contextPath}/mypage/reservations" class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                    예약 목록으로 돌아가기
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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
                    <button type="button" id="cancel-confirm-btn" data-success-message="예약이 취소되었습니다." class="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-red-700 disabled:cursor-not-allowed disabled:opacity-50">
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
