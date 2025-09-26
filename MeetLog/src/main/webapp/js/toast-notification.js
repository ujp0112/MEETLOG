/**
 * 토스트 알림 시스템
 * MEETLOG 프로젝트용 사용자 피드백 개선
 */

class ToastNotification {
    constructor() {
        this.container = null;
        this.notifications = new Map();
        this.init();
    }

    init() {
        // 토스트 컨테이너가 없으면 생성
        if (!document.getElementById('toast-container')) {
            this.createContainer();
        } else {
            this.container = document.getElementById('toast-container');
        }
    }

    createContainer() {
        this.container = document.createElement('div');
        this.container.id = 'toast-container';
        this.container.className = 'fixed top-4 right-4 z-50 space-y-2';
        document.body.appendChild(this.container);
    }

    show(message, type = 'info', duration = 5000, options = {}) {
        const id = this.generateId();
        const toast = this.createToast(id, message, type, options);

        this.container.appendChild(toast);
        this.notifications.set(id, toast);

        // 애니메이션으로 표시
        setTimeout(() => {
            toast.classList.add('show');
        }, 10);

        // 자동 제거
        if (duration > 0) {
            setTimeout(() => {
                this.hide(id);
            }, duration);
        }

        return id;
    }

    createToast(id, message, type, options) {
        const toast = document.createElement('div');
        toast.id = `toast-${id}`;
        toast.className = `toast toast-${type} transform translate-x-full transition-transform duration-300 ease-in-out`;

        const icon = this.getIcon(type);
        const backgroundColor = this.getBackgroundColor(type);
        const textColor = this.getTextColor(type);

        toast.innerHTML = `
            <div class="flex items-center p-4 ${backgroundColor} ${textColor} rounded-lg shadow-lg min-w-72 max-w-96">
                <div class="flex-shrink-0 mr-3">
                    ${icon}
                </div>
                <div class="flex-1">
                    <p class="text-sm font-medium">${message}</p>
                    ${options.description ? `<p class="text-xs opacity-90 mt-1">${options.description}</p>` : ''}
                </div>
                <button onclick="toastNotification.hide('${id}')" class="flex-shrink-0 ml-3 opacity-70 hover:opacity-100 transition-opacity">
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                    </svg>
                </button>
            </div>
        `;

        // 클릭하면 제거
        toast.addEventListener('click', (e) => {
            if (e.target.tagName !== 'BUTTON' && e.target.tagName !== 'SVG' && e.target.tagName !== 'PATH') {
                this.hide(id);
            }
        });

        return toast;
    }

    hide(id) {
        const toast = this.notifications.get(id);
        if (toast) {
            toast.classList.remove('show');
            toast.classList.add('translate-x-full');

            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
                this.notifications.delete(id);
            }, 300);
        }
    }

    success(message, duration = 3000, options = {}) {
        return this.show(message, 'success', duration, options);
    }

    error(message, duration = 5000, options = {}) {
        return this.show(message, 'error', duration, options);
    }

    warning(message, duration = 4000, options = {}) {
        return this.show(message, 'warning', duration, options);
    }

    info(message, duration = 3000, options = {}) {
        return this.show(message, 'info', duration, options);
    }

    loading(message, options = {}) {
        return this.show(message, 'loading', 0, options); // 0 = 자동 제거 안함
    }

    getIcon(type) {
        const icons = {
            success: `<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
            </svg>`,
            error: `<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
            </svg>`,
            warning: `<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
            </svg>`,
            info: `<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path>
            </svg>`,
            loading: `<svg class="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>`
        };
        return icons[type] || icons.info;
    }

    getBackgroundColor(type) {
        const colors = {
            success: 'bg-green-500',
            error: 'bg-red-500',
            warning: 'bg-yellow-500',
            info: 'bg-blue-500',
            loading: 'bg-gray-500'
        };
        return colors[type] || colors.info;
    }

    getTextColor(type) {
        return 'text-white';
    }

    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }

    // 모든 토스트 제거
    clear() {
        this.notifications.forEach((toast, id) => {
            this.hide(id);
        });
    }

    // 특정 타입의 토스트만 제거
    clearType(type) {
        this.notifications.forEach((toast, id) => {
            if (toast.classList.contains(`toast-${type}`)) {
                this.hide(id);
            }
        });
    }
}

// 전역 인스턴스 생성
const toastNotification = new ToastNotification();

// 편의 함수들
function showSuccess(message, options = {}) {
    return toastNotification.success(message, options.duration, options);
}

function showError(message, options = {}) {
    return toastNotification.error(message, options.duration, options);
}

function showWarning(message, options = {}) {
    return toastNotification.warning(message, options.duration, options);
}

function showInfo(message, options = {}) {
    return toastNotification.info(message, options.duration, options);
}

function showLoading(message, options = {}) {
    return toastNotification.loading(message, options);
}

// click-protection.js와 통합
if (typeof clickProtection !== 'undefined') {
    // 기존 showSuccess와 showError 메서드를 토스트로 변경
    const originalShowSuccess = clickProtection.showSuccess.bind(clickProtection);
    const originalShowError = clickProtection.showError.bind(clickProtection);

    clickProtection.showSuccess = function(elementId, successText = '완료!', duration = 1000) {
        originalShowSuccess(elementId, successText, duration);
        showSuccess(successText);
    };

    clickProtection.showError = function(elementId, errorText = '오류 발생', duration = 2000) {
        originalShowError(elementId, errorText, duration);
        showError(errorText);
    };
}