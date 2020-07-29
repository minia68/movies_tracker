// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationResponse _$ConfigurationResponseFromJson(
    Map<String, dynamic> json) {
  return ConfigurationResponse(
    images: json['images'] == null
        ? null
        : Images.fromJson(json['images'] as Map<String, dynamic>),
  );
}

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    baseUrl: json['base_url'] as String,
    secureBaseUrl: json['secure_base_url'] as String,
    backdropSizes:
        (json['backdrop_sizes'] as List)?.map((e) => e as String)?.toList(),
    logoSizes: (json['logo_sizes'] as List)?.map((e) => e as String)?.toList(),
    posterSizes:
        (json['poster_sizes'] as List)?.map((e) => e as String)?.toList(),
    profileSizes:
        (json['profile_sizes'] as List)?.map((e) => e as String)?.toList(),
    stillSizes:
        (json['still_sizes'] as List)?.map((e) => e as String)?.toList(),
  );
}
