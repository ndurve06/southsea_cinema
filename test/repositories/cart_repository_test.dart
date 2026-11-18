import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

const Movie testMovie1 = Movie(
    id: 'despicable-me',
    name: 'DESPICABLE ME',
    year: '2010',
    ageRating: 'PG',
    description:
        'Longtime villain Felonious Gru has his pride hurt when an unknown rival steals the Great Pyramid of Giza.',
    price: 6.00,
    imagePath: 'assets/images/despicable_me.jpg');

const Movie testMovie2 = Movie(
    id: 'wolf-of-wall-street',
    name: 'THE WOLF OF WALL STREET',
    year: '2013',
    ageRating: '18',
    description:
        'In 1987, twenty-two-year-old Jordan Belfort becomes a Wall Street stockbroker for L.F. Rothschild, employed under Mark Hanna.',
    price: 10.00,
    imagePath: 'assets/images/wolf_of_wall_street.jpg');

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  group('CartRepository tests', () {
    test('starts with empty basket and zero totals', () {
      final CartRepository cart = CartRepository.instance;
      expect(cart.getItems().length, 0);
      expect(cart.getTotalItems(), 0);
    });

    test('adds items and calculates total correctly', () {
      final CartRepository cart = CartRepository.instance;
      const CartItem item1 = CartItem(
        movie: testMovie1,
        quantity: 2,
      );
      const CartItem item2 = CartItem(
        movie: testMovie2,
        quantity: 1,
      );

      cart.addItem(item1);
      cart.addItem(item2);

      expect(cart.getItems().length, 2);
      expect(cart.getTotalItems(), 3);
      expect(cart.getTotal(), 22.00);
    });

    test('removes items correctly', () {
      final CartRepository cart = CartRepository.instance;
      const CartItem item = CartItem(
        movie: testMovie1,
        quantity: 1,
      );
      cart.addItem(item);
      expect(cart.getItems().length, 1);

      cart.removeItem(0);
      expect(cart.getItems().length, 0);
    });

    test('clear all items from basket', () {
      final CartRepository cart = CartRepository.instance;

      const CartItem item1 = CartItem(movie: testMovie1, quantity: 2);
      const CartItem item2 = CartItem(movie: testMovie1, quantity: 1);

      cart.addItem(item1);
      cart.addItem(item2);
      cart.clear();
      expect(cart.getItems().length, 0);
      expect(cart.getTotalItems(), 0);
      expect(cart.getTotal(), 0.0);
    });
  });
}
