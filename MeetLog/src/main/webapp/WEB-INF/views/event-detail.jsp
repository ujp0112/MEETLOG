<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.title} - MEET LOG</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
</head>
<body class="bg-slate-50">
    <div class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
    
                 <div class="max-w-4xl mx-auto">
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
<<<<<<< HEAD
                        
                        <img src="${event.image}" alt="${event.title}" class="w-full h-64 md:h-96 object-cover">
=======
>>>>>>> origin/my-feature
                        
                        <mytag:image fileName="${event.image}" altText="${event.title}" cssClass="w-full h-64 md:h-96 object-cover" />
        
                         
                        <div class="p-8">
                            <h1 class="text-3xl font-bold text-slate-800 mb-4">${event.title}</h1>
                           
                             <div class="flex justify-between items-center mb-6 text-slate-600 border-b pb-4">
                                <span><strong>시작일:</strong> <fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd"/></span>
                                <span><strong>종료일:</strong> <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/></span>
                      
                           </div>
                            
                            <div class="prose max-w-none" style="white-space: pre-wrap;">
                                ${event.content}
  
                             </div>
                            
                            <div class="mt-8 flex gap-4">
<<<<<<< HEAD
                                <a href="${pageContext.request.contextPath}/event/list" 
=======
               
                                 <a href="${pageContext.request.contextPath}/event/list" 
>>>>>>> origin/my-feature
                                   class="bg-slate-500 text-white font-bold px-6 py-3 rounded-md hover:bg-slate-600 transition-colors">
                                    목록으로
   
                                     </a>
                                <button onclick="shareEvent()" class="bg-sky-500 text-white font-bold px-6 py-3 rounded-md hover:bg-sky-600 transition-colors">
                              
                                     공유하기
                                </button>
                            </div>
                        </div>
          
                     </div>
                </div>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        function shareEvent() {
            if (navigator.share) {
            
                 navigator.share({
                    title: document.title,
                    text: 'MEET LOG에서 진행하는 특별한 이벤트를 확인해보세요!',
                    url: window.location.href
                });
             } else {
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('이벤트 링크가 클립보드에 복사되었습니다.');
                });
             }
        }
    </script>
</body>
</html>