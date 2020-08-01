import 'package:json_annotation/json_annotation.dart';

part 'movie_credits.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MovieCrew {
  final String job;
  final String name;
  final String profilePath;

  MovieCrew({this.job, this.name, this.profilePath});

  Map<String, dynamic> toJson() => _$MovieCrewToJson(this);
  factory MovieCrew.fromJson(Map<String, dynamic> json) =>
      _$MovieCrewFromJson(json);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MovieCast {
  final String character;
  final String name;
  final String profilePath;

  MovieCast({this.character, this.name, this.profilePath});

  Map<String, dynamic> toJson() => _$MovieCastToJson(this);
  factory MovieCast.fromJson(Map<String, dynamic> json) =>
      _$MovieCastFromJson(json);
}
