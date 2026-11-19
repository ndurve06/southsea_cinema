import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:southsea_cinema/screens/bookings_screen.dart';
import 'package:southsea_cinema/screens/menu_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('isSupportedPlatform', () {
    test('returns true on Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(isSupportedPlatform(), isTrue);
    });

    test('returns false on non-Android platforms', () {
      const List<TargetPlatform> unsupportedPlatforms = <TargetPlatform>[
        TargetPlatform.iOS,
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.fuchsia,
      ];

      for (final TargetPlatform platform in unsupportedPlatforms) {
        debugDefaultTargetPlatformOverride = platform;
        expect(
          isSupportedPlatform(),
          isFalse,
          reason: '$platform is not supported',
        );
      }
    });
  });

  testWidgets('shows the unsupported-platform message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());

    expect(
      find.text(
        'This app saves orders with SQLite and is set up to run on '
        'Android only. Stop the app and run it on an Android emulator '
        'or device instead.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows the home screen on Android', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text('Southsea Cinema'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  group('Android app routes', () {
    setUp(() async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
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

    testWidgets('navigates to the basket screen', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MenuScreen));
      Navigator.of(context).pushNamed('/basket');
      await tester.pumpAndSettle();

      expect(find.byType(BasketScreen), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('navigates to the bookings screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MenuScreen));
      Navigator.of(context).pushNamed('/bookings');
      await tester.pumpAndSettle();

      expect(find.byType(BookingsScreen), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
