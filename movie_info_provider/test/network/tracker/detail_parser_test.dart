import 'dart:io';

import 'package:movie_info_provider/src/tracker/rutor/detail_parser.dart';
import 'package:test/test.dart';


void main() {
  test('imdbId not found', () {
    final searchParser = DetailParser();
    try {
      searchParser.getTorrentDetail(
          '<a href="http://imdb.com/title//" target="_blank"></a>');
      throw Exception();
    } on DetailParserException catch (e) {
      expect(e.message, 'id not found');
    }
  });
  test('kinopoiskId not found', () {
    final searchParser = DetailParser();
    try {
      searchParser.getTorrentDetail(
          '<a href="http://www.imdb.com/title/123/" target="_blank"></a>');
      throw Exception();
    } on DetailParserException catch (e) {
      expect(e.message, 'id not found');
    }
  });

  test('getTorrentDetail', () {
    final page = File(
            'test/assets/detail.html')
        .readAsStringSync();
    final searchParser = DetailParser();
    expect(
        searchParser.getTorrentDetail(page),
        DetailParserResult(
            kinopoiskId: '1128272', imdbId: 'tt8106534'));
  });
}
