import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ElegantActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const ElegantActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<ElegantActionButton> createState() => _ElegantActionButtonState();
}

class _ElegantActionButtonState extends State<ElegantActionButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _radialController;
  late Animation<double> _radialScale;
  
  // For local toggle state if needed, but we mostly rely on widget.isActive
  bool _localActive = false;

  @override
  void initState() {
    super.initState();
    _localActive = widget.isActive;
    _radialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _radialScale = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _radialController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(ElegantActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      setState(() {
        _localActive = widget.isActive;
      });
    }
  }

  @override
  void dispose() {
    _radialController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _radialController.forward();
    } else {
      _radialController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _localActive;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _localActive = !_localActive;
              });
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _isHovered ? const Color(0xFF292929) : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _isHovered ? const Color(0xFF666666) : const Color(0xFF2C2C2C),
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Radial Gradient Effect
                  Positioned.fill(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _radialScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _radialScale.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.15),
                                    Colors.white.withOpacity(0),
                                  ],
                                  stops: const [0.0, 0.7],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Icon with fill animation
                  Center(
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      fill: active ? 1.0 : 0.0,
                      weight: 400,
                      size: 24,
                    ).animate(target: active ? 1 : 0)
                     .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 200.ms)
                     .then()
                     .scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 150.ms),
                  ),

                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

