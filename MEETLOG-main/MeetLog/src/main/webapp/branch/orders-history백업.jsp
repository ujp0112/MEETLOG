<!-- File: webapp/branch/orders-history.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- 서버사이드 페이징: pageSize 고정 10. 컨트롤러가 orders(현재 페이지 목록), totalCount(전체 건수), page(현재 페이지) 세팅 가정 -->
<c:set var="pageSize" value="10"/>
<c:set var="currentPage" value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}"/>
<c:if test="${currentPage lt 1}"><c:set var="currentPage" value="1"/></c:if>
<c:set var="totalCount" value="${empty requestScope.totalCount ? 0 : requestScope.totalCount}"/>
<c:set var="totalPages" value="${(totalCount + pageSize - 1) / pageSize}"/>
<c:if test="${totalPages lt 1}"><c:set var="totalPages" value="1"/></c:if>
<c:set var="shownCount" value="${empty orders ? 0 : fn:length(orders)}"/>
<c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}"/>
<c:set var="endIndex" value="${shownCount > 0 ? (startIndex + shownCount - 1) : 0}"/>
<c:set var="showStart" value="${shownCount > 0 ? startIndex : 0}"/>
<c:set var="showEnd" value="${shownCount > 0 ? endIndex : 0}"/>
<c:set var="hasPrev" value="${currentPage gt 1}"/>
<c:set var="hasNext" value="${currentPage lt totalPages}"/>
<c:set var="prevPage" value="${hasPrev ? (currentPage - 1) : 1}"/>
<c:set var="nextPage" value="${hasNext ? (currentPage + 1) : totalPages}"/>
<c:set var="baseUrl" value="${pageContext.request.requestURI}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - 발주 기록</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
:root{--bg:#f6faf8;--surface:#ffffff;--border:#e5e7eb;--muted:#6b7280;--title:#0f172a;--primary:#2f855a;--primary-600:#27764f;--ring:#93c5aa}
*{box-sizing:border-box}
html,body{height:100%}
body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif;background:var(--bg);color:var(--title)}
.container{max-width:1200px;margin:0 auto;padding:20px}
.panel{background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 20px rgba(16,24,40,.05)}
.panel .hd{display:flex;align-items:center;gap:10px;padding:16px 18px;border-bottom:1px solid var(--border)}
.panel .bd{padding:16px 18px}
.title{margin:0;font-weight:800;font-size:20px}

