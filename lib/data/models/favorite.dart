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

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      movieId: json['movie_id'] as int,
      image: json['image'] as String? ?? '',
      favorite: true,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      releaseDate: DateTime.tryParse(json['release_date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
      'image': image,
      'title': title,
      'overview': overview,
      'popularity': popularity,
      'release_date': releaseDate.toIso8601String(),
    };
  }
}
