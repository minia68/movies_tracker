import 'package:json_annotation/json_annotation.dart';

part 'find_response.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class FindResponse {
  final List<MovieResult> movieResults;

  FindResponse({this.movieResults});

  factory FindResponse.fromJson(Map<String, dynamic> json) =>
      _$FindResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class MovieResult {
  final String posterPath;
  final String overview;
  final String releaseDate;
  final int id;
  final String title;
  final String backdropPath;
  final double popularity;
  final int voteCount;
  final double voteAverage;

  MovieResult(
      {this.posterPath,
      this.overview,
      this.releaseDate,
      this.id,
      this.title,
      this.backdropPath,
      this.popularity,
      this.voteCount,
      this.voteAverage});

  factory MovieResult.fromJson(Map<String, dynamic> json) =>
      _$MovieResultFromJson(json);
}
