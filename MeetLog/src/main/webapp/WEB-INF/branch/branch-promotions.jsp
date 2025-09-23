<%-- branch-promotions.jsp (새 파일) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>진행중인 프로모션</title>

<style>
    body {
        margin: 0;
        background: #f6faf8;
        color: #0f172a;
        font: 14px/1.45 system-ui, -apple-system, sans-serif;
    }
    a {
        text-decoration: none;
        color: inherit;
    }
    main {
        max-width: 1100px;
        margin: 20px auto;
    }
    .panel {
        background: #ffffff;
        border: 1px solid #e5e7eb;
        border-radius: 16px;
        box-shadow: 0 8px 20px rgba(16,24,40,.05);
    }
    .panel .hd {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 16px 18px;
        border-bottom: 1px solid #e5e7eb;
    }
    .panel .bd {
        padding: 16px 18px;
    }
    .title {
        margin: 0;
        font-size: 20px;
        font-weight: 800;
    }
    .empty {
        color: #6b7280;
        text-align: center;
        padding: 24px;
    }
    .grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 18px;
    }

    /* --- 버튼 (Button) --- */
    .btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 12px;
        border: 1px solid #e5e7eb;
        border-radius: 999px;
        background: #ffffff;
        font-weight: 700;
        cursor: pointer;
    }
    .btn.primary {
        background: #285a3b;
        border-color: #285a3b;
        color: #fff;
    }
    .btn:hover {
        background: #f8fafc;
    }

    /* --- 뱃지 (Badge) --- */
    .badge {
        display: inline-block;
        padding: 2px 8px;
        border-radius: 999px;
        border: 1px solid #e5e7eb;
        font-size: 12px;
    }
    .badge.ok { /* 진행중 */
        background: #ecfdf5;
        color: #065f46;
        border-color: #a7f3d0;
    }
    .badge.warn { /* 예정 */
        background: #fffbeb;
        color: #b45309;
        border-color: #fde68a;
    }
    .badge.na { /* 종료 */
        background: #f1f5f9;
        color: #475569;
        border-color: #e2e8f0;
    }
    
    /* --- 프로모션 카드 --- */
    .promo-card {
        display: flex;
        flex-direction: row;
        gap: 16px;
        padding: 16px;
        border: 1px solid #e5e7eb;
        border-radius: 14px;
        background: #fff;
        transition: box-shadow .2s;
    }
    .promo-card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,.08);
    }
    .promo-card .thumb {
        width: 120px;
        height: 120px;
        flex-shrink: 0;
        border-radius: 8px;
        object-fit: cover;
        border: 1px solid #e5e7eb;
    }
    .promo-card .body {
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }
    .promo-card h3 {
        margin: 0 0 8px 0;
        font-size: 16px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .promo-card .description {
        margin: 0;
        color: #6b7280;
        font-size: 13px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        height: 3em;
    }
    .promo-card .period {
        font-weight: bold;
        margin-top: auto;
        padding-top: 8px;
    }

    /* --- 반응형 --- */
    @media (max-width: 768px) {
        .grid {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>
<body>
	<%@ include file="/WEB-INF/layout/branchheader.jspf"%>
	<main>
		<section class="panel">
			<div class="hd">
				<h1 class="title">진행/예정 프로모션</h1>
			</div>
			<div class="bd">
				<c:if test="${empty promotions}">
					<p class="empty">현재 진행중이거나 예정된 프로모션이 없습니다.</p>
				</c:if>
				<div class="grid" style="grid-template-columns: 1fr 1fr;">
					<c:forEach var="p" items="${promotions}">
						<c:url var="viewUrl" value="/branch/promotion/view">
							<c:param name="id" value="${p.id}" />
						</c:url>
						<%-- [수정] a 태그로 카드를 감싸서 상세 페이지로 링크 --%>
						<a href="${viewUrl}" class="card"
							style="text-decoration: none; color: inherit; flex-direction: row; gap: 16px; padding: 16px;">
							<mytag:image fileName="${p.imgPath}" altText="${p.title}"
								cssClass="thumb" />
							<div class="body">
								<h3>${p.title}</h3>
								<p class="description">${p.description}</p>
								<p class="period">
									<fmt:formatDate value="${p.startDate}" pattern="MM.dd" />
									~
									<fmt:formatDate value="${p.endDate}" pattern="MM.dd" />
								</p>
							</div>
						</a>
					</c:forEach>
				</div>
			</div>
		</section>
	</main>
</body>
</html>