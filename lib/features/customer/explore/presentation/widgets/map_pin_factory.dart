import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';

/// Paints the category pins as bitmaps for Google Maps, cached per look.
class MapPinFactory {
  MapPinFactory._();

  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> pin(
    CategoryStyle style, {
    required bool selected,
    required bool hasReward,
    required double devicePixelRatio,
  }) async {
    final key = '${style.icon.codePoint}-${style.color.toARGB32()}-$selected-$hasReward-$devicePixelRatio';
    final cached = _cache[key];
    if (cached != null) return cached;

    final size = selected ? 52.0 : 42.0;
    const tail = 8.0;
    final dpr = devicePixelRatio;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(dpr);
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 3;

    // Soft drop shadow
    canvas.drawCircle(
      center.translate(0, 2),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    // Tail
    final path = Path()
      ..moveTo(size / 2 - 7, size - 8)
      ..lineTo(size / 2 + 7, size - 8)
      ..lineTo(size / 2, size + tail - 2)
      ..close();
    canvas.drawPath(path, Paint()..color = selected ? AppColors.primary : style.color);
    // Ring + body
    canvas.drawCircle(center, radius, Paint()..color = hasReward ? AppColors.reward : AppColors.white);
    canvas.drawCircle(center, radius - 3, Paint()..color = selected ? AppColors.primary : style.color);
    // Icon glyph
    final painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(style.icon.codePoint),
        style: TextStyle(
          fontSize: radius,
          fontFamily: style.icon.fontFamily,
          package: style.icon.fontPackage,
          color: AppColors.white,
        ),
      )
      ..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));

    final image = await recorder.endRecording().toImage((size * dpr).ceil(), ((size + tail) * dpr).ceil());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final descriptor = BitmapDescriptor.bytes(bytes!.buffer.asUint8List(), imagePixelRatio: dpr);
    return _cache[key] = descriptor;
  }
}
