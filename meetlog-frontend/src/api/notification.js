import apiClient from './client';

/**
 * 알림 API
 */
export const notificationAPI = {
  /**
   * 알림 목록 조회
   */
  getNotifications: async (page = 1, size = 20) => {
    const response = await apiClient.get('/notifications', {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 읽지 않은 알림 수 조회
   */
  getUnreadCount: async () => {
    const response = await apiClient.get('/notifications/unread-count');
    return response.data;
  },

  /**
   * 알림 읽음 처리
   */
  markAsRead: async (id) => {
    await apiClient.patch(`/notifications/${id}/read`);
  },

  /**
   * 모든 알림 읽음 처리
   */
  markAllAsRead: async () => {
    await apiClient.patch('/notifications/read-all');
  },

  /**
   * 알림 삭제
   */
  delete: async (id) => {
    await apiClient.delete(`/notifications/${id}`);
  }
};

export default notificationAPI;
