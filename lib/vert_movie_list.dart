import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/home/home_screen_image.dart';
import 'package:framed_v2/movie_row.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:framed_v2/movie_widget.dart';

typedef OnMovieTap = void Function(int movieId);

class VerticalMovieList extends StatelessWidget {
  final List<MovieResults> movies;
  final MovieViewModel movieViewModel;
  final OnMovieTap onMovieTap;
  const VerticalMovieList({
    super.key,
    required this.movies,
    required this.onMovieTap,
    required this.movieViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 6,
          childAspectRatio: 0.62, // Adjusted for 4 columns
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: movies.length,
          (context, index) {
            final movie = movies[index];
            final imageUrl = movieViewModel.getImageUrl(
              ImageSize.small,
              movie.posterPath,
            );
            
            if (imageUrl == null) return const SizedBox.shrink();

            return Center(
              child: MovieWidget(
                movieId: movie.id,
                movieUrl: imageUrl,
                onMovieTap: onMovieTap,
                movieType: MovieType.trending, // Providing a default MovieType for animation
              ),
            );
          },
        ),
      ),
    );
  }
}
