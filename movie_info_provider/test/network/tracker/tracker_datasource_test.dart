import 'package:mockito/mockito.dart';
import 'package:movie_info_provider/src/html_page_provider.dart';
import 'package:movie_info_provider/src/tracker/detail_result.dart';
import 'package:movie_info_provider/src/tracker/rutor/rutor_tracker_datasource.dart';
import 'package:movie_info_provider/src/tracker/rutor/search_parser.dart';
import 'package:test/test.dart';

void main() {
  test('search', () async {
    final baseUrl = 'baseUrl';
    final htmlPageProvider = MockHtmlPageProvider();
    when(htmlPageProvider.call(any)).thenAnswer((_) async => '');
    final ds = RutorTrackerDataSource(htmlPageProvider, baseUrl);
    try {
      await ds.search('qwe');
    } on Exception {}
    try {
      await ds.search('/asd');
    } on Exception {}
    expect(verify(htmlPageProvider.call(captureAny)).captured,
        ['baseUrl/qwe', 'baseUrl/asd']);
  });

  test('getDetail', () async {
    final baseUrl = 'baseUrl';
    final htmlPageProvider = MockHtmlPageProvider();
    when(htmlPageProvider.call(any)).thenAnswer((_) async => '''
<a href="http://www.imdb.com/title/tt123/" target="_blank"></a>
<a href="http://www.kinopoisk.ru/film/456/" target="_blank"></a>''');
    final ds = RutorTrackerDataSource(htmlPageProvider, baseUrl);
    final searchResult = SearchParserResult(
        detailUrl: 'detailUrl',
        magnetUrl: 'magnetUrl',
        title: 'title',
        size: 1,
        seeders: 2,
        leechers: 3);
    var response = await ds.getDetail(searchResult);
    expect(response, DetailResult(
        imdbId: 'tt123',
        kinopoiskId: '456',
        magnetUrl: 'magnetUrl',
        title: 'title',
        size: 1,
        seeders: 2,
        leechers: 3));
  });
}

class MockHtmlPageProvider extends Mock implements HtmlPageProvider {}
