<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고급 검색 - MEET LOG</title>
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
        .card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .card-hover:hover { transform: translateY(-2px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl fade-in">
                <h1 class="text-4xl font-bold gradient-text mb-2">고급 검색</h1>
                <p class="text-slate-600">세밀한 조건으로 데이터를 검색하세요</p>
            </div>
            
            <!-- 검색 타입 선택 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6">검색 타입 선택</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <button onclick="setSearchType('restaurants')" 
                            class="p-6 rounded-2xl card-hover ${searchType == 'restaurants' ? 'bg-blue-50 border-2 border-blue-500' : 'bg-slate-50'}"
                            id="btn-restaurants">
                        <div class="text-center">
                            <div class="text-4xl mb-2">🏪</div>
                            <h3 class="text-lg font-bold text-slate-800">음식점</h3>
                            <p class="text-slate-600 text-sm">음식점 정보 검색</p>
                        </div>
                    </button>
                    
                    <button onclick="setSearchType('reviews')" 
                            class="p-6 rounded-2xl card-hover ${searchType == 'reviews' ? 'bg-blue-50 border-2 border-blue-500' : 'bg-slate-50'}"
                            id="btn-reviews">
                        <div class="text-center">
                            <div class="text-4xl mb-2">⭐</div>
                            <h3 class="text-lg font-bold text-slate-800">리뷰</h3>
                            <p class="text-slate-600 text-sm">리뷰 검색</p>
                        </div>
                    </button>
                    
                    <button onclick="setSearchType('reservations')" 
                            class="p-6 rounded-2xl card-hover ${searchType == 'reservations' ? 'bg-blue-50 border-2 border-blue-500' : 'bg-slate-50'}"
                            id="btn-reservations">
                        <div class="text-center">
                            <div class="text-4xl mb-2">📅</div>
                            <h3 class="text-lg font-bold text-slate-800">예약</h3>
                            <p class="text-slate-600 text-sm">예약 정보 검색</p>
                        </div>
                    </button>
                </div>
            </div>
            
            <!-- 검색 폼 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6">검색 조건</h2>
                <form method="post" action="${pageContext.request.contextPath}/search" class="space-y-6">
                    <input type="hidden" name="type" id="searchType" value="${searchType}">
                    
                    <!-- 기본 검색 조건 -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="keyword" class="block text-sm font-medium text-slate-700 mb-2">키워드</label>
                            <input type="text" id="keyword" name="keyword" 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   placeholder="검색할 키워드를 입력하세요"
                                   value="${searchParams.keyword}">
                        </div>
                        
                        <div>
                            <label for="startDate" class="block text-sm font-medium text-slate-700 mb-2">시작 날짜</label>
                            <input type="date" id="startDate" name="startDate" 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   value="${searchParams.startDate}">
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="endDate" class="block text-sm font-medium text-slate-700 mb-2">종료 날짜</label>
                            <input type="date" id="endDate" name="endDate" 
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   value="${searchParams.endDate}">
                        </div>
                        
                        <!-- 음식점 검색 조건 -->
                        <div id="restaurant-conditions" class="hidden">
                            <label for="category" class="block text-sm font-medium text-slate-700 mb-2">카테고리</label>
                            <select id="category" name="category" 
                                    class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="한식" ${searchParams.category == '한식' ? 'selected' : ''}>한식</option>
                                <option value="중식" ${searchParams.category == '중식' ? 'selected' : ''}>중식</option>
                                <option value="일식" ${searchParams.category == '일식' ? 'selected' : ''}>일식</option>
                                <option value="양식" ${searchParams.category == '양식' ? 'selected' : ''}>양식</option>
                                <option value="카페" ${searchParams.category == '카페' ? 'selected' : ''}>카페</option>
                                <option value="디저트" ${searchParams.category == '디저트' ? 'selected' : ''}>디저트</option>
                            </select>
                        </div>
                        
                        <!-- 리뷰 검색 조건 -->
                        <div id="review-conditions" class="hidden">
                            <label for="minRating" class="block text-sm font-medium text-slate-700 mb-2">최소 평점</label>
                            <select id="minRating" name="minRating" 
                                    class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="5" ${searchParams.minRating == '5' ? 'selected' : ''}>5점</option>
                                <option value="4" ${searchParams.minRating == '4' ? 'selected' : ''}>4점 이상</option>
                                <option value="3" ${searchParams.minRating == '3' ? 'selected' : ''}>3점 이상</option>
                                <option value="2" ${searchParams.minRating == '2' ? 'selected' : ''}>2점 이상</option>
                                <option value="1" ${searchParams.minRating == '1' ? 'selected' : ''}>1점 이상</option>
                            </select>
                        </div>
                        
                        <!-- 예약 검색 조건 -->
                        <div id="reservation-conditions" class="hidden">
                            <label for="status" class="block text-sm font-medium text-slate-700 mb-2">예약 상태</label>
                            <select id="status" name="status" 
                                    class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">전체</option>
                                <option value="PENDING" ${searchParams.status == 'PENDING' ? 'selected' : ''}>대기중</option>
                                <option value="CONFIRMED" ${searchParams.status == 'CONFIRMED' ? 'selected' : ''}>확정</option>
                                <option value="CANCELLED" ${searchParams.status == 'CANCELLED' ? 'selected' : ''}>취소됨</option>
                                <option value="COMPLETED" ${searchParams.status == 'COMPLETED' ? 'selected' : ''}>완료</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="flex justify-center space-x-4">
                        <button type="submit" class="btn-primary text-white px-8 py-3 rounded-xl font-semibold">
                            🔍 검색
                        </button>
                        <button type="button" onclick="resetForm()" class="btn-secondary text-white px-8 py-3 rounded-xl font-semibold">
                            🔄 초기화
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- 검색 결과 -->
            <c:if test="${not empty searchResults}">
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold gradient-text">검색 결과</h2>
                        <span class="text-slate-600">총 ${searchResults.size()}건</span>
                    </div>
                    
                    <c:choose>
                        <c:when test="${searchType == 'restaurants'}">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <c:forEach var="restaurant" items="${searchResults}">
                                    <div class="p-6 bg-slate-50 rounded-2xl card-hover">
                                        <h3 class="text-xl font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                        <p class="text-slate-600 mb-4">${restaurant.category} • ${restaurant.location}</p>
                                        <div class="flex items-center space-x-2 mb-4">
                                            <div class="flex space-x-1">
                                                <c:forEach begin="1" end="${restaurant.rating}">
                                                    <span class="text-yellow-400">★</span>
                                                </c:forEach>
                                                <c:forEach begin="${restaurant.rating + 1}" end="5">
                                                    <span class="text-slate-300">☆</span>
                                                </c:forEach>
                                            </div>
                                            <span class="text-slate-700 font-semibold">${restaurant.rating}</span>
                                            <span class="text-slate-500">(${restaurant.reviewCount}개 리뷰)</span>
                                        </div>
                                        <div class="flex space-x-2">
                                            <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}" 
                                               class="btn-primary text-white px-4 py-2 rounded-lg text-sm">
                                                상세보기
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        
                        <c:when test="${searchType == 'reviews'}">
                            <div class="space-y-4">
                                <c:forEach var="review" items="${searchResults}">
                                    <div class="p-6 bg-slate-50 rounded-2xl card-hover">
                                        <div class="flex justify-between items-start mb-4">
                                            <div class="flex items-center space-x-4">
                                                <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                                    ${review.author.charAt(0)}
                                                </div>
                                                <div>
                                                    <h3 class="font-bold text-slate-800">${review.author}</h3>
                                                    <p class="text-slate-600 text-sm">${review.restaurantName}</p>
                                                </div>
                                            </div>
                                            <div class="text-right">
                                                <div class="flex items-center space-x-2 mb-2">
                                                    <div class="flex space-x-1">
                                                        <c:forEach begin="1" end="${review.rating}">
                                                            <span class="text-yellow-400 text-lg">★</span>
                                                        </c:forEach>
                                                        <c:forEach begin="${review.rating + 1}" end="5">
                                                            <span class="text-slate-300 text-lg">☆</span>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="text-slate-700 font-semibold">${review.rating}</span>
                                                </div>
                                                <p class="text-slate-500 text-sm">${review.createdAt}</p>
                                            </div>
                                        </div>
                                        <p class="text-slate-700">${review.content}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        
                        <c:when test="${searchType == 'reservations'}">
                            <div class="space-y-4">
                                <c:forEach var="reservation" items="${searchResults}">
                                    <div class="p-6 bg-slate-50 rounded-2xl card-hover">
                                        <div class="flex justify-between items-start mb-4">
                                            <div class="flex-1">
                                                <h3 class="text-xl font-bold text-slate-800">${reservation.customerName}</h3>
                                                <p class="text-slate-600">${reservation.restaurantName}</p>
                                            </div>
                                            <div class="text-right">
                                                <span class="status-${reservation.status} text-white px-4 py-2 rounded-full text-sm font-semibold">
                                                    ${reservation.status == 'PENDING' ? '대기중' : 
                                                      reservation.status == 'CONFIRMED' ? '확정' : 
                                                      reservation.status == 'CANCELLED' ? '취소됨' : '완료'}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                            <div class="p-4 bg-white rounded-xl">
                                                <p class="text-sm text-slate-600">예약 날짜</p>
                                                <p class="font-semibold text-slate-800">${reservation.reservationDate}</p>
                                            </div>
                                            <div class="p-4 bg-white rounded-xl">
                                                <p class="text-sm text-slate-600">예약 시간</p>
                                                <p class="font-semibold text-slate-800">${reservation.reservationTime}</p>
                                            </div>
                                            <div class="p-4 bg-white rounded-xl">
                                                <p class="text-sm text-slate-600">인원</p>
                                                <p class="font-semibold text-slate-800">${reservation.partySize}명</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function setSearchType(type) {
            document.getElementById('searchType').value = type;
            
            // 버튼 스타일 업데이트
            document.querySelectorAll('[id^="btn-"]').forEach(btn => {
                btn.classList.remove('bg-blue-50', 'border-2', 'border-blue-500');
                btn.classList.add('bg-slate-50');
            });
            
            document.getElementById('btn-' + type).classList.remove('bg-slate-50');
            document.getElementById('btn-' + type).classList.add('bg-blue-50', 'border-2', 'border-blue-500');
            
            // 조건 섹션 표시/숨김
            document.querySelectorAll('[id$="-conditions"]').forEach(div => {
                div.classList.add('hidden');
            });
            
            document.getElementById(type + '-conditions').classList.remove('hidden');
        }
        
        function resetForm() {
            document.querySelector('form').reset();
            setSearchType('restaurants');
        }
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            const searchType = '${searchType}';
            if (searchType) {
                setSearchType(searchType);
            } else {
                setSearchType('restaurants');
            }
            
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
