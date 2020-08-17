export 'messages.dart';

import 'messages.dart';

class PreviewPrograms {
  /// The aspect ratio for 16:9.
  static const int ASPECT_RATIO_16_9 = 0;
  ///The aspect ratio for 1:1.
  static const int ASPECT_RATIO_1_1 = 3;
  /// The aspect ratio for 2:3.
  static const int ASPECT_RATIO_2_3 = 4;
  /// The aspect ratio for 3:2.
  static const int ASPECT_RATIO_3_2 = 1;
  /// The aspect ratio for 4:3.
  static const int ASPECT_RATIO_4_3 = 2;
  /// The aspect ratio for movie poster which is 1:1.441.
  static const int ASPECT_RATIO_MOVIE_POSTER = 5;
  /// The review rating style for five star rating.
  static const int REVIEW_RATING_STYLE_STARS = 0;
  /// The review rating style for thumbs-up and thumbs-down rating.
  static const int REVIEW_RATING_STYLE_THUMBS_UP_DOWN = 1;
  /// The review rating style for 0 to 100 point system.
  static const int REVIEW_RATING_STYLE_PERCENTAGE = 2;
  /// The program type for movie.
  static const int TYPE_MOVIE = 0;
  /// The program type for TV series.
  static const int TYPE_TV_SERIES = 1;
}

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