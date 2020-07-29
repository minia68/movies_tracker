import 'package:meta/meta.dart';

class DetailResult {
  final String imdbId;
  final String kinopoiskId;
  final String magnetUrl;
  final String title;
  final double size;
  final int seeders;
  final int leechers;

  DetailResult(
      {@required this.imdbId,
      @required this.kinopoiskId,
      @required this.magnetUrl,
      @required this.title,
      @required this.size,
      @required this.seeders,
      @required this.leechers});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailResult &&
          runtimeType == other.runtimeType &&
          imdbId == other.imdbId &&
          kinopoiskId == other.kinopoiskId &&
          magnetUrl == other.magnetUrl &&
          title == other.title &&
          size == other.size &&
          seeders == other.seeders &&
          leechers == other.leechers;

  @override
  int get hashCode =>
      imdbId.hashCode ^
      kinopoiskId.hashCode ^
      magnetUrl.hashCode ^
      title.hashCode ^
      size.hashCode ^
      seeders.hashCode ^
      leechers.hashCode;
}
