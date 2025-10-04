<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="bg-blue-500 text-blue-200">
  <div class="mx-auto max-w-7xl px-4 py-16">

    <div class="flex flex-col gap-12 lg:flex-row lg:justify-between">
      
      <div class="max-w-md space-y-6">
        <div>
          <p class="text-xl font-black tracking-tight text-white">MEET LOG</p>
          <p class="mt-2 text-sm">맛있는 순간을 기록하고 공유하는 미식 플랫폼. 취향과 데이터를 연결해 실패 없는 만남을 완성합니다.</p>
        </div>
        <div class="space-y-3 text-sm">
          <p class="text-base font-bold text-white">고객센터</p>
          <div class="space-y-1 text-xs">
            <p>이메일 : <a href="mailto:cs@meetlog.com" class="font-semibold text-white hover:underline">cs@meetlog.com</a></p>
            <p>운영시간 : 평일 10:00 - 18:00 (점심시간 12:00 - 13:00)</p>
            <p>주소 : 서울특별시 금천구 가산동 가산디지털1로 70, 9F</p>
          </div>
        </div>
        <div class="flex items-center gap-4 text-indigo-300">
          <a href="https://x.com/" target="_blank" class="hover:text-white" aria-label="X social link">
            <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"></path></svg>
          </a>
          <a href="https://instagram.com/" target="_blank" class="hover:text-white" aria-label="Instagram social link">
            <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.85s-.012 3.584-.07 4.85c-.148 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07s-3.584-.012-4.85-.07c-3.252-.148-4.771-1.691-4.919-4.919-.058-1.265-.069-1.645-.069-4.85s.012-3.584.07-4.85C2.165 3.856 3.708 2.31 6.96 2.163 8.216 2.105 8.596 2.093 12 2.093zm0-2.163C8.618 0 8.162.016 6.906.068 2.924.225.225 2.924.068 6.906.016 8.162 0 8.618 0 12s.016 3.838.068 5.094c.157 3.982 2.856 6.681 6.838 6.838 1.256.052 1.712.068 5.094.068s3.838-.016 5.094-.068c3.982-.157 6.681-2.856 6.838-6.838.052-1.256.068-1.712.068-5.094s-.016-3.838-.068-5.094C21.076 2.924 18.377.225 14.394.068 13.138.016 12.682 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.88 1.44 1.44 0 000-2.88z"></path></svg>
          </a>
          <a href="https://facebook.com/" target="_blank" class="hover:text-white" aria-label="Facebook social link">
            <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M22.675 0h-21.35C.59 0 0 .59 0 1.325v21.35C0 23.41.59 24 1.325 24H12.82v-9.29H9.69v-3.62h3.13V8.41c0-3.1 1.89-4.79 4.66-4.79 1.32 0 2.46.1 2.78.14v3.24h-1.9c-1.5 0-1.8.72-1.8 1.77v2.3h3.59l-.47 3.62h-3.12V24h5.72c.73 0 1.32-.59 1.32-1.32V1.32C24 .59 23.41 0 22.675 0z"></path></svg>
          </a>
        </div>
      </div>

      <%-- 2. 고객 지원 섹션을 가로 형태로 수정 --%>
      <div class="w-full lg:max-w-md">
        <h3 class="text-base font-semibold text-white">고객지원</h3>
        <hr class="my-3 border-indigo-500"> <%-- 구분선 색상 변경 --%>
        <div class="flex flex-wrap items-center gap-x-6 gap-y-2 text-sm">
          <a href="${pageContext.request.contextPath}/service" class="hover:text-white hover:underline">서비스 소개</a>
          <a href="${pageContext.request.contextPath}/faq" class="hover:text-white hover:underline">자주 묻는 질문</a>
          <a href="${pageContext.request.contextPath}/inquiry" class="hover:text-white hover:underline">문의하기</a>
          <a href="${pageContext.request.contextPath}/privacy" class="hover:text-white hover:underline">개인정보처리방침</a>
          <a href="${pageContext.request.contextPath}/terms" class="hover:text-white hover:underline">이용약관</a>
        </div>
      </div>

    </div>

    <div class="mt-16 border-t border-indigo-500/50 pt-8 text-center text-xs text-indigo-300 sm:flex sm:items-center sm:justify-between sm:text-left"> <%-- 여백(mt) 및 색상 변경 --%>
      <p>© 2025 MEET LOG. All rights reserved.</p>
      <p class="mt-4 sm:mt-0">사업자등록번호 123-45-67890 | 통신판매업 신고 2025-서울금천-1234 | 대표 이재호</p>
    </div>
  </div>
</footer>