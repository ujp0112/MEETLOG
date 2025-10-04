<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="bg-sky-600 text-blue-200">
  <div class="mx-auto max-w-7xl px-4 py-14">

    <div class="flex flex-col gap-8 lg:flex-row lg:justify-between">
      
      <div class="max-w-md space-y-6">
        <div>
          <p class="text-xl font-black tracking-tight text-white">MEET LOG</p>
          <p class="mt-2 text-sm">맛있는 순간을 기록하고 공유하는 미식 플랫폼 MEET LOG</p>
        </div>

        <div class="space-y-3 text-sm mt-4">
          <p class="text-base font-bold text-white">고객센터</p>
          <hr class="my-3 border-indigo-200">
          <div class="space-y-1 text-xs">
            <p>이메일 : <a href="mailto:cs@meetlog.com" class="font-semibold text-white hover:underline">cs@meetlog.com</a></p>
            <p>운영시간 : 평일 10:00 - 18:00 (점심시간 12:00 - 13:00)</p>
            <p>주소 : 서울특별시 금천구 가산동 가산디지털1로 70, 9F</p>
          </div>
        </div>

      </div>


      <div class="w-full lg:max-w-md">
        <h3 class="text-base font-semibold text-white">고객지원</h3>
        <hr class="my-3 border-indigo-200">
        <div class="flex flex-wrap items-center gap-x-6 gap-y-2 text-sm">
          <a href="${pageContext.request.contextPath}/service" class="hover:text-white hover:underline">서비스</a>
          <a href="${pageContext.request.contextPath}/faq" class="hover:text-white hover:underline">자주 묻는 질문</a>
          <a href="${pageContext.request.contextPath}/inquiry" class="hover:text-white hover:underline">문의하기</a>
          <a href="${pageContext.request.contextPath}/privacy" class="hover:text-white hover:underline">개인정보처리방침</a>
          <a href="${pageContext.request.contextPath}/terms" class="hover:text-white hover:underline">이용약관</a>
        </div>

      </div>

    </div>
    <div class="mt-8 pt-4 text-center text-xs text-sky-200 sm:flex sm:items-center sm:justify-between sm:text-left">
      <p>© 2025 MEET LOG All rights reserved.</p>
      <p class="mt-4 sm:mt-0">사업자등록번호 123-45-67890 | 통신판매업 신고 2025-서울금천-1234 | 대표 이재호</p>
    </div>

  </div>
</footer>