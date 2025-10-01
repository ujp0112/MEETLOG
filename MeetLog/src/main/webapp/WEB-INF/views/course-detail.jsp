<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEET LOG - ${course.title}</title> 
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-100">

    <div id="app" class="flex flex-col min-h-screen">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-4 md:p-8 max-w-3xl">

                <c:choose>
                    <c:when test="${not empty course}">
                        <div id="course-detail-container" class="bg-white rounded-2xl shadow-lg overflow-hidden">
                            <div>
                                <c:choose>
                                    <c:when test="${not empty course.previewImage}">
                                        <mytag:image fileName="${course.previewImage}" altText="${course.title}" cssClass="w-full h-72 object-cover" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-72 bg-gradient-to-br from-green-200 to-green-400 flex items-center justify-center">
                                            <span class="text-4xl">MEET LOG</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="p-6 md:p-8">
                                <div class="flex flex-wrap gap-2 mb-4">
                                    <c:forEach var="tag" items="${course.tags}">
                                        <span class="text-xs font-semibold bg-sky-100 text-sky-700 px-2 py-1 rounded-full">${tag}</span>
                                    </c:forEach>
                                </div>
                                <h1 class="text-4xl font-bold">${course.title}</h1>

                                <div class="flex items-center mt-4 mb-6 pb-6 border-b">
                                    <c:if test="${not empty course.author}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(course.profileImage, 'http')}">
                                                <c:set var="authorImageUrl" value="${course.profileImage}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="authorImageUrl" value="${pageContext.request.contextPath}/${course.profileImage}" />
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="${authorImageUrl}" alt="${course.author}" class="w-10 h-10 rounded-full mr-3 object-cover">
                                        <div>
                                            <p><a href="${pageContext.request.contextPath}/feed/user/${course.userId}" class="font-semibold hover:text-blue-600 transition-colors">${course.author}</a></p>
                                            <p class="text-sm text-slate-500">작성자</p>
                                        </div>
                                    </c:if>

                                    <div class="ml-auto flex items-center gap-4">
                                        <button type="button" id="like-btn" class="flex items-center gap-1 font-semibold transition <c:choose><c:when test='${isLiked}'>text-red-500</c:when><c:otherwise>text-slate-600 hover:text-red-500</c:otherwise></c:choose>" data-course-id="<c:out value='${course.id}'/>">
                                            <svg class="w-5 h-5" fill="<c:choose><c:when test='${isLiked}'>currentColor</c:when><c:otherwise>none</c:otherwise></c:choose>" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
                                            <span id="like-count"><c:out value="${course.likes}"/></span>
                                        </button>
                                        <button type="button" id="wishlist-btn" class="flex items-center gap-1 font-semibold py-2 px-4 rounded-full text-sm transition <c:choose><c:when test='${isWishlisted}'>bg-red-500 text-white hover:bg-red-600</c:when><c:otherwise>bg-gray-200 text-gray-700 hover:bg-gray-300</c:otherwise></c:choose>" data-course-id="<c:out value='${course.id}'/>">
                                            <svg class="w-4 h-4" fill="<c:choose><c:when test='${isWishlisted}'>currentColor</c:when><c:otherwise>none</c:otherwise></c:choose>" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
                                            </svg>
                                            <span id="wishlist-text"><c:choose><c:when test='${isWishlisted}'>찜 완료</c:when><c:otherwise>찜하기</c:otherwise></c:choose></span>
                                        </button>
                                    </div>
                                </div>

                                <h3 class="text-2xl font-bold mb-6">코스 상세 경로</h3>
                                <div class="relative border-l-2 border-sky-200 pl-8 space-y-8">
                                    <c:forEach var="step" items="${steps}" varStatus="status">
                                        <div class="relative">
                                            <div class="absolute -left-10 top-2 w-4 h-4 bg-sky-500 rounded-full border-2 border-white"></div>
                                            <div class="flex items-start gap-4">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(step.image, 'http')}">
                                                        <c:set var="stepImageUrl" value="${step.image}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="stepImageUrl" value="${pageContext.request.contextPath}/${step.image}" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <img src="${stepImageUrl}" class="w-24 h-24 rounded-lg object-cover shadow-md">
                                                <div>
                                                    <p class="text-sm text-slate-500">${status.count}. ${step.type}</p>
                                                    <h4 class="text-lg font-bold">${step.emoji} ${step.name}</h4>
                                                    <p class="text-sm text-slate-600 mt-1">${step.description}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="mt-10 pt-6 border-t flex flex-col items-center gap-3">
                                    <button id="kakao-share-btn" class="w-full max-w-xs bg-yellow-400 text-black font-bold py-3 rounded-full hover:bg-yellow-500">카카오톡으로 공유하기</button>
                                    <button id="copy-url-btn" class="w-full max-w-xs bg-slate-700 text-white font-bold py-3 rounded-full hover:bg-slate-800">URL 복사하기</button>
                                </div>

                                <div id="course-comments" class="mt-12">
                                    <h3 class="text-2xl font-bold mb-4">댓글 <span class="text-slate-500 text-base">(<c:out value="${courseCommentCount}" default="0"/>)</span></h3>

                                    <c:choose>
                                        <c:when test="${not empty courseComments}">
                                            <ul class="space-y-4">
                                                <c:forEach var="comment" items="${courseComments}">
                                                    <c:choose>
                                                        <c:when test="${not empty comment.profileImage && fn:startsWith(comment.profileImage, 'http')}">
                                                            <c:set var="commentProfileImageUrl" value="${comment.profileImage}" />
                                                        </c:when>
                                                        <c:when test="${not empty comment.profileImage}">
                                                            <c:set var="commentProfileImageUrl" value="${pageContext.request.contextPath}/${comment.profileImage}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="commentProfileImageUrl" value="https://placehold.co/48x48/94a3b8/ffffff?text=U" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <li class="bg-white border border-slate-200 rounded-xl p-4 shadow-sm" data-comment-id="${comment.id}">
                                                        <div class="flex gap-3">
                                                            <img src="${commentProfileImageUrl}" alt="${comment.nickname}" class="w-10 h-10 rounded-full object-cover">
                                                            <div class="flex-1">
                                                                <div class="flex items-center gap-2">
                                                                    <span class="font-semibold text-slate-800"><c:out value="${comment.nickname}"/></span>
                                                                    <span class="text-xs text-slate-500"><c:out value="${comment.createdAtFormatted}"/></span>
                                                                </div>
                                                                <p class="mt-2 text-slate-700 whitespace-pre-line comment-content"><c:out value="${comment.content}"/></p>
                                                                <div class="comment-edit-form hidden mt-2">
                                                                    <textarea class="w-full min-h-[80px] border border-slate-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-sky-500 comment-edit-textarea" maxlength="500"><c:out value="${comment.content}"/></textarea>
                                                                    <div class="flex gap-2 mt-2">
                                                                        <button type="button" class="px-3 py-1 bg-sky-600 text-white text-sm rounded hover:bg-sky-700 save-edit-btn" data-comment-id="${comment.id}">저장</button>
                                                                        <button type="button" class="px-3 py-1 bg-slate-400 text-white text-sm rounded hover:bg-slate-500 cancel-edit-btn">취소</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <c:if test="${not empty sessionScope.user && sessionScope.user.id == comment.userId}">
                                                                <div class="flex flex-col gap-1">
                                                                    <button type="button" class="edit-comment-btn text-xs text-slate-400 hover:text-blue-500" data-comment-id="${comment.id}">수정</button>
                                                                    <button type="button" class="delete-comment-btn text-xs text-slate-400 hover:text-red-500" data-comment-id="${comment.id}">삭제</button>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-slate-500 bg-slate-100 rounded-xl p-6 text-center">아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${not empty sessionScope.user}">
                                        <form id="comment-form" class="mt-8 space-y-3">
                                            <textarea id="comment-content" class="w-full min-h-[110px] border border-slate-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-sky-500" maxlength="500" placeholder="댓글을 입력해주세요."></textarea>
                                            <div class="flex justify-end">
                                                <button type="submit" class="px-5 py-2 bg-sky-600 text-white rounded-lg hover:bg-sky-700 transition">댓글 등록</button>
                                            </div>
                                        </form>
                                    </c:if>

                                    <c:if test="${empty sessionScope.user}">
                                        <p class="mt-6 text-sm text-slate-500 text-center">
                                            댓글을 작성하려면 <a href="${pageContext.request.contextPath}/login" class="text-sky-600 font-semibold hover:underline">로그인</a>이 필요합니다.
                                        </p>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="p-8 text-center text-lg font-semibold bg-white rounded-lg shadow">해당 코스를 찾을 수 없습니다.</p>
                    </c:otherwise>
                </c:choose>

            </div>
        </main>

        <!-- 찜하기 폴더 선택 모달 -->
        <div id="wishlist-modal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50 flex items-center justify-center">
            <div class="bg-white rounded-2xl p-6 m-4 max-w-md w-full max-h-[80vh] overflow-y-auto">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-xl font-bold">저장할 폴더 선택</h2>
                    <button id="close-modal" class="text-gray-500 hover:text-gray-700">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>

                <!-- 로딩 상태 -->
                <div id="modal-loading" class="text-center py-8">
                    <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-sky-500 mx-auto"></div>
                    <p class="mt-2 text-gray-600">폴더를 불러오는 중...</p>
                </div>

                <!-- 폴더 목록 -->
                <div id="storage-list" class="hidden space-y-3">
                    <!-- 폴더들이 여기에 동적으로 추가됩니다 -->
                </div>

                <!-- 새 폴더 생성 버튼 -->
                <div id="create-folder-section" class="hidden border-t pt-4 mt-4">
                    <button id="show-create-form" class="w-full py-3 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition flex items-center justify-center gap-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
                        새 폴더 만들기
                    </button>

                    <!-- 새 폴더 생성 폼 -->
                    <div id="create-form" class="hidden mt-4">
                        <input type="text" id="folder-name" placeholder="폴더 이름을 입력하세요"
                               class="w-full p-3 border border-gray-300 rounded-lg mb-3 focus:outline-none focus:ring-2 focus:ring-sky-500">
                        <div class="flex gap-2">
                            <button id="create-folder" class="flex-1 py-2 px-4 bg-sky-500 text-white rounded-lg hover:bg-sky-600 transition">
                                생성
                            </button>
                            <button id="cancel-create" class="flex-1 py-2 px-4 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition">
                                취소
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>


    <script>
        // JSP에서 JavaScript로 안전하게 데이터 전달
        const courseData = {
            id: Number('<c:out value="${course.id}" default="0"/>'),
            title: '<c:out value="${course.title}" escapeXml="true"/>',
            author: '<c:out value="${course.author}" escapeXml="true"/>'
        };
        
        // 로그인 상태 체크
        const isUserLoggedIn = <c:out value="${not empty sessionScope.user}" default="false"/>;
        const rawContextPath = '<c:out value="${pageContext.request.contextPath}"/>';
        const derivedContextPath = (() => {
            const courseIndex = window.location.pathname.indexOf('/course');
            if (courseIndex > 0) {
                return window.location.pathname.substring(0, courseIndex);
            }
            return '';
        })();
        const contextPath = rawContextPath && rawContextPath !== '/' ? rawContextPath : derivedContextPath;
        const buildUrl = (path) => (contextPath ? contextPath + path : path);

        document.addEventListener('DOMContentLoaded', function() {
            const copyBtn = document.getElementById('copy-url-btn');
            const likeBtn = document.getElementById('like-btn');
            const wishlistBtn = document.getElementById('wishlist-btn');
            const showCreateFormBtn = document.getElementById('show-create-form');
            const createForm = document.getElementById('create-form');
            const cancelCreateBtn = document.getElementById('cancel-create');
            const createFolderBtn = document.getElementById('create-folder');
            const folderNameInput = document.getElementById('folder-name');
            const defaultCreateButtonText = createFolderBtn ? createFolderBtn.textContent.trim() : '';
            const commentForm = document.getElementById('comment-form');
            const commentContentInput = document.getElementById('comment-content');
            const deleteCommentButtons = document.querySelectorAll('.delete-comment-btn');
            const editCommentButtons = document.querySelectorAll('.edit-comment-btn');
            const saveEditButtons = document.querySelectorAll('.save-edit-btn');
            const cancelEditButtons = document.querySelectorAll('.cancel-edit-btn');

            // URL 복사 기능
            if (copyBtn) {
                copyBtn.addEventListener('click', (e) => {
                    navigator.clipboard.writeText(window.location.href).then(() => {
                        e.target.textContent = '✅ 복사 완료!';
                        setTimeout(() => {
                            e.target.textContent = 'URL 복사하기';
                        }, 2000);
                    }).catch(err => {
                        alert('URL 복사에 실패했습니다.');
                    });
                });
            }

            if (wishlistBtn) {
                const datasetCourseId = parseInt(wishlistBtn.dataset.courseId || '0', 10);
                if (!Number.isNaN(datasetCourseId) && datasetCourseId > 0) {
                    courseData.id = datasetCourseId;
                }
            }

            if (!Number.isInteger(courseData.id) || courseData.id <= 0) {
                console.error('코스 ID를 확인할 수 없습니다.', courseData.id);
            }

            // 좋아요 기능
            if (likeBtn) {
                likeBtn.addEventListener('click', async function() {
                    const courseId = courseData.id;

                    if (!Number.isInteger(courseId) || courseId <= 0) {
                        alert('코스 정보를 불러오지 못했습니다. 페이지를 새로고침 해주세요.');
                        return;
                    }
                    if (!isUserLoggedIn) {
                        alert('로그인이 필요합니다.');
                        const redirectPath = '/login?redirectURL=' + encodeURIComponent('/course/detail?id=' + courseId);
                        window.location.href = buildUrl(redirectPath);
                        return;
                    }
                    
                    try {
                        const params = new URLSearchParams();
                        params.append('courseId', courseId);

                        const response = await fetch(buildUrl('/course/like'), {
                            method: 'POST',
                            credentials: 'same-origin',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: params.toString()
                        });
                        
                        const result = await parseJsonResponse(response);
                        const data = result.data;
                        
                        if (data.success) {
                            const svg = this.querySelector('svg');
                            const countSpan = document.getElementById('like-count');
                            
                            if (data.isLiked) {
                                this.classList.remove('text-slate-600');
                                this.classList.add('text-red-500');
                                svg.setAttribute('fill', 'currentColor');
                            } else {
                                this.classList.remove('text-red-500');
                                this.classList.add('text-slate-600');
                                svg.setAttribute('fill', 'none');
                            }
                            
                            countSpan.textContent = data.likeCount;
                        } else {
                            if (response.status === 401) {
                                alert('로그인이 필요합니다.');
                                const redirectPath = '/login?redirectURL=' + encodeURIComponent('/course/detail?id=' + courseId);
                                window.location.href = buildUrl(redirectPath);
                            } else {
                                alert(data.message || '오류가 발생했습니다.');
                            }
                        }
                    } catch (error) {
                        console.error('좋아요 요청 실패:', error);
                        alert(error.message || '요청 처리 중 오류가 발생했습니다.');
                    }
                });
            }

            // 카카오톡 공유 기능
            const kakaoShareBtn = document.getElementById('kakao-share-btn');
            if (kakaoShareBtn) {
                kakaoShareBtn.addEventListener('click', function() {
                    const url = window.location.href;
                    const title = courseData.title;
                    const author = courseData.author;
                    const description = author + "님의 맛집 코스를 확인해보세요!";
                    
                    // 카카오톡 공유 URL 생성
                    const kakaoUrl = 'https://sharer.kakao.com/talk/friends/?url=' + encodeURIComponent(url) + 
                                   '&title=' + encodeURIComponent(title) + 
                                   '&description=' + encodeURIComponent(description);
                    
                    // 새 창으로 카카오톡 공유 페이지 열기
                    window.open(kakaoUrl, 'kakao-share', 'width=500,height=600');
                });
            }

            // 코스 찜 기능 - 모달 버전
            if (wishlistBtn) {
                wishlistBtn.addEventListener('click', function() {
                    // 로그인 체크
                    if (!isUserLoggedIn) {
                        alert('로그인이 필요합니다.');
                        const redirectPath = '/login?redirectURL=' + encodeURIComponent('/course/detail?id=' + courseData.id);
                        window.location.href = buildUrl(redirectPath);
                        return;
                    }

                    const isCurrentlyWishlisted = this.classList.contains('bg-red-500');

                    if (isCurrentlyWishlisted) {
                        // 이미 찜한 상태면 찜 해제
                        removeFromWishlist();
                    } else {
                        // 찜하지 않은 상태면 모달 띄워서 폴더 선택
                        openWishlistModal();
                    }
                });
            }

            // 찜하기 모달 관련 함수들
            function openWishlistModal() {
                const modal = document.getElementById('wishlist-modal');
                const loading = document.getElementById('modal-loading');
                const storageList = document.getElementById('storage-list');
                const createSection = document.getElementById('create-folder-section');

                // 모달 보이기
                modal.classList.remove('hidden');

                // 로딩 상태 보이기
                loading.classList.remove('hidden');
                storageList.classList.add('hidden');
                createSection.classList.add('hidden');
                resetCreateForm();

                // 사용자의 저장소 목록 가져오기
                loadUserStorages();
            }

            async function loadUserStorages(highlightStorageId) {
                try {
                    const response = await fetch(buildUrl('/course/storages'), {
                        credentials: 'same-origin',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    });

                    const result = await parseJsonResponse(response);
                    const data = result.data;

                    if (data.success) {
                        displayStorages(data.storages, highlightStorageId);
                    } else {
                        alert(data.message || '저장소 목록을 불러오는데 실패했습니다.');
                        closeModal();
                    }
                } catch (error) {
                    console.error('저장소 목록 조회 실패:', error);
                    alert('네트워크 오류가 발생했습니다.');
                    closeModal();
                }
            }

            function displayStorages(storages, highlightStorageId) {
                const loading = document.getElementById('modal-loading');
                const storageList = document.getElementById('storage-list');
                const createSection = document.getElementById('create-folder-section');

                // 로딩 숨기고 리스트 보이기
                loading.classList.add('hidden');
                storageList.classList.remove('hidden');
                createSection.classList.remove('hidden');

                // 저장소 리스트 초기화
                storageList.innerHTML = '';

                if (!storages || storages.length === 0) {
                    storageList.innerHTML = '<p class="text-center text-sm text-gray-500">폴더가 없습니다. 새 폴더를 만들어보세요.</p>';
                    return;
                }

                // 각 저장소를 버튼으로 추가
                storages.forEach(storage => {
                    const storageBtn = document.createElement('button');
                    const colorClass = storage.colorClass || 'bg-blue-100';
                    const itemCount = storage.itemCount != null ? storage.itemCount : 0;
                    storageBtn.className = 'w-full p-4 text-left rounded-lg border-2 border-gray-200 hover:border-sky-300 hover:bg-sky-50 transition';
                    storageBtn.innerHTML = ''
                        + '<div class="flex items-center gap-3">'
                        + '<div class="w-4 h-4 rounded ' + colorClass + '"></div>'
                        + '<span class="font-medium text-slate-700">' + storage.name + '</span>'
                        + '<span class="ml-auto text-xs text-slate-500">' + itemCount + '개</span>'
                        + '</div>';
                    storageBtn.dataset.storageId = storage.id;

                    storageBtn.addEventListener('click', () => {
                        addToStorage(storage.id, storage.name);
                    });

                    if (highlightStorageId && storage.id === highlightStorageId) {
                        storageBtn.classList.add('border-sky-500', 'ring-2', 'ring-sky-200');
                    }

                    storageList.appendChild(storageBtn);
                });
            }

            function resetCreateForm() {
                if (createForm && showCreateFormBtn) {
                    createForm.classList.add('hidden');
                    showCreateFormBtn.classList.remove('hidden');
                }
                if (folderNameInput) {
                    folderNameInput.value = '';
                }
                if (createFolderBtn) {
                    createFolderBtn.disabled = false;
                    createFolderBtn.textContent = defaultCreateButtonText || '생성';
                }
            }

            if (showCreateFormBtn) {
                showCreateFormBtn.addEventListener('click', () => {
                    showCreateFormBtn.classList.add('hidden');
                    if (createForm) {
                        createForm.classList.remove('hidden');
                    }
                    if (folderNameInput) {
                        folderNameInput.focus();
                    }
                });
            }

            if (cancelCreateBtn) {
                cancelCreateBtn.addEventListener('click', (event) => {
                    event.preventDefault();
                    resetCreateForm();
                });
            }

            if (createFolderBtn) {
                createFolderBtn.addEventListener('click', async (event) => {
                    event.preventDefault();

                    if (!folderNameInput) {
                        return;
                    }

                    const folderName = folderNameInput.value.trim();
                    if (!folderName) {
                        alert('폴더 이름을 입력해주세요.');
                        folderNameInput.focus();
                        return;
                    }

                    try {
                        createFolderBtn.disabled = true;
                        createFolderBtn.textContent = '생성 중...';

                        const params = new URLSearchParams();
                        params.append('name', folderName);
                        params.append('colorClass', 'bg-blue-100');

                        const response = await fetch(buildUrl('/course/storages'), {
                            method: 'POST',
                            credentials: 'same-origin',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: params.toString()
                        });

                        const result = await parseJsonResponse(response);
                        const data = result.data;

                        if (data.success && data.storage) {
                            resetCreateForm();
                            showMessage('"' + data.storage.name + '" 폴더가 생성되었습니다.');
                            await loadUserStorages(data.storage.id);
                        } else {
                            alert((data && data.message) || '폴더 생성에 실패했습니다.');
                        }
                    } catch (error) {
                        console.error('폴더 생성 실패:', error);
                        alert('폴더 생성 중 오류가 발생했습니다.');
                    } finally {
                        if (createFolderBtn) {
                            createFolderBtn.disabled = false;
                            createFolderBtn.textContent = defaultCreateButtonText || '생성';
                        }
                    }
                });
            }

            if (commentForm && commentContentInput) {
                commentForm.addEventListener('submit', async (event) => {
                    event.preventDefault();

                    const content = commentContentInput.value.trim();
                    if (!content) {
                        alert('댓글 내용을 입력해주세요.');
                        commentContentInput.focus();
                        return;
                    }

                    try {
                        const params = new URLSearchParams();
                        params.append('courseId', courseData.id);
                        params.append('content', content);

                        const response = await fetch(buildUrl('/course/comment'), {
                            method: 'POST',
                            credentials: 'same-origin',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: params.toString()
                        });

                        const result = await parseJsonResponse(response);
                        const data = result.data;

                        if (data.success) {
                            commentForm.reset();
                            showMessage(data.message || '댓글이 등록되었습니다.');
                            window.location.reload();
                        } else {
                            alert(data.message || '댓글 등록에 실패했습니다.');
                        }
                    } catch (error) {
                        console.error('댓글 등록 실패:', error);
                        alert(error.message || '댓글 등록 중 오류가 발생했습니다.');
                    }
                });
            }

            if (deleteCommentButtons) {
                deleteCommentButtons.forEach(button => {
                    button.addEventListener('click', async () => {
                        const commentId = button.getAttribute('data-comment-id');
                        if (!commentId) {
                            return;
                        }

                        if (!confirm('댓글을 삭제하시겠습니까?')) {
                            return;
                        }

                        try {
                            const params = new URLSearchParams();
                            params.append('commentId', commentId);

                            const response = await fetch(buildUrl('/course/comment/delete'), {
                                method: 'POST',
                                credentials: 'same-origin',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                    'X-Requested-With': 'XMLHttpRequest'
                                },
                                body: params.toString()
                            });

                            const result = await parseJsonResponse(response);
                            const data = result.data;

                            if (data.success) {
                                showMessage(data.message || '댓글이 삭제되었습니다.');
                                window.location.reload();
                            } else {
                                alert(data.message || '댓글 삭제에 실패했습니다.');
                            }
                        } catch (error) {
                            console.error('댓글 삭제 실패:', error);
                            alert(error.message || '댓글 삭제 중 오류가 발생했습니다.');
                        }
                    });
                });
            }

            // 댓글 수정 기능
            if (editCommentButtons) {
                editCommentButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        const commentItem = button.closest('li');
                        const commentContent = commentItem.querySelector('.comment-content');
                        const editForm = commentItem.querySelector('.comment-edit-form');

                        // 댓글 내용 숨기고 수정 폼 보이기
                        commentContent.classList.add('hidden');
                        editForm.classList.remove('hidden');

                        // 수정 버튼 숨기기
                        button.style.display = 'none';
                    });
                });
            }

            if (cancelEditButtons) {
                cancelEditButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        const commentItem = button.closest('li');
                        const commentContent = commentItem.querySelector('.comment-content');
                        const editForm = commentItem.querySelector('.comment-edit-form');
                        const editButton = commentItem.querySelector('.edit-comment-btn');

                        // 수정 폼 숨기고 댓글 내용 보이기
                        editForm.classList.add('hidden');
                        commentContent.classList.remove('hidden');

                        // 수정 버튼 다시 보이기
                        editButton.style.display = 'block';
                    });
                });
            }

            if (saveEditButtons) {
                saveEditButtons.forEach(button => {
                    button.addEventListener('click', async () => {
                        const commentId = button.getAttribute('data-comment-id');
                        const commentItem = button.closest('li');
                        const textarea = commentItem.querySelector('.comment-edit-textarea');
                        const newContent = textarea.value.trim();

                        if (!newContent) {
                            alert('댓글 내용을 입력해주세요.');
                            textarea.focus();
                            return;
                        }

                        try {
                            const params = new URLSearchParams();
                            params.append('commentId', commentId);
                            params.append('content', newContent);

                            const response = await fetch(buildUrl('/course/comment/update'), {
                                method: 'POST',
                                credentials: 'same-origin',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                    'X-Requested-With': 'XMLHttpRequest'
                                },
                                body: params.toString()
                            });

                            const result = await parseJsonResponse(response);
                            const data = result.data;

                            if (data.success) {
                                showMessage(data.message || '댓글이 수정되었습니다.');
                                window.location.reload();
                            } else {
                                alert(data.message || '댓글 수정에 실패했습니다.');
                            }
                        } catch (error) {
                            console.error('댓글 수정 실패:', error);
                            alert(error.message || '댓글 수정 중 오류가 발생했습니다.');
                        }
                    });
                });
            }

            async function addToStorage(storageId, storageName) {
                const courseId = courseData.id;

                if (!Number.isInteger(courseId) || courseId <= 0) {
                    alert('코스 정보를 불러오지 못했습니다. 페이지를 새로고침 해주세요.');
                    return;
                }

                try {
                    const params = new URLSearchParams();
                    params.append('courseId', courseId);
                    params.append('action', 'add');
                    if (storageId) {
                        params.append('storageId', storageId);
                    }

                    const response = await fetch(buildUrl('/course/wishlist'), {
                        method: 'POST',
                        credentials: 'same-origin',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: params.toString()
                    });

                    const result = await parseJsonResponse(response);
                    const data = result.data;

                    if (data.success) {
                        // 모달 닫기
                        closeModal();

                        // 찜하기 버튼 상태 업데이트
                        updateWishlistButton(true);

                        // 성공 메시지
                        showMessage('"' + storageName + '" 폴더에 저장되었습니다.');
                    } else {
                        alert(data.message || '저장에 실패했습니다.');
                    }
                } catch (error) {
                    console.error('저장 실패:', error);
                    alert(error.message || '요청 처리 중 오류가 발생했습니다.');
                }
            }

            async function removeFromWishlist() {
                const courseId = courseData.id;

                if (!Number.isInteger(courseId) || courseId <= 0) {
                    alert('코스 정보를 불러오지 못했습니다. 페이지를 새로고침 해주세요.');
                    return;
                }

                try {
                    const params = new URLSearchParams();
                    params.append('courseId', courseId);
                    params.append('action', 'remove');

                    const response = await fetch(buildUrl('/course/wishlist'), {
                        method: 'POST',
                        credentials: 'same-origin',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: params.toString()
                    });

                    const result = await parseJsonResponse(response);
                    const data = result.data;

                    if (data.success) {
                        updateWishlistButton(false);
                        showMessage('찜 목록에서 제거되었습니다.');
                    } else {
                        alert(data.message || '제거에 실패했습니다.');
                    }
                } catch (error) {
                    console.error('찜 제거 실패:', error);
                    alert(error.message || '요청 처리 중 오류가 발생했습니다.');
                }
            }

            function updateWishlistButton(isWishlisted) {
                const svg = wishlistBtn.querySelector('svg');
                const textSpan = document.getElementById('wishlist-text');

                if (isWishlisted) {
                    wishlistBtn.classList.remove('bg-gray-200', 'text-gray-700', 'hover:bg-gray-300');
                    wishlistBtn.classList.add('bg-red-500', 'text-white', 'hover:bg-red-600');
                    svg.setAttribute('fill', 'currentColor');
                    textSpan.textContent = '찜 완료';
                } else {
                    wishlistBtn.classList.remove('bg-red-500', 'text-white', 'hover:bg-red-600');
                    wishlistBtn.classList.add('bg-gray-200', 'text-gray-700', 'hover:bg-gray-300');
                    svg.setAttribute('fill', 'none');
                    textSpan.textContent = '찜하기';
                }
            }

            function showMessage(message) {
                // 간단한 토스트 메시지 표시
                const toast = document.createElement('div');
                toast.className = 'fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50';
                toast.textContent = message;
                document.body.appendChild(toast);

                setTimeout(() => {
                    toast.remove();
                }, 3000);
            }

            function closeModal() {
                const modal = document.getElementById('wishlist-modal');
                modal.classList.add('hidden');
                resetCreateForm();
            }

            // 모달 닫기 이벤트
            document.getElementById('close-modal').addEventListener('click', closeModal);

            // 모달 외부 클릭 시 닫기
            document.getElementById('wishlist-modal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeModal();
                }
            });

        });

        async function parseJsonResponse(response) {
            const contentType = response.headers.get('content-type') || '';
            const text = await response.text();

            let data = null;
            if (contentType.includes('application/json')) {
                try {
                    data = JSON.parse(text);
                } catch (err) {
                    throw new Error('응답을 파싱할 수 없습니다.');
                }
            }

            if (!data) {
                throw new Error(text || '알 수 없는 응답이 반환되었습니다.');
            }

            return { data, raw: text, status: response.status };
        }
    </script>
</body>
</html>
