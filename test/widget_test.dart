import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

//Run test cases in termial:
//flutter test test/widget_test.dart

void main() {
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
    expect(find.text('BOOK NOW'), findsNWidgets(2));
  });

  testWidgets('Navigate to movie listing and add tickets to order',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();
    expect(find.text('TED 2 (2012) (15)'), findsOneWidget);
    expect(
      find.text(
          'A wish comes true for John when his teddy bear, Ted, comes to life.'),
      findsOneWidget,
    );
    expect(find.text('Southsea Cinema Room'), findsOneWidget);
    expect(find.text('Tickets (£7.99 each)'), findsOneWidget);
    await tester.tap(find.text('ADD TO ORDER'));
    await tester.pumpAndSettle();
    expect(find.text('ADDED'), findsOneWidget);
  });
}
