<!-- File: webapp/hq/material-management.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>본사 · 재료 관리</title>
  <style>
    :root{
      --bg:#f6faf8;--surface:#ffffff;--border:#e5e7eb;--muted:#6b7280;--title:#0f172a;--primary:#2f855a;--primary-600:#27764f;--ring:#93c5aa
    }
    html,body{height:100%}
    body{margin:0;background:var(--bg);color:var(--title);font:14px/1.45 system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,"Apple SD Gothic Neo","Noto Sans KR",sans-serif}

    /* Shell with left sidebar include */
    .shell{max-width:1280px;margin:0 auto;padding:20px;display:grid;grid-template-columns:260px minmax(0,1fr);gap:20px}
    @media (max-width: 960px){.shell{grid-template-columns:1fr}}

    /* Card */
    .panel{max-width:1000px;background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 20px rgba(16,24,40,.05);margin:0 auto;}
    .panel .hd{display:flex;align-items:center;gap:10px;padding:16px 18px;border-bottom:1px solid var(--border)}
    .panel .bd{padding:16px 18px}

    .title{margin:0;font-size:20px;font-weight:800}
    .pill{padding:6px 10px;border-radius:999px;background:#eef7f0;border:1px solid #ddeee1;color:#246b45;font-weight:700}

    .toolbar{display:flex;flex-wrap:wrap;gap:8px}
    .field{display:flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--border);border-radius:10px;padding:8px 10px}
    .field>select,.field>input{border:0;outline:0;min-width:160px}

    .btn{appearance:none;border:1px solid var(--border);background:#fff;padding:10px 14px;border-radius:999px;font-weight:700;cursor:pointer;text-decoration:none;color:#111827}
    .btn:hover{background:#f8fafc}
    .btn.primary{background:var(--primary);border-color:var(--primary);color:#fff}
    .btn.primary:hover{background:var(--primary-600)}
    .btn-sm{padding:6px 8px;border-radius:8px}
    .btn-danger{color:#b91c1c;border-color:#fecaca}
    .btn-danger:hover{background:#fff1f2;border-color:#fca5a5}

    /* Table (spreadsheet look) */
    .table-wrap{border:1px solid var(--border);border-radius:14px;overflow:auto;background:#fff}
    table.sheet{width:100%;border-collapse:separate;border-spacing:0;min-width:860px}
    .sheet thead th{position:sticky;top:0;background:#fff;border-bottom:1px solid var(--border);font-weight:800;text-align:left;padding:12px 10px;font-size:13px}
    .sheet tbody td{padding:12px 10px;border-bottom:1px solid #f1f5f9;vertical-align:middle}
    .sheet tbody tr:hover td{background:#fafafa}
    .cell-num{text-align:left}

    .thumb{width:40px;height:40px;border-radius:8px;border:1px solid var(--border);object-fit:cover;background:#fafafa;display:block}
    .row-actions{display:flex;gap:6px}

    .empty{color:var(--muted);text-align:center;padding:24px}

    /* Modal (edit form) */
    .modal{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(15,23,42,.45);z-index:100}
    .modal.show{display:flex}
    .dialog{width:100%;max-width:720px;background:#fff;border-radius:20px;border:1px solid var(--border);box-shadow:0 10px 30px rgba(0,0,0,.12)}
    .dialog .hd{display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid var(--border)}
    .dialog .bd{padding:16px}
    .close-x{border:0;background:transparent;font-size:22px;cursor:pointer}

    /* Reuse of material-settings form styles */
    .form{display:grid;gap:14px}
    .row{display:grid;grid-template-columns:160px 1fr;align-items:center;gap:12px}
    .label{color:var(--muted);font-size:14px}
    .input{width:100%;padding:12px 14px;border:1px solid var(--border);border-radius:12px;background:#fff;outline:0;font-size:14px}
    .input:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--ring)}
    .image-field{display:grid;grid-template-columns:72px 1fr;gap:12px;align-items:center}
    .preview-circle{width:72px;height:72px;border-radius:10px;border:2px dashed var(--border);background:#fafafa;display:flex;align-items:center;justify-content:center;overflow:hidden;cursor:pointer}
    .preview-circle img{width:100%;height:100%;object-fit:cover}
    .hint{color:var(--muted);font-size:12px}
    .actions{display:flex;gap:10px;justify-content:center;margin-top:8px}

    @media (max-width:560px){.row{grid-template-columns:1fr}}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %><!--   <div class="shell"> -->

    <main>
      <section class="panel" aria-labelledby="pageTitle">
    <%-- <jsp:include page="/WEB-INF/jspf/sidebar-materials.jspf" /> --%>
        <div class="hd">
          <h1 id="pageTitle" class="title">재료 관리</h1>
          <span class="pill">HQ</span>
          <div style="flex:1 1 auto"></div>
          <button class="btn primary" data-action="append">+ 재료 추가</button>
        </div>
        <div class="bd">
          <!-- optional toolbar: wire up as needed -->
          <form method="get" class="toolbar" style="margin-bottom:12px">
            <div class="field"><span style="color:var(--muted)">검색</span><input name="q" value="${fn:escapeXml(param.q)}" placeholder="재료명/단위/브랜드"/></div>
            <button class="btn" type="submit">검색</button>
            <a class="btn" href="${contextPath}/hq/material-management.jsp">초기화</a>
          </form>

          <div class="table-wrap" role="region" aria-label="재료 목록">
            <table class="sheet" role="grid">
              <thead>
                <tr>
                  <th style="width:56px">이미지</th>
                  <th>재료명</th>
                  <th style="width:120px">단위</th>
                  <th style="width:120px">단가</th>
                  <th style="width:120px">보유량</th>
                  <th style="width:120px">주문단위</th>
                  <th style="width:140px">가격</th>
                  <th style="width:132px">관리</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${materials}">
                  <tr id="row-${m.num}"
                      data-id="${m.num}"
                      data-name="${fn:escapeXml(m.name)}"
                      data-unit="${fn:escapeXml(m.unit)}"
                      data-unitprice="${m.unitPrice}"
                      data-step="${m.step}"
                      data-qty="${empty m.stockQty ? (empty m.quantity ? 0 : m.quantity) : m.stockQty}"
                      data-img="${m.imgfilename}">
                    <td>
                      <c:choose>
                        <c:when test="${not empty m.imgfilename}">
                          <img class="thumb" src="${contextPath}/imageView?filename=${m.imgfilename}" alt="${fn:escapeXml(m.name)}"/>
                        </c:when>
                        <c:otherwise>
                          <span class="thumb" style="display:grid;place-items:center">🥬</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${m.name}</td>
                    <td>${m.unit}</td>
                    <td class="cell-num"><fmt:formatNumber value="${m.unitPrice}" /></td>
                    <td class="cell-num">
                      <c:choose>
                        <c:when test="${not empty m.stockQty}"><fmt:formatNumber value="${m.stockQty}"/></c:when>
                        <c:when test="${not empty m.quantity}"><fmt:formatNumber value="${m.quantity}"/></c:when>
                        <c:otherwise>0</c:otherwise>
                      </c:choose>
                    </td>
                    <td class="cell-num"><fmt:formatNumber value="${m.step}" /></td>
                    <td class="cell-num">
                      <fmt:formatNumber value="${(m.unitPrice) * (m.step)}" />
                    </td>
                    <td>
                      <div class="row-actions">
                        <button type="button" class="btn-sm" data-action="edit">수정</button>
                        <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="${contextPath}/hq/materials/${m.num}/delete">삭제</button>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty materials}">
                  <!-- MOCK: 서버 데이터가 없을 때 예시 행 표시 -->
                  <tr id="row-m1" data-id="m1" data-name="로메인" data-unit="kg" data-unitprice="4500" data-step="5" data-qty="20" data-img="">
                    <td><span class="thumb" style="display:grid;place-items:center">🥬</span></td>
                    <td>로메인</td>
                    <td>kg</td>
                    <td class="cell-num">4,500</td>
                    <td class="cell-num">20</td>
                    <td class="cell-num">5</td>
                    <td class="cell-num">22,500</td>
                    <td>
                      <div class="row-actions">
                        <button type="button" class="btn-sm" data-action="edit">수정</button>
                        <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="#mock">삭제</button>
                      </div>
                    </td>
                  </tr>
                  <tr id="row-m2" data-id="m2" data-name="방울토마토" data-unit="팩" data-unitprice="3200" data-step="10" data-qty="150" data-img="">
                    <td><span class="thumb" style="display:grid;place-items:center">🍅</span></td>
                    <td>방울토마토</td>
                    <td>팩</td>
                    <td class="cell-num">3,200</td>
                    <td class="cell-num">150</td>
                    <td class="cell-num">10</td>
                    <td class="cell-num">32,000</td>
                    <td>
                      <div class="row-actions">
                        <button type="button" class="btn-sm" data-action="edit">수정</button>
                        <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="#mock">삭제</button>
                      </div>
                    </td>
                  </tr>
                  <tr id="row-m3" data-id="m3" data-name="닭가슴살" data-unit="kg" data-unitprice="8700" data-step="4" data-qty="60" data-img="">
                    <td><span class="thumb" style="display:grid;place-items:center">🍗</span></td>
                    <td>닭가슴살</td>
                    <td>kg</td>
                    <td class="cell-num">8,700</td>
                    <td class="cell-num">60</td>
                    <td class="cell-num">4</td>
                    <td class="cell-num">34,800</td>
                    <td>
                      <div class="row-actions">
                        <button type="button" class="btn-sm" data-action="edit">수정</button>
                        <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="#mock">삭제</button>
                      </div>
                    </td>
                  </tr>
                  <tr id="row-m4" data-id="m4" data-name="아보카도" data-unit="개" data-unitprice="2500" data-step="12" data-qty="30" data-img="">
                    <td><span class="thumb" style="display:grid;place-items:center">🥑</span></td>
                    <td>아보카도</td>
                    <td>개</td>
                    <td class="cell-num">2,500</td>
                    <td class="cell-num">30</td>
                    <td class="cell-num">12</td>
                    <td class="cell-num">30,000</td>
                    <td>
                      <div class="row-actions">
                        <button type="button" class="btn-sm" data-action="edit">수정</button>
                        <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="#mock">삭제</button>
                      </div>
                    </td>
                  </tr>
                  <tr id="row-m5" data-id="m5" data-name="올리브오일" data-unit="L" data-unitprice="9800" data-step="1" data-qty="8" data-img="">
                    <td><span class="thumb" style="display:grid;place-items:center">🫒</span></td>
                    <td>올리브오일</td>
                    <td>L</td>
                    <td class="cell-num">9,800</td>
                    <td class="cell-num">8</td>
                    <td class="cell-num">1</td>
                    <td class="cell-num">9,800</td>
                    <td>
                      <div class="row-actions">
                        <button type="button" class="btn-sm" data-action="edit">수정</button>
                        <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="#mock">삭제</button>
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
<!--   </div> -->

  <!-- Edit Modal: material-settings.jsp의 폼을 재사용 -->
  <div id="editModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="dialog">
      <div class="hd">
        <strong>재료 수정</strong>
        <button class="close-x" type="button" aria-label="닫기" onclick="closeEditModal()">×</button>
      </div>
      <div class="bd">
        <form id="editForm" class="form" action="${contextPath}/materialSetting" method="post" enctype="multipart/form-data">
          <input type="hidden" name="num" id="f-num" />
          <div class="row">
            <label class="label">재료 사진</label>
            <div class="image-field">
              <label class="preview-circle" for="f-ifile" title="이미지 선택">
                <img id="f-preview" src="${contextPath}/img/plus.png" alt="preview" />
              </label>
              <div>
                <input class="input" type="text" id="f-selectFile" placeholder="선택된 파일 없음" readonly />
                <div class="hint">정사각형 이미지를 권장합니다. (JPG/PNG)</div>
              </div>
            </div>
          </div>
          <div class="row">
            <label class="label" for="f-name">재료명<span style="color:#ef4444"> *</span></label>
            <input class="input" type="text" name="name" id="f-name" required />
          </div>
          <div class="row">
            <label class="label" for="f-unit">단위<span style="color:#ef4444"> *</span></label>
            <input class="input" type="text" name="unit" id="f-unit" placeholder="kg / L / 개" required />
          </div>
          <div class="row">
            <label class="label" for="f-unitPrice">단가</label>
            <input class="input" type="number" name="unitPrice" id="f-unitPrice" step="100" min="0" />
          </div>
          <div class="row">
            <label class="label" for="f-step">주문단위(팩당 단위수)</label>
            <input class="input" type="number" name="step" id="f-step" step="1" min="1" />
          </div>
          <input type="file" name="ifile" id="f-ifile" accept="image/*" style="display:none" />
          <div class="actions">
            <button class="btn primary" type="submit">저장</button>
            <button class="btn" type="button" onclick="closeEditModal()">취소</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  
  <!-- Append Modal: material-settings.jsp의 폼을 재사용 -->
  <div id="appendModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="dialog">
      <div class="hd">
        <strong>재료 수정</strong>
        <button class="close-x" type="button" aria-label="닫기" onclick="closeAppendModal()">×</button>
      </div>
      <div class="bd">
        <form id="appendForm" class="form" action="${contextPath}/materialSetting" method="post" enctype="multipart/form-data">
          <input type="hidden" name="num" id="f-num" />
          <div class="row">
            <label class="label">재료 사진</label>
            <div class="image-field">
              <label class="preview-circle" for="f-ifile" title="이미지 선택">
                <img id="f-preview" src="${contextPath}/img/plus.png" alt="preview" />
              </label>
              <div>
                <input class="input" type="text" id="f-selectFile" placeholder="선택된 파일 없음" readonly />
                <div class="hint">정사각형 이미지를 권장합니다. (JPG/PNG)</div>
              </div>
            </div>
          </div>
          <div class="row">
            <label class="label" for="f-name">재료명<span style="color:#ef4444"> *</span></label>
            <input class="input" type="text" name="name" id="f-name" required />
          </div>
          <div class="row">
            <label class="label" for="f-unit">단위<span style="color:#ef4444"> *</span></label>
            <input class="input" type="text" name="unit" id="f-unit" placeholder="kg / L / 개" required />
          </div>
          <div class="row">
            <label class="label" for="f-unitPrice">단가</label>
            <input class="input" type="number" name="unitPrice" id="f-unitPrice" step="100" min="0" />
          </div>
          <div class="row">
            <label class="label" for="f-step">주문단위(팩당 단위수)</label>
            <input class="input" type="number" name="step" id="f-step" step="1" min="1" />
          </div>
          <input type="file" name="ifile" id="f-ifile" accept="image/*" style="display:none" />
          <div class="actions">
            <button class="btn primary" type="submit">저장</button>
            <button class="btn" type="button" onclick="closeAppendModal()">취소</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Deletion fallback form (non-JS) -->
  <form id="fallbackDeleteForm" method="post" style="display:none"></form>

  <script>
    const $ = (sel, el=document) => el.querySelector(sel);
    const $$ = (sel, el=document) => Array.from(el.querySelectorAll(sel));

    // Table action handlers
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
        fetch(url, { method: 'POST' }) // 서버에 맞게 변경하세요
          .then(res => { if(!res.ok) throw new Error('서버 오류'); return res.text(); })
          .then(() => { tr.parentNode.removeChild(tr); })
          .catch(err => { alert('삭제 실패: ' + err.message); btn.disabled = false; })
      }else if(action === 'append'){
    	  openAppend();
      }
    });

    // Modal open/close
    const editModal = $('#editModal');
    const appendModal = $('#appendModal');
    function openEdit(tr){
    	//console.log(tr);
      if(!tr) return;
      // Fill form with row dataset
      $('#f-num').value = tr.dataset.id || '';
      $('#f-name').value = tr.dataset.name || '';
      $('#f-unit').value = tr.dataset.unit || '';
      $('#f-unitPrice').value = tr.dataset.unitprice || '';
      $('#f-step').value = tr.dataset.step || '';
      const img = tr.dataset.img;
      //if(img){ $('#f-preview').src = `${'${contextPath}'}/imageView?filename=${'${'}img${'}'}`; }
      //else{ $('#f-preview').src = `${'${contextPath}'}/img/plus.png`; }
      $('#f-selectFile').value = '';
      editModal.classList.add('show');
      editModal.setAttribute('aria-hidden', 'false');
      setTimeout(()=>{ $('#f-name').focus(); }, 0);
    }
    function closeEditModal(){
      modal.classList.remove('show');
      modal.setAttribute('aria-hidden', 'true');
      $('#editForm').reset();
    }
    editModal.addEventListener('click', (e)=>{ if(e.target === modal) closeEditModal(); });
    document.addEventListener('keydown', (e)=>{ if(e.key==='Escape' && editModal.classList.contains('show')) closeEditModal(); });

    function openAppend(){
    	//console.log(tr);
      // Fill form with row dataset
      $('#f-selectFile').value = '';
      appendModal.classList.add('show');
      appendModal.setAttribute('aria-hidden', 'false');
      setTimeout(()=>{ $('#f-name').focus(); }, 0);
    }
    function closeAppendModal(){
      appendModal.classList.remove('show');
      appendModal.setAttribute('aria-hidden', 'true');
      $('#editForm').reset();
    }
    appendModal.addEventListener('click', (e)=>{ if(e.target === modal) closeAppendModal(); });
    document.addEventListener('keydown', (e)=>{ if(e.key==='Escape' && appendModal.classList.contains('show')) closeAppendModal(); });

    // Image preview (reuse from material-settings)
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
  </script>
</body>
</html>
