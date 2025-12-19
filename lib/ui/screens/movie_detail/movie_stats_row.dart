import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:intl/intl.dart';

class MovieStatsRow extends StatelessWidget {
  final MovieDetails details;
  const MovieStatsRow({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, top: 24),
            child: Text(
              "Info",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildStatItem(
                  context,
                  icon: Icons.calendar_today_rounded,
                  label: 'Released',
                  value: DateFormat('MMM d, yyyy').format(details.releaseDate),
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  context,
                  icon: Icons.language_rounded,
                  label: 'Language',
                  value: details.originalLanguage.toUpperCase(),
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  context,
                  icon: Icons.attach_money_rounded,
                  label: 'Budget',
                  value: _formatCurrency(details.budget),
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  context,
                  icon: Icons.trending_up_rounded,
                  label: 'Revenue',
                  value: _formatCurrency(details.revenue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 78,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Colors.white70, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    if (amount <= 0) return 'N/A';
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(1)}B';
    }
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\$$amount';
  }
}
