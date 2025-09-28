<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${restaurant.name} 예약 설정 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Flatpickr for date picker -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
    <!-- Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        .gradient-text {
            background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .slide-up {
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .toggle-switch {
            appearance: none;
            width: 48px;
            height: 24px;
            background: #cbd5e1;
            border-radius: 12px;
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .toggle-switch:checked {
            background: #3b82f6;
        }
        .toggle-switch::before {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: white;
            top: 2px;
            left: 2px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        .toggle-switch:checked::before {
            transform: translateX(24px);
        }
        .time-slot {
            transition: all 0.2s ease;
        }
        .time-slot:hover {
            transform: scale(1.05);
        }
        .time-slot.selected {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }
        .flatpickr-calendar {
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border-radius: 12px;
            border: none;
        }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container mx-auto p-4 md:p-8 max-w-6xl">
        <!-- 헤더 -->
        <div class="glass-card p-6 rounded-2xl mb-6 slide-up">
            <div class="flex items-center gap-3 mb-4">
                <a href="${pageContext.request.contextPath}/business/restaurants"
                   class="text-slate-500 hover:text-sky-600 transition-colors flex items-center gap-2">
                    <i class="fas fa-arrow-left"></i> 내 음식점 관리
                </a>
            </div>
            <div class="flex items-center gap-4 mb-4">
                <div class="w-16 h-16 rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white text-2xl">
                    <i class="fas fa-utensils"></i>
                </div>
                <div>
                    <h1 class="text-3xl font-bold gradient-text">${restaurant.name}</h1>
                    <p class="text-slate-600">예약 시스템 설정</p>
                </div>
            </div>
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <div class="flex items-center gap-2 text-blue-800">
                    <i class="fas fa-info-circle"></i>
                    <span class="font-semibold">알림</span>
                </div>
                <p class="text-blue-700 mt-1">고객이 온라인으로 예약할 수 있도록 상세한 설정을 구성해보세요. 설정 후 바로 적용됩니다.</p>
            </div>
        </div>

        <form id="reservationSettingsForm" action="${pageContext.request.contextPath}/reservation-settings/${restaurant.id}/save" method="post">

            <!-- Hidden inputs to ensure all day time values are always sent -->
            <input type="hidden" name="mondayStart" value="${reservationSettings.mondayStart != null ? reservationSettings.mondayStart : '09:00'}">
            <input type="hidden" name="mondayEnd" value="${reservationSettings.mondayEnd != null ? reservationSettings.mondayEnd : '22:00'}">
            <input type="hidden" name="tuesdayStart" value="${reservationSettings.tuesdayStart != null ? reservationSettings.tuesdayStart : '09:00'}">
            <input type="hidden" name="tuesdayEnd" value="${reservationSettings.tuesdayEnd != null ? reservationSettings.tuesdayEnd : '22:00'}">
            <input type="hidden" name="wednesdayStart" value="${reservationSettings.wednesdayStart != null ? reservationSettings.wednesdayStart : '09:00'}">
            <input type="hidden" name="wednesdayEnd" value="${reservationSettings.wednesdayEnd != null ? reservationSettings.wednesdayEnd : '22:00'}">
            <input type="hidden" name="thursdayStart" value="${reservationSettings.thursdayStart != null ? reservationSettings.thursdayStart : '09:00'}">
            <input type="hidden" name="thursdayEnd" value="${reservationSettings.thursdayEnd != null ? reservationSettings.thursdayEnd : '22:00'}">
            <input type="hidden" name="fridayStart" value="${reservationSettings.fridayStart != null ? reservationSettings.fridayStart : '09:00'}">
            <input type="hidden" name="fridayEnd" value="${reservationSettings.fridayEnd != null ? reservationSettings.fridayEnd : '22:00'}">
            <input type="hidden" name="saturdayStart" value="${reservationSettings.saturdayStart != null ? reservationSettings.saturdayStart : '09:00'}">
            <input type="hidden" name="saturdayEnd" value="${reservationSettings.saturdayEnd != null ? reservationSettings.saturdayEnd : '22:00'}">
            <input type="hidden" name="sundayStart" value="${reservationSettings.sundayStart != null ? reservationSettings.sundayStart : '09:00'}">
            <input type="hidden" name="sundayEnd" value="${reservationSettings.sundayEnd != null ? reservationSettings.sundayEnd : '22:00'}">

            <!-- 기본 설정 -->
            <div class="glass-card p-6 rounded-2xl mb-6 slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
                    <i class="fas fa-toggle-on text-blue-500"></i>
                    기본 설정
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- 예약 활성화 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <i class="fas fa-calendar-check text-green-500 text-xl"></i>
                                <div>
                                    <h3 class="font-semibold text-slate-800">예약 시스템 활성화</h3>
                                    <p class="text-sm text-slate-600">고객이 온라인으로 예약할 수 있습니다</p>
                                </div>
                            </div>
                            <input type="checkbox" name="reservationEnabled" class="toggle-switch"
                                   ${reservationSettings.reservationEnabled ? 'checked' : ''}>
                        </div>
                    </div>

                    <!-- 자동 승인 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <i class="fas fa-check-circle text-blue-500 text-xl"></i>
                                <div>
                                    <h3 class="font-semibold text-slate-800">예약 자동 승인</h3>
                                    <p class="text-sm text-slate-600">예약 요청을 자동으로 승인합니다</p>
                                </div>
                            </div>
                            <input type="checkbox" name="autoAccept" class="toggle-switch"
                                   ${reservationSettings.autoAccept ? 'checked' : ''}>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 예약 조건 설정 -->
            <div class="glass-card p-6 rounded-2xl mb-6 slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
                    <i class="fas fa-users text-purple-500"></i>
                    예약 조건 설정
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- 최소 인원 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <label class="block text-sm font-semibold text-slate-700 mb-3">
                            <i class="fas fa-user-minus text-orange-500 mr-2"></i>
                            최소 예약 인원
                        </label>
                        <input type="number" name="minPartySize" min="1" max="20"
                               value="${reservationSettings.minPartySize != null ? reservationSettings.minPartySize : 1}"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <p class="text-xs text-slate-500 mt-2">명 이상 예약 가능</p>
                    </div>

                    <!-- 최대 인원 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <label class="block text-sm font-semibold text-slate-700 mb-3">
                            <i class="fas fa-user-plus text-green-500 mr-2"></i>
                            최대 예약 인원
                        </label>
                        <input type="number" name="maxPartySize" min="1" max="50"
                               value="${reservationSettings.maxPartySize != null ? reservationSettings.maxPartySize : 10}"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <p class="text-xs text-slate-500 mt-2">명 이하 예약 가능</p>
                    </div>

                    <!-- 예약 가능 일수 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <label class="block text-sm font-semibold text-slate-700 mb-3">
                            <i class="fas fa-calendar-alt text-blue-500 mr-2"></i>
                            예약 가능 기간
                        </label>
                        <input type="number" name="advanceBookingDays" min="1" max="365"
                               value="${reservationSettings.advanceBookingDays != null ? reservationSettings.advanceBookingDays : 30}"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <p class="text-xs text-slate-500 mt-2">일 전까지 예약 가능</p>
                    </div>

                    <!-- 최소 예약 시간 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <label class="block text-sm font-semibold text-slate-700 mb-3">
                            <i class="fas fa-clock text-red-500 mr-2"></i>
                            최소 예약 시간
                        </label>
                        <input type="number" name="minAdvanceHours" min="1" max="72"
                               value="${reservationSettings.minAdvanceHours != null ? reservationSettings.minAdvanceHours : 2}"
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <p class="text-xs text-slate-500 mt-2">시간 전까지 예약 가능</p>
                    </div>
                </div>
            </div>

            <!-- 운영 시간 설정 -->
            <div class="glass-card p-6 rounded-2xl mb-6 slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
                    <i class="fas fa-business-time text-indigo-500"></i>
                    요일별 운영 시간
                </h2>

                <div class="space-y-4">
                    <!-- 월요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-red-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    월
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">월요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="mondayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.mondayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.mondayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="mondayStartVisible"
                                       value="${reservationSettings.mondayStart != null ? reservationSettings.mondayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=mondayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="mondayEndVisible"
                                       value="${reservationSettings.mondayEnd != null ? reservationSettings.mondayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=mondayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>

                    <!-- 화요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-orange-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    화
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">화요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="tuesdayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.tuesdayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.tuesdayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="tuesdayStartVisible"
                                       value="${reservationSettings.tuesdayStart != null ? reservationSettings.tuesdayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=tuesdayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="tuesdayEndVisible"
                                       value="${reservationSettings.tuesdayEnd != null ? reservationSettings.tuesdayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=tuesdayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>

                    <!-- 수요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-yellow-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    수
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">수요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="wednesdayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.wednesdayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.wednesdayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="wednesdayStartVisible"
                                       value="${reservationSettings.wednesdayStart != null ? reservationSettings.wednesdayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=wednesdayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="wednesdayEndVisible"
                                       value="${reservationSettings.wednesdayEnd != null ? reservationSettings.wednesdayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=wednesdayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>

                    <!-- 목요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-green-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    목
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">목요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="thursdayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.thursdayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.thursdayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="thursdayStartVisible"
                                       value="${reservationSettings.thursdayStart != null ? reservationSettings.thursdayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=thursdayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="thursdayEndVisible"
                                       value="${reservationSettings.thursdayEnd != null ? reservationSettings.thursdayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=thursdayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>

                    <!-- 금요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    금
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">금요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="fridayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.fridayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.fridayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="fridayStartVisible"
                                       value="${reservationSettings.fridayStart != null ? reservationSettings.fridayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=fridayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="fridayEndVisible"
                                       value="${reservationSettings.fridayEnd != null ? reservationSettings.fridayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=fridayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>

                    <!-- 토요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-indigo-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    토
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">토요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="saturdayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.saturdayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.saturdayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="saturdayStartVisible"
                                       value="${reservationSettings.saturdayStart != null ? reservationSettings.saturdayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=saturdayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="saturdayEndVisible"
                                       value="${reservationSettings.saturdayEnd != null ? reservationSettings.saturdayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=saturdayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>

                    <!-- 일요일 -->
                    <div class="bg-white p-6 rounded-xl border border-slate-200">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-purple-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    일
                                </div>
                                <div>
                                    <h3 class="font-semibold text-slate-800">일요일</h3>
                                    <p class="text-sm text-slate-600">영업일 설정 및 운영 시간</p>
                                </div>
                            </div>
                            <input type="checkbox" name="sundayEnabled" class="toggle-switch day-toggle"
                                   ${reservationSettings.sundayEnabled ? 'checked' : ''}>
                        </div>

                        <div class="grid grid-cols-2 gap-4 day-times" style="display: ${reservationSettings.sundayEnabled ? 'grid' : 'none'}">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                <input type="time" name="sundayStartVisible"
                                       value="${reservationSettings.sundayStart != null ? reservationSettings.sundayStart : '09:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=sundayStart]').value = this.value">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                <input type="time" name="sundayEndVisible"
                                       value="${reservationSettings.sundayEnd != null ? reservationSettings.sundayEnd : '22:00'}"
                                       class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                       onchange="document.querySelector('input[name=sundayEnd]').value = this.value">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 예약 불가 날짜 설정 -->
            <div class="glass-card p-6 rounded-2xl mb-6 slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
                    <i class="fas fa-calendar-times text-red-500"></i>
                    예약 불가 날짜 설정
                </h2>

                <div class="bg-white p-6 rounded-xl border border-slate-200">
                    <div class="mb-4">
                        <label class="block text-sm font-semibold text-slate-700 mb-3">
                            <i class="fas fa-ban text-red-500 mr-2"></i>
                            휴무일 또는 특별한 날짜 선택
                        </label>
                        <p class="text-sm text-slate-600 mb-4">여러 날짜를 선택할 수 있습니다. 선택된 날짜는 예약이 불가능합니다.</p>
                        <input type="text" id="blackoutDates" name="blackoutDates" placeholder="날짜를 선택하세요..." readonly
                               class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 cursor-pointer"
                               value="${reservationSettings.blackoutDates != null ? reservationSettings.blackoutDates : ''}">
                    </div>
                    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                        <div class="flex items-center gap-2 text-yellow-800">
                            <i class="fas fa-lightbulb"></i>
                            <span class="font-semibold">팁</span>
                        </div>
                        <p class="text-yellow-700 text-sm mt-1">정기 휴무일이나 특별 행사로 인한 휴무일을 미리 설정하면 고객 혼란을 방지할 수 있습니다.</p>
                    </div>
                </div>
            </div>

            <!-- 특별 안내사항 -->
            <div class="glass-card p-6 rounded-2xl mb-6 slide-up">
                <h2 class="text-2xl font-bold gradient-text mb-6 flex items-center gap-3">
                    <i class="fas fa-comment-alt text-teal-500"></i>
                    특별 안내사항
                </h2>

                <div class="bg-white p-6 rounded-xl border border-slate-200">
                    <label class="block text-sm font-semibold text-slate-700 mb-3">
                        <i class="fas fa-pen text-teal-500 mr-2"></i>
                        고객에게 전달할 메시지
                    </label>
                    <textarea name="specialNotes" rows="4" placeholder="예약 시 고객에게 안내할 특별한 사항을 입력하세요. (예: 주차 안내, 복장 규정, 특별 요청사항 등)"
                              class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 resize-none">${reservationSettings.specialNotes != null ? reservationSettings.specialNotes : ''}</textarea>
                    <p class="text-xs text-slate-500 mt-2">이 메시지는 예약 확인 시 고객에게 표시됩니다.</p>
                </div>
            </div>

            <!-- 저장 버튼 -->
            <div class="flex justify-center">
                <button type="submit" class="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center gap-3">
                    <i class="fas fa-save"></i>
                    설정 저장하기
                </button>
            </div>
        </form>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        // JSP 변수를 JavaScript로 전달
        var contextPath = '${pageContext.request.contextPath}';
        var restaurantId = '${restaurant.id}';

        // 요일별 토글 처리
        document.addEventListener('DOMContentLoaded', function() {
            const dayToggles = document.querySelectorAll('.day-toggle');

            dayToggles.forEach(toggle => {
                toggle.addEventListener('change', function() {
                    const dayTimes = this.closest('.bg-white').querySelector('.day-times');
                    if (this.checked) {
                        dayTimes.style.display = 'grid';
                    } else {
                        dayTimes.style.display = 'none';
                    }
                });
            });

            // 블랙아웃 날짜 달력 설정
            flatpickr("#blackoutDates", {
                mode: "multiple",
                dateFormat: "Y-m-d",
                locale: "ko",
                minDate: "today",
                inline: false,
                altInput: true,
                altFormat: "Y년 m월 d일",
                allowInput: false,
                clickOpens: true,
                appendTo: document.body,
                onChange: function(selectedDates, dateStr, instance) {
                    console.log("Selected dates:", dateStr);
                }
            });
        });

        // 폼 제출 처리 - 수정된 버전
        document.getElementById('reservationSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();

            console.log('폼 제출 시작');

            // 체크박스 상태 직접 확인
            console.log('=== 직접 체크박스 상태 확인 ===');
            const mondayCheckbox = document.querySelector('input[name="mondayEnabled"]');
            const tuesdayCheckbox = document.querySelector('input[name="tuesdayEnabled"]');
            console.log('월요일 체크박스:', mondayCheckbox, '체크 상태:', mondayCheckbox ? mondayCheckbox.checked : 'not found');
            console.log('화요일 체크박스:', tuesdayCheckbox, '체크 상태:', tuesdayCheckbox ? tuesdayCheckbox.checked : 'not found');

            // 시간 필드 직접 확인
            console.log('=== 시간 필드 직접 확인 ===');
            const mondayStartVisible = document.querySelector('input[name="mondayStartVisible"]');
            const mondayEndVisible = document.querySelector('input[name="mondayEndVisible"]');
            const tuesdayStartVisible = document.querySelector('input[name="tuesdayStartVisible"]');
            const tuesdayEndVisible = document.querySelector('input[name="tuesdayEndVisible"]');

            console.log('월요일 시작:', mondayStartVisible ? mondayStartVisible.value : 'not found');
            console.log('월요일 종료:', mondayEndVisible ? mondayEndVisible.value : 'not found');
            console.log('화요일 시작:', tuesdayStartVisible ? tuesdayStartVisible.value : 'not found');
            console.log('화요일 종료:', tuesdayEndVisible ? tuesdayEndVisible.value : 'not found');

            // 폼 데이터를 직접 수집
            const formData = new FormData();

            // 기본 설정들
            const reservationEnabled = document.querySelector('input[name="reservationEnabled"]');
            const autoAccept = document.querySelector('input[name="autoAccept"]');

            formData.append('reservationEnabled', reservationEnabled ? reservationEnabled.checked.toString() : 'false');
            formData.append('autoAccept', autoAccept ? autoAccept.checked.toString() : 'false');

            console.log('기본 설정:', {
                reservationEnabled: reservationEnabled ? reservationEnabled.checked : false,
                autoAccept: autoAccept ? autoAccept.checked : false
            });

            // 요일별 설정 직접 수집
            const dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

            // 먼저 보이는 필드에서 숨겨진 필드로 값 복사
            dayNames.forEach(day => {
                const visibleStart = document.querySelector(`input[name="${day}StartVisible"]`);
                const visibleEnd = document.querySelector(`input[name="${day}EndVisible"]`);
                const hiddenStart = document.querySelector(`input[name="${day}Start"]`);
                const hiddenEnd = document.querySelector(`input[name="${day}End"]`);

                // 보이는 필드가 있고 값이 있으면 숨겨진 필드에 복사
                if (visibleStart && visibleStart.value && hiddenStart) {
                    hiddenStart.value = visibleStart.value;
                    console.log(`${day} 시작 시간 업데이트: ${visibleStart.value}`);
                }
                if (visibleEnd && visibleEnd.value && hiddenEnd) {
                    hiddenEnd.value = visibleEnd.value;
                    console.log(`${day} 종료 시간 업데이트: ${visibleEnd.value}`);
                }
            });

            // 요일별 데이터 수집
            dayNames.forEach(day => {
                const dayEnabled = document.querySelector(`input[name="${day}Enabled"]`);
                const hiddenStart = document.querySelector(`input[name="${day}Start"]`);
                const hiddenEnd = document.querySelector(`input[name="${day}End"]`);

                const enabledValue = dayEnabled ? dayEnabled.checked.toString() : 'false';
                const startValue = hiddenStart ? hiddenStart.value : '09:00';
                const endValue = hiddenEnd ? hiddenEnd.value : '22:00';

                formData.append(day + 'Enabled', enabledValue);
                formData.append(day + 'Start', startValue);
                formData.append(day + 'End', endValue);

                console.log(`${day}:`, {
                    enabled: enabledValue,
                    start: startValue,
                    end: endValue
                });
            });

            // 기타 설정들
            const minPartySize = document.querySelector('input[name="minPartySize"]');
            const maxPartySize = document.querySelector('input[name="maxPartySize"]');
            const advanceBookingDays = document.querySelector('input[name="advanceBookingDays"]');
            const minAdvanceHours = document.querySelector('input[name="minAdvanceHours"]');
            const specialNotes = document.querySelector('textarea[name="specialNotes"]');
            const blackoutDates = document.querySelector('input[name="blackoutDates"]');

            if (minPartySize) formData.append('minPartySize', minPartySize.value || '1');
            if (maxPartySize) formData.append('maxPartySize', maxPartySize.value || '10');
            if (advanceBookingDays) formData.append('advanceBookingDays', advanceBookingDays.value || '30');
            if (minAdvanceHours) formData.append('minAdvanceHours', minAdvanceHours.value || '2');
            if (specialNotes) formData.append('specialNotes', specialNotes.value || '');
            if (blackoutDates) formData.append('blackoutDates', blackoutDates.value || '');

            // FormData 크기 확인
            console.log('FormData 항목 수:', Array.from(formData.entries()).length);

            // 전송할 데이터 확인
            console.log('=== 전송할 데이터 ===');
            let count = 0;
            for (let [key, value] of formData.entries()) {
                console.log(`${key}: ${value}`);
                count++;
            }
            console.log(`총 ${count}개 항목 전송`);

            // FormData를 무조건 URLSearchParams로 대체 (FormData 파라미터 인식 불가 문제)
            if (true) {
                console.log('FormData가 비어있음, URLSearchParams로 대체');
                const params = new URLSearchParams();

                params.append('reservationEnabled', reservationEnabled ? reservationEnabled.checked.toString() : 'false');
                params.append('autoAccept', autoAccept ? autoAccept.checked.toString() : 'false');

                // 요일별 체크박스 직접 처리
                params.append('mondayEnabled', mondayCheckbox ? mondayCheckbox.checked.toString() : 'false');
                params.append('tuesdayEnabled', tuesdayCheckbox ? tuesdayCheckbox.checked.toString() : 'false');

                // 나머지 요일들
                const wednesdayCheckbox = document.querySelector('input[name="wednesdayEnabled"]');
                const thursdayCheckbox = document.querySelector('input[name="thursdayEnabled"]');
                const fridayCheckbox = document.querySelector('input[name="fridayEnabled"]');
                const saturdayCheckbox = document.querySelector('input[name="saturdayEnabled"]');
                const sundayCheckbox = document.querySelector('input[name="sundayEnabled"]');

                params.append('wednesdayEnabled', wednesdayCheckbox ? wednesdayCheckbox.checked.toString() : 'false');
                params.append('thursdayEnabled', thursdayCheckbox ? thursdayCheckbox.checked.toString() : 'false');
                params.append('fridayEnabled', fridayCheckbox ? fridayCheckbox.checked.toString() : 'false');
                params.append('saturdayEnabled', saturdayCheckbox ? saturdayCheckbox.checked.toString() : 'false');
                params.append('sundayEnabled', sundayCheckbox ? sundayCheckbox.checked.toString() : 'false');

                // 시간 설정들 - 앞서 찾은 요소들 재사용
                params.append('mondayStart', mondayStartVisible ? mondayStartVisible.value : '09:00');
                params.append('mondayEnd', mondayEndVisible ? mondayEndVisible.value : '22:00');
                params.append('tuesdayStart', tuesdayStartVisible ? tuesdayStartVisible.value : '09:00');
                params.append('tuesdayEnd', tuesdayEndVisible ? tuesdayEndVisible.value : '22:00');

                // 나머지 요일들 (체크 안 된 요일들은 기본값)
                const wednesdayStartVisible = document.querySelector('input[name="wednesdayStartVisible"]');
                const wednesdayEndVisible = document.querySelector('input[name="wednesdayEndVisible"]');
                const thursdayStartVisible = document.querySelector('input[name="thursdayStartVisible"]');
                const thursdayEndVisible = document.querySelector('input[name="thursdayEndVisible"]');
                const fridayStartVisible = document.querySelector('input[name="fridayStartVisible"]');
                const fridayEndVisible = document.querySelector('input[name="fridayEndVisible"]');
                const saturdayStartVisible = document.querySelector('input[name="saturdayStartVisible"]');
                const saturdayEndVisible = document.querySelector('input[name="saturdayEndVisible"]');
                const sundayStartVisible = document.querySelector('input[name="sundayStartVisible"]');
                const sundayEndVisible = document.querySelector('input[name="sundayEndVisible"]');

                params.append('wednesdayStart', wednesdayStartVisible ? wednesdayStartVisible.value : '09:00');
                params.append('wednesdayEnd', wednesdayEndVisible ? wednesdayEndVisible.value : '22:00');
                params.append('thursdayStart', thursdayStartVisible ? thursdayStartVisible.value : '09:00');
                params.append('thursdayEnd', thursdayEndVisible ? thursdayEndVisible.value : '22:00');
                params.append('fridayStart', fridayStartVisible ? fridayStartVisible.value : '09:00');
                params.append('fridayEnd', fridayEndVisible ? fridayEndVisible.value : '22:00');
                params.append('saturdayStart', saturdayStartVisible ? saturdayStartVisible.value : '09:00');
                params.append('saturdayEnd', saturdayEndVisible ? saturdayEndVisible.value : '22:00');
                params.append('sundayStart', sundayStartVisible ? sundayStartVisible.value : '09:00');
                params.append('sundayEnd', sundayEndVisible ? sundayEndVisible.value : '22:00');

                console.log('시간 값 확인:', {
                    mondayEnd: mondayEndVisible ? mondayEndVisible.value : 'not found',
                    tuesdayEnd: tuesdayEndVisible ? tuesdayEndVisible.value : 'not found'
                });

                // 기타 설정들
                const minPartySize = document.querySelector('input[name="minPartySize"]');
                const maxPartySize = document.querySelector('input[name="maxPartySize"]');
                const advanceBookingDays = document.querySelector('input[name="advanceBookingDays"]');
                const minAdvanceHours = document.querySelector('input[name="minAdvanceHours"]');
                const specialNotes = document.querySelector('textarea[name="specialNotes"]');
                const blackoutDates = document.querySelector('input[name="blackoutDates"]');

                if (minPartySize) params.append('minPartySize', minPartySize.value || '1');
                if (maxPartySize) params.append('maxPartySize', maxPartySize.value || '10');
                if (advanceBookingDays) params.append('advanceBookingDays', advanceBookingDays.value || '30');
                if (minAdvanceHours) params.append('minAdvanceHours', minAdvanceHours.value || '2');
                if (specialNotes) params.append('specialNotes', specialNotes.value || '');
                if (blackoutDates) params.append('blackoutDates', blackoutDates.value || '');

                console.log('URLSearchParams 데이터:', params.toString());

                // 버튼 상태 관리
                const submitBtn = this.querySelector('button[type="submit"]');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>저장 중...';
                submitBtn.disabled = true;

                // URLSearchParams로 전송
                fetch(contextPath + '/reservation-settings/' + restaurantId + '/save', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('success', '예약 설정이 성공적으로 저장되었습니다!');
                    } else {
                        showNotification('error', '설정 저장 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('error', '네트워크 오류로 저장에 실패했습니다.');
                })
                .finally(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                });
                return; // FormData 전송을 건너뜀
            }

            // 로딩 상태 표시
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>저장 중...';
            submitBtn.disabled = true;

            fetch(contextPath + '/reservation-settings/' + restaurantId + '/save', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('success', '예약 설정이 성공적으로 저장되었습니다!');
                } else {
                    showNotification('error', '설정 저장 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('error', '네트워크 오류로 저장에 실패했습니다.');
            })
            .finally(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });

        // 알림 표시 함수
        function showNotification(type, message) {
            const notification = document.createElement('div');
            const baseClasses = 'fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transform transition-all duration-300';
            const typeClasses = type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white';
            notification.className = baseClasses + ' ' + typeClasses;

            const iconClass = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
            notification.innerHTML =
                '<div class="flex items-center gap-3">' +
                    '<i class="fas ' + iconClass + '"></i>' +
                    '<span>' + message + '</span>' +
                '</div>';

            document.body.appendChild(notification);

            // 애니메이션
            setTimeout(() => notification.classList.add('translate-x-0'), 100);

            // 3초 후 제거
            setTimeout(() => {
                notification.classList.add('translate-x-full');
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }
    </script>
</body>
</html>