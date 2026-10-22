import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';

/// Six-box code entry backed by one hidden field, so paste and SMS autofill
/// still work.
class OtpBoxes extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const OtpBoxes({super.key, this.length = 6, required this.onChanged});

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _focus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () => _focus.requestFocus(),
        child: Stack(
          children: [
            // Hidden input that owns the keyboard and autofill.
            Opacity(
              opacity: 0,
              child: SizedBox(
                height: 1,
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  maxLength: widget.length,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: widget.onChanged,
                ),
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < widget.length; i++) ...[
                  if (i > 0) SizedBox(width: 8.w),
                  Expanded(child: _box(i < text.length ? text[i] : '', _focus.hasFocus && i == text.length)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(String digit, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 60.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(
          color: active ? AppColors.primary : (digit.isEmpty ? AppColors.border : AppColors.borderStrong),
          width: active ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Text(digit, style: AppTextStyle.display.copyWith(fontSize: 26.sp)),
    );
  }
}
