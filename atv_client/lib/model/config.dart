import 'package:domain/domain.dart';

class Config {
  final String imageBasePath;
  final List<MovieInfo> movies;

  Config({this.imageBasePath, this.movies});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Config &&
          runtimeType == other.runtimeType &&
          imageBasePath == other.imageBasePath &&
          movies == other.movies;

  @override
  int get hashCode =>
      imageBasePath.hashCode ^ movies.hashCode;
}