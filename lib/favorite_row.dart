import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';

class FavoriteRow extends StatelessWidget {
  final Favorite favorite;
  final MovieViewModel movieViewModel;
  final OnMovieTap onMovieTap;
  final OnFavoriteResultsTap onFavoriteResultsTap;
  const FavoriteRow({
    super.key,
    required this.favorite,
    required this.movieViewModel,
    required this.onMovieTap,
    required this.onFavoriteResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textWidth = screenWidth - 132;
    final imageUrl = movieViewModel.getImageUrl(
      ImageSize.small,
      favorite.image,
    );
    return GestureDetector(
      onTap: () => onMovieTap(favorite.movieId),

      child: SizedBox(
        height: 148,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            addHorizontalSpace(16),
            SizedBox(
              height: 140,
              width: 100,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      height: 140,
                      width: 100,
                    )
                  : emptyWidget,
            ),
            addHorizontalSpace(16),
            Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => onFavoriteResultsTap(favorite),
                    icon: favorite.favorite
                        ? const Icon(Icons.favorite_outlined, color: Colors.red)
                        : const Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                          ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: textWidth,
                          child: AutoSizeText(
                            favorite.title,
                            maxLines: 1,
                            minFontSize: 10,
                            style: Theme.of(context).textTheme.labelLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        addVerticalSpace(4),
                        Text(
                          yearFormat.format(favorite.releaseDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        addVerticalSpace(4),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
