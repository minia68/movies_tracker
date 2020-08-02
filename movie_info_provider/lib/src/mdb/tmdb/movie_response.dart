import 'package:json_annotation/json_annotation.dart';

part 'movie_response.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Movie {
  final String posterPath;
  final String overview;
  final String releaseDate;
  final int id;
  final String title;
  final String backdropPath;
  final double popularity;
  final int voteCount;
  final double voteAverage;
  final List<Genre> genres;
  final List<ProductionCountry> productionCountries;
  final Credits credits;
  final Videos videos;

  Movie({
    this.posterPath,
    this.overview,
    this.releaseDate,
    this.id,
    this.title,
    this.backdropPath,
    this.popularity,
    this.voteCount,
    this.voteAverage,
    this.genres,
    this.productionCountries,
    this.credits,
    this.videos,
  });
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Genre {
  final int id;
  final String name;

  Genre({this.id, this.name});
  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class ProductionCountry {
  @JsonKey(name: 'iso_3166_1')
  final String code;
  final String name;

  ProductionCountry({this.code, this.name});
  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Credits {
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({this.cast, this.crew});
  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cast {
  final int id;
  final String name;
  final String character;
  final int order;
  final String profilePath;

  Cast({this.id, this.name, this.character, this.order, this.profilePath});
  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Crew {
  final int id;
  final String name;
  final String job;
  final String profilePath;

  Crew({this.id, this.name, this.job, this.profilePath});
  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Videos {
  final List<Video> results;

  Videos({this.results});
  factory Videos.fromJson(Map<String, dynamic> json) => _$VideosFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Video {
  final String key;
  final String site;
  final String type;

  Video({this.key, this.site, this.type});
  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
