package util;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;

import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfo;

public class GoogleLoginBO {

    // api.properties 파일에서 클라이언트 ID와 시크릿을 읽어옵니다.
    private static final String CLIENT_ID = AppConfigListener.getApiKey("google.clientId");
    private static final String CLIENT_SECRET = AppConfigListener.getApiKey("google.clientSecret");
    private static final String REDIRECT_URI = AppConfigListener.getApiKey("google.callbackUrl");

    // 사용자 정보 범위를 지정합니다. (프로필, 이메일)
    private static final Collection<String> SCOPES = Arrays.asList("profile", "email");
    private static final NetHttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static final GsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();

    private static AuthorizationCodeFlow flow;

    /**
     * GoogleAuthorizationCodeFlow 객체를 초기화하고 반환합니다.
     */
    private static AuthorizationCodeFlow getFlow() {
        if (flow == null) {
            flow = new GoogleAuthorizationCodeFlow.Builder(
                    HTTP_TRANSPORT, JSON_FACTORY, CLIENT_ID, CLIENT_SECRET, SCOPES)
                    .setAccessType("offline")
                    .build();
        }
        return flow;
    }

    /**
     * 구글 인증 페이지로 이동하기 위한 URL을 생성합니다.
     * @return 생성된 인증 URL
     */
    public static String getAuthorizationUrl() {
        AuthorizationCodeRequestUrl urlBuilder = getFlow().newAuthorizationUrl()
                .setRedirectUri(REDIRECT_URI);
        return urlBuilder.build();
    }

    /**
     * 콜백에서 받은 인증 코드를 사용하여 AccessToken을 발급받습니다.
     * @param code 콜백으로 전달된 인증 코드
     * @return 발급받은 Credential 객체 (AccessToken 포함)
     * @throws IOException
     */
    public static Credential getAccessToken(String code) throws IOException {
        TokenResponse tokenResponse = getFlow().newTokenRequest(code)
                .setRedirectUri(REDIRECT_URI)
                .execute();
        
        return getFlow().createAndStoreCredential(tokenResponse, null);
    }

    /**
     * AccessToken(Credential)을 사용하여 사용자 프로필 정보를 가져옵니다.
     * @param credential 발급받은 Credential 객체
     * @return 사용자 정보가 담긴 Userinfo 객체
     * @throws IOException
     */
    public static Userinfo getUserProfile(Credential credential) throws IOException {
        Oauth2 oauth2 = new Oauth2.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName("MeetLog")
                .build();
        
        return oauth2.userinfo().get().execute();
    }
}