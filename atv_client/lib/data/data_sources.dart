import 'package:domain/domain.dart';

abstract class LocalDataSource implements Repository {
  Future<void> setTopSeedersFhdMovies(Map<String, dynamic> moviesInfo);
  Future<void> setImageBasePath(String imageBasePath);
}
abstract class RemoteDataSource {
  Future<String> getImageBasePath();
  Future<Map<String, dynamic>> getTopSeedersFhdMovies();
}
