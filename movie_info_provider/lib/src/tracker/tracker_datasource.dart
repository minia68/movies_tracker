import 'detail_result.dart';
import 'search_result.dart';

abstract class TrackerDataSource<S extends SearchResult, D extends DetailResult> {
  Future<List<S>> search(String search);

  Future<D> getDetail(S searchResult);
}