<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 관리 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .btn-secondary { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4); }
        .btn-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-success:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(16, 185, 129, 0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4); }
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .status-pending { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
        .status-confirmed { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        .status-cancelled { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl fade-in">
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold gradient-text">예약 관리</h1>
                <div class="flex space-x-4">
                    <select class="px-4 py-2 border-2 border-slate-200 rounded-xl focus:border-blue-500 focus:outline-none">
                        <option>전체</option>
                        <option>대기중</option>
                        <option>확정</option>
                        <option>취소</option>
                    </select>
                    <button class="btn-primary text-white px-6 py-3 rounded-2xl font-semibold">
                        📊 통계 보기
                    </button>
                </div>
            </div>
            
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <c:forEach var="reservation" items="${reservations}">
                            <div class="glass-card p-6 rounded-2xl card-hover">
                                <div class="flex justify-between items-start mb-4">
                                    <div class="flex-1">
                                        <h3 class="text-xl font-bold text-slate-800">${reservation.restaurantName}</h3>
                                        <p class="text-slate-600">예약자: ${reservation.customerName}</p>
                                        <p class="text-slate-600">연락처: ${reservation.customerPhone}</p>
                                    </div>
                                    <div class="text-right">
                                        <span class="status-${reservation.status} text-white px-4 py-2 rounded-full text-sm font-semibold">
                                            ${reservation.status == 'PENDING' ? '대기중' : 
                                              reservation.status == 'CONFIRMED' ? '확정' : '취소'}
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                                    <div class="p-4 bg-slate-50 rounded-xl">
                                        <p class="text-sm text-slate-600">예약 날짜</p>
                                        <p class="font-semibold text-slate-800">${reservation.reservationDate}</p>
                                    </div>
                                    <div class="p-4 bg-slate-50 rounded-xl">
                                        <p class="text-sm text-slate-600">예약 시간</p>
                                        <p class="font-semibold text-slate-800">${reservation.reservationTime}</p>
                                    </div>
                                    <div class="p-4 bg-slate-50 rounded-xl">
                                        <p class="text-sm text-slate-600">인원</p>
                                        <p class="font-semibold text-slate-800">${reservation.partySize}명</p>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty reservation.specialRequests}">
                                    <div class="p-4 bg-blue-50 rounded-xl mb-4">
                                        <p class="text-sm text-blue-600 font-semibold">특별 요청사항</p>
                                        <p class="text-blue-800">${reservation.specialRequests}</p>
                                    </div>
                                </c:if>
                                
                                <div class="flex space-x-2">
                                    <c:if test="${reservation.status == 'PENDING'}">
                                        <form method="post" action="${pageContext.request.contextPath}/business/reservation/update-status" style="display: inline;">
                                            <input type="hidden" name="reservationId" value="${reservation.id}">
                                            <input type="hidden" name="status" value="CONFIRMED">
                                            <button type="submit" class="btn-success text-white px-4 py-2 rounded-lg text-sm">확정</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/business/reservation/update-status" style="display: inline;">
                                            <input type="hidden" name="reservationId" value="${reservation.id}">
                                            <input type="hidden" name="status" value="CANCELLED">
                                            <button type="submit" class="btn-danger text-white px-4 py-2 rounded-lg text-sm">거절</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${reservation.status == 'CONFIRMED'}">
                                        <form method="post" action="${pageContext.request.contextPath}/business/reservation/update-status" style="display: inline;">
                                            <input type="hidden" name="reservationId" value="${reservation.id}">
                                            <input type="hidden" name="status" value="COMPLETED">
                                            <button type="submit" class="btn-warning text-white px-4 py-2 rounded-lg text-sm">완료</button>
                                        </form>
                                    </c:if>
                                    <button class="btn-secondary text-white px-4 py-2 rounded-lg text-sm">상세보기</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">📅</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">예약이 없습니다</h3>
                            <p class="text-slate-500">아직 예약이 없습니다. 음식점을 등록하고 홍보해보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 카드 호버 효과
            document.querySelectorAll('.card-hover').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-4px)';
                    this.style.boxShadow = '0 20px 40px rgba(0, 0, 0, 0.15)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.1)';
                });
            });
        });
    </script>
</body>
</html>
