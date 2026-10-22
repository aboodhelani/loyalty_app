import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../../customer/profile/presentation/pages/profile_page.dart';
import '../../../owner/domain/usecases/owner_usecases.dart';
import '../../../owner/presentation/bloc/owner_business_cubit.dart';
import '../../../owner/presentation/pages/business_profile_page.dart';
import '../../../owner/presentation/pages/owner_activity_page.dart';
import '../../../owner/presentation/pages/owner_staff_page.dart';
import '../../../owner/presentation/pages/program_builder_page.dart';
import '../../../../shared/presentation/widgets/app_nav_bar.dart';
import '../../../../core/styles/app_icons.dart';

/// Business app — owner mode (B1–B4), plus Account to switch back.
class OwnerShell extends StatefulWidget {
  final BusinessMembership membership;

  const OwnerShell({super.key, required this.membership});

  @override
  State<OwnerShell> createState() => _OwnerShellState();
}

class _OwnerShellState extends State<OwnerShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final m = widget.membership;
    return BlocProvider(
      create: (_) => OwnerBusinessCubit(
        businessId: m.businessId,
        getBusinessUseCase: sl<GetOwnerBusinessUseCase>(),
        updateProfileUseCase: sl<UpdateBusinessProfileUseCase>(),
        saveProgramUseCase: sl<SaveProgramUseCase>(),
        setProgramStatusUseCase: sl<SetProgramStatusUseCase>(),
        addStaffUseCase: sl<AddStaffUseCase>(),
        removeStaffUseCase: sl<RemoveStaffUseCase>(),
      )..load(),
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            OwnerActivityPage(businessId: m.businessId, businessName: m.businessName),
            const ProgramBuilderPage(),
            const OwnerStaffPage(),
            const BusinessProfilePage(),
            const ProfilePage(),
          ],
        ),
        bottomNavigationBar: AppNavBar(
          index: _index,
          onChanged: (i) => setState(() => _index = i),
          items: [
            AppNavItem(AppIcons.chart, AppIcons.chartFill, s.ownerActivityTab),
            AppNavItem(AppIcons.cards, AppIcons.cardsFill, s.ownerProgramTab),
            AppNavItem(AppIcons.team, AppIcons.teamFill, s.ownerStaffTab),
            AppNavItem(AppIcons.store, AppIcons.storeFill, s.ownerBusinessTab),
            AppNavItem(AppIcons.user, AppIcons.userFill, s.accountTab),
          ],
        ),
      ),
    );
  }
}
