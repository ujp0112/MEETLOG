import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { restaurantAPI } from '../api/restaurant';

const RestaurantForm = () => {
  const { restaurantId } = useParams();
  const navigate = useNavigate();
  const isEdit = !!restaurantId;

  const [formData, setFormData] = useState({
    name: '',
    category: '한식',
    description: '',
    address: '',
    addressDetail: '',
    phone: '',
    operatingHours: '',
    priceRange: 2,
    menuInfo: '',
    facilities: '',
    parkingInfo: '',
    capacity: '',
    imageUrl: ''
  });

  const [imageFile, setImageFile] = useState(null);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [uploading, setUploading] = useState(false);

  const categories = [
    '한식', '중식', '일식', '양식', '분식', '카페', '디저트', '기타'
  ];

  useEffect(() => {
    if (isEdit) {
      fetchRestaurant();
    }
  }, [restaurantId]);

  const fetchRestaurant = async () => {
    try {
      const data = await restaurantAPI.getById(restaurantId);
      setFormData({
        name: data.name || '',
        category: data.category || '한식',
        description: data.description || '',
        address: data.address || '',
        addressDetail: data.addressDetail || '',
        phone: data.phone || '',
        operatingHours: data.operatingHours || '',
        priceRange: data.priceRange || 2,
        menuInfo: data.menuInfo || '',
        facilities: data.facilities || '',
        parkingInfo: data.parkingInfo || '',
        capacity: data.capacity || '',
        imageUrl: data.imageUrl || ''
      });
    } catch (err) {
      alert('레스토랑 정보를 불러오는데 실패했습니다.');
      navigate('/restaurants');
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
    setErrors({ ...errors, [name]: '' });
  };

  const handleImageChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
      alert('이미지 파일만 업로드 가능합니다.');
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      alert('파일 크기는 5MB 이하여야 합니다.');
      return;
    }

    setImageFile(file);
    setUploading(true);

    try {
      const imageUrl = await restaurantAPI.uploadImage(file);
      setFormData({
        ...formData,
        imageUrl
      });
    } catch (err) {
      alert('이미지 업로드에 실패했습니다.');
      setImageFile(null);
    } finally {
      setUploading(false);
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.name || formData.name.length < 2) {
      newErrors.name = '레스토랑 이름은 최소 2자 이상이어야 합니다.';
    }

    if (!formData.address) {
      newErrors.address = '주소는 필수입니다.';
    }

    const phoneRegex = /^\d{2,3}-\d{3,4}-\d{4}$/;
    if (formData.phone && !phoneRegex.test(formData.phone)) {
      newErrors.phone = '올바른 전화번호 형식이 아닙니다. (예: 02-1234-5678)';
    }

    if (formData.capacity && formData.capacity < 1) {
      newErrors.capacity = '수용 인원은 최소 1명 이상이어야 합니다.';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!validateForm()) {
      return;
    }

    setLoading(true);

    const submitData = {
      ...formData,
      capacity: formData.capacity ? parseInt(formData.capacity) : null,
      priceRange: parseInt(formData.priceRange)
    };

    try {
      if (isEdit) {
        await restaurantAPI.update(restaurantId, submitData);
        alert('레스토랑이 수정되었습니다.');
        navigate(`/restaurants/${restaurantId}`);
      } else {
        const result = await restaurantAPI.create(submitData);
        alert('레스토랑이 등록되었습니다.');
        navigate(`/restaurants/${result.restaurantId}`);
      }
    } catch (err) {
      alert(err.response?.data?.message || '저장에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-white shadow">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <h1 className="text-2xl font-bold text-gray-900">
            {isEdit ? '레스토랑 수정' : '레스토랑 등록'}
          </h1>
        </div>
      </div>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-6">
          {/* Image Upload */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              대표 이미지
            </label>
            <div className="flex items-center space-x-4">
              {formData.imageUrl && (
                <img
                  src={formData.imageUrl}
                  alt="Preview"
                  className="w-32 h-32 object-cover rounded-lg"
                />
              )}
              <div>
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleImageChange}
                  className="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                  disabled={uploading}
                />
                {uploading && <p className="text-sm text-gray-500 mt-1">업로드 중...</p>}
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Name */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                레스토랑 이름 *
              </label>
              <input
                type="text"
                name="name"
                required
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.name}
                onChange={handleChange}
              />
              {errors.name && <p className="mt-1 text-sm text-red-600">{errors.name}</p>}
            </div>

            {/* Category */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                카테고리 *
              </label>
              <select
                name="category"
                required
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.category}
                onChange={handleChange}
              >
                {categories.map(cat => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>
            </div>

            {/* Address */}
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                주소 *
              </label>
              <input
                type="text"
                name="address"
                required
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.address}
                onChange={handleChange}
              />
              {errors.address && <p className="mt-1 text-sm text-red-600">{errors.address}</p>}
            </div>

            {/* Address Detail */}
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                상세 주소
              </label>
              <input
                type="text"
                name="addressDetail"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.addressDetail}
                onChange={handleChange}
              />
            </div>

            {/* Phone */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                전화번호
              </label>
              <input
                type="tel"
                name="phone"
                placeholder="02-1234-5678"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.phone}
                onChange={handleChange}
              />
              {errors.phone && <p className="mt-1 text-sm text-red-600">{errors.phone}</p>}
            </div>

            {/* Price Range */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                가격대
              </label>
              <select
                name="priceRange"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.priceRange}
                onChange={handleChange}
              >
                <option value={1}>1만원 이하</option>
                <option value={2}>1-2만원</option>
                <option value={3}>2-3만원</option>
                <option value={4}>3만원 이상</option>
              </select>
            </div>

            {/* Capacity */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                수용 인원
              </label>
              <input
                type="number"
                name="capacity"
                min="1"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.capacity}
                onChange={handleChange}
              />
              {errors.capacity && <p className="mt-1 text-sm text-red-600">{errors.capacity}</p>}
            </div>

            {/* Operating Hours */}
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                영업시간
              </label>
              <textarea
                name="operatingHours"
                rows={3}
                placeholder="예: 평일 11:00-22:00&#10;주말 11:00-23:00"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.operatingHours}
                onChange={handleChange}
              />
            </div>

            {/* Description */}
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                설명
              </label>
              <textarea
                name="description"
                rows={4}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.description}
                onChange={handleChange}
              />
            </div>

            {/* Menu Info */}
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                메뉴 정보
              </label>
              <textarea
                name="menuInfo"
                rows={4}
                placeholder="메뉴와 가격을 입력하세요"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.menuInfo}
                onChange={handleChange}
              />
            </div>

            {/* Facilities */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                편의시설
              </label>
              <input
                type="text"
                name="facilities"
                placeholder="예: WiFi, 단체석, 포장"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.facilities}
                onChange={handleChange}
              />
            </div>

            {/* Parking Info */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                주차 정보
              </label>
              <input
                type="text"
                name="parkingInfo"
                placeholder="예: 주차 가능 (20대)"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                value={formData.parkingInfo}
                onChange={handleChange}
              />
            </div>
          </div>

          {/* Buttons */}
          <div className="mt-6 flex justify-end space-x-3">
            <button
              type="button"
              onClick={() => navigate(-1)}
              className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
            >
              취소
            </button>
            <button
              type="submit"
              disabled={loading || uploading}
              className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? '저장 중...' : isEdit ? '수정' : '등록'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default RestaurantForm;
