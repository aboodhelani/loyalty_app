import 'package:flutter/material.dart';

/// Design tokens. Structure follows the Zox design system; palette from the
/// client brand: cream #F2EDD7 (brand surface) and brown #755139 (actions).
/// Cream cannot carry white text, so brown drives buttons and accents and
/// cream is the page background and soft highlight.
class AppColors {
  // Brand defaults (placeholder)
  static const Color _defaultPrimary = Color(0xFF755139);

  /// Brand cream — page background and soft fills.
  static const brandCream = Color(0xFFF2EDD7);

  static Color _primary = _defaultPrimary;
  static Color _primaryHover = _darken(_defaultPrimary, 0.12);
  static Color _primarySoft = brandCream;
  static Color _primaryRing = _darken(_defaultPrimary, 0.2);

  static Color get primary => _primary;
  static Color get primaryHover => _primaryHover;
  static Color get primarySoft => _primarySoft;
  static Color get primaryRing => _primaryRing;
  static Color get primaryColor => _primary;

  /// Lighter brand tint for buttons that are loading or not tappable.
  static Color get primaryLight => Color.lerp(_primary, const Color(0xFFFFFFFF), 0.45)!;

  static void applyBrand(Color color) {
    _primary = color;
    _primaryHover = _darken(color, 0.12);
    _primarySoft = color.withValues(alpha: 0.1);
    _primaryRing = _darken(color, 0.2);
  }

  static void resetBrand() {
    _primary = _defaultPrimary;
    _primaryHover = _darken(_defaultPrimary, 0.12);
    _primarySoft = brandCream;
    _primaryRing = _darken(_defaultPrimary, 0.2);
  }

  static Color _darken(Color c, double amount) {
    return Color.fromARGB(
      (c.a * 255).round().clamp(0, 255),
      ((c.r * 255) * (1 - amount)).round().clamp(0, 255),
      ((c.g * 255) * (1 - amount)).round().clamp(0, 255),
      ((c.b * 255) * (1 - amount)).round().clamp(0, 255),
    );
  }

  // Backgrounds
  static const background = brandCream;
  static const surface = Color(0xFFE9E2C6);
  static const surfaceElevated = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);

  // Foregrounds
  static const foreground = Color(0xFF2B1D14);
  static const foregroundMuted = Color(0xFF4A3B30);
  static const foregroundSubtle = Color(0xFF7A6A5C);
  static const foregroundFaint = Color(0xFFA1A1AA);
  static const foregroundPlaceholder = Color(0xFF9F9FA3);

  // Borders
  static const border = Color(0xFFE4DCC0);
  static const borderStrong = Color(0xFFCFC4A0);

  // Neutral tokens (shared with the Zox design system)
  static const neutral500 = Color(0xFF2E2E37);
  static const neutral400 = Color(0xFF58585F);
  static const neutral200 = Color(0xFF9F9FA3);
  static const neutral100 = Color(0xFFBEBEC1);
  static const stroke100 = Color(0xFFF6F6F7);
  static const stroke200 = Color(0xFFF2F2F3);
  static const stroke300 = Color(0xFFECECEE);

  // Stamp card
  /// Empty stamp slot on the grid.
  static const stampEmpty = Color(0xFFEDE6CC);

  /// "Ready to redeem" pill and the reward highlight.
  static const reward = Color(0xFFC08A2E);
  static const rewardFill = Color(0xFFFAF1DC);

  // Status colours — earthy tones tuned to the cream/brown brand.
  static const activeGreen = Color(0xFF5B7F3C);
  static const successFill = Color(0xFFEAF0DC);
  static const warningFill = Color(0xFFFBF1DA);
  static const warningBorder = Color(0xFFEBD3A0);
  static const warningText = Color(0xFF7C5414);
  static const warningAccent = Color(0xFFA9711F);
  static const dangerFill = Color(0xFFF7E4DC);
  static const dangerText = Color(0xFF9C3B24);
  static const infoFill = Color(0xFFE7EEF0);
  static const infoText = Color(0xFF3D6476);

  // Semantic
  static const success = Color(0xFF5B7F3C);
  static const success500 = Color(0xFF5B7F3C);
  static const failedRed = Color(0xFFB4462C);
  static const destructiveIcon = Color(0xFFB4462C);

  /// Wallet buttons (Apple Pay, Google Pay) are black per both brands.
  static const applePay = Color(0xFF000000);

  // Category accents — map pins and placeholder covers.
  static const categoryCafe = Color(0xFF8B5E3C);
  static const categoryRestaurant = Color(0xFFE5484D);
  static const categorySalon = Color(0xFFD6409F);
  static const categoryBarber = Color(0xFF3E63DD);
  static const categoryCarWash = Color(0xFF0EA5E9);
  static const categoryTailor = Color(0xFF7C3AED);
  static const categoryRetail = Color(0xFF12A594);
  static const categoryBeauty = Color(0xFFF76B15);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  // Opacity variants
  static Color get white10 => white.withValues(alpha: 0.1);
  static Color get white70 => white.withValues(alpha: 0.7);
  static Color get black10 => black.withValues(alpha: 0.1);
  static Color get black40 => black.withValues(alpha: 0.4);
  static Color get shadow => const Color(0xFF2B1D14).withValues(alpha: 0.06);
}
