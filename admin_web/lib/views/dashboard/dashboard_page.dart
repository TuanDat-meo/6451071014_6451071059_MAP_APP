import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF1E88E5), size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Hệ Thống Quản Lý',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- Stat Cards Row ---
            LayoutBuilder(builder: (context, constraints) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildGradientCard(
                    constraints.maxWidth,
                    'Tổng Doanh Thu',
                    '733,190',
                    const [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                    Icons.attach_money_rounded,
                  ),
                  _buildGradientCard(
                    constraints.maxWidth,
                    'Giá Trị TB',
                    '122,198',
                    const [Color(0xFFAB47BC), Color(0xFF8E24AA)],
                    Icons.auto_awesome,
                  ),
                  _buildGradientCard(
                    constraints.maxWidth,
                    'Tổng Đơn',
                    '6',
                    const [Color(0xFFFFA726), Color(0xFFFB8C00)],
                    Icons.shopping_bag_rounded,
                  ),
                  _buildGradientCard(
                    constraints.maxWidth,
                    'Đã Bán',
                    '12',
                    const [Color(0xFF26A69A), Color(0xFF00897B)],
                    Icons.inventory_2_rounded,
                  ),
                ],
              );
            }),
            const SizedBox(height: 30),

            // --- Charts Row ---
            LayoutBuilder(
              builder: (context, constraints) {
                double chartHeight = 380;
                bool isSmall = constraints.maxWidth < 900;
                
                return Flex(
                  direction: isSmall ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Chart: Line Chart
                    Flexible(
                      flex: isSmall ? 0 : 7,
                      child: Container(
                        height: chartHeight,
                        margin: const EdgeInsets.only(bottom: 20, right: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: _boxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phân Tích Doanh Thu Tuần', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                            const SizedBox(height: 20),
                            Expanded(
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: _LineChartPainter(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right Chart: Pie Chart
                    Flexible(
                      flex: isSmall ? 0 : 3,
                      child: Container(
                        height: chartHeight,
                        margin: const EdgeInsets.only(bottom: 20, left: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: _boxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Thống Kê Trạng Thái', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                            const SizedBox(height: 40),
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CustomPaint(
                                    painter: _DonutChartPainter(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF48BB78), shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                const Text('delivered', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                const Spacer(),
                                const Text('3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _buildGradientCard(double maxWidth, String title, String value, List<Color> gradient, IconData icon) {
    // Calculate item width assuming 4 in a row minus spacing
    double cardWidth = (maxWidth - (3 * 20)) / 4;
    if (cardWidth < 200) cardWidth = maxWidth;

    return Container(
      width: cardWidth,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ghost Background Icon
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.15)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.grey.withOpacity(0.1)..strokeWidth = 1;
    
    // Drawing Grid lines horizontally
    for (int i = 0; i < 6; i++) {
      double y = size.height - (i * (size.height / 5));
      canvas.drawLine(Offset(40, y), Offset(size.width, y), gridPaint);
    }

    // Text styling for Y Labels
    final textPainter = TextPainter(textAlign: TextAlign.right, textDirection: TextDirection.ltr);
    final yLabels = ['0', '50K', '100K', '150K', '200K', '250K', '300K'];
    for (int i = 0; i < yLabels.length; i++) {
      double y = size.height - (i * (size.height / 6));
      if (y < 0) continue;
      textPainter.text = TextSpan(text: yLabels[i], style: const TextStyle(color: Colors.grey, fontSize: 10));
      textPainter.layout();
      textPainter.paint(canvas, Offset(30 - textPainter.width, y - textPainter.height / 2));
    }

    // Drawing Bottom Labels
    final xLabels = ['T2', 'T2', 'T3', 'T3', 'T4', 'T4', 'T5', 'T5', 'T6', 'T6', 'T7', 'T7', 'CN'];
    double stepX = (size.width - 50) / (xLabels.length - 1);
    for (int i = 0; i < xLabels.length; i++) {
      double x = 40 + (i * stepX);
      textPainter.text = TextSpan(text: xLabels[i], style: const TextStyle(color: Colors.grey, fontSize: 10));
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height + 5));
    }

    // Drawing The Data Line & Gradient
    // Map arbitrary points that create that peak shape
    final points = [
      Offset(40, size.height * 0.2),
      Offset(40 + stepX, size.height * 0.5),
      Offset(40 + 2 * stepX, size.height * 0.9),
      Offset(40 + 3 * stepX, size.height * 0.6),
      Offset(40 + 4 * stepX, size.height * 0.1), // High Peak
      Offset(40 + 5 * stepX, size.height * 0.4),
      Offset(40 + 6 * stepX, size.height * 0.95),
      Offset(40 + 7 * stepX, size.height * 0.98),
      Offset(40 + 8 * stepX, size.height * 0.9),
      Offset(40 + 9 * stepX, size.height * 0.8),
      Offset(40 + 10 * stepX, size.height * 0.7),
      Offset(40 + 11 * stepX, size.height * 0.75),
      Offset(size.width, size.height * 0.8),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    // Curve builder
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i+1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    // Fill path
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(40, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF03A9F4).withOpacity(0.2),
          const Color(0xFF03A9F4).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF03A9F4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(path, linePaint);

    // Plot dots
    final dotPaint = Paint()..color = const Color(0xFF03A9F4);
    final dotBorder = Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.fill;
    
    for (var point in points) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(point, 3, dotBorder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45;

    // Defining sectors with percentage
    final List<double> values = [0.17, 0.17, 0.17, 0.50];
    final List<Color> colors = [
      const Color(0xFFE53E3E), // Red
      const Color(0xFF607D8B), // Grey Blue
      const Color(0xFFE91E63), // Pink
      const Color(0xFF4CAF50), // Green
    ];

    double startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = 2 * math.pi * values[i];
      
      // Drawing with a gap/inset effect
      paint.color = colors[i];
      
      canvas.drawArc(
        rect.deflate(22), // Center stroke inside the layout
        startAngle + 0.05, // Mini gap between sectors
        sweepAngle - 0.05,
        false,
        paint
      );

      // Put text inside the arc
      final double labelAngle = startAngle + sweepAngle / 2;
      final double labelRadius = radius - 22; // Position on the arc center line
      final double lx = center.dx + math.cos(labelAngle) * labelRadius;
      final double ly = center.dy + math.sin(labelAngle) * labelRadius;

      final textPainter = TextPainter(
        text: const TextSpan(text: '17%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      );
      if (i == 3) {
         textPainter.text = const TextSpan(text: '50%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold));
      }
      textPainter.layout();
      textPainter.paint(canvas, Offset(lx - textPainter.width / 2, ly - textPainter.height / 2));

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
