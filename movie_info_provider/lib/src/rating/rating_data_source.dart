import 'rating.dart';

abstract class RatingDataSource {
  Future<Rating> getRating(String id);
}
