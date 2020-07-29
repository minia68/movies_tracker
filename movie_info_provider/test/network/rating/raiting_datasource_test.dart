import 'package:mockito/mockito.dart';
import 'package:movie_info_provider/src/html_page_provider.dart';
import 'package:movie_info_provider/src/rating/kinopoisk_rating_datasource.dart';
import 'package:movie_info_provider/src/rating/rating.dart';
import 'package:test/test.dart';

void main() {
  test('wrong response format', () async {
    final htmlPageProvider = MockHtmlPageProvider();
    when(htmlPageProvider.call(any)).thenAnswer(
        (_) async => '<a href="http://imdb.com/title//" target="_blank"></a>');
    final ds = KinopoiskRatingDataSource(htmlPageProvider);
    try {
      await ds.getRating('');
      throw Exception();
    } on KinopoiskRatingException catch (e) {
      expect(e.message, startsWith('wrong response format'));
    }
  });

  test('getResult', () async {
    final htmlPageProvider = MockHtmlPageProvider();
    when(htmlPageProvider.call(any)).thenAnswer((_) async => '''<rating>
<kp_rating num_vote="4079">6.071</kp_rating>
<imdb_rating num_vote="35233">6.2</imdb_rating>
</rating>''');
    final ds = KinopoiskRatingDataSource(htmlPageProvider);
    expect(
        await ds.getRating(''),
        Rating(
            imdbVoteAverage: 6.2,
            imdbVoteCount: 35233,
            kinopoiskVoteAverage: 6.071,
            kinopoiskVoteCount: 4079));
  });
}

class MockHtmlPageProvider extends Mock implements HtmlPageProvider {}
