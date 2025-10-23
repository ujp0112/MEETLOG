import React, { useState } from 'react';
import { courseAPI } from '../../api/course';

const CourseForm = ({ course, onSuccess, onCancel }) => {
  const isEdit = !!course;

  const [formData, setFormData] = useState({
    title: course?.title || '',
    description: course?.description || '',
    area: course?.area || '',
    duration: course?.duration || '',
    price: course?.price || 0,
    maxParticipants: course?.maxParticipants || 0,
    type: course?.type || 'COMMUNITY',
    previewImage: course?.previewImage || '',
    steps: course?.steps || [],
    tags: course?.tags || []
  });

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // 태그 입력
  const [tagInput, setTagInput] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'price' || name === 'maxParticipants' ? parseInt(value) || 0 : value
    });
  };

  const handleAddTag = () => {
    if (tagInput.trim() && !formData.tags.includes(tagInput.trim())) {
      setFormData({
        ...formData,
        tags: [...formData.tags, tagInput.trim()]
      });
      setTagInput('');
    }
  };

  const handleRemoveTag = (tag) => {
    setFormData({
      ...formData,
      tags: formData.tags.filter(t => t !== tag)
    });
  };

  const handleAddStep = () => {
    const newStep = {
      stepOrder: formData.steps.length,
      stepType: '',
      emoji: '',
      name: '',
      latitude: null,
      longitude: null,
      address: '',
      description: '',
      image: '',
      time: 0,
      cost: 0
    };
    setFormData({
      ...formData,
      steps: [...formData.steps, newStep]
    });
  };

  const handleRemoveStep = (index) => {
    const newSteps = formData.steps.filter((_, i) => i !== index);
    // 순서 재정렬
    newSteps.forEach((step, i) => {
      step.stepOrder = i;
    });
    setFormData({
      ...formData,
      steps: newSteps
    });
  };

  const handleStepChange = (index, field, value) => {
    const newSteps = [...formData.steps];
    newSteps[index][field] = value;
    setFormData({
      ...formData,
      steps: newSteps
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (formData.steps.length === 0) {
      setError('최소 1개 이상의 코스 단계가 필요합니다.');
      return;
    }

    setLoading(true);
    try {
      if (isEdit) {
        await courseAPI.update(course.courseId, formData);
      } else {
        await courseAPI.create(formData);
      }
      if (onSuccess) onSuccess();
    } catch (err) {
      console.error('Failed to save course:', err);
      setError(err.response?.data?.message || '코스 저장에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-6 space-y-6">
      <h3 className="text-xl font-bold">{isEdit ? '코스 수정' : '새 코스 만들기'}</h3>

      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded">
          <p className="text-sm text-red-600">{error}</p>
        </div>
      )}

      {/* 기본 정보 */}
      <div className="space-y-4">
        <h4 className="font-semibold text-gray-700">기본 정보</h4>

        {/* 제목 */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            코스 제목 *
          </label>
          <input
            type="text"
            name="title"
            value={formData.title}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            required
          />
        </div>

        {/* 설명 */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            설명
          </label>
          <textarea
            name="description"
            value={formData.description}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            rows="3"
          />
        </div>

        {/* 지역 & 소요 시간 */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              지역
            </label>
            <input
              type="text"
              name="area"
              value={formData.area}
              onChange={handleChange}
              placeholder="예: 강남구"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              소요 시간
            </label>
            <input
              type="text"
              name="duration"
              value={formData.duration}
              onChange={handleChange}
              placeholder="예: 3시간"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>

        {/* 가격 & 최대 참가자 */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              가격 (원)
            </label>
            <input
              type="number"
              name="price"
              value={formData.price}
              onChange={handleChange}
              min="0"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              최대 참가자 수
            </label>
            <input
              type="number"
              name="maxParticipants"
              value={formData.maxParticipants}
              onChange={handleChange}
              min="0"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>

        {/* 타입 */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            타입 *
          </label>
          <select
            name="type"
            value={formData.type}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            required
          >
            <option value="COMMUNITY">커뮤니티</option>
            <option value="OFFICIAL">공식</option>
          </select>
        </div>

        {/* 태그 */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            태그
          </label>
          <div className="flex gap-2 mb-2">
            <input
              type="text"
              value={tagInput}
              onChange={(e) => setTagInput(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && (e.preventDefault(), handleAddTag())}
              placeholder="태그 입력 후 추가 버튼 클릭"
              className="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            />
            <button
              type="button"
              onClick={handleAddTag}
              className="px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700"
            >
              추가
            </button>
          </div>
          <div className="flex flex-wrap gap-2">
            {formData.tags.map((tag, index) => (
              <span
                key={index}
                className="inline-flex items-center px-3 py-1 rounded-full text-sm bg-blue-100 text-blue-800"
              >
                {tag}
                <button
                  type="button"
                  onClick={() => handleRemoveTag(tag)}
                  className="ml-2 text-blue-600 hover:text-blue-800"
                >
                  ×
                </button>
              </span>
            ))}
          </div>
        </div>
      </div>

      {/* 코스 단계 */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h4 className="font-semibold text-gray-700">코스 단계 *</h4>
          <button
            type="button"
            onClick={handleAddStep}
            className="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700"
          >
            + 단계 추가
          </button>
        </div>

        {formData.steps.map((step, index) => (
          <div key={index} className="border border-gray-300 rounded-lg p-4 space-y-3">
            <div className="flex items-center justify-between">
              <h5 className="font-medium text-gray-700">단계 {index + 1}</h5>
              <button
                type="button"
                onClick={() => handleRemoveStep(index)}
                className="text-red-600 hover:text-red-800 text-sm"
              >
                삭제
              </button>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-xs text-gray-600 mb-1">장소명 *</label>
                <input
                  type="text"
                  value={step.name}
                  onChange={(e) => handleStepChange(index, 'name', e.target.value)}
                  className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                  required
                />
              </div>
              <div>
                <label className="block text-xs text-gray-600 mb-1">이모지</label>
                <input
                  type="text"
                  value={step.emoji}
                  onChange={(e) => handleStepChange(index, 'emoji', e.target.value)}
                  className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                  placeholder="🍔"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-xs text-gray-600 mb-1">위도 *</label>
                <input
                  type="number"
                  step="0.000001"
                  value={step.latitude || ''}
                  onChange={(e) => handleStepChange(index, 'latitude', parseFloat(e.target.value))}
                  className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                  required
                />
              </div>
              <div>
                <label className="block text-xs text-gray-600 mb-1">경도 *</label>
                <input
                  type="number"
                  step="0.000001"
                  value={step.longitude || ''}
                  onChange={(e) => handleStepChange(index, 'longitude', parseFloat(e.target.value))}
                  className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-xs text-gray-600 mb-1">주소</label>
              <input
                type="text"
                value={step.address}
                onChange={(e) => handleStepChange(index, 'address', e.target.value)}
                className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
              />
            </div>

            <div>
              <label className="block text-xs text-gray-600 mb-1">설명</label>
              <textarea
                value={step.description}
                onChange={(e) => handleStepChange(index, 'description', e.target.value)}
                className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                rows="2"
              />
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-xs text-gray-600 mb-1">소요 시간 (분)</label>
                <input
                  type="number"
                  value={step.time}
                  onChange={(e) => handleStepChange(index, 'time', parseInt(e.target.value) || 0)}
                  min="0"
                  className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                />
              </div>
              <div>
                <label className="block text-xs text-gray-600 mb-1">예상 비용 (원)</label>
                <input
                  type="number"
                  value={step.cost}
                  onChange={(e) => handleStepChange(index, 'cost', parseInt(e.target.value) || 0)}
                  min="0"
                  className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                />
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* 버튼 */}
      <div className="flex justify-end space-x-3 pt-4 border-t">
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
          disabled={loading}
          className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? '저장 중...' : isEdit ? '수정하기' : '생성하기'}
        </button>
      </div>
    </form>
  );
};

export default CourseForm;
