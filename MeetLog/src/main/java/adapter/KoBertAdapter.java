package adapter;

import com.fasterxml.jackson.databind.ObjectMapper;
import service.port.RecommendationPort;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * KoBERT FastAPI 서버를 통해 RecommendationPort의 기능을 구현한 어댑터
 */
public class KoBertAdapter implements RecommendationPort {
    private static final String API_URL = "http://127.0.0.1:8000/vectorize";
    private static final int MAX_RETRIES = 3;
    private static final int INITIAL_BACKOFF_MS = 100;

    private final HttpClient client = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_1_1)
            .build();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public double[] getVectorFromText(String text) {
        return getVectorWithRetry(text, MAX_RETRIES);
    }

    /**
     * 재시도 로직이 포함된 벡터 변환 메서드
     */
    private double[] getVectorWithRetry(String text, int maxRetries) {
        Exception lastException = null;

        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                double[] result = callKoBertAPI(text);
                if (result != null) {
                    return result;
                }

                // null 반환인 경우도 재시도 (서버 응답이 있지만 처리 실패)
                if (attempt < maxRetries) {
                    int backoffTime = INITIAL_BACKOFF_MS * (int) Math.pow(2, attempt - 1);
                    System.out.println("KoBERT API 호출 실패. " + attempt + "번째 시도 실패. "
                        + backoffTime + "ms 후 재시도...");
                    Thread.sleep(backoffTime);
                }

            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                System.err.println("재시도 중 인터럽트 발생: " + e.getMessage());
                return null;
            } catch (Exception e) {
                lastException = e;

                if (attempt < maxRetries) {
                    int backoffTime = INITIAL_BACKOFF_MS * (int) Math.pow(2, attempt - 1);
                    System.err.println("KoBERT API 호출 중 예외 발생 (" + attempt + "/" + maxRetries
                        + "): " + e.getMessage() + ". " + backoffTime + "ms 후 재시도...");
                    try {
                        Thread.sleep(backoffTime);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        return null;
                    }
                }
            }
        }

        // 모든 재시도 실패
        System.err.println("KoBERT API 호출 " + maxRetries + "회 모두 실패. 마지막 예외: "
            + (lastException != null ? lastException.getMessage() : "알 수 없음"));
        if (lastException != null) {
            lastException.printStackTrace();
        }
        return null;
    }

    /**
     * 실제 KoBERT API 호출 로직
     */
    private double[] callKoBertAPI(String text) throws Exception {
        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("text", text);
        String jsonBody = objectMapper.writeValueAsString(requestBody);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .header("Content-Type", "application/json")
                .timeout(java.time.Duration.ofSeconds(10)) // 타임아웃 설정
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            Map<String, Object> result = objectMapper.readValue(response.body(), Map.class);
            @SuppressWarnings("unchecked")
            List<Double> vectorList = (List<Double>) result.get("vector");

            if (vectorList == null || vectorList.isEmpty()) {
                System.err.println("KoBERT API 응답에 벡터가 없음");
                return null;
            }

            return vectorList.stream().mapToDouble(Double::doubleValue).toArray();
        } else {
            System.err.println("KoBERT API 호출 실패. 응답 코드: " + response.statusCode()
                + ", 응답 본문: " + response.body());
            return null;
        }
    }
}
