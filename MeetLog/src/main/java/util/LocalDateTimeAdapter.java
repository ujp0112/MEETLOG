package util;

import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Gson이 java.time.LocalDateTime을 올바르게 직렬화/역직렬화하도록 돕는 어댑터
 */
public class LocalDateTimeAdapter extends TypeAdapter<LocalDateTime> {

    // ISO 표준 formatter (e.g., "2025-09-25T18:10:30")
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    public void write(final JsonWriter jsonWriter, final LocalDateTime localDateTime) throws IOException {
        if (localDateTime == null) {
            jsonWriter.nullValue();
        } else {
            jsonWriter.value(formatter.format(localDateTime));
        }
    }

    @Override
    public LocalDateTime read(final JsonReader jsonReader) throws IOException {
        if (jsonReader.peek() == com.google.gson.stream.JsonToken.NULL) {
            jsonReader.nextNull();
            return null;
        } else {
            return LocalDateTime.parse(jsonReader.nextString(), formatter);
        }
    }
}