import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/screens/tabs.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6C4DDC),
  brightness: Brightness.dark,
);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  scaffoldBackgroundColor: const Color(0xFF0F1115),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF1C1F26),
    elevation: 6,
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF151821),
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF242833),
    labelStyle: GoogleFonts.poppins(
      fontSize: 12,
      color: colorScheme.onSurface,
    ),
    side: BorderSide(
      color: colorScheme.primary.withOpacity(0.3),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  ),
);

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
