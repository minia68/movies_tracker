import 'package:moor/moor.dart';

import '../data_sources.dart';
import 'app_db.dart';
import '../../model/program.dart' as model;

part 'programs_dao.g.dart';

@UseDao(include: {'tables.moor'})
class ProgramsDao extends DatabaseAccessor<AppDb>
    with _$ProgramsDaoMixin
    implements ProgramLocalDataSource {
  ProgramsDao(AppDb db) : super(db);

  @override
  Future<void> createProgram(model.Program program) {
    return into(programs).insert(ProgramsCompanion.insert(
      programId: program.id,
      externalId: program.externalId,
      channelExternalId: program.channelExternalId,
      isDeleted: Value(program.isDeleted),
    ));
  }

  @override
  Future<void> deletePrograms(List<model.Program> programsToDelete) {
    return batch((b) {
      for (final program in programsToDelete) {
        b.deleteWhere(
            programs,
            (Programs tbl) =>
                tbl.programId.equals(program.id) &
                tbl.channelExternalId.equals(program.channelExternalId));
      }
    });
  }

  @override
  Future<List<model.Program>> getPrograms() async {
    return (await select(programs).get())
        .map((e) => model.Program(
              id: e.programId,
              externalId: e.externalId,
              channelExternalId: e.channelExternalId,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  @override
  Future<void> setProgramDeleted(model.Program program) {
    return (update(programs)
          ..where((tbl) =>
              tbl.programId.equals(program.id) &
              tbl.channelExternalId.equals(program.channelExternalId)))
        .write(ProgramsCompanion(isDeleted: Value(true)));
  }
}
