package dao;

import model.TelegramMessageLog;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

/**
 * 텔레그램 메시지 로그 데이터 액세스 객체
 */
public class TelegramMessageLogDAO {

    /**
     * 메시지 발송 로그 삽입
     */
    public void insert(TelegramMessageLog log) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("mapper.TelegramMessageLogMapper.insert", log);
            session.commit();
        }
    }

    /**
     * 발송 성공 로그 기록 (간편 메서드)
     */
    public void logSuccess(Long tgLinkId, String chatId, String messageType, String messageText,
                           String referenceType, Long referenceId) {
        TelegramMessageLog log = new TelegramMessageLog();
        log.setTgLinkId(tgLinkId);
        log.setChatId(chatId);
        log.setMessageType(messageType);
        log.setMessageText(messageText);
        log.setReferenceType(referenceType);
        log.setReferenceId(referenceId);
        log.setStatus(TelegramMessageLog.STATUS_SENT);
        insert(log);
    }

    /**
     * 발송 실패 로그 기록 (간편 메서드)
     */
    public void logFailure(Long tgLinkId, String chatId, String messageType, String messageText,
                           String errorMessage, String status) {
        TelegramMessageLog log = new TelegramMessageLog();
        log.setTgLinkId(tgLinkId);
        log.setChatId(chatId);
        log.setMessageType(messageType);
        log.setMessageText(messageText);
        log.setErrorMessage(errorMessage);
        log.setStatus(status);
        insert(log);
    }
}
