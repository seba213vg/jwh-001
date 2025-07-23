import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.bigStone,
    textTheme: GoogleFonts.gamjaFlowerTextTheme(),
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      elevatedButtonSchemeColor: SchemeColor.surfaceTint,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      listTileTileSchemeColor: SchemeColor.onSecondary,
      listTileSelectedTileSchemeColor: SchemeColor.errorContainer,
      alignedDropdown: true,
      bottomNavigationBarSelectedLabelSchemeColor:
          SchemeColor.onPrimaryContainer,
      bottomNavigationBarSelectedIconSchemeColor:
          SchemeColor.onPrimaryContainer,
      bottomNavigationBarElevation: 3.0,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.bigStone,
    textTheme: GoogleFonts.gamjaFlowerTextTheme(),
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      elevatedButtonSchemeColor: SchemeColor.surfaceTint,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      listTileTileSchemeColor: SchemeColor.onSecondary,
      listTileSelectedTileSchemeColor: SchemeColor.errorContainer,
      alignedDropdown: true,
      bottomNavigationBarSelectedLabelSchemeColor:
          SchemeColor.onPrimaryContainer,
      bottomNavigationBarSelectedIconSchemeColor:
          SchemeColor.onPrimaryContainer,
      bottomNavigationBarElevation: 3.0,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
