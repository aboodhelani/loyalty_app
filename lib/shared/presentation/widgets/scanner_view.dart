import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_style.dart';
import '../../../core/translations/l10n.dart';
import 'app_dialog.dart';
import '../../../core/styles/app_icons.dart';

/// Camera QR scanner with a typed-code fallback (no camera on simulators, a
/// cracked lens at the counter…). Reports one value per scan; the parent
/// remounts it to scan again.
class ScannerView extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String> onValue;

  const ScannerView({super.key, required this.title, required this.hint, required this.onValue});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final _controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool _done = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _emit(String value) {
    if (_done || value.trim().isEmpty) return;
    _done = true;
    _controller.stop();
    widget.onValue(value.trim());
  }

  Future<void> _typeCode() async {
    final s = S.of(context);
    final value = await showInputDialog(
      context,
      icon: AppIcons.keyboard,
      title: s.enterCode,
      label: s.codeLabel,
      confirmLabel: s.continueLabel,
      keyboardType: TextInputType.visiblePassword,
    );
    if (value != null) _emit(value);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: (capture) {
            final raw = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
            if (raw != null) _emit(raw);
          },
          errorBuilder: (context, error) => ColoredBox(
            color: AppColors.foreground,
            child: Center(
              child: Padding(
                padding: EdgeInsetsDirectional.all(32.sp),
                child: Text(
                  s.cameraUnavailable,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),
        ),
        // Viewfinder
        Center(
          child: Container(
            width: 240.sp,
            height: 240.sp,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white, width: 3),
              borderRadius: BorderRadius.circular(24.sp),
            ),
          ),
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: Container(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.black.withValues(alpha: 0.65), AppColors.transparent],
              ),
            ),
            child: Column(
              children: [
                Text(widget.title, style: AppTextStyle.sectionTitle.copyWith(color: AppColors.white)),
                SizedBox(height: 4.h),
                Text(
                  widget.hint,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.small.copyWith(color: AppColors.white70),
                ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 24.h,
          start: 0,
          end: 0,
          child: Center(
            child: FilledButton.tonalIcon(
              onPressed: _typeCode,
              icon: const Icon(AppIcons.keyboard),
              label: Text(s.enterCode),
            ),
          ),
        ),
      ],
    );
  }
}
