<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 설정 - MEET LOG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Noto Sans KR', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); min-height: 100vh; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .gradient-text { background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .btn-primary { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .slide-up { animation: slideUp 0.8s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .toggle-switch { position: relative; display: inline-block; width: 60px; height: 34px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 34px; }
        .slider:before { position: absolute; content: ""; height: 26px; width: 26px; left: 4px; bottom: 4px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: #3b82f6; }
        input:checked + .slider:before { transform: translateX(26px); }
    </style>
</head>
<body class="bg-slate-100">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="container mx-auto p-4 md:p-8">
        <div class="space-y-8">
            <!-- 헤더 섹션 -->
            <div class="glass-card p-8 rounded-3xl fade-in">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-4xl font-bold gradient-text mb-2">예약 설정</h1>
                        <p class="text-slate-600">고객의 온라인 예약을 효율적으로 관리하세요</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-slate-500">음식점: <strong>${restaurant.name}</strong></p>
                        <p class="text-sm text-slate-500">위치: ${restaurant.location}</p>
                    </div>
                </div>
            </div>
            
            <form action="${pageContext.request.contextPath}/reservation-settings" method="post">
                <input type="hidden" name="restaurantId" value="${restaurant.id}">
                
                <!-- 기본 설정 -->
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <h2 class="text-2xl font-bold gradient-text mb-6">기본 예약 설정</h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- 자동 승인 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-3">
                                <label class="text-lg font-semibold text-slate-800">자동 승인</label>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="autoAccept" value="true" ${settings.autoAccept ? 'checked' : ''}>
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <p class="text-sm text-slate-600">예약 요청을 자동으로 승인합니다. 비활성화 시 수동 승인이 필요합니다.</p>
                        </div>
                        
                        <!-- 최대 예약 가능 일수 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <label class="block text-lg font-semibold text-slate-800 mb-3">최대 예약 가능 일수</label>
                            <select name="maxAdvanceDays" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="7" ${settings.maxAdvanceDays == 7 ? 'selected' : ''}>7일</option>
                                <option value="14" ${settings.maxAdvanceDays == 14 ? 'selected' : ''}>14일</option>
                                <option value="30" ${settings.maxAdvanceDays == 30 ? 'selected' : ''}>30일</option>
                                <option value="60" ${settings.maxAdvanceDays == 60 ? 'selected' : ''}>60일</option>
                                <option value="90" ${settings.maxAdvanceDays == 90 ? 'selected' : ''}>90일</option>
                            </select>
                            <p class="text-sm text-slate-600 mt-2">고객이 미리 예약할 수 있는 최대 기간</p>
                        </div>
                        
                        <!-- 최소 예약 시간 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <label class="block text-lg font-semibold text-slate-800 mb-3">최소 예약 시간</label>
                            <select name="minAdvanceHours" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="1" ${settings.minAdvanceHours == 1 ? 'selected' : ''}>1시간 전</option>
                                <option value="2" ${settings.minAdvanceHours == 2 ? 'selected' : ''}>2시간 전</option>
                                <option value="4" ${settings.minAdvanceHours == 4 ? 'selected' : ''}>4시간 전</option>
                                <option value="24" ${settings.minAdvanceHours == 24 ? 'selected' : ''}>하루 전</option>
                            </select>
                            <p class="text-sm text-slate-600 mt-2">예약 가능한 최소 시간</p>
                        </div>
                        
                        <!-- 최대 인원수 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <label class="block text-lg font-semibold text-slate-800 mb-3">최대 인원수</label>
                            <select name="maxPartySize" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="2" ${settings.maxPartySize == 2 ? 'selected' : ''}>2명</option>
                                <option value="4" ${settings.maxPartySize == 4 ? 'selected' : ''}>4명</option>
                                <option value="6" ${settings.maxPartySize == 6 ? 'selected' : ''}>6명</option>
                                <option value="8" ${settings.maxPartySize == 8 ? 'selected' : ''}>8명</option>
                                <option value="10" ${settings.maxPartySize == 10 ? 'selected' : ''}>10명</option>
                                <option value="12" ${settings.maxPartySize == 12 ? 'selected' : ''}>12명</option>
                            </select>
                            <p class="text-sm text-slate-600 mt-2">온라인 예약 가능한 최대 인원</p>
                        </div>
                        
                        <!-- 시간 간격 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <label class="block text-lg font-semibold text-slate-800 mb-3">예약 시간 간격</label>
                            <select name="timeSlotInterval" class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="15" ${settings.timeSlotInterval == 15 ? 'selected' : ''}>15분</option>
                                <option value="30" ${settings.timeSlotInterval == 30 ? 'selected' : ''}>30분</option>
                                <option value="60" ${settings.timeSlotInterval == 60 ? 'selected' : ''}>1시간</option>
                            </select>
                            <p class="text-sm text-slate-600 mt-2">예약 시간대 간격</p>
                        </div>
                        
                        <!-- 특별 안내사항 -->
                        <div class="bg-white p-6 rounded-2xl md:col-span-2">
                            <label class="block text-lg font-semibold text-slate-800 mb-3">특별 안내사항</label>
                            <textarea name="specialInstructions" rows="4" 
                                      class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                      placeholder="예약 시 고객에게 전달할 특별 안내사항을 입력하세요...">${settings.specialInstructions}</textarea>
                            <p class="text-sm text-slate-600 mt-2">예약 확인 시 고객에게 표시될 메시지</p>
                        </div>
                    </div>
                </div>
                
                <!-- 요일별 운영시간 -->
                <div class="glass-card p-8 rounded-3xl slide-up">
                    <h2 class="text-2xl font-bold gradient-text mb-6">요일별 예약 가능 시간</h2>
                    
                    <div class="space-y-4">
                        <!-- 요일별 설정 -->
                        <c:set var="dayNames" value="월요일,화요일,수요일,목요일,금요일,토요일,일요일" />
                        <c:set var="dayNamesArray" value="${fn:split(dayNames, ',')}" />
                        
                        <!-- 월요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">월요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="mondayEnabled" value="true" 
                                           ${settings.mondayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('monday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="monday-settings" class="grid grid-cols-2 gap-4 ${settings.mondayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="mondayStart" value="${settings.mondayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="mondayEnd" value="${settings.mondayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 화요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">화요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="tuesdayEnabled" value="true" 
                                           ${settings.tuesdayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('tuesday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="tuesday-settings" class="grid grid-cols-2 gap-4 ${settings.tuesdayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="tuesdayStart" value="${settings.tuesdayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="tuesdayEnd" value="${settings.tuesdayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 수요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">수요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="wednesdayEnabled" value="true" 
                                           ${settings.wednesdayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('wednesday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="wednesday-settings" class="grid grid-cols-2 gap-4 ${settings.wednesdayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="wednesdayStart" value="${settings.wednesdayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="wednesdayEnd" value="${settings.wednesdayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 목요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">목요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="thursdayEnabled" value="true" 
                                           ${settings.thursdayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('thursday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="thursday-settings" class="grid grid-cols-2 gap-4 ${settings.thursdayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="thursdayStart" value="${settings.thursdayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="thursdayEnd" value="${settings.thursdayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 금요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">금요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="fridayEnabled" value="true" 
                                           ${settings.fridayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('friday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="friday-settings" class="grid grid-cols-2 gap-4 ${settings.fridayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="fridayStart" value="${settings.fridayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="fridayEnd" value="${settings.fridayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 토요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">토요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="saturdayEnabled" value="true" 
                                           ${settings.saturdayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('saturday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="saturday-settings" class="grid grid-cols-2 gap-4 ${settings.saturdayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="saturdayStart" value="${settings.saturdayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="saturdayEnd" value="${settings.saturdayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 일요일 -->
                        <div class="bg-white p-6 rounded-2xl">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-semibold text-slate-800">일요일</h3>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="sundayEnabled" value="true" 
                                           ${settings.sundayEnabled ? 'checked' : ''} 
                                           onchange="toggleDaySettings('sunday', this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="sunday-settings" class="grid grid-cols-2 gap-4 ${settings.sundayEnabled ? '' : 'opacity-50 pointer-events-none'}">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">시작 시간</label>
                                    <input type="time" name="sundayStart" value="${settings.sundayStart}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 mb-2">종료 시간</label>
                                    <input type="time" name="sundayEnd" value="${settings.sundayEnd}" 
                                           class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 저장 버튼 -->
                <div class="glass-card p-6 rounded-3xl text-center">
                    <button type="submit" class="btn-primary text-white px-8 py-4 rounded-xl font-bold text-lg">
                        💾 설정 저장
                    </button>
                    <p class="text-sm text-slate-500 mt-3">변경사항은 즉시 적용됩니다.</p>
                </div>
            </form>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        function toggleDaySettings(day, enabled) {
            const settingsDiv = document.getElementById(day + '-settings');
            if (enabled) {
                settingsDiv.classList.remove('opacity-50', 'pointer-events-none');
            } else {
                settingsDiv.classList.add('opacity-50', 'pointer-events-none');
            }
        }
        
        // 전체 적용 기능
        function applyToAll() {
            const mondayEnabled = document.querySelector('input[name="mondayEnabled"]').checked;
            const mondayStart = document.querySelector('input[name="mondayStart"]').value;
            const mondayEnd = document.querySelector('input[name="mondayEnd"]').value;
            
            const days = ['tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
            
            days.forEach(day => {
                document.querySelector(`input[name="${day}Enabled"]`).checked = mondayEnabled;
                document.querySelector(`input[name="${day}Start"]`).value = mondayStart;
                document.querySelector(`input[name="${day}End"]`).value = mondayEnd;
                toggleDaySettings(day, mondayEnabled);
            });
        }
        
        // 월요일 설정에 전체 적용 버튼 추가
        document.addEventListener('DOMContentLoaded', function() {
            const mondayHeader = document.querySelector('h3');
            if (mondayHeader && mondayHeader.textContent === '월요일') {
                const applyButton = document.createElement('button');
                applyButton.type = 'button';
                applyButton.className = 'text-sm bg-blue-100 hover:bg-blue-200 text-blue-700 px-3 py-1 rounded-lg font-semibold transition-colors';
                applyButton.textContent = '전체 적용';
                applyButton.onclick = applyToAll;
                mondayHeader.parentElement.appendChild(applyButton);
            }
        });
    </script>
</body>
</html>
