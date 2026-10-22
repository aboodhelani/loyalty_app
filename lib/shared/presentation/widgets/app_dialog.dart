import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_style.dart';
import '../../../core/translations/l10n.dart';
import 'app_button.dart';

/// Branded confirmation dialog: icon badge, title, message and full-width
/// actions. Returns true when confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.foreground.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween(begin: 0.94, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ),
    pageBuilder: (context, _, __) => _DialogShell(
      icon: icon,
      tone: destructive ? AppColors.failedRed : AppColors.primary,
      title: title,
      message: message,
      actions: [
        AppButton(
          label: confirmLabel,
          variant: destructive ? AppButtonVariant.danger : AppButtonVariant.primary,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        SizedBox(height: 8.h),
        AppButton(
          label: S.of(context).cancel,
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
  return result == true;
}

/// Branded single-field input dialog. Returns the trimmed value, or null.
Future<String?> showInputDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? message,
  required String label,
  required String confirmLabel,
  TextInputType keyboardType = TextInputType.text,
}) {
  final controller = TextEditingController();
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.foreground.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, _, __) {
      void submit() {
        final v = controller.text.trim();
        if (v.isNotEmpty) Navigator.of(context).pop(v);
      }

      return _DialogShell(
        icon: icon,
        tone: AppColors.primary,
        title: title,
        message: message,
        body: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          style: AppTextStyle.code.copyWith(fontSize: 22.sp, letterSpacing: 3.sp),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          decoration: InputDecoration(hintText: label),
          onSubmitted: (_) => submit(),
        ),
        actions: [
          AppButton(label: confirmLabel, onPressed: submit),
          SizedBox(height: 8.h),
          AppButton(
            label: S.of(context).cancel,
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

class _DialogShell extends StatelessWidget {
  final IconData icon;
  final Color tone;
  final String title;
  final String? message;
  final Widget? body;
  final List<Widget> actions;

  const _DialogShell({
    required this.icon,
    required this.tone,
    required this.title,
    this.message,
    this.body,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.w, 24.h, 24.w, MediaQuery.viewInsetsOf(context).bottom + 24.h),
        child: Material(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(28.sp),
          elevation: 0,
          child: Container(
            constraints: BoxConstraints(maxWidth: 400.w),
            padding: EdgeInsetsDirectional.fromSTEB(24.w, 28.h, 24.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsetsDirectional.all(16.sp),
                    decoration: BoxDecoration(color: tone.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(icon, color: tone, size: 28.sp),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(title, textAlign: TextAlign.center, style: AppTextStyle.sectionTitle),
                if (message != null) ...[
                  SizedBox(height: 8.h),
                  Text(message!, textAlign: TextAlign.center, style: AppTextStyle.body),
                ],
                if (body != null) ...[SizedBox(height: 20.h), body!],
                SizedBox(height: 24.h),
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
