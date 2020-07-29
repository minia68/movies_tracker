import 'mdb_movie_info.dart';

abstract class MdbDataSource {
  Future<MdbMovieInfo> getMovieInfo(String id);

  Future<String> getImageBasePath();
}
