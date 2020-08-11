import 'dart:convert';

import 'package:atv_client/data/db/app_db.dart' as db;
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/moor.dart' as moor;

void main() {
  db.AppDb appDb;

  setUp(() {
    appDb = db.AppDb(memory: true);
  });

  tearDown(() async {
    await appDb.close();
  });
  
  test('getImageBasePath', () async {
    expect(await appDb.configsDao.getImageBasePath(), isNull);
    appDb.into(appDb.configs).insert(db.ConfigsCompanion.insert(
      id: moor.Value(1),
      imageBasePath: moor.Value('imageBasePath'),
    ));
    final imageBasePath = await appDb.configsDao.getImageBasePath();
    expect(imageBasePath, 'imageBasePath');
  });

  test('getTopSeedersFhdMovies', () async {
    expect(await appDb.configsDao.getTopSeedersFhdMovies(), isEmpty);
    appDb.into(appDb.configs).insert(db.ConfigsCompanion.insert(
        id: moor.Value(1),
        moviesInfo: moor.Value(json.encode({
          'results': [
            MovieInfo(
              imdbId: 'imdbId1',
              torrentsInfo: [
                MovieTorrentInfo(magnetUrl: 'magnetUrl')
              ],
              cast: [MovieCast(name: 'name')],
              crew: [MovieCrew(name: 'name')],
              raiting: MovieRaiting(imdbVoteAverage: 3),
            ),
          ]
        })),
    ));
    final movies = await appDb.configsDao.getTopSeedersFhdMovies();
    final movie = movies[0];
    expect(movie.imdbId, 'imdbId1');
    expect(movie.torrentsInfo[0].magnetUrl, 'magnetUrl');
    expect(movie.cast[0].name, 'name');
    expect(movie.crew[0].name, 'name');
    expect(movie.raiting.imdbVoteAverage, 3);
  });

  test('setImageBasePath', () async {
    await appDb.configsDao.setImageBasePath('imageBasePath');
    var config = await appDb.select(appDb.configs).getSingle();
    expect(config.imageBasePath, 'imageBasePath');

    await appDb.configsDao.setImageBasePath('imageBasePath1');
    config = await appDb.select(appDb.configs).getSingle();
    expect(config.imageBasePath, 'imageBasePath1');
  });

  test('setTopSeedersFhdMovies', () async {
    var movies = {
      'results': [
        MovieInfo(
          imdbId: 'imdbId1',
          torrentsInfo: [
            MovieTorrentInfo(magnetUrl: 'magnetUrl')
          ],
          cast: [MovieCast(name: 'name')],
          crew: [MovieCrew(name: 'name')],
          raiting: MovieRaiting(imdbVoteAverage: 3),
        ),
      ]
    };
    await appDb.configsDao.setTopSeedersFhdMovies(movies);
    var config = await appDb.select(appDb.configs).getSingle();
    expect(config.moviesInfo, json.encode(movies));

    movies = {
      'results': [
        MovieInfo(
          imdbId: 'imdbId2',
          torrentsInfo: [
            MovieTorrentInfo(magnetUrl: 'magnetUrl2')
          ],
          cast: [MovieCast(name: 'name2')],
          crew: [MovieCrew(name: 'name2')],
          raiting: MovieRaiting(imdbVoteAverage: 32),
        ),
      ]
    };
    await appDb.configsDao.setTopSeedersFhdMovies(movies);
    config = await appDb.select(appDb.configs).getSingle();
    expect(config.moviesInfo, json.encode(movies));
  });
}