<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Balanced Footer - Header Style Match with Hover Interactions -->
<footer class="bg-white/85 backdrop-blur-lg border-t border-slate-200/50 mt-16">
  <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">

    <!-- Main Content: 3-Column Grid -->
    <div class="grid grid-cols-1 gap-8 md:grid-cols-3">

      <!-- Column 1: Brand & Description -->
      <div class="space-y-3">
        <div class="flex items-center gap-2">

          <h2 class="text-xl font-black text-slate-900">MEET LOG</h2>
        </div>
        <p class="text-sm leading-relaxed text-slate-600">
          맛있는 순간을 기록하고 공유하는<br>프리미엄 미식 플랫폼
        </p>

      </div>

      <!-- Column 2: Quick Links -->
      <div class="space-y-3">
        <h3 class="text-sm font-semibold text-slate-900 flex items-center gap-2">
          <svg class="h-4 w-4 text-slate-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
          </svg>
          빠른 링크
        </h3>
        <nav class="flex flex-col gap-2" role="navigation" aria-label="푸터 네비게이션">
          <a href="${pageContext.request.contextPath}/service"
             class="group inline-flex items-center gap-2 text-sm text-slate-600 transition-all duration-300 ease-out hover:translate-x-1 hover:text-blue-600">
            <svg class="h-3.5 w-3.5 opacity-0 -ml-5 transition-all duration-300 group-hover:opacity-100 group-hover:ml-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span>서비스 소개</span>
          </a>
          <a href="${pageContext.request.contextPath}/faq"
             class="group inline-flex items-center gap-2 text-sm text-slate-600 transition-all duration-300 ease-out hover:translate-x-1 hover:text-blue-600">
            <svg class="h-3.5 w-3.5 opacity-0 -ml-5 transition-all duration-300 group-hover:opacity-100 group-hover:ml-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span>자주 묻는 질문</span>
          </a>
          <a href="${pageContext.request.contextPath}/inquiry"
             class="group inline-flex items-center gap-2 text-sm text-slate-600 transition-all duration-300 ease-out hover:translate-x-1 hover:text-blue-600">
            <svg class="h-3.5 w-3.5 opacity-0 -ml-5 transition-all duration-300 group-hover:opacity-100 group-hover:ml-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span>문의하기</span>
          </a>
          <a href="${pageContext.request.contextPath}/privacy"
             class="group inline-flex items-center gap-2 text-sm text-slate-600 transition-all duration-300 ease-out hover:translate-x-1 hover:text-blue-600">
            <svg class="h-3.5 w-3.5 opacity-0 -ml-5 transition-all duration-300 group-hover:opacity-100 group-hover:ml-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span>개인정보처리방침</span>
          </a>
          <a href="${pageContext.request.contextPath}/terms"
             class="group inline-flex items-center gap-2 text-sm text-slate-600 transition-all duration-300 ease-out hover:translate-x-1 hover:text-blue-600">
            <svg class="h-3.5 w-3.5 opacity-0 -ml-5 transition-all duration-300 group-hover:opacity-100 group-hover:ml-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span>이용약관</span>
          </a>
        </nav>
      </div>

      <!-- Column 3: Contact & Support -->
      <div class="space-y-3">
        <h3 class="text-sm font-semibold text-slate-900 flex items-center gap-2">
          <svg class="h-4 w-4 text-slate-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 4.5v2.25z" />
          </svg>
          고객 지원
        </h3>
        <div class="space-y-2.5">
          <!-- Email -->
          <a href="mailto:cs@meetlog.com"
             class="group flex items-center gap-2.5 rounded-lg border border-slate-200/50 bg-slate-50/30 px-3 py-2.5 text-sm text-slate-700 transition-all duration-300 ease-out hover:translate-x-1 hover:border-blue-300 hover:bg-blue-50/50 hover:text-blue-600 hover:shadow-sm"
             aria-label="고객센터 이메일">
            <svg class="h-5 w-5 flex-shrink-0 text-slate-400 transition-colors duration-300 group-hover:text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75" />
            </svg>
            <div class="flex flex-col">
              <span class="text-xs text-slate-500 transition-colors duration-300 group-hover:text-blue-500">이메일 문의</span>
              <span class="font-medium">cs@meetlog.com</span>
            </div>
          </a>

          <!-- Phone -->
          <a href="tel:02-1234-5678"
             class="group flex items-center gap-2.5 rounded-lg border border-slate-200/50 bg-slate-50/30 px-3 py-2.5 text-sm text-slate-700 transition-all duration-300 ease-out hover:translate-x-1 hover:border-blue-300 hover:bg-blue-50/50 hover:text-blue-600 hover:shadow-sm"
             aria-label="고객센터 전화">
            <svg class="h-5 w-5 flex-shrink-0 text-slate-400 transition-colors duration-300 group-hover:text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 4.5v2.25z" />
            </svg>
            <div class="flex flex-col">
              <span class="text-xs text-slate-500 transition-colors duration-300 group-hover:text-blue-500">대표 전화</span>
              <span class="font-medium">02-1234-5678</span>
            </div>
          </a>

          <!-- Business Hours -->
          <div class="flex items-start gap-2.5 rounded-lg border border-slate-200/50 bg-slate-50/30 px-3 py-2.5 text-xs text-slate-600">
            <svg class="h-4 w-4 mt-0.5 flex-shrink-0 text-slate-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div class="flex flex-col gap-0.5">
              <span class="text-slate-500">평일 09:00 - 18:00</span>
              <span class="text-slate-500">주말 및 공휴일 휴무</span>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- Divider -->
    <div class="my-6 border-t border-slate-200/50"></div>

    <!-- Bottom Section: Social + Legal -->
    <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">

      <!-- Left: Social Media -->
      <div class="flex items-center gap-3 text-xs text-slate-500">
        <div class="flex flex-wrap items-center gap-x-3 gap-y-1">
          <span>사업자등록번호 123-45-67890</span>
          <span class="hidden sm:inline" aria-hidden="true">|</span>
          <span>통신판매업 2025-서울금천-1234</span>
          <span class="hidden sm:inline" aria-hidden="true">|</span>
          <span>대표 이재호</span>
        </div>
        <!-- <span class="text-xs font-medium text-slate-600">함께하세요</span>
        <div class="flex gap-2" role="group" aria-label="소셜 미디어">
          <a href="#"
             aria-label="Instagram"
             class="group flex h-9 w-9 items-center justify-center rounded-lg bg-gradient-to-br from-purple-500 to-pink-500 text-white shadow-sm transition-all duration-300 ease-out hover:scale-110 hover:shadow-md">
            <svg class="h-5 w-5 transition-transform duration-300 group-hover:rotate-12" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
              <path d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z"/>
            </svg>
          </a>
          <a href="#"
             aria-label="Facebook"
             class="group flex h-9 w-9 items-center justify-center rounded-lg bg-blue-600 text-white shadow-sm transition-all duration-300 ease-out hover:scale-110 hover:bg-blue-700 hover:shadow-md">
            <svg class="h-5 w-5 transition-transform duration-300 group-hover:rotate-12" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
              <path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd"/>
            </svg>
          </a>
          <a href="#"
             aria-label="Twitter"
             class="group flex h-9 w-9 items-center justify-center rounded-lg bg-slate-800 text-white shadow-sm transition-all duration-300 ease-out hover:scale-110 hover:bg-slate-900 hover:shadow-md">
            <svg class="h-5 w-5 transition-transform duration-300 group-hover:rotate-12" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
              <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
            </svg>
          </a>
        </div> -->
      </div>

      <!-- Right: Legal & Copyright -->
      <div class="flex flex-col gap-2 text-xs text-slate-500">

        <div class="flex flex-wrap items-center gap-x-3 gap-y-1">
          <span>서울특별시 금천구 가산디지털1로 70, 9F</span>
          <span class="hidden sm:inline" aria-hidden="true">|</span>
          <span class="font-medium text-slate-600">&copy; 2025 MEET LOG. All rights reserved.</span>
        </div>
      </div>

    </div>

  </div>
</footer>
