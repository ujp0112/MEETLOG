<!-- File: webapp/hq/promotion-management.jsp -->
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
  <title>본사 · 프로모션 관리</title>
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
<%@ include file="/WEB-INF/layout/header.jspf" %>

  <main>
    <section class="panel" aria-labelledby="pageTitle">
      <div class="hd">
        <h1 id="pageTitle" class="title">프로모션 관리</h1>
        <span class="pill">HQ</span>
        <div style="flex:1 1 auto"></div>
        <button class="btn primary" data-action="append">+ 프로모션 추가</button>
      </div>
      <div class="bd">
        <!-- toolbar -->
        

        <div class="table-wrap" role="region" aria-label="공지 목록">
          <table class="sheet" role="grid">
            <!-- 프로모션 테이블 -->
          </table>
        </div>
      </div>
    </section>
  </main>

</body>
</html>
