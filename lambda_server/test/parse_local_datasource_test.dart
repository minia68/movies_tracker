import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:lambda_server/parse_local_datasource.dart';
import 'package:test/test.dart';

void main() {
  Dio dio;
  final basePath = 'parse/';

  setUpAll(() async {
    dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:1337/',
        contentType: 'application/json',
        headers: {
          'X-Parse-Application-Id': 'appId',
          'X-Parse-Master-Key': 'masterKey',
        }));
//    dio.interceptors.add(LogInterceptor(
//      responseBody: true,
//      requestBody: true,
//    ));
    final schema = json.decode(
            (await getProjectFile('script/db_schema.json')).readAsStringSync())
        as List;
    for (final classSchema in schema) {
      await dio.post<String>('parse/schemas/${classSchema['className']}',
          data: classSchema);
    }
  });

  tearDownAll(() {
    dio.close(force: true);
  });

  test('saveImageBasePath', () async {
    final ds = ParseLocalDataSource(dio, basePath: basePath);
    await ds.setImageBasePath('testPath');

    var response = await dio.get<String>('${basePath}classes/config');
    var jsonResponse = json.decode(response.data)['results'] as List;
    expect(jsonResponse.length, 1);
    expect(jsonResponse[0]['imageBasePath'], 'testPath');

    await ds.setImageBasePath('testPath1');

    response = await dio.get<String>('${basePath}classes/config');
    jsonResponse = json.decode(response.data)['results'] as List;
    expect(jsonResponse.length, 1);
    expect(jsonResponse[0]['imageBasePath'], 'testPath1');
  });

  test('setMovieInfo', () async {
    final ds = ParseLocalDataSource(dio, basePath: 'parse');
    await ds.setMovieInfo([
      MovieInfo(
        tmdbId: '1',
        imdbId: '11',
        imdbVoteAverage: 11.1,
        imdbVoteCount: 111,
        kinopoiskId: '111',
        kinopoiskVoteAverage: 21.1,
        kinopoiskVoteCount: 211,
        posterPath: 'posterPath1',
        overview: 'overview1',
        releaseDate: DateTime(2010, 01, 01),
        title: 'title1',
        backdropPath: 'backdropPath1',
        tmdbPopularity: 31.1,
        tmdbVoteCount: 311,
        tmdbVoteAverage: 311.1,
        torrentsInfo: [
          MovieTorrentInfo(
            magnetUrl: 'magnetUrl1',
            title: 'title1',
            size: 1.1,
            seeders: 11,
            leechers: 111,
          ),
          MovieTorrentInfo(
            magnetUrl: 'magnetUrl2',
            title: 'title2',
            size: 2.1,
            seeders: 21,
            leechers: 211,
          ),
        ],
      ),
    ]);

    var response =
        await dio.get<String>('${basePath}classes/movies', queryParameters: {
      'include': 'torrentsInfo',
    });
    var jsonResponse = json.decode(response.data)['results'] as List;
    expect(jsonResponse.length, 1);
    var movieInfo = jsonResponse[0] as Map;
    expect(movieInfo['tmdbId'], '1');
    expect(movieInfo['imdbId'], '11');
    expect(movieInfo['imdbVoteAverage'], 11.1);
    expect(movieInfo['imdbVoteCount'], 111);
    expect(movieInfo['kinopoiskId'], '111');
    expect(movieInfo['kinopoiskVoteAverage'], 21.1);
    expect(movieInfo['kinopoiskVoteCount'], 211);
    expect(movieInfo['posterPath'], 'posterPath1');
    expect(movieInfo['overview'], 'overview1');
    expect(movieInfo['releaseDate'], {
      '__type': 'Date',
      'iso': DateTime(2010, 01, 01).toIso8601String() + 'Z',
    });
    expect(movieInfo['title'], 'title1');
    expect(movieInfo['backdropPath'], 'backdropPath1');
    expect(movieInfo['tmdbPopularity'], 31.1);
    expect(movieInfo['tmdbVoteCount'], 311);
    expect(movieInfo['tmdbVoteAverage'], 311.1);
    var torrentsInfo = movieInfo['torrentsInfo'] as List;
    expect(torrentsInfo.length, 2);
    var torrentInfo = torrentsInfo[0] as Map;
    expect(torrentInfo['magnetUrl'], 'magnetUrl1');
    expect(torrentInfo['title'], 'title1');
    expect(torrentInfo['size'], 1.1);
    expect(torrentInfo['seeders'], 11);
    expect(torrentInfo['leechers'], 111);
    torrentInfo = torrentsInfo[1] as Map;
    expect(torrentInfo['magnetUrl'], 'magnetUrl2');
    expect(torrentInfo['title'], 'title2');
    expect(torrentInfo['size'], 2.1);
    expect(torrentInfo['seeders'], 21);
    expect(torrentInfo['leechers'], 211);

    await ds.setMovieInfo([
      MovieInfo(imdbId: '333', torrentsInfo: []),
      MovieInfo(imdbId: '444', torrentsInfo: []),
    ]);
    response = await dio.get<String>('${basePath}classes/movies');
    jsonResponse = json.decode(response.data)['results'] as List;
    expect(jsonResponse.length, 2);
    movieInfo = jsonResponse[0] as Map;
    expect(movieInfo['imdbId'], '333');
    expect(movieInfo['tmdbId'], isNull);
    expect(movieInfo['torrentsInfo'].length, 0);
    movieInfo = jsonResponse[1] as Map;
    expect(movieInfo['imdbId'], '444');
    expect(movieInfo['tmdbId'], isNull);
    expect(movieInfo['torrentsInfo'].length, 0);
  });
}

//https://stackoverflow.com/questions/58592859/reading-a-resource-from-a-file-in-a-flutter-test
Future<File> getProjectFile(String path) async {
  var dir = Directory.current;
  while (
      !await dir.list().any((entity) => entity.path.endsWith('pubspec.yaml'))) {
    dir = dir.parent;
  }
  return File('${dir.path}/$path');
}
