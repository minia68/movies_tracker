// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    posterPath: json['poster_path'] as String,
    overview: json['overview'] as String,
    releaseDate: json['release_date'] as String,
    id: json['id'] as int,
    title: json['title'] as String,
    backdropPath: json['backdrop_path'] as String,
    popularity: (json['popularity'] as num)?.toDouble(),
    voteCount: json['vote_count'] as int,
    voteAverage: (json['vote_average'] as num)?.toDouble(),
    genres: (json['genres'] as List)
        ?.map(
            (e) => e == null ? null : Genre.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    productionCountries: (json['production_countries'] as List)
        ?.map((e) => e == null
            ? null
            : ProductionCountry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    credits: json['credits'] == null
        ? null
        : Credits.fromJson(json['credits'] as Map<String, dynamic>),
    videos: json['videos'] == null
        ? null
        : Videos.fromJson(json['videos'] as Map<String, dynamic>),
  );
}

Genre _$GenreFromJson(Map<String, dynamic> json) {
  return Genre(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

ProductionCountry _$ProductionCountryFromJson(Map<String, dynamic> json) {
  return ProductionCountry(
    code: json['iso_3166_1'] as String,
    name: json['name'] as String,
  );
}

Credits _$CreditsFromJson(Map<String, dynamic> json) {
  return Credits(
    cast: (json['cast'] as List)
        ?.map(
            (e) => e == null ? null : Cast.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    crew: (json['crew'] as List)
        ?.map(
            (e) => e == null ? null : Crew.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Cast _$CastFromJson(Map<String, dynamic> json) {
  return Cast(
    id: json['id'] as int,
    name: json['name'] as String,
    character: json['character'] as String,
    order: json['order'] as int,
    profilePath: json['profile_path'] as String,
  );
}

Crew _$CrewFromJson(Map<String, dynamic> json) {
  return Crew(
    id: json['id'] as int,
    name: json['name'] as String,
    job: json['job'] as String,
    profilePath: json['profile_path'] as String,
  );
}

Videos _$VideosFromJson(Map<String, dynamic> json) {
  return Videos(
    results: (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Video.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    key: json['key'] as String,
    site: json['site'] as String,
    type: json['type'] as String,
  );
}
