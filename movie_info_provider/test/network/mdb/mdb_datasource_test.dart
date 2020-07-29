import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:movie_info_provider/src/mdb/tmdb/client.dart';
import 'package:movie_info_provider/src/mdb/tmdb/configuration_response.dart';
import 'package:movie_info_provider/src/mdb/tmdb/find_response.dart';
import 'package:movie_info_provider/src/mdb/tmdb/tmdb_datasource.dart';
import 'package:test/test.dart';

void main() {
  test('getMovieInfo', () async {
    final client = MockClient();
    when(client.find('1', any, any))
        .thenAnswer((_) async => FindResponse.fromJson(json.decode('''
{
  "movie_results": [],
  "person_results": [],
  "tv_results": [],
  "tv_episode_results": [],
  "tv_season_results": []
}''')));
    when(client.find('2', any, any))
        .thenAnswer((_) async => FindResponse.fromJson(json.decode('''
{
  "movie_results": [
    {
      "id": 509967,
      "video": false,
      "vote_count": 453,
      "vote_average": 6.5,
      "title": "Шестеро вне закона",
      "release_date": "2019-12-13",
      "original_language": "en",
      "original_title": "6 Underground",
      "genre_ids": [
        28,
        53
      ],
      "backdrop_path": "/eFw5YSorHidsajLTayo1noueIxI.jpg",
      "adult": false,
      "overview": "Шесть миллиардеров фальсифицируют собственные смерти и создают отряд мстителей, чтобы самостоятельно вершить правосудие.",
      "poster_path": "/sZre2G2Cy39lm3RFrK14FtlPubS.jpg",
      "popularity": 258.317
    }
  ],
  "person_results": [],
  "tv_results": [],
  "tv_episode_results": [],
  "tv_season_results": []
}''')));
    final ds = TmdbDataSource(client);
    var response = await ds.getMovieInfo('1');
    expect(response, isNull);

    response = await ds.getMovieInfo('2');
    expect(response.voteCount, 453);
    expect(response.voteAverage, 6.5);
    expect(response.popularity, 258.317);
    expect(response.title, 'Шестеро вне закона');
    expect(response.backdropPath, '/eFw5YSorHidsajLTayo1noueIxI.jpg');
    expect(response.releaseDate, DateTime.parse('2019-12-13'));
    expect(response.overview, 'Шесть миллиардеров фальсифицируют собственные смерти и создают отряд мстителей, чтобы самостоятельно вершить правосудие.');
    expect(response.posterPath, '/sZre2G2Cy39lm3RFrK14FtlPubS.jpg');
    expect(response.id, '509967');
  });

  test('getImageBasePath', () async {
    final client = MockClient();
    when(client.configuration()).thenAnswer((_) async => ConfigurationResponse.fromJson(json.decode('''
 {
  "images": {
    "base_url": "http://image.tmdb.org/t/p/",
    "secure_base_url": "https://image.tmdb.org/t/p/",
    "backdrop_sizes": [
      "w300",
      "w780",
      "w1280",
      "original"
    ],
    "logo_sizes": [
      "w45",
      "w92",
      "w154",
      "w185",
      "w300",
      "w500",
      "original"
    ],
    "poster_sizes": [
      "w92",
      "w154",
      "w185",
      "w342",
      "w500",
      "w780",
      "original"
    ],
    "profile_sizes": [
      "w45",
      "w185",
      "h632",
      "original"
    ],
    "still_sizes": [
      "w92",
      "w185",
      "w300",
      "original"
    ]
  },
  "change_keys": [
    "adult",
    "air_date",
    "also_known_as",
    "alternative_titles",
    "biography",
    "birthday",
    "budget",
    "cast",
    "certifications",
    "character_names",
    "created_by",
    "crew",
    "deathday",
    "episode",
    "episode_number",
    "episode_run_time",
    "freebase_id",
    "freebase_mid",
    "general",
    "genres",
    "guest_stars",
    "homepage",
    "images",
    "imdb_id",
    "languages",
    "name",
    "network",
    "origin_country",
    "original_name",
    "original_title",
    "overview",
    "parts",
    "place_of_birth",
    "plot_keywords",
    "production_code",
    "production_companies",
    "production_countries",
    "releases",
    "revenue",
    "runtime",
    "season",
    "season_number",
    "season_regular",
    "spoken_languages",
    "status",
    "tagline",
    "title",
    "translations",
    "tvdb_id",
    "tvrage_id",
    "type",
    "video",
    "videos"
  ]
}''')));
    final ds = TmdbDataSource(client);
    var response = await ds.getImageBasePath();
    expect(response, 'http://image.tmdb.org/t/p/');

    when(client.configuration()).thenAnswer((_) async => ConfigurationResponse.fromJson(json.decode('''{}''')));
    response = await ds.getImageBasePath();
    expect(response, isNull);
  });
}

class MockClient extends Mock implements TmdbClient {}
