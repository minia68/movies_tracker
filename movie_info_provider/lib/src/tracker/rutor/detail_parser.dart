import 'package:meta/meta.dart';

class DetailParser {
  DetailParserResult getTorrentDetail(String page) {
    final imdbId = _getId(page, '"http://www.imdb.com/title/(.*?)/"');
    String kinopoiskId;
    try {
      kinopoiskId = _getId(page, '"http://www.kinopoisk.ru/film/(.*?)/"');
    } catch (_) {
      kinopoiskId =
          _getId(page, '"http://www.kinopoisk.ru/level/1/film/(.*?)/"');
    }
    return DetailParserResult(imdbId: imdbId, kinopoiskId: kinopoiskId);
  }

  String _getId(String page, String url) {
    final matches = RegExp(url).allMatches(page).toList();
    if (matches.isEmpty || matches[0].groupCount < 1) {
      throw DetailParserException('id not found');
    }
    return matches[0].group(1);
  }
}

class DetailParserResult {
  final String imdbId;
  final String kinopoiskId;

  DetailParserResult({@required this.imdbId, @required this.kinopoiskId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailParserResult &&
          runtimeType == other.runtimeType &&
          imdbId == other.imdbId &&
          kinopoiskId == other.kinopoiskId;

  @override
  int get hashCode => imdbId.hashCode ^ kinopoiskId.hashCode;

  @override
  String toString() {
    return 'Result{imdbId: $imdbId, kinopoiskId: $kinopoiskId}';
  }
}

class DetailParserException implements Exception {
  DetailParserException(this.message);

  final String message;

  @override
  String toString() {
    return 'DetailParserException{message: $message}';
  }
}
