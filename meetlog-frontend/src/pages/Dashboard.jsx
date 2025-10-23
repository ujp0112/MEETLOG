import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { getHealthCheck } from '../api/health';

const Dashboard = () => {
  const navigate = useNavigate();
  const { user, logout } = useAuth();
  const [health, setHealth] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const checkHealth = async () => {
      try {
        const data = await getHealthCheck();
        setHealth(data);
        setError(null);
      } catch (err) {
        setError('Spring Boot 서버에 연결할 수 없습니다.');
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    checkHealth();
  }, []);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8 flex justify-between items-center">
          <h1 className="text-3xl font-bold text-gray-900">
            MeetLog - Spring Boot + React
          </h1>
          <div className="flex items-center space-x-4">
            <div className="text-sm text-gray-700">
              <span className="font-medium">{user?.name}</span>
              <span className="text-gray-500 ml-2">({user?.email})</span>
            </div>
            <button
              onClick={handleLogout}
              className="px-4 py-2 text-sm font-medium text-white bg-red-600 hover:bg-red-700 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
              로그아웃
            </button>
          </div>
        </div>
      </header>

      <main>
        <div className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
          <div className="px-4 py-6 sm:px-0">
            <div className="border-4 border-dashed border-gray-200 rounded-lg p-8">
              <h2 className="text-2xl font-semibold mb-4">
                Phase 2 완료: JWT 인증 시스템
              </h2>

              {/* 사용자 정보 */}
              <div className="bg-white rounded-lg shadow p-6 mb-6">
                <h3 className="text-xl font-semibold mb-3">사용자 정보</h3>
                <div className="space-y-2">
                  <p><strong>이름:</strong> {user?.name}</p>
                  <p><strong>이메일:</strong> {user?.email}</p>
                  <p><strong>닉네임:</strong> {user?.nickname}</p>
                  <p><strong>회원 유형:</strong> {user?.userType === 'NORMAL' ? '일반 사용자' : user?.userType === 'BUSINESS' ? '사업자' : '관리자'}</p>
                </div>
              </div>

              {/* Health Check 상태 */}
              <div className="bg-white rounded-lg shadow p-6 mb-6">
                <h3 className="text-xl font-semibold mb-3">백엔드 서버 상태</h3>
                {loading && (
                  <p className="text-gray-600">서버 상태 확인 중...</p>
                )}
                {error && (
                  <div className="bg-red-50 border border-red-200 rounded p-4">
                    <p className="text-red-600">{error}</p>
                    <p className="text-sm text-red-500 mt-2">
                      Spring Boot 서버가 실행 중인지 확인하세요: http://localhost:8080/api/health
                    </p>
                  </div>
                )}
                {health && (
                  <div className="bg-green-50 border border-green-200 rounded p-4">
                    <p className="text-green-600 font-semibold">
                      ✓ 서버 정상 동작
                    </p>
                    <div className="mt-3 text-sm">
                      <p><strong>Status:</strong> {health.status}</p>
                      <p><strong>Service:</strong> {health.service}</p>
                      <p><strong>Version:</strong> {health.version}</p>
                      <p><strong>Timestamp:</strong> {health.timestamp}</p>
                    </div>
                  </div>
                )}
              </div>

              {/* 완료된 작업 목록 */}
              <div className="bg-white rounded-lg shadow p-6">
                <h3 className="text-xl font-semibold mb-3">완료된 작업</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <h4 className="font-semibold mb-2">Phase 1: 프로젝트 기반</h4>
                    <ul className="space-y-1 text-sm">
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        Spring Boot 프로젝트 생성
                      </li>
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        MyBatis + MariaDB 연동
                      </li>
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        Spring Security 기본 설정
                      </li>
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        React 프로젝트 + Tailwind CSS
                      </li>
                    </ul>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">Phase 2: JWT 인증</h4>
                    <ul className="space-y-1 text-sm">
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        JWT 토큰 생성/검증
                      </li>
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        로그인/회원가입 API
                      </li>
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        AuthContext + 상태 관리
                      </li>
                      <li className="flex items-center">
                        <span className="text-green-500 mr-2">✓</span>
                        로그인/회원가입 페이지
                      </li>
                    </ul>
                  </div>
                </div>
              </div>

              {/* Phase 3 완료 */}
              <div className="bg-white rounded-lg shadow p-6 mt-6">
                <h3 className="text-xl font-semibold mb-3">Phase 3: 레스토랑 도메인</h3>
                <ul className="space-y-1 text-sm">
                  <li className="flex items-center">
                    <span className="text-green-500 mr-2">✓</span>
                    레스토랑 CRUD API
                  </li>
                  <li className="flex items-center">
                    <span className="text-green-500 mr-2">✓</span>
                    레스토랑 목록/상세 페이지
                  </li>
                  <li className="flex items-center">
                    <span className="text-green-500 mr-2">✓</span>
                    검색 및 필터링 기능
                  </li>
                  <li className="flex items-center">
                    <span className="text-green-500 mr-2">✓</span>
                    이미지 업로드
                  </li>
                </ul>
                <div className="mt-4">
                  <button
                    onClick={() => navigate('/restaurants')}
                    className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                  >
                    레스토랑 검색하기
                  </button>
                </div>
              </div>

              {/* 다음 단계 */}
              <div className="bg-blue-50 rounded-lg p-6 mt-6">
                <h3 className="text-xl font-semibold mb-3 text-blue-900">
                  다음 단계: Phase 4
                </h3>
                <p className="text-blue-800">
                  리뷰 시스템 구축
                </p>
                <ul className="mt-3 space-y-1 text-sm text-blue-700">
                  <li>• 리뷰 CRUD API</li>
                  <li>• 별점 및 평가</li>
                  <li>• 리뷰 이미지 업로드</li>
                  <li>• 리뷰 신고 기능</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Dashboard;
