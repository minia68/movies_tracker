import 'package:meta/meta.dart';

class Rating {
  final double imdbVoteAverage;
  final int imdbVoteCount;
  final double kinopoiskVoteAverage;
  final int kinopoiskVoteCount;

  Rating(
      {@required this.imdbVoteAverage,
      @required this.imdbVoteCount,
      @required this.kinopoiskVoteAverage,
      @required this.kinopoiskVoteCount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rating &&
          runtimeType == other.runtimeType &&
          imdbVoteAverage == other.imdbVoteAverage &&
          imdbVoteCount == other.imdbVoteCount &&
          kinopoiskVoteAverage == other.kinopoiskVoteAverage &&
          kinopoiskVoteCount == other.kinopoiskVoteCount;

  @override
  int get hashCode =>
      imdbVoteAverage.hashCode ^
      imdbVoteCount.hashCode ^
      kinopoiskVoteAverage.hashCode ^
      kinopoiskVoteCount.hashCode;
}
