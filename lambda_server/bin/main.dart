import 'dart:io';

import 'package:aws_lambda_dart_runtime/aws_lambda_dart_runtime.dart';
import 'package:dio/dio.dart';
import 'package:aws_lambda_dart_runtime/runtime/context.dart';
import 'package:lambda_server/parse_local_datasource.dart';
import 'package:movie_info_provider/movie_info_provider.dart';

void main(List<String> arguments) async {
  final moviesProvider = MovieInfoProvider(
    RutorTrackerDataSource(
        DioHtmlPageProvider(), Platform.environment['RUTOR_ADDRESS']),
    KinopoiskRatingDataSource(DioHtmlPageProvider()),
    TmdbDataSource(TmdbClient.setup(Platform.environment['TMDB_API_KEY'])),
    Platform.environment['RUTOR_SEARCH_STRING'],
  );

  final dio = Dio(BaseOptions(
      baseUrl: Platform.environment['PARSE_SERVER_ADDRESS'],
      contentType: 'application/json',
      headers: {
        'X-Parse-Application-Id': Platform.environment['PARSE_SERVER_APP_ID'],
        'X-Parse-Master-Key': Platform.environment['PARSE_SERVER_MASTER_KEY'],
      }));

  final handler = (Context context, AwsCloudwatchEvent event) async {
    final ds = ParseLocalDataSource(dio);
    await ds.updateData(
      await moviesProvider.getImageBasePath(),
      await moviesProvider.getTopSeedersFhdMovies(),
    );
    return InvocationResult(context.requestId, '');
  };
  Runtime()
    ..registerHandler<AwsCloudwatchEvent>(
        Platform.environment['AWS_LAMBDA_HANDLER_NAME'], handler)
    ..invoke();
}
