import 'package:flutter/material.dart';

import 'package:biocentral/sdk/presentation/style/biocentral_colors.dart';
import 'package:biocentral/sdk/presentation/style/biocentral_component_themes.dart';
import 'package:biocentral/sdk/presentation/style/biocentral_typography.dart';

/// Biocentral's global "stylesheet": assembles colours, typography and
/// component themes into the light and dark [ThemeData].
///
/// The names `lightTheme` and `darkTheme` stay the same, so main.dart
/// doesn't need to change.
///
/// Where to change what:
/// * a colour            → biocentral_colors.dart
/// * a font or text size → biocentral_typography.dart
/// * spacing, radii      → biocentral_spacing.dart
/// * how a widget looks  → biocentral_component_themes.dart
class BiocentralStyle {
  static final ThemeData lightTheme = _build(
    BiocentralColorSchemes.light,
    BiocentralColorSchemes.lightExtras,
  );

  static final ThemeData darkTheme = _build(
    BiocentralColorSchemes.dark,
    BiocentralColorSchemes.darkExtras,
  );

  static ThemeData _build(ColorScheme c, BiocentralColors extras) {
    final t = BiocentralTypography.textTheme(c);

    return ThemeData(
      // Material 3 is the default since Flutter 3.16 (the old theme set useMaterial3: false).
      colorScheme: c,
      textTheme: t,
      fontFamily: BiocentralFonts.body,
      fontFamilyFallback: BiocentralFonts.sansFallback,
      scaffoldBackgroundColor: c.surface,
      canvasColor: c.surface,
      // Same control sizes on macOS, Windows and Linux.
      visualDensity: VisualDensity.standard,
      extensions: <ThemeExtension<dynamic>>[extras],

      // Buttons
      filledButtonTheme: BiocentralComponentThemes.filledButton(c, t),
      elevatedButtonTheme: BiocentralComponentThemes.elevatedButton(c, t),
      outlinedButtonTheme: BiocentralComponentThemes.outlinedButton(c, t),
      textButtonTheme: BiocentralComponentThemes.textButton(c, t),
      iconButtonTheme: BiocentralComponentThemes.iconButton(c),
      segmentedButtonTheme: BiocentralComponentThemes.segmentedButton(c, t),

      // Inputs & dropdowns
      inputDecorationTheme: BiocentralComponentThemes.inputDecoration(c, t),
      dropdownMenuTheme: BiocentralComponentThemes.dropdownMenu(c, t),
      menuTheme: BiocentralComponentThemes.menu(c),
      popupMenuTheme: BiocentralComponentThemes.popupMenu(c, t),
      chipTheme: BiocentralComponentThemes.chip(c, t),
      sliderTheme: BiocentralComponentThemes.slider(c, t),

      // Surfaces
      cardTheme: BiocentralComponentThemes.card(c),
      dialogTheme: BiocentralComponentThemes.dialog(c, t),
      expansionTileTheme: BiocentralComponentThemes.expansionTile(c),
      dividerTheme: BiocentralComponentThemes.divider(c),
      dataTableTheme: BiocentralComponentThemes.dataTable(c, t),

      // Navigation
      tabBarTheme: BiocentralComponentThemes.tabBar(c, t),
      appBarTheme: BiocentralComponentThemes.appBar(c, t),

      // Feedback
      tooltipTheme: BiocentralComponentThemes.tooltip(c, t),
      snackBarTheme: BiocentralComponentThemes.snackBar(c, t),
      progressIndicatorTheme: BiocentralComponentThemes.progressIndicator(c),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Active Learning colours — kept unchanged so the Active Learning plugin
  // still compiles. TODO(step 2): replace their uses with
  // `context.bioColors` (success, warning, plotSeries) and the ColorScheme,
  // then delete this block.
  // ─────────────────────────────────────────────────────────────────────
  static const Color alTooltipBackground = Color(0xFF455A64);
  static const Color alTooltipTextColor = Colors.white;
  static const Color alConnectorLineColor = Colors.transparent;
  static const Color alPredictionErrorBodyColor = Color(0xFF673AB7);
  static const Color alPredictionLineColor = Colors.blue;
  static const Color alExperimentalLineColor = Colors.orange;
  static const Color alWarningColor = Colors.orange;
  static const Color alWarningBackgroundColor = Color(0xFFFFE0B2);
  static const Color alWarningTextColor = Color(0xFFEF6C00);
  static const Color alSuccessColor = Colors.green;
  static const Color alSuccessTextColor = Color(0xFF388E3C);
  static const Color alCriticalColor = Colors.red;
  static const Color alCriticalBackgroundColor = Color(0xFFFFCDD2);
  static const List<Color> alIterationColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.brown,
    Colors.pink,
  ];
  static const List<Color> alScoreGradientColors = [
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.yellow,
  ];
}
