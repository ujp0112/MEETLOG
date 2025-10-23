import apiClient from './client';

export const dashboardAPI = {
  /**
   * 관리자 대시보드 통계 조회
   */
  getAdminDashboard: async () => {
    const response = await apiClient.get('/dashboard/admin');
    return response.data;
  },

  /**
   * 비즈니스 대시보드 통계 조회
   */
  getBusinessDashboard: async (restaurantId) => {
    const response = await apiClient.get(`/dashboard/business/${restaurantId}`);
    return response.data;
  }
};
