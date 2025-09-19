<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div id="loading-overlay" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-lg p-6 flex items-center space-x-3">
        <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-sky-600"></div>
        <span class="text-slate-700">처리 중...</span>
    </div>
</div>

<script>
    // 로딩 오버레이를 보여주는 함수
    function showLoading() {
        document.getElementById('loading-overlay').classList.remove('hidden');
    }
    
    // 로딩 오버레이를 숨기는 함수
    function hideLoading() {
        document.getElementById('loading-overlay').classList.add('hidden');
    }
    
    // 페이지 로드가 완료되면 스크립트 실행
    document.addEventListener('DOMContentLoaded', function() {
        // 페이지의 모든 form 태그에 'submit' 이벤트 리스너 추가
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            form.addEventListener('submit', function() {
                showLoading(); // 폼 제출 시 로딩 표시
            });
        });
        
        // window.fetch 함수를 재정의하여 AJAX 요청을 가로채기
        const originalFetch = window.fetch;
        window.fetch = function(...args) {
            showLoading(); // fetch 요청 시작 시 로딩 표시
            
            // 원래 fetch 함수를 실행하고, 요청이 성공하든 실패하든 항상 finally 블록 실행
            return originalFetch.apply(this, args)
                .finally(() => {
                    // 너무 빨리 사라지는 것을 방지하기 위해 최소 0.5초간 로딩을 표시
                    setTimeout(hideLoading, 500); 
                });
        };
    });
</script>