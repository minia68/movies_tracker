import 'package:logging/logging.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'configuration_response.dart';
import 'find_response.dart';
import 'movie_response.dart';

part 'client.g.dart';

final _logger = Logger('TmdbClient');

@RestApi(baseUrl: 'https://api.themoviedb.org/3/')
abstract class TmdbClient {
  @GET('/find/{externalId}')
  Future<FindResponse> find(
      @Path() String externalId,
      @Query('language') String language,
      @Query('external_source') String externalSource);

  @GET('/configuration')
  Future<ConfigurationResponse> configuration();

  @GET('/movie/{movieId}')
  Future<Movie> getMovie(
    @Path() int movieId,
    @Query('language') String language, {
    @Query('append_to_response') String appendToResponse = 'credits,videos',
  });

  static TmdbClient setup(String apiKey) {
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.interceptors
      ..add(LogInterceptor(
          responseBody: true, logPrint: (obj) => _logger.config(obj)))
      ..add(ApiKeyInterceptor(apiKey));
    return _TmdbClient(dio);
  }
}

class ApiKeyInterceptor extends InterceptorsWrapper {
  final String _apiKey;

  ApiKeyInterceptor(this._apiKey);
//  final Dio _dio;

// Rate limit removed
//  ApiKeyInterceptor(this._apiKey, this._dio);
//
//  @override
//  Future onError(DioError err) async {
//    if (err.response?.statusCode == 429) {
//      _dio.lock();
//      _dio.interceptors.responseLock.lock();
//      _dio.interceptors.errorLock.lock();
//      await Future.delayed(Duration(
//          seconds: int.parse(err.response.headers.value('Retry-After'))));
//      _dio.unlock();
//      _dio.interceptors.responseLock.unlock();
//      _dio.interceptors.errorLock.unlock();
//
//      final options = err.response.request;
//      return _dio.request(options.path, options: options);
//    }
//    return err;
//  }

  @override
  Future onRequest(RequestOptions options) async {
    options.queryParameters['api_key'] = _apiKey;
    return options;
  }
}
