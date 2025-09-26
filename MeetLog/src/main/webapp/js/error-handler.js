/**
 * 전역 오류 처리 시스템
 * MEETLOG 프로젝트용 사용자 피드백 개선
 */

function ErrorHandler() {
    this.networkErrorMessages = new Map();
    this.retryAttempts = new Map();
    this.maxRetries = 3;
    this.setupGlobalErrorHandlers();
}

ErrorHandler.prototype.setupGlobalErrorHandlers = function() {
    var self = this;

    // JavaScript 오류 처리
    window.addEventListener('error', function(event) {
        self.handleJavaScriptError(event);
    });

    // Promise rejection 처리
    window.addEventListener('unhandledrejection', function(event) {
        self.handlePromiseRejection(event);
    });

    // Fetch 오류 래퍼
    this.wrapFetch();
};

ErrorHandler.prototype.handleJavaScriptError = function(event) {
    console.error('JavaScript Error:', {
        message: event.message,
        filename: event.filename,
        lineno: event.lineno,
        colno: event.colno,
        error: event.error
    });

    // 사용자에게 친화적인 메시지 표시
    if (typeof showError === 'function') {
        showError('페이지에 오류가 발생했습니다. 새로고침 후 다시 시도해주세요.', {
            description: '문제가 지속될 경우 고객센터로 문의해주세요.',
            duration: 8000
        });
    }
};

ErrorHandler.prototype.handlePromiseRejection = function(event) {
    console.error('Unhandled Promise Rejection:', event.reason);

    // 네트워크 오류인지 확인
    if (this.isNetworkError(event.reason)) {
        this.handleNetworkError(event.reason);
    } else {
        // 일반적인 Promise rejection
        if (typeof showError === 'function') {
            showError('요청 처리 중 오류가 발생했습니다.', {
                description: '잠시 후 다시 시도해주세요.',
                duration: 5000
            });
        }
    }

    // 기본 동작 방지 (콘솔에 오류 메시지가 표시되지 않도록)
    event.preventDefault();
};

ErrorHandler.prototype.wrapFetch = function() {
    var originalFetch = window.fetch;
    var self = this;

    window.fetch = function(url, options) {
        if (options === undefined) {
            options = {};
        }

        return originalFetch(url, options).then(function(response) {
            // HTTP 오류 상태 확인
            if (!response.ok) {
                var error = new FetchError(
                    'HTTP ' + response.status + ': ' + response.statusText,
                    response.status,
                    url,
                    response
                );
                throw error;
            }
            return response;
        }).catch(function(error) {
            // 네트워크 오류 처리
            if (self.isNetworkError(error)) {
                return self.handleFetchError(url, options, error);
            }
            throw error;
        });
    };
};

ErrorHandler.prototype.handleFetchError = function(url, options, error) {
    var self = this;
    var errorKey = (options.method || 'GET') + '_' + url;
    var currentAttempts = this.retryAttempts.get(errorKey) || 0;

    // 재시도 로직
    if (currentAttempts < this.maxRetries && this.shouldRetry(error)) {
        this.retryAttempts.set(errorKey, currentAttempts + 1);

        if (typeof showWarning === 'function') {
            showWarning('연결이 불안정합니다. 재시도 중... (' + (currentAttempts + 1) + '/' + this.maxRetries + ')', {
                duration: 2000
            });
        }

        // 지수 백오프로 재시도
        var delay = Math.pow(2, currentAttempts) * 1000;
        return this.sleep(delay).then(function() {
            return window.fetch(url, options);
        });
    }

    // 재시도 횟수 초과
    this.retryAttempts.delete(errorKey);
    this.handleNetworkError(error, url);
    throw error;
};

