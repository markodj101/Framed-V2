import 'package:flutter/material.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';

class GenreRow extends StatefulWidget {
  final List<GenreState> genres;
  const GenreRow({super.key, required this.genres});

  @override
  State<GenreRow> createState() => _GenreRowState();
}

class _GenreRowState extends State<GenreRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
      child: SizedBox(
        height: 34,
        child: SlideTransition(
          position: _offsetAnimation,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: widget.genres
                .map(
                  (genre) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: buttonGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      genre.genre,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
