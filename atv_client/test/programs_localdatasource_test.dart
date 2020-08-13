import 'package:atv_client/data/db/app_db.dart' as db;
import 'package:atv_client/model/program.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/moor.dart';

void main() {
  db.AppDb appDb;

  setUp(() {
    appDb = db.AppDb(memory: true);
  });

  tearDown(() async {
    await appDb.close();
  });

  void _testModelDb(db.Program actual, Program expected) {
    expect(actual.programId, expected.id);
    expect(actual.externalId, expected.externalId);
    expect(actual.channelExternalId, expected.channelExternalId);
    expect(actual.isDeleted, expected.isDeleted);
  }

  test('createProgram', () async {
    final program = Program(
      id: 1,
      externalId: 'externalId',
      channelExternalId: 'channelExternalId',
      isDeleted: false,
    );
    await appDb.programsDao.createProgram(program);

    final actual = await (appDb.select(appDb.programs)
          ..where((tbl) => tbl.programId.equals(1)))
        .getSingle();
    _testModelDb(actual, program);
  });

  test('deletePrograms', () async {
    final programs = [
      Program(id: 1, channelExternalId: '1', externalId: '1'),
      Program(id: 2, channelExternalId: '1', externalId: '1'),
      Program(id: 3, channelExternalId: '1', externalId: '1'),
    ];
    appDb.into(appDb.programs).insert(db.ProgramsCompanion.insert(
          programId: programs[0].id,
          channelExternalId: '1',
          externalId: '1',
          isDeleted: Value(false),
        ));
    appDb.into(appDb.programs).insert(db.ProgramsCompanion.insert(
          programId: programs[1].id,
          channelExternalId: '1',
          externalId: '1',
          isDeleted: Value(false),
        ));
    appDb.into(appDb.programs).insert(db.ProgramsCompanion.insert(
          programId: programs[2].id,
          channelExternalId: '1',
          externalId: '1',
          isDeleted: Value(false),
        ));

    await appDb.programsDao.deletePrograms([programs[0], programs[2]]);

    final actual = await appDb.select(appDb.programs).get();
    expect(actual.length, 1);
    _testModelDb(actual[0], programs[1]);
  });

  test('getPrograms', () async {
    final programs = [
      Program(
        id: 1,
        externalId: 'externalId1',
        isDeleted: false,
        channelExternalId: 'channelExternalId1',
      ),
      Program(
          id: 2,
          externalId: 'externalId2',
          isDeleted: true,
          channelExternalId: 'channelExternalId2'),
    ];
    appDb.into(appDb.programs).insert(db.ProgramsCompanion.insert(
          programId: programs[0].id,
          externalId: programs[0].externalId,
          channelExternalId: programs[0].channelExternalId,
          isDeleted: Value(programs[0].isDeleted),
        ));
    appDb.into(appDb.programs).insert(db.ProgramsCompanion.insert(
          programId: programs[1].id,
          externalId: programs[1].externalId,
          channelExternalId: programs[1].channelExternalId,
          isDeleted: Value(programs[1].isDeleted),
        ));

    final actuals = await appDb.programsDao.getPrograms();
    expect(actuals, programs);
  });

  test('setProgramDeleted', () async {
    final program = Program(
      id: 1,
      externalId: 'externalId',
      channelExternalId: 'channelExternalId',
      isDeleted: false,
    );
    appDb.into(appDb.programs).insert(db.ProgramsCompanion.insert(
          programId: program.id,
          externalId: program.externalId,
          channelExternalId: program.channelExternalId,
          isDeleted: Value(program.isDeleted),
        ));

    await appDb.programsDao.setProgramDeleted(program);

    final actual = await (appDb.select(appDb.programs)
          ..where((tbl) => tbl.programId.equals(program.id)))
        .getSingle();
    expect(actual.programId, program.id);
    expect(actual.isDeleted, true);
  });
}
