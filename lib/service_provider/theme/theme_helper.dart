import 'package:flutter/material.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => SPThemeHelper().themeColor();
ThemeData get theme => SPThemeHelper().themeData();

/// Helper class for managing themes and colors for Service Provider.
class SPThemeHelper {
  // Supported custom color themes
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // Supported color schemes
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  LightCodeColors themeColor() => _getThemeColors();
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = const ColorScheme.light();
}

class LightCodeColors {
  // App Colors (aligned with customer theme)
  Color get light_blue_900 => const Color(0xFF086788); // Protz Primary
  Color get white_A700 => const Color(0xFFFFFFFF);
  Color get light_blue_50 => const Color(0xFFEBFBFE);  // Protz Secondary
  Color get gray_900 => const Color(0xFF1E1E1E);       // Black
  Color get blue_gray_400 => const Color(0xFF8E8E8E);  // Dark Grey

  // Additional
  Color get transparentCustom => Colors.transparent;
}