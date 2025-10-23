import apiClient from './client';

export const reviewAPI = {
  /**
   * 리뷰 검색
   */
  search: async (params) => {
    const response = await apiClient.get('/reviews', { params });
    return response.data;
  },

  /**
   * 리뷰 상세 조회
   */
  getById: async (id) => {
    const response = await apiClient.get(`/reviews/${id}`);
    return response.data;
  },

  /**
   * 레스토랑별 리뷰 목록
   */
  getByRestaurant: async (restaurantId, page = 1, size = 10) => {
    const response = await apiClient.get(`/reviews/restaurant/${restaurantId}`, {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 내 리뷰 목록
   */
  getMyReviews: async (page = 1, size = 10) => {
    const response = await apiClient.get('/reviews/my', {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 리뷰 작성
   */
  create: async (reviewData) => {
    const response = await apiClient.post('/reviews', reviewData);
    return response.data;
  },

  /**
   * 리뷰 수정
   */
  update: async (id, reviewData) => {
    const response = await apiClient.put(`/reviews/${id}`, reviewData);
    return response.data;
  },

  /**
   * 리뷰 삭제
   */
  delete: async (id) => {
    await apiClient.delete(`/reviews/${id}`);
  },

  /**
   * 리뷰 좋아요
   */
  like: async (id) => {
    await apiClient.post(`/reviews/${id}/like`);
  },

  /**
   * 리뷰 좋아요 취소
   */
  unlike: async (id) => {
    await apiClient.delete(`/reviews/${id}/like`);
  },

  /**
   * 사업자 답글 등록/수정
   */
  addReply: async (id, replyContent) => {
    const response = await apiClient.post(`/reviews/${id}/reply`, null, {
      params: { replyContent }
    });
    return response.data;
  }
};
