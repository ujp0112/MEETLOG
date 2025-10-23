import React, { useState, useEffect } from 'react';
import { reviewAPI } from '../../api/review';
import ReviewCard from './ReviewCard';

const ReviewList = ({ restaurantId }) => {
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);

  useEffect(() => {
    fetchReviews();
  }, [restaurantId, page]);

  const fetchReviews = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await reviewAPI.getByRestaurant(restaurantId, page, 10);
      if (page === 1) {
        setReviews(data);
      } else {
        setReviews([...reviews, ...data]);
      }
      setHasMore(data.length === 10);
    } catch (err) {
      console.error('Failed to fetch reviews:', err);
      setError('리뷰를 불러오는데 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  const handleUpdate = (review) => {
    // 리뷰 수정 모달 또는 페이지로 이동
    console.log('Update review:', review);
  };

  const handleDelete = () => {
    // 리뷰 삭제 후 목록 새로고침
    setPage(1);
    fetchReviews();
  };

  const loadMore = () => {
    setPage(page + 1);
  };

  if (loading && page === 1) {
    return (
      <div className="flex justify-center items-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-lg p-4">
        <p className="text-red-600">{error}</p>
      </div>
    );
  }

  if (reviews.length === 0) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">아직 리뷰가 없습니다.</p>
        <p className="text-sm text-gray-400 mt-2">첫 번째 리뷰를 작성해보세요!</p>
      </div>
    );
  }

  return (
    <div>
      <div className="space-y-4">
        {reviews.map((review) => (
          <ReviewCard
            key={review.id}
            review={review}
            onUpdate={handleUpdate}
            onDelete={handleDelete}
          />
        ))}
      </div>

      {hasMore && (
        <div className="text-center mt-6">
          <button
            onClick={loadMore}
            disabled={loading}
            className="px-6 py-2 bg-white border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 disabled:opacity-50"
          >
            {loading ? '로딩 중...' : '더 보기'}
          </button>
        </div>
      )}
    </div>
  );
};

export default ReviewList;
