import 'package:domain/src/movie_torrent_info.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'movie_info.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MovieInfo {
  final String tmdbId;
  final String imdbId;
  final double imdbVoteAverage;
  final int imdbVoteCount;
  final String kinopoiskId;
  final double kinopoiskVoteAverage;
  final int kinopoiskVoteCount;
  final String posterPath;
  final String overview;
  final DateTime releaseDate;
  final String title;
  final String backdropPath;
  final double tmdbPopularity;
  final int tmdbVoteCount;
  final double tmdbVoteAverage;
  final List<MovieTorrentInfo> torrentsInfo;

  MovieInfo(
      {@required this.tmdbId,
      @required this.imdbId,
      @required this.imdbVoteAverage,
      @required this.imdbVoteCount,
      @required this.kinopoiskId,
      @required this.kinopoiskVoteAverage,
      @required this.kinopoiskVoteCount,
      @required this.posterPath,
      @required this.overview,
      @required this.releaseDate,
      @required this.title,
      @required this.backdropPath,
      @required this.tmdbPopularity,
      @required this.tmdbVoteCount,
      @required this.tmdbVoteAverage,
      @required this.torrentsInfo});

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
