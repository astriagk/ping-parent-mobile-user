import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class AppTheme {
  static ThemeType defaultTheme = ThemeType.light;

  //Theme Colors

  bool isDark;
  Color primary;
  Color darkText;
  Color lightText;
  Color screenBg;
  Color screenDarkBg;
  Color trans;
  Color yellowIcon;
  Color bgBox;
  Color hintText;
  Color white;
  Color borderColor;
  Color stroke;
  Color alertZone;
  Color online;
  Color success;
  Color dashColor;
  Color activeColor;
  Color onBoardBtnClr;
  Color onBoardDotClr;
  Color onBoardTxtClr;

  Color hintTextClr;

  // Color pendingColor;

  /// Default constructor
  AppTheme({
    required this.isDark,
    required this.primary,
    required this.darkText,
    required this.lightText,
    required this.screenBg,
    required this.trans,
    required this.screenDarkBg,
    required this.yellowIcon,
    required this.bgBox,
    required this.hintText,
    required this.white,
    required this.borderColor,
    required this.stroke,
    required this.alertZone,
    required this.online,
    required this.success,
    required this.dashColor,
    required this.activeColor,
    required this.onBoardBtnClr,
    required this.onBoardDotClr,
    required this.onBoardTxtClr,
    required this.hintTextClr,
  });

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppTheme(
            isDark: false,
            primary: const Color(0xff171C26),
            darkText: const Color(0xff171C26),
            lightText: const Color(0xFFA2A4A8),
            screenBg: const Color(0xffFFFFFF),
            screenDarkBg: const Color(0xff171C26),
            trans: Colors.transparent,
            yellowIcon: const Color(0xFFFFB400),
            bgBox: const Color(0xFFF3F4F6),
            hintText: const Color(0xFFA2A4A8),
            white: const Color(0xffFFFFFF),
            borderColor: const Color(0xFFEFEFEF),
            stroke: const Color(0xFFE8E8E9),
            alertZone: const Color(0xFFFF4B4B),
            online: Colors.green,
            success: const Color(0xFF20B149),
            dashColor: const Color(0xFF96989B),
            activeColor: const Color(0xFF3F8FDA),
            onBoardBtnClr: Color(0xff199675),
            onBoardDotClr: Color(0xffE5E8EA),
            onBoardTxtClr: Color(0xff808B97),
            hintTextClr: Color(0xff797D83));

      case ThemeType.dark:
        return AppTheme(
            isDark: true,
            primary: const Color(0xff622CFD),
            darkText: const Color(0xff171C26),
            lightText: const Color(0xFFA2A4A8),
            screenBg: const Color(0xFF17161B),
            screenDarkBg: const Color(0xff171C26),
            trans: Colors.transparent,
            yellowIcon: const Color(0xFFFFB400),
            bgBox: const Color(0xFFF3F4F6),
            hintText: const Color(0xFFA2A4A8),
            white: const Color(0xffFFFFFF),
            borderColor: const Color(0xFFEFEFEF),
            stroke: const Color(0xFFE8E8E9),
            online: Colors.green,
            alertZone: const Color(0xFFFF4B4B),
            success: const Color(0xFF20B149),
            dashColor: const Color(0xFF96989B),
            activeColor: const Color(0xFF3F8FDA),
            onBoardBtnClr: Color(0xff199675),
            onBoardDotClr: Color(0xffE5E8EA),
            onBoardTxtClr: Color(0xff808B97),
            hintTextClr: Color(0xff797D83));
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
        textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
        useMaterial3: true,
        colorScheme: ColorScheme(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primary: primary,
            secondary: primary,
            surface: screenBg,
            onSurface: screenBg,
            onError: Colors.red,
            onPrimary: primary,
            tertiary: screenBg,
            onInverseSurface: screenBg,
            tertiaryContainer: screenBg,
            surfaceTint: screenBg,
            surfaceContainerHighest: screenBg,
            onSecondary: primary,
            error: Colors.red));
    return t.copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.transparent, cursorColor: primary),
        buttonTheme: ButtonThemeData(buttonColor: primary),
        highlightColor: primary);
  }
}
