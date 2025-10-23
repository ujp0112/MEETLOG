import React, { useState, useEffect } from 'react';
import { followAPI } from '../../api/follow';
import FollowButton from './FollowButton';

/**
 * 팔로워/팔로잉 목록 컴포넌트
 */
const FollowList = ({ userId, type = 'followers', currentUser }) => {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalCount, setTotalCount] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const size = 20;

  useEffect(() => {
    fetchList();
  }, [userId, type, page]);

  const fetchList = async () => {
    setLoading(true);
    try {
      const data = type === 'followers'
        ? await followAPI.getFollowers(userId, page, size)
        : await followAPI.getFollowing(userId, page, size);

      setItems(data[type]);
      setTotalCount(data.totalCount);
      setTotalPages(data.totalPages);
    } catch (error) {
      console.error('Failed to fetch follow list:', error);
    } finally {
      setLoading(false);
    }
  };

  const handlePageChange = (newPage) => {
    setPage(newPage);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  if (loading && page === 1) {
    return (
      <div className="text-center py-12">
        <span className="text-4xl animate-spin inline-block">⏳</span>
        <p className="mt-4 text-gray-600">로딩 중...</p>
      </div>
    );
  }

  return (
    <div>
      {/* 헤더 */}
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900">
          {type === 'followers' ? '팔로워' : '팔로잉'}
        </h2>
        <p className="text-gray-600 mt-1">
          총 {totalCount.toLocaleString()}명
        </p>
      </div>

      {/* 목록 */}
      {items.length === 0 ? (
        <div className="text-center py-12 bg-gray-50 rounded-lg">
          <span className="text-6xl mb-4 block">👥</span>
          <p className="text-gray-600">
            {type === 'followers' ? '팔로워가 없습니다.' : '팔로우 중인 사용자가 없습니다.'}
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {items.map((item) => {
            const user = type === 'followers'
              ? {
                  id: item.followerId,
                  name: item.followerName,
                  nickname: item.followerNickname,
                  profileImage: item.followerProfileImage,
                  level: item.followerLevel,
                  followersCount: item.followerFollowersCount,
                  followingCount: item.followerFollowingCount
                }
              : {
                  id: item.followingId,
                  name: item.followingName,
                  nickname: item.followingNickname,
                  profileImage: item.followingProfileImage,
                  level: item.followingLevel,
                  followersCount: item.followingFollowersCount,
                  followingCount: item.followingFollowingCount
                };

            return (
              <div
                key={item.id}
                className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow"
              >
                <div className="flex items-center gap-4">
                  {/* 프로필 이미지 */}
                  <a href={`/users/${user.id}`}>
                    {user.profileImage ? (
                      <img
                        src={user.profileImage}
                        alt={user.nickname}
                        className="w-12 h-12 rounded-full object-cover"
                      />
                    ) : (
                      <div className="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-xl font-bold">
                        {user.nickname?.[0]?.toUpperCase() || '?'}
                      </div>
                    )}
                  </a>

                  {/* 사용자 정보 */}
                  <div>
                    <a
                      href={`/users/${user.id}`}
                      className="font-medium text-gray-900 hover:text-blue-600 transition-colors"
                    >
                      {user.nickname || user.name}
                    </a>
                    {item.isMutual && (
                      <span className="ml-2 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                        맞팔로우
                      </span>
                    )}
                    <div className="text-sm text-gray-600 mt-1">
                      <span>팔로워 {user.followersCount?.toLocaleString() || 0}</span>
                      <span className="mx-2">•</span>
                      <span>팔로잉 {user.followingCount?.toLocaleString() || 0}</span>
                      {user.level && (
                        <>
                          <span className="mx-2">•</span>
                          <span>Lv.{user.level}</span>
                        </>
                      )}
                    </div>
                  </div>
                </div>

                {/* 팔로우 버튼 */}
                <FollowButton
                  userId={user.id}
                  currentUser={currentUser}
                  onFollowChange={fetchList}
                />
              </div>
            );
          })}
        </div>
      )}

      {/* 페이지네이션 */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-2 mt-8">
          <button
            onClick={() => handlePageChange(page - 1)}
            disabled={page === 1}
            className="px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            이전
          </button>

          {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
            const pageNum = page <= 3 ? i + 1 : page - 2 + i;
            if (pageNum > totalPages) return null;
            return (
              <button
                key={pageNum}
                onClick={() => handlePageChange(pageNum)}
                className={`px-4 py-2 border rounded-md ${
                  page === pageNum
                    ? 'bg-blue-600 text-white border-blue-600'
                    : 'border-gray-300 hover:bg-gray-50'
                }`}
              >
                {pageNum}
              </button>
            );
          })}

          <button
            onClick={() => handlePageChange(page + 1)}
            disabled={page === totalPages}
            className="px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            다음
          </button>
        </div>
      )}
    </div>
  );
};

export default FollowList;
