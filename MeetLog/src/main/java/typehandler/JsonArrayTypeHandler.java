package typehandler;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedTypes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * [오류 해결 핵심]
 * MyBatis의 TypeHandler로 등록되기 위해 반드시 BaseTypeHandler<T>를 상속(extends)해야 합니다.
 * 이 클래스는 DB의 VARCHAR(JSON 문자열)와 Java의 List<String> 타입을 매핑합니다.
 * 이 extends 구문이 없으면 MyBatis가 형 변환(Cast)에 실패하여 ClassCastException이 발생합니다.
 */
@MappedTypes(List.class) // 이 핸들러가 Java의 List 타입을 처리함을 명시
public class JsonArrayTypeHandler extends BaseTypeHandler<List<String>> {

    // Jackson ObjectMapper (Thread-safe 하므로 static으로 관리)
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    // Jackson이 List<String>이라는 제네릭 타입을 정확히 인식하기 위한 TypeReference
    private static final TypeReference<List<String>> TYPE_REFERENCE = new TypeReference<>() {};

    /**
     * 1. Java 객체(List<String>) -> DB 데이터(JSON VARCHAR)로 변환 (INSERT, UPDATE 시)
     */
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, List<String> parameter, JdbcType jdbcType) throws SQLException {
        try {
            // List 객체를 JSON 문자열로 변환합니다.
            String jsonString = objectMapper.writeValueAsString(parameter);
            ps.setString(i, jsonString);
        } catch (JsonProcessingException e) {
            // JSON 변환 실패 시 SQLException을 발생시켜 롤백되도록 함
            throw new SQLException("List를 JSON 문자열로 변환 중 오류 발생", e);
        }
    }

    /**
     * 2. DB 데이터(JSON VARCHAR) -> Java 객체(List<String>)로 변환 (SELECT 결과 - 컬럼 이름 기준)
     */
    @Override
    public List<String> getNullableResult(ResultSet rs, String columnName) throws SQLException {
        String jsonString = rs.getString(columnName);
        return convertJsonToList(jsonString);
    }

    /**
     * 3. DB 데이터(JSON VARCHAR) -> Java 객체(List<String>)로 변환 (SELECT 결과 - 컬럼 인덱스 기준)
     */
    @Override
    public List<String> getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String jsonString = rs.getString(columnIndex);
        return convertJsonToList(jsonString);
    }

    /**
     * 4. DB 데이터(JSON VARCHAR) -> Java 객체(List<String>)로 변환 (프로시저 호출 결과)
     */
    @Override
    public List<String> getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String jsonString = cs.getString(columnIndex);
        return convertJsonToList(jsonString);
    }

    /**
     * 공통 변환 로직: JSON 문자열을 List<String> 객체로 변환
     */
    private List<String> convertJsonToList(String jsonString) throws SQLException {
        // DB 값이 NULL이거나 빈 문자열이면 Java에서도 null 반환
        if (jsonString == null || jsonString.isEmpty()) {
            return null;
        }
        
        try {
            // JSON 문자열을 List<String> 객체로 변환합니다.
            return objectMapper.readValue(jsonString, TYPE_REFERENCE);
        } catch (IOException e) {
            // JSON 파싱 실패 시 예외 발생
            throw new SQLException("JSON 문자열을 List<String>으로 변환 중 오류 발생", e);
        }
    }
}