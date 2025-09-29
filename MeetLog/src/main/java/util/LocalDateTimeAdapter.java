package util;

import com.google.gson.*;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    public JsonElement serialize(LocalDateTime src, Type typeOfSrc, JsonSerializationContext context) {
        // [수정] LocalDateTime 객체가 null인 경우, JSON null로 변환합니다.
        if (src == null) {
            return JsonNull.INSTANCE;
        }
        return new JsonPrimitive(FORMATTER.format(src));
    }

    @Override
    public LocalDateTime deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {
        // [수정] JSON 데이터가 null인 경우, null 객체를 반환합니다.
        if (json == null || json.isJsonNull()) {
            return null;
        }
        return LocalDateTime.parse(json.getAsString(), FORMATTER);
    }
}