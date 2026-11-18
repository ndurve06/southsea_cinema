import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/screens/menu_screen.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';
import 'package:southsea_cinema/screens/bookings_screen.dart';

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

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({super.key});

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final bool? isDarkMode = await prefs.getBool(prefDarkMode);
    if (!mounted || isDarkMode == null) {
      return;
    }

    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _setDarkMode(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Southsea Cinema & Arts Centre",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: cinemaBrand,
            brightness: Brightness.light,
          ).copyWith(
            primary: cinemaBrandDark,
            surface: const Color(0xFFF2F4F7),
            onSurface: cinemaBackground,
            onSurfaceVariant: const Color(0xFF606673),
            onPrimary: cinemaFontWhite,
          ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: cinemaBrandDark),
          titleTextStyle: cinemaHeaderStyle.copyWith(color: cinemaBackground),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: cinemaBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          brightness: Brightness.dark,
        ).copyWith(
          primary: cinemaBrand,
          surface: cinemaSurface,
          onSurface: cinemaFontWhite,
          onSurfaceVariant: cinemaFontMuted,
          onPrimary: cinemaFontWhite,
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: cinemaSurface,
            iconTheme: const IconThemeData(color: cinemaBrand),
            titleTextStyle:
                cinemaHeaderStyle.copyWith(color: cinemaFontWhite),
            elevation: 0,
        ),
      ),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        //'/listing': (context) => const MovieListing(),
        '/basket': (context) => const BasketScreen(),
        '/settings': (context) => SettingsScreen(
              isDarkMode: _themeMode == ThemeMode.dark,
              onDarkModeChanged: _setDarkMode,
            ),
        '/bookings': (context) => const BookingsScreen(),
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
