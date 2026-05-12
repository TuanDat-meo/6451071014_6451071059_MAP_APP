document.addEventListener('DOMContentLoaded', function() {
    // Revenue Line Chart
    const revCtx = document.getElementById('revenueChart').getContext('2d');
    
    // Create Gradient
    const gradient = revCtx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(79, 172, 254, 0.4)');
    gradient.addColorStop(1, 'rgba(79, 172, 254, 0)');

    new Chart(revCtx, {
        type: 'line',
        data: {
            labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
            datasets: [{
                label: 'Doanh thu (k)',
                data: [265, 50, 250, 310, 30, 85, 60],
                borderColor: '#4facfe',
                borderWidth: 3,
                fill: true,
                backgroundColor: gradient,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#4facfe',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        display: true,
                        color: 'rgba(0,0,0,0.03)'
                    },
                    ticks: {
                        callback: function(value) {
                            return value + 'k';
                        },
                        font: {
                            family: 'Outfit'
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            family: 'Outfit'
                        }
                    }
                }
            }
        }
    });

    // Order Status Donut Chart
    const statusCtx = document.getElementById('statusChart').getContext('2d');
    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Đã giao', 'Đang làm', 'Đã hủy'],
            datasets: [{
                data: [50, 33, 17],
                backgroundColor: [
                    '#4facfe',
                    '#667eea',
                    '#f5576c'
                ],
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '75%',
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });

    // Add some interactivity to sidebar
    const navItems = document.querySelectorAll('.sidebar-nav li');
    navItems.forEach(item => {
        item.addEventListener('click', function() {
            navItems.forEach(i => i.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // Notification badge simulation
    setTimeout(() => {
        const badge = document.querySelector('.badge');
        if (badge) badge.style.display = 'block';
    }, 2000);
});
