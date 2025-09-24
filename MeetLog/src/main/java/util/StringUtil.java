package util;

public class StringUtil {

    /**
     * HTML 태그를 제거하고, 지정된 길이로 문자열을 자른 뒤 "..."을 붙여줍니다.
     * @param html      원본 HTML 문자열
     * @param maxLength 최대 길이
     * @return 요약된 순수 텍스트
     */
    public static String stripHtmlAndTruncate(String html, int maxLength) {
        if (html == null || html.isEmpty()) {
            return "";
        }

        // 1. 정규표현식으로 모든 HTML 태그를 제거합니다.
        String textOnly = html.replaceAll("<[^>]*>", "");
        
        // 2. HTML 공백 문자(&nbsp;)를 일반 공백으로 바꿉니다.
        textOnly = textOnly.replaceAll("&nbsp;", " ");

        // 3. 길이가 maxLength보다 길면 자르고 "..."을 붙입니다.
        if (textOnly.length() > maxLength) {
            return textOnly.substring(0, maxLength) + "...";
        }

        return textOnly;
    }
}