<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="pageSize" value="10" />
<c:set var="currentPage" value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}" />
<c:set var="totalCount" value="${empty requestScope.totalCount ? 0 : requestScope.totalCount}" />
<c:set var="totalPages" value="${(totalCount + pageSize - 1) / pageSize}" />
<c:set var="shownCount" value="${empty materials ? 0 : fn:length(materials)}" />
<c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}" />
<c:set var="endIndex" value="${shownCount > 0 ? (startIndex + shownCount - 1) : 0}" />
<c:set var="hasPrev" value="${currentPage > 1}" />
<c:set var="hasNext" value="${currentPage < totalPages}" />
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}" />
<c:set var="nextPage" value="${hasNext ? (currentPage + 1) : totalPages}" />
<c:set var="baseUrl" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MEET LOG - 발주</title>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px;">
            <section class="panel">
                <div class="hd">
                    <h1 class="title">재료 목록</h1>
                    <div class="spacer"></div>
                    <div class="hint">주문단위(step)의 배수로만 발주됩니다.</div>
                </div>
                <div class="bd">
                    <div class="table-wrap">
                        <table class="sheet" id="materialsTable">
                            <thead>
                                <tr>
                                    <th style="width: 56px">이미지</th>
                                    <th>재료명</th>
                                    <th style="width: 90px">단위</th>
                                    <th class="cell-num" style="width: 110px">단가</th>
                                    <th class="cell-num" style="width: 120px">주문단위</th>
                                    <th style="width: 140px">수량</th>
                                    <th style="width: 80px">담기</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="m" items="${materials}">
                                    <tr data-id="${m.id}" data-name="${fn:escapeXml(m.name)}" data-unit="${fn:escapeXml(m.unit)}" data-price="${m.unitPrice}" data-step="${empty m.step ? 1 : m.step}" data-img="${m.imgPath}">
                                        <td>
                                            <mytag:image fileName="${m.imgPath}" altText="${m.name}" cssClass="thumb"/>
                                        </td>
                                        <td>${m.name}</td>
                                        <td>${m.unit}</td>
                                        <td class="cell-num"><fmt:formatNumber value="${m.unitPrice}" /></td>
                                        <td class="cell-num"><fmt:formatNumber value="${empty m.step ? 1 : m.step}" /></td>
                                        <td><input class="input" type="number" style="padding: 8px 10px; border-radius: 8px;" inputmode="numeric" min="0" step="${empty m.step ? 1 : m.step}" value="${empty m.step ? 1 : m.step}" aria-label="${fn:escapeXml(m.name)} 수량" /></td>
                                        <td><button type="button" class="btn sm" data-action="add-to-cart">담기</button></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty materials}">
                                    <tr><td colspan="7" style="text-align:center; padding: 48px; color: var(--muted);">발주 가능한 재료가 없습니다.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${totalCount > 0}">
                        <div class="pager" id="mainPager">
                            <div class="left">
                                <span class="info">${startIndex}–${endIndex} / ${totalCount} (페이지 ${currentPage} / <fmt:formatNumber value='${totalPages}' maxFractionDigits='0' />)</span>
                            </div>
                            <div class="right">
                                <div class="btn-group">
                                    <c:url var="firstUrl" value="${baseUrl}"><c:param name="page" value="1" /></c:url>
                                    <c:url var="prevUrl" value="${baseUrl}"><c:param name="page" value="${prevPage}" /></c:url>
                                    <c:url var="nextUrl" value="${baseUrl}"><c:param name="page" value="${nextPage}" /></c:url>
                                    <c:url var="lastUrl" value="${baseUrl}"><c:param name="page" value="${totalPages}" /></c:url>
                                    
                                    <a class="btn sm" href="${firstUrl}" aria-disabled="${not hasPrev}">≪</a>
                                    <a class="btn sm" href="${prevUrl}" aria-disabled="${not hasPrev}">‹</a>
                                    <a class="btn sm" href="${nextUrl}" aria-disabled="${not hasNext}">›</a>
                                    <a class="btn sm" href="${lastUrl}" aria-disabled="${not hasNext}">≫</a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </section>

            <aside class="cart" style="position: sticky; top: 84px;">
                <div class="panel">
                    <div class="hd">
                        <strong class="title">장바구니</strong>
                        <div class="spacer"></div>
                        <button type="button" class="btn sm" data-action="cart-clear">비우기</button>
                    </div>
                    <div class="bd">
                        <div class="cart-empty" style="padding: 48px; text-align: center; color: var(--muted);">담긴 재료가 없습니다.</div>
                        <div class="cart-list" style="display: none; gap: 10px; flex-direction: column;"></div>
                        <div class="cart-total" style="display: none; justify-content: space-between; font-weight: 700; margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border);">
                            <span>합계 (<span class="cart-count">0</span>건)</span>
                            <span><span class="cart-sum">0</span>원</span>
                        </div>
                        <form id="orderForm" method="post" action="${contextPath}/branch/order" style="margin-top: 12px; display: none;">
                            <input type="hidden" name="orderJson" id="orderJson" />
                            <button type="submit" class="btn primary" style="width: 100%;">발주 요청</button>
                        </form>
                    </div>
                </div>
            </aside>
        </div>
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
      var imageUrl = it.img ? ('${contextPath}/images/' + encodeURIComponent(it.img)) : '';
      html += '<div class="cart-item">' +
        (imageUrl ? '<img src="' + imageUrl + '" alt="" style="width:48px;height:48px;border-radius:8px;object-fit:cover;border:1px solid var(--border)">' : '<div style="width:48px;height:48px;border:1px solid var(--border);border-radius:8px;display:grid;place-items:center">📦</div>') +
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
