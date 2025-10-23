import React, { useState } from 'react';
import { courseAPI } from '../../api/course';
import { useAuth } from '../../context/AuthContext';

const CourseCard = ({ course, onUpdate, onDelete }) => {
  const { user } = useAuth();
  const [isLiked, setIsLiked] = useState(course.isLiked || false);
  const [likes, setLikes] = useState(course.likesCount || 0);

  const isOwner = user && user.userId === course.authorId;

  const handleLike = async () => {
    try {
      if (isLiked) {
        await courseAPI.unlike(course.courseId);
        setIsLiked(false);
        setLikes(likes - 1);
      } else {
        await courseAPI.like(course.courseId);
        setIsLiked(true);
        setLikes(likes + 1);
      }
    } catch (error) {
      console.error('Failed to toggle like:', error);
      alert('좋아요 처리에 실패했습니다.');
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('이 코스를 삭제하시겠습니까?')) return;

    try {
      await courseAPI.delete(course.courseId);
      if (onDelete) onDelete();
    } catch (error) {
      console.error('Failed to delete course:', error);
      alert('코스 삭제에 실패했습니다.');
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'PENDING':
        return 'bg-yellow-100 text-yellow-800';
      case 'ACTIVE':
        return 'bg-green-100 text-green-800';
      case 'COMPLETED':
        return 'bg-blue-100 text-blue-800';
      case 'CANCELLED':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const getStatusText = (status) => {
    switch (status) {
      case 'PENDING':
        return '대기 중';
      case 'ACTIVE':
        return '활성';
      case 'COMPLETED':
        return '완료';
      case 'CANCELLED':
        return '취소';
      default:
        return status;
    }
  };

  const getTypeText = (type) => {
    return type === 'OFFICIAL' ? '공식' : '커뮤니티';
  };

  const totalCost = course.steps?.reduce((sum, step) => sum + (step.cost || 0), 0) || 0;
  const totalTime = course.steps?.reduce((sum, step) => sum + (step.time || 0), 0) || 0;

  const formatTime = (minutes) => {
    if (!minutes) return '시간 미정';
    if (minutes < 60) return `${minutes}분`;
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    return mins > 0 ? `${hours}시간 ${mins}분` : `${hours}시간`;
  };

  const formatCost = (cost) => {
    if (!cost) return '무료';
    if (cost >= 10000) {
      return `${(cost / 10000).toFixed(1)}만원`;
    }
    return `${cost.toLocaleString()}원`;
  };

  return (
    <div className="bg-white rounded-lg shadow hover:shadow-lg transition-shadow p-6 mb-4">
      {/* Header */}
      <div className="flex items-start justify-between mb-4">
        <div className="flex-1">
          <div className="flex items-center gap-2 mb-2">
            <h3 className="text-lg font-bold text-gray-900">{course.title}</h3>
            <span className={`px-2 py-1 rounded text-xs font-medium ${getStatusColor(course.status)}`}>
              {getStatusText(course.status)}
            </span>
            <span className="px-2 py-1 rounded text-xs font-medium bg-purple-100 text-purple-800">
              {getTypeText(course.type)}
            </span>
          </div>
          <p className="text-sm text-gray-600">{course.authorNickname || course.authorName}</p>
        </div>
      </div>

      {/* Description */}
      {course.description && (
        <p className="text-sm text-gray-700 mb-4 line-clamp-2">{course.description}</p>
      )}

      {/* Info Grid */}
      <div className="grid grid-cols-2 gap-4 mb-4">
        {course.area && (
          <div>
            <p className="text-xs text-gray-500">지역</p>
            <p className="text-sm font-medium">{course.area}</p>
          </div>
        )}
        <div>
          <p className="text-xs text-gray-500">소요 시간</p>
          <p className="text-sm font-medium">{course.duration || formatTime(totalTime)}</p>
        </div>
        <div>
          <p className="text-xs text-gray-500">예상 비용</p>
          <p className="text-sm font-medium">{formatCost(course.price || totalCost)}</p>
        </div>
        <div>
          <p className="text-xs text-gray-500">단계 수</p>
          <p className="text-sm font-medium">{course.steps?.length || 0}개</p>
        </div>
      </div>

      {/* Steps Preview */}
      {course.steps && course.steps.length > 0 && (
        <div className="mb-4">
          <p className="text-xs text-gray-500 mb-2">코스 경로</p>
          <div className="flex items-center gap-2 overflow-x-auto">
            {course.steps.slice(0, 5).map((step, index) => (
              <React.Fragment key={step.stepId}>
                <div className="flex items-center gap-1 px-2 py-1 bg-gray-100 rounded text-xs whitespace-nowrap">
                  {step.emoji && <span>{step.emoji}</span>}
                  <span>{step.name}</span>
                </div>
                {index < Math.min(4, course.steps.length - 1) && (
                  <span className="text-gray-400">→</span>
                )}
              </React.Fragment>
            ))}
            {course.steps.length > 5 && (
              <span className="text-xs text-gray-500">+{course.steps.length - 5}</span>
            )}
          </div>
        </div>
      )}

      {/* Tags */}
      {course.tags && course.tags.length > 0 && (
        <div className="mb-4">
          <div className="flex flex-wrap gap-2">
            {course.tags.map((tag, index) => (
              <span
                key={index}
                className="px-2 py-1 bg-blue-50 text-blue-700 rounded text-xs"
              >
                #{tag}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* Stats & Actions */}
      <div className="flex items-center justify-between pt-4 border-t">
        <div className="flex items-center gap-4 text-sm text-gray-600">
          <button
            onClick={handleLike}
            className={`flex items-center gap-1 ${isLiked ? 'text-red-500' : 'hover:text-red-500'}`}
          >
            <span>{isLiked ? '❤️' : '🤍'}</span>
            <span>{likes}</span>
          </button>
          <span>💬 {course.commentsCount || 0}</span>
          <span>📅 {course.reservationsCount || 0}</span>
        </div>

        {isOwner && (
          <div className="flex gap-2">
            <button
              onClick={() => onUpdate && onUpdate(course)}
              className="px-3 py-1 text-sm text-blue-600 hover:text-blue-800 border border-blue-300 rounded hover:bg-blue-50"
            >
              수정
            </button>
            <button
              onClick={handleDelete}
              className="px-3 py-1 text-sm text-red-600 hover:text-red-800 border border-red-300 rounded hover:bg-red-50"
            >
              삭제
            </button>
          </div>
        )}
      </div>

      {/* Created At */}
      <div className="mt-2 text-xs text-gray-400">
        생성일: {new Date(course.createdAt).toLocaleDateString()}
      </div>
    </div>
  );
};

export default CourseCard;
