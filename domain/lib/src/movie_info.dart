import 'package:domain/src/movie_credits.dart';
import 'package:domain/src/movie_torrent_info.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'movie_info.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MovieInfo {
  final int tmdbId;
  final String imdbId;
  final String kinopoiskId;
  final String posterPath;
  final String overview;
  final DateTime releaseDate;
  final String title;
  final String backdropPath;
  final double tmdbPopularity;
  final int tmdbVoteCount;
  final double tmdbVoteAverage;
  MovieRaiting raiting;
  List<MovieTorrentInfo> torrentsInfo;
  final String youtubeTrailerKey;
  final List<MovieCrew> crew;
  final List<MovieCast> cast;
  final List<String> genres;
  final List<String> productionCountries;

  MovieInfo({
    this.tmdbId,
    @required this.imdbId,
    this.kinopoiskId,
    this.posterPath,
    @required this.overview,
    this.releaseDate,
    @required this.title,
    this.backdropPath,
    this.tmdbPopularity,
    this.tmdbVoteCount,
    this.tmdbVoteAverage,
    this.raiting,
    @required this.torrentsInfo,
    this.youtubeTrailerKey,
    this.cast,
    this.crew,
    this.productionCountries,
    this.genres,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieInfo &&
          runtimeType == other.runtimeType &&
          imdbId == other.imdbId;

  @override
  @JsonKey(ignore: true)
  int get hashCode => imdbId.hashCode;

  Map<String, dynamic> toJson() => _$MovieInfoToJson(this);
  factory MovieInfo.fromJson(Map<String, dynamic> json) =>
      _$MovieInfoFromJson(json);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MovieRaiting {
  final double imdbVoteAverage;
  final int imdbVoteCount;
  final double kinopoiskVoteAverage;
  final int kinopoiskVoteCount;

  MovieRaiting({
    this.imdbVoteAverage,
    this.imdbVoteCount,
    this.kinopoiskVoteAverage,
    this.kinopoiskVoteCount,
  });
  Map<String, dynamic> toJson() => _$MovieRaitingToJson(this);
  factory MovieRaiting.fromJson(Map<String, dynamic> json) =>
      _$MovieRaitingFromJson(json);
}
