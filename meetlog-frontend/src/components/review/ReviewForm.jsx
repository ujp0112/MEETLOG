import React, { useState } from 'react';
import { reviewAPI } from '../../api/review';

const ReviewForm = ({ restaurantId, onSuccess, onCancel }) => {
  const [formData, setFormData] = useState({
    restaurantId: restaurantId,
    rating: 5,
    content: '',
    images: [],
    keywords: []
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const keywordOptions = [
    '맛있어요', '친절해요', '청결해요', '가성비 좋아요',
    '분위기 좋아요', '재방문 의사 있어요', '주차 편해요', '접근성 좋아요'
  ];

  const handleRatingClick = (rating) => {
    setFormData({ ...formData, rating });
  };

  const handleKeywordToggle = (keyword) => {
    const keywords = formData.keywords.includes(keyword)
      ? formData.keywords.filter(k => k !== keyword)
      : [...formData.keywords, keyword];
    setFormData({ ...formData, keywords });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (formData.content.length < 10) {
      setError('리뷰 내용은 최소 10자 이상 입력해주세요.');
      return;
    }

    setLoading(true);
    try {
      await reviewAPI.create(formData);
      if (onSuccess) onSuccess();
    } catch (err) {
      console.error('Failed to create review:', err);
      setError(err.response?.data?.message || '리뷰 작성에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-6">
      <h3 className="text-xl font-bold mb-4">리뷰 작성</h3>

      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded">
          <p className="text-sm text-red-600">{error}</p>
        </div>
      )}

      {/* Rating */}
      <div className="mb-6">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          평점 *
        </label>
        <div className="flex items-center space-x-2">
          {[1, 2, 3, 4, 5].map((star) => (
            <button
              key={star}
              type="button"
              onClick={() => handleRatingClick(star)}
              className="focus:outline-none"
            >
              <svg
                className={`w-8 h-8 ${
                  star <= formData.rating
                    ? 'text-yellow-400'
                    : 'text-gray-300'
                } hover:text-yellow-400 transition-colors`}
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
            </button>
          ))}
          <span className="ml-2 text-lg font-semibold text-gray-700">
            {formData.rating}.0
          </span>
        </div>
      </div>

      {/* Keywords */}
      <div className="mb-6">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          키워드 선택 (선택사항)
        </label>
        <div className="flex flex-wrap gap-2">
          {keywordOptions.map((keyword) => (
            <button
              key={keyword}
              type="button"
              onClick={() => handleKeywordToggle(keyword)}
              className={`px-4 py-2 rounded-full text-sm font-medium transition-colors ${
                formData.keywords.includes(keyword)
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              {keyword}
            </button>
          ))}
        </div>
      </div>

      {/* Content */}
      <div className="mb-6">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          리뷰 내용 *
        </label>
        <textarea
          value={formData.content}
          onChange={(e) => setFormData({ ...formData, content: e.target.value })}
          placeholder="레스토랑에 대한 솔직한 리뷰를 작성해주세요 (최소 10자)"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          rows="6"
          required
        />
        <p className="mt-1 text-sm text-gray-500">
          {formData.content.length} / 1000자
        </p>
      </div>

      {/* Buttons */}
      <div className="flex justify-end space-x-3">
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            className="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
          >
            취소
          </button>
        )}
        <button
          type="submit"
          disabled={loading}
          className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? '작성 중...' : '리뷰 등록'}
        </button>
      </div>
    </form>
  );
};

export default ReviewForm;
