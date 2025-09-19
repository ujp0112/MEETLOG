<!-- File: webapp/branch/order.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- 서버사이드 페이징: pageSize 고정 10. 컨트롤러가 materials(현재 페이지 목록), totalCount(전체 건수), page(현재 페이지)를 세팅해주는 것을 가정. -->
<c:set var="pageSize" value="10" />
<c:set var="currentPage"
	value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}" />
<c:if test="${currentPage lt 1}">
	<c:set var="currentPage" value="1" />
</c:if>
<c:set var="totalCount"
	value="${empty requestScope.totalCount ? 0 : requestScope.totalCount}" />
<c:set var="totalPages"
	value="${(totalCount + pageSize - 1) / pageSize}" />
<c:if test="${totalPages lt 1}">
	<c:set var="totalPages" value="1" />
</c:if>
<c:set var="shownCount"
	value="${empty materials ? 0 : fn:length(materials)}" />
<c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}" />
<c:set var="endIndex"
	value="${shownCount > 0 ? (startIndex + shownCount - 1) : 0}" />
<c:set var="showStart" value="${shownCount > 0 ? startIndex : 0}" />
<c:set var="showEnd" value="${shownCount > 0 ? endIndex : 0}" />
<c:set var="hasPrev" value="${currentPage gt 1}" />
<c:set var="hasNext" value="${currentPage lt totalPages}" />
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}" />
<c:set var="nextPage"
	value="${hasNext ? (currentPage + 1) : totalPages}" />
<c:set var="baseUrl" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - order</title>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap"
	rel="stylesheet">
