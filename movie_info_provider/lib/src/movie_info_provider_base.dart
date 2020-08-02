import 'package:domain/domain.dart';
import 'package:logging/logging.dart';

import 'mdb/mdb_datasource.dart';
import 'mdb/mdb_movie_info.dart';
import 'rating/rating.dart';
import 'rating/rating_data_source.dart';
import 'tracker/detail_result.dart';
import 'tracker/search_result.dart';
import 'tracker/tracker_datasource.dart';

final _logger = Logger('MovieInfoProvider');

class MovieInfoProvider {
  final TrackerDataSource _trackerDataSource;
  final RatingDataSource _ratingDataSource;
  final MdbDataSource _mdbDataSource;
  final String _trackerSearchUrl;

  MovieInfoProvider(this._trackerDataSource, this._ratingDataSource,
      this._mdbDataSource, this._trackerSearchUrl);

  Future<String> getImageBasePath() {
    return _mdbDataSource.getImageBasePath();
  }

  Future<List<MovieInfo>> getTopSeedersFhdMovies(
      {List<MovieInfo> existing}) async {
    existing ??= [];

    _logger.fine('start loading tracker search $_trackerSearchUrl');
    final searchResults = await _trackerDataSource.search(_trackerSearchUrl);
    _logger.fine('load ${searchResults.length} search results');

    final newIds = <String>[];
    final ratingUpdated = <String, List<String>>{};

    for (var searchResult in searchResults) {
      _logger.fine('start loading tracker detail ${searchResult.detailUrl}');
      DetailResult detailResult;
      try {
        detailResult = await _trackerDataSource.getDetail(searchResult);
      } catch (e, s) {
        _logger.warning('error parsing detail page', e, s);
        continue;
      }

      newIds.add(detailResult.imdbId);
      final movieInfo = existing.firstWhere(
          (movieInfo) => movieInfo.imdbId == detailResult.imdbId,
          orElse: () => null);
      if (movieInfo != null) {
        await _update(searchResult, detailResult, movieInfo, ratingUpdated);
      } else {
        final newMovieInfo =
            await _create(searchResult, detailResult, ratingUpdated);
        if (newMovieInfo != null) {
          existing.add(newMovieInfo);
        }
      }
    }
    return existing
        .where(
            (movieInfo) => newIds.any((imdbId) => imdbId == movieInfo.imdbId))
        .toList();
  }

  Future _update(
    SearchResult searchResult,
    DetailResult detailResult,
    MovieInfo movieInfo,
    Map<String, List<String>> raitingUpdated,
  ) async {
    _logger.fine('find existing imdbId ${detailResult.imdbId}');
    final torrentsInfo = movieInfo.torrentsInfo ??= [];

    if (!raitingUpdated.containsKey(detailResult.imdbId)) {
      _logger.fine('get raiting ${detailResult.imdbId}');
      final rating = await _getRating(detailResult);
      movieInfo.raiting = MovieRaiting(
        imdbVoteAverage: rating.imdbVoteAverage,
        imdbVoteCount: rating.imdbVoteCount,
        kinopoiskVoteAverage: rating.kinopoiskVoteAverage,
        kinopoiskVoteCount: rating.kinopoiskVoteCount,
      );
      raitingUpdated[detailResult.imdbId] = [detailResult.magnetUrl];
      torrentsInfo.clear();
    } else {
      raitingUpdated[detailResult.imdbId].add(detailResult.magnetUrl);
    }

    final torrentsInfoIdx = torrentsInfo.indexWhere(
        (torrentsInfo) => torrentsInfo.magnetUrl == detailResult.magnetUrl);
    final movieTorrentInfo = _toMovieTorrentInfo(searchResult, detailResult);
    if (torrentsInfoIdx == -1) {
      _logger.fine('add torrentsInfo ${detailResult.imdbId}');
      torrentsInfo.add(movieTorrentInfo);
    } else {
      _logger.fine('find existing torrentsInfo ${detailResult.magnetUrl}');
      torrentsInfo[torrentsInfoIdx] = movieTorrentInfo;
    }
  }

  Future<MovieInfo> _create(
    SearchResult searchResult,
    DetailResult detailResult,
    Map<String, List<String>> raitingUpdated,
  ) async {
    raitingUpdated[detailResult.imdbId] = [detailResult.magnetUrl];
    final rating = await _getRating(detailResult);

    MdbMovieInfo movieInfo;
    try {
      _logger.fine('start loading mdb info ${detailResult.imdbId}');
      movieInfo = await _mdbDataSource.getMovieInfo(detailResult.imdbId);
    } catch (e, s) {
      _logger.warning('error get mdb info ${detailResult.imdbId}', e, s);
    }
    if (movieInfo == null) {
      return null;
    }

    return MovieInfo(
      tmdbId: int.parse(movieInfo.id),
      imdbId: detailResult.imdbId,
      raiting: MovieRaiting(
        imdbVoteAverage: rating.imdbVoteAverage,
        imdbVoteCount: rating.imdbVoteCount,
        kinopoiskVoteAverage: rating.kinopoiskVoteAverage,
        kinopoiskVoteCount: rating.kinopoiskVoteCount,
      ),
      kinopoiskId: detailResult.kinopoiskId,
      posterPath: movieInfo.posterPath,
      overview: movieInfo.overview,
      releaseDate: movieInfo.releaseDate,
      title: movieInfo.title,
      backdropPath: movieInfo.backdropPath,
      tmdbPopularity: movieInfo.popularity,
      tmdbVoteCount: movieInfo.voteCount,
      tmdbVoteAverage: movieInfo.voteAverage,
      torrentsInfo: [_toMovieTorrentInfo(searchResult, detailResult)],
      youtubeTrailerKey: movieInfo.youtubeTrailerKey,
      genres: movieInfo.genres,
      productionCountries:
          movieInfo.productionCountries?.map((e) => e.name)?.toList(),
      cast: movieInfo.cast
          ?.map((e) => MovieCast(
                character: e.character,
                name: e.name,
                profilePath: e.posterPath,
              ))
          ?.toList(),
      crew: movieInfo.crew
          ?.map((e) => MovieCrew(
                job: e.job,
                name: e.name,
                profilePath: e.posterPath,
              ))
          ?.toList(),
    );
  }

  MovieTorrentInfo _toMovieTorrentInfo(
      SearchResult searchResult, DetailResult detailResult) {
    return MovieTorrentInfo(
        magnetUrl: detailResult.magnetUrl,
        title: detailResult.title,
        size: detailResult.size,
        seeders: detailResult.seeders,
        leechers: detailResult.leechers);
  }

  Future<Rating> _getRating(DetailResult detailResult) async {
    Rating rating;
    try {
      _logger.fine('start loading rating ${detailResult.kinopoiskId}');
      rating = await _ratingDataSource.getRating(detailResult.kinopoiskId);
    } catch (e, s) {
      _logger.warning('error get rating ${detailResult.imdbId}', e, s);
      rating = Rating(
          imdbVoteAverage: 0,
          imdbVoteCount: 0,
          kinopoiskVoteAverage: 0,
          kinopoiskVoteCount: 0);
    }
    return rating;
  }
}
