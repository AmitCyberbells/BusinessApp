import 'package:flutter/material.dart';
import 'dart:math' show cos, sin, pi;

class SuccessConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Main check circle
    final Paint circlePaint = Paint()
      ..color = const Color(0xFF2F6D88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.2;
    canvas.drawCircle(center, radius, circlePaint);

    // Check mark
    final checkPaint = Paint()
      ..color = const Color(0xFF2F6D88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(center.dx - radius * 0.5, center.dy);
    path.lineTo(center.dx - radius * 0.1, center.dy + radius * 0.4);
    path.lineTo(center.dx + radius * 0.5, center.dy - radius * 0.4);
    canvas.drawPath(path, checkPaint);

    // Confetti elements
    final confettiPaint = Paint()..style = PaintingStyle.fill;

    // Draw stars
    _drawStar(canvas, Offset(size.width * 0.2, size.height * 0.3),
        size.width * 0.03, Colors.purple);
    _drawStar(canvas, Offset(size.width * 0.8, size.height * 0.7),
        size.width * 0.03, const Color(0xFF2F6D88));

    // Draw dots
    confettiPaint.color = Colors.purple.withOpacity(0.6);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.2),
        size.width * 0.02, confettiPaint);
    confettiPaint.color = const Color(0xFF2F6D88).withOpacity(0.6);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.8),
        size.width * 0.02, confettiPaint);

    // Draw squiggles
    final squigglePaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final squigglePath = Path();
    squigglePath.moveTo(size.width * 0.15, size.height * 0.5);
    squigglePath.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.4,
      size.width * 0.25,
      size.height * 0.5,
    );
    canvas.drawPath(squigglePath, squigglePaint);

    squigglePaint.color = const Color(0xFF2F6D88);
    final squigglePath2 = Path();
    squigglePath2.moveTo(size.width * 0.75, size.height * 0.5);
    squigglePath2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.6,
      size.width * 0.85,
      size.height * 0.5,
    );
    canvas.drawPath(squigglePath2, squigglePaint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double halfRadius = radius * 0.5;

    for (int i = 0; i < 8; i++) {
      final double angle = i * pi / 4;
      final double x = cos(angle);
      final double y = sin(angle);

      if (i == 0) {
        path.moveTo(center.dx + radius * x, center.dy + radius * y);
      } else {
        path.lineTo(center.dx + radius * x, center.dy + radius * y);
      }

      path.lineTo(
        center.dx + halfRadius * cos(angle + pi / 8),
        center.dy + halfRadius * sin(angle + pi / 8),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SuccessConfetti extends StatelessWidget {
  final double size;

  const SuccessConfetti({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SuccessConfettiPainter(),
      ),
    );
  }
}
