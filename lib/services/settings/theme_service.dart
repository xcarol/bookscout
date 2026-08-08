import 'package:flutter/material.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/models/title_list_theme.dart';

class ThemeService with ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  ColorScheme _lightColorScheme = lightColorSchemeDefault;
  CustomColors _lightCustomColors = lightCustomColorsDefault;
  TitleListTheme _lightTitleListTheme = _createTitleListTheme(
    lightColorSchemeDefault,
    lightCustomColorsDefault,
  );

  ColorScheme get lightColorScheme => _lightColorScheme;
  CustomColors get lightCustomColors => _lightCustomColors;
  TitleListTheme get lightTitleListTheme => _lightTitleListTheme;

  ColorScheme _darkColorScheme = darkColorSchemeDefault;
  CustomColors _darkCustomColors = darkCustomColorsDefault;
  TitleListTheme _darkTitleListTheme = _createTitleListTheme(
    darkColorSchemeDefault,
    darkCustomColorsDefault,
  );

  ColorScheme get darkColorScheme => _darkColorScheme;
  CustomColors get darkCustomColors => _darkCustomColors;
  TitleListTheme get darkTitleListTheme => _darkTitleListTheme;

  ScrollbarThemeData get lightScrollbarTheme => ScrollbarThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.dragged)) {
        return _lightColorScheme.onSurfaceVariant.withValues(alpha: 0.8);
      }
      return _lightColorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    }),
    thickness: WidgetStateProperty.all(5.0),
    radius: const Radius.circular(8),
    thumbVisibility: WidgetStateProperty.all(false),
    trackVisibility: WidgetStateProperty.all(false),
    interactive: true,
  );

  ScrollbarThemeData get darkScrollbarTheme => ScrollbarThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.dragged)) {
        return _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.8);
      }
      return _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    }),
    thickness: WidgetStateProperty.all(5.0),
    radius: const Radius.circular(8),
    thumbVisibility: WidgetStateProperty.all(false),
    trackVisibility: WidgetStateProperty.all(false),
    interactive: true,
  );

  void setupTheme() {
    _setColorScheme(
      lightColorSchemeDefault,
      lightCustomColorsDefault,
      darkColorSchemeDefault,
      darkCustomColorsDefault,
    );
  }

  void _setColorScheme(
    ColorScheme lightColorScheme,
    CustomColors lightCustomColors,
    ColorScheme darkColorScheme,
    CustomColors darkCustomColors,
  ) {
    _lightColorScheme = lightColorScheme;
    _lightCustomColors = lightCustomColors;
    _lightTitleListTheme = _createTitleListTheme(
      lightColorScheme,
      lightCustomColors,
    );
    _darkColorScheme = darkColorScheme;
    _darkCustomColors = darkCustomColors;
    _darkTitleListTheme = _createTitleListTheme(
      darkColorScheme,
      darkCustomColors,
    );
  }

  static TitleListTheme _createTitleListTheme(
    ColorScheme colorScheme,
    CustomColors customColors,
  ) {
    return TitleListTheme(
      infoLineBackground: colorScheme.primaryContainer,
      infoLineActiveFilterBackground: colorScheme.surface,
      infoLineActiveFilterForeground: colorScheme.primary,
      infoLineInactiveFilterBackground: colorScheme.surface,
      infoLineInactiveFilterForeground: colorScheme.onSurface,
      controlPanelBackground: colorScheme.secondary,
      controlPanelForeground: colorScheme.onSurface,
      controlPanelActiveFilterBackground: colorScheme.primary,
      controlPanelActiveFilterForeground: colorScheme.onSurface,
      controlPanelInactiveFilterBackground: colorScheme.secondary,
      controlPanelInactiveFilterForeground: colorScheme.onSurface,
      searchCursorColor: colorScheme.onSurface,
      searchHintColor: colorScheme.onSurface,
      searchSelectionColor: colorScheme.onSurface.withValues(alpha: 0.5),
    );
  }

  static ColorScheme lightColorSchemeDefault = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF10B981),
    onPrimary: Color(0xFF121212),
    primaryContainer: Color(0xFF121212),
    onPrimaryContainer: Color(0xFFF5F5F5),
    secondary: Color(0xFF333333),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFE5BA73),
    onTertiary: Color(0xFF333333),
    error: Color(0xFF333333),
    onError: Colors.red,
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF9E9E9E),
  );

  static CustomColors lightCustomColorsDefault = CustomColors(
    ratedBook: lightColorSchemeDefault.tertiary,
    navigationBarSelected: lightColorSchemeDefault.primary,
    navigationBarNotSelected: const Color(0xFF8E8E8E),
    dividerColor: lightColorSchemeDefault.secondary,
    bottomNavigationBarBackground: lightColorSchemeDefault.secondary,
    appBarBackground: lightColorSchemeDefault.primaryContainer,
    appBarText: lightColorSchemeDefault.onSurface,
  );

  static ColorScheme darkColorSchemeDefault = lightColorSchemeDefault.copyWith(
    brightness: Brightness.dark,
  );
  static CustomColors darkCustomColorsDefault = lightCustomColorsDefault;
}
