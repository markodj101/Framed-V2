import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CrystalLoader extends StatelessWidget {
  const CrystalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(6, (index) {
            return _Crystal(
              index: index,
              delay: (index * 0.3).seconds,
            );
          }),
        ),
      ),
    );
  }
}

class _Crystal extends StatelessWidget {
  final int index;
  final Duration delay;

  const _Crystal({
    required this.index,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    // White themed gradients
    final gradients = [
      linearGradient([const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)]),
      linearGradient([const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)]),
      linearGradient([const Color(0xFFFFFFFF), const Color(0xFFF5F5F5)]),
      linearGradient([const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)]),
      linearGradient([const Color(0xFFE9ECEF), const Color(0xFFDEE2E6)]),
      linearGradient([const Color(0xFFDEE2E6), const Color(0xFFCED4DA)]),
    ];

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(45 * math.pi / 180),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: gradients[index % gradients.length],
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .custom(
      delay: delay,
      duration: 4.seconds,
      builder: (context, value, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..rotateZ(value * 2 * math.pi),
          child: child,
        );
      },
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .scale(
      delay: delay,
      duration: 2.seconds,
      begin: const Offset(0.5, 0.5),
      end: const Offset(1, 1),
      curve: Curves.easeInOut,
    )
    .fadeIn(
      delay: delay,
      duration: 2.seconds,
      curve: Curves.easeInOut,
    );
  }

  LinearGradient linearGradient(List<Color> colors) {
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
