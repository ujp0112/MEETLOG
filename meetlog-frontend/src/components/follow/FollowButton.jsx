import React, { useState, useEffect } from 'react';
import { followAPI } from '../../api/follow';

/**
 * 팔로우 버튼 컴포넌트
 */
const FollowButton = ({ userId, currentUser, onFollowChange }) => {
  const [isFollowing, setIsFollowing] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (currentUser && userId !== currentUser.id) {
      checkFollowStatus();
    }
  }, [currentUser, userId]);

  const checkFollowStatus = async () => {
    try {
      const data = await followAPI.isFollowing(userId);
      setIsFollowing(data.isFollowing);
    } catch (error) {
      console.error('Failed to check follow status:', error);
    }
  };

  const handleToggleFollow = async () => {
    if (!currentUser) {
      alert('로그인이 필요합니다.');
      window.location.href = '/login';
      return;
    }

    setLoading(true);
    try {
      if (isFollowing) {
        await followAPI.unfollow(userId);
        setIsFollowing(false);
        if (onFollowChange) onFollowChange(false);
      } else {
        await followAPI.follow(userId);
        setIsFollowing(true);
        if (onFollowChange) onFollowChange(true);
      }
    } catch (error) {
      console.error('Failed to toggle follow:', error);
      if (error.response?.status === 400 && error.response?.data?.message === 'Cannot follow yourself') {
        alert('자기 자신을 팔로우할 수 없습니다.');
      } else if (error.response?.status === 400 && error.response?.data?.message === 'Already following') {
        alert('이미 팔로우 중입니다.');
      } else {
        alert('팔로우 처리에 실패했습니다.');
      }
    } finally {
      setLoading(false);
    }
  };

  // 본인이면 버튼 표시 안함
  if (!currentUser || userId === currentUser.id) {
    return null;
  }

  return (
    <button
      onClick={handleToggleFollow}
      disabled={loading}
      className={`px-4 py-2 rounded-md font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 ${
        isFollowing
          ? 'bg-gray-200 text-gray-800 hover:bg-gray-300 focus:ring-gray-400'
          : 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500'
      } disabled:opacity-50 disabled:cursor-not-allowed`}
      aria-label={isFollowing ? '팔로잉' : '팔로우'}
    >
      {loading ? (
        <span className="flex items-center gap-2">
          <span className="animate-spin">⏳</span>
          처리 중...
        </span>
      ) : (
        <span className="flex items-center gap-2">
          {isFollowing ? (
            <>
              <span>✓</span>
              팔로잉
            </>
          ) : (
            <>
              <span>+</span>
              팔로우
            </>
          )}
        </span>
      )}
    </button>
  );
};

export default FollowButton;
