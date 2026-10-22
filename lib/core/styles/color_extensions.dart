import 'package:flutter/material.dart';

/// Converts a [Color] to a `#RRGGBB` hex string.
extension ColorHexX on Color {
  String toHex() {
    int channel(double v) => (v * 255).round().clamp(0, 255);
    String two(int v) => v.toRadixString(16).padLeft(2, '0');
    return '#${two(channel(r))}${two(channel(g))}${two(channel(b))}'.toUpperCase();
  }
}

/// Parses a `#RRGGBB` (or `RRGGBB`) hex string into a [Color].
extension HexStringX on String {
  Color toColor() {
    final h = replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
