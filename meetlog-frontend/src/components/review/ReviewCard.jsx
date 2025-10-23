import React, { useState } from 'react';
import { reviewAPI } from '../../api/review';
import { useAuth } from '../../context/AuthContext';

const ReviewCard = ({ review, onUpdate, onDelete }) => {
  const { user } = useAuth();
  const [isLiked, setIsLiked] = useState(false);
  const [likes, setLikes] = useState(review.likes || 0);
  const [showReplyForm, setShowReplyForm] = useState(false);
  const [replyContent, setReplyContent] = useState(review.replyContent || '');

  const isOwner = user && user.userId === review.userId;
  const isBusinessOwner = user && user.userType === 'BUSINESS';

  const handleLike = async () => {
    try {
      if (isLiked) {
        await reviewAPI.unlike(review.id);
        setLikes(likes - 1);
      } else {
        await reviewAPI.like(review.id);
        setLikes(likes + 1);
      }
      setIsLiked(!isLiked);
    } catch (error) {
      console.error('Failed to toggle like:', error);
    }
  };

  const handleReplySubmit = async (e) => {
    e.preventDefault();
    try {
      await reviewAPI.addReply(review.id, replyContent);
      setShowReplyForm(false);
      if (onUpdate) onUpdate();
    } catch (error) {
      console.error('Failed to add reply:', error);
      alert('답글 등록에 실패했습니다.');
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('정말 이 리뷰를 삭제하시겠습니까?')) return;

    try {
      await reviewAPI.delete(review.id);
      if (onDelete) onDelete();
    } catch (error) {
      console.error('Failed to delete review:', error);
      alert('리뷰 삭제에 실패했습니다.');
    }
  };

  const renderStars = (rating) => {
    return (
      <div className="flex items-center">
        {[1, 2, 3, 4, 5].map((star) => (
          <svg
            key={star}
            className={`w-5 h-5 ${
              star <= rating ? 'text-yellow-400' : 'text-gray-300'
            }`}
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
          </svg>
        ))}
        <span className="ml-2 text-sm text-gray-600">{rating}.0</span>
      </div>
    );
  };

  return (
    <div className="bg-white rounded-lg shadow p-6 mb-4">
      {/* Header */}
      <div className="flex items-start justify-between mb-4">
        <div className="flex items-center">
          <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center text-white font-bold">
            {review.userNickname ? review.userNickname[0] : review.userName[0]}
          </div>
          <div className="ml-3">
            <p className="font-semibold text-gray-900">
              {review.userNickname || review.userName}
            </p>
            <p className="text-sm text-gray-500">
              {new Date(review.createdAt).toLocaleDateString()}
            </p>
          </div>
        </div>
        {isOwner && (
          <div className="flex space-x-2">
            <button
              onClick={() => onUpdate && onUpdate(review)}
              className="text-sm text-blue-600 hover:text-blue-800"
            >
              수정
            </button>
            <button
              onClick={handleDelete}
              className="text-sm text-red-600 hover:text-red-800"
            >
              삭제
            </button>
          </div>
        )}
      </div>

      {/* Rating */}
      <div className="mb-3">{renderStars(review.rating)}</div>

      {/* Content */}
      <p className="text-gray-700 mb-4">{review.content}</p>

      {/* Keywords */}
      {review.keywords && review.keywords.length > 0 && (
        <div className="flex flex-wrap gap-2 mb-4">
          {review.keywords.map((keyword, index) => (
            <span
              key={index}
              className="px-3 py-1 bg-blue-100 text-blue-700 text-sm rounded-full"
            >
              {keyword}
            </span>
          ))}
        </div>
      )}

      {/* Images */}
      {review.images && review.images.length > 0 && (
        <div className="grid grid-cols-3 gap-2 mb-4">
          {review.images.map((image, index) => (
            <img
              key={index}
              src={image}
              alt={`Review ${index + 1}`}
              className="w-full h-32 object-cover rounded"
            />
          ))}
        </div>
      )}

      {/* Likes */}
      <div className="flex items-center justify-between border-t pt-4">
        <button
          onClick={handleLike}
          className={`flex items-center space-x-1 ${
            isLiked ? 'text-red-600' : 'text-gray-600'
          } hover:text-red-600`}
        >
          <svg
            className="w-5 h-5"
            fill={isLiked ? 'currentColor' : 'none'}
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
            />
          </svg>
          <span className="text-sm">좋아요 {likes}</span>
        </button>

        {isBusinessOwner && !review.replyContent && (
          <button
            onClick={() => setShowReplyForm(true)}
            className="text-sm text-blue-600 hover:text-blue-800"
          >
            답글 달기
          </button>
        )}
      </div>

      {/* Business Reply */}
      {review.replyContent && (
        <div className="mt-4 pl-4 border-l-4 border-blue-500 bg-blue-50 p-4 rounded">
          <p className="text-sm font-semibold text-blue-900 mb-2">사업자 답글</p>
          <p className="text-sm text-gray-700">{review.replyContent}</p>
          <p className="text-xs text-gray-500 mt-2">
            {new Date(review.replyCreatedAt).toLocaleDateString()}
          </p>
        </div>
      )}

      {/* Reply Form */}
      {showReplyForm && (
        <form onSubmit={handleReplySubmit} className="mt-4 pl-4 border-l-4 border-blue-500">
          <textarea
            value={replyContent}
            onChange={(e) => setReplyContent(e.target.value)}
            placeholder="답글을 입력하세요..."
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            rows="3"
            required
          />
          <div className="flex justify-end space-x-2 mt-2">
            <button
              type="button"
              onClick={() => setShowReplyForm(false)}
              className="px-4 py-2 text-sm text-gray-600 hover:text-gray-800"
            >
              취소
            </button>
            <button
              type="submit"
              className="px-4 py-2 text-sm text-white bg-blue-600 rounded-md hover:bg-blue-700"
            >
              등록
            </button>
          </div>
        </form>
      )}
    </div>
  );
};

export default ReviewCard;
