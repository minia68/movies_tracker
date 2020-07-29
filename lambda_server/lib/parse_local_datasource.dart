import 'dart:convert' as convert;
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

class ParseLocalDataSource {
  final Dio dio;
  final String basePath;
  final String configPath = 'classes/config';
  final String moviesPath = 'classes/movies';
  final String torrentsInfoPath = 'classes/torrentsInfo';

  ParseLocalDataSource(this.dio, {String basePath = ''})
      : basePath = basePath == null || basePath.isEmpty
            ? ''
            : basePath.endsWith('/') ? basePath : basePath + '/';

  Future<void> setImageBasePath(String path) async {
    final response = await dio.get<String>(
      basePath + configPath,
      queryParameters: {
        'keys': 'objectId',
      },
    );
    final jsonResponse = convert.json.decode(response.data)['results'] as List;
    if (jsonResponse.isNotEmpty) {
      await dio
          .delete('${basePath}${configPath}/${jsonResponse[0]['objectId']}');
    }
    await dio.post(basePath + configPath, data: {'imageBasePath': path});
  }

  Future<void> setMovieInfo(List<MovieInfo> movies) async {
    await _deleteAllMovieInfo();

    var requests = <Map<String, dynamic>>[];
    for (final movie in movies) {
      for (final torrentInfo in movie.torrentsInfo) {
        requests.add({
          'method': 'POST',
          'path': '/' + basePath + torrentsInfoPath,
          'body': torrentInfo.toJson(),
        });
      }
    }
    final torrentsInfoIds = [];
    await _batch(requests, torrentsInfoIds);

    requests = <Map<String, dynamic>>[];
    var i = 0;
    for (final movie in movies) {
      final body = movie.toJson();
      if (body['releaseDate'] != null) {
        body['releaseDate'] = {
          '__type': 'Date',
          'iso': body['releaseDate'] + 'Z',
        };
      }
      body['torrentsInfo'] = (body['torrentsInfo'] as List).map((_) {
        return {
          '__type': 'Pointer',
          'className': 'torrentsInfo',
          'objectId': torrentsInfoIds[i++]['success']['objectId'] as String,
        };
      }).toList();
      requests.add({
        'method': 'POST',
        'path': '/' + basePath + moviesPath,
        'body': body,
      });
    }
    await _batch(requests);
  }

  Future<void> _deleteAllMovieInfo() async {
    final limit = 200;
    var count = 1;
    final requests = <Map<String, dynamic>>[];
    for (var skip = 0; skip < count; skip += limit) {
      final first = skip == 0;
      final response = await dio.get<String>(
        basePath + moviesPath,
        queryParameters: {
          'keys': 'torrentsInfo',
          'include': 'torrentsInfo',
          'limit': limit,
          'count': first ? 1 : 0,
          'skip': skip,
        },
      );
      final jsonResponse = convert.json.decode(response.data);
      if (first) {
        count = jsonResponse['count'];
      }

      final movies = jsonResponse['results'] as List;
      for (final movie in movies) {
        requests.add({
          'method': 'DELETE',
          'path': '/${basePath}${moviesPath}/${movie['objectId']}',
        });
        final torrentsInfo = movie['torrentsInfo'] as List;
        for (final torrentInfo in torrentsInfo) {
          requests.add({
            'method': 'DELETE',
            'path':
                '/${basePath}${torrentsInfoPath}/${torrentInfo['objectId']}',
          });
        }
      }
    }
    await _batch(requests);
  }

  Future _batch(List<Map<String, dynamic>> requests, [List results]) async {
    final length = requests.length;
    for (var i = 0; i < length; i += 50) {
      final response = await dio.post<String>(
        '${basePath}batch',
        data: convert.json.encode({
          'requests': requests.sublist(i, math.min(i + 50, length)),
        }),
      );
      if (results != null) {
        results.addAll(convert.json.decode(response.data) as List);
      }
    }
  }
}
