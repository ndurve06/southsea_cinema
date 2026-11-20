import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/screens/movie_listing.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

//Run test cases in termial:
//flutter test test/widget_test.dart

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  /*testWidgets('Basic app loading test', (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    expect(find.text('Welcome to Southsea Cinema'), findsOneWidget);
  });*/

  testWidgets('Displays movie cards with names and prices',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    expect(find.text("Southsea Cinema"), findsOneWidget);
    expect(find.text('TED 2 (2012)'), findsOneWidget);
    expect(find.text('DESPICABLE ME (2010)'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsWidgets);
  });

  testWidgets('Navigate to movie listing and add tickets to order',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();
    expect(find.byType(MovieListing), findsOneWidget);
    expect(find.text('Southsea Cinema Room'), findsOneWidget);
    expect(find.text('Tickets (£7.99 each)'), findsOneWidget);
    await tester.tap(find.text('ADD TO ORDER'));
    await tester.pumpAndSettle();
    expect(find.text('ADDED'), findsOneWidget);
  });

  testWidgets('Navigate from home page to movie listing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();
    expect(find.byType(MovieListing), findsOneWidget);
    //expect()
  });

  testWidgets('Starts in dark mode when no preference is saved',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('Restores and persists the selected theme mode',
      (WidgetTester tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefDarkMode: false,
    });

    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Settings'));
    await tester.pumpAndSettle();

    final Switch darkModeSwitch =
        tester.widget<Switch>(find.byKey(const Key('darkModeSwitch')));
    expect(darkModeSwitch.value, isFalse);
    await tester.ensureVisible(find.byKey(const Key('darkModeSwitch')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('darkModeSwitch')));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getBool(prefDarkMode), isTrue);
  });

  testWidgets('HomeView loads and displays movies',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeView(),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('THE WOLF OF WALL STREET (2013)'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
  });
}
