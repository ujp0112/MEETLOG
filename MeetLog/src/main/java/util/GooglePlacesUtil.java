package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import model.Review;
import model.Restaurant;

public class GooglePlacesUtil {

    private static final String API_KEY = AppConfigListener.getApiKey("GOOGLE_API_KEY");

    /**
     * 1단계: 장소 이름과 좌표로 Google Place ID를 검색합니다.
     * @param name 장소 이름
     * @param lat 위도
     * @param lng 경도
     * @return Google Place ID 문자열, 없으면 null
     */
    public static String findPlaceId(String name, double lat, double lng) {
        try {
            String encodedName = URLEncoder.encode(name, StandardCharsets.UTF_8.toString());
            String urlStr = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
                    + "?input=" + encodedName
                    + "&inputtype=textquery"
                    + "&fields=place_id"
                    + "&locationbias=circle:200@" + lat + "," + lng // 검색 정확도를 높이기 위해 좌표 주변으로 bias
                    + "&key=" + API_KEY;

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String inputLine;
                StringBuilder content = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
               }

                JSONObject json = new JSONObject(content.toString());
                if ("OK".equals(json.getString("status"))) {
                    JSONArray candidates = json.getJSONArray("candidates");
                    if (candidates.length() > 0) {
                        return candidates.getJSONObject(0).getString("place_id");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Google Place ID 검색 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 2단계: Place ID를 사용하여 장소의 상세 정보를 가져옵니다.
     * @param placeId Google Place ID
     * @param restaurant 정보를 채울 Restaurant 객체
     * @return 상세 정보가 채워진 Restaurant 객체
     */
    public static Restaurant getPlaceDetails(String placeId, Restaurant restaurant) {
        try {
            String urlStr = "https://maps.googleapis.com/maps/api/place/details/json"
                    + "?place_id=" + placeId
                    + "&fields=name,formatted_phone_number,opening_hours,website,photos,rating,user_ratings_total,reviews"
                    + "&language=ko" // 결과를 한국어로 요청
                    + "&key=" + API_KEY;

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String inputLine;
                StringBuilder content = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
               }

                JSONObject json = new JSONObject(content.toString());
                if ("OK".equals(json.getString("status"))) {
                    JSONObject result = json.getJSONObject("result");

                    // 전화번호, 웹사이트, 평점 등 추가 정보 설정
                    if (result.has("formatted_phone_number")) {
                        restaurant.setPhone(result.getString("formatted_phone_number"));
                    }
                    // [추가] 웹사이트 정보 파싱
                    if (result.has("website")) {
                        restaurant.setWebsite(result.getString("website"));
                    }
                    if (result.has("rating")) {
                        restaurant.setRating(result.getDouble("rating"));
                    }
                    if (result.has("user_ratings_total")) {
                        restaurant.setReviewCount(result.getInt("user_ratings_total"));
                    }

                    // [추가] 사진 정보 파싱 (최대 10개)
                    if (result.has("photos")) {
                        JSONArray photos = result.getJSONArray("photos");
                        List<String> photoUrls = new ArrayList<>();
                        for (int i = 0; i < photos.length() && i < 10; i++) {
                            String photoReference = photos.getJSONObject(i).getString("photo_reference");
                            String photoUrl = "https://maps.googleapis.com/maps/api/place/photo"
                                    + "?maxwidth=800"
                                    + "&photoreference=" + photoReference
                                    + "&key=" + API_KEY;
                            photoUrls.add(photoUrl);
                        }
                        restaurant.setAdditionalImages(photoUrls); // Restaurant 모델의 additionalImages 필드 사용
                    }

                    // [추가] 리뷰 정보 파싱 (최대 5개)
                    if (result.has("reviews")) {
                        JSONArray reviewsJson = result.getJSONArray("reviews");
                        List<Review> reviewList = new ArrayList<>();
                        for (int i = 0; i < reviewsJson.length(); i++) {
                            JSONObject reviewJson = reviewsJson.getJSONObject(i);
                            Review review = new Review();
                            review.setAuthor(reviewJson.getString("author_name"));
                            review.setProfileImage(reviewJson.getString("profile_photo_url"));
                            review.setRating(reviewJson.getInt("rating"));
                            review.setContent(reviewJson.getString("text"));
                            // Google API는 유닉스 타임스탬프(초)를 반환하므로 Date 객체로 변환
                            long timeInSeconds = reviewJson.getLong("time");
                            //review.setCreatedAt(new java.sql.Timestamp(timeInSeconds * 1000L));
                            
                            reviewList.add(review);
                        }
                        restaurant.setReviews(reviewList);
                    }

                    // 운영 시간 정보 파싱
                    if (result.has("opening_hours") && result.getJSONObject("opening_hours").has("weekday_text")) {
                        JSONArray weekdayText = result.getJSONObject("opening_hours").getJSONArray("weekday_text");
                        // [수정] JSON 배열을 문자열로 직접 처리하는 방식으로 변경
                        String rawArrayString = weekdayText.toString();
                        
                        // 1. 대괄호 제거:  ["...","..."] -> "...", "..."
                        String contentString = rawArrayString.substring(1, rawArrayString.length() - 1);
                        
                        // 2. 각 항목을 분리하여 리스트로 만듦
                        String[] hoursArray = contentString.split("\",\"");
                        for (int i = 0; i < hoursArray.length; i++) {
                            // 3. 각 항목의 앞뒤 큰따옴표 제거 및 불필요한 공백 정리
                            hoursArray[i] = hoursArray[i].replace("\"", "").replaceAll("\\s", "");
                        }
                        restaurant.setHours(String.join("\n", hoursArray));
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Google Place 상세 정보 검색 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return restaurant;
    }
}
