import 'package:domain/domain.dart';

class Config {
  final String imageBasePath;
  final List<MovieInfo> movies;
  final bool isUpdating;

  Config({this.imageBasePath, this.movies, this.isUpdating});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Config &&
          runtimeType == other.runtimeType &&
          imageBasePath == other.imageBasePath &&
          movies == other.movies &&
          isUpdating == other.isUpdating;

  @override
  int get hashCode =>
      imageBasePath.hashCode ^ movies.hashCode ^ isUpdating.hashCode;
}