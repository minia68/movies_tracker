import 'package:dio/dio.dart';

import '../data_sources.dart';

class ParseDataSource implements RemoteDataSource {
  final Dio dio;
  final String basePath;
  final String configPath = 'classes/config';
  final String filePath = 'files';

  ParseDataSource(this.dio, {String basePath = ''})
      : basePath = basePath == null || basePath.isEmpty
            ? ''
            : basePath.endsWith('/') ? basePath : basePath + '/';

  @override
  Future<String> getImageBasePath() async {
    final configResults =
        (await dio.get<Map<String, dynamic>>(basePath + configPath))
            .data['results'] as List;
    if (configResults.isNotEmpty) {
      final config = configResults[0] as Map<String, dynamic>;
      return config['imageBasePath'];
    } else {
      return null;
    }
  }

  @override
  Future<String> getTopSeedersFhdMovies() async {
    final configResults =
        (await dio.get<Map<String, dynamic>>(basePath + configPath))
            .data['results'] as List;
    if (configResults.isNotEmpty) {
      final config = configResults[0] as Map<String, dynamic>;
      final url = config['topSeedersFhdMovies']['url'] as String;
      final response = await dio.get<String>(url);
      return response.data;
    } else {
      return null;
    }
  }
}
