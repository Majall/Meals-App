import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF6C4DDC);
  static const secondary = Color(0xFF2EC4B6);
  static const accent = Color(0xFFFFB800);

  static const lightBackground = Color(0xFFF7F8FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0F3FA);
  static const lightOutline = Color(0xFFE0E4EF);

  static const darkBackground = Color(0xFF0C0F16);
  static const darkSurface = Color(0xFF151A23);
  static const darkSurfaceVariant = Color(0xFF1E2533);
  static const darkOutline = Color(0xFF2A3140);
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}

class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double pill = 999;
}

@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.soft,
    required this.medium,
  });

  final List<BoxShadow> soft;
  final List<BoxShadow> medium;

  @override
  AppShadows copyWith({List<BoxShadow>? soft, List<BoxShadow>? medium}) {
    return AppShadows(
      soft: soft ?? this.soft,
      medium: medium ?? this.medium,
    );
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) {
      return this;
    }
    return AppShadows(
      soft: BoxShadow.lerpList(soft, other.soft, t) ?? soft,
      medium: BoxShadow.lerpList(medium, other.medium, t) ?? medium,
    );
  }
}

class AppTheme {
  static final _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    error: const Color(0xFFE5484D),
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: const Color(0xFF1B1E28),
    surfaceVariant: AppColors.lightSurfaceVariant,
    onSurfaceVariant: const Color(0xFF475066),
    outline: AppColors.lightOutline,
  );

  static final _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    error: const Color(0xFFFF6B6B),
    onError: Colors.black,
    surface: AppColors.darkSurface,
    onSurface: const Color(0xFFF4F6FB),
    surfaceVariant: AppColors.darkSurfaceVariant,
    onSurfaceVariant: const Color(0xFFB9C0D4),
    outline: AppColors.darkOutline,
  );

  static ThemeData lightTheme = _buildTheme(_lightColorScheme);
  static ThemeData darkTheme = _buildTheme(_darkColorScheme);

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          height: 1.4,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primary.withOpacity(0.15),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.6)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withOpacity(0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: colorScheme.primary,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        dataTextStyle: textTheme.bodyMedium,
        dividerThickness: 0.6,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.6),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(AppRadius.pill),
        thickness: WidgetStateProperty.all(4),
        thumbColor:
            WidgetStateProperty.all(colorScheme.primary.withOpacity(0.4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.surfaceVariant,
        ),
      ),
      extensions: [
        AppShadows(
          soft: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(isDark ? 0.3 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          medium: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(isDark ? 0.4 : 0.18),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
      ],
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }
}
