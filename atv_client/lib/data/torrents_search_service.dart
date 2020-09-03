import 'package:domain/domain.dart';
import 'package:movie_info_provider/movie_info_provider.dart';

enum SearchMethod {
  fullPhrase,
  allWords,
  anyWord,
  logicalExpression,
}

enum SearchIn {
  title,
  titleAndDescription,
}

enum Category {
  any,
  foreignMovies,
  music,
  other,
  foreignTvShows,
  ourMovies,
  tv,
  cartoons,
  games,
  soft,
  anime,
  books,
  popularScienceFilms,
  sport,
  household,
  humor,
  ourTvShows,
  foreignReleases,
}

enum Sort {
  addDate,
  seeders,
  leechers,
  title,
  size,
  relevance,
}

enum Order {
  descending,
  ascending,
}

enum Quality {
  //TODO add quality
  all,
  fhd
}

class TorrentsSearchService {
  final _baseUrl = 'http://rutor.info/search/';
  final RutorTrackerDataSource _rutorTrackerDataSource;

  TorrentsSearchService(this._rutorTrackerDataSource);

  Future<List<MovieTorrentInfo>> search(
    String pattern, {
    SearchMethod searchMethod,
    SearchIn searchIn,
    Category category,
    Sort sort,
    Order order,
  }) async {
    final result = await _rutorTrackerDataSource.search(
      _baseUrl +
          getSearchParamsString(
            searchMethod: searchMethod,
            searchIn: searchIn,
            category: category,
            sort: sort,
            order: order,
          ) +
          pattern,
    );
    return result
        .map((e) => MovieTorrentInfo(
              magnetUrl: e.magnetUrl,
              title: e.title,
              leechers: e.leechers,
              seeders: e.seeders,
              size: e.size,
            ))
        .toList();
  }

  String getSearchParamsString({
    SearchMethod searchMethod,
    SearchIn searchIn,
    Category category,
    Sort sort,
    Order order,
  }) {
    return '0/${category?.index ?? 0}/'
        '${searchMethod?.index ?? 0}${searchIn?.index ?? 0}0/'
        '${(sort?.index ?? 0) * 2 + (order?.index ?? 0)}/';
  }
}
