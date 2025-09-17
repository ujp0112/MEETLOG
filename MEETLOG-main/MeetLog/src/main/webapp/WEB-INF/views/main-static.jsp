<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 홈</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 페이지 로드 시 부드러운 애니메이션 효과 */
        .page-content { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100">

    <div id="app" class="min-h-screen flex flex-col">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8">
                
                <section class="mb-12">
                    <h2 class="text-2xl md:text-3xl font-bold mb-6">🏆 실시간 맛집 랭킹 TOP 10</h2>
                    <div class="flex space-x-4 overflow-x-auto pb-4 -mx-4 px-4 horizontal-scroll">
                        <c:forEach var="r" items="${topRankedRestaurants}" varStatus="status">
                            <a href="${pageContext.request.contextPath}/restaurant/detail/${r.id}" 
                               class="flex-shrink-0 w-60 md:w-64 bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 transition duration-300 group">
                                <div class="relative">
                                    <img src="${not empty r.image ? r.image : 'https://placehold.co/600x400/94a3b8/ffffff?text=No+Image'}" 
                                         alt="${r.name}" class="w-full h-32 object-cover">
                                    <div class="absolute top-2 left-2 bg-black bg-opacity-60 text-white text-lg font-bold w-8 h-8 flex items-center justify-center rounded-full">
                                        ${status.count}
                                    </div>
                                    <div class="absolute bottom-0 left-0 right-0 p-2 bg-gradient-to-t from-black/70 to-transparent">
                                        <h3 class="text-white text-lg font-bold truncate">${r.name}</h3>
                                        <p class="text-white text-sm">${r.location}</p>
                                    </div>
                                </div>
                                <div class="p-3">
                                    <p class="text-sm text-slate-600 truncate">❤️ <fmt:formatNumber value="${r.likes}" pattern="#,##0"/></p>
                                    <div class="text-sm font-bold text-sky-600 mt-2">${r.rating}점</div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </section>

                <section class="mb-12">
                    <h2 class="text-2xl md:text-3xl font-bold mb-6">🔍 나에게 꼭 맞는 맛집 찾기</h2>
                    <div class="bg-white p-8 rounded-2xl shadow-lg">
                        <form "${pageContext.request.contextPath}.do/restaurant/search" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 items-end">
                            <div>
                                <label class="block text-sm font-semibold mb-2">만나는 장소</label>
                                <input type="text" name="location" placeholder="예: 강남역" class="w-full p-3 border rounded-lg">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold mb-2">만나는 유형</label>
                                <select name="type" class="w-full p-3 border rounded-lg">
                                    <option value="">전체</option>
                                    <option value="데이트">데이트</option>
                                    <option value="회식">회식</option>
                                    <option value="가족모임">가족모임</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold mb-2">음식 종류</label>
                                <select name="category" class="w-full p-3 border rounded-lg">
                                    <option value="">전체</option>
                                    <option value="한식">한식</option>
                                    <option value="일식">일식</option>
                                    <option value="양식">양식</option>
                                    <option value="중식">중식</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold mb-2">가격대 (1인)</label>
                                <select name="price" class="w-full p-3 border rounded-lg">
                                    <option value="">전체</option>
                                    <option value="10000">1만원 이하</option>
                                    <option value="20000">1-2만원</option>
                                    <option value="30000">2-3만원</option>
                                    <option value="30001">3만원 이상</option>
                                </select>
                            </div>
                             <div class="lg:col-span-1">
                                <button type="submit" class="w-full bg-sky-500 text-white py-3 px-4 rounded-lg font-bold text-lg hover:bg-sky-600 transition-colors">
                                    맛집 찾기
                                </button>
                            </div>
                        </form>
                    </div>
                </section>

                <section class="mb-12">
                    <h2 class="text-2xl md:text-3xl font-bold mb-6">🔥 지금 뜨는 후기</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <c:forEach var="review" items="${hotReviews}">
                            <div class="bg-white p-6 rounded-2xl shadow-lg">
                                <div class="flex items-center mb-4">
                                    <div class="w-10 h-10 bg-sky-100 rounded-full flex items-center justify-center mr-3">
                                        <span class="text-sky-600 font-bold">${review.author.substring(0, 1)}</span>
                                    </div>
                                    <div>
                                        <h4 class="font-semibold">${review.author}</h4>
                                        <div class="flex text-yellow-400 text-sm">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span class="${i <= review.rating ? 'text-yellow-400' : 'text-gray-300'}">★</span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <p class="text-slate-700 mb-4 h-12 truncate">${review.content}</p>
                                <a href="${pageContext.request.contextPath}/review/${review.id}" class="bg-sky-500 text-white px-4 py-2 rounded-lg text-sm">리뷰 보기</a>
                            </div>
                        </c:forEach>
                    </div>
                </section>

                <section class="mb-12">
                    <h2 class="text-2xl md:text-3xl font-bold mb-6">📝 최신 칼럼</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="column" items="${latestColumns}">
                            <a href="${pageContext.request.contextPath}/column/${column.id}" class="bg-white p-6 rounded-2xl shadow-lg block hover:shadow-xl transition">
                                <div class="flex items-center mb-4">
                                    <img src="${not empty column.authorImage ? column.authorImage : 'https://placehold.co/50x50/45b7d1/ffffff?text=ME'}" alt="${column.author}" class="w-10 h-10 rounded-full mr-3">
                                    <div>
                                        <h4 class="font-semibold">${column.author}</h4>
                                        <p class="text-sm text-slate-500"><fmt:formatDate value="${column.createdAt}" pattern="yyyy.MM.dd"/></p>
                                    </div>
                                </div>
                                <h3 class="font-bold text-lg mb-2 h-12 truncate">${column.title}</h3>
                                <p class="text-slate-600 text-sm h-10 truncate">${column.content}</p>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <jsp:include page="/WEB-INF/views/common/loading.jsp" />
</body>
</html>