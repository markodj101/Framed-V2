// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieResponseImpl _$$MovieResponseImplFromJson(Map<String, dynamic> json) =>
    _$MovieResponseImpl(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieResults.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_pages: (json['total_pages'] as num).toInt(),
      total_results: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$$MovieResponseImplToJson(_$MovieResponseImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.total_pages,
      'total_results': instance.total_results,
    };
