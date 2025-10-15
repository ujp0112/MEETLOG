<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>지점 · 판매 메뉴 설정</title>
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
    table.sheet { width: 100%; border-collapse: separate; border-spacing: 0;}
    .sheet thead th { position: sticky; top: 0; background: #fff; border-bottom: 1px solid var(--border); font-weight: 800; text-align: left; padding: 12px 10px; font-size: 13px; }
    .sheet tbody td {max-width:300px; padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
    .cell-num { text-align: right; }
    .thumb { width: 44px; height: 250px; border-radius: 8px; border: 1px solid var(--border); object-fit: cover; background: #fafafa; display: block; }
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

/* 이 페이지 전용 스타일 */

.field { display:flex; align-items:center; gap:8px; background:var(--surface); border:1px solid var(--border); border-radius:8px; padding:4px 10px; }
.field > span { font-size: 13px; color: var(--text-muted); }
.field > input { border:0; outline:0; min-width:220px; background: transparent; padding: 6px 4px; }

.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:20px}
@media (max-width:980px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media (max-width:640px){.grid{grid-template-columns:1fr}}
.card{display:flex;flex-direction:column;border:1px solid var(--border);border-radius:14px;overflow:hidden;background:var(--surface);cursor:pointer; transition: .2s;}
.card:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(15,23,42,.08); }
.card .thumb{width:100%;aspect-ratio:16/10;object-fit:cover;background:#f3f4f6}
.card .body{padding:14px 16px;display:grid;gap:8px}
.card .name{font-weight:800; font-size: 16px;}
.card .meta{display:flex;justify-content:space-between;align-items: center; color:#374151}

.switch{display:inline-flex;align-items:center;gap:10px; cursor: pointer;}
.switch input{position:absolute;opacity:0;width:0;height:0}
.switch .track{width:44px;height:24px;border-radius:999px;background:#e5e7eb;position:relative;transition:.2s}
.switch .dot{position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;background:#fff;box-shadow:0 1px 3px rgba(0,0,0,.15);transition:.2s}
.switch input:checked + .track{background:#e5e7eb)}
.switch input:checked + .track .dot{transform:translateX(20px)}

.badge.on{color:var(--status-green-text);background:var(--status-green-bg);border-color:var(--status-green-border)}
.badge.off{color:var(--status-red-text);background:var(--status-red-bg);border-color:var(--status-red-border)}
.empty{color:var(--text-muted);text-align:center;padding:48px}

/* Popover */
.popover-mask{position:fixed;inset:0;background:rgba(0,0,0,.35);display:none;align-items:center;justify-content:center;z-index:200}
.popover-mask.show{display:flex}
.popover{width:100%;max-width:800px;background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 10px 30px rgba(0,0,0,.2)}
.popover .hd{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--border)}
.popover .hd > strong { font-size: 16px; font-weight: 700; }
.popover .bd{padding:16px}
.close-x{border:0;background:transparent;font-size:24px;cursor:pointer; color: var(--text-muted);}
.total{display:flex;justify-content:flex-end;gap:8px;margin-top:12px; font-size: 15px;}

.recipe-cell {
  margin-top: 8px; padding: 12px 14px; border: 1px solid var(--border);
  border-radius: 8px; background-color: #f9fafb; white-space: pre-wrap;
  line-height: 1.6; max-height: 300px; overflow-y: auto;
  min-height: 150px; color: #374151;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/layout/branchheader.jspf" %>
<div class="container">
    <section class="panel" aria-labelledby="pageTitle">
      <div class="hd">
        <h1 id="pageTitle" class="title">판매 메뉴 설정</h1>
        
      </div>

      <div class="bd">
        <div id="grid" class="grid" aria-live="polite"></div>
        <div id="empty" class="empty" style="display:none">메뉴가 없습니다.</div>
      </div>
    </section>
</div>
<div id="popMask" class="popover-mask" aria-hidden="true">
  <div class="popover" role="dialog" aria-modal="true" aria-labelledby="popTitle">
    <div class="hd">
      <strong id="popTitle">메뉴 재료</strong>
      <button class="close-x" type="button" aria-label="닫기" onclick="closePop()">×</button>
    </div>
    <div class="bd">
      <div class="table-wrap">
        <table class="sheet">
          <thead>
            <tr>
              <th>재료명</th>
              <th class="cell-num" style="width:120px">수량</th>
              <th class="cell-num" style="width:120px">단가</th>
              <th style="width:100px">단위</th>
            </tr>
          </thead>
          <tbody id="popRows"></tbody>
        </table>
      </div>
      <div class="total"><span class="hint">원가 합계:</span> <strong><span id="popSum">0</span>원</strong></div>
      <h4 style="margin-top: 16px;">레시피</h4>
      <div id="popRecipe" class="recipe-cell"></div>
    </div>
  </div>
</div>

<script>
const CTX='${contextPath}';
const $=s=>document.querySelector(s);
const $$=s=>Array.from(document.querySelectorAll(s));
const nf=new Intl.NumberFormat('ko-KR');
function escapeHtml(s){
	  if(s==null) return '';
	  return String(s)
	    .replace(/&/g,'&amp;')
	    .replace(/</g,'&lt;')
	    .replace(/>/g,'&gt;')
	    .replace(/"/g,'&quot;')
	    .replace(/'/g,'&#039;');
	}

function cardTpl(m){
	  console.log(m);
	  var img = m.imgPath ? (CTX + '/images/' + encodeURIComponent(m.imgPath)) : 'https://placehold.co/600x400/e0e7ff/4338ca?text=No+Image';
	  var checked = (m.enabled === 'Y');
	  return ''
	    + '<article class="card" data-id="' + m.id + '" data-name="' + escapeHtml(m.name||'') + '">'
	    +   '<img class="thumb" src="' + img + '" alt="' + escapeHtml(m.name||'') + '"/>'
	    +   '<div class="body">'
	    +     '<div class="name">' + escapeHtml(m.name||'') + '</div>'
	    +     '<div class="meta">'
	    +       '<span>' + nf.format(m.price||0) + '원</span>'
	    +       '<span class="badge ' + (checked?'on':'off') + '">' + (checked?'판매중':'미판매') + '</span>'
	    +     '</div>'
	    +     '<label class="switch" title="판매 여부" onclick="event.stopPropagation()">'
	    +       '<input type="checkbox" ' + (checked?'checked':'') + ' aria-label="판매 여부">'
	    +       '<span class="track"><span class="dot"></span></span>'
	    +     '</label>'
	    +   '</div>'
	    + '</article>';
	}


async function fetchList(){
  const url = CTX + '/branch/menus/list';
  const res = await fetch(url);
  if(!res.ok) throw new Error('목록 로딩 실패');
  return await res.json();
}

async function saveToggle(menuId, enabled){
  const body = new URLSearchParams();
  body.set('enabled', enabled ? 'Y' : 'N');
  const res = await fetch(CTX + '/branch/menus/' + encodeURIComponent(String(menuId)) + '/toggle', {
    method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:body
  });
  if(!res.ok) throw new Error('저장 실패');
}

async function reload(){
  const grid = $('#grid'); const empty = $('#empty');
  grid.innerHTML = '';
  try{
    const rows = await fetchList();
    if(!rows || rows.length===0){ empty.style.display='block'; return; }
    empty.style.display='none';
    grid.innerHTML = rows.map(cardTpl).join('');
  }catch(e){
    console.error(e);
    grid.innerHTML = '<div class="empty">목록을 불러오지 못했습니다.</div>';
  }
}

document.addEventListener('click', async (e)=>{
  const card = e.target.closest('.card');
  if(card){
    const id = card.dataset.id;
    const name = card.dataset.name || '메뉴 재료';
    $('#popTitle').textContent = name + ' · 재료';
    openPop();
    await fillPopover(id);
  }
});
document.addEventListener('change', async (e)=>{
  const card = e.target.closest('.card'); if(!card) return;
  if(e.target.matches('.switch input[type="checkbox"]')){
    const id = card.dataset.id;
    const checked = e.target.checked;
    const badge = card.querySelector('.badge');
    badge.textContent = checked ? '판매중' : '미판매';
    badge.classList.toggle('on', checked);
    badge.classList.toggle('off', !checked);
    try{
      await saveToggle(id, checked);
    }catch(err){
      e.target.checked = !checked;
      badge.textContent = !checked ? '판매중' : '미판매';
      badge.classList.toggle('on', !checked);
      badge.classList.toggle('off', checked);
      alert('저장에 실패했습니다. 잠시 후 다시 시도해주세요.');
    }
  }
});
function openPop(){ $('#popMask').classList.add('show'); $('#popMask').setAttribute('aria-hidden','false'); }
function closePop(){ $('#popMask').classList.remove('show'); $('#popMask').setAttribute('aria-hidden','true'); $('#popRows').innerHTML=''; $('#popSum').textContent='0'; }
$('#popMask').addEventListener('click', (e)=>{ if(e.target.id==='popMask') closePop(); });
document.addEventListener('keydown', (e)=>{ if(e.key==='Escape' && $('#popMask').classList.contains('show')) closePop(); });

async function fillPopover(menuId){
  try{
    const res = await fetch(CTX + '/branch/menus/' + encodeURIComponent(String(menuId)) + '/ingredients');
    if(!res.ok) throw new Error();
    const data = await res.json();
    const ingredients = data.ingredients; 
    const recipeText = data.recipe;
    
    const tbody = document.getElementById('popRows');
    tbody.innerHTML = '';
    let sum = 0;

    if(Array.isArray(ingredients) && ingredients.length){
      for(const it of ingredients){
        const price = Number(it.unitPrice||0), qty = Number(it.qty||0);
        sum += price * qty;
        const tr = document.createElement('tr');
        tr.innerHTML =
            '<td>' + escapeHtml(it.materialName||'') + '</td>'
          + '<td class="cell-num">' + qty + '</td>'
          + '<td class="cell-num">' + nf.format(price) + '</td>'
          + '<td>' + escapeHtml(it.unit||'') + '</td>';
        tbody.appendChild(tr);
      }
    }else{
      const tr = document.createElement('tr');
      tr.innerHTML = '<td colspan="4" class="empty-row" style="padding: 24px;">등록된 재료가 없습니다.</td>';
      tbody.appendChild(tr);
    }
    document.getElementById('popSum').textContent = nf.format(Math.round(sum));
    document.getElementById('popRecipe').textContent = recipeText || '등록된 레시피가 없습니다.';
  }catch(e){
    document.getElementById('popRows').innerHTML =
      '<tr><td colspan="4" style="text-align:center;color:#b91c1c; padding: 24px;">불러오기에 실패했습니다.</td></tr>';
  }
}

reload();
</script>
</body>
</html>