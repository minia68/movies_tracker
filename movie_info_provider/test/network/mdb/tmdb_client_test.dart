import 'package:dio/dio.dart';
import 'package:movie_info_provider/src/mdb/tmdb/client.dart';
import 'package:test/test.dart';

void main() {
  test('ApiKeyInterceptor', () async {
    final dio = Dio();
    final apiKey = 'apiKey';
    final interceptor = ApiKeyInterceptor(apiKey);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.interceptors
      ..add(interceptor)
      ..add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        return dio.resolve('asd');
//        if (options.headers.containsKey('Retry-After')) {
//          return dio.resolve('asd');
//        }
//        options.headers = {'Retry-After': ''};
//        return dio.reject(DioError(response: Response(
//            request: options,
//            statusCode: 429,
//            headers: Headers.fromMap({'Retry-After': ['1']}))));
      }));

    final resp = await dio.get('');
    expect(resp.data.toString(), 'asd');
    expect(resp.request.queryParameters['api_key'], apiKey);
  });
}
