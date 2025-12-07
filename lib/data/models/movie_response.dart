import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framed_v2/data/models/movie_results.dart';

part 'movie_response.freezed.dart';
part 'movie_response.g.dart';

@freezed
class MovieResponse with _$MovieResponse {
  const factory MovieResponse({
    required int page,
    required List<MovieResults> results,
    @JsonKey(name: 'total_pages') required int total_pages,
    @JsonKey(name: 'total_results') required int total_results,
  }) = _MovieResponse;

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}
