import 'package:atv_client/data/cnannels_service.dart';
import 'package:atv_client/model/channel.dart';
import 'package:atv_client/model/program.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('update channels.isEmpty', () async {
    final programTvDataSource = MockProgramTvDataSource();
    final programLocalDataSource = MockProgramLocalDataSource();
    final channelsService =
        ChannelsService(programLocalDataSource, programTvDataSource);

    when(programTvDataSource.getChannels()).thenAnswer((_) async => []);
    when(programTvDataSource.createChannel(any))
        .thenAnswer((_) async => 'channelId');
    when(programLocalDataSource.getPrograms()).thenAnswer((_) async => [
          Program(
            id: 'id1',
            externalId: 'externalId1',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: false,
          ),
          Program(
            id: 'id11',
            externalId: 'externalId11',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: false,
          ),
          Program(
            id: 'id111',
            externalId: 'externalId111',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: true,
          ),
        ]);
    when(programTvDataSource.createProgram(any, any))
        .thenAnswer((_) async => 'id1111');
    when(programLocalDataSource.createProgram(any))
        .thenAnswer((_) async => null);
    when(programTvDataSource.updateProgram(any, any, any))
        .thenAnswer((_) async => null);
    when(programTvDataSource.deleteProgram(any)).thenAnswer((_) async => null);
    when(programLocalDataSource.deletePrograms(any))
        .thenAnswer((_) async => null);

    await channelsService.update([
      MovieInfo(imdbId: 'externalId1'),
      MovieInfo(imdbId: 'externalId2'),
      MovieInfo(imdbId: 'externalId111'),
    ]);

    expect(
        verify(programTvDataSource.createProgram(captureAny, captureAny))
            .captured,
        ['channelId', MovieInfo(imdbId: 'externalId2')]);
    expect(verify(programLocalDataSource.createProgram(captureAny)).captured, [
      Program(
        id: 'id1111',
        channelExternalId: ChannelsService.moviesChannelId,
        externalId: 'externalId2',
      )
    ]);
    expect(
        verify(programTvDataSource.updateProgram(
                captureAny, captureAny, captureAny))
            .captured,
        ['channelId', 'id1', MovieInfo(imdbId: 'externalId1')]);
    expect(verify(programTvDataSource.deleteProgram(captureAny)).captured,
        ['id11']);
    expect(verify(programLocalDataSource.deletePrograms(captureAny)).captured, [
      [
        Program(
          id: 'id11',
          externalId: 'externalId11',
          channelExternalId: ChannelsService.moviesChannelId,
          isDeleted: false,
        )
      ]
    ]);
  });

  test('update !isBrowsable', () async {
    final programTvDataSource = MockProgramTvDataSource();
    final programLocalDataSource = MockProgramLocalDataSource();
    final channelsService =
      ChannelsService(programLocalDataSource, programTvDataSource);

    when(programTvDataSource.getChannels()).thenAnswer((_) async => [
      Channel(
        id: 'channelId',
        isDefault: true,
        externalId: ChannelsService.moviesChannelId,
        title: 'movies',
        logoUri: 'movies_channel_logo',
        isBrowsable: false,
      ),
    ]);
    await channelsService.update([]);

    verify(programTvDataSource.getChannels());
    verifyNoMoreInteractions(programTvDataSource);
    verifyZeroInteractions(programLocalDataSource);
  });
}

class MockProgramTvDataSource extends Mock implements ProgramTvDataSource {}

class MockProgramLocalDataSource extends Mock
    implements ProgramLocalDataSource {}
