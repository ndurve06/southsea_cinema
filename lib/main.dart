import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/screens/menu_screen.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';

bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const SouthseaCinemaApp());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}

class SouthseaCinemaApp extends StatelessWidget {
  const SouthseaCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Southsea Cinema & Arts Centre",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: cinemaBackground,
          colorScheme: ColorScheme.fromSeed(
            seedColor: cinemaBrand,
            primary: cinemaBrand,
            surface: cinemaSurface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: cinemaSurface,
            iconTheme: IconThemeData(color: cinemaBrand),
            titleTextStyle: cinemaHeaderStyle,
            elevation: 0,
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        //'/listing': (context) => const MovieListing(),
        '/basket': (context) => const BasketScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
