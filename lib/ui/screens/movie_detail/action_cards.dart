import 'package:flutter/material.dart';

class ActionCards extends StatelessWidget {
  const ActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCard(
              context,
              icon: Icons.visibility,
              title: 'Members',
              count: '692k',
              color: const Color(0xFF00C853), // Vibrant Green
            ),
            const SizedBox(width: 12),
            _buildCard(
              context,
              icon: Icons.description,
              title: 'Reviews',
              count: '268k',
              color: const Color(0xFF546E7A), // Blue Grey
            ),
            const SizedBox(width: 12),
            _buildCard(
              context,
              icon: Icons.featured_play_list,
              title: 'Lists',
              count: '117k',
              color: const Color(0xFF039BE5), // Sky Blue
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            count,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(230),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
