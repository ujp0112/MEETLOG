<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageSize" value="${requestScope.pageSize}" />
<c:set var="currentPage" value="${requestScope.currentPage}" />
<c:set var="totalCount" value="${requestScope.totalCount}" />
<fmt:parseNumber var="totalPages" integerOnly="true"
    value="${totalCount > 0 ? Math.floor((totalCount - 1) / pageSize) + 1 : 1}" />
<c:set var="hasPrev" value="${currentPage > 1}" />
<c:set var="hasNext" value="${currentPage < totalPages}" />
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}" />
<c:set var="nextPage" value="${hasNext ? (currentPage + 1) : totalPages}" />
<c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}" />
<c:set var="endIndex" value="${startIndex + fn:length(notices) - 1}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>지점 · 사내 공지</title>
<style>
:root { --bg: #f6faf8; --surface: #ffffff; --border: #e5e7eb; --muted: #6b7280; --title: #0f172a; --primary: #2f855a; --primary-600: #27764f; --ring: #93c5aa
}
html, body {
    height: 100%
}
body {
    margin: 0;
    background: var(--bg);
    color: var(--title);
    font: 14px/1.45 system-ui, -apple-system, Segoe UI, Roboto, Helvetica,
        Arial, "Apple SD Gothic Neo", "Noto Sans KR", sans-serif
}
/* Shell with left sidebar include */
.shell {
    max-width: 1280px;
    margin: 0 auto;
    padding: 20px;
    display: grid;
    grid-template-columns: 260px minmax(0, 1fr);
    gap: 20px
}
@media ( max-width : 960px) {
    .shell {
        grid-template-columns: 1fr
    }
}
/* Card */
.panel {
    max-width: 1000px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 16px;
    box-shadow: 0 8px 20px rgba(16, 24, 40, .05);
    margin: 0 auto;
}
.panel .hd {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 16px 18px;
    border-bottom: 1px solid var(--border)
}
.panel .bd {
    padding: 16px 18px
}
.title {
    margin: 0;
    font-size: 20px;
    font-weight: 800
}
.pill {
    padding: 6px 10px;
    border-radius: 999px;
    background: #eef7f0;
    border: 1px solid #ddeee1;
    color: #246b45;
    font-weight: 700
}
.toolbar {
    display: flex;
    flex-wrap: wrap;
    gap: 8px
}
.field {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 8px 10px
}
.field>select, .field>input {
    border: 0;
    outline: 0;
    min-width: 160px
}
.btn {
    appearance: none;
    border: 1px solid var(--border);
    background: #fff;
    padding: 10px 14px;
    border-radius: 999px;
    font-weight: 700;
    cursor: pointer;
    text-decoration: none;
    color: #111827
}
.btn:hover {
    background: #f8fafc
}
.btn.primary {
    background: var(--primary);
    border-color: var(--primary);
    color: #fff
}
.btn.primary:hover {
    background: var(--primary-600)
}
.btn-sm, .btn.sm {
    padding: 6px 8px;
    border-radius: 8px
}
.btn-danger {
    color: #b91c1c;
    border-color: #fecaca
}
.btn-danger:hover {
    background: #fff1f2;
    border-color: #fca5a5
}
/* Table (spreadsheet look) */
.table-wrap {
    border: 1px solid var(--border);
    border-radius: 14px;
    overflow: auto;
    background: #fff
}
table.sheet {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    min-width: 860px
}
.sheet thead th {
    position: sticky;
    top: 0;
    background: #fff;
    border-bottom: 1px solid var(--border);
    font-weight: 800;
    text-align: left;
    padding: 12px 10px;
    font-size: 13px
}
.sheet tbody td {
    padding: 12px 10px;
    border-bottom: 1px solid #f1f5f9;
    vertical-align: middle
}
.sheet tbody tr:hover td {
    background: #fafafa
}
.cell-id {
    text-align: left
}
.thumb {
    width: 40px;
    height: 40px;
    border-radius: 8px;
    border: 1px solid var(--border);
    object-fit: cover;
    background: #fafafa;
    display: block
}
.row-actions {
    display: flex;
    gap: 6px
}
.empty {
    color: var(--muted);
    text-align: center;
    padding: 24px
}
.pager .btn[aria-disabled="true"] {
    pointer-events: none;
    opacity: 0.5;
}
.pager .info { font-size: 12px; color: var(--muted); }
</style>
</head>
<body>
<!-- dd -->
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <main>
        <section class="panel" aria-labelledby="pageTitle">
            <div class="hd">
                <h1 id="pageTitle" class="title">사내 공지</h1>
                <span class="pill">BRANCH</span>
                <div style="flex: 1 1 auto"></div>
            </div>
            <div class="bd">
                <div class="table-wrap" role="region" aria-label="공지 목록">
                    <table class="sheet" role="grid">
                        <thead>
                            <tr>
                                <th style="width: 80px">번호</th>
                                <th>제목</th>
                                <th style="width: 120px">조회수</th>
                                <th style="width: 150px">작성일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="n" items="${notices}">
                                <tr>
                                    <td>${n.id}</td>
                                    <td><a href="${contextPath}/branch/notice/view?id=${n.id}">${fn:escapeXml(n.title)}</a></td>
                                    <td>${n.viewCount}</td>
                                    <td><fmt:formatDate value="${n.createdAt}"
                                            pattern="yyyy-MM-dd" /></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty notices}">
                                <tr>
                                    <td colspan="4" class="empty">등록된 공지사항이 없습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <%-- [수정] inventory.jsp와 동일한 페이지네이션 UI 적용 --%>
                <c:if test="${totalCount > 0}">
                    <div class="pager" id="mainPager">
                        <div class="left">
                            <div class="btn-group">
                                <a class="btn sm" href="?page=1" aria-disabled="${not hasPrev}">≪</a>
                                <a class="btn sm" href="?page=${prevPage}" aria-disabled="${not hasPrev}">‹</a>
                                <a class="btn sm" href="?page=${nextPage}" aria-disabled="${not hasNext}">›</a>
                                <a class="btn sm" href="?page=${totalPages}" aria-disabled="${not hasNext}">≫</a>
                            </div>
                            <span class="info">${startIndex}–${endIndex} / ${totalCount} (페이지 ${currentPage} / <fmt:formatNumber value='${totalPages}' maxFractionDigits='0' />)</span>
                        </div>
                        <div class="right">
                            <span class="info">페이지당 ${pageSize}건</span>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
    </main>
</body>
<script>
	// 스크립트 추가

	/* 
	 // 모달 열기/닫기
	 document.querySelector('[data-action="append"]').addEventListener('click', () => {
	 form.reset();
	 form.querySelector('#noticeId').value = '';
	 modalTitle.textContent = '공지 추가';
	 modal.classList.add('show');
	 });
	 modal.addEventListener('click', e => {
	 if(e.target.matches('[data-action="close-modal"]') || e.target === modal) {
	 modal.classList.remove('show');
	 }
	 });

	 // 수정 버튼 이벤트
	 document.querySelectorAll('[data-action="edit"]').forEach(btn => {
	 btn.addEventListener('click', async () => {
	 const id = btn.dataset.id;
	 const res = await fetch(`${contextPath}/hq/notice/${id}`);
	 if(res.ok) {
	 const notice = await res.json();
	 form.querySelector('#noticeId').value = notice.id;
	 form.querySelector('#title').value = notice.title;
	 form.querySelector('#content').value = notice.content;
	 modalTitle.textContent = '공지 수정';
	 modal.classList.add('show');
	 }
	 });
	 }); */
</script>
</html>
