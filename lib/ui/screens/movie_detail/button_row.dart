import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:framed_v2/ui/screens/movie_detail/elegant_action_button.dart';

typedef OnFavoriteSelected = void Function();

class ButtonRow extends StatelessWidget {
  final bool favoriteSelected;
  final OnFavoriteSelected onFavoriteSelected;
  final int movieId;

  const ButtonRow({
    super.key,
    required this.favoriteSelected,
    required this.onFavoriteSelected,
    required this.movieId,
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
        ],
      ),
    );
  }
}


