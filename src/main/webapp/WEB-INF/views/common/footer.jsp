<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="bg-slate-900 text-white py-12 mt-16">
    <div class="container mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <!-- 회사 정보 -->
            <div class="col-span-1 md:col-span-2">
                <h3 class="text-2xl font-bold mb-4">MEET LOG</h3>
                <p class="text-slate-300 mb-4">
                    맛있는 순간을 기록하고 공유하는 플랫폼입니다.<br>
                    당신만의 특별한 맛집을 발견해보세요.
                </p>
                <div class="flex space-x-4">
                    <a href="#" class="text-slate-300 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                        </svg>
                    </a>
                    <a href="#" class="text-slate-300 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd"/>
                        </svg>
                    </a>
                    <a href="#" class="text-slate-300 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                             <path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.024.06 1.378.06 3.808s-.012 2.784-.06 3.808c-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.024.048-1.378.06-3.808.06s-2.784-.012-3.808-.06c-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.048-1.024-.06-1.378-.06-3.808s.012-2.784.06-3.808c.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 013.45 2.525c.636-.247 1.363-.416 2.427-.465C6.901 2.013 7.255 2 9.685 2h2.63zM12 9.25c-1.507 0-2.75 1.243-2.75 2.75s1.243 2.75 2.75 2.75 2.75-1.243 2.75-2.75S13.507 9.25 12 9.25zm0 4a1.25 1.25 0 100-2.5 1.25 1.25 0 000 2.5zm4.75-5.25a.969.969 0 100-1.938.969.969 0 000 1.938z" clip-rule="evenodd"/>
                        </svg>
                    </a>
                </div>
            </div>
            
            <!-- 빠른 링크 -->
            <div>
                <h4 class="text-lg font-semibold mb-4">빠른 링크</h4>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/main" class="text-slate-300 hover:text-white transition">홈</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurant" class="text-slate-300 hover:text-white transition">맛집찾기</a></li>
                    <li><a href="${pageContext.request.contextPath}/column" class="text-slate-300 hover:text-white transition">칼럼</a></li>
                    <li><a href="${pageContext.request.contextPath}/course" class="text-slate-300 hover:text-white transition">추천코스</a></li>
                    <li><a href="${pageContext.request.contextPath}/event/list" class="text-slate-300 hover:text-white transition">이벤트</a></li>
                </ul>
            </div>
            
            <!-- 고객지원 -->
            <div>
                <h4 class="text-lg font-semibold mb-4">고객지원</h4>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/service" class="text-slate-300 hover:text-white transition">서비스 소개</a></li>
                    <li><a href="${pageContext.request.contextPath}/privacy" class="text-slate-300 hover:text-white transition">개인정보처리방침</a></li>
                    <li><a href="${pageContext.request.contextPath}/inquiry" class="text-slate-300 hover:text-white transition">문의하기</a></li>
                    <li><a href="${pageContext.request.contextPath}/faq" class="text-slate-300 hover:text-white transition">자주 묻는 질문</a></li>
                </ul>
            </div>
        </div>
        
        <div class="border-t border-slate-700 mt-8 pt-8 text-center">
            <p class="text-slate-400">
                © 2025 MEET LOG. All rights reserved. | 
                <a href="${pageContext.request.contextPath}/privacy" class="hover:text-white transition">개인정보처리방침</a> | 
                <a href="${pageContext.request.contextPath}/service" class="hover:text-white transition">이용약관</a>
            </p>
        </div>
    </div>
</footer>