<style>
:root{--bg:#f6faf8;--surface:#ffffff;--border:#e5e7eb;--muted:#6b7280;--title:#0f172a;--primary:#2f855a;--primary-600:#27764f;--ring:#93c5aa}
html,body{height:100%}
body{margin:0;background:var(--bg);color:var(--title);font:14px/1.45 system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,"Apple SD Gothic Neo","Noto Sans KR",sans-serif}
.panel{max-width:1100px;background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 20px rgba(16,24,40,.05);margin:20px auto;}
.panel .hd{display:flex;align-items:center;gap:10px;padding:16px 18px;border-bottom:1px solid var(--border)}
.panel .bd{padding:16px 18px}
.title{margin:0;font-size:20px;font-weight:800}
.pill{padding:6px 10px;border-radius:999px;background:#eef7f0;border:1px solid #ddeee1;color:#246b45;font-weight:700}
.field{display:flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--border);border-radius:10px;padding:8px 10px}
.field>input{border:0;outline:0;min-width:220px}
.btn{appearance:none;border:1px solid var(--border);background:#fff;padding:10px 14px;border-radius:999px;font-weight:700;cursor:pointer;text-decoration:none;color:#111827}
.btn:hover{background:#f8fafc}
.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px}
@media (max-width:980px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media (max-width:640px){.grid{grid-template-columns:1fr}}
.card{display:flex;flex-direction:column;border:1px solid var(--border);border-radius:14px;overflow:hidden;background:#fff;cursor:pointer}
.card .thumb{width:100%;aspect-ratio:16/10;object-fit:cover;background:#f3f4f6}
.card .body{padding:12px 14px;display:grid;gap:8px}
.card .name{font-weight:800}
.card .meta{display:flex;justify-content:space-between;color:#374151}
.switch{display:inline-flex;align-items:center;gap:10px}
.switch input{position:absolute;opacity:0;width:0;height:0}
.switch .track{width:44px;height:24px;border-radius:999px;background:#e5e7eb;position:relative;transition:.2s}
.switch .dot{position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;background:#fff;box-shadow:0 1px 3px rgba(0,0,0,.15);transition:.2s}
.switch input:checked + .track{background:var(--primary)}
.switch input:checked + .track .dot{transform:translateX(20px)}
.badge{padding:2px 8px;border-radius:999px;font-weight:700;font-size:12px;border:1px solid var(--border)}
.badge.on{color:#065f46;background:#ecfdf5;border-color:#a7f3d0}
.badge.off{color:#991b1b;background:#fef2f2;border-color:#fecaca}
.empty{color:var(--muted);text-align:center;padding:24px}

/* Popover (가운데 뜨는 경량 모달) */
.popover-mask{position:fixed;inset:0;background:rgba(0,0,0,.35);display:none;align-items:center;justify-content:center;z-index:200}
.popover-mask.show{display:flex}
.popover{width:100%;max-width:560px;background:#fff;border:1px solid var(--border);border-radius:16px;box-shadow:0 10px 30px rgba(0,0,0,.2)}
.popover .hd{display:flex;align-items:center;justify-content:space-between;padding:12px 14px;border-bottom:1px solid var(--border)}
.popover .bd{padding:12px 14px}
.close-x{border:0;background:transparent;font-size:22px;cursor:pointer}
.table-wrap{border:1px solid var(--border);border-radius:12px;overflow:hidden;background:#fff}
table.sheet{width:100%;border-collapse:separate;border-spacing:0}
.sheet thead th{background:#fff;border-bottom:1px solid var(--border);font-weight:800;text-align:left;padding:10px}
.sheet tbody td{padding:10px;border-bottom:1px solid #f1f5f9}
.cell-num{text-align:right}
.total{display:flex;justify-content:flex-end;gap:8px;margin-top:8px}
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

* {
	box-sizing: border-box
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

.container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px
}

.panel {
	background: var(- -surface);
	border: 1px solid var(- -border);
	border-radius: 16px;
	box-shadow: 0 8px 20px rgba(16, 24, 40, .05)
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
	font-weight: 800;
	font-size: 20px
}

.grid {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 18px
}

@media ( max-width : 980px) {
	.grid {
		grid-template-columns: 1fr
	}
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
	min-width: 720px
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

.cell-num {
	text-align: right
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

.btn {
	appearance: none;
	border: 1px solid var(- -border);
	background: #fff;
	padding: 8px 12px;
	border-radius: 10px;
	font-weight: 700;
	cursor: pointer;
	text-decoration: none;
	align-items: center;
}

.btn:hover {
	background: #f8fafc
}

.btn.primary {
	background: var(--primary);
	border-color: var(--primary);
	display:flex;
	color: #fff;
	align-items:center;
}

.btn.primary:hover {
	background: var(- -primary-600)
}

.btn.sm {
	padding: 6px 8px;
	border-radius: 8px
}

.btn[aria-disabled="true"], .btn:disabled {
	opacity: .5;
	cursor: not-allowed
}

.badge {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 999px;
	border: 1px solid var(- -border);
	font-size: 12px
}

.badge.na {
	background: #f8fafc;
	color: #334155
}

.badge.ok {
	background: #ecfdf5;
	color: #065f46;
	border-color: #a7f3d0
}

.badge.rcv {
	background: #eff6ff;
	color: #1e40af;
	border-color: #bfdbfe
}

.cart {
	position: sticky;
	top: 16px
}

.cart .hd {
	display: flex;
	align-items: center;
	justify-content: space-between
}

.cart-empty {
	border: 1px dashed var(- -border);
	border-radius: 12px;
	padding: 18px;
	color: var(- -muted);
	text-align: center
}

.cart-list {
	display: grid;
	gap: 10px;
	max-height: 360px;
	overflow: auto;
	padding-right: 4px
}

.cart-item {
	display: grid;
	grid-template-columns: 48px 1fr auto;
	gap: 10px;
	align-items: center;
	border: 1px solid var(- -border);
	border-radius: 12px;
	padding: 8px
}

.cart-item .meta {
	display: grid;
	gap: 4px
}

.qty-ctrl {
	display: flex;
	align-items: center;
	gap: 6px
}

.qty-ctrl input {
	width: 88px
}

.cart-total {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-top: 12px;
	padding-top: 10px;
	border-top: 1px solid var(- -border);
	font-weight: 800
}

.hint {
	color: var(- -muted);
	font-size: 12px
}

/* pager */
.pager {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-top: 10px
}

.pager .left, .pager .right {
	display: flex;
	align-items: center;
	gap: 8px
}

.pager .info {
	font-size: 12px;
	color: var(- -muted)
}

.pager .btn-group {
	display: flex;
	gap: 6px
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jspf/branchheader.jspf"%>
	<div class="container">
		<section class="panel">
			<div class="hd">
				<h1 class="title">order</h1>
				<div style="flex: 1 1 auto"></div>
				<div class="hint">주문단위(step)의 배수로만 발주됩니다.</div>
			</div>
			<div class="bd">
				<div class="grid">
					<!-- 재료 목록 -->
					<div>
						<div class="table-wrap" role="region" aria-label="재료 목록">
							<table class="sheet" role="grid" id="materialsTable">
								<thead>
									<tr>
										<th style="width: 56px">이미지</th>
										<th>재료명</th>
										<th style="width: 90px">단위</th>
										<th style="width: 110px">단가</th>
										<th style="width: 120px">주문단위</th>
										<th style="width: 140px">수량</th>
										<th style="width: 80px">담기</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="m" items="${materials}">
										<tr data-id="${m.id}" data-name="${fn:escapeXml(m.name)}"
											data-unit="${fn:escapeXml(m.unit)}"
											data-price="${m.unitPrice}"
											data-step="${empty m.step ? 1 : m.step}"
											data-img="${m.imgPath}">
											<td><c:choose>
													<c:when test="${not empty m.imgPath}">
														<img class="thumb" src="${contextPath}${m.imgPath}"
															alt="${fn:escapeXml(m.name)}" />
													</c:when>
													<c:otherwise>
														<span class="thumb"
															style="display: grid; place-items: center">🥬</span>
													</c:otherwise>
												</c:choose></td>
											<td>${m.name}</td>
											<td>${m.unit}</td>
											<td class="cell-num"><fmt:formatNumber
													value="${m.unitPrice}" /></td>
											<td class="cell-num"><fmt:formatNumber
													value="${empty m.step ? 1 : m.step}" /></td>
											<td><input class="input" type="number"
												inputmode="numeric" min="0"
												step="${empty m.step ? 1 : m.step}"
												value="${empty m.step ? 1 : m.step}"
												aria-label="${fn:escapeXml(m.name)} 수량" /></td>
											<td><button type="button" class="btn sm"
													data-action="add-to-cart">담기</button></td>
										</tr>
									</c:forEach>

									<c:if test="${empty materials}">
										<!-- 페이지에 재료가 없습니다. 서버에서 totalCount와 page를 확인하세요. -->
										<!-- <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:18px">표시할 재료가 없습니다.</td></tr> -->
										<!-- MOCK 데이터 -->
										<tr data-id="m1" data-name="로메인" data-unit="kg"
											data-price="4500" data-step="5" data-img="">
											<td><span class="thumb"
												style="display: grid; place-items: center">🥬</span></td>
											<td>로메인</td>
											<td>kg</td>
											<td class="cell-num">4,500</td>
											<td class="cell-num">5</td>
											<td><input class="input" type="number" min="0" step="5"
												value="5" /></td>
											<td><button type="button" class="btn sm"
													data-action="add-to-cart">담기</button></td>
										</tr>
										<tr data-id="m2" data-name="방울토마토" data-unit="팩"
											data-price="3200" data-step="10" data-img="">
											<td><span class="thumb"
												style="display: grid; place-items: center">🍅</span></td>
											<td>방울토마토</td>
											<td>팩</td>
											<td class="cell-num">3,200</td>
											<td class="cell-num">10</td>
											<td><input class="input" type="number" min="0" step="10"
												value="10" /></td>
											<td><button type="button" class="btn sm"
													data-action="add-to-cart">담기</button></td>
										</tr>
										<tr data-id="m3" data-name="닭가슴살" data-unit="kg"
											data-price="8700" data-step="4" data-img="">
											<td><span class="thumb"
												style="display: grid; place-items: center">🍗</span></td>
											<td>닭가슴살</td>
											<td>kg</td>
											<td class="cell-num">8,700</td>
											<td class="cell-num">4</td>
											<td><input class="input" type="number" min="0" step="4"
												value="4" /></td>
											<td><button type="button" class="btn sm"
													data-action="add-to-cart">담기</button></td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>

						<!-- 서버사이드 페이저: pageSize=10 고정, 다른 쿼리스트링은 보존 -->
						<div class="pager" id="materialsPager"
							aria-label="재료 목록 페이지 네비게이션">
							<div class="left">
								<div class="btn-group">
									<!-- First -->
									<c:url var="firstUrl" value="${baseUrl}">
										<c:forEach var="entry" items="${paramValues}">
											<c:if test="${entry.key ne 'page'}">
												<c:param name="${entry.key}" value="${entry.value[0]}" />
											</c:if>
										</c:forEach>
										<c:param name="page" value="1" />
									</c:url>
									<c:choose>
										<c:when test="${hasPrev}">
											<a class="btn sm" href="${firstUrl}" aria-label="첫 페이지">≪</a>
										</c:when>
										<c:otherwise>
											<span class="btn sm" aria-disabled="true">≪</span>
										</c:otherwise>
									</c:choose>

									<!-- Prev -->
									<c:url var="prevUrl" value="${baseUrl}">
										<c:forEach var="entry" items="${paramValues}">
											<c:if test="${entry.key ne 'page'}">
												<c:param name="${entry.key}" value="${entry.value[0]}" />
											</c:if>
										</c:forEach>
										<c:param name="page" value="${prevPage}" />
									</c:url>
									<c:choose>
										<c:when test="${hasPrev}">
											<a class="btn sm" href="${prevUrl}" aria-label="이전 페이지">‹</a>
										</c:when>
										<c:otherwise>
											<span class="btn sm" aria-disabled="true">‹</span>
										</c:otherwise>
									</c:choose>

									<!-- Next -->
									<c:url var="nextUrl" value="${baseUrl}">
										<c:forEach var="entry" items="${paramValues}">
											<c:if test="${entry.key ne 'page'}">
												<c:param name="${entry.key}" value="${entry.value[0]}" />
											</c:if>
										</c:forEach>
										<c:param name="page" value="${nextPage}" />
									</c:url>
									<c:choose>
										<c:when test="${hasNext}">
											<a class="btn sm" href="${nextUrl}" aria-label="다음 페이지">›</a>
										</c:when>
										<c:otherwise>
											<span class="btn sm" aria-disabled="true">›</span>
										</c:otherwise>
									</c:choose>

									<!-- Last -->
									<c:url var="lastUrl" value="${baseUrl}">
										<c:forEach var="entry" items="${paramValues}">
											<c:if test="${entry.key ne 'page'}">
												<c:param name="${entry.key}" value="${entry.value[0]}" />
											</c:if>
										</c:forEach>
										<c:param name="page" value="${totalPages}" />
									</c:url>
									<c:choose>
										<c:when test="${hasNext}">
											<a class="btn sm" href="${lastUrl}" aria-label="마지막 페이지">≫</a>
										</c:when>
										<c:otherwise>
											<span class="btn sm" aria-disabled="true">≫</span>
										</c:otherwise>
									</c:choose>
								</div>
								<span class="info" aria-live="polite"> <c:choose>
										<c:when test="${totalCount gt 0}">
                      ${showStart}–${showEnd} / ${totalCount} (페이지 ${currentPage} / <fmt:formatNumber
												value="${totalPages}" maxFractionDigits="0" />)
                    </c:when>
										<c:otherwise>0 / 0 (페이지 1 / 1)</c:otherwise>
									</c:choose>
								</span>
							</div>
							<div class="right">
								<span class="info">페이지당 10건</span>
							</div>
						</div>
					</div>

					<!-- 장바구니 -->
					<aside class="cart">
						<div class="panel">
							<div class="hd">
								<strong>장바구니</strong>
								<button type="button" class="btn sm" data-action="cart-clear">비우기</button>
							</div>
							<div class="bd">
								<div class="cart-empty">담긴 재료가 없습니다.</div>
								<div class="cart-list" style="display: none"></div>
								<div class="cart-total" style="display: none">
									<span>합계 (<span class="cart-count">0</span>건)
									</span> <span><span class="cart-sum">0</span>원</span>
								</div>
								<form id="orderForm" method="post"
									action="${contextPath}/orderForm"
									style="margin-top: 12px; display: none">
									<input type="hidden" name="orderJson" id="orderJson" />
									<button type="submit" class="btn primary"
        style="width:100%;display:flex;align-items:center;justify-content:center;">
  발주 확인
</button>

								</form>
								<div class="hint" style="margin-top: 8px">확인 시 발주 요청이
									전송됩니다.</div>
							</div>
						</div>
					</aside>
				</div>
			</div>
		</section>
	</div>

	<script>
(function(){
  var nf = new Intl.NumberFormat('ko-KR');
  var cart = new Map(); // key: materialId, value: item
  var cartList = document.querySelector('.cart-list');
  var cartEmpty = document.querySelector('.cart-empty');
  var cartTotal = document.querySelector('.cart-total');
  var cartCountEl = document.querySelector('.cart-count');
  var cartSumEl = document.querySelector('.cart-sum');
  var orderForm = document.getElementById('orderForm');
  var orderJson = document.getElementById('orderJson');

  function toNumber(v){ if(typeof v==='number') return v; if(!v) return 0; return Number(String(v).replace(/[^0-9.-]/g,''))||0; }
  function stepFix(qty, step){ step = step>0? step : 1; if(qty<=0) return 0; var k = Math.ceil(qty/step); return k*step; }

  // 담기
  document.addEventListener('click', function(e){
    var btn = e.target.closest('button[data-action="add-to-cart"]');
    if(!btn) return;
    var tr = btn.closest('tr');
    var id = tr.getAttribute('data-id');
    var idNum = (/^\d+$/.test(id) ? Number(id) : id);
    var name = tr.getAttribute('data-name');
    var unit = tr.getAttribute('data-unit');
    var price = toNumber(tr.getAttribute('data-price'));
    var step = toNumber(tr.getAttribute('data-step')) || 1;
    var img = tr.getAttribute('data-img') || '';
    var qtyInput = tr.querySelector('input[type="number"]');
    var raw = toNumber(qtyInput && qtyInput.value);
    var qty = stepFix(raw, step);
    if(qty<=0){ alert('수량을 입력하세요.'); return; }
    if(raw !== qty){ qtyInput.value = qty; }

    if(cart.has(id)){
      var old = cart.get(id); old.quantity = toNumber(old.quantity) + qty; cart.set(id, old);
    }else{
      cart.set(id, { id:idNum, name:name, unit:unit, unitPrice:price, step:step, quantity:qty, img:img });
    }
    renderCart();
  });

  // 장바구니 비우기
  document.addEventListener('click', function(e){
    var btn = e.target.closest('button[data-action="cart-clear"]');
    if(!btn) return;
    if(!confirm('장바구니를 비울까요?')) return;
    cart.clear();
    renderCart();
  });

  // 아이템 수량 증감/삭제
  cartList.addEventListener('click', function(e){
    var id = e.target && e.target.getAttribute('data-id');
    if(e.target.matches('button[data-act="inc"]')){ changeQty(id, +1); }
    else if(e.target.matches('button[data-act="dec"]')){ changeQty(id, -1); }
    else if(e.target.matches('button[data-act="del"]')){ cart.delete(id); renderCart(); }
  });

  cartList.addEventListener('change', function(e){
    if(!e.target.matches('input[data-role="qty-input"]')) return;
    var id = e.target.getAttribute('data-id');
    var item = cart.get(id); if(!item) return;
    var q = stepFix(toNumber(e.target.value), toNumber(item.step));
    if(q<=0){ cart.delete(id); } else { item.quantity = q; cart.set(id, item); }
    renderCart();
  });

  function changeQty(id, dir){
    var item = cart.get(id); if(!item) return;
    var st = toNumber(item.step)||1;
    var q = toNumber(item.quantity) + dir*st;
    if(q<=0){ cart.delete(id); } else { item.quantity = q; cart.set(id, item); }
    renderCart();
  }

  function renderCart(){
    var arr = Array.from(cart.values());
    if(arr.length===0){
      cartEmpty.style.display='block';
      cartList.style.display='none';
      cartTotal.style.display='none';
      orderForm.style.display='none';
      orderJson.value='';
      return;
    }
    cartEmpty.style.display='none';
    cartList.style.display='grid';
    cartTotal.style.display='flex';
    orderForm.style.display='block';

    var html = '';
    var sum = 0;
    for(var i=0;i<arr.length;i++){
      var it = arr[i];
      var sub = toNumber(it.unitPrice) * toNumber(it.quantity);
      sum += sub;
      html += '<div class="cart-item">' +
        (it.img ? '<img src="' + '${contextPath}' + it.img + '" alt="" style="width:48px;height:48px;border-radius:8px;object-fit:cover;border:1px solid var(--border)">' : '<div style="width:48px;height:48px;border:1px solid var(--border);border-radius:8px;display:grid;place-items:center">📦</div>') +
        '<div class="meta">' +
          '<div><strong>' + escapeHtml(it.name) + '</strong> <span class="hint">(' + escapeHtml(it.unit) + ')</span></div>' +
          '<div class="hint">단가 ' + new Intl.NumberFormat('ko-KR').format(toNumber(it.unitPrice)) + '원</div>' +
        '</div>' +
        '<div style="display:grid;gap:6px;justify-items:end">' +
          '<div class="qty-ctrl">' +
            '<button type="button" class="btn sm" data-act="dec" data-id="' + it.id + '">−</button>' +
            '<input class="input" data-role="qty-input" data-id="' + it.id + '" type="number" min="0" step="' + (toNumber(it.step)||1) + '" value="' + toNumber(it.quantity) + '">' +
            '<button type="button" class="btn sm" data-act="inc" data-id="' + it.id + '">+</button>' +
          '</div>' +
          '<div><strong>' + new Intl.NumberFormat('ko-KR').format(sub) + '</strong>원 <button type="button" class="btn sm danger" data-act="del" data-id="' + it.id + '">삭제</button></div>' +
        '</div>' +
      '</div>';
    }
    cartList.innerHTML = html;
    cartCountEl.textContent = String(arr.length);
    cartSumEl.textContent = new Intl.NumberFormat('ko-KR').format(Math.round(sum));
    orderJson.value = JSON.stringify(arr);
  }

  // 폼 전송 전 직렬화 보강
  orderForm.addEventListener('submit', function(){ orderJson.value = JSON.stringify(Array.from(cart.values())); });

  // 서버로 fetch 전송(선택), 실패시 폴백 제출
  orderForm.addEventListener('click', function(e){
    var btn = e.target.closest('button[type="submit"]');
    if(!btn) return;
    if(!window.fetch) return; // 구형 브라우저 폴백
    e.preventDefault();
    var url = orderForm.getAttribute('action');
    var payload = { items: Array.from(cart.values()) };
    orderJson.value = JSON.stringify(Array.from(cart.values()));
    const body = new URLSearchParams();
    body.set('orderJson', orderJson.value);
    fetch(url, {
      method: 'POST',
      headers: { 'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8' },
      body: body.toString()
    })
      .then(function(res){ if(!res.ok) throw new Error('서버 오류'); return res.json ? res.json() : res.text(); })
      .then(function(){ alert('발주 요청이 접수되었습니다.'); cart.clear(); renderCart(); })
      .catch(function(){ orderForm.submit(); });
  });

  function escapeHtml(s){ if(s==null) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;').replace(/'/g,'&#039;'); }
})();
</script>

</body>
</html>
