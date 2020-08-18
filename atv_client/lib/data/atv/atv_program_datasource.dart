import 'package:atv_channels/atv_channels.dart' as api;

import '../../model/channel.dart';
import 'package:domain/domain.dart';
import '../data_sources.dart';

class AtvProgramDataSource implements ProgramTvDataSource {
  final api.AtvChannelsApi _atvChannelsApi;
  String _imageBasePath;

  AtvProgramDataSource(this._atvChannelsApi);

  @override
  Future<int> createChannel(Channel channel) async {
    final response =
        await _atvChannelsApi.createChannel(api.CreateChannelRequest()
          ..name = channel.title
          ..externalId = channel.externalId
          ..defaultChannel = channel.isDefault
          ..logoDrawableResourceName = channel.logoUri);
    return response.id;
  }

  @override
  Future<int> createProgram(int channelId, MovieInfo movie) async {
    final response = await _atvChannelsApi
        .createProgram(_createProgramRequest(channelId, null, movie));
    return response.id;
  }

  @override
  Future<void> deleteProgram(int id) {
    return _atvChannelsApi.deleteProgram(api.DeleteRequest()..id = id);
  }

  @override
  Future<List<Channel>> getChannels() async {
    return (await _atvChannelsApi.getChannelsList())
        .map((e) => Channel(
              id: e.id,
              externalId: e.externalId,
              isDefault: null,
              isBrowsable: e.isBrowsable,
              title: e.title,
            ))
        .toList();
  }

  @override
  Future<List<int>> getProgramsIds(int channelId) {
    return _atvChannelsApi
        .getProgramsIdsList(api.GetProgramsIdsRequest()..channelId = channelId);
  }

  @override
  Future<void> setChannelBrowsable(int id) {
    return _atvChannelsApi
        .setChannelBrowsable(api.SetChannelBrowsableRequest()..id = id);
  }

  @override
  Future<void> updateProgram(int channelId, int id, MovieInfo movie) {
    return _atvChannelsApi
        .updateProgram(_createProgramRequest(channelId, id, movie));
  }

  api.CreateProgramRequest _createProgramRequest(
      int channelId, int id, MovieInfo movie) {
    return api.CreateProgramRequest()
      ..externalId = movie.imdbId
      ..title = movie.title
      ..channelId = channelId
      ..type = api.PreviewPrograms.TYPE_MOVIE
      ..reviewRatingStyle = api.PreviewPrograms.REVIEW_RATING_STYLE_STARS
      ..reviewRating = (movie.raiting.imdbVoteAverage * 0.5).toString()
      ..posterArtAspectRatio = api.PreviewPrograms.ASPECT_RATIO_2_3
      ..description = movie.overview
      ..posterArtUri = '$_imageBasePath${movie.posterPath}'
      ..releaseDate = '${movie.releaseDate.year}-'
          '${movie.releaseDate.month < 10 ? '0${movie.releaseDate.month}' : movie.releaseDate.month.toString()}-'
          '${movie.releaseDate.day < 10 ? '0${movie.releaseDate.day}' : movie.releaseDate.day.toString()}';
  }

  @override
  void setImageBasePath(String imageBasePath) {
    _imageBasePath = imageBasePath;
  }
}
