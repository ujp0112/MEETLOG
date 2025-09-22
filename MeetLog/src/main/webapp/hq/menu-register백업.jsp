<!-- File: webapp/hq/menu-register.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>본사 · 메뉴 관리</title>
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

.panel {
	width: 1000px;
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

.cell-num {
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
	max-width: 1100px;
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
	font-size: 14px;
	text-align: right;
	padding: 15px
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

/* 재료 테이블 전용 사이즈 조절 */
.ingredients .table-wrap {
	max-height: 240px
}

.ingredients table.sheet {
	min-width: 680px
}

.ingredients .total {
	display: flex;
	justify-content: flex-end;
	align-items: center;
	gap: 8px;
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
	<jsp:include page="/WEB-INF/jspf/header.jspf" />
	<main>
		<section class="panel" aria-labelledby="pageTitle">
			<div class="hd">
				<h1 id="pageTitle" class="title">메뉴 관리</h1>
				<span class="pill">HQ</span>
				<div style="flex: 1 1 auto"></div>
				<button class="btn primary" data-action="append">+ 메뉴 추가</button>
			</div>
			<div class="bd">
				<form method="get" class="toolbar" style="margin-bottom: 12px">
					<div class="field">
						<span style="color: var(- -muted)">검색</span><input name="q"
							value="${fn:escapeXml(param.q)}" placeholder="메뉴명/단위/브랜드" />
					</div>
					<button class="btn" type="submit">검색</button>
					<a class="btn" href="${contextPath}/hq/menu-register.jsp">초기화</a>
				</form>

				<div class="table-wrap" role="region" aria-label="메뉴 목록">
					<table class="sheet" role="grid">
						<thead>
							<tr>
								<th style="width: 56px">이미지</th>
								<th>메뉴명</th>
								<th style="width: 120px">단위</th>
								<th style="width: 120px">단가</th>
								<th style="width: 120px">보유량</th>
								<th style="width: 120px">주문단위</th>
								<th style="width: 140px">가격</th>
								<th style="width: 132px">관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="m" items="${menus}">
								<tr id="row-${m.num}" data-id="${m.num}"
									data-name="${fn:escapeXml(m.name)}"
									data-saleprice="${m.salePrice}" data-unitprice="${m.unitPrice}"
									data-step="${m.step}"
									data-qty="${empty m.stockQty ? (empty m.quantity ? 0 : m.quantity) : m.stockQty}"
									data-img="${m.imgfilename}">
									<td><c:choose>
											<c:when test="${not empty m.imgfilename}">
												<img class="thumb"
													src="${contextPath}/imageView?filename=${m.imgfilename}"
													alt="${fn:escapeXml(m.name)}" />
											</c:when>
											<c:otherwise>
												<span class="thumb"
													style="display: grid; place-items: center">🥬</span>
											</c:otherwise>
										</c:choose></td>
									<td>${m.name}</td>
									<td>${m.salePrice}</td>
									<td class="cell-num"><fmt:formatNumber
											value="${m.unitPrice}" /></td>
									<td class="cell-num"><c:choose>
											<c:when test="${not empty m.stockQty}">
												<fmt:formatNumber value="${m.stockQty}" />
											</c:when>
											<c:when test="${not empty m.quantity}">
												<fmt:formatNumber value="${m.quantity}" />
											</c:when>
											<c:otherwise>0</c:otherwise>
										</c:choose></td>
									<td class="cell-num"><fmt:formatNumber
											value="${m.step}" /></td>
									<td class="cell-num"><fmt:formatNumber
											value="${(m.unitPrice) * (m.step)}" /></td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit">수정</button>
											<button type="button" class="btn-sm btn-danger"
												data-action="delete"
												data-delete-url="${contextPath}/hq/materials/${m.num}/delete">삭제</button>
										</div>
									</td>
								</tr>
							</c:forEach>
							<c:if test="${empty menus}">
								<tr id="row-m1" data-id="m1" data-name="로메인"
									data-saleprice="10000" data-unitprice="4500" data-step="5"
									data-qty="20" data-img="">
									<td><span class="thumb"
										style="display: grid; place-items: center">🥬</span></td>
									<td>로메인</td>
									<td>10000</td>
									<td class="cell-num">4,500</td>
									<td class="cell-num">20</td>
									<td class="cell-num">5</td>
									<td class="cell-num">22,500</td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit">수정</button>
											<button type="button" class="btn-sm btn-danger"
												data-action="delete" data-delete-url="#mock">삭제</button>
										</div>
									</td>
								</tr>
								<tr id="row-m2" data-id="m2" data-name="방울토마토"
									data-saleprice="100000" data-unitprice="3200"
									data-step="10" data-qty="150" data-img="">
									<td><span class="thumb"
										style="display: grid; place-items: center">🍅</span></td>
									<td>방울토마토</td>
									<td>100000</td>
									<td class="cell-num">3,200</td>
									<td class="cell-num">150</td>
									<td class="cell-num">10</td>
									<td class="cell-num">32,000</td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit">수정</button>
											<button type="button" class="btn-sm btn-danger"
												data-action="delete" data-delete-url="#mock">삭제</button>
										</div>
									</td>
								</tr>
								<tr id="row-m3" data-id="m3" data-name="닭가슴살"
									data-saleprice="15000" data-unitprice="8700" data-step="4"
									data-qty="60" data-img="">
									<td><span class="thumb"
										style="display: grid; place-items: center">🍗</span></td>
									<td>닭가슴살</td>
									<td>15000</td>
									<td class="cell-num">8,700</td>
									<td class="cell-num">60</td>
									<td class="cell-num">4</td>
									<td class="cell-num">34,800</td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit">수정</button>
											<button type="button" class="btn-sm btn-danger"
												data-action="delete" data-delete-url="#mock">삭제</button>
										</div>
									</td>
								</tr>
								<tr id="row-m4" data-id="m4" data-name="아보카도"
									data-saleprice="5000" data-unitprice="2500" data-step="12"
									data-qty="30" data-img="">
									<td><span class="thumb"
										style="display: grid; place-items: center">🥑</span></td>
									<td>아보카도</td>
									<td>5000</td>
									<td class="cell-num">2,500</td>
									<td class="cell-num">30</td>
									<td class="cell-num">12</td>
									<td class="cell-num">30,000</td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit">수정</button>
											<button type="button" class="btn-sm btn-danger"
												data-action="delete" data-delete-url="#mock">삭제</button>
										</div>
									</td>
								</tr>
								<tr id="row-m5" data-id="m5" data-name="올리브오일" data-unit="L"
									data-unitprice="9800" data-step="1" data-qty="8"
									data-img="">
									<td><span class="thumb"
										style="display: grid; place-items: center">🫒</span></td>
									<td>올리브오일</td>
									<td>L</td>
									<td class="cell-num">9,800</td>
									<td class="cell-num">8</td>
									<td class="cell-num">1</td>
									<td class="cell-num">9,800</td>
									<td>
										<div class="row-actions">
											<button type="button" class="btn-sm" data-action="edit">수정</button>
											<button type="button" class="btn-sm btn-danger"
												data-action="delete" data-delete-url="#mock">삭제</button>
										</div>
									</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
		</section>
	</main>

	<!-- ===================== 메뉴 수정 모달 ===================== -->
	<div id="editModal" class="modal" aria-hidden="true" role="dialog"
		aria-modal="true">
		<div class="dialog">
			<div class="hd">
				<strong>메뉴 수정</strong>
				<button class="close-x" type="button" aria-label="닫기"
					onclick="closeEditModal()">×</button>
			</div>
			<div class="bd">
				<form id="editForm" class="form" action="${contextPath}/메뉴정정(미구현)"
					method="post" enctype="multipart/form-data">
					<input type="hidden" name="num" id="f-num" />
					<div class="row">
						<label class="label">메뉴 사진</label>
						<div class="image-field">
							<label class="preview-circle" for="f-ifile" title="이미지 선택">
								<img id="f-preview" src="${contextPath}/img/plus.png"
								alt="preview" />
							</label>
							<div>
								<input class="input" type="text" id="f-selectFile"
									placeholder="선택된 파일 없음" readonly />
								<div class="hint">정사각형 이미지를 권장합니다. (JPG/PNG)</div>
							</div>
						</div>
					</div>
					<div class="row">
						<label class="label" for="f-name">메뉴명<span
							style="color: #ef4444"> *</span></label> <input class="input" type="text"
							name="name" id="f-name" required />
					</div>
					<div class="row">
						<label class="label" for="f-salePrice">판매가<span
							style="color: #ef4444"> *</span></label> <input class="input"
							type="number" name="salePrice" id="f-salePrice" step="100"
							min="0" required />
					</div>
					<div class="row">
						<label class="label" for="f-unitPrice">원가</label> <input
							class="input" type="number" name="unitPrice" id="f-unitPrice"
							step="1" min="0" readonly />
					</div>

					<!-- 재료 테이블 섹션 (수정 모달) -->
					<section class="ingredients" aria-label="재료 목록">
						<div class="row">
							<label class="label">메뉴 재료</label>
							<div>
								<div class="table-wrap">
									<table class="sheet ingredients-table" role="grid">
										<thead>
											<tr>
												<th>재료명</th>
												<th style="width: 120px">수량</th>
												<th style="width: 120px">원가</th>
												<th style="width: 120px">단위</th>
												<th style="width: 140px">관리</th>
											</tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
								<div class="actions" style="justify-content: flex-end">
									<button type="button" class="btn" data-action="ingredient-add">+
										재료 추가</button>
								</div>
								<div class="total" aria-live="polite">
									<span class="hint">원가 합계:</span> <strong><span
										class="cost-sum">0</span>원</strong>
								</div>
								<input type="hidden" name="ingredientsJson"
									class="ingredients-json" />
							</div>
						</div>
					</section>

					<input type="file" name="ifile" id="f-ifile" accept="image/*"
						style="display: none" />
					<div class="actions">
						<button class="btn primary" type="submit">저장</button>
						<button class="btn" type="button" onclick="closeEditModal()">취소</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- ===================== 메뉴 추가 모달 ===================== -->
	<div id="appendModal" class="modal" aria-hidden="true" role="dialog"
		aria-modal="true">
		<div class="dialog">
			<div class="hd">
				<strong>메뉴 추가</strong>
				<button class="close-x" type="button" aria-label="닫기"
					onclick="closeAppendModal()">×</button>
			</div>
			<div class="bd">
				<form id="appendForm" class="form" action="${contextPath}/메뉴추가(미구현)"
					method="post" enctype="multipart/form-data">
					<input type="hidden" name="num" />
					<div class="row">
						<label class="label">메뉴 사진</label>
						<div class="image-field">
							<label class="preview-circle" for="f-ifile" title="이미지 선택">
								<img id="f-preview" src="${contextPath}/img/plus.png"
								alt="preview" />
							</label>
							<div>
								<input class="input" type="text" id="f-selectFile"
									placeholder="선택된 파일 없음" readonly />
								<div class="hint">정사각형 이미지를 권장합니다. (JPG/PNG)</div>
							</div>
						</div>
					</div>
					<table>
						<tr>
							<td>
								<div class="row">
									<label class="label" for="af-name">메뉴명<span
										style="color: #ef4444"> *</span></label> <input class="input"
										type="text" name="name" id="af-name" required />
								</div>
							</td>
							<td>
								<div class="row">
									<label class="label" for="af-salePrice">판매가<span
										style="color: #ef4444"> *</span></label> <input class="input"
										type="number" name="salePrice" id="af-salePrice" step="100"
										min="0" required />
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="row">
									<label class="label" for="af-unitPrice">원가</label> <input
										class="input" type="number" name="unitPrice" id="af-unitPrice"
										step="1" min="0" readonly />
								</div>
							</td>
							<td>
								<!-- 자리 고정용 빈 칸 -->
							</td>
						</tr>
					</table>

					<!-- 재료 테이블 섹션 (추가 모달) -->
					<section class="ingredients" aria-label="재료 목록">
						<div class="row">
							<label class="label">메뉴 재료</label>
							<div>
								<div class="table-wrap">
									<table class="sheet ingredients-table" role="grid">
										<thead>
											<tr>
												<th>재료명</th>
												<th style="width: 120px">수량</th>
												<th style="width: 120px">원가</th>
												<th style="width: 120px">단위</th>
												<th style="width: 140px">관리</th>
											</tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
								<div class="actions" style="justify-content: flex-end">
									<button type="button" class="btn" data-action="ingredient-add">+
										재료 추가</button>
								</div>
								<div class="total" aria-live="polite">
									<span class="hint">원가 합계:</span> <strong><span
										class="cost-sum">0</span>원</strong>
								</div>
								<input type="hidden" name="ingredientsJson"
									class="ingredients-json" />
							</div>
						</div>
					</section>

					<input type="file" name="ifile" id="f-ifile" accept="image/*"
						style="display: none" />
					<div class="actions">
						<button class="btn primary" type="submit">저장</button>
						<button class="btn" type="button" onclick="closeAppendModal()">취소</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- ===================== 재료행 수정 모달 ===================== -->
	<div id="ingredientModal" class="modal" aria-hidden="true"
		role="dialog" aria-modal="true">
		<div class="dialog" style="max-width: 560px">
			<div class="hd">
				<strong>재료행 수정</strong>
				<button class="close-x" type="button" aria-label="닫기"
					onclick="closeIngredientModal()">×</button>
			</div>
			<div class="bd">
				<form id="ingredientForm" class="form">
					<input type="hidden" id="ing-mode" value="add" /> <input
						type="hidden" id="ing-row-id" value="" />
					<div class="row">
						<label class="label" for="ing-material">재료변경</label> <select
							class="input" id="ing-material"></select>
					</div>
					<div class="row">
						<label class="label" for="ing-qty">수량변경</label> <input
							class="input" id="ing-qty" type="number" inputmode="decimal"
							min="0" step="0.01" required />
					</div>
					<div class="row">
						<label class="label" for="ing-price">단가</label> <input
							class="input" id="ing-price" type="number" min="0" step="1"
							readonly />
					</div>
					<div class="row">
						<label class="label" for="ing-unit">단위</label> <input
							class="input" id="ing-unit" type="text" readonly />
					</div>
					<div class="actions">
						<button class="btn primary" type="submit">확인</button>
						<button class="btn" type="button" onclick="closeIngredientModal()">취소</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 업로드된 재료 목록: 서버 데이터 우선, 없으면 목업 사용 -->
	<select id="materialsCatalog" style="display: none">
		<c:forEach var="mat" items="${materials}">
			<option value="${mat.num}" data-name="${fn:escapeXml(mat.name)}"
				data-unit="${fn:escapeXml(mat.unit)}" data-price="${mat.unitPrice}">${fn:escapeXml(mat.name)}</option>
		</c:forEach>
		<c:if test="${empty materials}">
			<option value="m1" data-name="로메인" data-unit="kg" data-price="4500">로메인</option>
			<option value="m2" data-name="방울토마토" data-unit="팩" data-price="3200">방울토마토</option>
			<option value="m3" data-name="닭가슴살" data-unit="kg" data-price="8700">닭가슴살</option>
			<option value="m4" data-name="아보카도" data-unit="개" data-price="2500">아보카도</option>
			<option value="m5" data-name="올리브오일" data-unit="L" data-price="9800">올리브오일</option>
		</c:if>
	</select>

	<!-- 삭제 Fallback -->
	<form id="fallbackDeleteForm" method="post" style="display: none"></form>

	<script>
    const $ = (sel, el=document) => el.querySelector(sel);
    const $$ = (sel, el=document) => Array.from(el.querySelectorAll(sel));

    // ===================== 기존 목록 테이블 액션 =====================
    document.addEventListener('click', (e) => {
      const btn = e.target.closest('button');
      if(!btn) return;
      const tr = e.target.closest('tr');
      const action = btn.dataset.action;
      if(action === 'edit'){
        openEdit(tr);
      }else if(action === 'delete'){
        const url = btn.dataset.deleteUrl;
        if(url === '#mock'){ tr.remove(); return; }
        if(!url) return;
        if(!confirm('삭제하시겠어요?')) return;
        btn.disabled = true;
        fetch(url, { method: 'POST' })
          .then(res => { if(!res.ok) throw new Error('서버 오류'); return res.text(); })
          .then(() => { tr.parentNode.removeChild(tr); })
          .catch(err => { alert('삭제 실패: ' + err.message); btn.disabled = false; })
      }else if(action === 'append'){
        openAppend();
      }
    });

    // ===================== 공통 유틸 =====================
    const nf = new Intl.NumberFormat('ko-KR');
    const uid = (p='id') => p + '-' + Date.now().toString(36) + '-' + Math.random().toString(36).slice(2,7);

    function toNumber(v){
      if(typeof v === 'number') return v;
      if(!v) return 0;
      return Number(String(v).replace(/[^0-9.-]/g,'')) || 0;
    }

    function ctxFromModal(modal){
      const form = modal.querySelector('form');
      return {
        modal,
        form,
        tbody: modal.querySelector('.ingredients-table tbody'),
        sumEl: modal.querySelector('.cost-sum'),
        unitPriceInput: form.querySelector('input[name="unitPrice"]'),
        jsonInput: form.querySelector('.ingredients-json')
      };
    }

    function readCatalog(){
      const sel = $('#materialsCatalog');
      return $$('#materialsCatalog option').map(opt=>({
        id: opt.value,
        name: opt.dataset.name || opt.textContent.trim(),
        unit: opt.dataset.unit || '',
        price: toNumber(opt.dataset.price)
      }));
    }

    function findInCatalog(id){
      const opt = $(`#materialsCatalog option[value="${CSS.escape(id)}"]`);
      if(!opt) return null;
      return { id: opt.value, name: opt.dataset.name || opt.textContent.trim(), unit: opt.dataset.unit || '', price: toNumber(opt.dataset.price) };
    }

    function serializeRows(ctx){
      const rows = $$('tr[data-ing-id]', ctx.tbody).map(tr=>({
        materialId: tr.dataset.materialId,
        name: tr.dataset.name,
        unit: tr.dataset.unit,
        unitPrice: toNumber(tr.dataset.price),
        quantity: toNumber(tr.dataset.qty)
      }));
      return rows;
    }

    function recalc(ctx){
      const rows = serializeRows(ctx);
      const sum = rows.reduce((acc, r)=> acc + (toNumber(r.unitPrice) * toNumber(r.quantity)), 0);
      if(ctx.sumEl) ctx.sumEl.textContent = nf.format(Math.round(sum));
      if(ctx.unitPriceInput){
        ctx.unitPriceInput.value = Math.round(sum);
      }
      if(ctx.jsonInput){
        ctx.jsonInput.value = JSON.stringify(rows);
      }
    }

    function upsertRow(ctx, payload){
      const {id, materialId, name, unit, price, qty} = payload;
      // 중복 재료 병합: materialId가 같은 행이 있으면 수량 합산
      let existing = $$('tr[data-ing-id]', ctx.tbody).find(tr => tr.dataset.materialId === materialId && tr.dataset.ingId !== id);
      if(existing){
        const newQty = toNumber(existing.dataset.qty) + toNumber(qty);
        existing.dataset.qty = String(newQty);
        existing.querySelector('[data-col="qty"]').textContent = newQty;
        recalc(ctx);
        return existing;
      }

      let tr = id ? ctx.tbody.querySelector('tr[data-ing-id="' + CSS.escape(id) + '"]') : null;
      if(!tr){
        tr = document.createElement('tr');
        tr.dataset.ingId = id || uid('ing');
        ctx.tbody.appendChild(tr);
      }
      tr.dataset.materialId = materialId;
      tr.dataset.name = name;
      tr.dataset.unit = unit;
      tr.dataset.price = String(price);
      tr.dataset.qty = String(qty);
      tr.innerHTML = '<td data-col="name">' + name + '</td>' +
        '<td data-col="qty" class="cell-num">' + qty + '</td>' +
        '<td data-col="price" class="cell-num">' + nf.format(price) + '</td>' +
        '<td data-col="unit">' + (unit || '') + '</td>' +
        '<td><div class="row-actions"><button type="button" class="btn-sm" data-action="ingredient-edit">수정</button><button type="button" class="btn-sm btn-danger" data-action="ingredient-delete">삭제</button></div></td>';
      recalc(ctx);
      return tr;
    }

    function removeRow(ctx, tr){
      if(!tr) return;
      tr.remove();
      recalc(ctx);
    }

    // ===================== 모달 제어 =====================
    const editModal = $('#editModal');
    const appendModal = $('#appendModal');
    const ingredientModal = $('#ingredientModal');
    let currentCtx = null; // 현재 작업중인 모달 컨텍스트

    function openEdit(tr){
      if(!tr) return;
      $('#f-num').value = tr.dataset.id || '';
      $('#f-name').value = tr.dataset.name || '';
      $('#f-salePrice').value = tr.dataset.saleprice || '';
      $('#f-unitPrice').value = tr.dataset.unitprice || '';
      $('#f-selectFile').value = '';
      editModal.classList.add('show');
      editModal.setAttribute('aria-hidden', 'false');
      currentCtx = ctxFromModal(editModal);
      // 초기화
      currentCtx.tbody.innerHTML = '';
      recalc(currentCtx);
      setTimeout(()=>{ $('#f-name').focus(); }, 0);
    }
    function closeEditModal(){
      editModal.classList.remove('show');
      editModal.setAttribute('aria-hidden', 'true');
      $('#editForm').reset();
      currentCtx = null;
    }
    editModal.addEventListener('click', (e)=>{ if(e.target === editModal) closeEditModal(); });

    function openAppend(){
      $('#f-selectFile').value = '';
      appendModal.classList.add('show');
      appendModal.setAttribute('aria-hidden', 'false');
      currentCtx = ctxFromModal(appendModal);
      // 초기화
      currentCtx.tbody.innerHTML = '';
      recalc(currentCtx);
      setTimeout(()=>{ $('#af-name').focus(); }, 0);
    }
    function closeAppendModal(){
      appendModal.classList.remove('show');
      appendModal.setAttribute('aria-hidden', 'true');
      $('#appendForm').reset();
      currentCtx = null;
    }
    appendModal.addEventListener('click', (e)=>{ if(e.target === appendModal) closeAppendModal(); });

    function openIngredientModal(mode, fromRow){
      if(!currentCtx) return;
      // 재료 선택 옵션 구성(1회 캐시 가능)
      const list = readCatalog();
      const sel = $('#ing-material');
      sel.innerHTML = '';
      for(const m of list){
        const opt = document.createElement('option');
        opt.value = m.id; opt.textContent = m.name; opt.dataset.unit = m.unit; opt.dataset.price = m.price;
        sel.appendChild(opt);
      }

      $('#ing-mode').value = mode;
      if(mode === 'edit' && fromRow){
        $('#ing-row-id').value = fromRow.dataset.ingId;
        $('#ing-material').value = fromRow.dataset.materialId;
        $('#ing-qty').value = fromRow.dataset.qty;
        $('#ing-price').value = toNumber(fromRow.dataset.price);
        $('#ing-unit').value = fromRow.dataset.unit || '';
      }else{
        const first = list[0];
        $('#ing-row-id').value = '';
        $('#ing-material').value = first ? first.id : '';
        $('#ing-qty').value = 1;
        $('#ing-price').value = first ? first.price : 0;
        $('#ing-unit').value = first ? first.unit : '';
      }

      ingredientModal.classList.add('show');
      ingredientModal.setAttribute('aria-hidden','false');
      setTimeout(()=> $('#ing-material').focus(), 0);
    }
    function closeIngredientModal(){
      ingredientModal.classList.remove('show');
      ingredientModal.setAttribute('aria-hidden','true');
      $('#ingredientForm').reset();
    }
    ingredientModal.addEventListener('click', (e)=>{ if(e.target === ingredientModal) closeIngredientModal(); });

    document.addEventListener('keydown', (e)=>{
      if(e.key==='Escape'){
        if(editModal.classList.contains('show')) closeEditModal();
        if(appendModal.classList.contains('show')) closeAppendModal();
        if(ingredientModal.classList.contains('show')) closeIngredientModal();
      }
    });

    // ===================== 이미지 프리뷰 =====================
    const ifile = $('#f-ifile');
    const preview = $('#f-preview');
    const selectFile = $('#f-selectFile');
    $('.preview-circle').addEventListener('click', ()=> ifile.click());
    ifile.addEventListener('change', function(){
      if(this.files && this.files[0]){
        const f = this.files[0];
        selectFile.value = f.name;
        const reader = new FileReader();
        reader.onload = e => preview.src = e.target.result;
        reader.readAsDataURL(f);
      }
    });

    // ===================== 재료 테이블 이벤트 위임 =====================
    [editModal, appendModal].forEach(modal => {
      modal.addEventListener('click', (e) => {
        if(!modal.classList.contains('show')) return;
        const btn = e.target.closest('button');
        if(!btn) return;
        const action = btn.dataset.action;
        if(action === 'ingredient-add'){
          currentCtx = ctxFromModal(modal);
          openIngredientModal('add');
        }else if(action === 'ingredient-edit'){
          currentCtx = ctxFromModal(modal);
          const tr = e.target.closest('tr[data-ing-id]');
          if(tr) openIngredientModal('edit', tr);
        }else if(action === 'ingredient-delete'){
          currentCtx = ctxFromModal(modal);
          const tr = e.target.closest('tr[data-ing-id]');
          if(tr && confirm('해당 재료를 삭제할까요?')) removeRow(currentCtx, tr);
        }
      });
    });

    // 재료 선택 변경 시 단가/단위 동기화
    $('#ing-material').addEventListener('change', (e)=>{
      const mat = findInCatalog(e.target.value);
      if(!mat) return;
      $('#ing-price').value = mat.price;
      $('#ing-unit').value = mat.unit || '';
    });

    // 재료행 모달 확인 → 테이블 반영
    $('#ingredientForm').addEventListener('submit', (e)=>{
      e.preventDefault();
      if(!currentCtx) return;
      const mode = $('#ing-mode').value;
      const rowId = $('#ing-row-id').value || null;
      const matId = $('#ing-material').value;
      const mat = findInCatalog(matId);
      const qty = toNumber($('#ing-qty').value);
      if(!mat || qty <= 0){ alert('재료/수량을 확인해주세요.'); return; }
      upsertRow(currentCtx, {
        id: rowId,
        materialId: mat.id,
        name: mat.name,
        unit: mat.unit,
        price: toNumber(mat.price),
        qty
      });
      closeIngredientModal();
    });

    // 폼 전송 전 JSON 직렬화 보장
    ['editForm','appendForm'].forEach(fid => {
      const form = document.getElementById(fid);
      if(!form) return;
      form.addEventListener('submit', ()=>{
        const ctx = ctxFromModal(form.closest('.modal'));
        recalc(ctx);
      });
    });
  </script>
</body>
</html>
