import React, { useState } from 'react';
import { reservationAPI } from '../../api/reservation';

const ReservationForm = ({ restaurantId, restaurantName, onSuccess, onCancel }) => {
  const [formData, setFormData] = useState({
    restaurantId: restaurantId,
    reservationTime: '',
    partySize: 2,
    specialRequests: '',
    contactPhone: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [availability, setAvailability] = useState(null);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'partySize' ? parseInt(value) : value
    });
    setAvailability(null);
  };

  const checkAvailability = async () => {
    if (!formData.reservationTime || !formData.partySize) {
      setError('예약 시간과 인원을 선택해주세요.');
      return;
    }

    try {
      const result = await reservationAPI.checkAvailability(
        restaurantId,
        formData.reservationTime,
        formData.partySize
      );
      setAvailability(result.available);
      if (!result.available) {
        setError('해당 시간에 예약이 불가능합니다. 다른 시간을 선택해주세요.');
      } else {
        setError('');
      }
    } catch (err) {
      console.error('Failed to check availability:', err);
      setError('예약 가능 여부를 확인할 수 없습니다.');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (availability === false) {
      setError('예약이 불가능한 시간입니다. 가능 여부를 다시 확인해주세요.');
      return;
    }

    setLoading(true);
    try {
      await reservationAPI.create(formData);
      if (onSuccess) onSuccess();
    } catch (err) {
      console.error('Failed to create reservation:', err);
      setError(err.response?.data?.message || '예약 생성에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-6">
      <h3 className="text-xl font-bold mb-4">{restaurantName} 예약</h3>

      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded">
          <p className="text-sm text-red-600">{error}</p>
        </div>
      )}

      {availability === true && (
        <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded">
          <p className="text-sm text-green-600">✓ 예약 가능한 시간입니다.</p>
        </div>
      )}

      {/* Reservation Time */}
      <div className="mb-4">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          예약 날짜 및 시간 *
        </label>
        <input
          type="datetime-local"
          name="reservationTime"
          value={formData.reservationTime}
          onChange={handleChange}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          required
        />
      </div>

      {/* Party Size */}
      <div className="mb-4">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          인원 수 *
        </label>
        <select
          name="partySize"
          value={formData.partySize}
          onChange={handleChange}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          required
        >
          {[...Array(10)].map((_, i) => (
            <option key={i + 1} value={i + 1}>
              {i + 1}명
            </option>
          ))}
        </select>
      </div>

      {/* Check Availability Button */}
      <div className="mb-6">
        <button
          type="button"
          onClick={checkAvailability}
          className="w-full px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700"
        >
          예약 가능 여부 확인
        </button>
      </div>

      {/* Contact Phone */}
      <div className="mb-4">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          연락처 (선택사항)
        </label>
        <input
          type="tel"
          name="contactPhone"
          value={formData.contactPhone}
          onChange={handleChange}
          placeholder="010-1234-5678"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
        />
      </div>

      {/* Special Requests */}
      <div className="mb-6">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          요청 사항 (선택사항)
        </label>
        <textarea
          name="specialRequests"
          value={formData.specialRequests}
          onChange={handleChange}
          placeholder="특별한 요청사항이 있으시면 입력해주세요"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          rows="3"
        />
      </div>

      {/* Buttons */}
      <div className="flex justify-end space-x-3">
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            className="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
          >
            취소
          </button>
        )}
        <button
          type="submit"
          disabled={loading || availability === false}
          className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? '예약 중...' : '예약하기'}
        </button>
      </div>
    </form>
  );
};

export default ReservationForm;
