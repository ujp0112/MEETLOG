import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
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
import { Line, Doughnut } from 'react-chartjs-2';

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

const BusinessDashboard = () => {
  const { restaurantId } = useParams();
  const [dashboard, setDashboard] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (restaurantId) {
      fetchDashboard();
    }
  }, [restaurantId]);

  const fetchDashboard = async () => {
    try {
      const data = await dashboardAPI.getBusinessDashboard(restaurantId);
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
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-gray-900">{dashboard.restaurantName} 대시보드</h1>
        <button
          onClick={fetchDashboard}
          className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        >
          새로고침
        </button>
      </div>

      {/* 핵심 지표 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="총 예약"
          value={dashboard.totalReservations?.toLocaleString() || '0'}
          change={dashboard.reservationGrowthRate}
        />
        <StatCard
          title="평균 평점"
          value={dashboard.averageRating?.toFixed(1) || '0.0'}
          subValue={`리뷰 ${dashboard.totalReviews || 0}개`}
        />
        <StatCard
          title="이번 달 매출"
          value={`${((dashboard.monthlyRevenue || 0) / 10000).toFixed(0)}만원`}
          change={dashboard.revenueGrowthRate}
        />
        <StatCard
          title="취소율"
          value={`${dashboard.cancellationRate?.toFixed(1) || '0.0'}%`}
          isNegative={true}
        />
      </div>

      {/* 오늘 예약 현황 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4 text-gray-900">오늘 예약 현황</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <p className="text-gray-600 text-sm">전체 예약</p>
            <p className="text-2xl font-bold text-gray-900">{dashboard.todayReservations || 0}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">대기 중</p>
            <p className="text-2xl font-bold text-yellow-600">{dashboard.pendingReservations || 0}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">확정</p>
            <p className="text-2xl font-bold text-green-600">{dashboard.confirmedReservations || 0}</p>
          </div>
        </div>
      </div>

      {/* 예약 상태 카드 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4 text-gray-900">예약 상태</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatusCard title="대기" value={dashboard.pendingReservations || 0} color="yellow" />
          <StatusCard title="확정" value={dashboard.confirmedReservations || 0} color="green" />
          <StatusCard title="완료" value={dashboard.completedReservations || 0} color="blue" />
          <StatusCard title="취소" value={dashboard.cancelledReservations || 0} color="red" />
        </div>
      </div>

      {/* 예약 추이 & 평점 분포 차트 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {dashboard.reservationTrend && dashboard.reservationTrend.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-900">예약 추이 (최근 30일)</h2>
            <Line
              data={{
                labels: dashboard.reservationTrend.map(d => d.label),
                datasets: [{
                  label: '예약 수',
                  data: dashboard.reservationTrend.map(d => d.count),
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

        {dashboard.ratingDistribution && dashboard.ratingDistribution.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-900">평점 분포</h2>
            <div className="max-w-md mx-auto">
              <Doughnut
                data={{
                  labels: dashboard.ratingDistribution.map(r => `⭐ ${r.rating}점`),
                  datasets: [{
                    data: dashboard.ratingDistribution.map(r => r.count),
                    backgroundColor: [
                      'rgba(239, 68, 68, 0.8)',
                      'rgba(249, 115, 22, 0.8)',
                      'rgba(234, 179, 8, 0.8)',
                      'rgba(132, 204, 22, 0.8)',
                      'rgba(34, 197, 94, 0.8)'
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

      {/* 구 평점 분포 (제거 예정) - 숨김 처리 */}
      {false && dashboard.ratingDistribution && dashboard.ratingDistribution.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">평점 분포</h2>
          <div className="space-y-2">
            {dashboard.ratingDistribution.map((rating, index) => (
              <div key={index} className="flex items-center gap-3">
                <span className="text-yellow-500 font-medium w-12">
                  {rating.rating}⭐
                </span>
                <div className="flex-1 bg-gray-200 rounded-full h-3">
                  <div
                    className="bg-yellow-500 h-3 rounded-full"
                    style={{ width: `${rating.percentage}%` }}
                  ></div>
                </div>
                <span className="text-sm w-24 text-right">
                  {rating.count} ({rating.percentage?.toFixed(1)}%)
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 인기 시간대 */}
      {dashboard.popularTimeSlots && dashboard.popularTimeSlots.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">인기 예약 시간대</h2>
          <div className="space-y-3">
            {dashboard.popularTimeSlots.map((slot, index) => (
              <div key={index} className="flex items-center justify-between border-b pb-2">
                <span className="font-medium text-gray-900">{slot.timeSlot}</span>
                <div className="flex items-center gap-4">
                  <span className="text-gray-700">{slot.reservationCount}건</span>
                  <span className="text-sm text-gray-600">
                    평균 {slot.averagePartySize?.toFixed(1)}명
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 다가오는 예약 */}
      {dashboard.upcomingReservations && dashboard.upcomingReservations.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">다가오는 예약</h2>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">고객명</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">예약 시간</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">인원</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">상태</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">연락처</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {dashboard.upcomingReservations.map((res) => (
                  <tr key={res.reservationId} className="hover:bg-gray-50">
                    <td className="px-4 py-3 text-sm text-gray-900">{res.userName}</td>
                    <td className="px-4 py-3 text-sm text-gray-700">
                      {new Date(res.reservationTime).toLocaleString('ko-KR', {
                        month: 'short',
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-700">{res.partySize}명</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-1 text-xs rounded-full ${
                        res.status === 'CONFIRMED'
                          ? 'bg-green-100 text-green-800'
                          : 'bg-yellow-100 text-yellow-800'
                      }`}>
                        {res.status === 'CONFIRMED' ? '확정' : '대기'}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-700">{res.contactPhone}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* 최근 리뷰 */}
      {dashboard.recentReviews && dashboard.recentReviews.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">최근 리뷰</h2>
          <div className="space-y-4">
            {dashboard.recentReviews.map((review) => (
              <div key={review.reviewId} className="border-b pb-4 last:border-b-0">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <span className="font-medium text-gray-900">{review.userName}</span>
                    <span className="text-yellow-500">
                      {'⭐'.repeat(review.rating)}
                    </span>
                  </div>
                  <span className="text-sm text-gray-500">
                    {new Date(review.createdAt).toLocaleDateString('ko-KR')}
                  </span>
                </div>
                <p className="text-gray-700 text-sm">{review.content}</p>
                {review.hasReply && (
                  <span className="inline-block mt-2 text-xs text-blue-600 bg-blue-50 px-2 py-1 rounded">
                    답변 완료
                  </span>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 리뷰 키워드 */}
      {dashboard.topKeywords && dashboard.topKeywords.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4 text-gray-900">리뷰 키워드 분석</h2>
          <div className="flex flex-wrap gap-2">
            {dashboard.topKeywords.map((keyword, index) => (
              <span
                key={index}
                className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium"
              >
                #{keyword.keyword} ({keyword.count})
              </span>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

const StatCard = ({ title, value, change, subValue, isNegative }) => (
  <div className="bg-white border border-gray-200 rounded-lg p-6 shadow-sm">
    <p className="text-gray-600 text-sm mb-2 font-medium">{title}</p>
    <p className="text-3xl font-bold text-gray-900">{value}</p>
    {subValue && <p className="text-sm text-gray-600 mt-1">{subValue}</p>}
    {change !== undefined && change !== null && (
      <p className={`text-sm mt-2 font-medium ${
        isNegative
          ? (change <= 0 ? 'text-green-600' : 'text-red-600')
          : (change >= 0 ? 'text-green-600' : 'text-red-600')
      }`}>
        {change >= 0 ? '↑' : '↓'} {Math.abs(change).toFixed(1)}% 전월 대비
      </p>
    )}
  </div>
);

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

export default BusinessDashboard;
