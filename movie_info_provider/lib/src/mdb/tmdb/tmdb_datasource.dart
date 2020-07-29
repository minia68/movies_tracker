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
    final response = await _client.find(id, _language, 'imdb_id');
    if (response.movieResults.length != 1) {
      return null;
    }
    final movieResult = response.movieResults[0];
    return MdbMovieInfo(
      id: movieResult.id.toString(),
      posterPath: movieResult.posterPath,
      overview: movieResult.overview,
      releaseDate: DateTime.parse(movieResult.releaseDate),
      title: movieResult.title,
      backdropPath: movieResult.backdropPath,
      popularity: movieResult.popularity,
      voteAverage: movieResult.voteAverage,
      voteCount: movieResult.voteCount,
    );
  }
}
