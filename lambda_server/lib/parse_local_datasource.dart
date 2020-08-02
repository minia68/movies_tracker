import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

class ParseLocalDataSource {
  final Dio dio;
  final String basePath;
  final String configPath = 'classes/config';
  final String filePath = 'files';

  ParseLocalDataSource(this.dio, {String basePath = ''})
      : basePath = basePath == null || basePath.isEmpty
            ? ''
            : basePath.endsWith('/') ? basePath : basePath + '/';

  Future<void> updateData(
    String baseImagePath,
    List<MovieInfo> movies,
  ) async {
    final fileResponse = await dio.post<Map<String, dynamic>>(
      basePath + filePath + '/topSeedersFhdMovies.json',
      data: convert.json.encode({
        'results': movies
      }),
    );

    final configResults =
        (await dio.get<Map<String, dynamic>>(basePath + configPath))
            .data['results'] as List;
    final data = {
      'imageBasePath': baseImagePath,
      'topSeedersFhdMovies': {
        'name': fileResponse.data['name'],
        'url': fileResponse.data['url'],
        '__type': 'File',
      }
    };
    if (configResults.isNotEmpty) {
      final config = configResults[0] as Map<String, dynamic>;
      await dio.delete(
          basePath + filePath + '/${config['topSeedersFhdMovies']['name']}');
      await dio.put('$basePath$configPath/${config['objectId']}', data: data);
    } else {
      await dio.post(basePath + configPath, data: data);
    }
  }
}
