import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { restaurantAPI } from '../api/restaurant';
import { useAuth } from '../context/AuthContext';

const RestaurantDetail = () => {
  const { restaurantId } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const [restaurant, setRestaurant] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchRestaurant();
  }, [restaurantId]);

  const fetchRestaurant = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await restaurantAPI.getById(restaurantId);
      setRestaurant(data);
    } catch (err) {
      console.error('Failed to fetch restaurant:', err);
      setError('레스토랑 정보를 불러오는데 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('정말 삭제하시겠습니까?')) {
      return;
    }

    try {
      await restaurantAPI.delete(restaurantId);
      alert('삭제되었습니다.');
      navigate('/restaurants');
    } catch (err) {
      alert('삭제에 실패했습니다.');
    }
  };

  const getPriceRangeText = (priceRange) => {
    switch (priceRange) {
      case 1: return '1만원 이하';
      case 2: return '1-2만원';
      case 3: return '2-3만원';
      case 4: return '3만원 이상';
      default: return '미정';
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">로딩 중...</p>
        </div>
      </div>
    );
  }

  if (error || !restaurant) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="bg-red-50 border border-red-200 rounded-lg p-6">
          <p className="text-red-600">{error || '레스토랑을 찾을 수 없습니다.'}</p>
          <button
            onClick={() => navigate('/restaurants')}
            className="mt-4 text-blue-600 hover:text-blue-800"
          >
            목록으로 돌아가기
          </button>
        </div>
      </div>
    );
  }

  const isOwner = user && user.userId === restaurant.ownerId;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex justify-between items-center">
            <Link
              to="/restaurants"
              className="text-blue-600 hover:text-blue-800"
            >
              ← 목록으로
            </Link>
            {isOwner && (
              <div className="space-x-2">
                <Link
                  to={`/restaurants/${restaurantId}/edit`}
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                >
                  수정
                </Link>
                <button
                  onClick={handleDelete}
                  className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700"
                >
                  삭제
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white rounded-lg shadow overflow-hidden">
          {/* Image */}
          <div className="h-96 bg-gray-200">
            {restaurant.imageUrl ? (
              <img
                src={restaurant.imageUrl}
                alt={restaurant.name}
                className="w-full h-full object-cover"
              />
            ) : (
              <div className="flex items-center justify-center h-full text-gray-400">
                이미지 없음
              </div>
            )}
          </div>

          {/* Info */}
          <div className="p-8">
            <div className="mb-6">
              <h1 className="text-3xl font-bold text-gray-900 mb-2">
                {restaurant.name}
              </h1>
              <div className="flex items-center mb-4">
                <span className="text-yellow-500 text-xl mr-2">★</span>
                <span className="text-lg text-gray-700">
                  {restaurant.averageRating?.toFixed(1) || '0.0'}
                </span>
                <span className="text-gray-500 ml-2">
                  ({restaurant.reviewCount || 0}개의 리뷰)
                </span>
              </div>
              <div className="flex gap-2">
                <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm">
                  {restaurant.category}
                </span>
                <span className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm">
                  {getPriceRangeText(restaurant.priceRange)}
                </span>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div>
                <h3 className="text-lg font-semibold mb-4">기본 정보</h3>
                <dl className="space-y-3">
                  <div>
                    <dt className="text-sm font-medium text-gray-500">주소</dt>
                    <dd className="text-gray-900">
                      {restaurant.address}
                      {restaurant.addressDetail && ` (${restaurant.addressDetail})`}
                    </dd>
                  </div>
                  {restaurant.phone && (
                    <div>
                      <dt className="text-sm font-medium text-gray-500">전화번호</dt>
                      <dd className="text-gray-900">{restaurant.phone}</dd>
                    </div>
                  )}
                  {restaurant.operatingHours && (
                    <div>
                      <dt className="text-sm font-medium text-gray-500">영업시간</dt>
                      <dd className="text-gray-900 whitespace-pre-line">{restaurant.operatingHours}</dd>
                    </div>
                  )}
                  {restaurant.capacity && (
                    <div>
                      <dt className="text-sm font-medium text-gray-500">수용인원</dt>
                      <dd className="text-gray-900">{restaurant.capacity}명</dd>
                    </div>
                  )}
                </dl>
              </div>

              <div>
                <h3 className="text-lg font-semibold mb-4">추가 정보</h3>
                {restaurant.description && (
                  <div className="mb-4">
                    <dt className="text-sm font-medium text-gray-500 mb-1">설명</dt>
                    <dd className="text-gray-900 whitespace-pre-line">{restaurant.description}</dd>
                  </div>
                )}
                {restaurant.facilities && (
                  <div className="mb-4">
                    <dt className="text-sm font-medium text-gray-500 mb-1">편의시설</dt>
                    <dd className="text-gray-900">{restaurant.facilities}</dd>
                  </div>
                )}
                {restaurant.parkingInfo && (
                  <div className="mb-4">
                    <dt className="text-sm font-medium text-gray-500 mb-1">주차정보</dt>
                    <dd className="text-gray-900">{restaurant.parkingInfo}</dd>
                  </div>
                )}
              </div>
            </div>

            {restaurant.menuInfo && (
              <div className="mt-8">
                <h3 className="text-lg font-semibold mb-4">메뉴</h3>
                <div className="bg-gray-50 rounded-lg p-4">
                  <p className="text-gray-900 whitespace-pre-line">{restaurant.menuInfo}</p>
                </div>
              </div>
            )}

            {/* Reviews Section Placeholder */}
            <div className="mt-8 pt-8 border-t">
              <h3 className="text-lg font-semibold mb-4">리뷰</h3>
              <div className="text-center py-8 text-gray-500">
                리뷰 기능은 Phase 4에서 구현됩니다.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RestaurantDetail;
