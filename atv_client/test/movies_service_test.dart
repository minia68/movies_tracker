import 'package:atv_client/data/data_sources.dart';
import 'package:atv_client/data/movies_service.dart';
import 'package:atv_client/model/config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('getMovies updating false', () async {
    final localDataSource = MockLocalDataSource();
    final moviesService = MoviesService(
      localDataSource,
      null,
      null,
    );
    when(localDataSource.getTopSeedersFhdMovies()).thenAnswer((_) async => null);
    when(localDataSource.getImageBasePath()).thenAnswer((_) async => null);
    when(localDataSource.getUpdating()).thenAnswer((_) async => false);

    expect(moviesService.getMovies(), emitsInOrder([
      Config(imageBasePath: null, movies: null),
      emitsDone,
    ]));
    verify(localDataSource.getUpdating()).called(1);
  });

  test('getMovies updating', () async {
    final localDataSource = MockLocalDataSource();
    final moviesService = MoviesService(
      localDataSource,
      null,
      null,
    );
    int count = 0;
    when(localDataSource.getTopSeedersFhdMovies()).thenAnswer((_) async => null);
    when(localDataSource.getImageBasePath()).thenAnswer((_) async => null);
    when(localDataSource.getUpdating()).thenAnswer((_) async {
      count++;
      return count < 3;
    });

    await expectLater(moviesService.getMovies(), emitsInOrder([
      Config(imageBasePath: null, movies: null),
      emitsDone,
    ]));
    expect(count, 3);
  });
}

class MockLocalDataSource extends Mock implements LocalDataSource {}
