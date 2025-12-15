import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/data/models/models.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/data/models/movie_videos.dart';
import 'package:framed_v2/vert_movie_list.dart';
import 'package:intl/intl.dart';

Widget addVerticalSpace(double amount) {
  return SizedBox(height: amount);
}

Widget addHorizontalSpace(double amount) {
  return SizedBox(width: amount);
}

enum ImageSize { small, large }

String imageUrl(String baseUrl, String size, String file) =>
    '$baseUrl$size$file';

String? getSizedImageUrl(
  ImageSize size,
  MovieConfiguration configuration,
  String? file,
) {
  if (file == null) return null;
  switch (size) {
    case ImageSize.small:
      return imageUrl(
        configuration.images.baseUrl,
        configuration.images.posterSizes[1],
        file,
      );
    case ImageSize.large:
      return imageUrl(
        configuration.images.baseUrl,
        configuration.images.posterSizes[5],
        file,
      );
  }
}

String? getMovieDetailsImagePath(
  MovieDetails details,
  MovieConfiguration configuration,
) {
  return getSizedImageUrl(ImageSize.large, configuration, details.backdropPath);
}

final yearFormat = DateFormat('yyyy');
String youtubeImageFromId(String videoId) {
  return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
}

enum Sorting {
  aToz(name: 'A-Z'),
  zToa(name: 'Z-A'),
  rating(name: 'Rating'),
  year(name: 'Year');

  const Sorting({required this.name});
  final String name;
}

String youtubeUrlFromId(String videoId) {
  return 'https://www.youtube.com/watch?v=$videoId';
}

typedef OnMovieTap = void Function(int movieId);

typedef OnMovieVideoTap = void Function(MovieVideo video);

typedef OnFavoriteResultsTap = void Function(Favorite favorite);

typedef OnMovieResultsTap = void Function(MovieResults movie);
const Widget emptyWidget = SizedBox.shrink();
