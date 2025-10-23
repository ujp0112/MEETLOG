import axios from 'axios';

/**
 * Axios 인스턴스 생성
 * - Base URL: 환경 변수에서 가져옴
 * - Timeout: 10초
 * - Default Headers: JSON
 */
const apiClient = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:8080/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

/**
 * 요청 인터셉터
 * - 요청 전에 토큰을 헤더에 추가
 */
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

/**
 * 응답 인터셉터
 * - 에러 응답 처리
 * - 401 에러 시 로그아웃 처리
 */
apiClient.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response) {
      // 401 Unauthorized - 토큰 만료 또는 인증 실패
      if (error.response.status === 401) {
        localStorage.removeItem('authToken');
        window.location.href = '/login';
      }

      // 403 Forbidden - 권한 없음
      if (error.response.status === 403) {
        console.error('접근 권한이 없습니다.');
      }

      // 500 Server Error
      if (error.response.status >= 500) {
        console.error('서버 오류가 발생했습니다.');
      }
    } else if (error.request) {
      // 요청은 보냈으나 응답을 받지 못함
      console.error('서버로부터 응답이 없습니다.');
    } else {
      // 요청 설정 중 에러 발생
      console.error('요청 중 오류가 발생했습니다:', error.message);
    }

    return Promise.reject(error);
  }
);

export default apiClient;
