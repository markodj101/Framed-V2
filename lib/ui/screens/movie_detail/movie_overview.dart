import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/ui/theme/theme.dart';

class MovieOverview extends StatefulWidget {
  final MovieDetails details;
  const MovieOverview({super.key, required this.details});

  @override
  State<MovieOverview> createState() => _MovieOverviewState();
}

class _MovieOverviewState extends State<MovieOverview> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Text(
              widget.details.overview,
              style: body1Regular.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _isExpanded ? "Show Less" : "...",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: _isExpanded ? 14 : 22,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

