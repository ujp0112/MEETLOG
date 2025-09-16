<!-- File: webapp/branch/inventory.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- 서버사이드 페이징: pageSize=10 고정 -->
<c:set var="pageSize" value="10"/>
<c:set var="currentPage" value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}"/>
<c:if test="${currentPage lt 1}"><c:set var="currentPage" value="1"/></c:if>
<c:set var="totalCount" value="${empty requestScope.totalCount ? 0 : requestScope.totalCount}"/>
<c:set var="totalPages" value="${(totalCount + pageSize - 1) / pageSize}"/>
<c:if test="${totalPages lt 1}"><c:set var="totalPages" value="1"/></c:if>
<c:set var="shownCount" value="${empty inventories ? 0 : fn:length(inventories)}"/>
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
<title>MEET LOG - 재고량</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
:root{--bg:#f6faf8;--surface:#ffffff;--border:#e5e7eb;--muted:#6b7280;--title:#0f172a;--primary:#2f855a;--primary-600:#27764f;--ring:#93c5aa}
*{box-sizing:border-box}
html,body{height:100%}
body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif;background:var(--bg);color:var(--title)}
.container{max-width:1200px;margin:0 auto;padding:20px}
.panel{max-width:1000px;background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 20px rgba(16,24,40,.05);margin:0 auto}
.panel .hd{display:flex;align-items:center;gap:10px;padding:16px 18px;border-bottom:1px solid var(--border)}
.panel .bd{padding:16px 18px}
.title{margin:0;font-weight:800;font-size:20px}

.table-wrap{border:1px solid var(--border);border-radius:14px;overflow:auto;background:#fff}
table.sheet{width:100%;border-collapse:separate;border-spacing:0;min-width:960px}
.sheet thead th{position:sticky;top:0;background:#fff;border-bottom:1px solid var(--border);font-weight:800;text-align:left;padding:12px 10px;font-size:13px}
.sheet tbody td{padding:12px 10px;border-bottom:1px solid #f1f5f9;vertical-align:middle}
.cell-num{text-align:right}
.thumb{width:40px;height:40px;border-radius:8px;border:1px solid var(--border);object-fit:cover;background:#fafafa;display:block}

.badge{display:inline-block;padding:2px 8px;border-radius:999px;border:1px solid var(--border);font-size:12px}
.badge.ok{background:#ecfdf5;color:#065f46;border-color:#a7f3d0}
.badge.warn{background:#fff7ed;color:#9a3412;border-color:#fed7aa}

.btn{appearance:none;border:1px solid var(--border);background:#fff;padding:8px 12px;border-radius:10px;font-weight:700;cursor:pointer;text-decoration:none}
.btn:hover{background:#f8fafc}
.btn.sm{padding:6px 8px;border-radius:8px}
.btn[aria-disabled="true"],.btn:disabled{opacity:.5;cursor:not-allowed}

/**** Pager ****/
.pager{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:10px}
.pager .left,.pager .right{display:flex;align-items:center;gap:8px}
.pager .btn-group{display:flex;gap:6px}
.pager .info{font-size:12px;color:var(--muted)}
</style>
</head>
<body>
  <jsp:include page="/WEB-INF/jspf/branchheader.jspf" />
  <div class="container">
    <section class="panel">
      <div class="hd">
        <h1 class="title" id="pageTitle">재고량</h1>
        <div style="flex:1 1 auto"></div>
      </div>
      <div class="bd">
        <div class="table-wrap" role="region" aria-label="재고 목록">
          <table class="sheet" role="grid" id="inventoryTable">
            <thead>
              <tr>
                <th style="width:60px">이미지</th>
                <th>재료명</th>
                <th style="width:100px">단위</th>
                <th style="width:160px">현재 재고</th>
                <th style="width:140px">안전 재고</th>
                <th style="width:160px">최근 변경일</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="it" items="${inventories}">
                <tr>
                  <td>
                    <c:choose>
                      <c:when test="${not empty it.imgfilename}">
                        <img class="thumb" src="${contextPath}/imageView?filename=${it.imgfilename}" alt="${fn:escapeXml(it.name)}"/>
                      </c:when>
                      <c:otherwise>
                        <span class="thumb" style="display:grid;place-items:center">📦</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>${it.name}</td>
                  <td>${it.unit}</td>
                  <td class="cell-num"><fmt:formatNumber value="${it.stockQty}"/> <span style="color:#64748b">${it.unit}</span></td>
                  <td class="cell-num"><fmt:formatNumber value="${it.safetyQty}"/></td>
                  <td><fmt:formatDate value="${it.updatedAt}" pattern="yyyy-MM-dd"/></td>
                </tr>
              </c:forEach>

              <c:if test="${empty inventories}">
                <!-- MOCK: 서버 데이터 없을 때 예시 3건 -->
                <tr>
                  <td><span class="thumb" style="display:grid;place-items:center">🥬</span></td>
                  <td>로메인</td>
                  <td>kg</td>
                  <td class="cell-num">12 <span style="color:#64748b">kg</span></td>
                  <td class="cell-num">10</td>
                  <td>2025-09-11</td>
                </tr>
                <tr>
                  <td><span class="thumb" style="display:grid;place-items:center">🍅</span></td>
                  <td>방울토마토</td>
                  <td>팩</td>
                  <td class="cell-num">8 <span style="color:#64748b">팩</span></td>
                  <td class="cell-num">12</td>
                  <td>2025-09-12</td>
                </tr>
                <tr>
                  <td><span class="thumb" style="display:grid;place-items:center">🍗</span></td>
                  <td>닭가슴살</td>
                  <td>kg</td>
                  <td class="cell-num">30 <span style="color:#64748b">kg</span></td>
                  <td class="cell-num">15</td>
                  <td>2025-09-10</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>

        <!-- Pager -->
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
</body>
</html>