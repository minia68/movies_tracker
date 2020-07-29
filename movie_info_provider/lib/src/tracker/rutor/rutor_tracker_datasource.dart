
import '../../html_page_provider.dart';
import '../detail_result.dart';
import '../tracker_datasource.dart';
import 'detail_parser.dart';
import 'search_parser.dart';

class RutorTrackerDataSource
    implements TrackerDataSource<SearchParserResult, DetailResult> {
  final HtmlPageProvider _htmlPageProvider;
  final String _baseUrl;

  RutorTrackerDataSource(this._htmlPageProvider, this._baseUrl);

  @override
  Future<DetailResult> getDetail(SearchParserResult searchResult) async {
    final page = await _htmlPageProvider(searchResult.detailUrl);

    final detailResult = DetailParser().getTorrentDetail(page);
    return DetailResult(
        imdbId: detailResult.imdbId,
        kinopoiskId: detailResult.kinopoiskId,
        magnetUrl: searchResult.magnetUrl,
        title: searchResult.title,
        size: searchResult.size,
        seeders: searchResult.seeders,
        leechers: searchResult.leechers);
  }

  @override
  Future<List<SearchParserResult>> search(String search) async {
    final page = await _htmlPageProvider(
        _baseUrl + (search.startsWith('/') ? search : '/$search'));
    final searchParser = SearchParser();
    final result = searchParser.getSearchResults(page, _baseUrl);
    return result;
  }
}