.table-wrap{border:1px solid var(--border);border-radius:14px;overflow:auto;background:#fff}
table.sheet{width:100%;border-collapse:separate;border-spacing:0;min-width:960px}
.sheet thead th{position:sticky;top:0;background:#fff;border-bottom:1px solid var(--border);font-weight:800;text-align:left;padding:12px 10px;font-size:13px}
.sheet tbody td{padding:12px 10px;border-bottom:1px solid #f1f5f9;vertical-align:middle}
.cell-num{text-align:right}

.btn{appearance:none;border:1px solid var(--border);background:#fff;padding:8px 12px;border-radius:10px;font-weight:700;cursor:pointer;text-decoration:none}
.btn:hover{background:#f8fafc}
.btn.primary{background:var(--primary);border-color:var(--primary);color:#fff}
.btn.primary:hover{background:var(--primary-600)}
.btn.sm{padding:6px 8px;border-radius:8px}
.btn[aria-disabled="true"],.btn:disabled{opacity:.5;cursor:not-allowed}
.badge{display:inline-block;padding:2px 8px;border-radius:999px;border:1px solid var(--border);font-size:12px}
.badge.na{background:#f8fafc;color:#334155}
.badge.ok{background:#ecfdf5;color:#065f46;border-color:#a7f3d0}
.badge.rcv{background:#eff6ff;color:#1e40af;border-color:#bfdbfe}

/**** Pager ****/
.pager{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:10px}
.pager .left,.pager .right{display:flex;align-items:center;gap:8px}
.pager .btn-group{display:flex;gap:6px}
.pager .info{font-size:12px;color:var(--muted)}

/* Modal */
.modal{position:fixed;inset:0;background:rgba(2,6,23,.6);display:none;align-items:center;justify-content:center;z-index:60}
.modal.show{display:flex}
.dialog{width:min(980px,calc(100% - 24px));max-height:min(88vh,900px);display:grid;grid-template-rows:auto 1fr auto;background:#fff;border-radius:16px;border:1px solid var(--border);box-shadow:0 30px 80px rgba(2,6,23,.35);overflow:hidden}
.dialog .hd{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--border)}
.dialog .bd{padding:12px 16px;overflow:auto}
.dialog .ft{display:flex;align-items:center;justify-content:flex-end;gap:8px;padding:10px 16px;border-top:1px solid var(--border)}
.close-x{border:0;background:transparent;font-size:22px;cursor:pointer}
.thumb{width:44px;height:44px;border-radius:8px;border:1px solid var(--border);object-fit:cover;background:#fafafa;display:block}
</style>
</head>
<body>
  <jsp:include page="/WEB-INF/jspf/branchheader.jspf" />
  <div class="container">
    <section class="panel">
      <div class="hd">
        <h1 class="title" id="pageTitle">발주 기록</h1>
        <div style="flex:1 1 auto"></div>
      </div>
      <div class="bd">
        <div class="table-wrap" role="region" aria-label="발주 기록 목록">
          <table class="sheet" role="grid" id="ordersHistoryTable">
            <thead>
              <tr>
                <th style="width:120px">발주 No</th>
                <th>품명</th>
                <th style="width:120px">가격</th>
                <th style="width:140px">발주일</th>
                <th style="width:120px">상태</th>
                <th style="width:120px">상세</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="o" items="${orders}">
                <tr data-id="${o.id}" data-status="${fn:escapeXml(o.status)}">
                  <td>#<c:out value='${o.id}'/></td>
                  <td>
                    <c:choose>
                      <c:when test="${o.itemCount gt 1}">${o.mainItemName} 외 ${o.itemCount - 1}건</c:when>
                      <c:otherwise>${o.mainItemName}</c:otherwise>
                    </c:choose>
                  </td>
                  <td class="cell-num"><fmt:formatNumber value="${o.totalPrice}"/></td>
                  <td><fmt:formatDate value="${o.orderDate}" pattern="yyyy-MM-dd"/></td>
                  <td>
                    <c:choose>
                      <c:when test="${o.status eq '검수완'}"><span class="badge ok">검수완</span></c:when>
                      <c:when test="${o.status eq '입고완'}"><span class="badge rcv">입고완</span></c:when>
                      <c:otherwise><span class="badge na">미검</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td><button type="button" class="btn sm" data-action="open-detail" data-id="${o.id}">상세보기</button></td>
                </tr>
              </c:forEach>
              <c:if test="${empty orders}">
                <!-- MOCK: 지점 예시 발주 2건 -->
                <tr data-id="201" data-status="미검" data-mock="1">
                  <td>#201</td>
                  <td>브로콜리 외 1건</td>
                  <td class="cell-num">128,000</td>
                  <td>2025-09-10</td>
                  <td><span class="badge na">미검</span></td>
                  <td><button type="button" class="btn sm" data-action="open-detail" data-id="201">상세보기</button></td>
                </tr>
                <tr data-id="202" data-status="입고완" data-mock="1">
                  <td>#202</td>
                  <td>방울토마토 외 2건</td>
                  <td class="cell-num">214,500</td>
                  <td>2025-09-11</td>
                  <td><span class="badge rcv">입고완</span></td>
                  <td><button type="button" class="btn sm" data-action="open-detail" data-id="202">상세보기</button></td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>

        <!-- Pager for main list -->
        <div class="pager" id="mainPager">
          <div class="left">
            <div class="btn-group">
              <c:url var="firstUrl" value="${baseUrl}">
                <c:forEach var="entry" items="${paramValues}">
                  <c:if test="${entry.key ne 'page'}"><c:param name="${entry.key}" value="${entry.value[0]}"/></c:if>
                </c:forEach>
                <c:param name="page" value="1"/>
              </c:url>
              <c:url var="prevUrl" value="${baseUrl}">
                <c:forEach var="entry" items="${paramValues}">
                  <c:if test="${entry.key ne 'page'}"><c:param name="${entry.key}" value="${entry.value[0]}"/></c:if>
                </c:forEach>
                <c:param name="page" value="${prevPage}"/>
              </c:url>
              <c:url var="nextUrl" value="${baseUrl}">
                <c:forEach var="entry" items="${paramValues}">
                  <c:if test="${entry.key ne 'page'}"><c:param name="${entry.key}" value="${entry.value[0]}"/></c:if>
                </c:forEach>
                <c:param name="page" value="${nextPage}"/>
              </c:url>
              <c:url var="lastUrl" value="${baseUrl}">
                <c:forEach var="entry" items="${paramValues}">
                  <c:if test="${entry.key ne 'page'}"><c:param name="${entry.key}" value="${entry.value[0]}"/></c:if>
                </c:forEach>
                <c:param name="page" value="${totalPages}"/>
              </c:url>
              <c:choose>
                <c:when test="${hasPrev}">
                  <a class="btn sm" href="${firstUrl}">≪</a>
                  <a class="btn sm" href="${prevUrl}">‹</a>
                </c:when>
                <c:otherwise>
                  <span class="btn sm" aria-disabled="true">≪</span>
                  <span class="btn sm" aria-disabled="true">‹</span>
                </c:otherwise>
              </c:choose>
              <c:choose>
                <c:when test="${hasNext}">
                  <a class="btn sm" href="${nextUrl}">›</a>
                  <a class="btn sm" href="${lastUrl}">≫</a>
                </c:when>
                <c:otherwise>
                  <span class="btn sm" aria-disabled="true">›</span>
                  <span class="btn sm" aria-disabled="true">≫</span>
                </c:otherwise>
              </c:choose>
            </div>
            <span class="info">
              <c:choose>
                <c:when test="${totalCount gt 0}">${showStart}–${showEnd} / ${totalCount} (페이지 ${currentPage} / <fmt:formatNumber value='${totalPages}' maxFractionDigits='0'/>)</c:when>
                <c:otherwise>0 / 0 (페이지 1 / 1)</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="right"><span class="info">페이지당 10건</span></div>
        </div>
      </div>
    </section>
  </div>

  <!-- 상세 모달(읽기 전용) -->
  <div id="detailModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="dialog">
      <div class="hd">
        <div><strong>발주 상세</strong> · <span id="modalMeta" class="badge na"></span></div>
        <button class="close-x" type="button" data-action="close-modal">×</button>
      </div>
      <div class="bd">
        <div class="table-wrap" role="region" aria-label="발주 상세">
          <table class="sheet" role="grid" id="detailTable">
            <thead>
              <tr>
                <th style="width:60px">사진</th>
                <th>품명</th>
                <th style="width:140px">품목별 총가격</th>
                <th style="width:160px">발주량</th>
                <th style="width:120px">상태</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
        <div class="pager" id="detailPager">
          <div class="left">
            <div class="btn-group">
              <button type="button" class="btn sm" data-role="first">≪</button>
              <button type="button" class="btn sm" data-role="prev">‹</button>
              <button type="button" class="btn sm" data-role="next">›</button>
              <button type="button" class="btn sm" data-role="last">≫</button>
            </div>
            <span class="info" id="detailPageInfo"></span>
          </div>
          <div class="right"><span class="info">페이지당 10건</span></div>
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

  var state = { orderId:null, page:1, size:10, total:0, totalPages:1, mock:false };

  // open modal
  document.addEventListener('click', function(e){
    var openBtn = e.target.closest('button[data-action="open-detail"]');
    if(openBtn){
      var tr = openBtn.closest('tr');
      var id = openBtn.getAttribute('data-id');
      state.orderId = id;
      state.page = 1;
      state.mock = (tr && tr.getAttribute('data-mock')==='1');
      metaEl.textContent = '#' + id;
      modal.classList.add('show');
      modal.setAttribute('aria-hidden','false');
      loadPage(1);
      return;
    }

    var closeBtn = e.target.closest('[data-action="close-modal"]');
    if(closeBtn){ closeModal(); }
  });

  modal.addEventListener('click', function(e){ if(e.target===modal) closeModal(); });
  document.addEventListener('keydown', function(e){ if(e.key==='Escape' && modal.classList.contains('show')) closeModal(); });

  function closeModal(){
    modal.classList.remove('show');
    modal.setAttribute('aria-hidden','true');
    tbody.innerHTML = '';
  }

  // pager controls
  pager.querySelector('[data-role="first"]').addEventListener('click', function(){ loadPage(1); });
  pager.querySelector('[data-role="prev"]').addEventListener('click', function(){ loadPage(Math.max(1, state.page-1)); });
  pager.querySelector('[data-role="next"]').addEventListener('click', function(){ loadPage(Math.min(state.totalPages, state.page+1)); });
  pager.querySelector('[data-role="last"]').addEventListener('click', function(){ loadPage(state.totalPages); });

  function loadPage(page){
    if(!state.orderId) return;
    state.page = page;
    tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#64748b">불러오는 중...</td></tr>';

    if(state.mock && window.MOCK_BRANCH && MOCK_BRANCH.details[state.orderId]){
      var all = MOCK_BRANCH.details[state.orderId];
      state.total = all.length;
      state.totalPages = Math.max(1, Math.ceil(state.total/state.size));
      var start = (page-1)*state.size;
      renderRows(all.slice(start, start+state.size));
      renderPager();
      return;
    }

    var url = ctx + '/branch/orders/' + encodeURIComponent(state.orderId) + '/details?page=' + page + '&size=' + state.size;
    fetch(url, { headers:{'Accept':'application/json'} })
      .then(function(r){ if(!r.ok) throw new Error('net'); return r.json(); })
      .then(function(data){
        var items = Array.isArray(data.items) ? data.items : [];
        state.total = Number(data.totalCount||items.length)||0;
        state.page = Number(data.page||page)||1;
        state.size = Number(data.pageSize||10)||10;
        state.totalPages = Math.max(1, Math.ceil(state.total/state.size));
        renderRows(items);
        renderPager();
      })
      .catch(function(){
        if(window.MOCK_BRANCH && MOCK_BRANCH.details[state.orderId]){
          state.mock = true; loadPage(page); return;
        }
        tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#ef4444">상세를 불러오지 못했습니다.</td></tr>';
        pageInfo.textContent = '';
      });
  }

  function renderRows(items){
    if(!items.length){
      tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#64748b">표시할 품목이 없습니다.</td></tr>';
      return;
    }
    var html='';
    for(var i=0;i<items.length;i++){
      var it = items[i]||{};
      var name = it.name||'';
      var unit = it.unit||'';
      var qty = Number(it.qty||0);
      var unitPrice = Number(it.unitPrice||0);
      var total = Math.round(unitPrice*qty);
      var img = it.imgfilename ? (ctx + '/imageView?filename=' + encodeURIComponent(it.imgfilename)) : '';
      var status = it.status||'미검';
      var badge = (status==='검수완')?'<span class="badge ok">검수완</span>':(status==='입고완')?'<span class="badge rcv">입고완</span>':'<span class="badge na">미검</span>';
      html += '<tr>'
            +   '<td>' + (img?('<img class="thumb" src="'+img+'" alt="">'):'<div class="thumb" style="display:grid;place-items:center">📦</div>') + '</td>'
            +   '<td>' + escapeHtml(name) + '</td>'
            +   '<td class="cell-num">' + nf.format(total) + '</td>'
            +   '<td class="cell-num">' + nf.format(qty) + ' <span style="color:#64748b">' + escapeHtml(unit) + '</span></td>'
            +   '<td>' + badge + '</td>'
            + '</tr>';
    }
    tbody.innerHTML = html;
  }

  function renderPager(){
    var start = (state.page-1)*state.size + 1;
    var end = Math.min(state.page*state.size, state.total);
    pageInfo.textContent = start + '–' + end + ' / ' + state.total + ' (페이지 ' + state.page + ' / ' + state.totalPages + ')';
    pager.querySelector('[data-role="first"]').disabled = state.page<=1;
    pager.querySelector('[data-role="prev"]').disabled  = state.page<=1;
    pager.querySelector('[data-role="next"]').disabled  = state.page>=state.totalPages;
    pager.querySelector('[data-role="last"]').disabled  = state.page>=state.totalPages;
  }

  function escapeHtml(s){ if(s==null) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;').replace(/'/g,'&#039;'); }
})();
</script>

<!-- MOCK (옵션): 서버 미연동 시 상세 표시에 사용 -->
<script>
var MOCK_BRANCH = {
  details: {
    '201': (function(){ var a=[]; for(var i=1;i<=11;i++){ a.push({ name:(i%2?'브로콜리':'방울토마토'), unit:(i%2?'kg':'팩'), unitPrice:(i%2?4500:3200), qty:(i%2?8:20), status:(i%3===0?'검수완':(i%5===0?'입고완':'미검')) }); } return a; })(),
    '202': [
      { name:'방울토마토', unit:'팩', unitPrice:3300, qty:30, status:'입고완' },
      { name:'로메인', unit:'kg', unitPrice:4700, qty:15, status:'입고완' },
      { name:'브로콜리', unit:'kg', unitPrice:4600, qty:12, status:'입고완' }
    ]
  }
};
</script>
</body>
</html>