ErrorHandler.prototype.handleNetworkError = function(error, url) {
    if (url === undefined) {
        url = '';
    }

    var message = '네트워크 연결을 확인해주세요.';
    var description = '인터넷 연결이 불안정하거나 서버에 일시적인 문제가 있을 수 있습니다.';

    if (error.name === 'TypeError' && error.message.includes('fetch')) {
        message = '서버에 연결할 수 없습니다.';
    } else if (error.status) {
        switch (error.status) {
            case 400:
                message = '잘못된 요청입니다.';
                description = '입력한 정보를 다시 확인해주세요.';
                break;
            case 401:
                message = '로그인이 필요합니다.';
                description = '다시 로그인해주세요.';
                this.redirectToLogin();
                break;
            case 403:
                message = '접근 권한이 없습니다.';
                description = '해당 기능을 사용할 권한이 없습니다.';
                break;
            case 404:
                message = '요청한 페이지를 찾을 수 없습니다.';
                description = 'URL을 다시 확인해주세요.';
                break;
            case 429:
                message = '너무 많은 요청이 발생했습니다.';
                description = '잠시 후 다시 시도해주세요.';
                break;
            case 500:
                message = '서버 내부 오류가 발생했습니다.';
                description = '잠시 후 다시 시도하거나 고객센터로 문의해주세요.';
                break;
            case 502:
            case 503:
            case 504:
                message = '서버가 일시적으로 사용할 수 없습니다.';
                description = '서버 점검 중이거나 일시적인 문제일 수 있습니다.';
                break;
        }
    }

    if (typeof showError === 'function') {
        showError(message, {
            description: description,
            duration: 8000
        });
    }
};

ErrorHandler.prototype.isNetworkError = function(error) {
    return (
        error instanceof TypeError ||
        error.name === 'NetworkError' ||
        error.name === 'FetchError' ||
        (error.message && error.message.includes('fetch')) ||
        (error.status && error.status >= 500)
    );
};

ErrorHandler.prototype.shouldRetry = function(error) {
    // 네트워크 오류나 5xx 서버 오류는 재시도
    if (this.isNetworkError(error)) {
        return true;
    }

    // 429 (Too Many Requests)도 재시도
    if (error.status === 429) {
        return true;
    }

    return false;
};

ErrorHandler.prototype.redirectToLogin = function() {
    setTimeout(function() {
        window.location.href = '/login';
    }, 3000);
};

ErrorHandler.prototype.sleep = function(ms) {
    return new Promise(function(resolve) {
        setTimeout(resolve, ms);
    });
};

// 특정 작업에 대한 맞춤형 오류 처리
ErrorHandler.prototype.handleLikeError = function(error, type) {
    if (type === undefined) {
        type = 'general';
    }

    var message = '좋아요 처리 중 오류가 발생했습니다.';

    if (error.status === 401) {
        message = '로그인 후 좋아요를 누를 수 있습니다.';
    } else if (error.status === 429) {
        message = '너무 빠르게 좋아요를 누르고 있습니다.';
    }

    if (typeof showError === 'function') {
        showError(message, { duration: 3000 });
    }
};

ErrorHandler.prototype.handleCommentError = function(error, action) {
    if (action === undefined) {
        action = 'submit';
    }

    var message = '댓글 처리 중 오류가 발생했습니다.';

    switch (action) {
        case 'submit':
            message = '댓글 등록에 실패했습니다.';
            break;
        case 'edit':
            message = '댓글 수정에 실패했습니다.';
            break;
        case 'delete':
            message = '댓글 삭제에 실패했습니다.';
            break;
    }

    if (error.status === 401) {
        message = '로그인 후 댓글을 작성할 수 있습니다.';
    } else if (error.status === 403) {
        message = '댓글을 수정/삭제할 권한이 없습니다.';
    }

    if (typeof showError === 'function') {
        showError(message, { duration: 4000 });
    }
};

ErrorHandler.prototype.handleUploadError = function(error) {
    var message = '파일 업로드에 실패했습니다.';

    if (error.status === 413) {
        message = '파일 크기가 너무 큽니다.';
    } else if (error.status === 415) {
        message = '지원하지 않는 파일 형식입니다.';
    }

    if (typeof showError === 'function') {
        showError(message, {
            description: '다시 시도하거나 다른 파일을 선택해주세요.',
            duration: 5000
        });
    }
};

// 사용자 정의 Fetch Error 클래스
function FetchError(message, status, url, response) {
    this.name = 'FetchError';
    this.message = message;
    this.status = status;
    this.url = url;
    this.response = response;
}
FetchError.prototype = Object.create(Error.prototype);
FetchError.prototype.constructor = FetchError;

// 전역 인스턴스 생성
var errorHandler = new ErrorHandler();

// 편의 함수들
function handleLikeError(error) {
    errorHandler.handleLikeError(error);
}

function handleCommentError(error, action) {
    errorHandler.handleCommentError(error, action);
}

function handleUploadError(error) {
    errorHandler.handleUploadError(error);
}