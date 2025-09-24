<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 칼럼 작성</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.tiny.cloud/1/${TINYMCE_API_KEY}/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
    
</head>
<body class="bg-slate-100">
    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="flex-grow">
            <div class="container mx-auto p-4 md:p-8">
                <div class="max-w-4xl mx-auto">
                    <div class="mb-6">
                        <h2 class="text-2xl md:text-3xl font-bold mb-2">칼럼 작성</h2>
                        <p class="text-slate-600">맛집에 대한 칼럼을 작성해주세요.</p>
                    </div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="bg-white p-6 rounded-xl shadow-lg">
                                <c:if test="${not empty errorMessage}">
                                    <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
                                        ${errorMessage}
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/column/write" method="post" enctype="multipart/form-data" class="space-y-6">
                                    <input type="hidden" name="action" value="create">
                                    <input type="hidden" name="userId" value="${sessionScope.user.id}">
                                    <input type="hidden" name="author" value="${sessionScope.user.nickname}">

                                    <div>
                                        <label for="title" class="block text-sm font-medium text-slate-700 mb-2">제목</label>
                                        <input type="text" id="title" name="title" required
                                               class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500"
                                               placeholder="칼럼 제목을 입력하세요">
                                    </div>

                                    <div>
                                        <label for="imageUpload" class="block text-sm font-medium text-slate-700 mb-2">썸네일 이미지 (선택사항)</label>
                                        <input type="file" id="imageUpload" name="thumbnail" accept="image/*"
                                               class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                                        <img id="imagePreview" src="" alt="이미지 미리보기" class="mt-4 rounded-lg shadow-sm" style="display: none; max-width: 300px; max-height: 200px;">
                                   </div>

                                    <div>
                                        <label for="content-editor" class="block text-sm font-medium text-slate-700 mb-2">내용</label>
                                        <textarea id="content-editor" name="content"
                                                  class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-sky-500 focus:border-sky-500"
                                                  placeholder="맛집에 대한 칼럼을 작성해주세요. 음식의 특징, 분위기, 추천 메뉴, 방문 팁 등을 자유롭게 작성하세요."></textarea>
                                        <p class="text-sm text-slate-500 mt-1">최소 100자 이상 작성해주세요.</p>
                                    </div>

                                    <div class="bg-slate-50 p-4 rounded-lg">
                                        <h4 class="font-medium text-slate-800 mb-2">📝 작성 팁</h4>
                                        <ul class="text-sm text-slate-600 space-y-1">
                                            <li>• 맛집의 특징과 분위기를 생생하게 묘사해주세요</li>
                                            <li>• 추천 메뉴와 가격 정보를 포함해주세요</li>
                                            <li>• 방문 시간대나 주차 정보 등 실용적인 정보를 추가해주세요</li>
                                            <li>• 개인적인 경험과 감상을 솔직하게 표현해주세요</li>
                                        </ul>
                                    </div>

                                    <div class="flex justify-end space-x-3">
                                        <a href="${pageContext.request.contextPath}/column" 
                                           class="px-6 py-2 border border-slate-300 rounded-md text-slate-700 hover:bg-slate-50">
                                            취소
                                        </a>
                                        <button type="submit" class="px-6 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700">
                                            칼럼 발행
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-12">
                                <div class="text-6xl mb-4">🔒</div>
                                <h2 class="text-2xl font-bold text-slate-800 mb-4">로그인이 필요합니다</h2>
                                <p class="text-slate-600 mb-6">칼럼을 작성하려면 로그인해주세요.</p>
                                <a href="${pageContext.request.contextPath}/login" 
                                   class="inline-block bg-sky-600 text-white font-bold py-3 px-6 rounded-lg hover:bg-sky-700">
                                    로그인하기
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>

    <script>
        $(document).ready(function() {
            $('#imageUpload').on('change', function(event) {
                if (this.files && this.files[0]) {
                     const reader = new FileReader();
                     reader.onload = function(e) {
                        $('#imagePreview').attr('src', e.target.result).show();
                     };
                    reader.readAsDataURL(this.files[0]);
                }
            });

            $('form').on('submit', function(e) {
                // 1. TinyMCE의 현재 내용을 실제 <textarea>에 동기화합니다.
                tinymce.triggerSave();

                const title = $('#title').val().trim();
                
                // 2. 태그를 제외한 순수 텍스트 길이를 검사하기 위해 TinyMCE API를 사용합니다.
                const textContent = tinymce.get('content-editor').getContent({ format: 'text' }).trim();
                
                if (title.length < 2) {
                    e.preventDefault();
                    alert('제목을 2자 이상 입력해주세요.');
                    return false;
                }
                
                if (textContent.length < 100) {
                    e.preventDefault();
                    alert('내용을 100자 이상 작성해주세요.');
                    return false;
                }
            });
        });
        
        tinymce.init({
            selector: 'textarea#content-editor',
            plugins: 'image link lists media table wordcount',
            toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | indent outdent | bullist numlist | link image media | table',
            height: 600,
            
            // 이미지 업로드 관련 설정
            images_upload_handler: (blobInfo) => new Promise((resolve, reject) => {
                const formData = new FormData();
                formData.append('file', blobInfo.blob(), blobInfo.filename());

                fetch('${pageContext.request.contextPath}/api/column/image-upload', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(json => {
                    if (!json || typeof json.location !== 'string') {
                        throw new Error('Invalid JSON: ' + JSON.stringify(json));
                    }
                    resolve(json.location);
                })
                .catch(error => {
                    reject('Upload failed: ' + error.message);
                });
            }),
            content_style: 'body { font-family: "Noto Sans KR", sans-serif; } img { max-width: 100%; height: auto; }'
        });
    </script>
</body>
</html>