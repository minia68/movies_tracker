import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'configs_dao.dart';
import 'programs_dao.dart';

part 'app_db.g.dart';

@UseMoor(
  include: {'tables.moor'},
  daos: [ProgramsDao, ConfigsDao],
)
class AppDb extends _$AppDb {
  AppDb({bool memory = false, bool logStatements = false}) :
        super(_openConnection(memory: memory, logStatements: logStatements));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection({bool memory, bool logStatements}) {
  return LazyDatabase(() async {
    if (memory) {
      return VmDatabase.memory(logStatements: logStatements);
    } else {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
      return VmDatabase(file, logStatements: logStatements);
    }
  });
}