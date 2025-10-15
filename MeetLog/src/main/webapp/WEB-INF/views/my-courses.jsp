<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 코스 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
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
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-4xl font-bold gradient-text mb-2">내 코스</h1>
                        <p class="text-slate-600">내가 만든 맛집 코스들을 관리해보세요</p>
                        <div class="flex items-center space-x-4 mt-3 text-sm text-slate-500">
                            <span>📍 총 ${totalCourses}개 코스</span>
                            <span>•</span>
                            <span>📄 ${currentPage} / ${totalPages} 페이지</span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/course/create" 
                       class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                        🗺️ 새 코스 만들기
                    </a>
                </div>
            </div>
            
            <!-- 알림 메시지 -->
            <c:if test="${param.deleted == 'success'}">
                <div class="glass-card p-4 rounded-2xl bg-green-50 border-green-200 text-green-800">
                    ✅ 코스가 성공적으로 삭제되었습니다.
                </div>
            </c:if>
            <c:if test="${param.error == 'delete_failed'}">
                <div class="glass-card p-4 rounded-2xl bg-red-50 border-red-200 text-red-800">
                    ❌ 코스 삭제에 실패했습니다.
                </div>
            </c:if>
            
            <!-- 코스 목록 -->
            <div class="glass-card p-8 rounded-3xl slide-up">
                <c:choose>
                    <c:when test="${not empty courses}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="course" items="${courses}">
                                <div class="card-hover rounded-2xl overflow-hidden bg-white shadow-lg">
                                    <!-- 코스 이미지 (클릭 가능) -->
                                    <a href="${pageContext.request.contextPath}/course/detail?id=${course.courseId}" class="block relative h-48 overflow-hidden">
                                        <c:choose>
                                            <c:when test="${not empty course.previewImage}">
                                                <mytag:image fileName="${course.previewImage}" altText="${course.title}" cssClass="w-full h-full object-cover" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-full bg-gradient-to-br from-green-200 to-green-400 flex items-center justify-center">
                                                    <span class="text-4xl">MEET LOG</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </a>

                                    <!-- 코스 정보 -->
                                    <div class="p-6">
                                        <a href="${pageContext.request.contextPath}/course/detail?id=${course.courseId}" class="block">
                                            <h3 class="text-lg font-bold text-slate-800 mb-2 line-clamp-2 hover:text-blue-600 transition-colors">${course.title}</h3>
                                        </a>
                                        
                                        <c:if test="${not empty course.description}">
                                            <p class="text-slate-600 text-sm mb-3 line-clamp-2">
                                                <c:choose>
                                                    <c:when test="${fn:length(course.description) > 80}">
                                                        ${fn:substring(course.description, 0, 80)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${course.description}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </c:if>
                                        
                                        <!-- 코스 통계 -->
                                        <div class="flex justify-between items-center text-sm text-slate-500 mb-4">
                                            <div class="flex items-center space-x-3">
                                                <span>${course.restaurantCount}곳</span>
                                                <span>${course.likeCount}명</span>
                                            </div>
                                            <span>
                                                ${course.createdAt.format(DateTimeFormatter.ofPattern('MM/dd'))}
                                            </span>
                                        </div>
                                        
                                        <!-- 액션 버튼 -->
                                        <div class="flex space-x-2">
                                            <a href="${pageContext.request.contextPath}/course/edit?id=${course.courseId}"
                                               class="flex-1 bg-blue-100 hover:bg-blue-200 text-blue-700 text-center py-2 px-4 rounded-lg font-semibold transition-colors">
                                                수정
                                            </a>
                                            <button data-course-id="${course.courseId}"
                                                    class="delete-course-btn flex-1 bg-red-100 hover:bg-red-200 text-red-700 py-2 px-4 rounded-lg font-semibold transition-colors">
                                                삭제
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <!-- 페이징 -->
                        <c:if test="${totalPages > 1}">
                            <div class="flex justify-center mt-8">
                                <div class="flex space-x-2">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}" 
                                           class="px-4 py-2 bg-white hover:bg-slate-100 text-slate-700 rounded-lg font-semibold transition-colors">
                                            이전
                                        </a>
                                    </c:if>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <c:choose>
                                            <c:when test="${pageNum == currentPage}">
                                                <span class="px-4 py-2 btn-primary text-white rounded-lg font-semibold">
                                                    ${pageNum}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${pageNum}" 
                                                   class="px-4 py-2 bg-white hover:bg-slate-100 text-slate-700 rounded-lg font-semibold transition-colors">
                                                    ${pageNum}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}" 
                                           class="px-4 py-2 bg-white hover:bg-slate-100 text-slate-700 rounded-lg font-semibold transition-colors">
                                            다음
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <h3 class="text-xl font-bold text-slate-800 mb-2">아직 만든 코스가 없습니다</h3>
                            <p class="text-slate-600 mb-6">나만의 특별한 맛집 코스를 만들어보세요!</p>
                            <div class="flex justify-center space-x-4">
                                <a href="${pageContext.request.contextPath}/course/create" 
                                   class="btn-primary text-white px-6 py-3 rounded-xl font-semibold">
                                    첫 번째 코스 만들기
                                </a>
                                <a href="${pageContext.request.contextPath}/course/list" 
                                   class="bg-green-100 hover:bg-green-200 text-green-700 px-6 py-3 rounded-xl font-semibold transition-colors">
                                    다른 코스 둘러보기
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty bookmarkedCourses}">
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <div class="flex items-center justify-between mb-6">
                        <div>
                            <h2 class="text-2xl font-bold text-slate-800">저장한 코스</h2>
                            <p class="text-slate-500 text-sm">찜한 코스를 빠르게 다시 살펴보세요.</p>
                        </div>
                        <span class="inline-flex items-center px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-sm font-semibold">
                            총 ${fn:length(bookmarkedCourses)}개
                        </span>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="course" items="${bookmarkedCourses}">
                            <div class="card-hover rounded-2xl overflow-hidden bg-white shadow-lg">
                                <a href="${pageContext.request.contextPath}/course/detail?id=${course.courseId}" class="block relative h-40 overflow-hidden">
                                    <c:choose>
                                        <c:when test="${not empty course.previewImage}">
                                            <mytag:image fileName="${course.previewImage}" altText="${course.title}" cssClass="w-full h-full object-cover" />
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full bg-gradient-to-br from-blue-200 to-blue-400 flex items-center justify-center text-white text-lg font-bold">
                                                ${course.title}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="p-5 space-y-3">
                                    <h3 class="text-lg font-bold text-slate-800 line-clamp-2">${course.title}</h3>
                                    <p class="text-slate-600 text-sm line-clamp-3">
                                        <c:choose>
                                            <c:when test="${not empty course.description}">${course.description}</c:when>
                                            <c:otherwise>설명이 없는 코스입니다.</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="flex items-center justify-between text-sm text-slate-500">
                                        <span class="flex items-center gap-1">
                                            <span>❤️</span>
                                            <fmt:formatNumber value="${course.likes}"/>
                                        </span>
                                        <a href="${pageContext.request.contextPath}/course/detail?id=${course.courseId}" class="text-blue-600 hover:text-blue-700 font-semibold">자세히 보기</a>
                                    </div>
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
        // function togglePublic(courseId, button) {
        //     fetch('${pageContext.request.contextPath}/my-courses', {
        //         method: 'POST',
        //         headers: {
        //             'Content-Type': 'application/x-www-form-urlencoded',
        //         },
        //         body: new URLSearchParams({
        //             action: 'togglePublic',
        //             courseId: courseId
        //         })
        //     })
        //     .then(response => response.json())
        //     .then(data => {
        //         if (data.success) {
        //             // 버튼 아이콘과 배지 업데이트
        //             button.textContent = data.isPublic ? '🔓' : '🔒';
                    
        //             const card = button.closest('.card-hover');
        //             const badge = card.querySelector('.absolute.top-3.left-3 span');
                    
        //             if (data.isPublic) {
        //                 badge.textContent = '공개';
        //                 badge.className = 'px-3 py-1 rounded-full text-xs font-semibold text-white bg-green-500';
        //             } else {
        //                 badge.textContent = '비공개';
        //                 badge.className = 'px-3 py-1 rounded-full text-xs font-semibold text-white bg-gray-500';
        //             }
        //         } else {
        //             alert(data.message || '상태 변경에 실패했습니다.');
        //         }
        //     })
        //     .catch(error => {
        //         console.error('Error:', error);
        //         alert('오류가 발생했습니다.');
        //     });
        // }
        
        function deleteCourse(courseId) {
            if (confirm('정말로 이 코스를 삭제하시겠습니까?\n삭제된 코스는 복구할 수 없습니다.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/my-courses';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const courseIdInput = document.createElement('input');
                courseIdInput.type = 'hidden';
                courseIdInput.name = 'courseId';
                courseIdInput.value = courseId;
                
                form.appendChild(actionInput);
                form.appendChild(courseIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 페이지 로드 시 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
            // 공개/비공개 토글 버튼 이벤트 리스너
            // document.querySelectorAll('.toggle-public-btn').forEach(button => {
            //     button.addEventListener('click', function() {
            //         const courseId = this.getAttribute('data-course-id');
            //         togglePublic(courseId, this);
            //     });
            // });
            
            // 코스 삭제 버튼 이벤트 리스너
            document.querySelectorAll('.delete-course-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const courseId = this.getAttribute('data-course-id');
                    deleteCourse(courseId);
                });
            });
        });
    </script>
</body>
</html>
