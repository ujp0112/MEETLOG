<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>결제 결과</title>
    <script>
        (function() {
            const params = new URLSearchParams(window.location.search);
            const resultCode = params.get('resultCode');
            const resultMessage = params.get('resultMessage');
            const merchantPayKey = params.get('merchantPayKey');
            const paymentId = params.get('paymentId');

            if (!merchantPayKey || !paymentId || !resultCode) {
                document.getElementById('status').textContent = '결제 결과 정보가 올바르지 않습니다.';
                return;
            }

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/payment/naver/manual-confirm';

            const fields = { resultCode, resultMessage, merchantPayKey, paymentId };
            Object.entries(fields).forEach(([key, value]) => {
                if (value !== null) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    form.appendChild(input);
                }
            });

            document.body.appendChild(form);
            form.submit();
        })();
    </script>
</head>
<body>
    <p id="status">결제 결과를 확인 중입니다...</p>
</body>
</html>
