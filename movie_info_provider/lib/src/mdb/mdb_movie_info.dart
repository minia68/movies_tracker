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
  final String youtubeTrailerKey;
  final List<MdbMovieCast> cast;
  final List<MdbMovieCrew> crew;
  final List<MdbMovieCountry> productionCountries;
  final List<String> genres;

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
    @required this.youtubeTrailerKey,
    @required this.cast,
    @required this.crew,
    @required this.productionCountries,
    @required this.genres,
  });

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is MdbMovieInfo &&
  //         runtimeType == other.runtimeType &&
  //         id == other.id &&
  //         posterPath == other.posterPath &&
  //         overview == other.overview &&
  //         releaseDate == other.releaseDate &&
  //         title == other.title &&
  //         backdropPath == other.backdropPath &&
  //         popularity == other.popularity &&
  //         voteCount == other.voteCount &&
  //         voteAverage == other.voteAverage &&
  //         youtubeTrailerKey == other.youtubeTrailerKey;

  // @override
  // int get hashCode =>
  //     id.hashCode ^
  //     posterPath.hashCode ^
  //     overview.hashCode ^
  //     releaseDate.hashCode ^
  //     title.hashCode ^
  //     backdropPath.hashCode ^
  //     popularity.hashCode ^
  //     voteCount.hashCode ^
  //     voteAverage.hashCode ^
  //     youtubeTrailerKey.hashCode;

  @override
  String toString() {
    return 'MdbMovieInfo{id: $id, posterPath: $posterPath, overview: $overview, releaseDate: $releaseDate, title: $title, backdropPath: $backdropPath, popularity: $popularity, voteCount: $voteCount, voteAverage: $voteAverage}';
  }
}

class MdbMovieCast {
  final String character;
  final String name;
  final String posterPath;

  MdbMovieCast({this.character, this.name, this.posterPath});

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is MdbMovieCast &&
  //         runtimeType == other.runtimeType &&
  //         character == other.character &&
  //         posterPath == other.posterPath &&
  //         name == other.name;

  // @override
  // int get hashCode => name.hashCode ^ posterPath.hashCode ^ character.hashCode;
}

class MdbMovieCrew {
  final String job;
  final String name;
  final String posterPath;

  MdbMovieCrew({this.job, this.name, this.posterPath});

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is MdbMovieCast &&
  //         runtimeType == other.runtimeType &&
  //         job == other.character &&
  //         posterPath == other.posterPath &&
  //         name == other.name;

  // @override
  // int get hashCode => name.hashCode ^ posterPath.hashCode ^ job.hashCode;
}

class MdbMovieCountry {
  final String code;
  final String name;

  MdbMovieCountry({this.code, this.name});
}
