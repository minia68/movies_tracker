// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _TmdbClient implements TmdbClient {
  _TmdbClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://api.themoviedb.org/3/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  find(externalId, language, externalSource) async {
    ArgumentError.checkNotNull(externalId, 'externalId');
    ArgumentError.checkNotNull(language, 'language');
    ArgumentError.checkNotNull(externalSource, 'externalSource');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'language': language,
      'external_source': externalSource
    };
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/find/$externalId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = FindResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  configuration() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/configuration',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ConfigurationResponse.fromJson(_result.data);
    return Future.value(value);
  }
}
