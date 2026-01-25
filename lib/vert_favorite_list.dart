import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/movie_widget.dart';
import 'package:framed_v2/data/models/movie_type.dart';

class VerticalFavoriteList extends StatelessWidget {
  final List<Favorite> favorites;
  final MovieViewModel movieViewModel;
  final OnMovieTap onMovieTap;
  final OnFavoriteResultsTap onFavoriteResultsTap;
  const VerticalFavoriteList({
    super.key,
    required this.favorites,
    required this.movieViewModel,
    required this.onMovieTap,
    required this.onFavoriteResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 3 : 5;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // Responsive columns
          mainAxisSpacing: 12,
          crossAxisSpacing: 6,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final favorite = favorites[index];
            // Assuming favorite.image is the full URL or path. 
            // In MovieViewModel.saveFavorite, it saves 'image: movieDetails.posterPath'.
            // So we might need to construct the URL or if it's already a URL.
            // MovieViewModel.getImageUrl uses configuration.
            // Let's check how FavoriteRow used it.
            // FavoriteRow used `movieViewModel.getImageUrl(ImageSize.medium, favorite.image)`
            
            final imageUrl = movieViewModel.getImageUrl(
              ImageSize.small, 
              favorite.image
            );

            if (imageUrl == null) return const SizedBox.shrink();

            return Stack(
              children: [
                MovieWidget(
                  movieId: favorite.movieId,
                  movieUrl: imageUrl,
                  onMovieTap: onMovieTap,
                  movieType: MovieType.similar, // Reusing similar or adding 'favorite' type? Using similar for now as it's generic enough or add 'favorite'
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => onFavoriteResultsTap(favorite),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          childCount: favorites.length,
        ),
      ),
    );
  }
}
