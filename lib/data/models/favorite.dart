import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite {
  @HiveField(0)
  final int movieId;
  @HiveField(1)
  final String image;
  @HiveField(2)
  bool favorite;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String overview;
  @HiveField(5)
  final double popularity;
  @HiveField(6)
  final DateTime releaseDate;

  Favorite({
    required this.movieId,
    required this.image,
    required this.favorite,
    required this.title,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
  });
}
