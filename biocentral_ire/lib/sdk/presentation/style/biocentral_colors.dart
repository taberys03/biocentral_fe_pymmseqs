import 'package:flutter/material.dart';

/// Biocentral colour tokens — the ONLY place where colours are defined.
///
/// To change a colour everywhere, change its hex value here.
///
/// Rules for the rest of the code:
/// * Widgets never use `Colors.*` or `Color(0x…)` directly.
/// * Standard roles come from `Theme.of(context).colorScheme.<role>`
///   (primary, surface, onSurfaceVariant, error, inverseSurface, …).
/// * Biocentral-specific roles (success, warning, data sets, plot series)
///   come from `context.bioColors.<role>`.
///
/// Brand colours (_global/design/design_guidelines.md):
/// Purple X11 #8E4DDE (primary) · Pearl Aqua #A1D2CE (secondary).
///
/// Contrast: every text colour below reaches at least 4.5:1 on the surface
/// it is meant for. Re-check contrast when you change a value.
/// The dark values are a first draft and still need testing.
abstract final class BiocentralColorSchemes {
  // ───────────────────────────── Light ─────────────────────────────
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // Main actions, active tab, progress, links. Brand purple.
    primary: Color(0xFF8E4DDE),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEEE4FB), // selected chips, highlighted rows
    onPrimaryContainer: Color(0xFF3A1470),
    inversePrimary: Color(0xFFC9A8F5),

    // Secondary accent. Brand aqua as container, darker teal for text/icons.
    secondary: Color(0xFF2E7D76),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFA1D2CE), // brand aqua
    onSecondaryContainer: Color(0xFF0E3B37),

    // Third accent (blue-violet from the logo), e.g. badges, info.
    tertiary: Color(0xFF4F5BD5),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE0E3FF),
    onTertiaryContainer: Color(0xFF15206E),

    // Real errors only — not for empty values or normal states.
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),

    // Backgrounds and text.
    surface: Color(0xFFFFFFFF), // page background
    onSurface: Color(0xFF1C1B1F), // main text
    onSurfaceVariant: Color(0xFF4A4752), // helper text, secondary labels
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF8F7FA), // side panels, info boxes
    surfaceContainer: Color(0xFFF2F0F5), // cards, table header
    surfaceContainerHigh: Color(0xFFECE9F0), // menus, selected segment
    surfaceContainerHighest: Color(0xFFE6E3EA),

    // Lines.
    outline: Color(0xFF7A7582), // input borders, secondary buttons
    outlineVariant: Color(0xFFD9D5DF), // dividers, card borders

    // Tooltips, snackbars (dark on light = readable).
    inverseSurface: Color(0xFF2D2A32),
    onInverseSurface: Color(0xFFF5F2F7),

    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFF8E4DDE),
  );

  static const BiocentralColors lightExtras = BiocentralColors(
    success: Color(0xFF2E7D32),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFDDF0DE),
    onSuccessContainer: Color(0xFF0F3D12),
    warning: Color(0xFF8A5A00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFDEBC8),
    onWarningContainer: Color(0xFF3D2700),
    // Data sets (based on Okabe–Ito, colour-blind safe; each ≥3:1 on white).
    // Always show with a text label and a small gap between bar segments.
    trainingSet: Color(0xFF005A8C),
    validationSet: Color(0xFFC26A00),
    testSet: Color(0xFF009E73),
    // Charts with several series (e.g. active learning iterations).
    plotSeries: [
      Color(0xFF0072B2),
      Color(0xFFE69F00),
      Color(0xFF009E73),
      Color(0xFFCC79A7),
      Color(0xFF56B4E9),
      Color(0xFFD55E00),
      Color(0xFFF0E442),
      Color(0xFF4A4752),
    ],
  );

  // ───────────────────────────── Dark (draft) ─────────────────────────────
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC29BF5),
    onPrimary: Color(0xFF3A1470),
    primaryContainer: Color(0xFF5F2DA8),
    onPrimaryContainer: Color(0xFFEEE4FB),
    inversePrimary: Color(0xFF8E4DDE),
    secondary: Color(0xFFA1D2CE),
    onSecondary: Color(0xFF0E3B37),
    secondaryContainer: Color(0xFF1F5751),
    onSecondaryContainer: Color(0xFFC4E7E3),
    tertiary: Color(0xFFBCC2FF),
    onTertiary: Color(0xFF1E2A85),
    tertiaryContainer: Color(0xFF3640A8),
    onTertiaryContainer: Color(0xFFE0E3FF),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF141218),
    onSurface: Color(0xFFE7E1EA),
    onSurfaceVariant: Color(0xFFCAC4D0),
    surfaceContainerLowest: Color(0xFF0F0D13),
    surfaceContainerLow: Color(0xFF1D1B20),
    surfaceContainer: Color(0xFF211F26),
    surfaceContainerHigh: Color(0xFF2B2930),
    surfaceContainerHighest: Color(0xFF36343B),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    inverseSurface: Color(0xFFE7E1EA),
    onInverseSurface: Color(0xFF322F35),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFC29BF5),
  );

  static const BiocentralColors darkExtras = BiocentralColors(
    success: Color(0xFF81C995),
    onSuccess: Color(0xFF0A3A16),
    successContainer: Color(0xFF1E4D2B),
    onSuccessContainer: Color(0xFFC8EBD0),
    warning: Color(0xFFF5C26B),
    onWarning: Color(0xFF3D2700),
    warningContainer: Color(0xFF5A3F00),
    onWarningContainer: Color(0xFFFDEBC8),
    trainingSet: Color(0xFF56B4E9),
    validationSet: Color(0xFFE69F00),
    testSet: Color(0xFF2FC49A),
    plotSeries: [
      Color(0xFF56B4E9),
      Color(0xFFE69F00),
      Color(0xFF2FC49A),
      Color(0xFFE59CC9),
      Color(0xFF9AD3F5),
      Color(0xFFFF8A4C),
      Color(0xFFF0E442),
      Color(0xFFCAC4D0),
    ],
  );
}

/// Biocentral-specific colour roles that Flutter's ColorScheme doesn't have.
/// Read them with `context.bioColors.success`, `context.bioColors.trainingSet`, …
@immutable
class BiocentralColors extends ThemeExtension<BiocentralColors> {
  const BiocentralColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.trainingSet,
    required this.validationSet,
    required this.testSet,
    required this.plotSeries,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color trainingSet;
  final Color validationSet;
  final Color testSet;
  final List<Color> plotSeries;

  @override
  BiocentralColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? trainingSet,
    Color? validationSet,
    Color? testSet,
    List<Color>? plotSeries,
  }) {
    return BiocentralColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      trainingSet: trainingSet ?? this.trainingSet,
      validationSet: validationSet ?? this.validationSet,
      testSet: testSet ?? this.testSet,
      plotSeries: plotSeries ?? this.plotSeries,
    );
  }

  @override
  BiocentralColors lerp(ThemeExtension<BiocentralColors>? other, double t) {
    if (other is! BiocentralColors) return this;
    return BiocentralColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      trainingSet: Color.lerp(trainingSet, other.trainingSet, t)!,
      validationSet: Color.lerp(validationSet, other.validationSet, t)!,
      testSet: Color.lerp(testSet, other.testSet, t)!,
      plotSeries: t < 0.5 ? plotSeries : other.plotSeries,
    );
  }
}

extension BiocentralColorsContext on BuildContext {
  /// Biocentral-specific colours of the current theme (light or dark).
  BiocentralColors get bioColors => Theme.of(this).extension<BiocentralColors>()!;
}
