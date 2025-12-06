import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/movie_widget.dart';
import 'package:framed_v2/data/models/movie.dart';

class HorizontalMovies extends StatelessWidget {
  final MovieType movieType;
  final OnMovieTap onMovieTap;
  final List<Movie> movies;

  const HorizontalMovies({
    required this.onMovieTap,
    required this.movies,
    required this.movieType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieWidget(
            movie: movies[index],
            onMovieTap: onMovieTap,
            movieType: movieType,
          );
        },
      ),
    );
  }
}
