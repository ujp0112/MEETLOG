import apiClient from './client';

export const courseAPI = {
  /**
   * 코스 검색
   */
  search: async (params) => {
    const response = await apiClient.get('/courses', { params });
    return response.data;
  },

  /**
   * 코스 상세 조회
   */
  getById: async (id) => {
    const response = await apiClient.get(`/courses/${id}`);
    return response.data;
  },

  /**
   * 내 코스 목록
   */
  getMyCourses: async (page = 1, size = 10) => {
    const response = await apiClient.get('/courses/my', {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 코스 생성
   */
  create: async (courseData) => {
    const response = await apiClient.post('/courses', courseData);
    return response.data;
  },

  /**
   * 코스 수정
   */
  update: async (id, courseData) => {
    const response = await apiClient.put(`/courses/${id}`, courseData);
    return response.data;
  },

  /**
   * 코스 삭제
   */
  delete: async (id) => {
    await apiClient.delete(`/courses/${id}`);
  },

  /**
   * 코스 좋아요
   */
  like: async (id) => {
    await apiClient.post(`/courses/${id}/like`);
  },

  /**
   * 코스 좋아요 취소
   */
  unlike: async (id) => {
    await apiClient.delete(`/courses/${id}/like`);
  }
};
