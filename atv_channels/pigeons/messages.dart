import 'package:pigeon/pigeon_lib.dart';

class CreateChannelRequest {
  String name;
  String logoDrawableResourceName;
  bool defaultChannel;
  String externalId;
}

class CreateResponse {
  int id;
}

class CreateProgramRequest {
  int programId;
  int channelId;
  int type;
  String title;
  String description;
  String posterArtUri;
  int posterArtAspectRatio;
  String reviewRating;
  int reviewRatingStyle;
  String releaseDate;
  String externalId;
  String channelExternalId;
}

class DeleteRequest {
  int id;
}

class GetInitialDataResponse {
	String channelExternalId;
	String programExternalId;
}

class GetChannelsResponse {
  List channels;
}

class SetChannelBrowsableRequest {
  int id;
}

class Channel {
  int id;
  String externalId;
  bool isBrowsable;
  String title;
}

class GetProgramsIdsRequest {
  int channelId;
}

class GetProgramsIdsResponse {
  List programsIds;
}

@HostApi()
abstract class AtvChannelsApi {
  CreateResponse createChannel(CreateChannelRequest request);
  void deleteChannel(DeleteRequest request);
  CreateResponse createProgram(CreateProgramRequest request);
  void updateProgram(CreateProgramRequest request);
  void deleteProgram(DeleteRequest request);
  GetInitialDataResponse getInitialData();
  GetChannelsResponse getChannels();
  void setChannelBrowsable(SetChannelBrowsableRequest request);
  void dummy(Channel dummy);
  GetProgramsIdsResponse getProgramsIds(GetProgramsIdsRequest request);
}

class ShowRequest {
  String channelExternalId;
  String programExternalId;
}

@FlutterApi()
abstract class AtvChannelsApiFlutter {
	void showChannel(ShowRequest request);
	void showProgram(ShowRequest request);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/messages.dart';
  opts.javaOut =
      'android/src/main/java/ru/minia68/atv_channels/Messages.java';
  opts.javaOptions.package = 'ru.minia68.atv_channels';
}
