import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// flutter test test/screens/basket_screen_test.dart

const Movie testMovie = Movie(
  id: 'test-1',
  name: 'Despicable Me',
  year: '2010',
  ageRating: 'U',
  description: 'A test movie.',
  price: 6.0,
  imagePath: 'assets/test.png',
);

Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition,
) async {
  for (int i = 0; i < 100; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();

    if (condition()) {
      return;
    }
  }
}

Future<void> pumpBasket(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

  // Wait for the past bookings to finish loading.
  await pumpUntil(
    tester,
    () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
  );
}

void main() {
  setUp(() async {
    CartRepository.instance.clear();

    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: CinemaDatabase.instance.configureDatabase,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  group('Basket Screen - past bookings', () {
    testWidgets('Shows a message when there are no previous bookings',
        (WidgetTester tester) async {
      await pumpBasket(tester);

      expect(find.text('Past Bookings'), findsOneWidget);
      expect(find.text('No previous bookings found.'), findsOneWidget);
    });

    testWidgets('Lists saved bookings below the basket',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await CinemaDatabase.instance.insertBooking(
          const Booking(
            bookingNumber: 1001,
            summary: '1 x Despicable Me',
            total: 10.0,
            date: '01/01/2026 10:00',
          ),
        );
        await CinemaDatabase.instance.insertBooking(
          const Booking(
            bookingNumber: 1002,
            summary: '3 x Wolf of Wall Street',
            total: 22.0,
            date: '02/01/2026 11:00',
          ),
        );
      });

      await pumpBasket(tester);

      expect(find.text('No previous bookings found.'), findsNothing);
      expect(find.text('Booking #1001'), findsOneWidget);
      expect(find.text('Booking #1002'), findsOneWidget);
      expect(find.text('3 x Wolf of Wall Street'), findsOneWidget);

      // The highest booking number should be listed first.
      final double newestY = tester.getTopLeft(find.text('Booking #1002')).dy;
      final double oldestY = tester.getTopLeft(find.text('Booking #1001')).dy;
      expect(newestY, lessThan(oldestY));
    });

    testWidgets('Lists item details for bookings with item rows',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await CinemaDatabase.instance.insertBookingWithItems(
          const Booking(
            bookingNumber: 1003,
            summary: '2 x Despicable Me',
            total: 16.0,
            date: '03/01/2026 12:00',
          ),
          const <BookingItem>[
            BookingItem(
              filmId: 'test-1',
              filmName: 'Despicable Me',
              unitPrice: 6.0,
              quantity: 2,
            ),
          ],
        );
      });

      await pumpBasket(tester);

      expect(find.text('2 x Despicable Me'), findsOneWidget);
      expect(find.text('Unit price: £6.00'), findsOneWidget);
      expect(find.text('Line total: £12.00'), findsOneWidget);
    });
  });

  group('Basket Screen - checkout', () {
    testWidgets('Saves a numbered booking, clears the basket and confirms',
        (WidgetTester tester) async {
      CartRepository.instance.addItem(
        const CartItem(movie: testMovie, quantity: 2),
      );
      await pumpBasket(tester);

      late final int expectedNumber;
      await tester.runAsync(() async {
        expectedNumber = await CinemaDatabase.instance.getNextBookingNumber();
      });

      final String confirmation =
          'Your booking has been confirmed! Booking number: $expectedNumber';

      await tester.ensureVisible(find.text('BUY TICKETS'));
      await tester.tap(find.text('BUY TICKETS'));

      // Wait for the save, the confirmation and the refreshed list.
      await pumpUntil(
        tester,
        () => find.text('Booking #$expectedNumber').evaluate().isNotEmpty,
      );

      // The booking was saved to the database.
      final List<Booking>? bookings = await tester.runAsync(() async {
        return await CinemaDatabase.instance.getAllBookings();
      });
      expect(bookings, isNotNull);
      if (bookings != null) {
        expect(bookings.length, 1);
        expect(bookings[0].bookingNumber, expectedNumber);
        expect(bookings[0].summary, '2 x Despicable Me');
        expect(bookings[0].total, 16.0);
        expect(bookings[0].items.single.unitPrice, 6.0);
        expect(bookings[0].items.single.quantity, 2);
        expect(bookings[0].items.single.lineTotal, 12.0);
      }

      // The basket was cleared and the confirmation shows the number.
      expect(CartRepository.instance.getItems(), isEmpty);
      expect(find.text('Your basket is empty'), findsOneWidget);
      expect(find.text(confirmation), findsOneWidget);

      // The new booking appears below the basket.
      expect(find.text('Booking #$expectedNumber'), findsOneWidget);
      expect(find.text('No previous bookings found.'), findsNothing);
    });

    testWidgets('Checkout keeps the basket when saving fails',
        (WidgetTester tester) async {
      CartRepository.instance.addItem(
        const CartItem(movie: testMovie, quantity: 2),
      );

      // Removing the table makes every database call fail on purpose.
      await tester.runAsync(() async {
        final Database database = await CinemaDatabase.instance.database;
        await database.execute('DROP TABLE bookings');
      });

      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));
      await pumpUntil(
        tester,
        () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
      );

      await tester.ensureVisible(find.text('BUY TICKETS'));
      await tester.tap(find.text('BUY TICKETS'));
      await pumpUntil(
        tester,
        () => find
            .text('Unable to complete your booking. Please try again.')
            .evaluate()
            .isNotEmpty,
      );

      expect(CartRepository.instance.getItems().length, 1);
      expect(find.textContaining('Despicable Me'), findsOneWidget);
      expect(
        find.text('Unable to complete your booking. Please try again.'),
        findsOneWidget,
      );
    });
  });

  group('Basket Screen - deleting a film', () {
    testWidgets('Deleting the middle film keeps the other two',
        (WidgetTester tester) async {
      const Movie first = Movie(
        id: 'test-1',
        name: 'Despicable Me',
        year: '2010',
        ageRating: 'U',
        description: 'A test movie.',
        price: 6.0,
        imagePath: 'assets/test.png',
      );
      const Movie middle = Movie(
        id: 'test-2',
        name: 'Wolf of Wall Street',
        year: '2013',
        ageRating: '18',
        description: 'A test movie.',
        price: 8.0,
        imagePath: 'assets/test.png',
      );
      const Movie last = Movie(
        id: 'test-3',
        name: 'Toy Story',
        year: '1995',
        ageRating: 'U',
        description: 'A test movie.',
        price: 5.0,
        imagePath: 'assets/test.png',
      );

      CartRepository.instance.addItem(
        const CartItem(movie: first, quantity: 1),
      );
      CartRepository.instance.addItem(
        const CartItem(movie: middle, quantity: 1),
      );
      CartRepository.instance.addItem(
        const CartItem(movie: last, quantity: 1),
      );

      await pumpBasket(tester);

      expect(find.textContaining('Despicable Me'), findsOneWidget);
      expect(find.textContaining('Wolf of Wall Street'), findsOneWidget);
      expect(find.textContaining('Toy Story'), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('delete_test-2')));
      await tester.tap(find.byKey(const Key('delete_test-2')));
      await tester.pump();

      expect(find.textContaining('Despicable Me'), findsOneWidget);
      expect(find.textContaining('Wolf of Wall Street'), findsNothing);
      expect(find.textContaining('Toy Story'), findsOneWidget);
      expect(CartRepository.instance.getItems().length, 2);
    });
  });
}
