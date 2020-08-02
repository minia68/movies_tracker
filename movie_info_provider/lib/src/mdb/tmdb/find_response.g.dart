// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindResponse _$FindResponseFromJson(Map<String, dynamic> json) {
  return FindResponse(
    movieResults: (json['movie_results'] as List)
        ?.map(
            (e) => e == null ? null : Movie.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
