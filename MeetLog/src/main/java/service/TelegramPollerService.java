package service;

import com.fasterxml.jackson.databind.JsonNode;
import dao.TgLinkDAO;
import model.TgLink;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import util.AppConfig;

/**
 * 텔레그램 봇 업데이트 폴링 서비스
 * /start 명령어를 수신하여 사용자 온보딩 처리
 */
public class TelegramPollerService implements Runnable {
    private static final Logger log = LoggerFactory.getLogger(TelegramPollerService.class);

    private final TelegramService telegramService;
    private final TgLinkDAO tgLinkDAO;
    private volatile boolean running = true;
    private long lastUpdateId = 0;

    public TelegramPollerService() {
        this.telegramService = new TelegramService();
        this.tgLinkDAO = new TgLinkDAO();
    }

    @Override
    public void run() {
        log.info("텔레그램 폴러 시작");

        int timeout = Integer.parseInt(AppConfig.getProperty("telegram.poll.timeout", "50"));

        while (running) {
            try {
                // getUpdates 호출 (롱 폴링)
                JsonNode response = telegramService.getUpdates(lastUpdateId, timeout);

                if (response == null) {
                    Thread.sleep(1000);
                    continue;
                }

                // "ok": true 확인
                if (!response.path("ok").asBoolean()) {
                    log.error("getUpdates 실패: {}", response);
                    Thread.sleep(5000);
                    continue;
                }

                // "result" 배열 처리
                JsonNode result = response.path("result");
                if (!result.isArray() || result.size() == 0) {
                    continue;
                }

                for (JsonNode update : result) {
                    processUpdate(update);

                    // update_id 갱신
                    long updateId = update.path("update_id").asLong();
                    if (updateId >= lastUpdateId) {
                        lastUpdateId = updateId + 1;
                    }
                }

            } catch (InterruptedException e) {
                log.info("텔레그램 폴러 중단됨");
                running = false;
                Thread.currentThread().interrupt();
            } catch (Exception e) {
                log.error("텔레그램 폴링 중 오류", e);
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException ie) {
                    running = false;
                    Thread.currentThread().interrupt();
                }
            }
        }

        log.info("텔레그램 폴러 종료");
    }

    /**
     * 업데이트 처리
     */
    private void processUpdate(JsonNode update) {
        try {
            JsonNode message = update.path("message");
            if (message.isMissingNode()) {
                return;
            }

            // /start 명령어 확인
            String text = message.path("text").asText("");
            if (!text.startsWith("/start")) {
                return;
            }

            // 토큰 추출
            String[] parts = text.split("\\s+");
            if (parts.length < 2) {
                log.debug("/start 명령어에 토큰 없음: {}", text);
                return;
            }

            String token = parts[1];
            Long tgUserId = message.path("from").path("id").asLong();
            String chatId = message.path("chat").path("id").asText();

            log.info("/start 명령어 수신: token={}, tgUserId={}, chatId={}", token, tgUserId, chatId);

            // 온보딩 처리
            handleOnboarding(token, tgUserId, chatId);

        } catch (Exception e) {
            log.error("업데이트 처리 중 오류", e);
        }
    }

    /**
     * 온보딩 처리
     * PENDING 상태의 토큰을 찾아서 ACTIVE로 전환하고 환영 메시지 발송
     */
    private void handleOnboarding(String token, Long tgUserId, String chatId) {
        try {
            // 토큰으로 레코드 조회
            TgLink link = tgLinkDAO.findByToken(token);
            if (link == null) {
                log.warn("유효하지 않은 토큰: token={}", token);
                return;
            }

            if (!link.isPending()) {
                log.warn("이미 처리된 토큰: token={}, state={}", token, link.getState());
                return;
            }

            // PENDING -> ACTIVE 전환
            int updated = tgLinkDAO.activateByToken(token, tgUserId, chatId);
            if (updated > 0) {
                log.info("텔레그램 온보딩 완료: userId={}, tgUserId={}, chatId={}",
                        link.getUserId(), tgUserId, chatId);

                // 환영 메시지 발송
                String welcomeMessage = "🎉 환영합니다!\n\n" +
                        "MEETLOG 텔레그램 알림이 연결되었습니다.\n" +
                        "이제 예약 및 결제 관련 알림을 받으실 수 있습니다.";

                telegramService.sendMessageToUser(
                        link.getUserId(),
                        welcomeMessage,
                        "WELCOME",
                        null,
                        null
                );
            } else {
                log.warn("온보딩 활성화 실패: token={}", token);
            }

        } catch (Exception e) {
            log.error("온보딩 처리 중 오류: token={}", token, e);
        }
    }

    /**
     * 폴러 중지
     */
    public void stop() {
        log.info("텔레그램 폴러 중지 요청");
        running = false;
    }

    /**
     * 폴러 실행 여부 확인
     */
    public boolean isRunning() {
        return running;
    }
}
