/**
 * MEET LOG 메인 페이지 성능 최적화 스크립트
 */

// 1. Intersection Observer로 이미지 lazy loading (폴백)
(function initLazyLoading() {
    // 네이티브 lazy loading을 지원하지 않는 브라우저를 위한 폴백
    if ('loading' in HTMLImageElement.prototype) {
        console.log('✅ Native lazy loading supported');
        return;
    }

    console.log('⚠️ Using Intersection Observer fallback for lazy loading');

    const images = document.querySelectorAll('img[loading="lazy"]');
    const imageObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                if (img.dataset.src) {
                    img.src = img.dataset.src;
                }
                img.classList.add('loaded');
                imageObserver.unobserve(img);
            }
        });
    }, {
        rootMargin: '50px' // 50px 전에 로드 시작
    });

    images.forEach(img => {
        // src를 data-src로 이동 (lazy loading)
        if (!img.dataset.src && img.src) {
            img.dataset.src = img.src;
            img.src = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"%3E%3C/svg%3E';
        }
        imageObserver.observe(img);
    });
})();

// 2. Debounce 유틸리티 함수
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// 3. 스크롤 이벤트 최적화 (Passive Listener)
document.addEventListener('DOMContentLoaded', () => {
    const carouselTracks = document.querySelectorAll('.review-carousel-track, .horizontal-scroll');

    carouselTracks.forEach(track => {
        // Debounce를 적용한 스크롤 핸들러
        const handleScroll = debounce(() => {
            // 스크롤 관련 로직 (필요시 추가)
            const scrollPercentage = (track.scrollLeft / (track.scrollWidth - track.clientWidth)) * 100;
            // console.log('Scroll:', scrollPercentage.toFixed(0) + '%');
        }, 150);

        // Passive 리스너로 성능 향상
        track.addEventListener('scroll', handleScroll, { passive: true });
    });
});

// 4. Intersection Observer로 섹션별 애니메이션
(function initSectionAnimations() {
    const sections = document.querySelectorAll('section');

    const sectionObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in-visible');
                // 한 번만 애니메이션 실행 후 언옵저브
                sectionObserver.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1, // 10% 보이면 트리거
        rootMargin: '0px 0px -100px 0px' // 100px 전에 애니메이션 시작
    });

    sections.forEach(section => {
        section.classList.add('fade-in-hidden');
        sectionObserver.observe(section);
    });
})();

// 5. 성능 측정 (개발 환경에서만)
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    window.addEventListener('load', () => {
        if (window.performance && window.performance.timing) {
            const timing = window.performance.timing;
            const loadTime = timing.loadEventEnd - timing.navigationStart;
            const domReady = timing.domContentLoadedEventEnd - timing.navigationStart;

            console.log('📊 Performance Metrics:');
            console.log('  - DOM Ready:', domReady + 'ms');
            console.log('  - Full Load:', loadTime + 'ms');

            // Web Vitals (LCP, FID, CLS) 측정
            if ('PerformanceObserver' in window) {
                // Largest Contentful Paint
                const lcpObserver = new PerformanceObserver((list) => {
                    const entries = list.getEntries();
                    const lastEntry = entries[entries.length - 1];
                    console.log('  - LCP:', lastEntry.renderTime || lastEntry.loadTime, 'ms');
                });
                lcpObserver.observe({ entryTypes: ['largest-contentful-paint'] });

                // First Input Delay
                const fidObserver = new PerformanceObserver((list) => {
                    const entries = list.getEntries();
                    entries.forEach(entry => {
                        console.log('  - FID:', entry.processingStart - entry.startTime, 'ms');
                    });
                });
                fidObserver.observe({ entryTypes: ['first-input'] });
            }
        }
    });
}

// 6. 리소스 힌트 동적 추가
(function addResourceHints() {
    // DNS Prefetch for external resources
    const dnsPrefetchDomains = [
        'https://fonts.googleapis.com',
        'https://fonts.gstatic.com'
    ];

    dnsPrefetchDomains.forEach(domain => {
        const link = document.createElement('link');
        link.rel = 'dns-prefetch';
        link.href = domain;
        document.head.appendChild(link);
    });
})();

// 7. 캐러셀 성능 개선 (requestAnimationFrame 사용)
(function optimizeCarousel() {
    const carousels = document.querySelectorAll('[id$="CarouselTrack"]');

    carousels.forEach(carousel => {
        let ticking = false;

        carousel.addEventListener('scroll', () => {
            if (!ticking) {
                window.requestAnimationFrame(() => {
                    // 스크롤 관련 업데이트
                    ticking = false;
                });
                ticking = true;
            }
        }, { passive: true });
    });
})();

console.log('✅ Main page optimizations loaded');
