import 'package:framed_v2/data/models/movie_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/movie_widget.dart';
import 'package:framed_v2/data/models/movie.dart';

class HorizontalMovies extends ConsumerWidget {
  final MovieType movieType;
  final OnMovieTap onMovieTap;
  final List<MovieResults> movies;

  const HorizontalMovies({
    required this.onMovieTap,
    required this.movies,
    required this.movieType,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieViewModelProvider);
    return movieAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => Container(),
      data: (viewModel) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: movies.length > 10 ? 10 : movies.length,
            itemBuilder: (context, index) {
              final imageUrl = viewModel.getImageUrl(
                ImageSize.small,
                movies[index].posterPath,
              );
              return imageUrl != null
                  ? Center(
                      child: MovieWidget(
                        movieId: movies[index].id,
                        movieUrl: imageUrl,
                        onMovieTap: onMovieTap,
                        movieType: movieType,
                      ),
                    )
                  : emptyWidget;
            },
          ),
        );
      },
    );
  }
}
