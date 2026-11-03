/// Biocentral spacing, sizes and shapes — the "CSS variables" for layout.
///
/// Use these instead of raw numbers in widgets:
/// `SizedBox(height: BiocentralSpacing.l)`,
/// `BorderRadius.circular(BiocentralRadius.m)`.
library;

/// Spacing scale on a 4 px grid. Use for padding, margins and gaps.
abstract final class BiocentralSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Inner padding of pages / tab content.
  static const double page = xl;

  /// Inner padding of cards and panels.
  static const double card = xl;
}

/// Corner radii.
abstract final class BiocentralRadius {
  /// Tooltips, small badges.
  static const double s = 6;

  /// Buttons, inputs, dropdowns, menus.
  static const double m = 8;

  /// Cards, panels, dialogs.
  static const double l = 12;

  /// Chips and pills (fully rounded).
  static const double pill = 999;
}

/// Fixed sizes of controls and layout.
abstract final class BiocentralSizes {
  /// Height of buttons, inputs and dropdowns.
  static const double controlHeight = 40;

  /// Minimum size of anything clickable (accessibility).
  static const double minTapTarget = 44;

  static const double iconSize = 20;
  static const double iconSizeSmall = 16;

  static const double borderWidth = 1;
  static const double focusBorderWidth = 2;

  /// Maximum width of forms and text blocks, so lines stay readable.
  static const double maxContentWidth = 960;
}

/// Durations for hover delays and animations.
abstract final class BiocentralDurations {
  static const Duration tooltipWait = Duration(milliseconds: 500);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
}
