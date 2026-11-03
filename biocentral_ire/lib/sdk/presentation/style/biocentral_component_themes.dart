import 'package:flutter/material.dart';

import 'package:biocentral/sdk/presentation/style/biocentral_spacing.dart';

/// Biocentral component themes — the "CSS rules" for every widget type.
///
/// Each method styles one kind of Flutter widget for the whole app.
/// Colours come only from the [ColorScheme] (see biocentral_colors.dart),
/// sizes from biocentral_spacing.dart, text from the [TextTheme]
/// (see biocentral_typography.dart).
///
/// With Material 3 most colours already follow the ColorScheme, so these
/// themes mainly set shapes, sizes, borders and text styles.
///
/// Important: Flutter has no cascade. A style set directly on a widget
/// (`color: …`, `style: TextStyle(…)`) always wins over these themes, so
/// feature code must not style widgets itself.
abstract final class BiocentralComponentThemes {
  // ───────────────────────────── Shared shapes ─────────────────────────────

  static RoundedRectangleBorder _controlShape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(BiocentralRadius.m));

  static RoundedRectangleBorder _panelShape(ColorScheme c) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BiocentralRadius.l),
        side: BorderSide(color: c.outlineVariant),
      );

  static const Size _buttonMinSize = Size(64, BiocentralSizes.controlHeight);
  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(horizontal: BiocentralSpacing.l + 4);

  // ───────────────────────────── Buttons ─────────────────────────────
  // Hierarchy: FilledButton = the one main action per screen,
  // OutlinedButton = secondary (Back, Discard), TextButton = tertiary
  // (Advanced settings, Reset to defaults).

  static FilledButtonThemeData filledButton(ColorScheme c, TextTheme t) => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: _buttonMinSize,
          padding: _buttonPadding,
          shape: _controlShape(),
          textStyle: t.labelLarge,
        ),
      );

  /// Existing ElevatedButtons look like the primary FilledButton (no shadow),
  /// so old and new code look the same until they are migrated.
  static ElevatedButtonThemeData elevatedButton(ColorScheme c, TextTheme t) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          elevation: 0,
          minimumSize: _buttonMinSize,
          padding: _buttonPadding,
          shape: _controlShape(),
          textStyle: t.labelLarge,
        ),
      );

  static OutlinedButtonThemeData outlinedButton(ColorScheme c, TextTheme t) => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.onSurface,
          side: BorderSide(color: c.outline),
          minimumSize: _buttonMinSize,
          padding: _buttonPadding,
          shape: _controlShape(),
          textStyle: t.labelLarge,
        ),
      );

  static TextButtonThemeData textButton(ColorScheme c, TextTheme t) => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          minimumSize: const Size(48, BiocentralSizes.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: BiocentralSpacing.m),
          shape: _controlShape(),
          textStyle: t.labelLarge,
        ),
      );

  static IconButtonThemeData iconButton(ColorScheme c) => IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: c.onSurfaceVariant,
          minimumSize: const Size(BiocentralSizes.minTapTarget, BiocentralSizes.minTapTarget),
          iconSize: BiocentralSizes.iconSize,
          shape: _controlShape(),
        ),
      );

  /// Toggles like "Overwrite / Merge" or "Database / Insights".
  static SegmentedButtonThemeData segmentedButton(ColorScheme c, TextTheme t) => SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          foregroundColor: c.onSurface,
          selectedForegroundColor: c.onPrimaryContainer,
          selectedBackgroundColor: c.primaryContainer,
          side: BorderSide(color: c.outline),
          minimumSize: const Size(48, BiocentralSizes.controlHeight),
          textStyle: t.labelLarge,
          shape: _controlShape(),
        ),
      );

  // ───────────────────────────── Inputs & dropdowns ─────────────────────────────

  /// Text fields, number fields and the field part of dropdowns.
  static InputDecorationThemeData inputDecoration(ColorScheme c, TextTheme t) {
    OutlineInputBorder border(Color color, [double width = BiocentralSizes.borderWidth]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(BiocentralRadius.m),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationThemeData(
      filled: true,
      fillColor: c.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: BiocentralSpacing.m, vertical: BiocentralSpacing.m),
      border: border(c.outline),
      enabledBorder: border(c.outline),
      focusedBorder: border(c.primary, BiocentralSizes.focusBorderWidth),
      errorBorder: border(c.error),
      focusedErrorBorder: border(c.error, BiocentralSizes.focusBorderWidth),
      disabledBorder: border(c.outlineVariant),
      labelStyle: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
      floatingLabelStyle: t.bodySmall?.copyWith(color: c.primary),
      hintStyle: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
      helperStyle: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
      helperMaxLines: 3,
      errorStyle: t.bodySmall?.copyWith(color: c.error),
      errorMaxLines: 3,
      prefixIconColor: c.onSurfaceVariant,
      suffixIconColor: c.onSurfaceVariant,
    );
  }

  static MenuStyle _menuStyle(ColorScheme c) => MenuStyle(
        backgroundColor: WidgetStatePropertyAll(c.surfaceContainer),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(3),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: BiocentralSpacing.xs)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BiocentralRadius.m),
            side: BorderSide(color: c.outlineVariant),
          ),
        ),
      );

  /// DropdownMenu (Material 3 dropdown with optional search).
  static DropdownMenuThemeData dropdownMenu(ColorScheme c, TextTheme t) => DropdownMenuThemeData(
        textStyle: t.bodyMedium,
        inputDecorationTheme: inputDecoration(c, t),
        menuStyle: _menuStyle(c),
      );

  static MenuThemeData menu(ColorScheme c) => MenuThemeData(style: _menuStyle(c));

  static PopupMenuThemeData popupMenu(ColorScheme c, TextTheme t) => PopupMenuThemeData(
        color: c.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        textStyle: t.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BiocentralRadius.m),
          side: BorderSide(color: c.outlineVariant),
        ),
      );

  static ChipThemeData chip(ColorScheme c, TextTheme t) => ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: c.primaryContainer,
        checkmarkColor: c.onPrimaryContainer,
        labelStyle: t.labelLarge?.copyWith(color: c.onSurface),
        side: BorderSide(color: c.outline),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: BiocentralSpacing.s, vertical: BiocentralSpacing.xs),
      );

  static SliderThemeData slider(ColorScheme c, TextTheme t) => SliderThemeData(
        trackHeight: 4,
        activeTrackColor: c.primary,
        inactiveTrackColor: c.primaryContainer,
        thumbColor: c.primary,
        overlayColor: c.primary.withValues(alpha: 0.12),
        activeTickMarkColor: c.onPrimary,
        inactiveTickMarkColor: c.primary,
        valueIndicatorColor: c.inverseSurface,
        valueIndicatorTextStyle: t.labelMedium?.copyWith(color: c.onInverseSurface),
      );

  // ───────────────────────────── Surfaces ─────────────────────────────

  static CardThemeData card(ColorScheme c) => CardThemeData(
        color: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: _panelShape(c),
      );

  static DialogThemeData dialog(ColorScheme c, TextTheme t) => DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BiocentralRadius.l)),
        titleTextStyle: t.headlineSmall,
        contentTextStyle: t.bodyMedium,
      );

  /// Used for collapsible sections ("Command Config", "Advanced settings").
  static ExpansionTileThemeData expansionTile(ColorScheme c) => ExpansionTileThemeData(
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        tilePadding: const EdgeInsets.symmetric(horizontal: BiocentralSpacing.l),
        childrenPadding: const EdgeInsets.fromLTRB(BiocentralSpacing.l, 0, BiocentralSpacing.l, BiocentralSpacing.m),
        textColor: c.onSurface,
        collapsedTextColor: c.onSurface,
        iconColor: c.onSurfaceVariant,
        collapsedIconColor: c.onSurfaceVariant,
      );

  static DividerThemeData divider(ColorScheme c) => DividerThemeData(
        color: c.outlineVariant,
        thickness: 1,
        space: 1,
      );

  static DataTableThemeData dataTable(ColorScheme c, TextTheme t) => DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(c.surfaceContainer),
        headingTextStyle: t.titleSmall,
        dataTextStyle: t.bodyMedium,
        dividerThickness: 1,
      );

  // ───────────────────────────── Navigation ─────────────────────────────

  static TabBarThemeData tabBar(ColorScheme c, TextTheme t) => TabBarThemeData(
        labelColor: c.onSurface,
        unselectedLabelColor: c.onSurfaceVariant,
        indicatorColor: c.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: c.outlineVariant,
        labelStyle: t.titleSmall,
        unselectedLabelStyle: t.titleSmall?.copyWith(fontWeight: FontWeight.w400),
      );

  static AppBarThemeData appBar(ColorScheme c, TextTheme t) => AppBarThemeData(
        backgroundColor: c.surface,
        foregroundColor: c.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: t.titleLarge,
      );

  // ───────────────────────────── Feedback ─────────────────────────────

  /// Dark tooltip on light theme (and the other way round) for readable contrast.
  static TooltipThemeData tooltip(ColorScheme c, TextTheme t) => TooltipThemeData(
        decoration: BoxDecoration(
          color: c.inverseSurface,
          borderRadius: BorderRadius.circular(BiocentralRadius.s),
        ),
        textStyle: t.bodySmall?.copyWith(color: c.onInverseSurface),
        padding: const EdgeInsets.symmetric(horizontal: BiocentralSpacing.m - 2, vertical: BiocentralSpacing.xs + 2),
        waitDuration: BiocentralDurations.tooltipWait,
      );

  static SnackBarThemeData snackBar(ColorScheme c, TextTheme t) => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.inverseSurface,
        contentTextStyle: t.bodyMedium?.copyWith(color: c.onInverseSurface),
        actionTextColor: c.inversePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BiocentralRadius.m)),
      );

  static ProgressIndicatorThemeData progressIndicator(ColorScheme c) => ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.primaryContainer,
        circularTrackColor: c.primaryContainer,
        linearMinHeight: 4,
      );
}
