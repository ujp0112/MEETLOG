<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이벤트 - MEET LOG</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
</head>
<body class="bg-slate-50">
    <div class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <h2 class="text-3xl font-bold text-slate-800 mb-8">🎉 이벤트 & 프로모션</h2>
                
                <section>
                    <h3 class="text-xl font-bold text-slate-700 mb-4">진행 중인 이벤트</h3>
                   
                    
                    <c:if test="${empty ongoingEvents}">
                        <div class="bg-white rounded-lg p-8 text-center text-slate-500">
                            현재 진행 중인 이벤트가 없습니다.
                         </div>
                    </c:if>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                        <c:forEach var="event" items="${ongoingEvents}">
                            <%-- [수정] 카드 전체를 클릭할 수 있도록 <a> 태그가 div를 감싸도록 변경 --%>
                            <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="block hover:shadow-xl transition-shadow rounded-lg">
                                <div class="bg-white rounded-lg shadow-md overflow-hidden h-full">
                                    <mytag:image fileName="${event.image}" altText="${event.title}" cssClass="w-full h-48 object-cover" />
                                    <div class="p-6">
                                        <h4 class="text-xl font-bold mb-2 truncate">${event.title}</h4>
                                        <p class="text-slate-600 mb-4 h-20 overflow-hidden text-ellipsis">${event.summary}</p>
                                        <div class="flex justify-between items-center text-sm text-slate-500">
                                            <span>시작: <fmt:formatDate value="${event.startDate}" pattern="yyyy.MM.dd"/></span>
                                            <span>종료: <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/></span>
                                        </div>
                                        <%-- "자세히 보기" 버튼은 이 자리에서 삭제되었습니다. --%>                                        
                                             <span>종료: <fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/></span>
                                        </div>
                                        <%-- "자세히 보기" 버튼은 이 자리에서 삭제되었습니다. --%>
>>>>>>> origin/my-feature
                                    </div>
                                </div>
                            </a>
    
                         </c:forEach>
                    </div>
                </section>
                
                <section class="mt-12">
           
                     <h3 class="text-xl font-bold text-slate-700 mb-4">종료된 이벤트</h3>
                     <c:if test="${empty finishedEvents}">
                        <div class="bg-white rounded-lg p-8 text-center text-slate-500">
                            종료된 이벤트가 없습니다.
                         </div>
                    </c:if>
                    <ul>
                        <c:forEach var="event" items="${finishedEvents}">
                            <li class="text-slate-500">
     
                                 <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="hover:text-sky-600">
                                    [<fmt:formatDate value="${event.endDate}" pattern="yyyy.MM.dd"/> 종료] ${event.title}
                               
                                  </a>
                            </li>
                        </c:forEach>
                    </ul>
                </section>
           
             </div>
        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>