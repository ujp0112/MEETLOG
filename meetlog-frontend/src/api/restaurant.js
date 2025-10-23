import apiClient from './client';

export const restaurantAPI = {
  search: async (params) => {
    const response = await apiClient.get('/restaurants', { params });
    return response.data;
  },

  getById: async (restaurantId) => {
    const response = await apiClient.get(`/restaurants/${restaurantId}`);
    return response.data;
  },

  getMyRestaurants: async () => {
    const response = await apiClient.get('/restaurants/my');
    return response.data;
  },

  create: async (data) => {
    const response = await apiClient.post('/restaurants', data);
    return response.data;
  },

  update: async (restaurantId, data) => {
    const response = await apiClient.put(`/restaurants/${restaurantId}`, data);
    return response.data;
  },

  delete: async (restaurantId) => {
    const response = await apiClient.delete(`/restaurants/${restaurantId}`);
    return response.data;
  },

  updateStatus: async (restaurantId, status) => {
    const response = await apiClient.patch(`/restaurants/${restaurantId}/status`, null, {
      params: { status }
    });
    return response.data;
  },

  uploadImage: async (file) => {
    const formData = new FormData();
    formData.append('file', file);
    const response = await apiClient.post('/files/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
    return response.data.url;
  }
};
