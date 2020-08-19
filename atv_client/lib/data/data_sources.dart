import 'package:atv_channels/atv_channels.dart' as atv_channels;
import 'package:domain/domain.dart';
import '../model/channel.dart';
import '../model/program.dart';

abstract class LocalDataSource implements Repository {
  Future<void> setTopSeedersFhdMovies(String moviesInfo);
  Future<void> setImageBasePath(String imageBasePath);
  Future<void> setUpdating(bool updating);
  Future<bool> getUpdating();
}

abstract class RemoteDataSource {
  Future<String> getImageBasePath();
  Future<String> getTopSeedersFhdMovies();
}

abstract class ProgramLocalDataSource {
  Future<void> createProgram(Program program);
  Future<List<Program>> getPrograms();
  Future<void> deletePrograms(List<Program> programs);
  Future<void> setProgramDeleted(Program program);
}

abstract class ProgramTvDataSource {
  Future<int> createProgram(int channelId, MovieInfo movie);
  Future<void> updateProgram(int channelId, int id, MovieInfo movie);
  Future<void> deleteProgram(int id);
  Future<int> createChannel(Channel channel);
  Future<List<Channel>> getChannels();
  Future<void> setChannelBrowsable(int id);
  Future<List<int>> getProgramsIds(int channelId);
  void setImageBasePath(String imageBasePath);
  Future<atv_channels.GetInitialDataResponse> getInitialData();
}