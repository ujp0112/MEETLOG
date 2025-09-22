<!-- File: webapp/branch/menu.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MEET LOG - 지점 관리</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style.css">
<style>
:root{
  --bg:#f6faf8;--surface:#ffffff;--border:#e5e7eb;--muted:#6b7280;--title:#0f172a;--primary:#2f855a;--primary-600:#27764f;--ring:#93c5aa
}
*{box-sizing:border-box}
html,body{height:100%}
body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif;background:var(--bg);color:var(--title)}
.page{min-height:100vh;display:flex;flex-direction:column}
.panel{background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 20px rgba(16,24,40,.05)}
.panel .hd{display:flex;align-items:center;gap:10px;padding:16px 18px;border-bottom:1px solid var(--border)}
.panel .bd{padding:16px 18px}
.shell{max-width:1280px;margin:0 auto;padding:20px;display:grid;grid-template-columns:260px minmax(0,1fr);gap:20px}
@media (max-width:960px){.shell{grid-template-columns:1fr}}

/* 카드 그리드 */
.cards{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px}
@media (max-width:1024px){.cards{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media (max-width:640px){.cards{grid-template-columns:1fr}}
.card{border:1px solid var(--border);background:#fff;border-radius:16px;overflow:visible;display:flex;flex-direction:column;position:relative}
.card:hover{box-shadow:0 8px 20px rgba(16,24,40,.06)}
.card .thumb{width:100%;height:160px;object-fit:cover;background:#f3f4f6;border-radius:16px 16px 16px 16px;}
.card .body{padding:12px 14px;display:grid;gap:10px}
.card h3{margin:0;font-weight:800;font-size:16px}
.badge{font-size:12px;color:var(--muted)}

/* 토글 스위치 */
.switch{position:relative;width:46px;height:26px}
.switch input{opacity:0;width:0;height:0}
.slider{position:absolute;cursor:pointer;inset:0;background:#e5e7eb;border-radius:999px;transition:background .2s}
.slider:before{content:"";position:absolute;height:22px;width:22px;left:2px;top:2px;background:#fff;border-radius:50%;box-shadow:0 1px 2px rgba(0,0,0,.15);transition:transform .2s}
input:checked + .slider{background:var(--primary)}
input:checked + .slider:before{transform:translateX(20px)}

/* 재료 패널 */
.ingredients{border-top:1px solid var(--border);padding:10px 14px;display:none}
.ingredients.show{display:none} /* in-card panel 숨김: 플로팅 패널 사용 */
.table-wrap{border:1px solid var(--border);border-radius:12px;overflow:auto}
.table{width:100%;border-collapse:separate;border-spacing:0}
.table th,.table td{padding:10px 8px;border-bottom:1px solid #f1f5f9;text-align:left;font-size:13px}
.cell-num{text-align:right}
.empty{color:var(--muted);text-align:center;padding:14px}
/* 카드 내 팝오버(행 높이 영향 없음) */
.ingredients-popover{position:absolute;top:100%;left:0;right:0;margin-top:8px;z-index:50;background:#fff;border:1px solid var(--border);border-radius:14px;box-shadow:0 12px 28px rgba(15,23,42,.18);max-height:60vh;overflow:auto}
.ingredients-popover .head{display:flex;align-items:center;justify-content:space-between;padding:10px 12px;border-bottom:1px solid var(--border)}
.ingredients-popover .close-x{border:0;background:transparent;font-size:20px;cursor:pointer}
</style>
</head>
<body>
  <jsp:include page="/WEB-INF/jspf/branchheader.jspf" />
  <div class="page">
    <main id="main-content" class="flex-grow">
      <div class="page-content container mx-auto p-8">
        <section class="panel" aria-labelledby="pageTitle">
          <div class="hd">
            <h1 id="pageTitle" class="text-xl font-extrabold">지점 메뉴 On/Off</h1>
            <div class="ml-auto text-sm text-gray-500">카드를 눌러 재료를 확인하세요</div>
          </div>
          <div class="bd">
            <div class="cards" aria-label="메뉴 카드 목록">
              <c:forEach var="m" items="${menus}">
                <article class="card" data-role="menu-card" data-id="${m.num}" data-load-url="${contextPath}/branch/menus/${m.num}/ingredients" tabindex="0">
                  <c:choose>
                    <c:when test="${not empty m.imgfilename}">
                      <img class="thumb" src="${contextPath}/imageView?filename=${m.imgfilename}" alt="${fn:escapeXml(m.name)}"/>
                    </c:when>
                    <c:otherwise>
                      <img class="thumb" src="${contextPath}/img/placeholder-menu.jpg" alt="${fn:escapeXml(m.name)}"/>
                    </c:otherwise>
                  </c:choose>
                  <div class="body">
                    <div class="flex items-start gap-2">
                      <h3 class="flex-1">${m.name}</h3>
                      <form method="post" action="${contextPath}/branch/menus/${m.num}/toggle" class="m-0" onsubmit="return false;">
                        <label class="switch" title="메뉴 On/Off">
                          <input type="checkbox" data-role="menu-toggle" aria-label="${fn:escapeXml(m.name)} 활성화" <c:if test="${m.enabled}">checked</c:if> />
                          <span class="slider"></span>
                        </label>
                      </form>
                    </div>
                    <div class="text-sm text-gray-600 flex items-center justify-between">
                      <span class="badge">가격</span>
                      <strong><fmt:formatNumber value="${m.salePrice}"/>원</strong>
                    </div>
                  </div>
                  <!-- 재료 패널 -->
                  <div class="ingredients" aria-hidden="true">
                    <c:choose>
                      <c:when test="${not empty m.ingredients}">
                        <div class="table-wrap">
                          <table class="table" role="grid">
                            <thead>
                              <tr>
                                <th style="width:100px">재료명</th>
                                <th style="width:100px">수량</th>
                                <th style="width:120px">원가</th>
                                <th style="width:100px">단위</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="ing" items="${m.ingredients}">
                                <tr>
                                  <td>${ing.name}</td>
                                  <td class="cell-num"><fmt:formatNumber value="${ing.quantity}"/></td>
                                  <td class="cell-num"><fmt:formatNumber value="${ing.salePrice}"/></td>
                                  <td>${ing.unit}</td>
                                </tr>
                              </c:forEach>
                            </tbody>
                          </table>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="empty">카드를 클릭하면 재료를 불러옵니다…</div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </article>
              </c:forEach>

              <c:if test="${empty menus}">
                <!-- MOCK: 서버 데이터가 없을 때 예시 2개 -->
                <article class="card" data-role="menu-card" data-id="demo1" data-load-url="#mock">
                  <img class="thumb" src="${contextPath}/img/돈까스.png" alt="샘플 메뉴"/>
                  <div class="body">
                    <div class="flex items-start gap-2">
                      <h3 class="flex-1">샐러드 세트</h3>
                      <label class="switch"><input type="checkbox" data-role="menu-toggle" checked><span class="slider"></span></label>
                    </div>
                    <div class="text-sm text-gray-600 flex items-center justify-between"><span class="badge">가격</span><strong>9,500원</strong></div>
                  </div>
                  <div class="ingredients" aria-hidden="true">
                    <div class="table-wrap">
                      <table class="table" role="grid">
                        <thead><tr><th style="width:100px">재료명</th><th style="width:100px">수량</th><th style="width:120px">원가</th><th style="width:100px">단위</th></tr></thead>
                        <tbody>
                          <tr><td>로메인</td><td class="cell-num">1</td><td class="cell-num">4500</td><td>kg</td></tr>
                          <tr><td>토마토</td><td class="cell-num">1</td><td class="cell-num">1500</td><td>팩</td></tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </article>

                <article class="card" data-role="menu-card" data-id="demo2" data-load-url="#mock">
                  <img class="thumb" src="${contextPath}/img/돈까스.png" alt="샘플 메뉴"/>
                  <div class="body">
                    <div class="flex items-start gap-2">
                      <h3 class="flex-1">치킨 아보카도</h3>
                      <label class="switch"><input type="checkbox" data-role="menu-toggle"><span class="slider"></span></label>
                    </div>
                    <div class="text-sm text-gray-600 flex items-center justify-between"><span class="badge">가격</span><strong>12,000원</strong></div>
                  </div>
                  <div class="ingredients" aria-hidden="true"><div class="empty">카드를 클릭하면 재료를 불러옵니다…</div></div>
                </article>
                
                <article class="card" data-role="menu-card" data-id="demo2" data-load-url="#mock">
                  <img class="thumb" src="${contextPath}/img/돈까스.png" alt="샘플 메뉴"/>
                  <div class="body">
                    <div class="flex items-start gap-2">
                      <h3 class="flex-1">치킨 아보카도</h3>
                      <label class="switch"><input type="checkbox" data-role="menu-toggle"><span class="slider"></span></label>
                    </div>
                    <div class="text-sm text-gray-600 flex items-center justify-between"><span class="badge">가격</span><strong>12,000원</strong></div>
                  </div>
                  <div class="ingredients" aria-hidden="true"><div class="empty">카드를 클릭하면 재료를 불러옵니다…</div></div>
                </article>
                
                <article class="card" data-role="menu-card" data-id="demo2" data-load-url="#mock">
                  <img class="thumb" src="${contextPath}/img/돈까스.png" alt="샘플 메뉴"/>
                  <div class="body">
                    <div class="flex items-start gap-2">
                      <h3 class="flex-1">치킨 아보카도</h3>
                      <label class="switch"><input type="checkbox" data-role="menu-toggle"><span class="slider"></span></label>
                    </div>
                    <div class="text-sm text-gray-600 flex items-center justify-between"><span class="badge">가격</span><strong>12,000원</strong></div>
                  </div>
                  <div class="ingredients" aria-hidden="true"><div class="empty">카드를 클릭하면 재료를 불러옵니다…</div></div>
                </article>
              </c:if>
            </div>
          </div>
        </section>
      </div>
    </main>
  </div>

<script>
(function(){
  var nf = new Intl.NumberFormat('ko-KR');

  // 카드 클릭 → 재료 패널 토글 및 필요시 지연 로드
  document.addEventListener('click', function(e){
    var card = e.target.closest('[data-role="menu-card"]');
    if(!card) return;
    // 토글 클릭은 카드 토글로 전파되지 않게 처리
    if(e.target.closest('[data-role="menu-toggle"]')) return;

    var panel = card.querySelector('.ingredients');
    var wasHidden = !panel.classList.contains('show');
    panel.classList.toggle('show');
    panel.setAttribute('aria-hidden', panel.classList.contains('show') ? 'false' : 'true');

    if(wasHidden){
      // 이미 서버 렌더링된 내용이 있으면 종료
      if(panel.querySelector('table')) return;
      var url = card.getAttribute('data-load-url');
      if(!url || url === '#mock') return;
      // 로딩 표시
      panel.innerHTML = '<div class="empty">불러오는 중…</div>';
      fetch(url, { headers: { 'Accept': 'application/json' }})
        .then(function(res){ if(!res.ok) throw new Error('네트워크 오류'); return res.json(); })
        .then(function(list){ renderIngredients(panel, list || []); })
        .catch(function(err){ panel.innerHTML = '<div class="empty">불러오기 실패: ' + err.message + '</div>'; });
    }
  });

  function renderIngredients(container, items){
    if(!items || !items.length){ container.innerHTML = '<div class="empty">재료 정보가 없습니다.</div>'; return; }
    var html = '';
    html += '<div class="table-wrap">';
    html += '<table class="table" role="grid">';
    html += '<thead><tr>' +
      '<th>재료명</th>' +
      '<th style="width:100px">수량</th>' +
      '<th style="width:120px">원가</th>' +
      '<th style="width:100px">단위</th>' +
      '</tr></thead><tbody>';
    for(var i=0;i<items.length;i++){
      var it = items[i];
      var q = it.quantity != null ? it.quantity : 0;
      var p = it.unitPrice != null ? it.unitPrice : 0;
      html += '<tr>' +
        '<td>' + escapeHtml(it.name || '') + '</td>' +
        '<td class="cell-num">' + nf.format(q) + '</td>' +
        '<td class="cell-num">' + nf.format(p) + '</td>' +
        '<td>' + escapeHtml(it.unit || '') + '</td>' +
      '</tr>';
    }
    html += '</tbody></table></div>';
    container.innerHTML = html;
  }
  // ===== 카드 내 팝오버 =====
  (function(){
    var nf2 = new Intl.NumberFormat('ko-KR');
    var openCard = null; var pop = null; var popBody = null;

    document.addEventListener('click', function(e){
      var card = e.target.closest('[data-role="menu-card"]');
      if(!card){
        // 바깥 클릭 닫기
        if(pop && !e.target.closest('.ingredients-popover')) closePopover();
        return;
      }
      if(e.target.closest('[data-role="menu-toggle"]')) return;
      if(openCard === card){ closePopover(); return; }
      openPopover(card);
    });

    function openPopover(card){
      if(!pop){ pop = document.createElement('div'); pop.className = 'ingredients-popover'; card.appendChild(pop); }
      else{ if(pop.parentNode !== card) card.appendChild(pop); }
      openCard = card;
      pop.innerHTML = '<div class="head"><strong>' + escapeHtml(card.querySelector('h3')?card.querySelector('h3').textContent:'재료') + '</strong><button type="button" class="close-x" aria-label="닫기">×</button></div><div class="body"></div>';
      popBody = pop.querySelector('.body');
      pop.querySelector('.close-x').addEventListener('click', closePopover);

      var panel = card.querySelector('.ingredients');
      var hasTable = panel && panel.querySelector('table');
      var url = card.getAttribute('data-load-url');
      if(hasTable){ popBody.innerHTML = panel.innerHTML; }
      else if(url && url !== '#mock'){
        popBody.innerHTML = '<div class="empty">불러오는 중…</div>';
        fetch(url, { headers: { 'Accept': 'application/json' }})
          .then(function(res){ if(!res.ok) throw new Error('네트워크 오류'); return res.json(); })
          .then(function(list){ renderIng(popBody, list || []); })
          .catch(function(err){ popBody.innerHTML = '<div class="empty">불러오기 실패: ' + err.message + '</div>'; });
      }else{ popBody.innerHTML = '<div class="empty">재료 정보가 없습니다.</div>'; }
    }

    function closePopover(){ if(!pop) return; pop.remove(); pop=null; popBody=null; openCard=null; }

    function renderIng(container, items){
      if(!items || !items.length){ container.innerHTML = '<div class="empty">재료 정보가 없습니다.</div>'; return; }
      var html = '';
      html += '<div class="table-wrap">';
      html += '<table class="table" role="grid">';
      html += '<thead><tr>' +
        '<th>재료명</th>' +
        '<th style="width:100px">수량</th>' +
        '<th style="width:120px">원가</th>' +
        '<th style="width:100px">단위</th>' +
        '</tr></thead><tbody>';
      for(var i=0;i<items.length;i++){
        var it = items[i];
        var q = it.quantity != null ? it.quantity : 0;
        var p = it.unitPrice != null ? it.unitPrice : 0;
        html += '<tr>' +
          '<td>' + escapeHtml(it.name || '') + '</td>' +
          '<td class="cell-num">' + nf2.format(q) + '</td>' +
          '<td class="cell-num">' + nf2.format(p) + '</td>' +
          '<td>' + escapeHtml(it.unit || '') + '</td>' +
        '</tr>';
      }
      html += '</tbody></table></div>';
      container.innerHTML = html;
    }
  })();

  // On/Off 토글 처리
  document.addEventListener('change', function(e){
    var cb = e.target.closest('input[type="checkbox"][data-role="menu-toggle"]');
    if(!cb) return;
    var card = cb.closest('[data-role="menu-card"]');
    var menuId = card ? card.getAttribute('data-id') : null;
    var url = card ? (cb.form && cb.form.getAttribute('action')) : null;
    var enabled = cb.checked;

    if(!url){ return; }
    // 낙관적 UI → 실패 시 롤백
    var old = !enabled;
    fetch(url, {
      method:'POST',
      headers:{ 'Content-Type':'application/json' },
      body: JSON.stringify({ enabled: enabled, id: menuId })
    }).then(function(res){
      if(!res.ok) throw new Error('서버 오류');
      return res.text();
    }).catch(function(){
      cb.checked = old;
      alert('상태 변경에 실패했습니다.');
    });
  });

  function escapeHtml(s){
    if(s==null) return '';
    return String(s)
      .replace(/&/g,'&amp;')
      .replace(/</g,'&lt;')
      .replace(/>/g,'&gt;')
      .replace(/\"/g,'&quot;')
      .replace(/'/g,'&#039;');
  }
})();
</script>
</body>
</html>
