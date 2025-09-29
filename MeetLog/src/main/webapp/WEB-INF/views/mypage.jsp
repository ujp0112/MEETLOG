<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 마이페이지</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <%-- The header path is standardized based on your first example --%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
  
           <div class="container mx-auto p-4 md:p-8">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                   
                         <div class="lg:col-span-1">
                                <div class="bg-white p-6 rounded-xl shadow-lg">
                                    <div class="text-center">
                 
                                        <mytag:image fileName="${sessionScope.user.profileImage}" altText="프로필" cssClass="w-24 h-24 rounded-full mx-auto mb-4" />
                                        <h2 class="text-xl font-bold text-slate-800">${sessionScope.user.nickname}</h2>
    
                                         <p class="text-slate-600 text-sm">${sessionScope.user.email}</p>
                                        <div class="mt-4">
                     
                                         <span class="inline-block bg-sky-100 text-sky-800 text-xs px-2 py-1 rounded-full">
                                                ${sessionScope.user.userType == 'PERSONAL' ? '개인회원' : '기업회원'}
                
                                             </span>
                                        </div>
                                
                                     </div>
                                </div>
                            </div>

                            <div class="lg:col-span-3 space-y-6">
      
                                 <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-sky-600">${fn:length(myReviews)}</div>
                                        <div class="text-sm text-slate-600">작성한 리뷰</div>
                                    </div>
                                     <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                        <div class="text-2xl font-bold text-sky-600">${fn:length(myColumns)}</div>
                                         <div class="text-sm text-slate-600">작성한 칼럼</div>
                                    </div>
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-sky-600">${fn:length(myReservations)}</div>
                                        <div class="text-sm text-slate-600">예약 내역</div>
                                     </div>
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-green-600">${availableCouponCount}</div>
                                        <div class="text-sm text-slate-600">사용 가능한 쿠폰</div>
                                     </div>
                                    <div class="bg-white p-6 rounded-xl shadow-lg text-center">
                                         <div class="text-2xl font-bold text-purple-600">${myCoursesCount}</div>
                                        <div class="text-sm text-slate-600">만든 코스</div>
                                     </div>
                                </div>

                                <div class="bg-white p-6 rounded-xl shadow-lg">
             
                                     <h3 class="text-xl font-bold text-slate-800 mb-4">최근 활동</h3>
                                    <div class="space-y-4">
                                   
                                         <c:choose>
                                            <c:when test="${not empty myReviews}">
                                                
                                                 <%-- Loop through the first 3 reviews --%>
                                                <c:forEach items="${myReviews}" var="review" begin="0" end="2">
                                         
                                                     <div class="flex items-center p-3 bg-slate-50 rounded-lg">
                                                        <div class="text-2xl mr-3">📝</div>
                          
                                                         <div class="flex-grow">
                                                            <p class="font-medium text-slate-800">
       
                                                                                             <c:choose>
                                           
                                                                                                 <c:when test="${fn:length(review.content) > 50}">
                                                                        
                                                                                                     ${fn:substring(review.content, 0, 50)}...
                                                                    </c:when>
                              
                                                                                                     <c:otherwise>
                                                              
                                                                                                         ${review.content}
                                                                    </c:otherwise>
                      
                                                                                                 </c:choose>
                                                          
                                                               </p>
                                                            <p class="text-sm text-slate-500">${review.createdAt}</p>
                                    
                                                         </div>
                                                    </div>
                            
                                                 </c:forEach>
                                            </c:when>
                                    
                                                 <c:otherwise>
                                                <div class="text-center text-slate-500 py-8">
                                         
                                                     <div class="text-4xl mb-2">📝</div>
                                                    <p>아직 작성한 리뷰가 없습니다.</p>
                                
                                                 </div>
                                            </c:otherwise>
                                        
                                         </c:choose>
                                    </div>
                                </div>


                                 <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                    <a href="${pageContext.request.contextPath}/mypage/reviews"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">📝</div>
                                        <h4 class="font-bold text-slate-800">내 리뷰</h4>
                                         <p class="text-sm text-slate-600">작성한 리뷰 관리</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/mypage/columns"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                        <div class="text-3xl mb-2">📰</div>
                                         <h4 class="font-bold text-slate-800">내 칼럼</h4>
                                        <p class="text-sm text-slate-600">작성한 칼럼 관리</p>
                                     </a>
                                    <a href="${pageContext.request.contextPath}/mypage/reservations"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">📅</div>
                                        <h4 class="font-bold text-slate-800">예약 내역</h4>
                                         <p class="text-sm text-slate-600">예약 관리</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/mypage/coupons"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">🎫</div>
                                        <h4 class="font-bold text-slate-800">내 쿠폰</h4>
                                         <p class="text-sm text-slate-600">쿠폰 관리 및 사용</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/my-courses"
                                       class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                         <div class="text-3xl mb-2">🗺️</div>
                                        <h4 class="font-bold text-slate-800">내 코스</h4>
                                         <p class="text-sm text-slate-600">내가 만든 코스 관리</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/mypage/settings"
                                         class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow text-center">
                                        <div class="text-3xl mb-2">⚙️</div>
                                         <h4 class="font-bold text-slate-800">설정</h4>
                                        <p class="text-sm text-slate-600">계정 설정</p>
                                    </a>
                                 </div>
                            </div>
                        </div>
                    </c:when>
   
                     <c:otherwise>
                        <div class="text-center py-12">
                            <div class="text-6xl mb-4">🔒</div>
                           
                             <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                            <p class="text-slate-600 mb-6">마이페이지를 이용하려면 로그인해주세요.</p>
                            <a href="${pageContext.request.contextPath}/login" 
                               class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                로그인하기
                            </a>
                        </div>
          
                     </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <%-- Replaced the inline footer with a reusable JSP include --%>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</body>
</html>