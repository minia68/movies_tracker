import 'package:meta/meta.dart';

class MdbMovieInfo {
  final String id;
  final String posterPath;
  final String overview;
  final DateTime releaseDate;
  final String title;
  final String backdropPath;
  final double popularity;
  final int voteCount;
  final double voteAverage;

  MdbMovieInfo({
    @required this.id,
    @required this.posterPath,
    @required this.overview,
    @required this.releaseDate,
    @required this.title,
    @required this.backdropPath,
    @required this.popularity,
    @required this.voteCount,
    @required this.voteAverage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MdbMovieInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          posterPath == other.posterPath &&
          overview == other.overview &&
          releaseDate == other.releaseDate &&
          title == other.title &&
          backdropPath == other.backdropPath &&
          popularity == other.popularity &&
          voteCount == other.voteCount &&
          voteAverage == other.voteAverage;

  @override
  int get hashCode =>
      id.hashCode ^
      posterPath.hashCode ^
      overview.hashCode ^
      releaseDate.hashCode ^
      title.hashCode ^
      backdropPath.hashCode ^
      popularity.hashCode ^
      voteCount.hashCode ^
      voteAverage.hashCode;

  @override
  String toString() {
    return 'MdbMovieInfo{id: $id, posterPath: $posterPath, overview: $overview, releaseDate: $releaseDate, title: $title, backdropPath: $backdropPath, popularity: $popularity, voteCount: $voteCount, voteAverage: $voteAverage}';
  }
}
