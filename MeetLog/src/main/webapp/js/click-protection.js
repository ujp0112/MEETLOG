/**
 * 중복 클릭 방지 및 로딩 상태 관리 JavaScript 라이브러리
 * MEETLOG 프로젝트용
 */

function ClickProtection() {
    this.processingElements = new Set();
    this.defaultTimeout = 2000; // 2초 기본 보호 시간
}

/**
 * 버튼이 현재 처리 중인지 확인
 */
ClickProtection.prototype.isProcessing = function(elementId) {
    return this.processingElements.has(elementId);
};

/**
 * 버튼을 처리 중 상태로 설정
 */
ClickProtection.prototype.setProcessing = function(elementId, timeout) {
    var self = this;

    if (timeout === undefined) {
        timeout = this.defaultTimeout;
    }

    var element = document.getElementById(elementId);
    if (!element) return false;

    // 이미 처리 중이면 무시
    if (this.isProcessing(elementId)) {
        return false;
    }

    // 처리 중 상태로 설정
    this.processingElements.add(elementId);
    element.disabled = true;

    // 원본 텍스트 저장
    var originalText = element.textContent || element.innerText;
    element.setAttribute('data-original-text', originalText);

    // 로딩 표시
    this.showLoading(element);

    // 타임아웃 설정
    setTimeout(function() {
        self.releaseProcessing(elementId);
    }, timeout);

    return true;
};

/**
 * 버튼의 처리 중 상태 해제
 */
ClickProtection.prototype.releaseProcessing = function(elementId) {
    var element = document.getElementById(elementId);
    if (!element) return;

    this.processingElements.delete(elementId);
    element.disabled = false;

    // 원본 텍스트 복원
    var originalText = element.getAttribute('data-original-text');
    if (originalText) {
        element.textContent = originalText;
        element.removeAttribute('data-original-text');
    }

    // 로딩 클래스 제거
    element.classList.remove('loading');
};

/**
 * 로딩 상태 표시
 */
ClickProtection.prototype.showLoading = function(element) {
    element.classList.add('loading');

    // 현재 텍스트에 따라 적절한 로딩 메시지 설정
    var currentText = element.textContent || element.innerText;
    var loadingText = '처리 중...';

    if (currentText.includes('좋아요')) {
        loadingText = '🔄';
    } else if (currentText.includes('팔로우')) {
        loadingText = '처리 중...';
    } else if (currentText.includes('저장')) {
        loadingText = '저장 중...';
    } else if (currentText.includes('삭제')) {
        loadingText = '삭제 중...';
    } else if (currentText.includes('수정')) {
        loadingText = '수정 중...';
    }

    element.textContent = loadingText;
};

/**
 * 성공 상태 표시 (잠시 표시 후 원본으로 복원)
 */
ClickProtection.prototype.showSuccess = function(elementId, successText, duration) {
    var self = this;

    if (successText === undefined) {
        successText = '완료!';
    }
    if (duration === undefined) {
        duration = 1000;
    }

    var element = document.getElementById(elementId);
    if (!element) return;

    var originalText = element.getAttribute('data-original-text') || element.textContent;
    element.textContent = successText;
    element.classList.add('success');

    setTimeout(function() {
        element.textContent = originalText;
        element.classList.remove('success');
        self.releaseProcessing(elementId);
    }, duration);
};

/**
 * 오류 상태 표시 (잠시 표시 후 원본으로 복원)
 */
ClickProtection.prototype.showError = function(elementId, errorText, duration) {
    var self = this;

    if (errorText === undefined) {
        errorText = '오류 발생';
    }
    if (duration === undefined) {
        duration = 2000;
    }

    var element = document.getElementById(elementId);
    if (!element) return;

    var originalText = element.getAttribute('data-original-text') || element.textContent;
    element.textContent = errorText;
    element.classList.add('error');

    setTimeout(function() {
        element.textContent = originalText;
        element.classList.remove('error');
        self.releaseProcessing(elementId);
    }, duration);
};

/**
 * 보호된 함수 실행 (중복 클릭 방지와 함께)
 */
ClickProtection.prototype.protectedExecute = function(elementId, promiseFunction, options) {
    var self = this;

    if (options === undefined) {
        options = {};
    }

    var timeout = options.timeout || this.defaultTimeout;
    var successText = options.successText || '완료!';
    var errorText = options.errorText || '오류 발생';
    var successDuration = options.successDuration || 1000;
    var errorDuration = options.errorDuration || 2000;

    // 중복 클릭 방지
    if (!this.setProcessing(elementId, timeout)) {
        return Promise.resolve(false);
    }

    return promiseFunction().then(function(result) {
        if (result && result.success !== false) {
            self.showSuccess(elementId, successText, successDuration);
            return result;
        } else {
            self.showError(elementId, errorText, errorDuration);
            return false;
        }
    }).catch(function(error) {
        console.error('Protected function execution error:', error);
        self.showError(elementId, errorText, errorDuration);
        return false;
    });
};

// 전역 인스턴스 생성
var clickProtection = new ClickProtection();

/**
 * 편의 함수들
 */

// 좋아요 보호 함수
function protectedLike(elementId, targetId, endpoint) {
    return clickProtection.protectedExecute(elementId, function() {
        return fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'action=like&targetId=' + targetId
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (data.success) {
                // 좋아요 수 업데이트
                var countElement = document.querySelector('#' + elementId + ' .like-count');
                if (countElement && data.likeCount !== undefined) {
                    countElement.textContent = data.likeCount;
                }

                // 버튼 상태 업데이트
                var button = document.getElementById(elementId);
                if (data.isLiked !== undefined) {
                    if (data.isLiked) {
                        button.classList.add('liked');
                        button.classList.add('text-red-500');
                        button.classList.remove('text-slate-500');
                    } else {
                        button.classList.remove('liked');
                        button.classList.remove('text-red-500');
                        button.classList.add('text-slate-500');
                    }
                }
            }
            return data;
        });
    }, {
        successText: '👍',
        errorText: '오류',
        successDuration: 500,
        errorDuration: 1500
    });
}

// 팔로우 보호 함수
function protectedFollow(elementId, targetUserId, endpoint) {
    return clickProtection.protectedExecute(elementId, function() {
        return fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'action=follow&targetUserId=' + targetUserId
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (data.success) {
                // 버튼 텍스트 업데이트
                var button = document.getElementById(elementId);
                if (data.isFollowing !== undefined) {
                    button.textContent = data.isFollowing ? '언팔로우' : '팔로우';
                    if (data.isFollowing) {
                        button.classList.add('following');
                    } else {
                        button.classList.remove('following');
                    }
                }
            }
            return data;
        });
    }, {
        successText: '완료',
        errorText: '실패',
        successDuration: 800,
        errorDuration: 1500
    });
}

// 댓글 보호 함수
function protectedComment(elementId, formData, endpoint) {
    return clickProtection.protectedExecute(elementId, function() {
        return fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            return data;
        });
    }, {
        successText: '등록 완료',
        errorText: '등록 실패',
        successDuration: 1000,
        errorDuration: 2000
    });
}