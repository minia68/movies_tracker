import 'package:domain/domain.dart';
import 'package:test/test.dart';

MovieInfo getTestMovieInfo(DateTime date) {
  return MovieInfo(
    backdropPath: 'backdropPath',
    imdbId: 'imdbId',
    imdbVoteAverage: 1,
    imdbVoteCount: 2,
    kinopoiskId: 'kinopoiskId',
    kinopoiskVoteAverage: 3,
    kinopoiskVoteCount: 4,
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: date,
    title: 'title',
    tmdbId: '5',
    tmdbPopularity: 6,
    tmdbVoteAverage: 7,
    tmdbVoteCount: 8,
    torrentsInfo: [
      MovieTorrentInfo(
        leechers: 1,
        magnetUrl: 'magnetUrl',
        seeders: 2,
        size: 3,
        title: 'title',
      ),
      MovieTorrentInfo(
        leechers: 11,
        magnetUrl: 'magnetUrl1',
        seeders: 21,
        size: 31,
        title: 'title1',
      )
    ],
  );
}

void testMovieInfo(MovieInfo movieInfoRes, MovieInfo movieInfo) {
  expect(movieInfoRes.backdropPath, movieInfo.backdropPath);
  expect(movieInfoRes.imdbId, movieInfo.imdbId);
  expect(movieInfoRes.imdbVoteAverage, movieInfo.imdbVoteAverage);
  expect(movieInfoRes.imdbVoteCount, movieInfo.imdbVoteCount);
  expect(movieInfoRes.kinopoiskId, movieInfo.kinopoiskId);
  expect(movieInfoRes.kinopoiskVoteAverage, movieInfo.kinopoiskVoteAverage);
  expect(movieInfoRes.kinopoiskVoteCount, movieInfo.kinopoiskVoteCount);
  expect(movieInfoRes.overview, movieInfo.overview);
  expect(movieInfoRes.posterPath, movieInfo.posterPath);
  expect(movieInfoRes.releaseDate, movieInfo.releaseDate);
  expect(movieInfoRes.title, movieInfo.title);
  expect(movieInfoRes.tmdbPopularity, movieInfo.tmdbPopularity);
  expect(movieInfoRes.tmdbVoteAverage, movieInfo.tmdbVoteAverage);
  expect(movieInfoRes.tmdbVoteCount, movieInfo.tmdbVoteCount);

  expect(movieInfoRes.torrentsInfo.length, movieInfo.torrentsInfo.length);
  for (var i = 0; i < movieInfoRes.torrentsInfo.length; i++) {
    testMovieTorrentInfo(
        movieInfoRes.torrentsInfo[i], movieInfo.torrentsInfo[i]);
  }
}

void testMovieTorrentInfo(
    MovieTorrentInfo torrentsInfoRes, MovieTorrentInfo torrentsInfo) {
  expect(torrentsInfoRes.leechers, torrentsInfo.leechers);
  expect(torrentsInfoRes.magnetUrl, torrentsInfo.magnetUrl);
  expect(torrentsInfoRes.seeders, torrentsInfo.seeders);
  expect(torrentsInfoRes.size, torrentsInfo.size);
  expect(torrentsInfoRes.title, torrentsInfo.title);
}
