import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:moor/moor.dart';

import '../data_sources.dart';
import 'app_db.dart';

part 'configs_dao.g.dart';

@UseDao(include: {'tables.moor'})
class ConfigsDao extends DatabaseAccessor<AppDb>
    with _$ConfigsDaoMixin
    implements LocalDataSource {
  ConfigsDao(AppDb db) : super(db);

  @override
  Future<String> getImageBasePath() async {
    return (await select(configs).getSingle())?.imageBasePath;
  }

  @override
  Future<List<MovieInfo>> getTopSeedersFhdMovies() async {
    final jsonData = (await select(configs).getSingle())?.moviesInfo;
    if (jsonData == null) {
      return [];
    }
    Map<String, dynamic> mapData = json.decode(jsonData);
    return (mapData['results'] as List)
        .map((e) => MovieInfo.fromJson(e))
        .toList();
  }

  @override
  Future<void> setImageBasePath(String imageBasePath) {
    return into(configs).insertOnConflictUpdate(ConfigsCompanion.insert(
      id: Value(1),
      imageBasePath: Value(imageBasePath),
    ));
  }

  @override
  Future<void> setTopSeedersFhdMovies(Map<String, dynamic> moviesInfo) {
    return into(configs).insertOnConflictUpdate(ConfigsCompanion.insert(
      id: Value(1),
      moviesInfo: Value(json.encode(moviesInfo)),
    ));
  }
}
