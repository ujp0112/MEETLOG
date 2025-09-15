package util;

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
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
            
        } catch (Exception e) {
            System.err.println("### MyBatis SqlSessionFactory 초기화 실패 ###");
            e.printStackTrace(); // <-- 실제 원인(ClassCastException 등)이 여기에 출력됩니다.
            throw new RuntimeException("MyBatis SqlSessionFactory 초기화에 실패했습니다.", e); 
        }
    }

    public static SqlSession getSqlSession() {
        return sqlSessionFactory.openSession(true); // autoCommit=true
    }
}