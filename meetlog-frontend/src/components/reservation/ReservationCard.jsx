import React from 'react';
import { reservationAPI } from '../../api/reservation';
import { useAuth } from '../../context/AuthContext';

const ReservationCard = ({ reservation, onUpdate, onCancel }) => {
  const { user } = useAuth();
  const isOwner = user && user.userId === reservation.userId;
  const isBusinessOwner = user && user.userType === 'BUSINESS';

  const handleCancel = async () => {
    const cancelReason = window.prompt('취소 사유를 입력해주세요 (선택사항):');
    if (cancelReason === null) return; // 사용자가 취소를 누른 경우

    try {
      await reservationAPI.cancel(reservation.id, cancelReason);
      if (onCancel) onCancel();
    } catch (error) {
      console.error('Failed to cancel reservation:', error);
      alert('예약 취소에 실패했습니다.');
    }
  };

  const handleConfirm = async () => {
    if (!window.confirm('이 예약을 확정하시겠습니까?')) return;

    try {
      await reservationAPI.confirm(reservation.id);
      if (onUpdate) onUpdate();
    } catch (error) {
      console.error('Failed to confirm reservation:', error);
      alert('예약 확정에 실패했습니다.');
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'PENDING':
        return 'bg-yellow-100 text-yellow-800';
      case 'CONFIRMED':
        return 'bg-green-100 text-green-800';
      case 'COMPLETED':
        return 'bg-blue-100 text-blue-800';
      case 'CANCELLED':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const getStatusText = (status) => {
    switch (status) {
      case 'PENDING':
        return '대기 중';
      case 'CONFIRMED':
        return '확정';
      case 'COMPLETED':
        return '완료';
      case 'CANCELLED':
        return '취소';
      default:
        return status;
    }
  };

  return (
    <div className="bg-white rounded-lg shadow p-6 mb-4">
      {/* Header */}
      <div className="flex items-start justify-between mb-4">
        <div>
          <h3 className="text-lg font-bold text-gray-900">{reservation.restaurantName}</h3>
          <p className="text-sm text-gray-500">{reservation.restaurantAddress}</p>
        </div>
        <span className={`px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(reservation.status)}`}>
          {getStatusText(reservation.status)}
        </span>
      </div>

      {/* Reservation Info */}
      <div className="grid grid-cols-2 gap-4 mb-4">
        <div>
          <p className="text-sm text-gray-500">예약 시간</p>
          <p className="font-medium">
            {new Date(reservation.reservationTime).toLocaleString('ko-KR', {
              year: 'numeric',
              month: 'long',
              day: 'numeric',
              hour: '2-digit',
              minute: '2-digit'
            })}
          </p>
        </div>
        <div>
          <p className="text-sm text-gray-500">인원</p>
          <p className="font-medium">{reservation.partySize}명</p>
        </div>
      </div>

      {/* Special Requests */}
      {reservation.specialRequests && (
        <div className="mb-4">
          <p className="text-sm text-gray-500">요청 사항</p>
          <p className="text-sm text-gray-700">{reservation.specialRequests}</p>
        </div>
      )}

      {/* Contact Info */}
      <div className="mb-4">
        <p className="text-sm text-gray-500">연락처</p>
        <p className="text-sm text-gray-700">{reservation.contactPhone || reservation.userPhone}</p>
      </div>

      {/* Cancel Info */}
      {reservation.status === 'CANCELLED' && reservation.cancelReason && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded">
          <p className="text-sm font-medium text-red-900">취소 사유</p>
          <p className="text-sm text-red-700">{reservation.cancelReason}</p>
          <p className="text-xs text-red-500 mt-1">
            취소일: {new Date(reservation.cancelledAt).toLocaleString()}
          </p>
        </div>
      )}

      {/* Actions */}
      <div className="flex justify-end space-x-2 border-t pt-4">
        {isOwner && reservation.status === 'PENDING' && (
          <button
            onClick={handleCancel}
            className="px-4 py-2 text-sm text-red-600 hover:text-red-800 border border-red-300 rounded-md hover:bg-red-50"
          >
            예약 취소
          </button>
        )}
        {isBusinessOwner && reservation.status === 'PENDING' && (
          <button
            onClick={handleConfirm}
            className="px-4 py-2 text-sm text-white bg-green-600 rounded-md hover:bg-green-700"
          >
            예약 확정
          </button>
        )}
      </div>

      {/* Created At */}
      <div className="mt-2 text-xs text-gray-400">
        예약일: {new Date(reservation.createdAt).toLocaleString()}
      </div>
    </div>
  );
};

export default ReservationCard;
