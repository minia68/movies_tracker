import 'package:json_annotation/json_annotation.dart';

import 'movie_response.dart';

part 'find_response.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class FindResponse {
  final List<Movie> movieResults;

  FindResponse({this.movieResults});

  factory FindResponse.fromJson(Map<String, dynamic> json) =>
      _$FindResponseFromJson(json);
}
