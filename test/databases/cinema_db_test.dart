import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

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

  Booking buildRecord(int orderNumber, String summary, double total) {
    return Booking(
      bookingNumber: orderNumber,
      summary: summary,
      total: total,
      date: '01/01/2026 10:00',
    );
  }

  Future<void> preparePersistentDatabase() async {
    await CinemaDatabase.instance.close();
    final Directory directory =
        await Directory.systemTemp.createTemp('cinema_db_test_');
    await databaseFactoryFfi.setDatabasesPath(directory.path);
    CinemaDatabase.instance.setDatabase(null);

    addTearDown(() async {
      await CinemaDatabase.instance.close();
      await directory.delete(recursive: true);
    });
  }

  test('insertBooking stores a booking and returns its id', () async {
    final int id = await CinemaDatabase.instance.insertBooking(
      buildRecord(1001, '1 ticket - Despicable Me', 7.50),
    );
    expect(id, greaterThan(0));

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings.length, 1);
    expect(bookings[0].id, id);
    expect(bookings[0].summary, '1 ticket - Despicable Me');
    expect(bookings[0].total, 7.50);
  });

  test('getNextOrderNumber increments the current maximum', () async {
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1001);

    await CinemaDatabase.instance.insertBooking(
      buildRecord(1005, 'Booking', 5.0),
    );
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1006);
  });

  test('getAllbookings returns newest order number first', () async {
    await CinemaDatabase.instance.insertBooking(
      buildRecord(1001, 'First', 5.0),
    );
    await CinemaDatabase.instance.insertBooking(
      buildRecord(1003, 'Third', 9.0),
    );
    await CinemaDatabase.instance.insertBooking(
      buildRecord(1002, 'Second', 7.0),
    );

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings[0].bookingNumber, 1003);
    expect(bookings[1].bookingNumber, 1002);
    expect(bookings[2].bookingNumber, 1001);
  });

  test('database getter returns the same cached database instance', () async {
    await preparePersistentDatabase();

    final Database firstDatabase = await CinemaDatabase.instance.database;
    final Database secondDatabase = await CinemaDatabase.instance.database;

    expect(identical(firstDatabase, secondDatabase), isTrue);
  });

  test('close closes the cached database and the getter opens a new one',
      () async {
    await preparePersistentDatabase();

    final Database firstDatabase = await CinemaDatabase.instance.database;
    await CinemaDatabase.instance.close();

    expect(firstDatabase.isOpen, isFalse);

    final Database secondDatabase = await CinemaDatabase.instance.database;
    expect(identical(firstDatabase, secondDatabase), isFalse);
    expect(secondDatabase.isOpen, isTrue);
  });

  test('getAllBookings returns fresh sample bookings newest first', () async {
    await preparePersistentDatabase();

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();

    expect(
      bookings.map((Booking booking) => booking.bookingNumber).toList(),
      <int>[1003, 1002, 1001],
    );
  });

  test('insertBookingWithItems saves a booking and its items together',
      () async {
    final Booking booking = buildRecord(1001, '1 x Despicable Me', 10.0);
    final int bookingId = await CinemaDatabase.instance.insertBookingWithItems(
      booking,
      const <BookingItem>[
        BookingItem(
          filmId: 'despicable-me',
          filmName: 'Despicable Me',
          unitPrice: 6.0,
          quantity: 1,
        ),
        BookingItem(
          filmId: 'shrek',
          filmName: 'Shrek',
          unitPrice: 4.0,
          quantity: 1,
        ),
      ],
    );

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings, hasLength(1));
    expect(bookings.single.id, bookingId);
    expect(bookings.single.items, hasLength(2));
    expect(bookings.single.items.first.filmId, 'despicable-me');
    expect(bookings.single.items.first.lineTotal, 6.0);
    expect(bookings.single.total, 10.0);
  });

  test('insertBookingWithItems rolls back when an item violates a constraint',
      () async {
    final Database db = await CinemaDatabase.instance.database;

    await expectLater(
      CinemaDatabase.instance.insertBookingWithItems(
        buildRecord(1001, 'Invalid item', 4.0),
        const <BookingItem>[
          BookingItem(
            filmId: 'valid-film',
            filmName: 'Valid Film',
            unitPrice: 4.0,
            quantity: 1,
          ),
          BookingItem(
            filmId: 'invalid-film',
            filmName: 'Invalid Film',
            unitPrice: 4.0,
            quantity: 0,
          ),
        ],
      ),
      throwsA(anything),
    );
    await expectLater(
      CinemaDatabase.instance.insertBookingWithItems(
        buildRecord(1001, 'Negative price', 4.0),
        const <BookingItem>[
          BookingItem(
            filmId: 'valid-film',
            filmName: 'Valid Film',
            unitPrice: 4.0,
            quantity: 1,
          ),
          BookingItem(
            filmId: 'negative-price-film',
            filmName: 'Negative Price Film',
            unitPrice: -1.0,
            quantity: 1,
          ),
        ],
      ),
      throwsA(anything),
    );

    expect(await db.query('bookings'), isEmpty);
    expect(await db.query('booking_items'), isEmpty);
  });

  test('migrates a file-backed version 1 database without losing bookings',
      () async {
    final Directory directory =
        await Directory.systemTemp.createTemp('cinema_db_migration_');
    addTearDown(() => directory.delete(recursive: true));
    final String databasePath = join(directory.path, 'cinema_v1.db');

    final Database versionOneDatabase =
        await databaseFactoryFfiNoIsolate.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE bookings (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              booking_number INTEGER NOT NULL,
              summary TEXT NOT NULL,
              total REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    final int legacyBookingId = await versionOneDatabase.insert(
      'bookings',
      <String, Object?>{
        'booking_number': 1012,
        'summary': '2 x Despicable Me',
        'total': 16.0,
        'date': '01/02/2026 10:00',
      },
    );
    await versionOneDatabase.close();

    final Database upgradedDatabase =
        await databaseFactoryFfiNoIsolate.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: CinemaDatabase.instance.configureDatabase,
        onCreate: CinemaDatabase.instance.createTables,
        onUpgrade: CinemaDatabase.instance.upgradeDatabase,
      ),
    );
    addTearDown(upgradedDatabase.close);

    final List<Map<String, Object?>> legacyBookings =
        await upgradedDatabase.query('bookings');
    expect(legacyBookings, hasLength(1));
    expect(legacyBookings.single['id'], legacyBookingId);
    expect(legacyBookings.single['summary'], '2 x Despicable Me');
    expect(legacyBookings.single['total'], 16.0);
    expect(await upgradedDatabase.query('booking_items'), isEmpty);

    final List<Map<String, Object?>> foreignKeySetting =
        await upgradedDatabase.rawQuery('PRAGMA foreign_keys');
    expect(foreignKeySetting.single['foreign_keys'], 1);
    final List<Map<String, Object?>> foreignKeyDefinition =
        await upgradedDatabase
            .rawQuery('PRAGMA foreign_key_list(booking_items)');
    expect(foreignKeyDefinition.single['table'], 'bookings');
    expect(foreignKeyDefinition.single['from'], 'booking_id');
    expect(foreignKeyDefinition.single['to'], 'id');
  });
}
