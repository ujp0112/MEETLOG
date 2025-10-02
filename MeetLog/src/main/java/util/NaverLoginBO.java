package util;

import java.io.IOException;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;
import com.github.scribejava.apis.NaverApi;

public class NaverLoginBO {

	// AppConfigListener를 사용하여 프로퍼티 파일에서 값을 읽어옵니다.
	private final static String CLIENT_ID = AppConfigListener.getApiKey("naverClientId");
	private final static String CLIENT_SECRET = AppConfigListener.getApiKey("naverClientSecret");
	private final static String REDIRECT_URI = AppConfigListener.getApiKey("naver.callbackUrl");

	private final static String SESSION_STATE = "oauth_state";
	private final static String PROFILE_API_URL = "https://openapi.naver.com/v1/nid/me";

	/**
	 * ScribeJava의 OAuth20Service 객체를 생성합니다.
	 */
	private static OAuth20Service getOauthService(HttpSession session) {
		return new ServiceBuilder(CLIENT_ID).apiSecret(CLIENT_SECRET).callback(REDIRECT_URI).build(NaverApi.instance());
	}

	/**
	 * 네이버 인증 URL 생성을 위한 메소드입니다.
	 * 
	 * @param session 사용자 세션
	 * @return 생성된 네이버 인증 URL
	 */
	public static String getAuthorizationUrl(HttpSession session) {
		String state = UUID.randomUUID().toString();
		session.setAttribute(SESSION_STATE, state); // 세션에 state 값 저장

		// 1. ServiceBuilder에서는 .state()를 호출하지 않고 oauthService 객체를 생성합니다.
		OAuth20Service oauthService = new ServiceBuilder(CLIENT_ID).apiSecret(CLIENT_SECRET).callback(REDIRECT_URI)
				.build(NaverApi.instance());

		// 2. 생성된 oauthService 객체의 getAuthorizationUrl 메소드에 state 값을 직접 전달합니다.
		return oauthService.getAuthorizationUrl(state);
	}

	/**
	 * 네이버 콜백 처리 후 AccessToken을 얻어오는 메소드입니다.
	 * 
	 * @param request 콜백 요청
	 * @param code    인증 코드
	 * @param state   CSRF 방지용 state 값
	 * @return 발급받은 AccessToken 객체
	 */
	public static OAuth2AccessToken getAccessToken(HttpServletRequest request, String code, String state)
			throws IOException {
		HttpSession session = request.getSession();
		String sessionState = (String) session.getAttribute(SESSION_STATE);

		// 세션에 저장된 state와 콜백으로 전달된 state가 일치하는지 검증합니다.
		if (state != null && state.equals(sessionState)) {
			try {
				return getOauthService(session).getAccessToken(code);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null; // state 불일치 시 null 반환
	}

	/**
	 * AccessToken을 이용하여 네이버 사용자 프로필 API를 호출하는 메소드입니다.
	 * 
	 * @param oauthToken 발급받은 AccessToken
	 * @return 사용자 프로필 정보 (JSON 문자열)
	 */
	public static String getUserProfile(OAuth2AccessToken oauthToken) throws IOException {
		OAuth20Service oauthService = new ServiceBuilder(CLIENT_ID).build(NaverApi.instance());
		OAuthRequest request = new OAuthRequest(Verb.GET, PROFILE_API_URL);
		oauthService.signRequest(oauthToken, request);
		try (Response response = oauthService.execute(request)) {
			return response.getBody();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}