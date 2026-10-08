import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('creates Movie instance with given properties', () {
      const movie = Movie(
        id: 'ted',
        name: 'TED 2',
        year: '2012',
        ageRating: '15',
        description:
            'A wish comes true for John when his teddy bear, Ted, comes to life.',
        price: 7.99,
        imagePath: 'assets/images/ted.jpg',
      );
      expect(movie.id, 'ted');
      expect(movie.name, 'TED 2');
      expect(movie.year, '2012');
      expect(movie.ageRating, '15');
      expect(movie.description,
          'A wish comes true for John when his teddy bear, Ted, comes to life.');
      expect(movie.price, 7.99);
      expect(movie.imagePath, 'assets/images/ted.jpg');
    });
    test(
        'formattedPrice returns price prefixed with pound sign and two decimals',
        () {
      const movie = Movie(
          id: 'despicable-me',
          name: 'DESPICABLE ME',
          year: '2010',
          ageRating: 'PG',
          description:
              'Longtime villain Felonious Gru has his pride hurt when an unknown rival steals the Great Pyramid of Giza.',
          price: 7.50,
          imagePath: 'assets/images/despicable_me.jpg');
      expect(movie.formattedPrice, '£7.50');
    });
  });
}
