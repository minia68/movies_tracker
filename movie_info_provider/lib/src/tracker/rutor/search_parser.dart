import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:meta/meta.dart';

import '../search_result.dart';

class SearchParser {
  List<SearchParserResult> getSearchResults(String page, String baseUrl) {
    final document = parse(page);
    final index = document.getElementById('index');
    if (index == null) {
      throw SearchParserException('torrents block not found');
    }
    final trs = index.querySelectorAll('tr.gai, tr.tum');
    final result = <SearchParserResult>[];
    for (var tr in trs) {
      final tds = tr.children;
      Element mainElement, sizeElement, peersElement;
      if (tds.length == 4) {
        mainElement = tds[1];
        sizeElement = tds[2];
        peersElement = tds[3];
      } else if (tds.length == 5) {
        mainElement = tds[1];
        sizeElement = tds[3];
        peersElement = tds[4];
      } else {
        throw SearchParserException('wrong torrent block format');
      }

      int seeders, leechers;
      try {
        seeders =
            int.parse(peersElement.querySelector('span.green')?.text?.trim());
        leechers =
            int.parse(peersElement.querySelector('span.red')?.text?.trim());
      } catch (e) {
        throw SearchParserException('wrong peer block format. ${e.toString()}');
      }

      double size;
      try {
        final sizeStr = sizeElement.text;
        int multiplier;
        if (sizeStr.endsWith('GB')) {
          multiplier = 1024 * 1024 * 1024;
        } else if (sizeStr.endsWith('MB')) {
          multiplier = 1024 * 1024;
        } else if (sizeStr.endsWith('KB')) {
          multiplier = 1024;
        } else {
          multiplier = 1;
        }

        size = double.parse(sizeStr.split('\u00A0')[0]) * multiplier;
      } catch (e) {
        throw SearchParserException('wrong size block format. ${e.toString()}');
      }

      String magnetUrl, detailUrl, title;
      try {
        final mainElements = mainElement.getElementsByTagName('a');
        magnetUrl = mainElements[1].attributes['href'];
        if (!magnetUrl.startsWith('magnet')) {
          throw SearchParserException('wrong magnet url format');
        }

        detailUrl = mainElements[2].attributes['href'];
        if (detailUrl.isEmpty) {
          throw SearchParserException('wrong detail url format');
        }
        if (!detailUrl.startsWith('http')) {
          detailUrl = baseUrl + detailUrl;
        }

        title = mainElements[2].text?.trim();
      } catch (e) {
        throw SearchParserException('wrong main block format. ${e.toString()}');
      }

      result.add(SearchParserResult(
          detailUrl: detailUrl,
          magnetUrl: magnetUrl,
          title: title,
          size: size,
          seeders: seeders,
          leechers: leechers));
    }
    return result;
  }
}

class SearchParserResult extends SearchResult {
  final String magnetUrl;
  final String title;
  final double size;
  final int seeders;
  final int leechers;

  SearchParserResult(
      {@required String detailUrl,
      @required this.magnetUrl,
      @required this.title,
      @required this.size,
      @required this.seeders,
      @required this.leechers}) : super(detailUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParserResult &&
          runtimeType == other.runtimeType &&
          detailUrl == other.detailUrl &&
          magnetUrl == other.magnetUrl &&
          title == other.title &&
          size == other.size &&
          seeders == other.seeders &&
          leechers == other.leechers;

  @override
  int get hashCode =>
      detailUrl.hashCode ^
      magnetUrl.hashCode ^
      title.hashCode ^
      size.hashCode ^
      seeders.hashCode ^
      leechers.hashCode;

  @override
  String toString() {
    return 'Result{detailUrl: $detailUrl, magnetUrl: $magnetUrl, title: $title, size: $size, seeders: $seeders, leechers: $leechers}';
  }
}

class SearchParserException implements Exception {
  SearchParserException(this.message);

  final String message;

  @override
  String toString() {
    return 'SearchParserException{message: $message}';
  }
}
