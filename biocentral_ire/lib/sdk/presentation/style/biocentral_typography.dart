import 'package:flutter/material.dart';

/// Biocentral fonts and text styles — the "CSS variables" for type.
///
/// Widgets never create their own `TextStyle(fontSize: …)`. They use
/// `Theme.of(context).textTheme.<style>` and, if needed, `.copyWith(…)`
/// for weight or colour only.
///
/// Fonts (_global/design/design_guidelines.md): Noto Sans / Liberation Mono
/// for headlines, Liberation Sans for text. Here: Noto Sans for all UI text
/// and Liberation Mono for sequences and IDs. To use Liberation Sans for body
/// text instead, change [BiocentralFonts.body].
///
/// The font files must be added to pubspec.yaml (see the snippet at the end
/// of this file). Until then, Flutter falls back to the fallback fonts.
abstract final class BiocentralFonts {
  static const String heading = 'NotoSans';
  static const String body = 'NotoSans';
  static const String mono = 'LiberationMono';

  static const List<String> sansFallback = ['Liberation Sans', 'Helvetica Neue', 'Arial', 'sans-serif'];
  static const List<String> monoFallback = ['Menlo', 'Consolas', 'DejaVu Sans Mono', 'monospace'];
}

abstract final class BiocentralTypography {
  /// The full text scale, based on Material 3 sizes for a desktop app.
  ///
  /// | Style          | Size | Use                                        |
  /// |----------------|------|--------------------------------------------|
  /// | displayLarge   | 48   | Welcome screen only                        |
  /// | displayMedium  | 40   | –                                          |
  /// | displaySmall   | 32   | –                                          |
  /// | headlineLarge  | 28   | Big empty states                           |
  /// | headlineMedium | 24   | Dialog titles on large dialogs             |
  /// | headlineSmall  | 22   | Page title (e.g. "Prepare data")           |
  /// | titleLarge     | 18   | Section / card title                       |
  /// | titleMedium    | 16   | Sub-section title                          |
  /// | titleSmall     | 14   | Field labels, tab labels (semi-bold)       |
  /// | bodyLarge      | 16   | Longer explanations                        |
  /// | bodyMedium     | 14   | Default text, table cells, inputs          |
  /// | bodySmall      | 13   | Helper text under fields, captions         |
  /// | labelLarge     | 14   | Buttons, chips                             |
  /// | labelMedium    | 12   | Badges, small buttons                      |
  /// | labelSmall     | 11   | Tiny labels (use sparingly)                |
  static TextTheme textTheme(ColorScheme colors) {
    const heading = BiocentralFonts.heading;
    const body = BiocentralFonts.body;
    const fallback = BiocentralFonts.sansFallback;

    return const TextTheme(
      displayLarge: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 48, height: 1.15, fontWeight: FontWeight.w600, letterSpacing: -0.5),
      displayMedium: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 40, height: 1.2, fontWeight: FontWeight.w600, letterSpacing: -0.25),
      displaySmall: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 32, height: 1.25, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 28, height: 1.3, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 24, height: 1.3, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 22, height: 1.3, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 18, height: 1.35, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontFamily: heading, fontFamilyFallback: fallback, fontSize: 16, height: 1.4, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 14, height: 1.4, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 14, height: 1.45, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 13, height: 1.4, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 14, height: 1.3, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 12, height: 1.3, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontFamily: body, fontFamilyFallback: fallback, fontSize: 11, height: 1.3, fontWeight: FontWeight.w600, letterSpacing: 0.2),
    ).apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
  }

  /// Monospace style for sequences, accession IDs and code-like values.
  /// Use: `BiocentralTypography.mono(context)`.
  static TextStyle mono(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    return base.copyWith(
      fontFamily: BiocentralFonts.mono,
      fontFamilyFallback: BiocentralFonts.monoFallback,
      fontSize: 13,
    );
  }

  /// Helper text under form fields (one line explaining a setting).
  static TextStyle helper(BuildContext context) {
    final theme = Theme.of(context);
    return (theme.textTheme.bodySmall ?? const TextStyle(fontSize: 13)).copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
  }
}

// ─── pubspec.yaml snippet ────────────────────────────────────────────────
// Download the fonts (both SIL Open Font License) and put the .ttf files
// into assets/fonts/:
//   Noto Sans:       https://fonts.google.com/noto/specimen/Noto+Sans
//   Liberation Mono: https://github.com/liberationfonts/liberation-fonts
//
// flutter:
//   fonts:
//     - family: NotoSans
//       fonts:
//         - asset: assets/fonts/NotoSans-Regular.ttf
//         - asset: assets/fonts/NotoSans-SemiBold.ttf
//           weight: 600
//         - asset: assets/fonts/NotoSans-Bold.ttf
//           weight: 700
//     - family: LiberationMono
//       fonts:
//         - asset: assets/fonts/LiberationMono-Regular.ttf
//         - asset: assets/fonts/LiberationMono-Bold.ttf
//           weight: 700
