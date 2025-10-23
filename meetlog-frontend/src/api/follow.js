import apiClient from './client';

/**
 * 팔로우 API
 */
export const followAPI = {
  /**
   * 팔로우
   */
  follow: async (userId) => {
    const response = await apiClient.post(`/follows/${userId}`);
    return response.data;
  },

  /**
   * 언팔로우
   */
  unfollow: async (userId) => {
    const response = await apiClient.delete(`/follows/${userId}`);
    return response.data;
  },

  /**
   * 팔로워 목록 조회
   */
  getFollowers: async (userId, page = 1, size = 20) => {
    const response = await apiClient.get(`/follows/${userId}/followers`, {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 팔로잉 목록 조회
   */
  getFollowing: async (userId, page = 1, size = 20) => {
    const response = await apiClient.get(`/follows/${userId}/following`, {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 팔로우 여부 확인
   */
  isFollowing: async (userId) => {
    const response = await apiClient.get(`/follows/${userId}/is-following`);
    return response.data;
  },

  /**
   * 팔로우 통계 조회
   */
  getStats: async (userId) => {
    const response = await apiClient.get(`/follows/${userId}/stats`);
    return response.data;
  },

  /**
   * 맞팔 여부 확인
   */
  isMutual: async (userId) => {
    const response = await apiClient.get(`/follows/${userId}/is-mutual`);
    return response.data;
  }
};

export default followAPI;
