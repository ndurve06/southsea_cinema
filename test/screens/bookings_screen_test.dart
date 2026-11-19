import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';
import 'package:southsea_cinema/screens/bookings_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> pumpUntilLoaded(WidgetTester tester) async {
  for (int i = 0; i < 100; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();

    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      return;
    }
  }
}

void main() {
  setUp(() async {
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

  testWidgets('Shows item rows for new bookings and summary for old bookings',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1003,
          summary: '2 tickets - Despicable Me',
          total: 16.0,
          date: '01/02/2026 10:00',
        ),
      );
      await CinemaDatabase.instance.insertBookingWithItems(
        const Booking(
          bookingNumber: 1004,
          summary: '2 x Despicable Me, 1 x Shrek',
          total: 28.0,
          date: '02/02/2026 12:00',
        ),
        const <BookingItem>[
          BookingItem(
            filmId: 'test-1',
            filmName: 'Despicable Me',
            unitPrice: 6.0,
            quantity: 2,
          ),
          BookingItem(
            filmId: 'test-2',
            filmName: 'Shrek',
            unitPrice: 12.0,
            quantity: 1,
          ),
        ],
      );
    });

    await tester.pumpWidget(const MaterialApp(home: BookingsScreen()));
    await pumpUntilLoaded(tester);

    expect(find.text('Booking #1004'), findsOneWidget);
    expect(
      find.text(
        '2 x Despicable Me at Friday 25 December 2026 17:00 - '
        'Unit price: £6.00 - Line total: £12.00',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        '1 x Shrek at Friday 25 December 2026 17:00 - '
        'Unit price: £12.00 - Line total: £12.00',
      ),
      findsOneWidget,
    );
    expect(find.text('Total: £28.00'), findsOneWidget);
    expect(find.text('Summary: 2 tickets - Despicable Me'), findsOneWidget);
    expect(find.text('02/02/2026 12:00'), findsOneWidget);
  });
}
