import 'package:flutter/material.dart';

import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../bloc/owner_business_cubit.dart';

/// Shared toasts for writes on [OwnerBusinessCubit].
void showOwnerFeedback(BuildContext context, OwnerBusinessState state) {
  if (state is! OwnerBusinessLoaded) return;
  final s = S.of(context);
  if (state.error != null) {
    AppSnackBar.showError(context, state.error!);
    return;
  }
  final message = switch (state.savedMessageKey) {
    'program' => s.programSaved,
    'business' => s.businessSaved,
    'staff' => s.staffAdded,
    _ => null,
  };
  if (message != null) AppSnackBar.showSuccess(context, message);
}
