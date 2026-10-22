import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/screens/movie_listing.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

//Run test cases in termial:
//flutter test test/widget_test.dart

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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
    expect(find.text('BOOK NOW'), findsNWidgets(5));
  });

  testWidgets('Navigate to movie listing and add tickets to order',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();
    expect(find.byType(MovieListing), findsOneWidget);
    expect(find.text('DESPICABLE ME (2010) (PG)'), findsOneWidget);
    expect(
      find.text(
          'Longtime villain Felonious Gru has his pride hurt when an unknown rival steals the Great Pyramid of Giza.'),
      findsOneWidget,
    );
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
    expect(find.text('DESPICABLE ME (2010)'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('THE WOLF OF WALL STREET (2013)'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
  });
}
