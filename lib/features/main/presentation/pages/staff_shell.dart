import 'package:flutter/material.dart';

import '../../../../core/translations/l10n.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../../customer/profile/presentation/pages/profile_page.dart';
import '../../../staff/presentation/pages/live_payments_page.dart';
import '../../../staff/presentation/pages/staff_redeem_page.dart';
import '../../../staff/presentation/pages/staff_stamp_page.dart';
import '../../../../shared/presentation/widgets/app_nav_bar.dart';
import '../../../../core/styles/app_icons.dart';

/// Business app — staff mode (S1–S3). No settings, by design (spec §3).
class StaffShell extends StatefulWidget {
  final BusinessMembership membership;

  const StaffShell({super.key, required this.membership});

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final m = widget.membership;
    return Scaffold(
      // Scanners are mounted only while their tab shows, so the camera is
      // released on the other tabs.
      body: IndexedStack(
        index: _index,
        children: [
          _index == 0 ? StaffStampPage(businessId: m.businessId) : const SizedBox.shrink(),
          _index == 1 ? StaffRedeemPage(businessId: m.businessId) : const SizedBox.shrink(),
          LivePaymentsPage(businessId: m.businessId, businessName: m.businessName),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: AppNavBar(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
        items: [
          AppNavItem(AppIcons.scan, AppIcons.scan, s.staffStampTab),
          AppNavItem(AppIcons.gift, AppIcons.gift, s.staffRedeemTab),
          AppNavItem(AppIcons.receipt, AppIcons.receiptFill, s.staffPaymentsTab),
          AppNavItem(AppIcons.user, AppIcons.userFill, s.accountTab),
        ],
      ),
    );
  }
}
