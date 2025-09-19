<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비즈니스 대시보드 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .stat-card { background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(248, 250, 252, 0.9) 100%); }
        .pulse-glow { animation: pulseGlow 2s ease-in-out infinite; }
        @keyframes pulseGlow { 0%, 100% { box-shadow: 0 0 20px rgba(59, 130, 246, 0.3); } 50% { box-shadow: 0 0 30px rgba(59, 130, 246, 0.5); } }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl fade-in">
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-4xl font-bold gradient-text mb-2">비즈니스 대시보드</h1>
                        <p class="text-slate-600">음식점 관리와 운영 현황을 한눈에 확인하세요</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-slate-500">환영합니다!</p>
                        <p class="text-lg font-semibold text-slate-800">사업자님</p>
                    </div>
                </div>
            </div>
            
            <!-- 통계 카드 섹션 -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="glass-card p-6 rounded-2xl card-hover stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">총 음식점</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty dashboardData.totalRestaurants ? dashboardData.totalRestaurants : 0}</p>
                        </div>
                        <div class="text-4xl text-blue-500">🍽️</div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl card-hover stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">총 리뷰</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty dashboardData.totalReviews ? dashboardData.totalReviews : 0}</p>
                        </div>
                        <div class="text-4xl text-green-500">⭐</div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl card-hover stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">평균 평점</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty dashboardData.averageRating ? dashboardData.averageRating : 0}</p>
                        </div>
                        <div class="text-4xl text-yellow-500">📊</div>
                    </div>
                </div>
                
                <div class="glass-card p-6 rounded-2xl card-hover stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">총 예약</p>
                            <p class="text-3xl font-bold text-slate-800">${not empty dashboardData.totalReservations ? dashboardData.totalReservations : 0}</p>
                        </div>
                        <div class="text-4xl text-purple-500">📅</div>
                    </div>
                </div>
            </div>
            
            <!-- 빠른 액션 섹션 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6">빠른 액션</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <a href="${pageContext.request.contextPath}/restaurant/add" class="btn-primary text-white p-6 rounded-2xl text-center card-hover">
                        <div class="text-3xl mb-2">➕</div>
                        <div class="font-semibold">음식점 등록</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/my" class="btn-secondary text-white p-6 rounded-2xl text-center card-hover">
                        <div class="text-3xl mb-2">🍽️</div>
                        <div class="font-semibold">내 음식점 관리</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/business/menu-management" class="btn-primary text-white p-6 rounded-2xl text-center card-hover">
                        <div class="text-3xl mb-2">📋</div>
                        <div class="font-semibold">메뉴 관리</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/business/reservation-management" class="btn-secondary text-white p-6 rounded-2xl text-center card-hover">
                        <div class="text-3xl mb-2">📅</div>
                        <div class="font-semibold">예약 관리</div>
                    </a>
                </div>
            </div>
            
            <!-- 통계 차트 섹션 -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- 리뷰 평점 분포 차트 -->
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <h2 class="text-2xl font-bold gradient-text mb-6">리뷰 평점 분포</h2>
                    <div class="h-80">
                        <canvas id="ratingChart"></canvas>
                    </div>
                </div>
                
                <!-- 월별 리뷰 추이 차트 -->
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <h2 class="text-2xl font-bold gradient-text mb-6">월별 리뷰 추이</h2>
                    <div class="h-80">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- 최근 리뷰 섹션 -->
            <c:if test="${not empty recentReviews}">
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <h2 class="text-2xl font-bold gradient-text mb-6">최근 리뷰</h2>
                    <div class="space-y-4">
                        <c:forEach var="review" items="${recentReviews}" end="4">
                            <div class="flex items-start space-x-4 p-4 bg-slate-50 rounded-2xl card-hover">
                                <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                    ${review.author.charAt(0)}
                                </div>
                                <div class="flex-1">
                                    <div class="flex items-center space-x-2 mb-2">
                                        <span class="font-bold text-slate-800">${review.author}</span>
                                        <div class="flex space-x-1">
                                            <c:forEach begin="1" end="${review.rating}">
                                                <span class="text-yellow-400 text-lg">★</span>
                                            </c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5">
                                                <span class="text-slate-300 text-lg">☆</span>
                                            </c:forEach>
                                        </div>
                                        <span class="text-slate-500 text-sm">${review.createdAt}</span>
                                    </div>
                                    <p class="text-slate-700">${review.content}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            
            <!-- 내 음식점 목록 섹션 -->
            <c:if test="${not empty myRestaurants}">
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold gradient-text">내 음식점</h2>
                        <a href="${pageContext.request.contextPath}/restaurant/my" class="text-blue-600 hover:text-blue-700 font-semibold">전체 보기 →</a>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        <c:forEach var="restaurant" items="${myRestaurants}" end="5">
                            <div class="p-4 bg-slate-50 rounded-2xl card-hover">
                                <h3 class="font-bold text-slate-800 mb-2">${restaurant.name}</h3>
                                <p class="text-slate-600 text-sm mb-2">${restaurant.category} • ${restaurant.location}</p>
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-1">
                                        <span class="text-yellow-400">★</span>
                                        <span class="text-slate-700 font-semibold">${restaurant.rating}</span>
                                        <span class="text-slate-500 text-sm">(${restaurant.reviewCount})</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${restaurant.id}" class="text-blue-600 hover:text-blue-700 text-sm font-semibold">상세보기</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
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
            
            // 리뷰 평점 분포 차트
            const ratingCtx = document.getElementById('ratingChart').getContext('2d');
            new Chart(ratingCtx, {
                type: 'doughnut',
                data: {
                    labels: ['5점', '4점', '3점', '2점', '1점'],
                    datasets: [{
                        data: [${not empty fiveStarReviews ? fiveStarReviews : 0}, 
                               ${not empty fourStarReviews ? fourStarReviews : 0}, 
                               ${not empty threeStarReviews ? threeStarReviews : 0}, 
                               ${not empty twoStarReviews ? twoStarReviews : 0}, 
                               ${not empty oneStarReviews ? oneStarReviews : 0}],
                        backgroundColor: [
                            '#10b981', // 5점 - 초록
                            '#3b82f6', // 4점 - 파랑
                            '#f59e0b', // 3점 - 노랑
                            '#f97316', // 2점 - 주황
                            '#ef4444'  // 1점 - 빨강
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });
            
            // 월별 리뷰 추이 차트
            const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
            new Chart(monthlyCtx, {
                type: 'line',
                data: {
                    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                    datasets: [{
                        label: '리뷰 수',
                        data: [12, 19, 3, 5, 2, 3, 8, 15, 22, 18, 25, 30], // 실제 데이터로 교체 필요
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#3b82f6',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.1)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>