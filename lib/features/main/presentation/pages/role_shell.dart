import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/entities/app_mode.dart';
import '../../../../shared/presentation/session/session_cubit.dart';
import 'customer_shell.dart';
import 'owner_shell.dart';
import 'staff_shell.dart';

/// One app, three shells (spec §2): the session's mode decides which screens
/// show. Switching mode swaps the shell in place.
class RoleShell extends StatelessWidget {
  const RoleShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen: (a, b) => a.mode != b.mode || a.activeBusinessId != b.activeBusinessId,
      builder: (context, state) {
        final membership = state.activeMembership;
        final child = switch (state.mode) {
          AppMode.owner when membership != null => OwnerShell(membership: membership),
          AppMode.staff when membership != null => StaffShell(membership: membership),
          _ => const CustomerShell(),
        };
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(key: ValueKey('${state.mode}-${state.activeBusinessId}'), child: child),
        );
      },
    );
  }
}
