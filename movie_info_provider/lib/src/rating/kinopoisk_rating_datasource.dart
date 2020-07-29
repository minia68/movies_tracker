
import '../html_page_provider.dart';
import 'rating.dart';
import 'rating_data_source.dart';

class KinopoiskRatingDataSource implements RatingDataSource {
  final HtmlPageProvider _htmlPageProvider;

  KinopoiskRatingDataSource(this._htmlPageProvider);

  @override
  Future<Rating> getRating(String kinopoiskId) async {
    final page = await _htmlPageProvider('https://rating.kinopoisk.ru/$kinopoiskId.xml');
    final imdbResult = _getResult(page, 'imdb_rating');
    final kinopoiskResult = _getResult(page, 'kp_rating');
    return Rating(
        imdbVoteAverage: imdbResult.imdbVoteAverage,
        imdbVoteCount: imdbResult.imdbVoteCount,
        kinopoiskVoteAverage: kinopoiskResult.imdbVoteAverage,
        kinopoiskVoteCount: kinopoiskResult.imdbVoteCount);
  }

  KinopoiskRatingResult _getResult(String data, String tagName) {
    try {
      final matches =
          RegExp('<$tagName num_vote="([0-9]+)">([0-9]*\.[0-9]*)</$tagName>')
              .allMatches(data)
              .toList();
      return KinopoiskRatingResult(
          double.parse(matches[0].group(2)), int.parse(matches[0].group(1)));
    } catch (e) {
      throw KinopoiskRatingException('wrong response format. ${e.toString()}');
    }
  }
}

class KinopoiskRatingResult {
  final double imdbVoteAverage;
  final int imdbVoteCount;

  KinopoiskRatingResult(this.imdbVoteAverage, this.imdbVoteCount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KinopoiskRatingResult &&
          runtimeType == other.runtimeType &&
          imdbVoteAverage == other.imdbVoteAverage &&
          imdbVoteCount == other.imdbVoteCount;

  @override
  int get hashCode => imdbVoteAverage.hashCode ^ imdbVoteCount.hashCode;

  @override
  String toString() {
    return 'Result{imdbVoteAverage: $imdbVoteAverage, imdbVoteCount: $imdbVoteCount}';
  }
}

class KinopoiskRatingException implements Exception {
  KinopoiskRatingException(this.message);

  final String message;

  @override
  String toString() {
    return 'KinopoiskRatingException{message: $message}';
  }
}
