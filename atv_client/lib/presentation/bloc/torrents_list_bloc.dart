import 'package:atv_channels/atv_channels.dart';

import '../../data/movies_service.dart';
import '../../model/config.dart';
import 'package:domain/domain.dart';
import 'package:rxdart/rxdart.dart';

enum TorrentsListSort { kinopoisk, imdb, tmdb, seeders }
typedef SortFunc = int Function(TorrentsListItem a, TorrentsListItem b);

class TorrentsListBloc {
  final MoviesService _moviesService;

  final _filterSubject =
      BehaviorSubject<TorrentsListSort>.seeded(TorrentsListSort.seeders);

  TorrentsListBloc(this._moviesService) {
    moviesList = Rx.combineLatest2(
      _filterSubject.stream,
      _moviesService.getMovies(),
      (TorrentsListSort filter, Config config) =>
          config.movies.map((movieInfo) {
        movieInfo.torrentsInfo.sort((a, b) => b.seeders.compareTo(a.seeders));
        return TorrentsListItem(movieInfo, config.imageBasePath);
      }).toList()
            ..sort(_getSortFunc(filter)),
    ).shareValue();
  }

  ValueStream<List<TorrentsListItem>> moviesList;


  Future<GetInitialDataResponse> getInitialData() {
    return _moviesService.channelsService.getInitialData();
  }

  void sort(TorrentsListSort type) {
    _filterSubject.add(type);
  }

  void dispose() {
    _filterSubject.close();
  }

  SortFunc _getSortFunc(TorrentsListSort type) {
    SortFunc sortFunc;
    switch (type) {
      case TorrentsListSort.kinopoisk:
        sortFunc = (TorrentsListItem a, TorrentsListItem b) => b
            .movieInfo.raiting.kinopoiskVoteAverage
            .compareTo(a.movieInfo.raiting.kinopoiskVoteAverage);
        break;
      case TorrentsListSort.imdb:
        sortFunc = (TorrentsListItem a, TorrentsListItem b) => b
            .movieInfo.raiting.imdbVoteAverage
            .compareTo(a.movieInfo.raiting.imdbVoteAverage);
        break;
      case TorrentsListSort.tmdb:
        sortFunc = (TorrentsListItem a, TorrentsListItem b) =>
            b.movieInfo.tmdbVoteAverage.compareTo(a.movieInfo.tmdbVoteAverage);
        break;
      case TorrentsListSort.seeders:
        sortFunc = (TorrentsListItem a, TorrentsListItem b) => b
            .movieInfo.torrentsInfo[0].seeders
            .compareTo(a.movieInfo.torrentsInfo[0].seeders);
        break;
    }
    return sortFunc;
  }
}

class TorrentsListItem {
  final MovieInfo _movieInfo;
  final String _imageBasePath;

  TorrentsListItem(this._movieInfo, this._imageBasePath);

  MovieInfo get movieInfo => _movieInfo;
  String get imageBasePath => _imageBasePath;
  String get imagePath => '${_imageBasePath}w300${_movieInfo.posterPath}';
}
