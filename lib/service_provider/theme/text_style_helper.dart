import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// Text styles helper for Service Provider screens
class SPTextStyleHelper {
  static SPTextStyleHelper? _instance;

  SPTextStyleHelper._();

  static SPTextStyleHelper get instance {
    _instance ??= SPTextStyleHelper._();
    return _instance!;
  }

  // Headline
  TextStyle get headline24MediumPoppins => TextStyle(
        fontSize: 24.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.light_blue_900,
      );

  // Subhead / Body
  TextStyle get body12RegularPoppins => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_400,
      );

  TextStyle get label10RegularPoppins => TextStyle(
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: appTheme.gray_900,
      );

  TextStyle get title14RegularWhite => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: appTheme.white_A700,
      );
}