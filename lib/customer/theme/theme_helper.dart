import 'package:flutter/material.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get light_blue_900 => Color(0xFF086788);
  Color get white_A700 => Color(0xFFFFFFFF);
  Color get light_blue_50 => Color(0xFFEBFBFE);
  Color get gray_900 => Color(0xFF1E1E1E);
  Color get blue_gray_900 => Color(0xFF263238);
  Color get black_900 => Color(0xFF000000);
  Color get deep_orange_100 => Color(0xFFFFC3BD);
  Color get light_blue_900_01 => Color(0xFF086688);
  Color get gray_100 => Color(0xFFF5F5F5);
  Color get red_A100 => Color(0xFFED847E);
  Color get blue_gray_900_01 => Color(0xFF30313D);
  Color get blue_gray_400 => Color(0xFF8E8E8E);
  Color get green_900 => Color(0xFF006115);
  Color get light_blue_800 => Color(0xFF0077CC);
  Color get red_500 => Color(0xFFFF3B30);
  Color get red_A700_19 => Color(0x19AF0000);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get whiteCustom => Colors.white;
  Color get greyCustom => Colors.grey;
  Color get color881908 => Color(0x88190867);
  Color get color190077 => Color(0x190077CC);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}
