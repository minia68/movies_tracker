// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCrew _$MovieCrewFromJson(Map<String, dynamic> json) {
  return MovieCrew(
    job: json['job'] as String,
    name: json['name'] as String,
    profilePath: json['profilePath'] as String,
  );
}

Map<String, dynamic> _$MovieCrewToJson(MovieCrew instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('job', instance.job);
  writeNotNull('name', instance.name);
  writeNotNull('profilePath', instance.profilePath);
  return val;
}

MovieCast _$MovieCastFromJson(Map<String, dynamic> json) {
  return MovieCast(
    character: json['character'] as String,
    name: json['name'] as String,
    profilePath: json['profilePath'] as String,
  );
}

Map<String, dynamic> _$MovieCastToJson(MovieCast instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('character', instance.character);
  writeNotNull('name', instance.name);
  writeNotNull('profilePath', instance.profilePath);
  return val;
}
