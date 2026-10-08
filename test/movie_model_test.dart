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

    test('isChildFriendly returns true for "U" rating', () {
      const movie = Movie(
          id: 'Shrek',
          name: 'SHREK',
          year: '2001',
          ageRating: 'U',
          description:
              'Shrek is an asocial ogre who loves the solitude of his swamp and enjoys fending off mobs and intruders.',
          price: 5.50,
          imagePath: 'assets/images/shrek.jpg');
      expect(movie.isChildFriendly, true);
    });

    test('isChildFriendly returns true for "PG" rating', () {
      const movie = Movie(
          id: 'despicable-me',
          name: 'DESPICABLE ME',
          year: '2010',
          ageRating: 'PG',
          description:
              'Longtime villain Felonious Gru has his pride hurt when an unknown rival steals the Great Pyramid of Giza.',
          price: 7.50,
          imagePath: 'assets/images/despicable_me.jpg');
      expect(movie.isChildFriendly, true);
    });

    test('isChildFriendly returns false for "12" rating', () {
      const movie = Movie(
          id: 'interstellar',
          name: 'INTERSTELLAR',
          year: '2014',
          ageRating: '12',
          description:
              'In the near future, humanity faces extinction due to dust storms and widespread crop blights.',
          price: 8.99,
          imagePath: 'assets/images/interstellar.jpg');
      expect(movie.isChildFriendly, false);
    });

    test('isAdultOnly returns true for "18" rating', () {
      const movie = Movie(
          id: 'wolf-of-wall-street',
          name: 'THE WOLF OF WALL STREET',
          year: '2013',
          ageRating: '18',
          description:
              'In 1987, twenty-two-year-old Jordan Belfort becomes a Wall Street stockbroker for L.F. Rothschild, employed under Mark Hanna.',
          price: 9.50,
          imagePath: 'assets/images/wolf_of_wall_street.jpg');
      expect(movie.isAdultOnly, true);
    });

    test('isAdultOnly returns false for "12" rating', () {
      const movie = Movie(
          id: 'interstellar',
          name: 'INTERSTELLAR',
          year: '2014',
          ageRating: '12',
          description:
              'In the near future, humanity faces extinction due to dust storms and widespread crop blights.',
          price: 8.99,
          imagePath: 'assets/images/interstellar.jpg');
      expect(movie.isAdultOnly, false);
    });
  });
}
