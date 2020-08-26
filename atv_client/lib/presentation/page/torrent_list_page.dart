import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:atv_channels/atv_channels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../bloc/torrents_list_bloc.dart';

class TorrentsListPage extends StatefulWidget {
  final TorrentsListBloc bloc;

  TorrentsListPage({Key key, @required this.bloc}) : super(key: key);

  @override
  _TorrentsListPageState createState() => _TorrentsListPageState();
}

class _TorrentsListPageState extends State<TorrentsListPage>
    with TickerProviderStateMixin
    implements AtvChannelsApiFlutter {
  BehaviorSubject<LogicalKeyboardKey> keySubject;
  BehaviorSubject<int> focusedIndexSubject;
  BehaviorSubject<bool> selectedSubject;
  StreamSubscription<int> focusedIndexStreamSubscription;
  StreamSubscription selectedSubjectSubscription;
  FocusNode focusNode;
  ItemScrollController scrollController = ItemScrollController();
  PageStorageKey<String> moviesKey = PageStorageKey<String>('_buildMovies');
  ScrollController infoController;
  FocusNode trailerFocusNode;

  @override
  void showChannel(ShowRequest arg) {
    print('showChannel ${arg.channelExternalId}');
    if (selectedSubject.value) {
      selectedSubject.add(false);
    }
  }

  @override
  void showProgram(ShowRequest arg) {
    print('showChannel ${arg.channelExternalId} ${arg.programExternalId}');
    final idx = widget.bloc.moviesList.value
        ?.indexWhere((e) => e.movieInfo.imdbId == arg.programExternalId);
    if (idx >= 0) {
      focusedIndexSubject.add(idx);
      selectedSubject.add(true);
    } else {
      print('idx $idx');
    }
  }

  @override
  void initState() {
    super.initState();
    keySubject = BehaviorSubject<LogicalKeyboardKey>();
    selectedSubject = BehaviorSubject<bool>();
    focusedIndexSubject = BehaviorSubject<int>();
    focusNode = FocusNode();
    trailerFocusNode = FocusNode();
    infoController = ScrollController();
    focusedIndexStreamSubscription = widget.bloc.moviesList
        .switchMap(_mapKeys)
        .distinct()
        .listen((focusedIndex) {
      print('----------------------- StreamBuilder $focusedIndex');
      focusedIndexSubject.add(focusedIndex);
      if (scrollController.isAttached) {
        scrollController.scrollTo(
            index: focusedIndex, duration: Duration(milliseconds: 100));
      }
    });
    selectedSubjectSubscription = keySubject
        .where((e) => e == LogicalKeyboardKey.select)
        .throttleTime(Duration(milliseconds: 200))
        .listen((event) => selectedSubject.add(true));

    AtvChannelsApiFlutter.setup(this);

    _checkInitData();
  }

  @override
  void dispose() {
    focusedIndexStreamSubscription.cancel();
    selectedSubjectSubscription.cancel();
    widget.bloc.dispose();
    focusedIndexSubject.close();
    selectedSubject.close();
    keySubject.close();
    focusNode.dispose();
    infoController.dispose();
    trailerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
//      appBar: AppBar(
//        //title: Text('qwewq'),
//        actions: <Widget>[
//          PopupMenuButton<TorrentsListSort>(
//            onSelected: widget.bloc.sort,
//            itemBuilder: (BuildContext context) => _filterListActions(),
//            icon: Icon(Icons.filter_list),
//          ),
//        ],
//      ),
        body: StreamBuilder<List<TorrentsListItem>>(
          stream: widget.bloc.moviesList,
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error.toString()}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            if (snapshot.hasData) {
              return _buildBody(snapshot.data);
            } else {
              return Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(List<TorrentsListItem> data) {
    final size = MediaQuery.of(context).size;
    final backdropImageLeft = size.width * 0.3;
    final backdropImageBottom = size.height * 0.4;
    final infoRight = size.width * 0.6;
    final moviesTop = size.height * 0.4;
    final torrentsTop = size.height * 0.5;
    final torrentsLeft = size.width * 0.4;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          left: backdropImageLeft,
          bottom: backdropImageBottom,
          child: StreamBuilder<int>(
            initialData: 0,
            stream:
                focusedIndexSubject.debounceTime(Duration(milliseconds: 400)),
            builder: (_, snapshot) {
              print('original ${snapshot.data}');
              if (!snapshot.hasData) {
                return Container();
              }
              final focusedMovieInfo = data[snapshot.data];
              return CachedNetworkImage(
                imageUrl: '${focusedMovieInfo.imageBasePath}original'
                    '${focusedMovieInfo.movieInfo.backdropPath ?? focusedMovieInfo.movieInfo.posterPath}',
                fit: BoxFit.cover,
                useOldImageOnUrlChange: true,
              );
            },
          ),
        ),
        Positioned.fill(
          left: backdropImageLeft,
          bottom: backdropImageBottom,
          child: _buildBackdrop(true),
        ),
        Positioned.fill(
          left: backdropImageLeft,
          bottom: backdropImageBottom,
          child: _buildBackdrop(false),
        ),
        Positioned.fill(
          right: infoRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: StreamBuilder<int>(
              initialData: 0,
              stream: focusedIndexSubject,
              builder: (_, snapshot) {
                print('_buildInfo ${snapshot.data}');
                if (!snapshot.hasData) {
                  return Container();
                }
                return _buildInfo(data[snapshot.data].movieInfo);
              },
            ),
          ),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: selectedSubject,
          builder: (_, snapshot) {
            print('AnimatedPositioned ${snapshot.data}');
            if (!snapshot.hasData) {
              return Container();
            }
            final selected = snapshot.data;
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: selected ? torrentsTop : moviesTop,
              bottom: selected ? 0 : 100,
              left: selected ? torrentsLeft : 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 200),
                child: selected
                    ? _buildTorrents(data[focusedIndexSubject.value].movieInfo)
                    : _buildMovies(data),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBackdrop(bool bottom) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: bottom
              ? FractionalOffset.bottomCenter
              : FractionalOffset.centerLeft,
          end: FractionalOffset.center,
          colors: [
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.7],
        ),
      ),
    );
  }

  Widget _buildInfo(MovieInfo movieInfo) {
    return Column(
      children: <Widget>[
        Text(
          movieInfo.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _ratingRow(8, 16, 4, 14, movieInfo),
        SizedBox(height: 16),
        Flexible(
          flex: 3,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            vsync: this,
            child: StreamBuilder<bool>(
              initialData: false,
              stream: selectedSubject,
              builder: (_, snapshot) {
                print('overview ${snapshot.data}');
                if (!snapshot.hasData) {
                  return Container();
                }
                return FocusScope(
                  autofocus: false,
                  canRequestFocus: snapshot.data,
                  onKey: _onInfoOverviewKey,
                  child: SingleChildScrollView(
                    controller: infoController,
                    child: RawMaterialButton(
                      onPressed: () {},
                      child: Text(
                        movieInfo.overview +
                            '11111111111111111111111111111111111111111111111111111111111111111111111111111111'
                                '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
                                '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
                                '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222'
                                '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222'
                                '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222',
                        style: TextStyle(fontSize: 16),
                        overflow: snapshot.data ? null : TextOverflow.ellipsis,
                        maxLines: snapshot.data ? null : 3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: StreamBuilder<bool>(
            initialData: false,
            stream: selectedSubject,
            builder: (_, snapshot) {
              print('Director ${snapshot.data}');
              if (!snapshot.hasData || !snapshot.data) {
                return Container();
              }
              return Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                      'Director: ${movieInfo.crew?.firstWhere((e) => e.job == 'Director', orElse: () => null)?.name ?? ''}'),
                  SizedBox(height: 8),
                  Text(
                      'Cast: ${movieInfo.cast?.take(10)?.map((e) => e.name)?.join(', ') ?? ''}'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovies(List<TorrentsListItem> data) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKey: (key) => keySubject.add(key.logicalKey),
      child: _buildMoviesList(data),
    );
  }

  Widget _buildMoviesList(List<TorrentsListItem> data) {
    const width = 138.0;
    const height = 200.0;
    const padding = 16.0;
    return ScrollablePositionedList.builder(
      itemScrollController: scrollController,
      key: moviesKey,
      padding: const EdgeInsets.symmetric(horizontal: padding / 2),
      itemCount: data.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, index) {
        final movieInfo = data[index];
        return SizedBox(
          width: width,
          height: height,
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 200),
            child: StreamBuilder<int>(
              initialData: 0,
              stream: focusedIndexSubject,
              builder: (_, snapshot) {
                print('_buildMoviesList ${snapshot.data}');
                if (!snapshot.hasData) {
                  return Container();
                }
                final focusedIndex = snapshot.data;
                return Container(
                  padding: focusedIndex == index
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.symmetric(horizontal: padding / 2),
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: movieInfo.imagePath,
                    fit: BoxFit.cover,
                    width: focusedIndex == index ? width : width - padding,
                    height: focusedIndex == index ? height : height - padding,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTorrents(MovieInfo movieInfo) {
    print('_buildTorrents');
    trailerFocusNode.requestFocus();
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          RaisedButton(
            focusNode: trailerFocusNode,
            onPressed: () => _openYoutube(movieInfo.youtubeTrailerKey),
            child: Text('Trailer'),
          ),
          ...(movieInfo.torrentsInfo
                ..addAll([
                  ...movieInfo.torrentsInfo,
                  ...movieInfo.torrentsInfo,
                  ...movieInfo.torrentsInfo,
                  ...movieInfo.torrentsInfo,
                  ...movieInfo.torrentsInfo,
                ]))
              .map((data) => RawMaterialButton(
                    onPressed: () => _openTorrent(data.magnetUrl),
                    child: ListTile(
                      title: Text(
                        '${data.title}',
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        '${(data.size / 1000000000).toStringAsFixed(1)} GB '
                        'S:${data.seeders} L:${data.leechers}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )),
        ],
      ).toList(),
    );
  }

  void _openYoutube(String youtubeTrailerKey) async {
    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data:
            'https://www.youtube.com/watch?v=$youtubeTrailerKey', //'vnd.youtube:${movieInfo.youtubeTrailerKey}',
        package: 'com.google.android.youtube',
      );
      await intent.launch();
    } catch (_, s) {
      print('=-=-=-=-=-=-=-=-=-=-=');
      print(s);
    }
  }

  void _openTorrent(String magnetUrl) {}

  Widget _ratingRow(double mainSpacing, double imageSize,
      double secondarySpacing, double fontSize, MovieInfo movieInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ..._rating(
          'assets/kinopoisk.png',
          'https://www.kinopoisk.ru/film/${movieInfo.kinopoiskId}',
          '${movieInfo.raiting.kinopoiskVoteAverage.toStringAsFixed(1)}/'
              '${movieInfo.raiting.kinopoiskVoteCount}',
          imageSize,
          secondarySpacing,
          fontSize,
        ),
        SizedBox(width: mainSpacing),
        ..._rating(
          'assets/imdb.png',
          'https://www.imdb.com/title/${movieInfo.imdbId}',
          '${movieInfo.raiting.imdbVoteAverage.toStringAsFixed(1)}/'
              '${movieInfo.raiting.imdbVoteCount}',
          imageSize,
          secondarySpacing,
          fontSize,
        ),
        SizedBox(width: mainSpacing),
        ..._rating(
          'assets/tmdb.png',
          'https://www.themoviedb.org/movie/${movieInfo.tmdbId}',
          '${movieInfo.tmdbVoteAverage.toStringAsFixed(1)}/'
              '${movieInfo.tmdbVoteCount}',
          imageSize,
          secondarySpacing,
          fontSize,
        ),
      ],
    );
  }

  List<Widget> _rating(String asset, String url, String rating,
      double imageSize, double spacing, double fontSize) {
    return [
      Image.asset(asset, width: imageSize, height: imageSize),
      SizedBox(width: spacing),
      Text(rating, style: TextStyle(fontSize: fontSize)),
    ];
  }

  Future<bool> _onWillPop() async {
    if (selectedSubject?.value ?? false) {
      selectedSubject.add(false);
      trailerFocusNode?.unfocus();
      return false;
    }
    return true;
  }

  Stream<int> _mapKeys(List<TorrentsListItem> data) {
    return keySubject
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

  bool _onInfoOverviewKey(FocusNode node, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      infoController.jumpTo(infoController.offset - 20);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      infoController.jumpTo(infoController.offset + 20);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      trailerFocusNode.focusInDirection(TraversalDirection.down);
    }
    return false;
  }

  Future<void> _checkInitData() async {
    final result = await widget.bloc.getInitialData();
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
}
