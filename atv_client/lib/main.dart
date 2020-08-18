import 'package:atv_channels/atv_channels.dart';
import 'package:workmanager/workmanager.dart';

import 'data/atv/atv_program_datasource.dart';
import 'data/channels_service.dart';
import 'data/movies_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'data/db/app_db.dart';
import 'data/network/parse_datasource.dart';

MoviesService init() {
  final db = AppDb(logStatements: true);
  final dio = Dio(BaseOptions(
      baseUrl: 'https://parseapi.back4app.com/',
      contentType: 'application/json',
      headers: {
        'X-Parse-Application-Id': '4mSOCSStSymWpiNKw0cnP0Fcz1hk6uFwjN5uGYgv',
        'X-Parse-REST-API-Key': 'avelPvw77LNGdxi8gDuxiBKzEHwZLDBr6DvnAt5Y',
      }));
  return MoviesService(
    db.configsDao,
    ParseDataSource(dio),
    ChannelsService(
      db.programsDao,
      AtvProgramDataSource(AtvChannelsApi()),
    ),
  );
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    try {
      final moviesService = init();
      await moviesService.update();
    } catch (_, s) {
      print(s);
      return false;
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  final moviesService = init();
  if (await moviesService.isUpdating() == null) {
    Workmanager.registerPeriodicTask(
      '1',
      'update',
      frequency: Duration(days: 1),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
  runApp(App(moviesService: moviesService));
}

class App extends StatelessWidget {
  final MoviesService moviesService;

  const App({Key key, this.moviesService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
