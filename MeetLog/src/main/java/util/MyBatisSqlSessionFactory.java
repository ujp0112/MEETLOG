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
            InputStream inputStream = Resources.getResourceAsStream(resource);
            if (inputStream == null) {
                throw new IOException("MyBatis 설정 파일 '" + resource + "'을 찾을 수 없습니다.");
            }
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
            
        } catch (Exception e) {
            // 서버 시작 시 초기화가 실패하면 로그를 남기고 즉시 시스템을 중단시키는 것이 안전합니다.
            System.err.println("### MyBatis SqlSessionFactory 초기화 중 치명적인 오류 발생 ###");
            e.printStackTrace();
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