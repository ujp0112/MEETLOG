<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="bg-slate-800 text-slate-400 py-12">
    <div class="container mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div class="md:col-span-2">
                <h3 class="text-2xl font-bold text-white mb-4">MEET LOG</h3>
                <p class="text-slate-400 mb-4">나에게 꼭 맞는 맛집을 찾는 가장 확실한 방법</p>
                <div class="flex space-x-4">
                    <a href="#" class="text-slate-400 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z"/>
                        </svg>
                    </a>
                    <a href="#" class="text-slate-400 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd"/>
                        </svg>
                    </a>
                    <a href="#" class="text-slate-400 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                             <path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.024.06 1.378.06 3.808s-.012 2.784-.06 3.808c-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.024.048-1.378.06-3.808.06s-2.784-.012-3.808-.06c-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.048-1.024-.06-1.378-.06-3.808s.012-2.784.06-3.808c.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 013.45 2.525c.636-.247 1.363-.416 2.427-.465C6.901 2.013 7.255 2 9.685 2h2.63zM12 9.25c-1.507 0-2.75 1.243-2.75 2.75s1.243 2.75 2.75 2.75 2.75-1.243 2.75-2.75S13.507 9.25 12 9.25zm0 4a1.25 1.25 0 100-2.5 1.25 1.25 0 000 2.5zm4.75-5.25a.969.969 0 100-1.938.969.969 0 000 1.938z" clip-rule="evenodd"/>
                        </svg>
                    </a>
                </div>
            </div>
            
            <div>
                <h4 class="text-white font-semibold mb-4">서비스</h4>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/main" class="text-slate-400 hover:text-white transition-colors">홈</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurant" class="text-slate-400 hover:text-white transition-colors">맛집 검색</a></li>
                    <li><a href="${pageContext.request.contextPath}/column" class="text-slate-400 hover:text-white transition-colors">칼럼</a></li>
                    <li><a href="${pageContext.request.contextPath}/mypage" class="text-slate-400 hover:text-white transition-colors">마이페이지</a></li>
                </ul>
            </div>
            
            <div>
                <h4 class="text-white font-semibold mb-4">고객지원</h4>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/service" class="text-slate-400 hover:text-white transition-colors">이용약관</a></li>
                    <li><a href="${pageContext.request.contextPath}/privacy" class="text-slate-400 hover:text-white transition-colors">개인정보처리방침</a></li>
                    <li><a href="#" class="text-slate-400 hover:text-white transition-colors">고객센터</a></li>
                    <li><a href="#" class="text-slate-400 hover:text-white transition-colors">FAQ</a></li>
                </ul>
            </div>
        </div>
        
        <div class="border-t border-slate-700 mt-8 pt-8 text-center">
            <p>&copy; 2025 MEET LOG. All Rights Reserved.</p>
        </div>
    </div>
</footer>