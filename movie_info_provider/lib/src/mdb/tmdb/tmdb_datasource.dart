import '../mdb_datasource.dart';
import '../mdb_movie_info.dart';
import 'client.dart';

class TmdbDataSource implements MdbDataSource {
  final TmdbClient _client;
  final String _language;

  TmdbDataSource(this._client, {String language})
      : _language = language ?? 'ru-RU';

  @override
  Future<String> getImageBasePath() async {
    final response = await _client.configuration();
    return response.images?.baseUrl;
  }

  @override
  Future<MdbMovieInfo> getMovieInfo(String id) async {
    final findResponse = await _client.find(id, _language, 'imdb_id');
    if (findResponse.movieResults.length != 1) {
      return null;
    }
    final movieResult = findResponse.movieResults[0];

    final movie = await _client.getMovie(movieResult.id, _language);

    final video = movie.videos?.results?.firstWhere(
            (e) => e.type == 'Trailer' && e.site == 'YouTube',
            orElse: () => null) ??
        movie.videos?.results?.firstWhere(
            (e) => e.type == 'Teaser' && e.site == 'YouTube',
            orElse: () => null);

    return MdbMovieInfo(
      id: movieResult.id.toString(),
      posterPath: movieResult.posterPath,
      overview: movieResult.overview,
      releaseDate: movieResult.releaseDate != null
          ? DateTime.parse(movieResult.releaseDate)
          : null,
      title: movieResult.title,
      backdropPath: movieResult.backdropPath,
      popularity: movieResult.popularity,
      voteAverage: movieResult.voteAverage,
      voteCount: movieResult.voteCount,
      cast: movie.credits?.cast
          ?.map((e) => MdbMovieCast(
                character: e.character,
                name: e.name,
                posterPath: e.profilePath,
              ))
          ?.toList(),
      crew: movie.credits?.crew
          ?.map((e) => MdbMovieCrew(
                job: e.job,
                name: e.name,
                posterPath: e.profilePath,
              ))
          ?.toList(),
      genres: movie.genres?.map((e) => e.name)?.toList(),
      productionCountries: movie.productionCountries
          ?.map((e) => MdbMovieCountry(
                code: e.code,
                name: e.name,
              ))
          ?.toList(),
      youtubeTrailerKey: video?.key,
    );
  }
}
