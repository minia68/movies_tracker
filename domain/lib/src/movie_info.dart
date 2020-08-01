import 'package:domain/src/movie_torrent_info.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'movie_info.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MovieInfo {
  final int tmdbId;
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
  final String youtubeTrailerKey;

  MovieInfo({
    this.tmdbId,
    @required this.imdbId,
    this.imdbVoteAverage,
    this.imdbVoteCount,
    this.kinopoiskId,
    this.kinopoiskVoteAverage,
    this.kinopoiskVoteCount,
    this.posterPath,
    @required this.overview,
    this.releaseDate,
    @required this.title,
    this.backdropPath,
    this.tmdbPopularity,
    this.tmdbVoteCount,
    this.tmdbVoteAverage,
    @required this.torrentsInfo,
    this.youtubeTrailerKey,
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
