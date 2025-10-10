package listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import service.TelegramPollerService;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * 텔레그램 폴러 라이프사이클 관리 리스너
 * 웹 애플리케이션 시작 시 폴러 스레드 시작, 종료 시 정리
 */
@WebListener
public class TelegramPollerListener implements ServletContextListener {
    private static final Logger log = LoggerFactory.getLogger(TelegramPollerListener.class);

    private Thread pollerThread;
    private TelegramPollerService pollerService;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        log.info("텔레그램 폴러 초기화 시작");

        try {
            pollerService = new TelegramPollerService();
            pollerThread = new Thread(pollerService, "TelegramPoller");
            pollerThread.setDaemon(true); // 데몬 스레드로 설정 (JVM 종료 시 자동 종료)
            pollerThread.start();

            log.info("텔레그램 폴러 스레드 시작 완료");
        } catch (Exception e) {
            log.error("텔레그램 폴러 시작 실패", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info("텔레그램 폴러 종료 시작");

        if (pollerService != null) {
            pollerService.stop();
        }

        if (pollerThread != null && pollerThread.isAlive()) {
            try {
                pollerThread.join(5000); // 최대 5초 대기
                if (pollerThread.isAlive()) {
                    log.warn("텔레그램 폴러 스레드가 5초 내에 종료되지 않음");
                    pollerThread.interrupt();
                } else {
                    log.info("텔레그램 폴러 스레드 종료 완료");
                }
            } catch (InterruptedException e) {
                log.error("텔레그램 폴러 종료 대기 중 인터럽트", e);
                Thread.currentThread().interrupt();
            }
        }
    }
}
