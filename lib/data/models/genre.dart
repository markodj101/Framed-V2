import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
class Genre with _$Genre {
  @HiveType(typeId: 1, adapterName: 'GenreAdapter')
  const factory Genre({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@freezed
class Genres with _$Genres {
  const factory Genres({required List<Genre> genres}) = _Genres;

  factory Genres.fromJson(Map<String, dynamic> json) => _$GenresFromJson(json);
}
