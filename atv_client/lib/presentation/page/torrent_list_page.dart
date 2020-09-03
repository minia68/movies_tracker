import 'package:android_intent/android_intent.dart';
import 'package:atv_channels/atv_channels.dart';
import 'package:atv_client/presentation/search/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../torrents_list_controller.dart';

class TorrentsListPage extends StatefulWidget {
  @override
  _TorrentsListPageState createState() => _TorrentsListPageState();
}

class _TorrentsListPageState extends State<TorrentsListPage>
    with TickerProviderStateMixin {
  PageStorageKey<String> moviesKey = PageStorageKey<String>('_buildMovies');
  final TorrentsListController bloc = Get.find();

  @override
  void initState() {
    print('initState');
    super.initState();
    AtvChannelsApiFlutter.setup(bloc);
    bloc.checkInitData();
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build ---------------');
    return WillPopScope(
      onWillPop: bloc.onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          print('build --------------- ${bloc.moviesList.value.data == null}');
          if (bloc.moviesList.value.error != null) {
            return Center(
              child: Text(
                'Error: ${bloc.moviesList.value.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (bloc.moviesList.value.data != null) {
            return _buildMain(bloc.moviesList.value.data);
          } else {
            return Center(
              child: SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildMain(List<TorrentsListItem> data) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          right: size.width * 0.7,
          child: Obx(() => CustomAnimation(
                duration: Duration(milliseconds: 200),
                tween: Tween(begin: size.width * -0.3, end: 0.0),
                builder: (_, child, value) => Transform.translate(
                  child: child,
                  offset: Offset(value, 0.0),
                ),
                control: _getShowSortAnimationControl(bloc.showSort.value),
                child: bloc.showSort.value ?? false ? _sortList() : Container(),
              )),
        ),
        Positioned.fill(
          child: Obx(() => CustomAnimation(
                duration: Duration(milliseconds: 200),
                tween: Tween(begin: 0.0, end: size.width * 0.3),
                builder: (_, child, value) => Transform.translate(
                  child: child,
                  offset: Offset(value, 0.0),
                ),
                control: _getShowSortAnimationControl(bloc.showSort.value),
                child: _buildBody(data),
              )),
        ),
      ],
    );
  }

  Widget _buildBody(List<TorrentsListItem> data) {
    final size = MediaQuery.of(context).size;
    final backdropImageLeft = size.width * 0.3;
    final backdropImageBottom = size.height * 0.3;
    final infoRight = size.width * 0.6;
    final infoTop = 32.0;
    final moviesTop = size.height * 0.6;
    final torrentsTop = size.height * 0.4;
    final torrentsLeft = size.width * 0.4;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          left: backdropImageLeft,
          bottom: backdropImageBottom,
          child: Obx(() {
            print('original ${bloc.backdropIndex.value}');
            final focusedMovieInfo = data[bloc.backdropIndex.value];
            return CachedNetworkImage(
              imageUrl: '${focusedMovieInfo.imageBasePath}original'
                  '${focusedMovieInfo.movieInfo.backdropPath ?? focusedMovieInfo.movieInfo.posterPath}',
              fit: BoxFit.cover,
              useOldImageOnUrlChange: true,
            );
          }),
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
          top: infoTop,
          right: infoRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Obx(() {
              print('_buildInfo ${bloc.focusedIndex.value}');
              return _buildInfo(data[bloc.focusedIndex.value].movieInfo);
            }),
          ),
        ),
        Obx(() {
          print('AnimatedPositioned ${bloc.selected.value}');
          final selected = bloc.selected.value;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: selected ? torrentsTop : moviesTop,
            bottom: 0,
            left: selected ? torrentsLeft : 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              reverseDuration: const Duration(milliseconds: 200),
              child: selected
                  ? _buildTorrents(data[bloc.focusedIndex.value].movieInfo)
                  : _buildMovies(data),
            ),
          );
        }),
        Positioned(
          left: 0,
          top: 0,
          child:
              Obx(() => !bloc.selected.value ? _buildActions() : Container()),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        IconButton(
          focusNode: bloc.sortButtonFocusNode,
          icon: Icon(Icons.sort),
          onPressed: bloc.onSortButtonPressed,
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SearchPage())),
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
            child: Obx(() {
              print('overview ${bloc.selected.value}');
              return FocusScope(
                autofocus: false,
                canRequestFocus: bloc.selected.value,
                onKey: bloc.onInfoOverviewKey,
                child: SingleChildScrollView(
                  controller: bloc.infoScrollController,
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: Text(
                      movieInfo.overview, //+
                      // '11111111111111111111111111111111111111111111111111111111111111111111111111111111'
                      //     '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
                      //     '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
                      //     '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222'
                      //     '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222'
                      //     '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222',
                      style: TextStyle(fontSize: 16),
                      overflow:
                          bloc.selected.value ? null : TextOverflow.ellipsis,
                      maxLines: bloc.selected.value ? null : 6,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Flexible(
          flex: 1,
          child: Obx(() {
            print('Director ${bloc.selected.value}');
            if (!bloc.selected.value) {
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
          }),
        ),
      ],
    );
  }

  Widget _buildMovies(List<TorrentsListItem> data) {
    return FocusScope(
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: bloc.moviesFocusNode,
        onKey: (key) => bloc.onKey(key.logicalKey),
        child: _buildMoviesList(data),
      ),
    );
  }

  Widget _buildMoviesList(List<TorrentsListItem> data) {
    const width = 138.0;
    const height = 200.0;
    const padding = 16.0;
    return ScrollablePositionedList.builder(
      itemScrollController: bloc.moviesScrollController,
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
            child: Obx(() {
              print('_buildMoviesList ${bloc.focusedIndex.value}');
              final focusedIndex = bloc.focusedIndex.value;
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
            }),
          ),
        );
      },
    );
  }

  Widget _buildTorrents(MovieInfo movieInfo) {
    print('_buildTorrents');
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          RaisedButton(
            autofocus: true,
            focusNode: bloc.trailerFocusNode,
            onPressed: () => _openYoutube(movieInfo.youtubeTrailerKey),
            child: Text('Trailer'),
          ),
          ...(movieInfo.torrentsInfo
              // ..addAll([
              //   ...movieInfo.torrentsInfo,
              //   ...movieInfo.torrentsInfo,
              //   ...movieInfo.torrentsInfo,
              //   ...movieInfo.torrentsInfo,
              //   ...movieInfo.torrentsInfo,
              // ])
              )
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
      print(s); //TODO show snackbar
    }
  }

  void _openTorrent(String magnetUrl) {} //TODO open torrent

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

  Widget _sortList() {
    return FocusScope(
      node: bloc.sortListFocusNode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sort by:'),
          ),
          Expanded(
            child: ListView(
              children: [
                _sortListItem(TorrentsListSort.kinopoisk, 'kinopoisk'),
                _sortListItem(TorrentsListSort.imdb, 'imdb'),
                _sortListItem(TorrentsListSort.tmdb, 'tmdb'),
                _sortListItem(TorrentsListSort.seeders, 'seeders'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortListItem(TorrentsListSort sortType, String title) {
    final current = bloc.filter.value == sortType;
    return RawMaterialButton(
      autofocus: current,
      onPressed: () => bloc.onSort(sortType),
      child: Text(
        title,
        style: TextStyle(color: current ? Theme.of(context).accentColor : null),
      ),
    );
  }

  CustomAnimationControl _getShowSortAnimationControl(bool showSort) {
    switch (showSort) {
      case true:
        return CustomAnimationControl.PLAY_FROM_START;
      case false:
        return CustomAnimationControl.PLAY_REVERSE_FROM_END;
      default:
        return CustomAnimationControl.STOP;
    }
  }
}
