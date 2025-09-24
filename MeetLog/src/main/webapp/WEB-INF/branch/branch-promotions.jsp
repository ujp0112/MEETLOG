<%-- branch-promotions.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>진행중인 프로모션</title>
    <style>
        :root { --bg: #f6faf8; --surface: #ffffff; --border: #e5e7eb; --muted: #6b7280; --title: #0f172a; --primary: #2f855a; }
        
        body {
            margin: 0;
            background: var(--bg);
            color: var(--title);
            font: 14px/1.45 system-ui, -apple-system, sans-serif;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        main {
            max-width: 1100px;
            margin: 20px auto;
        }
        .panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(16,24,40,.05);
        }
        .panel .hd {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 16px 18px;
            border-bottom: 1px solid var(--border);
        }
        .panel .bd {
            padding: 16px 18px;
        }
        .title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
        }
        
        /* --- 프로모션 카드 그리드 및 스타일 --- */
        .promo-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }
        .promo-card {
            display: flex;
            gap: 16px;
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: var(--surface);
            transition: .2s;
            overflow: hidden;
        }
        .promo-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,.08);
            transform: translateY(-2px);
            border-color: #d1d5db;
        }
        .promo-card .thumb {
            width: 90px;
            height: 90px;
            flex-shrink: 0;
            border-radius: 8px;
            object-fit: cover;
        }
        .promo-card-content {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            flex: 1;
        }
        .promo-card-title {
            margin: 0 0 8px 0;
            font-size: 16px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-weight: 700;
        }
        .promo-card-desc {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2; /* 2줄까지만 보이도록 설정 */
            -webkit-box-orient: vertical;
            line-height: 1.4em;
            height: 2.8em; /* 1.4em * 2 lines */
        }
        .promo-card-date {
            font-weight: 600;
            margin-top: auto;
            padding-top: 8px;
            color: var(--primary);
            font-size: 13px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/layout/branchheader.jspf"%>
    <main>
        <section class="panel">
            <div class="hd">
                <h1 class="title">진행/예정 프로모션</h1>
            </div>
            <div class="bd">
                <c:if test="${empty promotions}">
                    <div style="text-align:center; padding: 48px; color: var(--muted);">
                        <p>현재 진행중이거나 예정된 프로모션이 없습니다.</p>
                    </div>
                </c:if>
                <div class="promo-grid">
                    <c:forEach var="p" items="${promotions}">
                        <c:url var="viewUrl" value="/branch/promotion/view">
                            <c:param name="id" value="${p.id}" />
                        </c:url>
                        <a href="${viewUrl}" class="promo-card">
                            <mytag:image fileName="${p.imgPath}" altText="${p.title}" cssClass="thumb" />
                            <div class="promo-card-content">
                                <h3 class="promo-card-title">${p.title}</h3>
                                <p class="promo-card-desc">${p.description}</p>
                                <p class="promo-card-date">
                                    <fmt:formatDate value="${p.startDate}" pattern="MM.dd" /> ~ <fmt:formatDate value="${p.endDate}" pattern="MM.dd" />
                                </p>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>
    </main>
</body>
</html>