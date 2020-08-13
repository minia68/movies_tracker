import 'package:atv_client/data/channels_service.dart';
import 'package:atv_client/data/data_sources.dart';
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
    when(programTvDataSource.createChannel(any)).thenAnswer((_) async => 1);
    when(programLocalDataSource.getPrograms()).thenAnswer((_) async => [
          Program(
            id: 1,
            externalId: 'externalId1',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: false,
          ),
          Program(
            id: 11,
            externalId: 'externalId11',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: false,
          ),
          Program(
            id: 111,
            externalId: 'externalId111',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: true,
          ),
          Program(
            id: 222,
            externalId: 'externalId222',
            channelExternalId: ChannelsService.moviesChannelId,
            isDeleted: false,
          ),
        ]);
    when(programTvDataSource.getProgramsIds(any))
        .thenAnswer((_) async => [1, 11, 111]);
    when(programTvDataSource.createProgram(any, any))
        .thenAnswer((_) async => 1111);
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
      MovieInfo(imdbId: 'externalId222'),
    ]);

    expect(
        verify(programTvDataSource.createProgram(captureAny, captureAny))
            .captured,
        [1, MovieInfo(imdbId: 'externalId2')]);
    expect(verify(programLocalDataSource.createProgram(captureAny)).captured, [
      Program(
        id: 1111,
        channelExternalId: ChannelsService.moviesChannelId,
        externalId: 'externalId2',
      )
    ]);
    expect(
        verify(programTvDataSource.updateProgram(
                captureAny, captureAny, captureAny))
            .captured,
        [1, 1, MovieInfo(imdbId: 'externalId1')]);
    expect(
        verify(programTvDataSource.deleteProgram(captureAny)).captured, [11]);
    expect(verify(programLocalDataSource.deletePrograms(captureAny)).captured, [
      [
        Program(
          id: 11,
          externalId: 'externalId11',
          channelExternalId: ChannelsService.moviesChannelId,
          isDeleted: false,
        )
      ]
    ]);
    expect(
        verify(programLocalDataSource.setProgramDeleted(captureAny)).captured,
        [Program(
          id: 222,
          externalId: 'externalId222',
          channelExternalId: ChannelsService.moviesChannelId,
          isDeleted: true,
        )]);
  });

  test('update !isBrowsable', () async {
    final programTvDataSource = MockProgramTvDataSource();
    final programLocalDataSource = MockProgramLocalDataSource();
    final channelsService =
        ChannelsService(programLocalDataSource, programTvDataSource);

    when(programTvDataSource.getChannels()).thenAnswer((_) async => [
          Channel(
            id: 1,
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
