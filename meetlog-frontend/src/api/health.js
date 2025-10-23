import apiClient from './client';

/**
 * Health Check API
 */
export const getHealthCheck = async () => {
  const response = await apiClient.get('/health');
  return response.data;
};
