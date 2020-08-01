// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCredits _$MovieCreditsFromJson(Map<String, dynamic> json) {
  return MovieCredits(
    cast: (json['cast'] as List)
        ?.map((e) =>
            e == null ? null : MovieCast.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    crew: (json['crew'] as List)
        ?.map((e) =>
            e == null ? null : MovieCrew.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MovieCreditsToJson(MovieCredits instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cast', instance.cast?.map((e) => e?.toJson())?.toList());
  writeNotNull('crew', instance.crew?.map((e) => e?.toJson())?.toList());
  return val;
}

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
