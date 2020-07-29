// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_torrent_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieTorrentInfo _$MovieTorrentInfoFromJson(Map<String, dynamic> json) {
  return MovieTorrentInfo(
    magnetUrl: json['magnetUrl'] as String,
    title: json['title'] as String,
    size: (json['size'] as num)?.toDouble(),
    seeders: json['seeders'] as int,
    leechers: json['leechers'] as int,
  );
}

Map<String, dynamic> _$MovieTorrentInfoToJson(MovieTorrentInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('magnetUrl', instance.magnetUrl);
  writeNotNull('title', instance.title);
  writeNotNull('size', instance.size);
  writeNotNull('seeders', instance.seeders);
  writeNotNull('leechers', instance.leechers);
  return val;
}
