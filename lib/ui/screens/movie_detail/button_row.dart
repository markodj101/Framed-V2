import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:framed_v2/ui/screens/movie_detail/elegant_action_button.dart';

typedef OnFavoriteSelected = void Function();

class ButtonRow extends StatelessWidget {
  final bool favoriteSelected;
  final OnFavoriteSelected onFavoriteSelected;
  final int movieId;
  final double voteAverage;

  const ButtonRow({
    super.key,
    required this.favoriteSelected,
    required this.onFavoriteSelected,
    required this.movieId,
    required this.voteAverage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 0, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElegantActionButton(
            label: 'Favorite',
            icon: Symbols.favorite,
            isActive: favoriteSelected,
            onTap: onFavoriteSelected,
          ),
          const SizedBox(width: 32),
          ElegantActionButton(
            label: 'Rate',
            icon: Symbols.thumbs_up_down,
            onTap: () {},
          ),
          const SizedBox(width: 32),
          ElegantActionButton(
            label: 'Share',
            icon: Symbols.share,
            onTap: () {
              final url = 'https://www.themoviedb.org/movie/$movieId';
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: _UserScore(voteAverage: voteAverage),
          ),
        ],
      ),
    );
  }
}

class _UserScore extends StatelessWidget {
  final double voteAverage;

  const _UserScore({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    final percentage = voteAverage.isFinite ? (voteAverage * 10).toInt() : 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        '$percentage% User Score',
        style: const TextStyle(
          color: Color(0xFF00C853), // matchGreen
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 7.0) {
      return const Color(0xFF21D07A); // Green
    } else if (score >= 5.0) {
      return const Color(0xFFD2D531); // Yellow
    } else {
      return const Color(0xFFDB2360); // Red
    }
  }
}
