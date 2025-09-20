<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 관리 테스트 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="glass-card p-8 rounded-3xl">
            <h1 class="text-3xl font-bold gradient-text mb-8">리뷰 관리 테스트</h1>
            
            <div class="space-y-6">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <p class="text-green-600 font-semibold">리뷰 데이터가 정상적으로 로드되었습니다!</p>
                        <p class="text-slate-600">리뷰 개수: ${reviews.size()}</p>
                        
                        <c:forEach var="review" items="${reviews}" varStatus="status">
                            <div class="glass-card p-6 rounded-2xl">
                                <h3 class="font-bold text-slate-800">리뷰 ${status.index + 1}</h3>
                                <p class="text-slate-600">작성자: ${review.author}</p>
                                <p class="text-slate-600">평점: ${review.rating}</p>
                                <p class="text-slate-600">내용: ${review.content}</p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-8xl mb-6">⭐</div>
                            <h3 class="text-2xl font-bold text-slate-600 mb-4">리뷰가 없습니다</h3>
                            <p class="text-slate-500">아직 리뷰가 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
