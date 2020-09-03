import 'dart:async';

import 'package:atv_channels/atv_channels.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../model/config.dart';
import '../data/movies_service.dart';

enum TorrentsListSort { kinopoisk, imdb, tmdb, seeders }
typedef SortFunc = int Function(TorrentsListItem a, TorrentsListItem b);

class TorrentsListController extends GetxController
    implements AtvChannelsApiFlutter {
  final MoviesService _moviesService;
  rx.BehaviorSubject<LogicalKeyboardKey> _keySubject;
  rx.ValueStream<List<TorrentsListItem>> _moviesList;
  final focusedIndex = 0.obs;
  final selected = false.obs;
  final moviesList = TorrentsListState().obs;
  final filter = TorrentsListSort.seeders.obs;
  final backdropIndex = 0.obs;
  final ItemScrollController moviesScrollController = ItemScrollController();
  ScrollController infoScrollController;
  FocusNode trailerFocusNode;
  FocusNode moviesFocusNode;
  FocusScopeNode sortListFocusNode;
  FocusNode sortButtonFocusNode;
  StreamSubscription _sortButtonFocusStreamSubscription;
  final showSort = RxBool();

  TorrentsListController(this._moviesService);

  @override
  void showChannel(ShowRequest arg) {
    print('showChannel ${arg.channelExternalId}');
    if (selected.value) {
      selected.value = false;
    }
  }

  @override
  void showProgram(ShowRequest arg) {
    print('showChannel ${arg.channelExternalId} ${arg.programExternalId}');
    final idx = moviesList.value.data
        ?.indexWhere((e) => e.movieInfo.imdbId == arg.programExternalId);
    if (idx >= 0) {
      focusedIndex.value = idx;
      selected.value = true;
    } else {
      print('idx $idx');
    }
  }

  Future _init() async {
  }

  @override
  void onInit() {
    print('onInit ====================');
    _init();

    infoScrollController = ScrollController();
    trailerFocusNode = FocusNode();
    moviesFocusNode = FocusNode();
    sortListFocusNode = FocusScopeNode();
    sortButtonFocusNode = FocusNode();

    _moviesList = rx.Rx.combineLatest2(
      filter.stream,
      _moviesService.getMovies().where(
          (event) => event.movies != null && event.imageBasePath != null),
      (TorrentsListSort filter, Config config) {
        print('===================  combineLatest2');
        return config.movies.map((movieInfo) {
          movieInfo.torrentsInfo.sort((a, b) => b.seeders.compareTo(a.seeders));
          return TorrentsListItem(movieInfo, config.imageBasePath);
        }).toList()
          ..sort(_getSortFunc(filter));
      },
    ).shareValue();
    moviesList.bindStream(_moviesList
        .map((event) => TorrentsListState(data: event))
        .onErrorReturnWith(
            (error) => TorrentsListState(error: error.toString())));
    filter.value = TorrentsListSort.seeders;

    _keySubject = rx.BehaviorSubject<LogicalKeyboardKey>();

    focusedIndex.bindStream(_moviesList.switchMap(_mapKeys).distinct());
    ever(focusedIndex, (value) {
      print('scrollController ========================');
      if (moviesScrollController.isAttached) {
        moviesScrollController.scrollTo(
            index: value, duration: Duration(milliseconds: 100));
      }
    });
    backdropIndex.bindStream(
        focusedIndex.stream.debounceTime(Duration(milliseconds: 400)));

    selected.bindStream(_keySubject
        .where((e) => e == LogicalKeyboardKey.select)
        .throttleTime(Duration(milliseconds: 200))
        .map((_) => true));

    _sortButtonFocusStreamSubscription = _keySubject
        .where((event) => event == LogicalKeyboardKey.arrowUp)
        .throttleTime(Duration(milliseconds: 200))
        .listen((_) => sortButtonFocusNode?.requestFocus());
  }

  @override
  void onClose() {
    print('onClose ====================');
    _keySubject?.close();
    _sortButtonFocusStreamSubscription?.cancel();
    sortButtonFocusNode?.dispose();
    infoScrollController?.dispose();
    trailerFocusNode?.dispose();
    moviesFocusNode?.dispose();
    sortListFocusNode?.dispose();
  }

  void onKey(LogicalKeyboardKey key) {
    print('++++++++++++++++++ onKey ${showSort.value} $key');
    _keySubject.add(key);
  }

  void onSort(TorrentsListSort type) {
    showSort.value = false;
    focusedIndex.value = 0;
    filter.value = type;
  }

  bool onInfoOverviewKey(FocusNode node, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      infoScrollController.jumpTo(infoScrollController.offset - 20);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      infoScrollController.jumpTo(infoScrollController.offset + 20);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      trailerFocusNode.focusInDirection(TraversalDirection.down);
    }
    return false;
  }

  Future<bool> onWillPop() async {
    if (selected.value) {
      selected.value = false;
      trailerFocusNode?.unfocus();
      return false;
    } else if (showSort.value ?? false) {
      showSort.value = false;
      moviesFocusNode.requestFocus();
      return false;
    }
    return true;
  }

  void onSortButtonPressed() {
    showSort.value = true;
    sortListFocusNode.requestFocus();
  }

  Future<void> checkInitData() async {
    final result = await _moviesService.channelsService.getInitialData();
    if (result.channelExternalId != null) {
      if (result.programExternalId != null) {
        showProgram(ShowRequest()
          ..programExternalId = result.programExternalId
          ..channelExternalId = result.channelExternalId);
      } else {
        showChannel(
            ShowRequest()..channelExternalId = result.channelExternalId);
      }
    } else {
      print('result.channelExternalId == null');
    }
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

  Stream<int> _mapKeys(List<TorrentsListItem> data) {
    return _keySubject
        .where((e) =>
            e == LogicalKeyboardKey.arrowLeft ||
            e == LogicalKeyboardKey.arrowRight)
        .throttleTime(Duration(milliseconds: 200))
        .scan((acc, value, _) {
      if ((value == LogicalKeyboardKey.arrowLeft && acc > 0) ||
          (value == LogicalKeyboardKey.arrowRight && acc < data.length - 1)) {
        return value == LogicalKeyboardKey.arrowLeft ? acc - 1 : acc + 1;
      }
      return acc;
    }, 0);
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

class TorrentsListState {
  final String error;
  final List<TorrentsListItem> data;

  TorrentsListState({this.error, this.data});
}
