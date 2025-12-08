import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/home/home_screen_image.dart';
import 'package:framed_v2/movie_row.dart';

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
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: movies.length, (
        BuildContext context,
        int index,
      ) {
        return MovieRow(
          movie: movies[index],
          movieViewModel: movieViewModel,
          onMovieTap: (movie) {
            onMovieTap(movie.id);
          },
        );
      }),
    );
  }
}
