<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
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
    <title>MEET LOG - 발주</title>
    <style>
        :root { --bg: #f6faf8; --surface: #ffffff; --border: #e5e7eb; --muted: #6b7280; --title: #0f172a; --primary: #2f855a; --primary-600: #27764f; --ring: #93c5aa; --text-muted: #6b7280; }
        * { box-sizing: border-box; }
        html, body { height: 100%; }
        body { margin: 0; background: var(--bg); color: var(--title); font: 14px/1.45 system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple SD Gothic Neo", "Noto Sans KR", sans-serif; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .panel { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; box-shadow: 0 8px 20px rgba(16, 24, 40, .05); }
        .panel .hd { display: flex; align-items: center; gap: 10px; padding: 16px 18px; border-bottom: 1px solid var(--border); }
        .panel .bd { padding: 16px 18px; }
        .title { margin: 0; font-weight: 800; font-size: 20px; }
        .spacer { flex: 1 1 auto; }
        .hint { color: var(--muted); font-size: 12px; }
        
        /* Layout */
        .order-layout { display: grid; grid-template-columns: minmax(0, 2fr) minmax(320px, 1fr); gap: 24px; align-items: flex-start; }
        @media (max-width: 960px) { .order-layout { grid-template-columns: 1fr; } }
        .cart-aside { position: sticky; top: 20px; }

        /* Table */
        .table-wrap { border: 1px solid var(--border); border-radius: 14px; overflow: auto; background: #fff; }
        table.sheet { width: 100%; border-collapse: separate; border-spacing: 0; min-width: 500px; }
        .sheet thead th { position: sticky; top: 0; background: #fff; border-bottom: 1px solid var(--border); font-weight: 800; text-align: left; padding: 12px 10px; font-size: 13px; }
        .sheet tbody td { padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .cell-num { text-align: right; }
        .thumb { width: 40px; height: 40px; border-radius: 8px; border: 1px solid var(--border); object-fit: cover; background: #fafafa; display: block; }
        .empty-row td { text-align: center; padding: 24px; color: var(--muted); }

        /* Input & Button */
        .input { width: 100%; padding: 8px 10px; border: 1px solid var(--border); border-radius: 8px; background: #fff; outline: 0; font-size: 14px; }
        .btn { display: inline-flex; align-items: center; justify-content: center; appearance: none; border: 1px solid var(--border); background: #fff; padding: 8px 12px; border-radius: 10px; font-weight: 700; cursor: pointer; text-decoration: none; color: #111827; }
        .btn:hover { background: #f8fafc; }
        .btn.primary { background: var(--primary); border-color: var(--primary); color: #fff; }
        .btn.primary:hover { background: var(--primary-600); }
        .btn.sm { padding: 6px 8px; border-radius: 8px; }
        .btn.danger { color: #b91c1c; border-color: #fecaca; }
        .btn.danger:hover { background: #fff1f2; border-color: #fca5a5; }
        .btn[aria-disabled="true"], .btn:disabled { opacity: .5; cursor: not-allowed; }
        
        /* Cart */
        .cart-list { display: grid; gap: 12px; max-height: 400px; overflow: auto; padding: 2px; }
        .cart-item { display: grid; grid-template-columns: 48px 1fr auto; align-items: center; gap: 12px; font-size: 13px; border: 1px solid var(--border); border-radius: 12px; padding: 8px; }
        .cart-item .meta { display: grid; gap: 2px; }
        .cart-item .meta strong { font-size: 14px; }
        .cart-item .actions { display: grid; gap: 6px; justify-items: end; }
        .qty-ctrl { display: flex; align-items: center; }
        .qty-ctrl .input { text-align: center; width: 60px; height: 32px; padding: 4px; border-radius: 6px; }
        .qty-ctrl .btn { height: 32px; width: 32px; padding: 0; }
        .cart-total { display: flex; justify-content: space-between; font-weight: 700; font-size: 16px; margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border); }
        .cart-empty { padding: 48px; text-align: center; color: var(--text-muted); border: 1px dashed var(--border); border-radius: 12px; }

        /* Pager */
        .pager { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-top: 10px; }
        .pager .left, .pager .right { display: flex; align-items: center; gap: 8px; }
        .pager .info { font-size: 12px; color: var(--muted); }
        .pager .btn-group { display: flex; gap: 6px; }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <div class="container">
        <div class="order-layout">
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
                                    <th style="width: 72px">이미지</th>
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
                                        <td><input class="input" type="number" inputmode="numeric" min="0" step="${empty m.step ? 1 : m.step}" value="${empty m.step ? 1 : m.step}" aria-label="${fn:escapeXml(m.name)} 수량" /></td>
                                        <td><button type="button" class="btn sm primary" data-action="add-to-cart">담기</button></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty materials}">
                                    <tr class="empty-row"><td colspan="7">발주 가능한 재료가 없습니다.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${totalCount > 0}">
                        <div class="pager" id="materialsPager">
                            <div class="left">
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
                            <div class="right">
                                <span class="info">${startIndex}–${endIndex} / ${totalCount} (페이지 ${currentPage} / <fmt:formatNumber value='${totalPages}' maxFractionDigits='0' />)</span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </section>
            
            <aside class="cart-aside">
                <div class="panel">
                    <div class="hd">
                        <strong class="title">장바구니</strong>
                        <div class="spacer"></div>
                        <button type="button" class="btn sm" data-action="cart-clear">비우기</button>
                    </div>
                    <div class="bd">
                        <div class="cart-empty">담긴 재료가 없습니다.</div>
                        <div class="cart-list" style="display: none;"></div>
                        <div class="cart-total" style="display: none;">
                            <span>합계 (<span class="cart-count">0</span>건)</span>
                            <span><span class="cart-sum">0</span>원</span>
                        </div>
                        <form id="orderForm" method="post" action="${contextPath}/orderForm" style="margin-top: 16px; display: none;">
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
      var cart = new Map();
      var cartList = document.querySelector('.cart-list');
      var cartEmpty = document.querySelector('.cart-empty');
      var cartTotal = document.querySelector('.cart-total');
      var cartCountEl = document.querySelector('.cart-count');
      var cartSumEl = document.querySelector('.cart-sum');
      var orderForm = document.getElementById('orderForm');
      var orderJson = document.getElementById('orderJson');
      
      function toNumber(v){ if(typeof v==='number') return v; if(!v) return 0; return Number(String(v).replace(/[^0-9.-]/g,''))||0; }
      function stepFix(qty, step){ step = step>0? step : 1; if(qty<=0) return 0; var k = Math.ceil(qty/step); return k*step; }
      
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
      
      document.addEventListener('click', function(e){
        var btn = e.target.closest('button[data-action="cart-clear"]');
        if(!btn) return;
        if(!confirm('장바구니를 비울까요?')) return;
        cart.clear();
        renderCart();
      });

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
            var imageUrl = it.img ? ('${contextPath}/images/' + encodeURIComponent(it.img)) : 'https://placehold.co/80x80/e0e7ff/4338ca?text=No+Img';
            html += '<div class="cart-item">' +
              '<img src="' + imageUrl + '" alt="' + escapeHtml(it.name) + '" class="thumb" style="width: 48px; height: 48px;">' +
            '<div class="meta">' +
              '<div><strong>' + escapeHtml(it.name) + '</strong> <span class="hint">(' + escapeHtml(it.unit) + ')</span></div>' +
              '<div class="hint">단가 ' + nf.format(toNumber(it.unitPrice)) + '원</div>' +
            '</div>' +
            '<div class="actions">' +
               '<div class="qty-ctrl">' +
                '<button type="button" class="btn sm" data-act="dec" data-id="' + it.id + '">−</button>' +
                '<input class="input" data-role="qty-input" data-id="' + it.id + '" type="number" min="0" step="' + (toNumber(it.step)||1) + '" value="' + toNumber(it.quantity) + '">' +
                '<button type="button" class="btn sm" data-act="inc" data-id="' + it.id + '">+</button>' +
              '</div>' +
               '<div><strong>' + nf.format(sub) + '</strong>원 <button type="button" class="btn sm danger" data-act="del" data-id="' + it.id + '">삭제</button></div>' +
            '</div>' +
          '</div>';
        }
        cartList.innerHTML = html;
        cartCountEl.textContent = String(arr.length);
        cartSumEl.textContent = nf.format(Math.round(sum));
        orderJson.value = JSON.stringify(arr);
      }
      
      orderForm.addEventListener('submit', function(e){
        if(cart.size === 0) {
            alert('장바구니가 비어있습니다.');
            e.preventDefault();
            return;
        }
        orderJson.value = JSON.stringify(Array.from(cart.values()));
        alert('발주 요청이 접수되었습니다.'); // For demonstration
      });
      
      function escapeHtml(s){ if(s==null) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#039;'); }
    })();
    </script>
</body>
</html>