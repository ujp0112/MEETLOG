package util;

import java.io.IOException;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;
import com.github.scribejava.apis.KakaoApi;

public class KakaoLoginBO {

    // AppConfigListener를 사용하여 프로퍼티 파일에서 값을 읽어옵니다.
    private final static String CLIENT_ID = AppConfigListener.getApiKey("kakao.clientId");
    private final static String REDIRECT_URI = AppConfigListener.getApiKey("kakao.callbackUrl");

    private final static String PROFILE_API_URL = "https://kapi.kakao.com/v2/user/me";
    
    /**
     * ScribeJava의 OAuth20Service 객체를 생성합니다.
     */
    private static OAuth20Service getOauthService() {
        return new ServiceBuilder(CLIENT_ID)
                .callback(REDIRECT_URI)
                .build(KakaoApi.instance());
    }
    
    /**
     * 카카오 인증 URL 생성을 위한 메소드입니다.
     * @return 생성된 카카오 인증 URL
     */
    public static String getAuthorizationUrl() {
        return getOauthService().getAuthorizationUrl();
    }
    
    /**
     * 카카오 콜백 처리 후 AccessToken을 얻어오는 메소드입니다.
     * @param code 인증 코드
     * @return 발급받은 AccessToken 객체
     */
    public static OAuth2AccessToken getAccessToken(String code) throws IOException {
        try {
            return getOauthService().getAccessToken(code);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * AccessToken을 이용하여 카카오 사용자 프로필 API를 호출하는 메소드입니다.
     * @param oauthToken 발급받은 AccessToken
     * @return 사용자 프로필 정보 (JSON 문자열)
     */
    public static String getUserProfile(OAuth2AccessToken oauthToken) throws IOException {
        OAuth20Service oauthService = getOauthService();
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