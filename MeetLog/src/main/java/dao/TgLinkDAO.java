package dao;

import model.TgLink;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * 텔레그램 연결 정보 데이터 액세스 객체
 */
public class TgLinkDAO {

    /**
     * 사용자 ID로 텔레그램 연결 정보 조회
     */
    public TgLink findByUserId(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("mapper.TgLinkMapper.findByUserId", userId);
        }
    }

    /**
     * 토큰으로 텔레그램 연결 정보 조회
     */
    public TgLink findByToken(String token) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("mapper.TgLinkMapper.findByToken", token);
        }
    }

    /**
     * chat_id로 텔레그램 연결 정보 조회
     */
    public TgLink findByChatId(String chatId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("mapper.TgLinkMapper.findByChatId", chatId);
        }
    }

    /**
     * 토큰 발급 (PENDING 상태로 upsert)
     * 기존 레코드가 있으면 토큰만 갱신, 없으면 새로 생성
     */
    public void upsertPending(int userId, String token) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("token", token);

            session.insert("mapper.TgLinkMapper.upsertPending", params);
            session.commit();
        }
    }

    /**
     * 온보딩 완료 (PENDING -> ACTIVE, chat_id와 tg_user_id 저장)
     */
    public int activateByToken(String token, Long tgUserId, String chatId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("token", token);
            params.put("tgUserId", tgUserId);
            params.put("chatId", chatId);

            int result = session.update("mapper.TgLinkMapper.activateByToken", params);
            session.commit();
            return result;
        }
    }

    /**
     * 상태 변경 (예: ACTIVE -> BLOCKED)
     */
    public int updateState(int userId, String newState) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("state", newState);

            int result = session.update("mapper.TgLinkMapper.updateState", params);
            session.commit();
            return result;
        }
    }

    /**
     * chat_id로 상태 변경 (발송 실패 시 BLOCKED 처리용)
     */
    public int updateStateByChatId(String chatId, String newState) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("chatId", chatId);
            params.put("state", newState);

            int result = session.update("mapper.TgLinkMapper.updateStateByChatId", params);
            session.commit();
            return result;
        }
    }

    /**
     * 연결 삭제 (사용자가 연결 해제 시)
     */
    public int deleteByUserId(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("mapper.TgLinkMapper.deleteByUserId", userId);
            session.commit();
            return result;
        }
    }
}
