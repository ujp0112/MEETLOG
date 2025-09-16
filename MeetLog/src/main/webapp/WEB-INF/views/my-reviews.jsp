<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 내 리뷰</title>
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
                <div class="mb-6">
                    <h2 class="text-2xl md:text-3xl font-bold mb-4">내 리뷰</h2>
                    <p class="text-slate-600">작성한 리뷰를 관리하세요.</p>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <div class="space-y-4">
                                    <c:forEach var="review" items="${reviews}">
                                        <div class="bg-white p-6 rounded-xl shadow-lg">
                                            <div class="flex items-start justify-between mb-4">
                                                <div class="flex-grow">
                                                    <div class="flex items-center mb-2">
                                                        <h3 class="text-lg font-bold text-slate-800 mr-3">리뷰 #${review.id}</h3>
                                                        <%-- Replaced scriptlet loop with JSTL for star rating --%>
                                                        <div class="text-yellow-500">
                                                            <c:forEach begin="1" end="${review.rating}">★</c:forEach>
                                                            <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                                        </div>
                                                    </div>
                                                    <p class="text-slate-600 text-sm mb-2">맛집 ID: ${review.restaurantId}</p>
                                                    <p class="text-slate-700">${review.content}</p>
                                                </div>
                                                <div class="flex items-center space-x-2">
                                                    <span class="text-sm text-slate-500">
                                                        <fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd HH:mm" />
                                                    </span>
                                                    <div class="flex items-center text-sky-600">
                                                        <span class="text-sm">❤️ ${review.likes}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="flex items-center justify-between pt-4 border-t border-slate-200">
                                                <div class="flex items-center space-x-2">
                                                    <a href="${pageContext.request.contextPath}/restaurant/detail/${review.restaurantId}" 
                                                       class="text-sky-600 hover:text-sky-700 text-sm font-medium">맛집 보기</a>
                                                    <span class="text-slate-300">|</span>
                                                    <button onclick="editReview(${review.id})" 
                                                            class="text-slate-600 hover:text-slate-700 text-sm font-medium">수정</button>
                                                    <span class="text-slate-300">|</span>
                                                    <button onclick="deleteReview(${review.id})" 
                                                            class="text-red-600 hover:text-red-700 text-sm font-medium">삭제</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <div class="text-6xl mb-4">📝</div>
                                    <h3 class="text-xl font-bold text-slate-800 mb-2">작성한 리뷰가 없습니다</h3>
                                    <p class="text-slate-600 mb-6">맛집을 방문하고 첫 리뷰를 작성해보세요!</p>
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
                            <p class="text-slate-600 mb-6">리뷰를 관리하려면 로그인해주세요.</p>
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

    <script>
        function editReview(reviewId) {
            // This JavaScript logic remains the same as it contains no JSP scriptlets.
            alert('리뷰 수정 기능은 준비 중입니다.');
        }

        function deleteReview(reviewId) {
            if (confirm('정말로 이 리뷰를 삭제하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/review', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&reviewId=' + reviewId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('리뷰 삭제 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('리뷰 삭제 중 오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>