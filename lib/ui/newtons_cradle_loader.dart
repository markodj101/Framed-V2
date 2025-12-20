import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NewtonsCradleLoader extends StatefulWidget {
  final Color color;
  final double size;

  const NewtonsCradleLoader({
    super.key,
    this.color = Colors.white,
    this.size = 50.0,
  });

  @override
  State<NewtonsCradleLoader> createState() => _NewtonsCradleLoaderState();
}

class _NewtonsCradleLoaderState extends State<NewtonsCradleLoader>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dot dimensions
    final dotSize = widget.size * 0.25;
    const dotCount = 4;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top for pivot
        children: List.generate(dotCount, (index) {
          // Inner dots are static (index 1 and 2)
          if (index > 0 && index < dotCount - 1) {
            return _buildDot(dotSize);
          }

          // First dot
          if (index == 0) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                double angle = 0;
                // 0% -> 25%: 0 -> 70 deg (swing up)
                // 25% -> 50%: 70 -> 0 deg (swing down)
                // 50% -> 100%: 0 deg (static)
                if (t <= 0.25) {
                   // Ease out
                   final curveT = Curves.easeOut.transform(t / 0.25);
                   angle = 70 * (3.14159 / 180) * curveT;
                } else if (t <= 0.5) {
                   // Ease in
                   final curveT = Curves.easeIn.transform((t - 0.25) / 0.25);
                   angle = 70 * (3.14159 / 180) * (1 - curveT);
                }
                
                return Transform(
                  transform: Matrix4.identity()..rotateZ(angle),
                  alignment: Alignment.topCenter, // Pivot at top
                  child: child,
                );
              },
              child: _buildDot(dotSize),
            );
          }

          // Last dot
          // 0% -> 50%: 0 deg (static)
          // 50% -> 75%: 0 -> -70 deg (swing up)
          // 75% -> 100%: -70 -> 0 deg (swing down)
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              double angle = 0;
              if (t > 0.5 && t <= 0.75) {
                 // Ease out
                 final curveT = Curves.easeOut.transform((t - 0.5) / 0.25);
                 angle = -70 * (3.14159 / 180) * curveT;
              } else if (t > 0.75) {
                 // Ease in
                 final curveT = Curves.easeIn.transform((t - 0.75) / 0.25);
                 angle = -70 * (3.14159 / 180) * (1 - curveT);
              }

              return Transform(
                transform: Matrix4.identity()..rotateZ(angle),
                alignment: Alignment.topCenter,
                child: child,
              );
            },
            child: _buildDot(dotSize),
          );
        }),
      ),
    );
  }

  Widget _buildDot(double size) {
    return Container(
      width: size,
      height: widget.size, // Container height is full size to allow swing clearance? 
      // Actually CSS says dot is 100% height of size. width 25%.
      // And the ::after is the circle at the top?
      // "display: flex; align-items: center; justify-content: center;"
      // "height: 100%; width: 25%; transform-origin: center top;"
      // "::after ... width: 100%; height: 25%; border-radius: 50%;"
      // Wait, height of ::after is 25% of the DOT container.
      // So if container is 50px high, dot container is 50px high.
      // ::after is 12.5px high (25% of 50px).
      // So the ball is at the top of the container?
      // But `align-items: center` on dot container? 
      // The CSS is:
      // .newtons-cradle__dot { ... display: flex; align-items: center; ... }
      // This centers the ::after vertically in the dot container?
      // BUT `transform-origin: center top;` suggests it swings from the top.
      // If the ball is centered vertically, and it swings from top, the string length is half the height.
      // Let's assume the ball is centered.
      
      child: Center(
        child: Container(
          width: size,
          height: size, // Circle
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
