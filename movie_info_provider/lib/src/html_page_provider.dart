import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'proxy_finder/proxy_finder_base.dart';

final _logger = Logger('HtmlPageProvider');

abstract class HtmlPageProvider {
  Future<String> call(String url);
  void close();
}

class DioHtmlPageProvider implements HtmlPageProvider {
  final _dio = Dio();

  DioHtmlPageProvider() {
    _dio.interceptors.add(LogInterceptor(logPrint: _logger.config));
    _dio.options.headers['User-Agent'] =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0';
  }

  @override
  Future<String> call(String url) async {
    return (await _dio.get(url)).data.toString();
  }

  @override
  void close() {
    _dio.close(force: true);
  }
}

class ProxyDioHtmlPageProvider implements HtmlPageProvider {
  ProxyFinder _proxyFinder;

  ProxyDioHtmlPageProvider() {
    _proxyFinder = ProxyFinder(
      BaseOptions(headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0'
      }),
      [LogInterceptor(logPrint: _logger.config)],
    );
  }

  @override
  Future<String> call(String url) async {
    if (_proxyFinder.proxyDio == null) {
      await _proxyFinder.findProxy();
    }
    return (await _proxyFinder.proxyDio.get(url)).data.toString();
  }

  @override
  void close() {
    _proxyFinder.proxyDio?.close(force: true);
  }
}
