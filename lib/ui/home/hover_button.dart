import 'package:flutter/material.dart';
import 'dart:ui';

class HoverScaleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color glowColor;

  const HoverScaleButton({
    required this.onPressed,
    required this.child,
    this.glowColor = Colors.white,
    super.key,
  });

  @override
  State<HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<HoverScaleButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: isHovered ? 10 : 0, sigmaY: isHovered ? 10 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
                  border: isHovered ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: widget.child,
              ),
            ),
          ),
      ),
    );
  }
}
