<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - 리뷰 작성</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .image-add-btn { cursor: pointer; display: flex; flex-direction: column; justify-content: center; align-items: center; width: 100px; height: 100px; border: 2px dashed #cbd5e1; border-radius: 0.5rem; color: #64748b; }
        .image-preview-container { position: relative; width: 100px; height: 100px; flex-shrink: 0; } /* flex-shrink: 0 추가 */
        .image-preview { width: 100%; height: 100%; object-fit: cover; border-radius: 0.5rem; }
        .remove-image-btn { position: absolute; top: -5px; right: -5px; width: 24px; height: 24px; background-color: rgba(0,0,0,0.7); color: white; border: none; border-radius: 50%; cursor: pointer; display: flex; justify-content: center; align-items: center; font-size: 14px; line-height: 1; }
        .keyword-tag { cursor: pointer; padding: 6px 12px; border: 1px solid #e2e8f0; border-radius: 9999px; transition: all 0.2s; }
        .keyword-tag.selected { background-color: #3b82f6; color: white; border-color: #3b82f6; }
        .rating-star { cursor: pointer; color: #d1d5db; transition: color 0.2s; }
        .rotate-180 { transform: rotate(180deg); }
    </style>
</head>
<body class="bg-gray-50">
    <div class="container mx-auto max-w-2xl p-4 sm:p-6 lg:p-8">
        <div class="bg-white p-8 rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-gray-800 mb-2">리뷰 작성</h1>
            <p class="text-gray-600 mb-6">${restaurant.name}</p>

            <form id="review-form" action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data">
                <input type="hidden" name="restaurantId" value="${restaurant.id}">

                <%-- [수정] 오류 메시지 표시 --%>
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                        <strong class="font-bold">오류!</strong>
                        <span class="block sm:inline">${errorMessage}</span>
                    </div>
                </c:if>
                
                <div class="mb-6">
                    <h2 class="text-lg font-semibold text-gray-700 mb-3">별점</h2>
                    <div class="flex items-center space-x-1">
                        <span class="rating-star text-3xl" data-rating="1">★</span>
                        <span class="rating-star text-3xl" data-rating="2">★</span>
                        <span class="rating-star text-3xl" data-rating="3">★</span>
                        <span class="rating-star text-3xl" data-rating="4">★</span>
                        <span class="rating-star text-3xl" data-rating="5">★</span>
                        <span id="rating-text" class="ml-4 text-lg font-bold text-blue-600">0점</span>
                    </div>
                    <input type="hidden" name="rating" id="rating" value="${not empty param.rating ? param.rating : 0}">
                </div>

                <div class="mb-6">
                     <div class="accordion-header flex justify-between items-center cursor-pointer py-2">
                        <h2 class="text-lg font-semibold text-gray-700">키워드 선택</h2>
                        <span class="transform transition-transform duration-200">▼</span>
                    </div>
                    <div class="accordion-content hidden">
                        <c:forEach var="category" items="${keywordCategories}">
                            <div class="mb-4">
                                <h3 class="font-semibold text-gray-600 mb-2">${category.key}</h3>
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="keyword" items="${category.value}">
                                        <span class="keyword-tag">${keyword}</span>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <input type="hidden" name="keywords" id="keywords-input" value="${param.keywords}">
                </div>

                <div class="mb-6">
                    <label for="content" class="block text-lg font-semibold text-gray-700 mb-2">리뷰 내용</label>
                    <textarea id="content" name="content" rows="8" class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="상세한 리뷰를 남겨주세요.">${param.content}</textarea>
                </div>

                <div class="mb-8">
                    <h2 class="text-lg font-semibold text-gray-700 mb-2">사진 첨부</h2>
                    <div id="image-preview-area" class="flex flex-wrap gap-4">
                        <%-- 미리보기 이미지가 여기에 동적으로 추가됩니다 --%>
                        <div id="image-add-button-container">
                             <label for="image-upload-input" class="image-add-btn">
                                <span>+</span>
                                <span>사진 추가</span>
                            </label>
                        </div>
                    </div>
                    <input type="file" id="image-upload-input" name="images" multiple accept="image/*" class="hidden">
                </div>

                <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-md font-bold hover:bg-blue-700 transition-colors">리뷰 등록</button>
            </form>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        const dataTransfer = new DataTransfer();

        $('#image-upload-input').on('change', function(e) {
            const files = e.target.files;

            for (const file of files) {
                dataTransfer.items.add(file);

                const reader = new FileReader();

                reader.onload = function(event) {
                	const previewHtml =
                        '<div class="image-preview-container" data-filename="' + file.name + '">' +
                            '<img src="' + event.target.result + '" class="image-preview">' +
                            '<button type="button" class="remove-image-btn">×</button>' +
                        '</div>';
                    // 미리보기 영역에 생성된 HTML을 '사진 추가' 버튼 앞에 추가하는 대신,
                    // 항상 영역의 마지막에 추가하고, '사진 추가' 버튼은 appendTo로 맨 뒤로 옮깁니다.
                    $('#image-preview-area').append(previewHtml);
                    $('#image-add-button-container').appendTo('#image-preview-area'); // 추가된 부분
                };
                
                reader.readAsDataURL(file);
            }
            
            $(this).val('');
            $('#image-upload-input')[0].files = dataTransfer.files;
        });

        $(document).on('click', '.remove-image-btn', function() {
            const container = $(this).closest('.image-preview-container');
            const filename = container.data('filename');
            
            container.remove();
            
            const newFiles = new DataTransfer();
            for (const file of dataTransfer.files) {
                if (file.name !== filename) {
                    newFiles.items.add(file);
                }
            }
            
            const tempFileList = newFiles.files;
            dataTransfer.items.clear(); 
            for(const file of tempFileList){
                dataTransfer.items.add(file); 
            }
            
            $('#image-upload-input')[0].files = dataTransfer.files;
        });
        
        $('#review-form').on('submit', function() {
            $('#image-upload-input')[0].files = dataTransfer.files;
            return true;
        });
        
        $('.keyword-tag').on('click', function() {
            const selectedCount = $('.keyword-tag.selected').length;
            const isSelected = $(this).hasClass('selected');

            if (!isSelected && selectedCount >= 5) {
                alert('키워드는 최대 5개까지 선택할 수 있습니다.');
                return; // 5개가 넘으면 더 이상 선택할 수 없도록 중단
            }

            $(this).toggleClass('selected'); 
            updateKeywordsInput(); 
        });
        $('.accordion-header').on('click', function() { $(this).next('.accordion-content').slideToggle(200); $(this).find('span').toggleClass('rotate-180'); });
        
        function updateKeywordsInput() {
            const selectedKeywords = [];
            $('.keyword-tag.selected').each(function() { selectedKeywords.push($(this).text()); });
            $('#keywords-input').val(selectedKeywords.join(','));
        }

        let currentRating = parseInt($('#rating').val()) || 0;
        
        function updateStars(rating) {
            $('.rating-star').each(function() {
                $(this).toggleClass('text-yellow-400', $(this).data('rating') <= rating)
                       .toggleClass('text-gray-300', $(this).data('rating') > rating);
            });
            $('#rating-text').text(rating + '점');
        }

        $('.rating-star').on('mouseenter', function() { updateStars($(this).data('rating')); })
            .on('mouseleave', function() { updateStars(currentRating); })
            .on('click', function() { 
                currentRating = $(this).data('rating'); 
                $('#rating').val(currentRating); 
                updateStars(currentRating);
            });

        // 페이지 로드 시 기존 값으로 UI 초기화
        function initializeForm() {
            // 1. 별점 초기화
            updateStars(currentRating);

            // 2. 키워드 초기화
            const initialKeywords = $('#keywords-input').val();
            if (initialKeywords) {
                const keywordsArray = initialKeywords.split(',');
                $('.keyword-tag').each(function() {
                    if (keywordsArray.includes($(this).text().trim())) {
                        $(this).addClass('selected');
                    }
                });
            }
        }

        initializeForm();
    });
    </script>
</body>
</html>