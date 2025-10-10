package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import dao.TelegramMessageLogDAO;
import dao.TgLinkDAO;
import model.TgLink;
import model.TelegramMessageLog;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import util.AppConfig;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * 텔레그램 봇 API 서비스
 * 메시지 발송 및 봇 업데이트 조회
 */
public class TelegramService {
    private static final Logger log = LoggerFactory.getLogger(TelegramService.class);
    private final TgLinkDAO tgLinkDAO = new TgLinkDAO();
    private final TelegramMessageLogDAO messageLogDAO = new TelegramMessageLogDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private final String botToken;
    private final String baseUrl;

    public TelegramService() {
        this.botToken = AppConfig.getProperty("telegram.bot.token", "");
        this.baseUrl = AppConfig.getProperty("telegram.baseUrl", "https://api.telegram.org");
    }

    /**
     * 사용자에게 메시지 발송
     *
     * @param userId 사용자 ID
     * @param message 메시지 내용
     * @param messageType 메시지 타입
     * @param referenceType 참조 타입 (reservation, payment 등)
     * @param referenceId 참조 ID
     * @return 성공 여부
     */
    public boolean sendMessageToUser(int userId, String message, String messageType,
                                      String referenceType, Long referenceId) {
        TgLink link = tgLinkDAO.findByUserId(userId);

        if (link == null) {
            log.debug("텔레그램 연결 정보 없음: userId={}", userId);
            return false;
        }

        if (!link.isActive()) {
            log.debug("텔레그램 연결 비활성 상태: userId={}, state={}", userId, link.getState());
            return false;
        }

        if (link.getChatId() == null || link.getChatId().isEmpty()) {
            log.warn("chat_id 없음: userId={}", userId);
            return false;
        }

        return sendMessage(link, message, messageType, referenceType, referenceId);
    }

    /**
     * 메시지 발송 (내부 메서드)
     */
    private boolean sendMessage(TgLink link, String message, String messageType,
                                 String referenceType, Long referenceId) {
        try {
            String apiUrl = String.format("%s/bot%s/sendMessage", baseUrl, botToken);
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            conn.setDoOutput(true);

            // JSON 페이로드 생성
            String jsonPayload = String.format(
                    "{\"chat_id\":\"%s\",\"text\":\"%s\",\"parse_mode\":\"Markdown\"}",
                    link.getChatId(),
                    escapeJson(message)
            );

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();

            if (responseCode == 200) {
                // 성공 로그
                messageLogDAO.logSuccess(
                        link.getId(),
                        link.getChatId(),
                        messageType,
                        message,
                        referenceType,
                        referenceId
                );
                log.info("텔레그램 메시지 발송 성공: userId={}, chatId={}", link.getUserId(), link.getChatId());
                return true;

            } else if (responseCode == 403) {
                // 차단됨 - BLOCKED 상태로 변경
                tgLinkDAO.updateStateByChatId(link.getChatId(), TgLink.STATE_BLOCKED);
                messageLogDAO.logFailure(
                        link.getId(),
                        link.getChatId(),
                        messageType,
                        message,
                        "User blocked the bot (403)",
                        TelegramMessageLog.STATUS_BLOCKED
                );
                log.warn("텔레그램 봇 차단됨: userId={}, chatId={}", link.getUserId(), link.getChatId());
                return false;

            } else {
                // 기타 오류
                String errorBody = readResponse(conn.getErrorStream());
                messageLogDAO.logFailure(
                        link.getId(),
                        link.getChatId(),
                        messageType,
                        message,
                        "HTTP " + responseCode + ": " + errorBody,
                        TelegramMessageLog.STATUS_FAILED
                );
                log.error("텔레그램 메시지 발송 실패: userId={}, responseCode={}, error={}",
                        link.getUserId(), responseCode, errorBody);
                return false;
            }

        } catch (Exception e) {
            log.error("텔레그램 메시지 발송 예외: userId={}", link.getUserId(), e);
            messageLogDAO.logFailure(
                    link.getId(),
                    link.getChatId(),
                    messageType,
                    message,
                    "Exception: " + e.getMessage(),
                    TelegramMessageLog.STATUS_FAILED
            );
            return false;
        }
    }

    /**
     * 봇 업데이트 가져오기 (롱 폴링)
     *
     * @param offset 마지막 update_id + 1
     * @param timeout 타임아웃 (초)
     * @return JSON 응답 또는 null
     */
    public JsonNode getUpdates(long offset, int timeout) {
        try {
            String apiUrl = String.format("%s/bot%s/getUpdates?offset=%d&timeout=%d",
                    baseUrl, botToken, offset, timeout);
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout((timeout + 5) * 1000);
            conn.setReadTimeout((timeout + 5) * 1000);

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                String response = readResponse(conn.getInputStream());
                return objectMapper.readTree(response);
            } else {
                log.error("getUpdates 실패: responseCode={}", responseCode);
                return null;
            }

        } catch (Exception e) {
            log.error("getUpdates 예외", e);
            return null;
        }
    }

    /**
     * JSON 문자열 이스케이프 (간단한 구현)
     */
    private String escapeJson(String text) {
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    /**
     * 응답 스트림 읽기
     */
    private String readResponse(java.io.InputStream inputStream) throws Exception {
        if (inputStream == null) return "";

        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            return response.toString();
        }
    }
}
