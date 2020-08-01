// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieInfo _$MovieInfoFromJson(Map<String, dynamic> json) {
  return MovieInfo(
    tmdbId: json['tmdbId'] as int,
    imdbId: json['imdbId'] as String,
    imdbVoteAverage: (json['imdbVoteAverage'] as num)?.toDouble(),
    imdbVoteCount: json['imdbVoteCount'] as int,
    kinopoiskId: json['kinopoiskId'] as String,
    kinopoiskVoteAverage: (json['kinopoiskVoteAverage'] as num)?.toDouble(),
    kinopoiskVoteCount: json['kinopoiskVoteCount'] as int,
    posterPath: json['posterPath'] as String,
    overview: json['overview'] as String,
    releaseDate: json['releaseDate'] == null
        ? null
        : DateTime.parse(json['releaseDate'] as String),
    title: json['title'] as String,
    backdropPath: json['backdropPath'] as String,
    tmdbPopularity: (json['tmdbPopularity'] as num)?.toDouble(),
    tmdbVoteCount: json['tmdbVoteCount'] as int,
    tmdbVoteAverage: (json['tmdbVoteAverage'] as num)?.toDouble(),
    torrentsInfo: (json['torrentsInfo'] as List)
        ?.map((e) => e == null
            ? null
            : MovieTorrentInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    youtubeTrailerKey: json['youtubeTrailerKey'] as String,
    credits: json['credits'] == null
        ? null
        : MovieCredits.fromJson(json['credits'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MovieInfoToJson(MovieInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tmdbId', instance.tmdbId);
  writeNotNull('imdbId', instance.imdbId);
  writeNotNull('imdbVoteAverage', instance.imdbVoteAverage);
  writeNotNull('imdbVoteCount', instance.imdbVoteCount);
  writeNotNull('kinopoiskId', instance.kinopoiskId);
  writeNotNull('kinopoiskVoteAverage', instance.kinopoiskVoteAverage);
  writeNotNull('kinopoiskVoteCount', instance.kinopoiskVoteCount);
  writeNotNull('posterPath', instance.posterPath);
  writeNotNull('overview', instance.overview);
  writeNotNull('releaseDate', instance.releaseDate?.toIso8601String());
  writeNotNull('title', instance.title);
  writeNotNull('backdropPath', instance.backdropPath);
  writeNotNull('tmdbPopularity', instance.tmdbPopularity);
  writeNotNull('tmdbVoteCount', instance.tmdbVoteCount);
  writeNotNull('tmdbVoteAverage', instance.tmdbVoteAverage);
  writeNotNull(
      'torrentsInfo', instance.torrentsInfo?.map((e) => e?.toJson())?.toList());
  writeNotNull('youtubeTrailerKey', instance.youtubeTrailerKey);
  writeNotNull('credits', instance.credits?.toJson());
  return val;
}
