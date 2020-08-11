import 'package:atv_client/model/channel.dart';
import 'package:atv_client/model/program.dart';
import 'package:domain/domain.dart';

abstract class ProgramLocalDataSource {
  Future<void> createProgram(Program program);
  Future<List<Program>> getPrograms();
  Future<void> deletePrograms(List<Program> programs);
  Future<void> setProgramDeleted(String id);
}

abstract class ProgramTvDataSource {
  Future<String> createProgram(String channelId, MovieInfo movie);
  Future<void> updateProgram(String channelId, String id, MovieInfo movie);
  Future<void> deleteProgram(String id);
  Future<String> createChannel(Channel channel);
  Future<List<Channel>> getChannels();
  Future<void> setChannelBrowsable(String id);
}

class ChannelsService {
  static const moviesChannelId = 'movies';
  final ProgramLocalDataSource _programLocalDataSource;
  final ProgramTvDataSource _programTvDataSource;
  final _channels = [
    Channel(
      id: null,
      isDefault: true,
      externalId: moviesChannelId,
      title: 'movies',
      logoUri: 'movies_channel_logo',
    )
  ];

  ChannelsService(this._programLocalDataSource, this._programTvDataSource);

  Future<void> userDeleteProgram(String id) async {
    await _programTvDataSource.deleteProgram(id);
    await _programLocalDataSource.setProgramDeleted(id);
  }

  Future<List<Channel>> getNotAddedChannels() async {
    final channels = await _programTvDataSource.getChannels();
    if (channels.isEmpty) {
      return _channels;
    } else {
      return channels.where((e) => !e.isBrowsable).toList();
    }
  }

  Future<void> addChannel(Channel channel) async {
    String id;
    if (channel.id == null) {
      id = await _programTvDataSource.createChannel(channel);
    } else {
      id = channel.id;
    }
    await _programTvDataSource.setChannelBrowsable(id);
  }

  Future<void> update(List<MovieInfo> movies) async {
    final channels = await _programTvDataSource.getChannels();
    if (channels.isEmpty) {
      final id = await _programTvDataSource.createChannel(_channels[0]);
      await _updateMoviesPrograms(id, movies);
    } else {
      final moviesChannel =
          channels.firstWhere((e) => e.externalId == moviesChannelId);
      if (moviesChannel.isBrowsable) {
        await _updateMoviesPrograms(moviesChannel.id, movies);
      }
    }
  }

  Future<void> _updateMoviesPrograms(
      String channelId, List<MovieInfo> movies) async {
    final localPrograms = await _programLocalDataSource.getPrograms();
    for (final movie in movies) {
      final program = localPrograms
          .firstWhere((e) => e.externalId == movie.imdbId, orElse: () => null);
      if (program == null) {
        final id = await _programTvDataSource.createProgram(channelId, movie);
        await _programLocalDataSource.createProgram(Program(
          id: id,
          channelExternalId: moviesChannelId,
          externalId: movie.imdbId,
        ));
      } else if (!program.isDeleted) {
        await _programTvDataSource.updateProgram(channelId, program.id, movie);
      }
    }
    final deletedPrograms = localPrograms
        .where((program) =>
            !movies.any((movie) => movie.imdbId == program.externalId))
        .toList();
    for (final program in deletedPrograms) {
      await _programTvDataSource.deleteProgram(program.id);
    }
    await _programLocalDataSource.deletePrograms(deletedPrograms);
  }
}
