import React, { useEffect, useState } from 'react';
import { dashboardAPI } from '../../api/dashboard';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js';
import { Line, Bar, Doughnut } from 'react-chartjs-2';

// Chart.js 등록
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
);

const AdminDashboard = () => {
  const [dashboard, setDashboard] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchDashboard();
  }, []);

  const fetchDashboard = async () => {
    try {
      const data = await dashboardAPI.getAdminDashboard();
      setDashboard(data);
    } catch (err) {
      console.error('Failed to fetch dashboard:', err);
      setError('대시보드 데이터를 불러올 수 없습니다.');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        <div className="text-gray-600">로딩 중...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex justify-center items-center h-screen">
        <div className="text-red-600">{error}</div>
      </div>
    );
  }

  if (!dashboard) {
    return (
      <div className="flex justify-center items-center h-screen">
        <div className="text-gray-600">데이터를 불러올 수 없습니다.</div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6 bg-gray-50 min-h-screen">
      <h1 className="text-3xl font-bold text-gray-900">관리자 대시보드</h1>

      {/* 핵심 통계 카드 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="전체 사용자"
          value={dashboard.totalUsers?.toLocaleString() || '0'}
          change={dashboard.userGrowthRate}
          icon="👥"
          color="blue"
        />
        <StatCard
          title="전체 레스토랑"
          value={dashboard.totalRestaurants?.toLocaleString() || '0'}
          change={dashboard.restaurantGrowthRate}
          icon="🍽️"
          color="green"
        />
        <StatCard
          title="전체 예약"
          value={dashboard.totalReservations?.toLocaleString() || '0'}
          change={dashboard.reservationGrowthRate}
          icon="📅"
          color="purple"
        />
        <StatCard
          title="총 매출"
          value={`${((dashboard.totalRevenue || 0) / 10000).toFixed(0)}만원`}
          change={dashboard.revenueGrowthRate}
          icon="💰"
          color="yellow"
        />
      </div>

      {/* 오늘 통계 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4 text-gray-900">오늘 통계</h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div>
            <p className="text-gray-600 text-sm">신규 가입</p>
            <p className="text-2xl font-bold text-blue-600">{dashboard.todayNewUsers || 0}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">오늘 예약</p>
            <p className="text-2xl font-bold text-green-600">{dashboard.todayReservations || 0}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">오늘 리뷰</p>
            <p className="text-2xl font-bold text-purple-600">{dashboard.todayReviews || 0}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">오늘 매출</p>
            <p className="text-2xl font-bold text-yellow-600">
              {((dashboard.todayRevenue || 0) / 10000).toFixed(1)}만원
            </p>
          </div>
        </div>
      </div>

      {/* 사용자 유형 & 예약 상태 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">사용자 유형</h2>
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-gray-700">일반 사용자</span>
              <span className="text-lg font-bold">{dashboard.normalUsers?.toLocaleString() || 0}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-700">비즈니스 사용자</span>
              <span className="text-lg font-bold">{dashboard.businessUsers?.toLocaleString() || 0}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-700">관리자</span>
              <span className="text-lg font-bold">{dashboard.adminUsers?.toLocaleString() || 0}</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">예약 현황</h2>
          <div className="grid grid-cols-2 gap-4">
            <StatusCard title="대기 중" value={dashboard.pendingReservations || 0} color="yellow" />
            <StatusCard title="확정" value={dashboard.confirmedReservations || 0} color="green" />
            <StatusCard title="완료" value={dashboard.completedReservations || 0} color="blue" />
            <StatusCard title="취소" value={dashboard.cancelledReservations || 0} color="red" />
          </div>
        </div>
      </div>

      {/* 차트: 사용자 증가 추이 & 예약 추이 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {dashboard.userTrend && dashboard.userTrend.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-900">사용자 증가 추이 (최근 30일)</h2>
            <Line
              data={{
                labels: dashboard.userTrend.map(d => d.label),
                datasets: [{
                  label: '신규 사용자',
                  data: dashboard.userTrend.map(d => d.value),
                  borderColor: 'rgb(59, 130, 246)',
                  backgroundColor: 'rgba(59, 130, 246, 0.1)',
                  fill: true,
                  tension: 0.4
                }]
              }}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: {
                    display: true,
                    position: 'top'
                  }
                },
                scales: {
                  y: {
                    beginAtZero: true
                  }
                }
              }}
              height={250}
            />
          </div>
        )}

        {dashboard.reservationTrend && dashboard.reservationTrend.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-900">예약 추이 (최근 30일)</h2>
            <Line
              data={{
                labels: dashboard.reservationTrend.map(d => d.label),
                datasets: [{
                  label: '예약 수',
                  data: dashboard.reservationTrend.map(d => d.value),
                  borderColor: 'rgb(34, 197, 94)',
                  backgroundColor: 'rgba(34, 197, 94, 0.1)',
                  fill: true,
                  tension: 0.4
                }]
              }}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: {
                    display: true,
                    position: 'top'
                  }
                },
                scales: {
                  y: {
                    beginAtZero: true
                  }
                }
              }}
              height={250}
            />
          </div>
        )}
      </div>

      {/* 매출 추이 차트 */}
      {dashboard.revenueTrend && dashboard.revenueTrend.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">매출 추이 (최근 30일)</h2>
          <Bar
            data={{
              labels: dashboard.revenueTrend.map(d => d.label),
              datasets: [{
                label: '매출 (원)',
                data: dashboard.revenueTrend.map(d => d.amount),
                backgroundColor: 'rgba(234, 179, 8, 0.8)',
                borderColor: 'rgb(234, 179, 8)',
                borderWidth: 1
              }]
            }}
            options={{
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  display: true,
                  position: 'top'
                },
                tooltip: {
                  callbacks: {
                    label: function(context) {
                      return '매출: ' + context.parsed.y.toLocaleString() + '원';
                    }
                  }
                }
              },
              scales: {
                y: {
                  beginAtZero: true,
                  ticks: {
                    callback: function(value) {
                      return (value / 10000).toFixed(0) + '만원';
                    }
                  }
                }
              }
            }}
            height={250}
          />
        </div>
      )}

      {/* 카테고리별 레스토랑 & 평점 분포 (도넛 차트) */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {dashboard.restaurantsByCategory && dashboard.restaurantsByCategory.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-900">카테고리별 레스토랑</h2>
            <div className="max-w-md mx-auto">
              <Doughnut
                data={{
                  labels: dashboard.restaurantsByCategory.map(c => c.category),
                  datasets: [{
                    data: dashboard.restaurantsByCategory.map(c => c.count),
                    backgroundColor: [
                      'rgba(255, 99, 132, 0.8)',
                      'rgba(54, 162, 235, 0.8)',
                      'rgba(255, 206, 86, 0.8)',
                      'rgba(75, 192, 192, 0.8)',
                      'rgba(153, 102, 255, 0.8)',
                      'rgba(255, 159, 64, 0.8)'
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                  }]
                }}
                options={{
                  responsive: true,
                  maintainAspectRatio: true,
                  plugins: {
                    legend: {
                      position: 'bottom'
                    },
                    tooltip: {
                      callbacks: {
                        label: function(context) {
                          const label = context.label || '';
                          const value = context.parsed;
                          const total = context.dataset.data.reduce((a, b) => a + b, 0);
                          const percentage = ((value / total) * 100).toFixed(1);
                          return `${label}: ${value} (${percentage}%)`;
                        }
                      }
                    }
                  }
                }}
              />
            </div>
          </div>
        )}

        {dashboard.reviewRatingDistribution && dashboard.reviewRatingDistribution.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-900">리뷰 평점 분포</h2>
            <div className="max-w-md mx-auto">
              <Doughnut
                data={{
                  labels: dashboard.reviewRatingDistribution.map(r => `⭐ ${r.rating}점`),
                  datasets: [{
                    data: dashboard.reviewRatingDistribution.map(r => r.count),
                    backgroundColor: [
                      'rgba(239, 68, 68, 0.8)',   // 1점 - 빨강
                      'rgba(249, 115, 22, 0.8)',  // 2점 - 주황
                      'rgba(234, 179, 8, 0.8)',   // 3점 - 노랑
                      'rgba(132, 204, 22, 0.8)',  // 4점 - 연두
                      'rgba(34, 197, 94, 0.8)'    // 5점 - 초록
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                  }]
                }}
                options={{
                  responsive: true,
                  maintainAspectRatio: true,
                  plugins: {
                    legend: {
                      position: 'bottom'
                    },
                    tooltip: {
                      callbacks: {
                        label: function(context) {
                          const label = context.label || '';
                          const value = context.parsed;
                          const total = context.dataset.data.reduce((a, b) => a + b, 0);
                          const percentage = ((value / total) * 100).toFixed(1);
                          return `${label}: ${value} (${percentage}%)`;
                        }
                      }
                    }
                  }
                }}
              />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

const StatCard = ({ title, value, change, icon, color }) => {
  const colorClasses = {
    blue: 'bg-blue-50 border-blue-200',
    green: 'bg-green-50 border-green-200',
    purple: 'bg-purple-50 border-purple-200',
    yellow: 'bg-yellow-50 border-yellow-200'
  };

  return (
    <div className={`${colorClasses[color]} border rounded-lg p-6`}>
      <div className="flex items-center justify-between mb-2">
        <p className="text-gray-700 text-sm font-medium">{title}</p>
        <span className="text-2xl">{icon}</span>
      </div>
      <p className="text-3xl font-bold text-gray-900">{value}</p>
      {change !== undefined && change !== null && (
        <p className={`text-sm mt-2 font-medium ${change >= 0 ? 'text-green-600' : 'text-red-600'}`}>
          {change >= 0 ? '↑' : '↓'} {Math.abs(change).toFixed(1)}% 전월 대비
        </p>
      )}
    </div>
  );
};

const StatusCard = ({ title, value, color }) => {
  const colorClasses = {
    yellow: 'bg-yellow-100 text-yellow-800 border-yellow-300',
    green: 'bg-green-100 text-green-800 border-green-300',
    blue: 'bg-blue-100 text-blue-800 border-blue-300',
    red: 'bg-red-100 text-red-800 border-red-300'
  };

  return (
    <div className={`${colorClasses[color]} border rounded-lg p-4 text-center`}>
      <p className="text-sm font-medium">{title}</p>
      <p className="text-2xl font-bold mt-2">{value?.toLocaleString() || 0}</p>
    </div>
  );
};

export default AdminDashboard;
