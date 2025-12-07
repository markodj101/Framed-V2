import "package:freezed_annotation/freezed_annotation.dart";
import 'package:intl/intl.dart';
part 'movie_results.freezed.dart';
part 'movie_results.g.dart';

DateTime? _parseDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return null;
  }
  return DateFormat('yyyy-MM-dd').parse(dateString);
}

@freezed
class MovieResults with _$MovieResults {
  const factory MovieResults({
    @JsonKey(name: 'backdrop_path') String? backdrop_path,

    required int id,
    @JsonKey(name: 'original_title') required String originalTitle,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'media_type') String? mediaType,
    required bool adult,
    required String title,
    @JsonKey(name: 'original_language') required String originalLanguage,
    @JsonKey(name: 'genre_ids') required List<int> genreIds,
    required double popularity,

    @JsonKey(name: 'release_date', fromJson: _parseDate) DateTime? releaseDate,
    required bool video,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'vote_count') required int voteCount,
  }) = _MovieResults;

  factory MovieResults.fromJson(Map<String, dynamic> json) =>
      _$MovieResultsFromJson(json);
}
