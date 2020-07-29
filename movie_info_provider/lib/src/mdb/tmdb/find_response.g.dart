// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindResponse _$FindResponseFromJson(Map<String, dynamic> json) {
  return FindResponse(
    movieResults: (json['movie_results'] as List)
        ?.map((e) =>
            e == null ? null : MovieResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

MovieResult _$MovieResultFromJson(Map<String, dynamic> json) {
  return MovieResult(
    posterPath: json['poster_path'] as String,
    overview: json['overview'] as String,
    releaseDate: json['release_date'] as String,
    id: json['id'] as int,
    title: json['title'] as String,
    backdropPath: json['backdrop_path'] as String,
    popularity: (json['popularity'] as num)?.toDouble(),
    voteCount: json['vote_count'] as int,
    voteAverage: (json['vote_average'] as num)?.toDouble(),
  );
}
