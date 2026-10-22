import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/presentation/session/auth_gate.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';

/// Guest placeholder for tabs that need an account.
class SignInPrompt extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const SignInPrompt({super.key, required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      icon: icon,
      title: title,
      message: message,
      action: SizedBox(
        width: 200.w,
        child: ElevatedButton(onPressed: () => ensureSignedIn(context), child: Text(S.of(context).signIn)),
      ),
    );
  }
}
