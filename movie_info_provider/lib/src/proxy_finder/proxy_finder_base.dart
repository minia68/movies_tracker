import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'proxy_list_item.dart';

class ProxyFinder {
  final BaseOptions proxyDioOptions;
  final List<Interceptor> interceptors;
  Dio proxyDio;
  int lastIndex = 0;
  List<ProxyListItem> proxyListItems;

  ProxyFinder._(this.proxyDioOptions, this.interceptors);

  factory ProxyFinder([
    BaseOptions proxyDioOptions,
    List<Interceptor> interceptors,
  ]) {
    proxyDioOptions ??= BaseOptions();
    proxyDioOptions.connectTimeout = 5000;
    proxyDioOptions.receiveTimeout = 5000;
    proxyDioOptions.sendTimeout = 5000;
    interceptors ??= [];
    return ProxyFinder._(proxyDioOptions, interceptors);
  }

  Future loadProxyList() async {
    final response = await Dio().get<String>(
        'https://raw.githubusercontent.com/fate0/proxylist/master/proxy.list');
    proxyListItems = response.data
        .split('\n')
        .map((e) => ProxyListItem.fromJson(json.decode(e)))
        .skip(lastIndex)
        .take(30)
        .toList();
  }

  Future findProxy() async {
    if (proxyListItems == null || proxyListItems.isEmpty) {
      await loadProxyList();
    }
    while (lastIndex < proxyListItems.length) {
      setProxy(proxyListItems[lastIndex]);
      try {
        final response = await proxyDio.get<String>('http://www.google.com');
        if (!response.data.contains('<title>Google</title>')) {
          throw ProxyFinderException('bad response body');
        }
        break;
      } catch (e) {
        lastIndex++;
      }
    }
    if (lastIndex == proxyListItems.length) {
      throw ProxyFinderException('cant find working proxy');
    }
  }

  void setProxy(ProxyListItem proxyListItem) {
    proxyDio?.close(force: true);
    proxyDio = Dio(proxyDioOptions)..interceptors.addAll(interceptors);
    (proxyDio.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      client.findProxy = (_) {
        return 'PROXY ${proxyListItem.host}:${proxyListItem.port}';
      };
    };
  }
}

class ProxyFinderException implements Exception {
  final String message;

  ProxyFinderException(this.message);
}
