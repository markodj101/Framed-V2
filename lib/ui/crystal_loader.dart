import 'package:flutter/material.dart';

class CrystalLoader extends StatefulWidget {
  const CrystalLoader({super.key, this.size = 200});

  final double size;

  @override
  State<CrystalLoader> createState() => _CrystalLoaderState();
}

class _CrystalLoaderState extends State<CrystalLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Transform(
          transform: Matrix4.identity()..setEntry(3, 2, 0.001), // Add perspective
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(6, (index) => _buildCrystal(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildCrystal(int index) {
    final delay = index * 0.3;
    final colors = [
      [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)],
      [const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)],
      [const Color(0xFFFFFFFF), const Color(0xFFF5F5F5)],
      [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
      [const Color(0xFFE9ECEF), const Color(0xFFDEE2E6)],
      [const Color(0xFFDEE2E6), const Color(0xFFCED4DA)],
    ][index];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate progress with delay
        double progress = (_controller.value + delay) % 1.0;
        
        // Spin animation (continuous rotation)
        final spinAngle = progress * 360;
        
        // Emerge animation (0 to 1 to 0 over 2 seconds)
        double emergeProgress = (progress * 2) % 2;
        if (emergeProgress > 1) emergeProgress = 2 - emergeProgress;
        
        // Scale and opacity
        final scale = 0.5 + emergeProgress * 0.5;
        final opacity = emergeProgress * 0.8;
        
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(45 * (3.14159 / 180)) // 45 degrees on X
            ..rotateZ(spinAngle * (3.14159 / 180)), // Spin on Z
          origin: const Offset(30, 60), // Bottom center
          alignment: Alignment.center,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.7),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
