<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- [추가] fn 태그 라이브러리 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - ${course.title}</title> 
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8 max-w-3xl">
                
                <c:choose>
                    <c:when test="${not empty course}">
                        <div id="course-detail-container" class="bg-white rounded-2xl shadow-lg overflow-hidden">
                            <div>
                                <%-- [수정] 이미지 URL 유형에 따라 동적으로 경로를 설정 --%>
                                <c:choose>
                                    <c:when test="${fn:startsWith(course.previewImage, 'http')}">
                                        <c:set var="previewImageUrl" value="${course.previewImage}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="previewImageUrl" value="${pageContext.request.contextPath}/${course.previewImage}" />
                                    </c:otherwise>
                                </c:choose>
                                <img src="${previewImageUrl}" alt="${course.title}" class="w-full h-72 object-cover">
                            </div>
                            
                            <div class="p-6 md:p-8">
                                <div class="flex flex-wrap gap-2 mb-4">
                                    <c:forEach var="tag" items="${course.tags}">
                                        <span class="text-xs font-semibold bg-sky-100 text-sky-700 px-2 py-1 rounded-full">${tag}</span>
                                    </c:forEach>
                                </div>
                                <h1 class="text-4xl font-bold">${course.title}</h1>
                                
                                <div class="flex items-center mt-4 mb-6 pb-6 border-b">
                                    <c:if test="${not empty course.authorName}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(course.authorImage, 'http')}">
                                                <c:set var="authorImageUrl" value="${course.authorImage}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="authorImageUrl" value="${pageContext.request.contextPath}/${course.authorImage}" />
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="${authorImageUrl}" alt="${course.authorName}" class="w-10 h-10 rounded-full mr-3 object-cover">
                                        <div>
                                            <p class="font-semibold">${course.authorName}</p>
                                            <p class="text-sm text-slate-500">작성자</p>
                                        </div>
                                    </c:if>
                                    
                                    <div class="ml-auto flex items-center gap-4">
                                        <button class="flex items-center gap-1 text-slate-600 font-semibold hover:text-red-500 transition">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
                                            <span>${course.likes}</span>
                                        </button>
                                        <button class="bg-sky-500 text-white font-bold py-2 px-5 rounded-full text-sm hover:bg-sky-600">❤️ 코스 저장</button>
                                    </div>
                                </div>
                                
                                <h3 class="text-2xl font-bold mb-6">코스 상세 경로</h3>
                                <div class="relative border-l-2 border-sky-200 pl-8 space-y-8">
                                    <c:forEach var="step" items="${steps}" varStatus="status">
                                        <div class="relative">
                                            <div class="absolute -left-10 top-2 w-4 h-4 bg-sky-500 rounded-full border-2 border-white"></div>
                                            <div class="flex items-start gap-4">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(step.image, 'http')}">
                                                        <c:set var="stepImageUrl" value="${step.image}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="stepImageUrl" value="${pageContext.request.contextPath}/${step.image}" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <img src="${stepImageUrl}" class="w-24 h-24 rounded-lg object-cover shadow-md">
                                                <div>
                                                    <p class="text-sm text-slate-500">${status.count}. ${step.type}</p>
                                                    <h4 class="text-lg font-bold">${step.emoji} ${step.name}</h4>
                                                    <p class="text-sm text-slate-600 mt-1">${step.description}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="mt-10 pt-6 border-t flex flex-col items-center gap-3">
                                    <button class="w-full max-w-xs bg-yellow-400 text-black font-bold py-3 rounded-full hover:bg-yellow-500">카카오톡으로 공유하기</button>
                                    <button id="copy-url-btn" class="w-full max-w-xs bg-slate-700 text-white font-bold py-3 rounded-full hover:bg-slate-800">URL 복사하기</button>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="p-8 text-center text-lg font-semibold bg-white rounded-lg shadow">해당 코스를 찾을 수 없습니다.</p>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </main>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const copyBtn = document.getElementById('copy-url-btn');
            if (copyBtn) {
                copyBtn.addEventListener('click', (e) => {
                    navigator.clipboard.writeText(window.location.href).then(() => {
                        e.target.textContent = '✅ 복사 완료!';
                        setTimeout(() => {
                            e.target.textContent = 'URL 복사하기';
                        }, 2000);
                    }).catch(err => {
                        alert('URL 복사에 실패했습니다.');
                    });
                });
            }
        });
    </script>
</body>
</html>