<!-- File: webapp/hq/material-management.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
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
    .cell-id{text-align:left}

    .thumb{width:40px;height:40px;border-radius:8px;border:1px solid var(--border);object-fit:cover;background:#fafafa;display:block}
    .row-actions{display:flex;gap:6px}

    .empty{color:var(--muted);text-align:center;padding:24px}

    /* Modal (edit/append form) */
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
<%@ include file="/WEB-INF/jspf/header.jspf" %>

  <main>
    <section class="panel" aria-labelledby="pageTitle">
      <div class="hd">
        <h1 id="pageTitle" class="title">재료 관리</h1>
        <span class="pill">HQ</span>
        <div style="flex:1 1 auto"></div>
        <button class="btn primary" data-action="append">+ 재료 추가</button>
      </div>
      <div class="bd">
        <!-- toolbar -->
        <form method="get" class="toolbar" style="margin-bottom:12px">
          <div class="field"><span style="color:var(--muted)">검색</span><input name="q" value="${fn:escapeXml(param.q)}" placeholder="재료명/단위/브랜드"/></div>
          <button class="btn" type="submit">검색</button>
          <!-- 초기화는 서블릿 경유로 -->
          <a class="btn" href="${contextPath}/hq/materials">초기화</a>
        </form>

        <div class="table-wrap" role="region" aria-label="재료 목록">
          <table class="sheet" role="grid">
            <thead>
              <tr>
                <th style="width:56px">이미지</th>
                <th>재료명</th>
                <th style="width:120px">단위</th>
                <th style="width:120px">단가</th>
                <th style="width:120px">주문단위</th>
                <th style="width:140px">가격</th>
                <th style="width:132px">관리</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="m" items="${materials}">
                <tr id="row-${m.id}"
                    data-id="${m.id}"
                    data-name="${fn:escapeXml(m.name)}"
                    data-unit="${fn:escapeXml(m.unit)}"
                    data-unitprice="${m.unitPrice}"
                    data-step="${m.step}"
                    data-img="${contextPath}${m.imgPath}"
                    data-img-path="${m.imgPath}">
                  <td>
                    <c:choose>
                      <c:when test="${not empty m.imgPath}">
                        <img class="thumb" src="${contextPath}${m.imgPath}" alt="${fn:escapeXml(m.name)}"/>
                      </c:when>
                      <c:otherwise>
                        <span class="thumb" style="display:grid;place-items:center">🥬</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>${m.name}</td>
                  <td>${m.unit}</td>
                  <td class="cell-id"><fmt:formatNumber value="${m.unitPrice}" /></td>
                  <td class="cell-id"><fmt:formatNumber value="${m.step}" /></td>
                  <td class="cell-id"><fmt:formatNumber value="${(m.unitPrice) * (m.step)}" /></td>
                  <td>
                    <div class="row-actions">
                      <button type="button" class="btn-sm" data-action="edit">수정</button>
                      <button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="${contextPath}/hq/materials/${m.id}/delete">삭제</button>
                    </div>
                  </td>
                </tr>
              </c:forEach>

              <c:if test="${empty materials}">
                <!-- MOCK 예시(서버 데이터 없을 때만 노출) -->
                <tr id="row-m1" data-id="m1" data-name="로메인" data-unit="kg" data-unitprice="4500" data-step="5" data-img="">
                  <td><span class="thumb" style="display:grid;place-items:center">🥬</span></td>
                  <td>로메인</td><td>kg</td><td class="cell-id">4,500</td><td class="cell-id">5</td><td class="cell-id">22,500</td>
                  <td><div class="row-actions"><button type="button" class="btn-sm" data-action="edit">수정</button><button type="button" class="btn-sm btn-danger" data-action="delete" data-delete-url="#mock">삭제</button></div></td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </section>
  </main>

  <!-- Edit Modal -->
  <div id="editModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="dialog">
      <div class="hd">
        <strong>재료 수정</strong>
        <button class="close-x" type="button" aria-label="닫기" onclick="closeEditModal()">×</button>
      </div>
      <div class="bd">
        <!-- 수정: action은 JS에서 /hq/materials/{id}/edit 로 세팅 -->
        <form id="editForm" class="form" method="post" enctype="multipart/form-data">
          <input type="hidden" name="id"            id="f-id" />
          <input type="hidden" name="prev_img_path" id="f-prev" />
          <div class="row">
            <label class="label">재료 사진</label>
            <div class="image-field">
              <label class="preview-circle" for="f-image" title="이미지 선택">
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
            <input class="input" type="number" name="unit_price" id="f-unitPrice" step="0.01" min="0" />
          </div>
          <div class="row">
            <label class="label" for="f-step">주문단위(팩당 단위수)</label>
            <input class="input" type="number" name="step" id="f-step" step="0.01" min="0" />
          </div>

          <!-- 이미지 URL(텍스트 우선) + 파일 업로드(대체) -->
          <div class="row">
            <label class="label" for="f-imgPath">이미지 URL</label>
            <input class="input" type="text" name="img_path" id="f-imgPath" placeholder="/uploads/materials/xxx.jpg" />
          </div>
          <input type="file" name="image" id="f-image" accept="image/*" style="display:none" />

          <div class="actions">
            <button class="btn primary" type="submit">저장</button>
            <button class="btn" type="button" onclick="closeEditModal()">취소</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Append Modal -->
  <div id="appendModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="dialog">
      <div class="hd">
        <strong>재료 추가</strong>
        <button class="close-x" type="button" aria-label="닫기" onclick="closeAppendModal()">×</button>
      </div>
      <div class="bd">
        <!-- 생성: POST /hq/materials -->
        <form id="appendForm" class="form" action="${contextPath}/hq/materials" method="post" enctype="multipart/form-data">
          <div class="row">
            <label class="label">재료 사진</label>
            <div class="image-field">
              <label class="preview-circle" for="a-image" title="이미지 선택">
                <img id="a-preview" src="${contextPath}/img/plus.png" alt="preview" />
              </label>
              <div>
                <input class="input" type="text" id="a-selectFile" placeholder="선택된 파일 없음" readonly />
                <div class="hint">정사각형 이미지를 권장합니다. (JPG/PNG)</div>
              </div>
            </div>
          </div>
          <div class="row">
            <label class="label" for="a-name">재료명<span style="color:#ef4444"> *</span></label>
            <input class="input" type="text" name="name" id="a-name" required />
          </div>
          <div class="row">
            <label class="label" for="a-unit">단위<span style="color:#ef4444"> *</span></label>
            <input class="input" type="text" name="unit" id="a-unit" placeholder="kg / L / 개" required />
          </div>
          <div class="row">
            <label class="label" for="a-unitPrice">단가</label>
            <input class="input" type="number" name="unit_price" id="a-unitPrice" step="0.01" min="0" />
          </div>
          <div class="row">
            <label class="label" for="a-step">주문단위(팩당 단위수)</label>
            <input class="input" type="number" name="step" id="a-step" step="0.01" min="0" />
          </div>

          <!-- 이미지 URL(텍스트) + 파일 -->
          <div class="row">
            <label class="label" for="a-imgPath">이미지 URL</label>
            <input class="input" type="text" name="img_path" id="a-imgPath" placeholder="/uploads/materials/xxx.jpg" />
          </div>
          <input type="file" name="image" id="a-image" accept="image/*" style="display:none" />

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
    const $  = (sel, el=document) => el.querySelector(sel);
    const $$ = (sel, el=document) => Array.from(el.querySelectorAll(sel));

    // Table action handlers (edit / delete / append)
    document.addEventListener('click', (e) => {
      const btn = e.target.closest('button'); if(!btn) return;
      const action = btn.dataset.action;

      if(action === 'edit'){
        const tr = btn.closest('tr'); openEdit(tr);
      }else if(action === 'delete'){
        const tr = btn.closest('tr');
        const url = btn.dataset.deleteUrl;
        if(url === '#mock'){ tr.remove(); return; }
        if(!url) return;
        if(!confirm('삭제하시겠어요?')) return;
        btn.disabled = true;
        fetch(url, { method: 'POST' })
          .then(res => { if(!res.ok) throw new Error('서버 오류'); return res.text(); })
          .then(()  => { tr.parentNode.removeChild(tr); })
          .catch(err => { alert('삭제 실패: ' + err.message); btn.disabled = false; });
      }else if(action === 'append'){
        openAppend();
      }
    });

    // ===== Edit Modal =====
    const editModal = $('#editModal');
    const editForm  = $('#editForm');

    function openEdit(tr){
      if(!tr) return;
      const id = tr.dataset.id || '';
      editForm.action = '${contextPath}/hq/materials/' + id + '/edit'; // POST {id}/edit

      // 채우기
      $('#f-id').value        = id;
      $('#f-name').value      = tr.dataset.name || '';
      $('#f-unit').value      = tr.dataset.unit || '';
      $('#f-unitPrice').value = tr.dataset.unitprice || '';
      $('#f-step').value      = tr.dataset.step || '';

      // 이미지 보존/미리보기
      const absImg  = tr.dataset.img || '';       // 화면용(절대)
      const relPath = tr.dataset.imgPath || '';   // 서버 저장용(상대: /uploads/..)
      $('#f-preview').src = absImg || '${contextPath}/img/plus.png';
      $('#f-prev').value  = relPath;
      $('#f-imgPath').value = relPath;

      $('#f-selectFile').value = '';
      editModal.classList.add('show');
      editModal.setAttribute('aria-hidden', 'false');
      setTimeout(()=>{ $('#f-name').focus(); }, 0);
    }
    function closeEditModal(){
      editModal.classList.remove('show');
      editModal.setAttribute('aria-hidden', 'true');
      editForm.reset();
      $('#f-preview').src = '${contextPath}/img/plus.png';
    }
    editModal.addEventListener('click', (e)=>{ if(e.target === editModal) closeEditModal(); });
    document.addEventListener('keydown', (e)=>{ if(e.key==='Escape' && editModal.classList.contains('show')) closeEditModal(); });

    // 파일 미리보기 (Edit)
    const fImage = $('#f-image'), fPreview = $('#f-preview'), fSelectFile = $('#f-selectFile');
    //$('.preview-circle[for="f-image"]').addEventListener('click', ()=> fImage.click());
    fImage.addEventListener('change', function(){
      if(this.files && this.files[0]){
        const f = this.files[0];
        fSelectFile.value = f.name;
        const reader = new FileReader();
        reader.onload = e => fPreview.src = e.target.result;
        reader.readAsDataURL(f);
      }
    });

    // ===== Append Modal =====
    const appendModal = $('#appendModal');
    const appendForm  = $('#appendForm');

    function openAppend(){
      appendForm.reset();
      // 초기 상태
      $('#a-preview').src = '${contextPath}/img/plus.png';
      $('#a-selectFile').value = '';
      appendModal.classList.add('show');
      appendModal.setAttribute('aria-hidden', 'false');
      setTimeout(()=>{ $('#a-name').focus(); }, 0);
    }
    function closeAppendModal(){
      appendModal.classList.remove('show');
      appendModal.setAttribute('aria-hidden', 'true');
      appendForm.reset();
      $('#a-preview').src = '${contextPath}/img/plus.png';
    }
    appendModal.addEventListener('click', (e)=>{ if(e.target === appendModal) closeAppendModal(); });
    document.addEventListener('keydown', (e)=>{ if(e.key==='Escape' && appendModal.classList.contains('show')) closeAppendModal(); });

    // 파일 미리보기 (Append)
    const aImage = $('#a-image'), aPreview = $('#a-preview'), aSelectFile = $('#a-selectFile');
    //$('.preview-circle[for="a-image"]').addEventListener('click', ()=> aImage.click());
    aImage.addEventListener('change', function(){
      if(this.files && this.files[0]){
        const f = this.files[0];
        aSelectFile.value = f.name;
        const reader = new FileReader();
        reader.onload = e => aPreview.src = e.target.result;
        reader.readAsDataURL(f);
      }
    });
  </script>
</body>
</html>
