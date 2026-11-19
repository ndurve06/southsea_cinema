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
      await CinemaDatabase.instance.insertBookingWithItems(
        const Booking(
          bookingNumber: 1002,
          summary: '2 x Despicable Me',
          total: 16.0,
          date: '02/01/2026 11:00',
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
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1001,
          summary: '3 x Legacy Film',
          total: 19.0,
          date: '01/01/2026 10:00',
        ),
      );
    });

    await tester.pumpWidget(const MaterialApp(home: BookingsScreen()));
    await pumpUntilLoaded(tester);

    expect(find.text('2 x Despicable Me'), findsOneWidget);
    expect(find.text('Unit price: £6.00'), findsOneWidget);
    expect(find.text('Line total: £12.00'), findsOneWidget);
    expect(find.text('Summary: 3 x Legacy Film'), findsOneWidget);
    expect(find.text('Total: £16.00'), findsOneWidget);
  });
}
