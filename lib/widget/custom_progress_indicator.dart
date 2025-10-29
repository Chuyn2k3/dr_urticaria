import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';

import '../constant/color.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GradientLoader(
        colors: [
          AppColors.primaryColor, Color(0xFF00C6FF), // xanh neon
          Color(0xFF0072FF), Color(0xFF00D2FF)
        ],
      ),
    );
  }
}

class LiquidCircularLoader extends StatefulWidget {
  final double size;
  final Color baseColor;
  final Color waveColor;

  const LiquidCircularLoader({
    super.key,
    this.size = 60,
    this.baseColor = const Color(0xFFE0F0FF),
    this.waveColor = const Color(0xFF1976D2),
  });

  @override
  State<LiquidCircularLoader> createState() => _LiquidCircularLoaderState();
}

class _LiquidCircularLoaderState extends State<LiquidCircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _waveAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _LiquidPainter(
              animationValue: _waveAnimation.value,
              baseColor: widget.baseColor,
              waveColor: widget.waveColor,
            ),
          );
        },
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;
  final Color waveColor;

  _LiquidPainter({
    required this.animationValue,
    required this.baseColor,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw base circle
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, basePaint);

    // Draw wave
    final wavePaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [waveColor.withOpacity(0.8), waveColor.withOpacity(0.2)],
        stops: const [0.0, 1.0],
        transform: GradientRotation(animationValue),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      0,
      2 * pi,
      false,
      wavePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) => true;
}

class GradientLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final List<Color> colors;
  final Duration duration;

  const GradientLoader({
    super.key,
    this.size = 40,
    this.strokeWidth = 4,
    this.colors = const [Colors.blue, Colors.purple, Colors.pink],
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<GradientLoader> createState() => _GradientLoaderState();
}

class _GradientLoaderState extends State<GradientLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              painter: _GradientPainter(
                strokeWidth: widget.strokeWidth,
                colors: widget.colors,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final double strokeWidth;
  final List<Color> colors;

  _GradientPainter({
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      colors: colors,
      startAngle: 0,
      endAngle: 2 * math.pi,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final radius = (size.width / 2) - strokeWidth / 2;
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      0,
      2 * math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_GradientPainter oldDelegate) => true;
}
