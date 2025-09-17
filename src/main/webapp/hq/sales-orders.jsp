<!-- File: webapp/hq/sales-orders.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>본사 · 발주 관리</title>
<style>
:root{--bg:#f6faf8;--surface:#ffffff;--border:#e5e7eb;--muted:#6b7280;--title:#0f172a;--primary:#2f855a;--primary-600:#27764f;--ring:#93c5aa}
*{box-sizing:border-box}
html,body{height:100%}
body{margin:0;background:var(--bg);color:var(--title);font:14px/1.45 system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,"Apple SD Gothic Neo","Noto Sans KR",sans-serif}
.container{max-width:1280px;margin:0 auto;padding:20px}

.card{background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 20px rgba(16,24,40,.06)}
.card .hd{display:flex;align-items:center;gap:10px;padding:16px 18px;border-bottom:1px solid var(--border)}
.card .bd{padding:16px 18px}
.title{margin:0;font-weight:800;font-size:20px}
.pill{display:inline-block;background:#f1f5f9;color:#475569;border:1px solid var(--border);border-radius:999px;padding:3px 8px;font-size:12px}

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
.btn[disabled]{opacity:.5;cursor:not-allowed}

.status{display:inline-flex;gap:6px;align-items:center}
.badge{display:inline-block;padding:2px 8px;border-radius:999px;border:1px solid var(--border);font-size:12px}
.badge.ok{background:#ecfdf5;color:#065f46;border-color:#a7f3d0}
.badge.na{background:#f8fafc;color:#334155}
.badge.rcv{background:#eff6ff;color:#1e40af;border-color:#bfdbfe}

/* Modal */
.modal{position:fixed;inset:0;background:rgba(2,6,23,.6);display:none;align-items:center;justify-content:center;z-index:60}
.modal.show{display:flex}
.dialog{width:min(980px,calc(100% - 24px));max-height:min(88vh,900px);display:grid;grid-template-rows:auto 1fr auto;background:#fff;border-radius:16px;border:1px solid var(--border);box-shadow:0 30px 80px rgba(2,6,23,.35);overflow:hidden}
.dialog .hd{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--border)}
.dialog .bd{padding:12px 16px;overflow:auto}
.dialog .ft{display:flex;align-items:center;justify-content:space-between;gap:8px;padding:10px 16px;border-top:1px solid var(--border)}
.close-x{border:0;background:transparent;font-size:22px;cursor:pointer}

.thumb{width:44px;height:44px;border-radius:8px;border:1px solid var(--border);object-fit:cover;background:#fafafa;display:block}

/**** Pager ****/
.pager{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:10px}
.pager .left,.pager .right{display:flex;align-items:center;gap:8px}
.pager .btn-group{display:flex;gap:6px}
.pager .info{font-size:12px;color:var(--muted)}
</style>
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>  <div class="container">
    <section class="card">
      <div class="hd">
        <h1 class="title">수주 관리</h1>
        <span class="pill">본사</span>
        <div style="flex:1 1 auto"></div>
        <div class="status">상태: <span class="badge na">미검</span> <span class="badge ok">검수완</span> <span class="badge rcv">입고완</span></div>
      </div>
      <div class="bd">
        <div class="table-wrap" role="region" aria-label="발주 목록">
          <table class="sheet" role="grid" id="ordersTable">
            <thead>
              <tr>
                <th style="width:120px">발주 No</th>
                <th>발주신청 지점명</th>
                <th>품명</th>
                <th style="width:120px">가격</th>
                <th style="width:140px">발주일</th>
                <th style="width:120px">상태</th>
                <th style="width:140px">입고검수서</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="o" items="${orders}">
                <tr data-id="${o.id}" data-branch="${fn:escapeXml(o.branchName)}" data-status="${fn:escapeXml(o.status)}">
                  <td>#<c:out value='${o.id}'/></td>
                  <td>${o.branchName}</td>
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
                  <td><button type="button" class="btn sm" data-action="open-inspect" data-id="${o.id}">입고검수서</button></td>
                </tr>
              </c:forEach>
              <c:if test="${empty orders}">
                <!-- MOCK 예시 발주 -->
                <tr data-id="101" data-branch="강남점" data-status="미검" data-mock="1">
                  <td>#101</td>
                  <td>강남점</td>
                  <td>브로콜리 외 1건</td>
                  <td class="cell-num">154,000</td>
                  <td>2025-09-10</td>
                  <td><span class="badge na">미검</span></td>
                  <td><button type="button" class="btn sm" data-action="open-inspect" data-id="101">입고검수서</button></td>
                </tr>
                <tr data-id="102" data-branch="홍대점" data-status="검수완" data-mock="1">
                  <td>#102</td>
                  <td>홍대점</td>
                  <td>닭가슴살 외 3건</td>
                  <td class="cell-num">412,500</td>
                  <td>2025-09-11</td>
                  <td><span class="badge ok">검수완</span></td>
                  <td><button type="button" class="btn sm" data-action="open-inspect" data-id="102">입고검수서</button></td>
                </tr>
                <tr data-id="103" data-branch="수원점" data-status="입고완" data-mock="1">
                  <td>#103</td>
                  <td>수원점</td>
                  <td>방울토마토 외 2건</td>
                  <td class="cell-num">238,900</td>
                  <td>2025-09-12</td>
                  <td><span class="badge rcv">입고완</span></td>
                  <td><button type="button" class="btn sm" data-action="open-inspect" data-id="103">입고검수서</button></td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </section>
  </div>

  <!-- 입고검수 Modal -->
  <div id="inspectModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="dialog">
      <div class="hd">
        <div><strong>입고검수서</strong> · <span id="modalOrderMeta" class="pill"></span></div>
        <button class="close-x" type="button" aria-label="닫기" onclick="closeInspect()">×</button>
      </div>
      <div class="bd">
        <div class="table-wrap" role="region" aria-label="발주 상세">
          <table class="sheet" role="grid" id="inspectTable">
            <thead>
              <tr>
                <th style="width:60px">사진</th>
                <th>품명</th>
                <th style="width:140px">품목별 총가격</th>
                <th style="width:160px">발주량</th>
                <th style="width:200px">입고처리</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
        <div class="pager" id="inspectPager">
          <div class="left">
            <div class="btn-group">
              <button type="button" class="btn sm" data-role="first">≪</button>
              <button type="button" class="btn sm" data-role="prev">‹</button>
              <button type="button" class="btn sm" data-role="next">›</button>
              <button type="button" class="btn sm" data-role="last">≫</button>
            </div>
            <span class="info" id="inspectPageInfo" aria-live="polite"></span>
          </div>
          <div class="right"><span class="info">페이지당 10건</span></div>
        </div>
      </div>
      <div class="ft">
        <span class="info">선택한 입고처리 상태가 저장됩니다.</span>
        <div style="display:flex;gap:8px">
          <button type="button" class="btn" onclick="closeInspect()">취소</button>
          <button type="button" class="btn primary" id="btnSaveInspect">검수완료</button>
        </div>
      </div>
    </div>
  </div>

  <script>
  // === MOCK 데이터 (orders가 비어있을 때 사용) ===
  var MOCK = {
    details: {
      '101': (function(){
        var arr = [];
        for (var i=1;i<=13;i++){
          arr.push({ lineId:'101-'+i, name: (i%3===1?'브로콜리': i%3===2?'방울토마토':'닭가슴살'), unit:(i%3===1?'kg': i%3===2?'팩':'kg'), unitPrice:(i%3===1?4500: i%3===2?3200:8700), qty:(i%3===1?10: i%3===2?20:8), imgfilename:'', status: '미검' });
        }
        return arr;
      })(),
      '102': (function(){
        var arr = [];
        for (var i=1;i<=24;i++){
          arr.push({ lineId:'102-'+i, name: (i%2? '닭가슴살':'시금치'), unit:(i%2? 'kg':'단'), unitPrice:(i%2? 8800:2100), qty:(i%2? 12:30), imgfilename:'', status: (i%2?'검수완':'미검') });
        }
        return arr;
      })(),
      '103': [
        { lineId:'103-1', name:'방울토마토', unit:'팩', unitPrice:3300, qty:30, imgfilename:'', status:'입고완' },
        { lineId:'103-2', name:'로메인', unit:'kg', unitPrice:4700, qty:15, imgfilename:'', status:'입고완' },
        { lineId:'103-3', name:'브로콜리', unit:'kg', unitPrice:4600, qty:12, imgfilename:'', status:'입고완' }
      ]
    }
  };
  </script>

  <script>
  (function(){
    var nf = new Intl.NumberFormat('ko-KR');
    var ctx = '${contextPath}';

    // ===== Orders list: open modal =====
    document.addEventListener('click', function(e){
      var btn = e.target.closest('button[data-action="open-inspect"]');
      if(!btn) return;
      var orderId = btn.getAttribute('data-id');
      var tr = btn.closest('tr');
      openInspect(orderId, tr && tr.getAttribute('data-branch'), tr && tr.getAttribute('data-mock')==='1');
    });

    // ===== Inspect Modal state =====
    var modal = document.getElementById('inspectModal');
    var tbody = document.querySelector('#inspectTable tbody');
    var pager = document.getElementById('inspectPager');
    var pageInfo = document.getElementById('inspectPageInfo');
    var metaEl = document.getElementById('modalOrderMeta');
    var btnSave = document.getElementById('btnSaveInspect');

    var state = { orderId:null, branchName:'', page:1, pageSize:10, total:0, totalPages:1, mock:false };
    var inspectionState = new Map(); // key: lineId, value: status string

    function openInspect(orderId, branchName, isMock){
      state.orderId = orderId;
      state.branchName = branchName || '';
      state.page = 1;
      state.mock = !!isMock;
      inspectionState.clear();
      metaEl.textContent = '#' + orderId + ' · ' + (branchName || '');
      modal.classList.add('show');
      modal.setAttribute('aria-hidden','false');
      loadPage(1);
    }
    function closeInspect(){
      modal.classList.remove('show');
      modal.setAttribute('aria-hidden','true');
      tbody.innerHTML = '';
    }
    // expose for inline onclick
    window.closeInspect = closeInspect;

    modal.addEventListener('click', function(e){ if(e.target===modal) closeInspect(); });
    document.addEventListener('keydown', function(e){ if(e.key==='Escape' && modal.classList.contains('show')) closeInspect(); });

    // Pager buttons
    pager.querySelector('[data-role="first"]').addEventListener('click', function(){ loadPage(1); });
    pager.querySelector('[data-role="prev"]').addEventListener('click', function(){ loadPage(Math.max(1, state.page-1)); });
    pager.querySelector('[data-role="next"]').addEventListener('click', function(){ loadPage(Math.min(state.totalPages, state.page+1)); });
    pager.querySelector('[data-role="last"]').addEventListener('click', function(){ loadPage(state.totalPages); });

    function loadPage(page){
      if(!state.orderId) return;
      state.page = page;
      tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#64748b">불러오는 중...</td></tr>';

      if(state.mock && window.MOCK && MOCK.details[state.orderId]){
        var all = MOCK.details[state.orderId];
        state.total = all.length;
        state.totalPages = Math.max(1, Math.ceil(state.total / state.pageSize));
        var start = (page-1)*state.pageSize;
        var slice = all.slice(start, start + state.pageSize);
        renderTable(slice);
        renderPager();
        return;
      }

      var url = ctx + '/hq/sales-orders/' + encodeURIComponent(state.orderId) + '/details?page=' + page + '&size=' + state.pageSize;
      fetch(url, { headers:{'Accept':'application/json'} })
        .then(function(r){ if(!r.ok) throw new Error('네트워크 오류'); return r.json(); })
        .then(function(data){
          var items = Array.isArray(data.items) ? data.items : [];
          state.total = Number(data.totalCount||items.length)||0;
          state.page = Number(data.page||page)||1;
          state.pageSize = Number(data.pageSize||10)||10;
          state.totalPages = Math.max(1, Math.ceil(state.total / state.pageSize));
          renderTable(items);
          renderPager();
        })
        .catch(function(){
          // 서버가 없으면 MOCK로 폴백
          if(window.MOCK && MOCK.details[state.orderId]){
            state.mock = true;
            loadPage(page);
            return;
          }
          tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#ef4444">상세를 불러오지 못했습니다.</td></tr>';
          pageInfo.textContent = '';
        });
    }

    function renderTable(items){
      if(!items.length){
        tbody.innerHTML = '<tr><td colspan="5" style="padding:16px;text-align:center;color:#64748b">표시할 품목이 없습니다.</td></tr>';
        return;
      }
      var html = '';
      for(var i=0;i<items.length;i++){
        var it = items[i] || {};
        var lineId = (it.lineId!=null ? it.lineId : (it.id!=null ? it.id : String(Math.random())));
        var name = it.name || '';
        var unit = it.unit || '';
        var qty = Number(it.qty||0);
        var unitPrice = Number(it.unitPrice||0);
        var total = Math.round(unitPrice * qty);
        var img = it.imgfilename ? (ctx + '/imageView?filename=' + encodeURIComponent(it.imgfilename)) : '';
        var cur = inspectionState.has(lineId) ? inspectionState.get(lineId) : (it.status || '미검');
        html += '<tr data-line-id="' + escapeHtml(String(lineId)) + '">'
              +   '<td>' + (img ? '<img class="thumb" src="' + img + '" alt="">' : '<div class="thumb" style="display:grid;place-items:center">📦</div>') + '</td>'
              +   '<td>' + escapeHtml(name) + '</td>'
              +   '<td class="cell-num">' + nf.format(total) + '</td>'
              +   '<td class="cell-num">' + nf.format(qty) + ' <span style="color:#64748b">' + escapeHtml(unit) + '</span></td>'
              +   '<td>'
              +     '<select class="input" data-role="status">'
              +       '<option value="미검"'   + (cur==='미검'?' selected':'')   + '>미검</option>'
              +       '<option value="검수완"' + (cur==='검수완'?' selected':'') + '>검수완</option>'
              +       '<option value="입고완"' + (cur==='입고완'?' selected':'') + '>입고완</option>'
              +     '</select>'
              +   '</td>'
              + '</tr>';
      }
      tbody.innerHTML = html;
    }

    function renderPager(){
      var start = (state.page-1)*state.pageSize + 1;
      var end = Math.min(state.page*state.pageSize, state.total);
      pageInfo.textContent = start + '–' + end + ' / ' + state.total + ' (페이지 ' + state.page + ' / ' + state.totalPages + ')';
      pager.querySelector('[data-role="first"]').disabled = state.page<=1;
      pager.querySelector('[data-role="prev"]').disabled  = state.page<=1;
      pager.querySelector('[data-role="next"]').disabled  = state.page>=state.totalPages;
      pager.querySelector('[data-role="last"]').disabled  = state.page>=state.totalPages;
    }

    tbody.addEventListener('change', function(e){
      if(!e.target.matches('select[data-role="status"]')) return;
      var tr = e.target.closest('tr');
      var id = tr.getAttribute('data-line-id');
      var val = e.target.value;
      inspectionState.set(id, val);
    });

    btnSave.addEventListener('click', function(){
      var rows = Array.from(tbody.querySelectorAll('tr[data-line-id]'));
      var lines = rows.map(function(tr){
        return { lineId: tr.getAttribute('data-line-id'), status: tr.querySelector('select[data-role="status"]').value };
      });
      if(!lines.length) { alert('저장할 항목이 없습니다.'); return; }

      if(state.mock){
        alert('MOCK: 검수 상태가 저장되었습니다. (서버 연동 전)');
        closeInspect();
        return;
      }

      var url = ctx + '/hq/sales-orders/' + encodeURIComponent(state.orderId) + '/inspect?page=' + state.page;
      fetch(url, { method:'POST', headers:{ 'Content-Type':'application/json' }, body: JSON.stringify({ lines: lines }) })
        .then(function(r){ if(!r.ok) throw new Error('save failed'); return r.json ? r.json() : null; })
        .then(function(){ alert('검수 상태가 저장되었습니다.'); closeInspect(); })
        .catch(function(){ alert('저장에 실패했습니다. 다시 시도해주세요.'); });
    });

    function escapeHtml(s){ if(s==null) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;').replace(/'/g,'&#039;'); }
  })();
  </script>
</body>
</html>