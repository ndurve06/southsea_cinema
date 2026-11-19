import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model', () {
    test('toJson includes every movie field and round-trips through fromJson',
        () {
      const Movie movie = Movie(
        id: 'despicable-me',
        name: 'DESPICABLE ME',
        year: '2010',
        ageRating: 'PG',
        description: 'A test movie description.',
        price: 7.99,
        imagePath: 'assets/images/despicable_me.jpg',
      );

      final Map<String, dynamic> json = movie.toJson();

      expect(json, <String, dynamic>{
        'id': 'despicable-me',
        'name': 'DESPICABLE ME',
        'year': '2010',
        'ageRating': 'PG',
        'description': 'A test movie description.',
        'price': 7.99,
        'imagePath': 'assets/images/despicable_me.jpg',
      });

      final Movie restored = Movie.fromJson(json);
      expect(restored.toJson(), movie.toJson());
    });
  });
}
