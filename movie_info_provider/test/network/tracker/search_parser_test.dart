import 'dart:io';

import 'package:movie_info_provider/src/tracker/rutor/search_parser.dart';
import 'package:test/test.dart';


void main() {
  test('torrents block not found', () {
    final page = '<html></html>';
    final searchParser = SearchParser();
    expect(
        () => searchParser.getSearchResults(page, 'null'),
        throwsA(predicate((e) =>
            e is SearchParserException &&
            e.message == 'torrents block not found')));
  });

  test('wrong torrent block format', () {
    final page =
        '<html><div id="index"><table><tr class="gai"><td></td></tr></table></div></html>';
    final searchParser = SearchParser();
    expect(
        () => searchParser.getSearchResults(page, 'null'),
        throwsA(predicate((e) =>
            e is SearchParserException &&
            e.message == 'wrong torrent block format')));
  });

  test('wrong peer block format', () {
    final page =
        '<html><div id="index"><table><tr class="gai"><td></td><td></td><td></td><td></td></tr></table></div></html>';
    final searchParser = SearchParser();
    expect(
        () => searchParser.getSearchResults(page, 'null'),
        throwsA(predicate((e) =>
            e is SearchParserException &&
            e.message.startsWith('wrong peer block format'))));
  });

  test('wrong size block format', () {
    final page =
        '<html><div id="index"><table><tr class="gai"><td></td><td></td><td></td><td><span class="green">1</span><span class="red">2</span></td></tr></table></div></html>';
    final searchParser = SearchParser();
    expect(
        () => searchParser.getSearchResults(page, 'null'),
        throwsA(predicate((e) =>
            e is SearchParserException &&
            e.message.startsWith('wrong size block format'))));
  });

  test('wrong main block format magnet', () {
    final page = '''<html><div id="index"><table><tr class="gai">
        <td></td>
        <td><a href=""></a></td>
        <td>12&nbsp;GB</td>
        <td><span class="green">1</span><span class="red">2</span></td>
        </tr></table></div></html>''';
    final searchParser = SearchParser();
    expect(
        () => searchParser.getSearchResults(page, 'null'),
        throwsA(predicate((e) =>
            e is SearchParserException &&
            e.message.startsWith('wrong main block format'))));
  });

  test('wrong main block format detail', () {
    final page = '''<html><div id="index"><table><tr class="gai">
        <td></td>
        <td><a href="magnet"></a></td>
        <td>12\u00A0GB</td>
        <td><span class="green">1</span><span class="red">2</span></td>
        </tr></table></div></html>''';
    final searchParser = SearchParser();
    expect(
        () => searchParser.getSearchResults(page, 'null'),
        throwsA(predicate((e) =>
            e is SearchParserException &&
            e.message.startsWith('wrong main block format'))));
  });

  test('getSearchResults', () {
    final page =
        File('test/assets/search.html').readAsStringSync();
    final searchParser = SearchParser();
    expect(searchParser.getSearchResults(page, 'null').take(3).toList(), [
      SearchParserResult(
          magnetUrl:
              'magnet:?xt=urn:btih:2d3702c1c9b471ed6dbe05dec41c09941fe92b6f&dn=rutor.info&tr=udp://opentor.org:2710&tr=udp://opentor.org:2710&tr=http://retracker.local/announce',
          detailUrl:
              'http://tor-ru.top/torrent/734378/shestero-vne-zakona_6-underground-2019-web-dl-1080p-pifagor',
          title:
              'Шестеро вне закона / 6 Underground (2019) WEB-DL 1080p | Пифагор',
          size: 7.9 * 1024 * 1024 * 1024,
          seeders: 2928,
          leechers: 322),
      SearchParserResult(
          detailUrl:
              'http://tor-ru.top/torrent/734318/kod-8_code-8-2019-web-dl-1080p-ot-selezen-itunes',
          magnetUrl:
              'magnet:?xt=urn:btih:c0ae304ff301418d29db31084bcbe6d9d4ae2398&dn=rutor.info&tr=udp://opentor.org:2710&tr=udp://opentor.org:2710&tr=http://retracker.local/announce',
          title:
              'Код 8 / Code 8 (2019) WEB-DL 1080p от селезень | iTunes',
          size: 3.51 * 1024 * 1024 * 1024,
          seeders: 2604,
          leechers: 178),
      SearchParserResult(
          magnetUrl:
              'magnet:?xt=urn:btih:ac6081f28027bbef531eebddde7a50a6c057dd60&dn=rutor.info&tr=udp://opentor.org:2710&tr=udp://opentor.org:2710&tr=http://retracker.local/announce',
          detailUrl:
              'http://tor-ru.top/torrent/734129/komnata-zhelanij_the-room-2019-web-dl-1080p-ot-selezen-itunes',
          title:
              'Комната желаний / The Room (2019) WEB-DL 1080p от селезень | iTunes',
          size: 3.6 * 1024 * 1024 * 1024,
          seeders: 2335,
          leechers: 163),
    ]);
  });
}
