import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:movie_info_provider/src/mdb/tmdb/client.dart';
import 'package:movie_info_provider/src/mdb/tmdb/configuration_response.dart';
import 'package:movie_info_provider/src/mdb/tmdb/find_response.dart';
import 'package:movie_info_provider/src/mdb/tmdb/movie_response.dart';
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
    when(client.getMovie(509967, any))
        .thenAnswer((_) async => Movie.fromJson(json.decode('''{
    "adult": false,
    "backdrop_path": "/nRXO2SnOA75OsWhNhXstHB8ZmI3.jpg",
    "belongs_to_collection": null,
    "budget": 260000000,
    "genres": [
        {
            "id": 12,
            "name": "приключения"
        },
        {
            "id": 10751,
            "name": "семейный"
        }
    ],
    "homepage": "https://movies.disney.com/the-lion-king-2019",
    "id": 420818,
    "imdb_id": "tt6105098",
    "original_language": "en",
    "original_title": "The Lion King",
    "overview": "История об отважном львенке по имени Симба. Знакомые с детства герои взрослеют, влюбляются, познают себя и окружающий мир, совершают ошибки и делают правильный выбор.",
    "popularity": 72.31,
    "poster_path": "/9NAGr8Z2OVURC4kjq31TIuNar4L.jpg",
    "production_companies": [
        {
            "id": 2,
            "logo_path": "/wdrCwmRnLFJhEoH8GSfymY85KHT.png",
            "name": "Walt Disney Pictures",
            "origin_country": "US"
        },
        {
            "id": 7297,
            "logo_path": "/l29JYQVZbTcjZXoz4CUYFpKRmM3.png",
            "name": "Fairview Entertainment",
            "origin_country": "US"
        }
    ],
    "production_countries": [
        {
            "iso_3166_1": "US",
            "name": "United States of America"
        }
    ],
    "release_date": "2019-07-12",
    "revenue": 1656943394,
    "runtime": 118,
    "spoken_languages": [
        {
            "iso_639_1": "en",
            "name": "English"
        }
    ],
    "status": "Released",
    "tagline": "",
    "title": "Король Лев",
    "video": false,
    "vote_average": 7.2,
    "vote_count": 6514,
    "credits": {
        "cast": [
            {
                "cast_id": 17,
                "character": "Scar (voice)",
                "credit_id": "59890a509251414bfa006d1e",
                "gender": 2,
                "id": 5294,
                "name": "Chiwetel Ejiofor",
                "order": 0,
                "profile_path": "/kq5DDnqqofoRI0t6ddtRlsJnNPT.jpg"
            },
            {
                "cast_id": 14,
                "character": "Zazu (voice)",
                "credit_id": "59640ace9251410bfa103ac8",
                "gender": 2,
                "id": 84292,
                "name": "John Oliver",
                "order": 1,
                "profile_path": "/nGIg6FSlUMznQ2At7ECDlQfnb1a.jpg"
            }
        ],
        "crew": [
            {
                "credit_id": "5e84f4cada10f00014ed1f6a",
                "department": "Directing",
                "gender": 2,
                "id": 15277,
                "job": "Director",
                "name": "Jon Favreau",
                "profile_path": "/8MtRRnEHaBSw8Ztdl8saXiw1egP.jpg"
            }
        ]
    },
    "videos": {
        "results": [
            {
                "id": "5c2bdc730e0a2655f239a24e",
                "iso_639_1": "ru",
                "iso_3166_1": "RU",
                "key": "RsPxU8MNDJg",
                "name": "Король Лев - тизер-трейлер 6+",
                "site": "YouTube",
                "size": 1080,
                "type": "Teaser"
            },
            {
                "id": "5cadf14f9251417a840139ef",
                "iso_639_1": "ru",
                "iso_3166_1": "RU",
                "key": "kNhdUVgukVk",
                "name": "Король Лев - официальный трейлер",
                "site": "YouTube",
                "size": 1080,
                "type": "Trailer"
            }
        ]
    }
}''')));
    when(client.find('11', any, any))
        .thenAnswer((_) async => FindResponse.fromJson(json.decode('''
{
  "movie_results": [
    {"id": 509968}
  ],
  "person_results": [],
  "tv_results": [],
  "tv_episode_results": [],
  "tv_season_results": []
}''')));
    when(client.getMovie(509968, any))
        .thenAnswer((_) async => Movie.fromJson(json.decode('''{
    "videos": {
        "results": [
            {
                "id": "5c2bdc730e0a2655f239a24e",
                "iso_639_1": "ru",
                "iso_3166_1": "RU",
                "key": "RsPxU8MNDJg",
                "name": "Король Лев - тизер-трейлер 6+",
                "site": "YouTube",
                "size": 1080,
                "type": "Teaser"
            },
            {
                "id": "5cadf14f9251417a840139ef",
                "iso_639_1": "ru",
                "iso_3166_1": "RU",
                "key": "kNhdUVgukVk",
                "name": "Король Лев - официальный трейлер",
                "site": "YouTube111",
                "size": 1080,
                "type": "Trailer"
            }
        ]
    }
}''')));
    when(client.find('111', any, any))
        .thenAnswer((_) async => FindResponse.fromJson(json.decode('''
{
  "movie_results": [
    {"id": 509969}
  ],
  "person_results": [],
  "tv_results": [],
  "tv_episode_results": [],
  "tv_season_results": []
}''')));
    when(client.getMovie(509969, any))
        .thenAnswer((_) async => Movie.fromJson(json.decode('''{
    "videos": {
        "results": [
            {
                "id": "5c2bdc730e0a2655f239a24e",
                "iso_639_1": "ru",
                "iso_3166_1": "RU",
                "key": "RsPxU8MNDJg",
                "name": "Король Лев - тизер-трейлер 6+",
                "site": "YouTube",
                "size": 1080,
                "type": "Teaser123"
            }
        ]
    }
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
    expect(response.overview,
        'Шесть миллиардеров фальсифицируют собственные смерти и создают отряд мстителей, чтобы самостоятельно вершить правосудие.');
    expect(response.posterPath, '/sZre2G2Cy39lm3RFrK14FtlPubS.jpg');
    expect(response.id, '509967');
    expect(response.cast.length, 2);
    var cast = response.cast[0];
    expect(cast.character, 'Scar (voice)');
    expect(cast.name, 'Chiwetel Ejiofor');
    expect(cast.posterPath, '/kq5DDnqqofoRI0t6ddtRlsJnNPT.jpg');
    cast = response.cast[1];
    expect(cast.character, 'Zazu (voice)');
    expect(cast.name, 'John Oliver');
    expect(cast.posterPath, '/nGIg6FSlUMznQ2At7ECDlQfnb1a.jpg');
    expect(response.crew.length, 1);
    final crew = response.crew[0];
    expect(crew.job, 'Director');
    expect(crew.name, 'Jon Favreau');
    expect(crew.posterPath, '/8MtRRnEHaBSw8Ztdl8saXiw1egP.jpg');
    expect(response.genres, ['приключения', 'семейный']);
    expect(response.productionCountries.length, 1);
    final country = response.productionCountries[0];
    expect(country.code, 'US');
    expect(country.name, 'United States of America');
    expect(response.youtubeTrailerKey, 'kNhdUVgukVk');

    response = await ds.getMovieInfo('11');
    expect(response.youtubeTrailerKey, 'RsPxU8MNDJg');

    response = await ds.getMovieInfo('111');
    expect(response.youtubeTrailerKey, null);
  });

  test('getImageBasePath', () async {
    final client = MockClient();
    when(client.configuration())
        .thenAnswer((_) async => ConfigurationResponse.fromJson(json.decode('''
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

    when(client.configuration()).thenAnswer(
        (_) async => ConfigurationResponse.fromJson(json.decode('''{}''')));
    response = await ds.getImageBasePath();
    expect(response, isNull);
  });
}

class MockClient extends Mock implements TmdbClient {}
