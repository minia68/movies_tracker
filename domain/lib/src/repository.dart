import 'package:domain/src/movie_info.dart';

abstract class Repository {
  Future<List<MovieInfo>> getTopSeedersFhdMovies();
  Future<String> getImageBasePath();
}
