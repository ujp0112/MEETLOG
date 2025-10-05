package util;

import java.io.IOException;
import java.io.InputStream;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MyBatisSqlSessionFactory {
	
    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            String resource = "mybatis-config.xml";
            System.err.println("[DEBUG] MyBatis 설정 파일 로딩 시작: " + resource);

            InputStream inputStream = Resources.getResourceAsStream(resource);
            if (inputStream == null) {
                System.err.println("[ERROR] MyBatis 설정 파일을 찾을 수 없습니다: " + resource);
                throw new IOException("MyBatis 설정 파일 '" + resource + "'을 찾을 수 없습니다.");
            }

            System.err.println("[DEBUG] MyBatis 설정 파일 로딩 성공, SqlSessionFactory 빌드 시작");
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
            System.err.println("[DEBUG] SqlSessionFactory 초기화 성공!");

        } catch (Exception e) {
            // 서버 시작 시 초기화가 실패하면 로그를 남기고 즉시 시스템을 중단시키는 것이 안전합니다.
            System.err.println("### MyBatis SqlSessionFactory 초기화 중 치명적인 오류 발생 ###");
            System.err.println("### 오류 타입: " + e.getClass().getName());
            System.err.println("### 오류 메시지: " + e.getMessage());
            e.printStackTrace();

            // Cause chain 출력
            Throwable cause = e.getCause();
            int depth = 1;
            while (cause != null && depth <= 5) {
                System.err.println("### Cause [" + depth + "]: " + cause.getClass().getName() + " - " + cause.getMessage());
                cause.printStackTrace();
                cause = cause.getCause();
                depth++;
            }

            throw new RuntimeException("MyBatis SqlSessionFactory 초기화에 실패했습니다.", e);
        }
    }

    /**
     * SqlSession을 반환합니다. (기본: 자동 커밋 모드)
     * @return SqlSession 객체
     */
    public static SqlSession getSqlSession() {
        if (sqlSessionFactory == null) {
             throw new RuntimeException("SqlSessionFactory가 초기화되지 않았습니다.");
        }
        return sqlSessionFactory.openSession(true); // autoCommit=true
    }
    
    /**
     * SqlSession을 반환합니다. (커밋 모드 지정 가능)
     * @param autoCommit true이면 자동 커밋, false이면 수동 커밋
     * @return SqlSession 객체
     */
    public static SqlSession getSqlSession(boolean autoCommit) {
        if (sqlSessionFactory == null) {
             throw new RuntimeException("SqlSessionFactory가 초기화되지 않았습니다.");
        }
        return sqlSessionFactory.openSession(autoCommit);
    }
}