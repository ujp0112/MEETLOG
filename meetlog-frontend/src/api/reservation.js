import apiClient from './client';

export const reservationAPI = {
  /**
   * 예약 검색
   */
  search: async (params) => {
    const response = await apiClient.get('/reservations', { params });
    return response.data;
  },

  /**
   * 예약 상세 조회
   */
  getById: async (id) => {
    const response = await apiClient.get(`/reservations/${id}`);
    return response.data;
  },

  /**
   * 레스토랑별 예약 목록
   */
  getByRestaurant: async (restaurantId, page = 1, size = 10) => {
    const response = await apiClient.get(`/reservations/restaurant/${restaurantId}`, {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 내 예약 목록
   */
  getMyReservations: async (page = 1, size = 10) => {
    const response = await apiClient.get('/reservations/my', {
      params: { page, size }
    });
    return response.data;
  },

  /**
   * 예약 가능 여부 확인
   */
  checkAvailability: async (restaurantId, reservationTime, partySize) => {
    const response = await apiClient.get('/reservations/availability', {
      params: { restaurantId, reservationTime, partySize }
    });
    return response.data;
  },

  /**
   * 예약 생성
   */
  create: async (reservationData) => {
    const response = await apiClient.post('/reservations', reservationData);
    return response.data;
  },

  /**
   * 예약 수정
   */
  update: async (id, reservationData) => {
    const response = await apiClient.put(`/reservations/${id}`, reservationData);
    return response.data;
  },

  /**
   * 예약 취소
   */
  cancel: async (id, cancelReason) => {
    await apiClient.delete(`/reservations/${id}`, {
      params: { cancelReason }
    });
  },

  /**
   * 예약 확정 (사업자용)
   */
  confirm: async (id) => {
    const response = await apiClient.post(`/reservations/${id}/confirm`);
    return response.data;
  }
};
