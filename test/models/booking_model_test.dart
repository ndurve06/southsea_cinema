import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';

// flutter test test/booking_model_test.dart

void main() {
  group('Booking Model', () {
    test('Create a booking with valid values', () {
      const booking = Booking(
        id: 1,
        bookingNumber: 1,
        summary: '2 tickets - Despicable Me',
        total: 12.0,
        date: '2026-11-11',
      );

      expect(booking.id, 1);
      expect(booking.bookingNumber, 1);
      expect(booking.summary, '2 tickets - Despicable Me');
      expect(booking.total, 12.0);
      expect(booking.date, '2026-11-11');
    });

    test('Allows an id to be null', () {
      const booking = Booking(
        bookingNumber: 2,
        summary: '1 ticket - Wolf of Wall Street',
        total: 10.0,
        date: '2026-11-11',
      );

      expect(booking.id, isNull);
    });

    test('Booking converted to a map and back', () {
      const original = Booking(
        id: 3,
        bookingNumber: 3,
        summary: '3 tickets - Despicable Me',
        total: 18.0,
        date: '2026-11-11',
      );

      final restored = Booking.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.bookingNumber, original.bookingNumber);
      expect(restored.summary, original.summary);
      expect(restored.total, original.total);
      expect(restored.date, original.date);
    });

    test('Booking converted to a map without an id', () {
      const booking = Booking(
        bookingNumber: 4,
        summary: '2 tickets - Despicable Me',
        total: 12.0,
        date: '2026-11-11',
      );

      expect(booking.toMap(), {
        'booking_number': 4,
        'summary': '2 tickets - Despicable Me',
        'total': 12.0,
        'date': '2026-11-11',
      });
    });

    test('Booking item maps persisted fields and calculates its line total',
        () {
      const BookingItem item = BookingItem(
        id: 8,
        bookingId: 3,
        filmId: 'despicable-me',
        filmName: 'Despicable Me',
        unitPrice: 6.0,
        quantity: 2,
      );

      final BookingItem restored = BookingItem.fromMap(<String, Object?>{
        'id': item.id,
        ...item.toMapForBooking(item.bookingId!),
      });

      expect(restored.id, item.id);
      expect(restored.bookingId, item.bookingId);
      expect(restored.filmId, item.filmId);
      expect(restored.filmName, item.filmName);
      expect(restored.unitPrice, item.unitPrice);
      expect(restored.quantity, item.quantity);
      expect(restored.lineTotal, 12.0);
    });
  });
}
