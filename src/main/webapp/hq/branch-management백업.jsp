<!-- File: webapp/hq/branch-management.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MEET LOG - 지점 관리</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
:root { -
	-bg: #f6faf8; /* page background */ -
	-surface: #ffffff; /* card surface */ -
	-border: #e5e7eb; /* neutral border */ -
	-muted: #6b7280; /* label text */ -
	-title: #0f172a; /* dark text */ -
	-primary: #2f855a; /* green */ -
	-primary-600: #27764f; /* green hover */ -
	-ring: #93c5aa; /* focus ring */
}

* {
	box-sizing: border-box;
}

html, body {
	height: 100%;
}

body {
	margin: 0;
	font-family: system-ui, -apple-system, Segoe UI, Roboto,
		Apple SD Gothic Neo, Noto Sans KR, sans-serif;
	background: var(- -bg);
	color: var(- -title);
} /* Header */
.page {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

.topbar {
	height: 56px;
	background: rgba(255, 255, 255, .9);
	backdrop-filter: saturate(180%) blur(8px);
	border-bottom: 1px solid var(- -border);
	display: flex;
	align-items: center;
	padding: 0 16px;
}

.brand {
	font-weight: 700;
	color: var(- -primary);
} /* Main */
.main {
	flex: 1;
	display: grid;
	place-items: start center;
	padding: 32px 16px;
}

.title {
	text-align: center;
	font-weight: 800;
	font-size: 22px;
	margin: 0 0 18px;
}

.card {
	width: 100%;
	max-width: 720px;
	background: var(- -surface);
	border: 1px solid var(- -border);
	border-radius: 20px;
	box-shadow: 0 8px 20px rgba(16, 24, 40, .06);
	padding: 22px;
} /* Form layout */
.form {
	display: grid;
	gap: 14px;
}

.row {
	display: grid;
	grid-template-columns: 160px 1fr;
	align-items: center;
	gap: 12px;
}

.label {
	color: var(- -muted);
	font-size: 14px;
} /* Inputs */
.input {
	width: 100%;
	padding: 12px 14px;
	border: 1px solid var(- -border);
	border-radius: 12px;
	background: #fff;
	outline: none;
	font-size: 14px;
	transition: border-color .15s, box-shadow .15s;
}

.input:focus {
	border-color: var(- -primary);
	box-shadow: 0 0 0 3px var(- -ring);
} /* Image picker */
.image-field {
	display: grid;
	grid-template-columns: 72px 1fr;
	gap: 12px;
	align-items: center;
}

.preview-circle {
	width: 72px;
	height: 72px;
	border-radius: 10px;
	border: 2px dashed var(- -border);
	background: #fafafa;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
	cursor: pointer;
}

.preview-circle img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.hint {
	color: var(- -muted);
	font-size: 12px;
} /* Actions */
.actions {
	display: flex;
	gap: 10px;
	justify-content: center;
	margin-top: 8px;
}

.btn {
	appearance: none;
	border: 1px solid var(- -border);
	background: #fff;
	padding: 12px 18px;
	border-radius: 999px;
	font-weight: 700;
	cursor: pointer;
	transition: transform .05s ease, background .15s, border-color .15s,
		color .15s;
}

.btn:active {
	transform: translateY(1px);
}

.btn.primary {
	background: var(- -primary);
	border-color: var(- -primary);
	color: #fff;
}

.btn.primary:hover {
	background: var(- -primary-600);
}

.btn.ghost {
	background: #fff;
}

.btn.ghost:hover {
	background: #f8fafc;
} /* old table fallback (hidden) */
table {
	display: none;
} /* Responsive */
@media ( max-width :560px) {
	.row {
		grid-template-columns: 1fr;
	}
}
/* Shell with left sidebar include */
    .shell{max-width:1280px;margin:0 auto;padding:20px;display:grid;grid-template-columns:260px minmax(0,1fr);gap:20px}
    @media (max-width: 960px){.shell{grid-template-columns:1fr}}

</style>
</head>
<body>
    <jsp:include page="/WEB-INF/jspf/header.jspf" />
	<div class="page">
		<!-- <header class="topbar"> <div class="brand">MeetLog • HQ</div> </header> -->
		<main id="main-content" class="flex-grow">
            <div class="page-content container mx-auto p-8">
                <h2 class="text-3xl font-bold mb-8">🏪 지점 관리</h2>
                <div class="bg-white p-6 rounded-lg shadow">
                    <h3 class="font-bold text-xl mb-4">신규 지점 추가 요청</h3>
                    <div class="space-y-2">
                        <div class="flex justify-between items-center p-3 border rounded-md">
                            <div>
                                <p class="font-bold">우부래도 강남점</p>
                                <p class="text-sm text-slate-500">주소: 서울시 강남구 테헤란로 123</p>
                            </div>
                            <div class="space-x-2">
                                <button class="bg-sky-500 text-white text-sm font-bold py-1 px-3 rounded-md">승인</button>
                                <button class="bg-red-500 text-white text-sm font-bold py-1 px-3 rounded-md">거절</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
	</div>

</body>
</html>