import 'package:domain/domain.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_info_provider/movie_info_provider.dart';
import 'package:movie_info_provider/src/mdb/mdb_datasource.dart';
import 'package:movie_info_provider/src/mdb/mdb_movie_info.dart';
import 'package:movie_info_provider/src/rating/rating.dart';
import 'package:movie_info_provider/src/rating/rating_data_source.dart';
import 'package:movie_info_provider/src/tracker/detail_result.dart';
import 'package:movie_info_provider/src/tracker/rutor/search_parser.dart';
import 'package:movie_info_provider/src/tracker/search_result.dart';
import 'package:movie_info_provider/src/tracker/tracker_datasource.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  TrackerDataSource trackerDataSource;
  RatingDataSource ratingDataSource;
  MdbDataSource mdbDataSource;
  MovieInfoProvider ds;
  final trackerSearchUrl = 'trackerSearchUrl';

  setUp(() {
    trackerDataSource = MockTrackerDataSource();
    ratingDataSource = MockRatingDataSource();
    mdbDataSource = MockMdbDataSource();
    ds = MovieInfoProvider(trackerDataSource, ratingDataSource,
        mdbDataSource, trackerSearchUrl);
  });

  test('loadTopSeedersFhdMovies', () async {
    when(trackerDataSource.search(any)).thenAnswer((_) async => [
          SearchResult('detailUrl'),
          SearchResult('detailUrl1'),
          SearchResult('detailUrl2'),
          SearchResult('detailUrl3'),
        ]);

    when(trackerDataSource.getDetail(SearchResult('detailUrl'))).thenAnswer(
        (_) async => DetailResult(
            imdbId: 'imdbId',
            kinopoiskId: 'kinopoiskId',
            leechers: 1,
            magnetUrl: 'magnetUrl',
            seeders: 2,
            size: 3,
            title: 'title'));
    when(trackerDataSource.getDetail(SearchResult('detailUrl1')))
        // ignore: missing_required_param
        .thenAnswer((_) async => DetailResult(
              imdbId: 'imdbId1',
              kinopoiskId: 'kinopoiskId1',
            ));
    when(trackerDataSource.getDetail(SearchResult('detailUrl2')))
        .thenAnswer((_) async => DetailResult(
              imdbId: 'imdbId',
              kinopoiskId: 'kinopoiskId',
              leechers: 11,
              magnetUrl: 'magnetUrl1',
              seeders: 21,
              size: 31,
              title: 'title1',
            ));
    when(trackerDataSource.getDetail(SearchResult('detailUrl3'))).thenAnswer(
        (_) async => throw SearchParserException('test'));

    when(ratingDataSource.getRating(any)).thenAnswer((_) async => Rating(
          imdbVoteAverage: 1,
          imdbVoteCount: 2,
          kinopoiskVoteAverage: 3,
          kinopoiskVoteCount: 4,
        ));
    var date = DateTime.now();
    when(mdbDataSource.getMovieInfo('imdbId'))
        .thenAnswer((_) async => MdbMovieInfo(
              id: '5',
              posterPath: 'posterPath',
              overview: 'overview',
              releaseDate: date,
              title: 'title',
              backdropPath: 'backdropPath',
              popularity: 6,
              voteAverage: 7,
              voteCount: 8,
            ));
    when(mdbDataSource.getMovieInfo('imdbId1'))
        // ignore: missing_required_param
        .thenAnswer((_) async => MdbMovieInfo(id: '2'));

    var movieInfo = getTestMovieInfo(date);

    final response = await ds.getTopSeedersFhdMovies(existing: [
      // ignore: missing_required_param
      MovieInfo(
        imdbId: 'imdbId3',
        torrentsInfo: [
          MovieTorrentInfo(
            magnetUrl: 'magnetUrl',
            seeders: 22,
            size: 32,
            title: 'title2',
            leechers: 12,
          ),
        ],
      )
    ]);
    expect(response.length, 2);
    testMovieInfo(response[0], movieInfo);

    expect(response[1].imdbId, 'imdbId1');
    expect(response[1].kinopoiskId, 'kinopoiskId1');
  });
}

class MockRemoteDataSource extends Mock implements MovieInfoProvider {}

class MockTrackerDataSource extends Mock implements TrackerDataSource {}

class MockRatingDataSource extends Mock implements RatingDataSource {}

class MockMdbDataSource extends Mock implements MdbDataSource {}
