import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

//Run test cases in termial:
//flutter test test/user_settings_test.dart

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  test('UserSettings defaults to empty values and false newsletter', () {
    const UserSettings settings = UserSettings();
    expect(settings.name, isEmpty);
    expect(settings.address, isEmpty);
    expect(settings.email, isEmpty);
    expect(settings.receiveNewsletter, false);
  });

  test('UserSettings stores configured values', () {
    const UserSettings settings = UserSettings(
      name: 'Taylor Reed',
      address: '22 Guildhall Walk',
      email: 'taylor@example.com',
      receiveNewsletter: true,
    );
    expect(settings.name, 'Taylor Reed');
    expect(settings.address, '22 Guildhall Walk');
    expect(settings.email, 'taylor@example.com');
    expect(settings.receiveNewsletter, isTrue);
  });

  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    final nameField = find.byType(TextField).at(0);
    final addressField = find.byType(TextField).at(1);
    final emailField = find.byType(TextField).at(2);
    await tester.enterText(nameField, 'Gerald Vernon-Jackson');
    await tester.enterText(addressField, 'Guildhall, PO1 2AJ');
    await tester.enterText(
      emailField,
      'gerald.vernon-jackson@portsmouthcc.gov.uk',
    );
    final switchFinder = find.byType(Switch);
    await tester.ensureVisible(switchFinder);
    await tester.pumpAndSettle();
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();
    expect(
        find.text('Settings saved for Gerald Vernon-Jackson'), findsOneWidget);
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getString(prefName), 'Gerald Vernon-Jackson');
    expect(await prefs.getString(prefAddress), 'Guildhall, PO1 2AJ');
    expect(
      await prefs.getString(prefEmail),
      'gerald.vernon-jackson@portsmouthcc.gov.uk',
    );
    expect(await prefs.getBool(prefNewsletter), isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Gerald Vernon-Jackson'), findsOneWidget);
    expect(find.text('Guildhall, PO1 2AJ'), findsOneWidget);
    expect(
      find.text('gerald.vernon-jackson@portsmouthcc.gov.uk'),
      findsOneWidget,
    );
    final Switch reopenedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(reopenedSwitch.value, isTrue);
  });

  testWidgets('SettingsScreen pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefName: 'Abdul Kadir',
      prefAddress: 'Portsmouth Guildhall, PO1 2AJ',
      prefEmail: 'abdul.kadir@portsmouthcc.gov.uk',
      prefNewsletter: true,
    });
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Abdul Kadir'), findsOneWidget);
    expect(find.text('Portsmouth Guildhall, PO1 2AJ'), findsOneWidget);
    expect(find.text('abdul.kadir@portsmouthcc.gov.uk'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
  });
}
