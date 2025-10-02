package service;

import com.google.api.services.oauth2.model.Userinfo;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import model.User;

public class SocialLoginService {

	public User getNaverProfile(String apiResult) {
		JsonObject a = (JsonObject) JsonParser.parseString(apiResult);
		JsonObject response = (JsonObject) a.get("response");

		User profile = new User();
		profile.setSocialProvider("NAVER");
		profile.setSocialId(response.get("id").getAsString());
		profile.setEmail(response.get("email").getAsString());
		profile.setNickname(response.get("nickname").getAsString());
		// 이름, 프로필 이미지가 있다면 추가
		if (response.has("name"))
			profile.setName(response.get("name").getAsString());
		if (response.has("profile_image"))
			profile.setProfileImage(response.get("profile_image").getAsString());

		return profile;
	}

	public User getKakaoProfile(String apiResult) {
		JsonObject root = JsonParser.parseString(apiResult).getAsJsonObject();
		long id = root.get("id").getAsLong();
		JsonObject properties = root.getAsJsonObject("properties");
		JsonObject kakaoAccount = root.getAsJsonObject("kakao_account");

		User profile = new User();
		profile.setSocialProvider("KAKAO");
		profile.setSocialId(String.valueOf(id));

		if (kakaoAccount.has("email")) {
			profile.setEmail(kakaoAccount.get("email").getAsString());
		}
		if (properties.has("nickname")) {
			profile.setNickname(properties.get("nickname").getAsString());
		}
		if (properties.has("profile_image")) {
			profile.setProfileImage(properties.get("profile_image").getAsString());
		}

		return profile;
	}

	/**
	 * [신규] 구글 사용자 정보를 User 객체로 변환합니다.
	 * 
	 * @param userInfo 구글 API에서 받아온 Userinfo 객체
	 * @return 정보가 채워진 User 객체
	 */
	public User getGoogleProfile(Userinfo userInfo) {
		if (userInfo == null) {
			return null;
		}

		User profile = new User();
		profile.setSocialProvider("GOOGLE");
		profile.setSocialId(userInfo.getId());
		profile.setEmail(userInfo.getEmail());

		// 구글은 '닉네임' 개념이 따로 없으므로 '이름(name)'을 닉네임으로 사용합니다.
		profile.setNickname(userInfo.getName());
		profile.setProfileImage(userInfo.getPicture());

		return profile;
	}
}