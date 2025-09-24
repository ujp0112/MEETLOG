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
<c:set var="shownCount" value="${empty orders ? 0 : fn:length(orders)}" />
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
<title>MEET LOG - 발주 기록</title>
<style>
    :root { --bg: #f6faf8; --surface: #ffffff; --border: #e5e7eb; --muted: #6b7280; --title: #0f172a; --primary: #2f855a; --primary-600: #27764f; --ring: #93c5aa; }
    * { box-sizing: border-box; }
    html, body { height: 100%; }
    body { margin: 0; background: var(--bg); color: var(--title); font: 14px/1.45 system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple SD Gothic Neo", "Noto Sans KR", sans-serif; }
    .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
    .panel { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; box-shadow: 0 8px 20px rgba(16, 24, 40, .05); }
    .panel .hd { display: flex; align-items: center; gap: 10px; padding: 16px 18px; border-bottom: 1px solid var(--border); }
    .panel .bd { padding: 16px 18px; }
    .title { margin: 0; font-weight: 800; font-size: 20px; }
    
    /* Table */
    .table-wrap { border: 1px solid var(--border); border-radius: 14px; overflow: auto; background: #fff; }
    table.sheet { width: 100%; border-collapse: separate; border-spacing: 0; min-width: 960px; }
    .sheet thead th { position: sticky; top: 0; background: #fff; border-bottom: 1px solid var(--border); font-weight: 800; text-align: left; padding: 12px 10px; font-size: 13px; }
    .sheet tbody td { padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
    .cell-num { text-align: right; }
    .thumb { width: 44px; height: 44px; border-radius: 8px; border: 1px solid var(--border); object-fit: cover; background: #fafafa; display: block; }
    .empty-row td { text-align: center; color: var(--muted); padding: 24px; }

    /* Button */
    .btn { appearance: none; border: 1px solid var(--border); background: #fff; padding: 8px 12px; border-radius: 10px; font-weight: 700; cursor: pointer; text-decoration: none; color:#111827; display: inline-flex; align-items: center; justify-content: center; }
    .btn:hover { background: #f8fafc; }
    .btn.sm { padding: 6px 8px; border-radius: 8px; }
    .btn[aria-disabled="true"], .btn:disabled { opacity: .5; cursor: not-allowed; }

    /* Badge */
    .badge { display: inline-block; padding: 2px 8px; border-radius: 999px; border: 1px solid transparent; font-size: 12px; font-weight: 700; }
    .status-pending { background: #f1f5f9; color: #475569; border-color: #e2e8f0; } /* 요청중/미검 */
    .status-approved { background: #ecfdf5; color: #065f46; border-color: #a7f3d0; } /* 검수완료 */
    .status-received { background: #eff6ff; color: #1e40af; border-color: #bfdbfe; } /* 입고완료 */
    
    /* Pager */
    .pager { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-top: 10px; }
    .pager .left, .pager .right { display: flex; align-items: center; gap: 8px; }
    .pager .btn-group { display: flex; gap: 6px; }
    .pager .info { font-size: 12px; color: var(--muted); }

    /* Modal */
    .modal { position: fixed; inset: 0; background: rgba(2, 6, 23, .6); display: none; align-items: center; justify-content: center; z-index: 60; }
    .modal.show { display: flex; }
    .dialog { width: min(980px, calc(100% - 24px)); max-height: min(88vh, 900px); display: grid; grid-template-rows: auto 1fr auto; background: #fff; border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 30px 80px rgba(2, 6, 23, .35); overflow: hidden; }
    .dialog .hd { display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; border-bottom: 1px solid var(--border); }
    .dialog .bd { padding: 12px 16px; overflow: auto; }
    .dialog .ft { display: flex; align-items: center; justify-content: flex-end; gap: 8px; padding: 10px 16px; border-top: 1px solid var(--border); }
    .close-x { border: 0; background: transparent; font-size: 22px; cursor: pointer; }
</style>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf" %>
    <div class="container">
        <section class="panel">
            <div class="hd">
                <h1 class="title" id="pageTitle">발주 기록</h1>
            </div>
 
            <div class="bd">
                <div class="table-wrap">
                    <table class="sheet" id="ordersHistoryTable">
                        <thead>
                            <tr>
                                <th style="width: 120px">발주 No.</th>
                                <th>품명</th>
                                <th class="cell-num" style="width: 120px">총 가격</th>
                                <th style="width: 140px">발주일</th>
                                <th style="width: 120px">상태</th>
                                <th style="width: 160px">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr data-id="${o.id}" data-status="${fn:escapeXml(o.status)}">
                                    <td>#<c:out value='${o.id}' /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.itemCount > 1}">${o.mainItemName} 외 ${o.itemCount - 1}건</c:when>
                                            <c:otherwise>${o.mainItemName}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="cell-num"><fmt:formatNumber value="${o.totalPrice}" />원</td>
                                    <td><fmt:formatDate value="${o.orderedAt}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status eq 'APPROVED'}"><span class="badge status-approved">검수완료</span></c:when>
                                            <c:when test="${o.status eq 'RECEIVED'}"><span class="badge status-received">입고완료</span></c:when>
                                            <c:otherwise><span class="badge status-pending">요청중</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 6px;">
                                            <button type="button" class="btn sm" data-action="open-detail" data-id="${o.id}">상세보기</button>
                                            <c:if test="${o.status eq 'APPROVED'}">
                                                <button type="button" class="btn sm" data-action="receive" data-id="${o.id}">입고처리</button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
            
                            <c:if test="${empty orders}">
                                <tr class="empty-row"><td colspan="6">발주 기록이 없습니다.</td></tr>
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
    </div>

    <div id="detailModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
        <div class="dialog">
            <div class="hd">
                <div>
                    <strong>발주 상세</strong> · <span id="modalMeta" class="badge status-pending"></span>
                </div>
                <button class="close-x" type="button" data-action="close-modal">×</button>
            </div>
            <div class="bd">
                <div class="table-wrap">
                    <table class="sheet" id="detailTable">
                        <thead>
                            <tr>
                                <th style="width: 60px">사진</th>
                                <th>품명</th>
                                <th class="cell-num" style="width: 140px">품목별 총가격</th>
                                <th class="cell-num" style="width: 160px">발주량</th>
                                <th style="width: 120px">상태</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="pager" id="detailPager" style="display: none;">
                    <div class="left">
                        <div class="btn-group">
                            <button type="button" class="btn sm" data-role="first">≪</button>
                            <button type="button" class="btn sm" data-role="prev">‹</button>
                            <button type="button" class="btn sm" data-role="next">›</button>
                            <button type="button" class="btn sm" data-role="last">≫</button>
                        </div>
                        <span class="info" id="detailPageInfo"></span>
                    </div>
                </div>
            </div>
            <div class="ft">
                <button type="button" class="btn" data-action="close-modal">닫기</button>
            </div>
        </div>
    </div>

    <script>
    (function(){
      var nf = new Intl.NumberFormat('ko-KR');
      var ctx = '${contextPath}';
      var modal = document.getElementById('detailModal');
      var tbody = document.querySelector('#detailTable tbody');
      var pager = document.getElementById('detailPager');
      var pageInfo = document.getElementById('detailPageInfo');
      var metaEl = document.getElementById('modalMeta');
      var state = { orderId:null, page:1, size:5, total:0, totalPages:1 };
      
      document.addEventListener('click', function(e){
        var openBtn = e.target.closest('button[data-action="open-detail"]');
        if(openBtn){
          var id = openBtn.getAttribute('data-id');
          state.orderId = id;
          state.page = 1;
          metaEl.textContent = '#' + id;
          modal.classList.add('show');
          modal.setAttribute('aria-hidden','false');
          loadPage(1);
          return;
        }

        var closeBtn = e.target.closest('[data-action="close-modal"]');
        if(closeBtn){ closeModal(); }
        
        var receiveBtn = e.target.closest('button[data-action="receive"]');
        if(receiveBtn) {
            if(!confirm('해당 발주를 입고 처리하시겠습니까? 재고가 즉시 증가합니다.')) return;
            var orderId = receiveBtn.getAttribute('data-id');
            var url = ctx + '/branch/orders/' + orderId + '/receive';
            
            receiveBtn.disabled = true;
            receiveBtn.textContent = '처리 중...';
            
            fetch(url, { method: 'POST' })
                .then(res => {
                    if (!res.ok) throw new Error('Network response was not ok.');
                    return res.json();
                })
                .then(data => {
                    if (data.success) {
                        alert('입고 처리가 완료되었습니다.');
                        window.location.reload();
                    } else {
                        throw new Error(data.message || 'Server returned an error.');
                    }
                })
                .catch(err => {
                    console.error('Fetch error:', err);
                    alert('오류가 발생했습니다: ' + err.message);
                    receiveBtn.disabled = false;
                    receiveBtn.textContent = '입고 처리';
                });
        }
      });

      modal.addEventListener('click', function(e){ if(e.target===modal) closeModal(); });
      document.addEventListener('keydown', function(e){ if(e.key==='Escape' && modal.classList.contains('show')) closeModal(); });
      
      function closeModal(){
        modal.classList.remove('show');
        modal.setAttribute('aria-hidden','true');
        tbody.innerHTML = '';
      }

      pager.querySelector('[data-role="first"]').addEventListener('click', function(){ loadPage(1); });
      pager.querySelector('[data-role="prev"]').addEventListener('click', function(){ loadPage(Math.max(1, state.page-1)); });
      pager.querySelector('[data-role="next"]').addEventListener('click', function(){ loadPage(Math.min(state.totalPages, state.page+1)); });
      pager.querySelector('[data-role="last"]').addEventListener('click', function(){ loadPage(state.totalPages); });
      
      function loadPage(page){
        if(!state.orderId) return;
        state.page = page;
        tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:var(--muted)">불러오는 중...</td></tr>';
        
        var url = ctx + '/branch/orders/' + encodeURIComponent(state.orderId) + '/details?page=' + page + '&size=' + state.size;
        fetch(url, { headers:{'Accept':'application/json'} })
          .then(r => { if(!r.ok) throw new Error('Network Error'); return r.json(); })
          .then(data => {
            var items = Array.isArray(data.items) ? data.items : [];
            state.total = Number(data.totalCount || items.length) || 0;
            state.page = Number(data.page || page) || 1;
            state.totalPages = Math.max(1, Math.ceil(state.total/state.size));
            renderRows(items);
            renderPager();
          })
          .catch(err => {
            tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#ef4444">상세를 불러오지 못했습니다.</td></tr>';
            pageInfo.textContent = '';
            pager.style.display = 'none';
            console.error(err);
          });
      }

      function renderRows(items){
          if(!items.length){
            tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:var(--muted)">표시할 품목이 없습니다.</td></tr>';
            return;
          }
          var html = items.map(it => {
            var name = it.materialName || '';
            var unit = it.unit || '';
            var qty = Number(it.qty || 0);
            var unitPrice = Number(it.unitPrice || 0);
            var total = Math.round(unitPrice*qty);
            var status = it.status || 'REQUESTED';
            
            var badgeHtml;
            if (status === 'APPROVED') {
                badgeHtml = '<span class="badge status-approved">검수완료</span>';
            } else if (status === 'RECEIVED') {
                badgeHtml = '<span class="badge status-received">입고완료</span>';
            } else {
                badgeHtml = '<span class="badge status-pending">요청중</span>';
            }

            var imgTag = it.imgPath 
                ? `<mytag:image fileName="\${it.imgPath}" altText="\${escapeHtml(name)}" cssClass="thumb"/>` // Custom tag usage is tricky in JS
                : `<span class="thumb" style="display:grid;place-items:center">📦</span>`;
            
            // For now, use simple img tag in JS, as JSP custom tags can't be processed here.
            var imageUrl = it.imgPath ? `${ctx}/images/${encodeURIComponent(it.imgPath)}` : '';
            var imgHtml = imageUrl 
                ? `<img class="thumb" src="${imageUrl}" alt="${escapeHtml(name)}">`
                : `<span class="thumb" style="display:grid;place-items:center;font-size:24px;">📦</span>`;

            return `<tr>
                      <td>${imgHtml}</td>
                      <td>${escapeHtml(name)}</td>
                      <td class="cell-num">${nf.format(total)}원</td>
                      <td class="cell-num">${nf.format(qty)} <span style="color:var(--muted)">${escapeHtml(unit)}</span></td>
                      <td>${badgeHtml}</td>
                    </tr>`;
          }).join('');
          tbody.innerHTML = html;
      }
      
      function renderPager(){
        if(state.total <= state.size) {
            pager.style.display = 'none';
            return;
        }
        pager.style.display = 'flex';
        var start = (state.page - 1) * state.size + 1;
        var end = Math.min(state.page * state.size, state.total);
        pageInfo.textContent = `${start}–${end} / ${state.total} (페이지 ${state.page} / ${state.totalPages})`;
        pager.querySelector('[data-role="first"]').disabled = state.page <= 1;
        pager.querySelector('[data-role="prev"]').disabled  = state.page <= 1;
        pager.querySelector('[data-role="next"]').disabled  = state.page >= state.totalPages;
        pager.querySelector('[data-role="last"]').disabled  = state.page >= state.totalPages;
      }
      
      function escapeHtml(s){ if(s==null) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#039;'); }
    })();
    </script>
</body>
</html>