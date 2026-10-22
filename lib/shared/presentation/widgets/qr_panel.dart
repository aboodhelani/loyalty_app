import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/styles/app_colors.dart';

/// A QR code on a white tile, sized for scanning across a counter.
class QrPanel extends StatelessWidget {
  final String data;
  final double? size;

  const QrPanel({super.key, required this.data, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: AppColors.border),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: QrImageView(
          key: ValueKey(data),
          data: data,
          size: size ?? 220.sp,
          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.foreground),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: AppColors.foreground,
          ),
        ),
      ),
    );
  }
}
