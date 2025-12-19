import 'package:flutter/material.dart';
import 'package:framed_v2/ui/theme/theme.dart';

class RatingDistribution extends StatelessWidget {
  final double voteAverage;
  final int voteCount;

  const RatingDistribution({
    required this.voteAverage,
    required this.voteCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy distribution data based on voteAverage
    final List<double> distribution = _generateDummyDistribution(voteAverage);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RATINGS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
              ),
              Row(
                children: [
                  Text(
                    voteAverage.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 4),
                  const Row(
                    children: [
                      Icon(Icons.star, color: matchGreen, size: 14),
                      Icon(Icons.star, color: matchGreen, size: 14),
                      Icon(Icons.star, color: matchGreen, size: 14),
                      Icon(Icons.star, color: matchGreen, size: 14),
                      Icon(Icons.star_half, color: matchGreen, size: 14),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: distribution.map((heightFactor) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 60 * heightFactor,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white12),
        ],
      ),
    );
  }

  List<double> _generateDummyDistribution(double average) {
    // Create a bell-curve-ish distribution centered around typical movie ratings
    // This is just for visual effect as requested in design
    final List<double> base = [0.1, 0.1, 0.15, 0.2, 0.3, 0.4, 0.8, 1.0, 0.6, 0.3];
    // Shift slightly based on average? Nah, let's keep it somewhat static but varied
    return base;
  }
}
