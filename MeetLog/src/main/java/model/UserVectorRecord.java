package model;

import java.time.LocalDateTime;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 사용자 리뷰 기반 임베딩 벡터 캐시 레코드.
 */
public class UserVectorRecord {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    private int userId;
    private String vectorJson;
    private String status;
    private LocalDateTime updatedAt;
    private String lastError;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getVectorJson() {
        return vectorJson;
    }

    public void setVectorJson(String vectorJson) {
        this.vectorJson = vectorJson;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getLastError() {
        return lastError;
    }

    public void setLastError(String lastError) {
        this.lastError = lastError;
    }

    /**
     * 저장된 JSON 문자열을 double 배열로 역직렬화합니다.
     *
     * @return double 배열, 존재하지 않으면 null
     */
    public double[] getVector() {
        if (vectorJson == null || vectorJson.isBlank()) {
            return null;
        }
        try {
            Double[] wrapper = objectMapper.readValue(vectorJson, Double[].class);
            double[] primitive = new double[wrapper.length];
            for (int i = 0; i < wrapper.length; i++) {
                primitive[i] = wrapper[i] != null ? wrapper[i] : 0.0;
            }
            return primitive;
        } catch (Exception e) {
            return null;
        }
    }
}

