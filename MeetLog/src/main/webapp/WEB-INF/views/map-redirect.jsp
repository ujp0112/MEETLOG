<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>지도로 이동 중...</title>
<meta charset="UTF-8">
</head>
<body>
	<p>지도로 이동 중입니다. 잠시만 기다려주세요...</p>

	<script>
		// ▼▼▼ [수정] 변수명을 'location' -> 'searchLocation'으로 변경 ▼▼▼
		const searchLocation = '<c:out value="${location}" escapeXml="true" />';

		if (searchLocation) {
			const kakaoMapUrl = 'https://map.kakao.com/link/search/'
					+ encodeURIComponent(searchLocation);

			// 사용자를 카카오맵 URL로 즉시 이동시킵니다.
			window.location.replace(kakaoMapUrl);
		} else {
			alert('장소 정보가 없어 지도를 표시할 수 없습니다.');
			window.history.back();
		}
	</script>
</body>
</html>