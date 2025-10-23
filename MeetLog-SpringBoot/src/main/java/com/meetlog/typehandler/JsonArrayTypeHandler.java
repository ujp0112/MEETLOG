package com.meetlog.typehandler;

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
 * MyBatis TypeHandler for JSON array fields
 * DB의 VARCHAR(JSON 문자열)와 Java의 List<String> 타입을 매핑합니다.
 */
@MappedTypes(List.class)
public class JsonArrayTypeHandler extends BaseTypeHandler<List<String>> {

    private static final ObjectMapper objectMapper = new ObjectMapper();
    private static final TypeReference<List<String>> TYPE_REFERENCE = new TypeReference<>() {};

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, List<String> parameter, JdbcType jdbcType) throws SQLException {
        try {
            String jsonString = objectMapper.writeValueAsString(parameter);
            ps.setString(i, jsonString);
        } catch (JsonProcessingException e) {
            throw new SQLException("List를 JSON 문자열로 변환 중 오류 발생", e);
        }
    }

    @Override
    public List<String> getNullableResult(ResultSet rs, String columnName) throws SQLException {
        String jsonString = rs.getString(columnName);
        return convertJsonToList(jsonString);
    }

    @Override
    public List<String> getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String jsonString = rs.getString(columnIndex);
        return convertJsonToList(jsonString);
    }

    @Override
    public List<String> getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String jsonString = cs.getString(columnIndex);
        return convertJsonToList(jsonString);
    }

    private List<String> convertJsonToList(String jsonString) throws SQLException {
        if (jsonString == null || jsonString.isEmpty()) {
            return null;
        }

        try {
            return objectMapper.readValue(jsonString, TYPE_REFERENCE);
        } catch (IOException e) {
            throw new SQLException("JSON 문자열을 List<String>으로 변환 중 오류 발생", e);
        }
    }
}
