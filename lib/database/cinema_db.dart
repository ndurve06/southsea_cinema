import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }
    final Database db = await _initDB('cinema_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);
    final Database db = await openDatabase(
      filePath,
      version: 2,
      onConfigure: configureDatabase,
      onCreate: _createDB,
      onUpgrade: upgradeDatabase,
    );
    return db;
  }

  Future<void> configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    await _createBookingItemsTable(db);
  }

  Future<void> _createBookingItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS booking_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_id INTEGER NOT NULL,
        film_id TEXT NOT NULL,
        film_name TEXT NOT NULL,
        unit_price REAL NOT NULL CHECK (unit_price >= 0),
        quantity INTEGER NOT NULL CHECK (quantity > 0),
        FOREIGN KEY (booking_id) REFERENCES bookings(id)
      )
    ''');
  }

  Future<void> upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await _createBookingItemsTable(db);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);
    await db.insert('bookings', <String, Object?>{
      'booking_number': 1003,
      'summary': '2 tickets - Despicable Me',
      'total': 15.00,
      'date': '2026-11-11 11:11',
    });
    await db.insert('bookings', <String, Object?>{
      'booking_number': 1002,
      'summary': '3 tickets - Shrek',
      'total': 4.50,
      'date': '2026-11-11 09:41',
    });
    await db.insert('bookings', <String, Object?>{
      'booking_number': 1001,
      'summary': '2 tickets - Interstellar',
      'total': 22.50,
      'date': '2026-11-11 05:47',
    });
  }

  Future<int> insertBooking(Booking booking) async {
    final Database db = await database;
    final int id = await db.insert('bookings', booking.toMap());
    return id;
  }

  Future<int> insertBookingWithItems(
    Booking booking,
    List<BookingItem> items,
  ) async {
    final Database db = await database;
    return db.transaction<int>((Transaction transaction) async {
      final int bookingId =
          await transaction.insert('bookings', booking.toMap());
      for (final BookingItem item in items) {
        await transaction.insert(
          'booking_items',
          item.toMapForBooking(bookingId),
        );
      }
      return bookingId;
    });
  }

  Future<List<Booking>> getAllBookings() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.query(
      'bookings',
      orderBy: 'booking_number DESC',
    );
    final List<Map<String, Object?>> itemRecords = await db.query(
      'booking_items',
      orderBy: 'id ASC',
    );

    final Map<int, List<BookingItem>> itemsByBooking = {};
    for (final Map<String, Object?> row in itemRecords) {
      final int bookingId = row['booking_id'] as int;
      itemsByBooking
          .putIfAbsent(bookingId, () => <BookingItem>[])
          .add(BookingItem.fromMap(row));
    }

    final List<Booking> bookings = [];
    for (final Map<String, Object?> row in records) {
      final int bookingId = row['id'] as int;
      bookings.add(
        Booking.fromMap(
          row,
          items: itemsByBooking[bookingId] ?? const <BookingItem>[],
        ),
      );
    }
    return bookings;
  }

  Future<int> getNextBookingNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(booking_number) as max_num FROM bookings',
    );

    if (records.isEmpty) {
      return 1001;
    }
    final Object? maxValue = records[0]['max_num'];
    if (maxValue == null) {
      return 1001;
    }

    final int currentMax = maxValue as int;
    return currentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
