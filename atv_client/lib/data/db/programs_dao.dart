import 'package:moor/moor.dart';

import '../cnannels_service.dart';
import 'app_db.dart';
import 'package:atv_client/model/program.dart' as model;

part 'programs_dao.g.dart';

@UseDao(include: {'tables.moor'})
class ProgramsDao extends DatabaseAccessor<AppDb>
    with _$ProgramsDaoMixin
    implements ProgramLocalDataSource {
  ProgramsDao(AppDb db) : super(db);

  @override
  Future<void> createProgram(model.Program program) {
    return into(programs).insert(ProgramsCompanion.insert(
      id: program.id,
      externalId: Value(program.externalId),
      channelExternalId: Value(program.channelExternalId),
      isDeleted: Value(program.isDeleted),
    ));
  }

  @override
  Future<void> deletePrograms(List<model.Program> programsToDelete) {
    return (delete(programs)
          ..where((tbl) => tbl.id.isIn(programsToDelete.map((e) => e.id))))
        .go();
  }

  @override
  Future<List<model.Program>> getPrograms() async {
    return (await select(programs).get())
        .map((e) => model.Program(
              id: e.id,
              externalId: e.externalId,
              channelExternalId: e.channelExternalId,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  @override
  Future<void> setProgramDeleted(String id) {
    return (update(programs)..where((tbl) => tbl.id.equals(id)))
        .write(ProgramsCompanion(isDeleted: Value(true)));
  }
}
