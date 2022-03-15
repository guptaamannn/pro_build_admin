import 'package:flutter/material.dart';

double kFabCornerRadius = 16;
double kFabDefaultElevation = 3;

class ThemeBuilder {
  final ColorScheme lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF005CBC),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD5E3FE),
    onPrimaryContainer: Color(0xFF011B40),
    inversePrimary: Color(0xFFA8C7FF),
    secondary: Color(0xFF565F71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDBE3FA),
    onSecondaryContainer: Color(0xFF131C2B),
    tertiary: Color(0xFF705473),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFBD8FD),
    onTertiaryContainer: Color(0xFF2A132F),
    error: Color(0xFFBB1B1B),
    onError: Color(0xFFBC1B1B),
    errorContainer: Color(0xFFFFDAD4),
    onErrorContainer: Color(0xFF410102),
    background: Color(0xFFFDFBFF),
    onBackground: Color(0xFF1A1B1F),
    surface: Color(0xFFFDFBFF),
    onSurface: Color(0xFF1A1B1F),
    surfaceVariant: Color(0xFFE0E3EC),
    onSurfaceVariant: Color(0xFF444750),
    outline: Color(0xFF747780),
  );

  final ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA8C7FF),
    onPrimary: Color(0xFF012F67),
    primaryContainer: Color(0xFF004590),
    onPrimaryContainer: Color(0xFFD5E3FE),
    inversePrimary: Color(0xFF005CBC),
    secondary: Color(0xFFBEC6DD),
    onSecondary: Color(0xFF283142),
    secondaryContainer: Color(0xFF3E4659),
    onSecondaryContainer: Color(0xFFDBE3FA),
    tertiary: Color(0xFFDEBCE1),
    onTertiary: Color(0xFF3F2845),
    tertiaryContainer: Color(0xFF573E5D),
    onTertiaryContainer: Color(0xFFFAD8FD),
    error: Color(0xFFFEB4A9),
    onError: Color(0xFF690004),
    errorContainer: Color(0xFF930006),
    onErrorContainer: Color(0xFFFFDAD4),
    background: Color(0xFF1A1B1F),
    onBackground: Color(0xFFE3E2E7),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE3E2E7),
    surfaceVariant: Color(0xFF444750),
    onSurfaceVariant: Color(0xFFC3C6CF),
    outline: Color(0xFF8C8F98),
  );

  ThemeData getLightTheme() => ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          foregroundColor: lightColorScheme.onSurface,
          elevation: 0,
          actionsIconTheme: IconThemeData(
            color: lightColorScheme.onSurface,
            size: 24,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kFabCornerRadius),
          ),
          backgroundColor: lightColorScheme.primary,
          elevation: kFabDefaultElevation,
          foregroundColor: lightColorScheme.onPrimary,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: lightColorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        colorScheme: lightColorScheme,
        popupMenuTheme: PopupMenuThemeData(
          color: lightColorScheme.surface,
          elevation: 1,
        ),

        //Alert Dialog
        dialogTheme: DialogTheme(
          backgroundColor: lightColorScheme.surface,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      );

  ThemeData getDarkTheme() => ThemeData.dark().copyWith(
      //AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: darkColorScheme.onSurface,
          size: 24,
        ),
      ),

      //FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kFabCornerRadius),
        ),
        backgroundColor: darkColorScheme.primary,
        elevation: kFabDefaultElevation,
        foregroundColor: darkColorScheme.onPrimary,
      ),

      //Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: darkColorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      backgroundColor: darkColorScheme.background,

      //BottomSheet
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: darkColorScheme.background),
      brightness: Brightness.dark,
      canvasColor: darkColorScheme.surface,
      scaffoldBackgroundColor: const Color(0xFF1F1F1F),
      colorScheme: darkColorScheme,
      popupMenuTheme: PopupMenuThemeData(
        color: darkColorScheme.surface,
        elevation: 1,
      ),

      //Alert Dialog
      dialogTheme: DialogTheme(
        backgroundColor: darkColorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ));
}
