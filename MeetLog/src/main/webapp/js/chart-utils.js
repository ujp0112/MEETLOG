/**
 * MEETLOG Chart.js 유틸리티
 * 모든 차트 관련 기능을 통합 관리
 */
class ChartUtils {
    constructor() {
        this.defaultColors = {
            primary: '#3b82f6',
            secondary: '#8b5cf6',
            success: '#10b981',
            warning: '#f59e0b',
            danger: '#ef4444',
            info: '#06b6d4',
            gradient: {
                primary: ['#3b82f6', '#1e40af'],
                secondary: ['#8b5cf6', '#7c3aed'],
                success: ['#10b981', '#059669'],
                warning: ['#f59e0b', '#d97706'],
                danger: ['#ef4444', '#dc2626']
            }
        };

        this.defaultOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        font: {
                            family: 'Noto Sans KR',
                            size: 12
                        },
                        padding: 20,
                        usePointStyle: true
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleFont: {
                        family: 'Noto Sans KR',
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        family: 'Noto Sans KR',
                        size: 12
                    },
                    cornerRadius: 8,
                    displayColors: true
                }
            },
            interaction: {
                intersect: false,
                mode: 'index'
            }
        };
    }

    /**
     * 그라데이션 생성
     */
    createGradient(ctx, colorArray, direction) {
        if (typeof direction === 'undefined') {
            direction = 'vertical';
        }
        const gradient = direction === 'vertical'
            ? ctx.createLinearGradient(0, 0, 0, 400)
            : ctx.createLinearGradient(0, 0, 400, 0);

        gradient.addColorStop(0, colorArray[0]);
        gradient.addColorStop(1, colorArray[1]);
        return gradient;
    }

    /**
     * 라인 차트 생성 (매출 트렌드, 방문 패턴 등)
     */
    createLineChart(ctx, data, options) {
        if (typeof options === 'undefined') {
            options = {};
        }
        const chartData = {
            labels: data.labels,
            datasets: data.datasets.map((dataset, index) => {
                return Object.assign({
                    label: dataset.label,
                    data: dataset.data,
                    borderColor: this.defaultColors.gradient.primary[0],
                    backgroundColor: this.createGradient(ctx, this.defaultColors.gradient.primary),
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: this.defaultColors.primary,
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }, dataset);
            })
        };

        const mergedOptions = this.mergeOptions(this.defaultOptions, {
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)'
                    },
                    ticks: {
                        font: {
                            family: 'Noto Sans KR'
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            family: 'Noto Sans KR'
                        }
                    }
                }
            }
        }, options);

        return new Chart(ctx, {
            type: 'line',
            data: chartData,
            options: mergedOptions
        });
    }

    /**
     * 도넛 차트 생성 (선호 카테고리, 예약 상태 등)
     */
    createDoughnutChart(ctx, data, options) {
        if (typeof options === 'undefined') {
            options = {};
        }
        const colors = [
            this.defaultColors.primary,
            this.defaultColors.secondary,
            this.defaultColors.success,
            this.defaultColors.warning,
            this.defaultColors.danger,
            this.defaultColors.info
        ];

        const chartData = {
            labels: data.labels,
            datasets: [{
                data: data.values,
                backgroundColor: colors.slice(0, data.labels.length),
                borderWidth: 0,
                hoverOffset: 10
            }]
        };

        const mergedOptions = this.mergeOptions(this.defaultOptions, {
            cutout: '60%',
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        boxWidth: 12,
                        padding: 15
                    }
                }
            }
        }, options);

        return new Chart(ctx, {
            type: 'doughnut',
            data: chartData,
            options: mergedOptions
        });
    }

    /**
     * 바 차트 생성 (가맹점 성과, 월별 통계 등)
     */
    createBarChart(ctx, data, options) {
        if (typeof options === 'undefined') {
            options = {};
        }
        const chartData = {
            labels: data.labels,
            datasets: data.datasets.map((dataset, index) => {
                const colorIndex = index % this.defaultColors.gradient.length;
                const gradientColors = Object.values(this.defaultColors.gradient)[colorIndex];

                return Object.assign({
                    label: dataset.label,
                    data: dataset.data,
                    backgroundColor: this.createGradient(ctx, gradientColors),
                    borderColor: gradientColors[0],
                    borderWidth: 1,
                    borderRadius: 6,
                    borderSkipped: false
                }, dataset);
            })
        };

        const mergedOptions = this.mergeOptions(this.defaultOptions, {
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)'
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }, options);

        return new Chart(ctx, {
            type: 'bar',
            data: chartData,
            options: mergedOptions
        });
    }

    /**
     * 실시간 데이터 업데이트
     */
    updateChart(chart, newData, newLabels) {
        if (newLabels) {
            chart.data.labels = newLabels;
        }

        chart.data.datasets.forEach((dataset, index) => {
            if (newData[index]) {
                dataset.data = newData[index];
            }
        });

        chart.update('active');
    }

    /**
     * 차트에 새로운 데이터 포인트 추가 (실시간 업데이트용)
     */
    addDataPoint(chart, label, dataPoints) {
        chart.data.labels.push(label);
        chart.data.datasets.forEach((dataset, index) => {
            dataset.data.push(dataPoints[index] || 0);
        });

        // 최대 데이터 포인트 수 제한 (성능 최적화)
        const maxDataPoints = 20;
        if (chart.data.labels.length > maxDataPoints) {
            chart.data.labels.shift();
            chart.data.datasets.forEach(dataset => {
                dataset.data.shift();
            });
        }

        chart.update('active');
    }

    /**
     * 옵션 병합 유틸리티
     */
    mergeOptions(defaultOpts, ...customOpts) {
        return customOpts.reduce((merged, opts) => {
            return this.deepMerge(merged, opts);
        }, JSON.parse(JSON.stringify(defaultOpts)));
    }

    /**
     * 깊은 객체 병합
     */
    deepMerge(target, source) {
        for (const key in source) {
            if (source[key] && typeof source[key] === 'object' && !Array.isArray(source[key])) {
                if (!target[key]) target[key] = {};
                this.deepMerge(target[key], source[key]);
            } else {
                target[key] = source[key];
            }
        }
        return target;
    }

    /**
     * 반응형 차트 크기 조정
     */
    resizeChart(chart) {
        chart.resize();
    }

    /**
     * 차트 애니메이션 설정
     */
    getAnimationConfig(duration, easing) {
        if (typeof duration === 'undefined') {
            duration = 1000;
        }
        if (typeof easing === 'undefined') {
            easing = 'easeInOutQuart';
        }
        return {
            animation: {
                duration: duration,
                easing: easing,
                onComplete: function() {
                    // 애니메이션 완료 후 실행될 콜백
                }
            }
        };
    }

    /**
     * 데이터 로딩 상태 표시
     */
    showLoadingState(containerId) {
        const container = document.getElementById(containerId);
        if (container) {
            container.innerHTML =
                '<div class="flex items-center justify-center h-64">' +
                    '<div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>' +
                    '<span class="ml-3 text-gray-600">데이터 로딩 중...</span>' +
                '</div>';
        }
    }

    /**
     * 에러 상태 표시
     */
    showErrorState(containerId, message) {
        if (typeof message === 'undefined') {
            message = '데이터를 불러오는데 실패했습니다.';
        }
        const container = document.getElementById(containerId);
        if (container) {
            container.innerHTML =
                '<div class="flex items-center justify-center h-64">' +
                    '<div class="text-center">' +
                        '<div class="text-red-500 text-4xl mb-4">⚠️</div>' +
                        '<p class="text-gray-600">' + message + '</p>' +
                        '<button onclick="location.reload()" class="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">' +
                            '다시 시도' +
                        '</button>' +
                    '</div>' +
                '</div>';
        }
    }
}

// 전역 인스턴스 생성
const chartUtils = new ChartUtils();

// 페이지 로드 시 Chart.js 초기화
document.addEventListener('DOMContentLoaded', function() {
    // Chart.js 글로벌 설정
    Chart.defaults.font.family = 'Noto Sans KR';
    Chart.defaults.font.size = 12;
    Chart.defaults.color = '#374151';

    // 반응형 차트 리사이징
    window.addEventListener('resize', function() {
        Chart.instances.forEach(chart => {
            chartUtils.resizeChart(chart);
        });
    });
});