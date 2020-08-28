import 'channels_service.dart';
import 'data_sources.dart';
import '../model/config.dart';
import 'package:rxdart/rxdart.dart';

class MoviesService {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  final ChannelsService channelsService;

  MoviesService(
      this._localDataSource, this._remoteDataSource, this.channelsService);

  Future<void> close() {
    return _localDataSource.close();
  }

  Stream<Config> getMovies() {
    return Stream.fromFuture(_localDataSource.getUpdating())
        .flatMap((updating) {
      if (updating) {
        return RepeatStream(
          (_) => Stream.fromFuture(Future.delayed(Duration(seconds: 5))
              .then((_) => _localDataSource.getUpdating())),
          12,
        )
            .takeWhileInclusive((updating) => updating)
            .where((updating) => !updating)
            .asyncMap(_getConfig);
      } else {
        return Stream.fromFuture(_getConfig(false));
      }
    });
  }

  Future<void> update() async {
    await _localDataSource.setUpdating(true);
    try {
      final imageBasePath = await _remoteDataSource.getImageBasePath();
      await _localDataSource
          .setImageBasePath(imageBasePath);
      await _localDataSource.setTopSeedersFhdMovies(
          await _remoteDataSource.getTopSeedersFhdMovies());

      channelsService.setImageBasePath(imageBasePath);
      await channelsService
          .update(await _localDataSource.getTopSeedersFhdMovies());
    } finally {
      await _localDataSource.setUpdating(false);
    }
  }

  Future<bool> isUpdating() {
    return _localDataSource.getUpdating();
  }

  Future<void> setUpdating() {
    return _localDataSource.setUpdating(true);
  }

  Future<Config> _getConfig(bool updating) async {
    return Config(
      imageBasePath: await _localDataSource.getImageBasePath(),
      movies: await _localDataSource.getTopSeedersFhdMovies(),
    );
  }
}
