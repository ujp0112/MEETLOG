<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 리뷰 목록</title>
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
                    <h2 class="text-2xl md:text-3xl font-bold mb-4">리뷰 목록</h2>
                    <p class="text-slate-600">맛집에 대한 리뷰를 확인하세요.</p>
                </div>

                <div class="space-y-4">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="review" items="${reviews}">
                                <div class="bg-white p-6 rounded-xl shadow-lg">
                                    <div class="flex items-start justify-between mb-4">
                                        <div class="flex-grow">
                                            <div class="flex items-center mb-2">
                                                <img src="${not empty review.authorImage ? review.authorImage : 'https://placehold.co/40x40/94a3b8/ffffff?text=U'}" 
                                                     class="w-10 h-10 rounded-full mr-3" alt="작성자">
                                                <div>
                                                    <h3 class="font-bold text-slate-800">${review.author}</h3>
                                                    <div class="text-yellow-500 text-sm">
                                                        <%-- Replaced scriptlet loop with JSTL for star rating --%>
                                                        <c:forEach begin="1" end="${review.rating}">★</c:forEach>
                                                        <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                                        <span class="text-slate-600 ml-1">(${review.rating}점)</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <p class="text-slate-700 mb-2">${review.content}</p>
                                            <p class="text-slate-500 text-sm">맛집 ID: ${review.restaurantId}</p>
                                        </div>
                                        <div class="text-right">
                                            <p class="text-sm text-slate-500 mb-2">
                                                <fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd" />
                                            </p>
                                            <div class="flex items-center text-sky-600">
                                                <button onclick="likeReview(${review.id})" 
                                                        class="flex items-center space-x-1 hover:text-sky-700">
                                                    <span>❤️</span>
                                                    <span class="text-sm">${review.likes}</span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex items-center justify-between pt-4 border-t border-slate-200">
                                        <a href="${pageContext.request.contextPath}/restaurant/detail/${review.restaurantId}" 
                                           class="text-sky-600 hover:text-sky-700 text-sm font-medium">맛집 보기</a>
                                        <a href="${pageContext.request.contextPath}/review/detail/${review.id}" 
                                           class="text-slate-600 hover:text-slate-700 text-sm font-medium">자세히 보기</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12">
                                <div class="text-6xl mb-4">📝</div>
                                <h3 class="text-xl font-bold text-slate-800 mb-2">리뷰가 없습니다</h3>
                                <p class="text-slate-600 mb-6">아직 작성된 리뷰가 없습니다.</p>
                                <a href="${pageContext.request.contextPath}/main" 
                                   class="inline-block bg-sky-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-sky-700">
                                    맛집 둘러보기
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

    <script>
        // This client-side script remains the same as it contains no JSP code.
        function likeReview(reviewId) {
            fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=like&reviewId=' + reviewId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('좋아요 처리 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('좋아요 처리 중 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>