import React, { useState, useEffect } from 'react';
import { courseAPI } from '../../api/course';
import CourseCard from './CourseCard';

const CourseList = ({ filters = {} }) => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState({
    currentPage: 1,
    totalPages: 1,
    totalCount: 0,
    pageSize: 10
  });

  const fetchCourses = async (page = 1) => {
    setLoading(true);
    try {
      const params = {
        ...filters,
        page,
        size: pagination.pageSize
      };
      const result = await courseAPI.search(params);
      setCourses(result.courses || []);
      setPagination({
        currentPage: result.currentPage || 1,
        totalPages: result.totalPages || 1,
        totalCount: result.totalCount || 0,
        pageSize: result.pageSize || 10
      });
    } catch (error) {
      console.error('Failed to fetch courses:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCourses(1);
  }, [JSON.stringify(filters)]);

  const handlePageChange = (newPage) => {
    if (newPage >= 1 && newPage <= pagination.totalPages) {
      fetchCourses(newPage);
    }
  };

  const handleUpdate = (course) => {
    // 수정 로직 - 부모 컴포넌트에서 처리하거나 모달로 처리
    console.log('Update course:', course);
  };

  const handleDelete = () => {
    // 삭제 후 목록 새로고침
    fetchCourses(pagination.currentPage);
  };

  if (loading && courses.length === 0) {
    return (
      <div className="flex justify-center items-center py-12">
        <div className="text-gray-500">로딩 중...</div>
      </div>
    );
  }

  if (!loading && courses.length === 0) {
    return (
      <div className="flex justify-center items-center py-12">
        <div className="text-center">
          <p className="text-gray-500 mb-2">코스가 없습니다.</p>
          <p className="text-sm text-gray-400">새로운 코스를 만들어보세요!</p>
        </div>
      </div>
    );
  }

  return (
    <div>
      {/* Course List */}
      <div className="space-y-4 mb-6">
        {courses.map(course => (
          <CourseCard
            key={course.courseId}
            course={course}
            onUpdate={handleUpdate}
            onDelete={handleDelete}
          />
        ))}
      </div>

      {/* Pagination */}
      {pagination.totalPages > 1 && (
        <div className="flex justify-center items-center gap-2">
          <button
            onClick={() => handlePageChange(pagination.currentPage - 1)}
            disabled={pagination.currentPage === 1}
            className="px-3 py-1 border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            이전
          </button>

          <div className="flex gap-1">
            {[...Array(pagination.totalPages)].map((_, index) => {
              const page = index + 1;
              // 현재 페이지 근처만 표시
              if (
                page === 1 ||
                page === pagination.totalPages ||
                (page >= pagination.currentPage - 2 && page <= pagination.currentPage + 2)
              ) {
                return (
                  <button
                    key={page}
                    onClick={() => handlePageChange(page)}
                    className={`px-3 py-1 border rounded ${
                      page === pagination.currentPage
                        ? 'bg-blue-600 text-white border-blue-600'
                        : 'border-gray-300 hover:bg-gray-50'
                    }`}
                  >
                    {page}
                  </button>
                );
              } else if (
                page === pagination.currentPage - 3 ||
                page === pagination.currentPage + 3
              ) {
                return <span key={page} className="px-2">...</span>;
              }
              return null;
            })}
          </div>

          <button
            onClick={() => handlePageChange(pagination.currentPage + 1)}
            disabled={pagination.currentPage === pagination.totalPages}
            className="px-3 py-1 border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            다음
          </button>
        </div>
      )}

      {/* Total Count */}
      <div className="text-center mt-4 text-sm text-gray-500">
        전체 {pagination.totalCount}개의 코스
      </div>
    </div>
  );
};

export default CourseList;
