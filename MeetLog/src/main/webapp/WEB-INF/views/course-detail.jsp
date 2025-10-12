<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MEET LOG - ${course.title}</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
<style type="text/tailwindcss">
        .chip { @apply inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-semibold text-slate-600; }
        .chip-on-dark { @apply inline-flex items-center gap-2 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold text-white/80; }
        .section-title { @apply text-xl font-bold text-slate-900 md:text-2xl; }
        .section-sub { @apply mt-2 text-sm text-slate-500 md:text-base; }
        .stat-card { @apply rounded-2xl border border-slate-200 bg-white p-5 shadow-sm; }
        .meta-label { @apply text-xs font-semibold uppercase tracking-widest text-slate-500; }
        .meta-value { @apply mt-1 text-base font-semibold text-slate-900; }
        .comment-bubble { @apply rounded-2xl border border-slate-200 bg-white/60 p-5 shadow-sm transition hover:border-sky-200; }
    </style>
</head>
<body class="bg-slate-50">

	<div id="app" class="flex flex-col min-h-screen">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />

		<main id="main-content" class="flex-grow bg-slate-50">
			<div class="mx-auto w-full max-w-6xl px-4 py-10 md:px-6 md:py-14">

				<c:choose>
					<c:when test="${not empty course}">
						<c:set var="heroImage" value="${course.previewImage}" />
						<c:if test="${empty heroImage and not empty steps}">
							<c:set var="heroImage" value="${steps[0].image}" />
						</c:if>
						<c:set var="authorImageUrl" value="" />
						<c:if test="${not empty course.author}">
							<c:choose>
								<c:when
									test="${not empty course.profileImage && fn:startsWith(course.profileImage, 'http')}">
									<c:set var="authorImageUrl" value="${course.profileImage}" />
								</c:when>
								<c:when test="${not empty course.profileImage}">
									<c:set var="authorImageUrl"
										value="${pageContext.request.contextPath}/${course.profileImage}" />
								</c:when>
							</c:choose>
						</c:if>
						<c:set var="stepCount" value="${fn:length(steps)}" />
						<c:set var="commentCount" value="${courseCommentCount}" />

						<div id="course-detail-container" class="space-y-12">
							<section class="overflow-hidden rounded-3xl bg-white shadow-xl">
								<div class="relative h-72 md:h-80">
									<c:choose>
										<c:when test="${not empty heroImage}">
											<mytag:image fileName="${heroImage}"
												altText="${course.title}"
												cssClass="absolute inset-0 h-full w-full object-cover" />
										</c:when>
										<c:otherwise>
											<div
												class="absolute inset-0 bg-gradient-to-br from-sky-300 via-slate-500 to-slate-800"></div>
										</c:otherwise>
									</c:choose>
									<div
										class="absolute inset-0 bg-gradient-to-br from-slate-950/80 via-slate-900/30 to-slate-900/10"></div>
									<div
										class="relative z-10 flex h-full flex-col justify-between gap-6 p-8 md:p-10">
										<div class="flex flex-wrap gap-2">
											<c:forEach var="tag" items="${course.tags}">
												<span class="chip-on-dark">${tag}</span>
											</c:forEach>
										</div>
										<div class="max-w-3xl space-y-4 text-white">
											<h1 class="text-3xl font-extrabold leading-tight md:text-4xl">${course.title}</h1>
											<c:if test="${not empty course.author}">
												<div
													class="flex flex-wrap items-center gap-3 text-sm text-white/80">
													<c:choose>
														<c:when test="${not empty authorImageUrl}">
															<img src="${authorImageUrl}" alt="${course.author}"
																class="h-10 w-10 rounded-full border-2 border-white/40 object-cover" />
														</c:when>
														<c:otherwise>
															<div
																class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-white/40 bg-white/20 text-sm font-semibold text-white/80">
																<c:out value="${fn:substring(course.author,0,1)}" />
															</div>
														</c:otherwise>
													</c:choose>
													<div>
														<a
															href="${pageContext.request.contextPath}/feed/user/${course.userId}"
															class="font-semibold text-white hover:text-sky-200 transition-colors">${course.author}</a>
														<p class="text-xs uppercase tracking-wide text-white/60">코스
															작성자</p>
													</div>
												</div>
											</c:if>
										</div>
									</div>
								</div>
								<div
									class="flex flex-wrap items-center gap-3 border-t border-slate-100 bg-white/95 px-6 py-5 md:px-8">
									<button id="copy-url-btn"
										class="flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:border-sky-400 hover:text-sky-600">
										<svg class="h-4 w-4" fill="none" stroke="currentColor"
											stroke-width="1.5" viewBox="0 0 24 24">
                                            <path stroke-linecap="round"
												stroke-linejoin="round"
												d="M8 17l-3 3m0 0l3 3m-3-3h12a4 4 0 004-4V5a2 2 0 00-2-2h-7m-5 14a4 4 0 01-4-4V4a2 2 0 012-2h7" />
                                        </svg>
										URL 복사하기
									</button>
									<button type="button" id="like-btn"
										class="flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold transition <c:choose><c:when test='${isLiked}'>text-red-500</c:when><c:otherwise>text-slate-600 hover:text-red-500</c:otherwise></c:choose>"
										data-course-id="<c:out value='${course.id}'/>">
										<svg class="h-4 w-4"
											fill="<c:choose><c:when test='${isLiked}'>currentColor</c:when><c:otherwise>none</c:otherwise></c:choose>"
											stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round"
												stroke-width="2"
												d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
										<span id="like-count"><c:out value="${course.likes}" /></span>
									</button>
									<button type="button" id="wishlist-btn"
										class="flex items-center gap-2 font-semibold rounded-full px-4 py-2 text-sm transition <c:choose><c:when test='${isWishlisted}'>bg-red-500 text-white hover:bg-red-600</c:when><c:otherwise>bg-gray-200 text-gray-700 hover:bg-gray-300</c:otherwise></c:choose>"
										data-course-id="<c:out value='${course.id}'/>">
										<svg class="h-4 w-4"
											fill="<c:choose><c:when test='${isWishlisted}'>currentColor</c:when><c:otherwise>none</c:otherwise></c:choose>"
											stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round"
												stroke-linejoin="round" stroke-width="2"
												d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
                                        </svg>
										<span id="wishlist-text"><c:choose>
												<c:when test='${isWishlisted}'>찜 완료</c:when>
												<c:otherwise>찜하기</c:otherwise>
											</c:choose></span>
									</button>
								</div>
							</section>

							<div
								class="grid gap-10 lg:grid-cols-[minmax(0,2.5fr)_minmax(0,1fr)]">
								<div class="space-y-10">
									<c:if test="${not empty course.description}">
										<section class="subtle-card space-y-3">
											<h2 class="section-title">코스 소개</h2>
											<p class="text-sm leading-relaxed text-slate-600">
												<c:out value="${course.description}" />
											</p>
										</section>
									</c:if>

									<div class="grid gap-4 sm:grid-cols-3">
										<div class="stat-card">
											<p class="meta-label">총 스탑</p>
											<p class="meta-value">
												<c:out value="${stepCount}" />
												곳
											</p>
											<p class="mt-2 text-xs text-slate-500">코스에 포함된 장소 수</p>
										</div>
										<div class="stat-card">
											<p class="meta-label">좋아요</p>
											<p class="meta-value">
												<c:out value="${course.likes}" />
											</p>
											<p class="mt-2 text-xs text-slate-500">마음에 든 사용자 수</p>
										</div>
										<div class="stat-card">
											<p class="meta-label">댓글</p>
											<p class="meta-value">
												<c:out value="${commentCount}" default="0" />
											</p>
											<p class="mt-2 text-xs text-slate-500">후기를 남겨보세요</p>
										</div>
									</div>

									<section class="subtle-card space-y-6">
										<div>
											<h2 class="section-title">코스 상세 경로</h2>
											<p class="section-sub">순서대로 방문하면 더 즐거운 하루가 됩니다.</p>
										</div>
										<c:choose>
											<c:when test="${stepCount > 0}">
												<div class="space-y-6">
													<c:forEach var="step" items="${steps}" varStatus="status">
														<div
															class="relative flex flex-col gap-4 rounded-2xl border border-slate-200 bg-white/80 p-5 shadow-sm md:flex-row md:items-center md:gap-6">
															<div class="flex items-center gap-3 md:w-48">
																<div
																	class="flex h-12 w-12 items-center justify-center rounded-full bg-sky-500 text-base font-bold text-white shadow-md">${status.count}</div>
																<div class="hidden text-2xl md:block">${empty step.emoji ? '📍' : step.emoji}</div>
															</div>
															<div
																class="flex flex-1 flex-col gap-4 md:flex-row md:items-start md:gap-6">
																<c:if test="${not empty step.image}">
																	<mytag:image fileName="${step.image}"
																		altText="${step.name}"
																		cssClass="h-28 w-full rounded-xl object-cover shadow-sm md:h-24 md:w-32" />
																</c:if>
																<div class="flex-1 space-y-2">
																	<p class="meta-label">${status.count}.
																		<c:out value="${step.type}" default="STEP" />
																	</p>
																	<h3 class="text-lg font-semibold text-slate-900">${empty step.emoji ? '' : step.emoji}
																		<c:out value="${step.name}" />
																	</h3>
																	<p class="text-sm leading-relaxed text-slate-600">
																		<c:out value="${step.description}" />
																	</p>
																	<div
																		class="flex flex-wrap gap-3 text-xs text-slate-500">
																		<c:if test="${not empty step.address}">
																			<span
																				class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
																				<svg class="h-3.5 w-3.5" fill="none"
																					stroke="currentColor" stroke-width="1.5"
																					viewBox="0 0 24 24">
																					<path stroke-linecap="round"
																						stroke-linejoin="round"
																						d="M12 21c4.418 0 8-3.582 8-8s-3.582-8-8-8-8 3.582-8 8 3.582 8 8 8z" />
																					<path stroke-linecap="round"
																						stroke-linejoin="round"
																						d="M12 12a1.5 1.5 0 100-3 1.5 1.5 0 000 3z" /></svg> <c:out
																					value="${step.address}" />
																			</span>
																		</c:if>
																		<c:if test="${not empty step.time}">
																			<span
																				class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
																				<svg class="h-3.5 w-3.5" fill="none"
																					stroke="currentColor" stroke-width="1.5"
																					viewBox="0 0 24 24">
																					<path stroke-linecap="round"
																						stroke-linejoin="round"
																						d="M12 6v6l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
																				<c:out value="${step.time}" />
																			</span>
																		</c:if>
																		<c:if test="${not empty step.cost}">
																			<span
																				class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
																				<svg class="h-3.5 w-3.5" fill="none"
																					stroke="currentColor" stroke-width="1.5"
																					viewBox="0 0 24 24">
																					<path stroke-linecap="round"
																						stroke-linejoin="round"
																						d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8v10" /></svg>
																				<c:out value="${step.cost}" />
																			</span>
																		</c:if>
																	</div>
																</div>
															</div>
														</div>
													</c:forEach>
												</div>
											</c:when>
											<c:otherwise>
												<p
													class="rounded-2xl bg-slate-50 p-6 text-center text-sm text-slate-500">등록된
													코스 단계가 없습니다.</p>
											</c:otherwise>
										</c:choose>
									</section>

									<section class="subtle-card space-y-6" id="comment-section">
										<div class="flex items-center justify-between">
											<div>
												<h2 class="section-title">댓글</h2>
												<p class="section-sub">다른 사람들과 코스 후기를 나눠보세요.</p>
											</div>
											<span
												class="rounded-full bg-slate-100 px-4 py-1 text-sm font-semibold text-slate-500"><c:out
													value="${courseCommentCount}" default="0" />개</span>
										</div>

										<c:choose>
											<c:when test="${not empty courseComments}">
												<ul id="comment-list" class="space-y-4">
													<c:forEach var="comment" items="${courseComments}">
														<li class="comment-item comment-bubble"
															data-comment-id="${comment.id}">
															<div class="flex items-start gap-3">
																<mytag:image fileName="${comment.profileImage}"
																	altText="${comment.nickname}"
																	cssClass="h-10 w-10 rounded-full object-cover" />
																<div class="flex-1 space-y-2">
																	<div class="flex items-start justify-between">
																		<div>
																			<p class="font-semibold text-slate-900">${comment.nickname}</p>
																			<p class="text-xs text-slate-400">${comment.createdAtFormatted}</p>
																		</div>
																		<div class="flex gap-2 text-xs text-slate-400">
																			<c:if
																				test="${not empty sessionScope.user && sessionScope.user.id == comment.userId}">
																				<button type="button"
																					class="edit-comment-btn hover:text-sky-600"
																					data-comment-id="${comment.id}">수정</button>
																				<button type="button"
																					class="delete-comment-btn hover:text-red-500"
																					data-comment-id="${comment.id}">삭제</button>
																			</c:if>
																		</div>
																	</div>
																	<p
																		class="comment-content text-sm leading-relaxed text-slate-700">${comment.content}</p>
																	<div class="comment-edit-form hidden space-y-3">
																		<textarea
																			class="comment-edit-textarea w-full min-h-[80px] rounded-lg border border-slate-300 p-3 focus:outline-none focus:ring-2 focus:ring-sky-500"
																			maxlength="500"><c:out
																				value="${comment.content}" /></textarea>
																		<div class="flex gap-2">
																			<button type="button"
																				class="save-edit-btn rounded-lg bg-sky-600 px-3 py-1 text-sm text-white hover:bg-sky-700"
																				data-comment-id="${comment.id}">저장</button>
																			<button type="button"
																				class="cancel-edit-btn rounded-lg bg-slate-300 px-3 py-1 text-sm text-slate-700 hover:bg-slate-400">취소</button>
																		</div>
																	</div>
																</div>
															</div>
														</li>
													</c:forEach>
												</ul>
											</c:when>
											<c:otherwise>
												<p
													class="rounded-2xl bg-slate-50 p-6 text-center text-sm text-slate-500">아직
													댓글이 없습니다. 첫 댓글을 남겨보세요!</p>
											</c:otherwise>
										</c:choose>

										<c:if test="${not empty sessionScope.user}">
											<form id="comment-form" class="space-y-3">
												<textarea id="comment-content"
													class="w-full min-h-[120px] rounded-xl border border-slate-300 bg-white p-3 text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
													maxlength="500" placeholder="댓글을 입력해주세요."></textarea>
												<div class="flex justify-end">
													<button type="submit"
														class="rounded-lg bg-sky-600 px-5 py-2 text-sm font-semibold text-white transition hover:bg-sky-700">댓글
														등록</button>
												</div>
											</form>
										</c:if>

										<c:if test="${empty sessionScope.user}">
											<p class="text-center text-sm text-slate-500">
												댓글을 작성하려면 <a href="${pageContext.request.contextPath}/login"
													class="font-semibold text-sky-600 hover:underline">로그인</a>이
												필요합니다.
											</p>
										</c:if>
									</section>
								</div>

								<aside class="space-y-6">
									<div class="stat-card space-y-4">
										<h3 class="text-lg font-semibold text-slate-900">코스 한눈에
											보기</h3>
										<ul class="space-y-3 text-sm text-slate-600">
											<li class="flex items-center justify-between"><span
												class="text-slate-500">총 스탑</span> <span
												class="font-semibold text-slate-900"><c:out
														value="${stepCount}" />곳</span></li>
											<li class="flex items-center justify-between"><span
												class="text-slate-500">좋아요</span> <span
												class="font-semibold text-slate-900"><c:out
														value="${course.likes}" /></span></li>
											<li class="flex items-center justify-between"><span
												class="text-slate-500">댓글</span> <span
												class="font-semibold text-slate-900"><c:out
														value="${commentCount}" default="0" /></span></li>
										</ul>
										<c:if test="${not empty course.tags}">
											<div class="mt-4 space-y-2">
												<p class="meta-label">태그</p>
												<div class="flex flex-wrap gap-2">
													<c:forEach var="tag" items="${course.tags}">
														<span class="chip">${tag}</span>
													</c:forEach>
												</div>
											</div>
										</c:if>
										<c:if test="${empty course.tags}">
											<p class="text-xs text-slate-400">등록된 태그가 없습니다.</p>
										</c:if>
									</div>

									<c:if test="${not empty course.author}">
										<div class="stat-card space-y-4">
											<h3 class="text-lg font-semibold text-slate-900">작성자 정보</h3>
											<div class="flex items-center gap-3">
												<c:choose>
													<c:when test="${not empty authorImageUrl}">
														<img src="${authorImageUrl}" alt="${course.author}"
															class="h-12 w-12 rounded-full object-cover" />
													</c:when>
													<c:otherwise>
														<div
															class="flex h-12 w-12 items-center justify-center rounded-full bg-slate-100 text-base font-semibold text-slate-600">
															<c:out value="${fn:substring(course.author,0,1)}" />
														</div>
													</c:otherwise>
												</c:choose>
												<div>
													<p class="font-semibold text-slate-900">
														<c:out value="${course.author}" />
													</p>
													<a
														href="${pageContext.request.contextPath}/feed/user/${course.userId}"
														class="text-xs text-slate-500 hover:text-sky-600">프로필
														살펴보기 →</a>
												</div>
											</div>
											<p class="text-xs text-slate-500">작성자를 팔로우하면 새로운 코스와 리뷰를
												빠르게 받아볼 수 있어요.</p>
										</div>
									</c:if>
								</aside>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<p
							class="rounded-2xl bg-white p-8 text-center text-lg font-semibold shadow">해당
							코스를 찾을 수 없습니다.</p>
					</c:otherwise>
				</c:choose>

			</div>
		</main>


		<!-- 찜하기 폴더 선택 모달 -->
		<div id="wishlist-modal"
			class="fixed inset-0 bg-black bg-opacity-50 hidden z-50 flex items-center justify-center">
			<div
				class="bg-white rounded-2xl p-6 m-4 max-w-md w-full max-h-[80vh] overflow-y-auto">
				<div class="flex justify-between items-center mb-6">
					<h2 class="text-xl font-bold">저장할 폴더 선택</h2>
					<button id="close-modal" class="text-gray-500 hover:text-gray-700">
						<svg class="w-6 h-6" fill="none" stroke="currentColor"
							viewBox="0 0 24 24">
                            <path stroke-linecap="round"
								stroke-linejoin="round" stroke-width="2"
								d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
					</button>
				</div>

				<!-- 로딩 상태 -->
				<div id="modal-loading" class="text-center py-8">
					<div
						class="animate-spin rounded-full h-8 w-8 border-b-2 border-sky-500 mx-auto"></div>
					<p class="mt-2 text-gray-600">폴더를 불러오는 중...</p>
				</div>

				<!-- 폴더 목록 -->
				<div id="storage-list" class="hidden space-y-3">
					<!-- 폴더들이 여기에 동적으로 추가됩니다 -->
				</div>

				<!-- 새 폴더 생성 버튼 -->
				<div id="create-folder-section" class="hidden border-t pt-4 mt-4">
					<button id="show-create-form"
						class="w-full py-3 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition flex items-center justify-center gap-2">
						<svg class="w-4 h-4" fill="none" stroke="currentColor"
							viewBox="0 0 24 24">
                            <path stroke-linecap="round"
								stroke-linejoin="round" stroke-width="2"
								d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
						새 폴더 만들기
					</button>

					<!-- 새 폴더 생성 폼 -->
					<div id="create-form" class="hidden mt-4">
						<input type="text" id="folder-name" placeholder="폴더 이름을 입력하세요"
							class="w-full p-3 border border-gray-300 rounded-lg mb-3 focus:outline-none focus:ring-2 focus:ring-sky-500">
						<div class="flex gap-2">
							<button id="create-folder"
								class="flex-1 py-2 px-4 bg-sky-500 text-white rounded-lg hover:bg-sky-600 transition">
								생성</button>
							<button id="cancel-create"
								class="flex-1 py-2 px-4 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition">
								취소</button>
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

	<%-- ▼▼▼ [추가] 카카오 공유 플로팅 버튼, 모달, 스크립트 ▼▼▼ --%>
	<%-- ▼▼▼ [수정] 플로팅 버튼 아이콘을 img 태그로 변경 ▼▼▼ --%>
	<%-- ▼▼▼ [수정] 플로팅 버튼 디자인 변경 (블랙 테마) ▼▼▼ --%>
	<div id="kakao-share-fab"
		class="group fixed bottom-8 right-8 z-40 cursor-pointer">
		<div
			class="absolute bottom-full right-0 mb-3 w-64 rounded-lg bg-slate-800 text-white text-sm text-center py-3 px-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none">
			친구와 간편하게 약속을 잡아보세요!
			<div
				class="absolute bottom-[-4px] right-6 w-2 h-2 bg-slate-800 rotate-45"></div>
		</div>
		<button
			class="w-16 h-16 bg-gray-800 text-white rounded-full flex items-center justify-center shadow-lg hover:bg-gray-900 transition-all duration-200 hover:scale-110">
			<img src="${pageContext.request.contextPath}/img/kakao_icon.png"
				alt="카카오톡 공유" class="w-8 h-8">
		</button>
	</div>

	<%-- ▼▼▼ [수정] 모달창 내 공유 버튼 아이콘을 img 태그로 변경 ▼▼▼ --%>
	<div id="kakao-share-modal" class="fixed inset-0 z-50 hidden">
		<div id="kakao-share-backdrop"
			class="absolute inset-0 bg-slate-900/60"></div>
		<div
			class="relative z-10 flex min-h-full items-center justify-center p-4">
			<div id="kakao-share-panel"
				class="w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">
				<div class="flex items-start justify-between">
					<div>
						<h2 class="text-xl font-semibold text-slate-800">친구와 약속 잡기</h2>
						<p class="mt-1 text-sm text-slate-500">이 코스를 함께 즐길 약속을 공유해
							보세요.</p>
					</div>
					<button id="kakao-share-close-btn" type="button"
						class="text-slate-400 hover:text-slate-600">&times;</button>
				</div>
				<div class="mt-6 space-y-4">
					<div>
						<label for="meeting-date"
							class="block text-sm font-medium text-slate-700">만날 날짜</label> <input
							type="date" id="meeting-date"
							class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-sky-500 focus:outline-none focus:ring-1 focus:ring-sky-500">
					</div>
					<div>
						<label for="meeting-time"
							class="block text-sm font-medium text-slate-700">만날 시간</label> <input
							type="time" id="meeting-time"
							class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-sky-500 focus:outline-none focus:ring-1 focus:ring-sky-500">
					</div>
					<div>
						<label for="meeting-place"
							class="block text-sm font-medium text-slate-700">만날 장소</label> <input
							type="text" id="meeting-place" placeholder="예: 강남역 10번 출구"
							class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-sky-500 focus:outline-none focus:ring-1 focus:ring-sky-500">
					</div>
				</div>
				<div class="mt-6 flex justify-end space-x-3">
					<button id="kakao-share-cancel-btn" type="button"
						class="rounded-lg border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600 hover:bg-slate-100">취소</button>
					<button id="kakao-share-submit-btn"
						class="inline-flex items-center justify-center gap-2 rounded-lg bg-gray-800 px-6 py-3 text-base font-semibold text-white shadow-sm transition hover:bg-gray-900">
						<img src="${pageContext.request.contextPath}/img/kakao_icon.png"
							alt="" class="w-9 h-9"> 카카오톡으로 공유하기
					</button>
				</div>
			</div>
		</div>
	</div>

	<%-- ▼▼▼ [수정] 카카오 공유 기능 스크립트 (최종) ▼▼▼ --%>
	<script>
    document.addEventListener('DOMContentLoaded', function () {
        // header.jsp에서 Kakao SDK가 이미 초기화되었으므로 여기서는 추가 초기화를 하지 않습니다.
        const fab = document.getElementById('kakao-share-fab');
        const modal = document.getElementById('kakao-share-modal');
        if (!fab || !modal) return;

        const backdrop = document.getElementById('kakao-share-backdrop');
        const closeBtn = document.getElementById('kakao-share-close-btn');
        const cancelBtn = document.getElementById('kakao-share-cancel-btn');
        const submitBtn = document.getElementById('kakao-share-submit-btn');
        const dateInput = document.getElementById('meeting-date');
        const timeInput = document.getElementById('meeting-time');
        const placeInput = document.getElementById('meeting-place');

        const isUserLoggedInForShare = <c:out value="${not empty sessionScope.user}" default="false"/>;

        const openModal = () => {
            if (!isUserLoggedInForShare) {
                alert('로그인이 필요한 기능입니다.');
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            dateInput.value = now.toISOString().slice(0, 10);
            timeInput.value = now.toISOString().slice(11, 16);
            placeInput.value = '';
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        };

        const closeModal = () => {
            modal.classList.add('hidden');
            document.body.style.overflow = '';
        };
        
        const handleShare = () => {
            if (!Kakao || !Kakao.isInitialized()) {
                alert("카카오톡 공유 기능이 준비되지 않았습니다. 잠시 후 다시 시도해주세요.");
                return;
            }
            
            const date = dateInput.value;
            const time = timeInput.value;
            const place = placeInput.value.trim();

            if (!date || !time || !place) {
                alert('만날 날짜, 시간, 장소를 모두 입력해 주세요.');
                return;
            }

            const meetingDateTime = new Date(`${date}T${time}:00`);
            const meetingTimeISO = new Date(meetingDateTime.getTime() - (9 * 60 * 60 * 1000)).toISOString().slice(0, 19);

            const courseTitle = courseData.title;
            const pageUrl = window.location.pathname + window.location.search;
            const mapRedirectUrl = `${pageContext.request.contextPath}/location-map?query=\${encodeURIComponent(place)}`;
            const description = `[약속] ${date} ${time}\n${place}에서 만나요!`;
            
            // ▼▼▼ [최종 수정] 카카오 공식 샘플 이미지 주소로 변경 ▼▼▼
            const imageUrl = 'https://t1.kakaocdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a5ebea.jpg';

            const templateId = 124984; // ⚠️ 본인의 템플릿 ID로 교체!

            Kakao.Share.sendCustom({
                templateId: templateId,
                templateArgs: {
                    'title': courseTitle,
                    'description': description,
                    'page_url': pageUrl,
                    'image_url': imageUrl,
                    'map_redirect_url': mapRedirectUrl,
                    'profile_name': '${sessionScope.user.nickname}',
                    'profile_image_url': `${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/images/${sessionScope.user.profileImage}`,
                    'like_count': ${course.likes},
                    'comment_count': ${commentCount},
                }
            });
            
            closeModal();
        };

        fab.addEventListener('click', openModal);
        closeBtn.addEventListener('click', closeModal);
        cancelBtn.addEventListener('click', closeModal);
        backdrop.addEventListener('click', closeModal);
        submitBtn.addEventListener('click', handleShare);
    });
    </script>
    
</body>
</html>
