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
      final torrentsInfo = existing
          .firstWhere((movieInfo) => movieInfo.imdbId == detailResult.imdbId,
              orElse: () => null)
          ?.torrentsInfo;
      if (torrentsInfo != null) {
        _logger.fine('find existing imdbId ${detailResult.imdbId}');
        final torrentsInfoIdx = torrentsInfo.indexWhere(
            (torrentsInfo) => torrentsInfo.magnetUrl == detailResult.magnetUrl);
        final movieTorrentInfo =
            _toMovieTorrentInfo(searchResult, detailResult);
        if (torrentsInfoIdx == -1) {
          _logger.fine('add torrentsInfo ${detailResult.imdbId}');
          torrentsInfo.add(movieTorrentInfo);
        } else {
          _logger.fine('find existing torrentsInfo ${detailResult.magnetUrl}');
          torrentsInfo[torrentsInfoIdx] = movieTorrentInfo;
        }
      } else {
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

        MdbMovieInfo movieInfo;
        try {
          _logger.fine('start loading mdb info ${detailResult.imdbId}');
          movieInfo = await _mdbDataSource.getMovieInfo(detailResult.imdbId);
        } catch (e, s) {
          _logger.warning('error get mdb info ${detailResult.imdbId}', e, s);
        }
        if (movieInfo == null) {
          continue;
        }

        existing.add(MovieInfo(
          tmdbId: movieInfo.id,
          imdbId: detailResult.imdbId,
          imdbVoteAverage: rating.imdbVoteAverage,
          imdbVoteCount: rating.imdbVoteCount,
          kinopoiskId: detailResult.kinopoiskId,
          kinopoiskVoteAverage: rating.kinopoiskVoteAverage,
          kinopoiskVoteCount: rating.kinopoiskVoteCount,
          posterPath: movieInfo.posterPath,
          overview: movieInfo.overview,
          releaseDate: movieInfo.releaseDate,
          title: movieInfo.title,
          backdropPath: movieInfo.backdropPath,
          tmdbPopularity: movieInfo.popularity,
          tmdbVoteCount: movieInfo.voteCount,
          tmdbVoteAverage: movieInfo.voteAverage,
          torrentsInfo: [_toMovieTorrentInfo(searchResult, detailResult)],
        ));
      }
    }
    return existing
        .where(
            (movieInfo) => newIds.any((imdbId) => imdbId == movieInfo.imdbId))
        .toList();
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
}
