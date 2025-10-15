
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- 페이지네이션 변수 설정 --%>
<c:set var="pageSize" value="${requestScope.pageSize}" />
<c:set var="currentPage" value="${requestScope.currentPage}" />
<c:set var="totalCount" value="${requestScope.totalCount}" />
<fmt:parseNumber var="totalPages" integerOnly="true"
    value="${totalCount > 0 ? Math.floor((totalCount - 1) / pageSize) + 1 : 1}" />
<c:set var="hasPrev" value="${currentPage > 1}" />
<c:set var="hasNext" value="${currentPage < totalPages}" />
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}" />
<c:set var="nextPage"
	value="${hasNext ? (currentPage + 1) : totalPages}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>본사 · 레시피 관리</title>
<style>
:root { -
	-bg: #f6faf8; -
	-surface: #ffffff; -
	-border: #e5e7eb; -
	-muted: #6b7280; -
	-title: #0f172a; -
	-primary: #2f855a; -
	-primary-600: #27764f; -
	-ring: #93c5aa
}

html, body {
	height: 100%
}

body {
	margin: 0;
	background: var(- -bg);
	color: var(- -title);
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
.empty-row td { text-align: center; padding: 24px; color: var(--muted); }

/* Card */
.panel {
	max-width: 1000px;
	background: var(- -surface);
	border: 1px solid var(- -border);
	border-radius: 16px;
	box-shadow: 0 8px 20px rgba(16, 24, 40, .05);
	margin: 0 auto;
}

.panel .hd {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 16px 18px;
	border-bottom: 1px solid var(- -border)
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
	border: 1px solid var(- -border);
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
	border: 1px solid var(- -border);
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
	background: var(- -primary);
	border-color: var(- -primary);
	color: #fff
}

.btn.primary:hover {
	background: var(- -primary-600)
}

.btn-sm {
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
	border: 1px solid var(- -border);
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
	border-bottom: 1px solid var(- -border);
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
	border: 1px solid var(- -border);
	object-fit: cover;
	background: #fafafa;
	display: block
}

.row-actions {
	display: flex;
	gap: 6px
}

.empty {
	color: var(- -muted);
	text-align: center;
	padding: 24px
}

/* Modal (edit/append form) */
.modal {
	position: fixed;
	inset: 0;
	display: none;
	align-items: center;
	justify-content: center;
	background: rgba(15, 23, 42, .45);
	z-index: 100
}

.modal.show {
	display: flex
}

.dialog {
	width: 100%;
	max-width: 720px;
	background: #fff;
	border-radius: 20px;
	border: 1px solid var(- -border);
	box-shadow: 0 10px 30px rgba(0, 0, 0, .12)
}

.dialog .hd {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 14px 16px;
	border-bottom: 1px solid var(- -border)
}

.dialog .bd {
	padding: 16px
}

.close-x {
	border: 0;
	background: transparent;
	font-size: 22px;
	cursor: pointer
}

/* Reuse of material-settings form styles */
.form {
	display: grid;
	gap: 14px
}

.row {
	display: grid;
	grid-template-columns: 160px 1fr;
	align-items: center;
	gap: 12px
}

.label {
	color: var(- -muted);
	font-size: 14px
}

.input {
	width: 100%;
	padding: 12px 14px;
	border: 1px solid var(- -border);
	border-radius: 12px;
	background: #fff;
	outline: 0;
	font-size: 14px
}

.input:focus {
	border-color: var(- -primary);
	box-shadow: 0 0 0 3px var(- -ring)
}

.image-field {
	display: grid;
	grid-template-columns: 72px 1fr;
	gap: 12px;
	align-items: center
}

.preview-circle {
	width: 72px;
	height: 72px;
	border-radius: 10px;
	border: 2px dashed var(- -border);
	background: #fafafa;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
	cursor: pointer
}

.preview-circle img {
	width: 100%;
	height: 100%;
	object-fit: cover
}

.hint {
	color: var(- -muted);
	font-size: 12px
}

.actions {
	display: flex;
	gap: 10px;
	justify-content: center;
	margin-top: 8px
}

@media ( max-width :560px) {
	.row {
		grid-template-columns: 1fr
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/layout/header.jspf"%>

	<main>
		<section class="panel" aria-labelledby="pageTitle">
			<div class="hd">
				<h1 id="pageTitle" class="title">레시피 관리</h1>
				<span class="pill">HQ</span>
				<div style="flex: 1 1 auto"></div>
			</div>
			<div class="bd">
				<!-- toolbar -->


				<div class="table-wrap" role="region" aria-label="레시피 목록">
					<table class="sheet" role="grid">
						<!-- 메뉴 테이블 -->
						<thead>
							<tr>
								<th style="width: 56px">이미지</th>
								<th>메뉴명</th>
								<th style="width: 140px">판매가</th>
								<th style="width: 132px">관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="m" items="${menus}">
								<tr id="row-${m.id}" data-id="${m.id}"
									data-name="${fn:escapeXml(m.name)}" data-saleprice="${m.price}"
									data-img="${contextPath}${m.imgPath}">
									<td><c:choose>
											<c:when test="${not empty m.imgPath}">
												<mytag:image fileName="${m.imgPath}" altText="${m.name}"
													cssClass="thumb" />
											</c:when>
											<c:otherwise>
												<span class="thumb"
													style="display: grid; place-items: center">🍽️</span>
											</c:otherwise>
										</c:choose></td>
									<td>${m.name}</td>
									<td class="cell-num"><fmt:formatNumber value="${m.price}" /></td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit"
												data-id="${m.id}">레시피 수정</button>

										</div>
									</td>
								</tr>
							</c:forEach>

							<c:if test="${empty menus}">
								<tr class="empty-row"><td colspan="4">메뉴가 없습니다.</td></tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
				<%-- 페이지네이션 UI 추가 --%>
				<div class="pager"
					style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
					<div class="btn-group" style="display: flex; gap: 6px;">
						<a class="btn btn-sm" href="?page=1" aria-disabled="${not hasPrev}">≪</a>
						<a class="btn btn-sm" href="?page=${prevPage}" aria-disabled="${not hasPrev}">‹</a>
						<a class="btn btn-sm" href="?page=${nextPage}" aria-disabled="${not hasNext}">›</a>
						<a class="btn btn-sm" href="?page=${totalPages}" aria-disabled="${not hasNext}">≫</a>
					</div>
					<div class="info" style="font-size: 13px; color: var(- -muted);">
						총 ${totalCount}건 (페이지 ${currentPage} /
						<fmt:formatNumber value="${totalPages}" maxFractionDigits="0" />
						)
					</div>
				</div>
			</div>
		</section>
	</main>
	<div id="recipeModal" class="modal">
		<div class="dialog" style="max-width: 800px;">
			<div class="hd">
				<strong id="modalTitle">레시피 수정</strong>
				<button class="close-x" type="button" aria-label="닫기">×</button>
			</div>
			<div class="bd">
				<form id="recipeForm">
					<input type="hidden" id="menuId" name="menuId">
					<h4>재료 목록</h4>
					<ul id="ingredientList"
						style="list-style: none; padding: 0; margin-bottom: 20px;"></ul>

					<h4>레시피</h4>
					<textarea id="recipeText" name="recipe" class="input" rows="15"
						placeholder="레시피를 입력하세요..."></textarea>

					<div class="actions" style="justify-content: flex-end;">
						<button type="button" class="btn close-x">취소</button>
						<button type="submit" class="btn primary">저장</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
const contextPath = '${contextPath}';
const recipeModal = document.getElementById('recipeModal');
const recipeForm = document.getElementById('recipeForm');
const modalTitle = document.getElementById('modalTitle');
const ingredientList = document.getElementById('ingredientList');
const recipeText = document.getElementById('recipeText');
const menuIdInput = document.getElementById('menuId');

// 모달 열기
document.querySelectorAll('button[data-action="edit"]').forEach(button => {
    button.addEventListener('click', async (event) => {
        event.preventDefault(); // 기본 버튼 동작 방지
        
        // [수정] 버튼 대신 버튼이 속한 행(tr)에서 ID를 가져오는 방식으로 변경
        const tr = button.closest('tr');
        const menuId = tr ? tr.dataset.id : null;
        
        console.log("1. 클릭된 메뉴의 ID:", menuId); 
        
        if (!menuId && menuId !== 0) {
            alert("오류: 메뉴 ID를 찾을 수 없습니다.");
            return;
        }
        
        // [수정] URL을 템플릿 리터럴 대신 문자열 덧셈 방식으로 생성
        const url = contextPath + '/hq/recipe?action=getDetails&id=' + menuId;

        console.log("2. 서버에 요청하는 최종 URL:", url);

        try {
            const response = await fetch(url);
            
            if (!response.ok) {
                throw new Error(`데이터 로딩 실패: 서버가 ${response.status} 상태로 응답했습니다.`);
            }
            
            const data = await response.json();
            
            modalTitle.textContent = data.menu.name + "레시피 수정";
            menuIdInput.value = data.menu.id;
            recipeText.value = data.menu.recipe || '';
            
            ingredientList.innerHTML = '';
            if (data.ingredients && data.ingredients.length > 0) {
                data.ingredients.forEach(ing => {
                	console.log(ing);
                    const li = document.createElement('li');
                    li.textContent = '• ' + ing.materialName + ' : ' + ing.qty +  " " + ing.unit;
                    ingredientList.appendChild(li);
                });
            } else {
                ingredientList.innerHTML = '<li>등록된 재료가 없습니다.</li>';
            }
            
            recipeModal.classList.add('show');

        } catch (error) {
            console.error("Fetch Error:", error);
            alert(error.message);
        }
    });
});

// 모달 닫기
function closeModal() {
    recipeModal.classList.remove('show');
}
recipeModal.querySelectorAll('.close-x').forEach(el => el.addEventListener('click', closeModal));
recipeModal.addEventListener('click', e => { if(e.target === recipeModal) closeModal(); });

// 레시피 저장
recipeForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const formData = new URLSearchParams(new FormData(recipeForm));
    
    try {
        const response = await fetch(`${contextPath}/hq/recipe`, {
            method: 'POST',
            body: formData
        });
        if (!response.ok) throw new Error('저장 실패');
        
        const result = await response.json();
        if (result.status === 'OK') {
            alert('레시피가 저장되었습니다.');
            closeModal();
        }
    } catch (error) {
        alert(error.message);
    }
});
</script>
</body>
</html>
