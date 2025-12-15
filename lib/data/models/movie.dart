import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final int movieId;
  @HiveField(1)
  final String image;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String overview;
  @HiveField(4)
  final double popularity;
  @HiveField(5)
  final DateTime releaseDate;

  Movie({
    required this.movieId,
    required this.image,
    required this.title,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
  });
}
