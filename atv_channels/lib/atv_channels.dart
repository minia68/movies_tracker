export 'messages.dart';

import 'messages.dart';

extension AtvChannelsApiExt on AtvChannelsApi {
  Future<List<Channel>> getChannelsList() async {
    final response = await this.getChannels();
    return response.channels
        .map((e) => _channelFromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  Future<List<int>> getProgramsIdsList(GetProgramsIdsRequest request) async {
    final response = await this.getProgramsIds(request);
    return List<int>.from(response.programsIds);
  }
}

Channel _channelFromMap(Map<dynamic, dynamic> pigeonMap) {
  final Channel result = Channel();
  result.id = pigeonMap['id'];
  result.externalId = pigeonMap['externalId'];
  result.isBrowsable = pigeonMap['isBrowsable'];
  result.title = pigeonMap['title'];
  return result;
}