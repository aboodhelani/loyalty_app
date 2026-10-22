import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../shared/domain/entities/app_mode.dart';
import '../../../../../shared/domain/models/app_user.dart';
import '../../../../../shared/presentation/session/session_cubit.dart';
import '../../../../../shared/presentation/widgets/app_dialog.dart';
import '../../../../../shared/presentation/widgets/page_header.dart';
import '../../../../../shared/presentation/widgets/settings_group.dart';
import '../../../../auth/domain/usecases/auth_usecases.dart';
import '../../../wallet/presentation/widgets/sign_in_prompt.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/edit_profile_sheet.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../shared/presentation/widgets/animations.dart';

/// Profile (C12). Also the "Account" tab of the owner and staff shells, where
/// it is the way back to customer mode.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final session = context.watch<SessionCubit>();
    final user = session.state.user;
    return BlocProvider(
      create: (_) => ProfileCubit(
        updateProfileUseCase: sl<UpdateProfileUseCase>(),
        onUserUpdated: session.userUpdated,
      ),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.error != null) AppSnackBar.showError(context, state.error!);
          if (state.saved) AppSnackBar.showSuccess(context, s.profileSaved);
        },
        child: Scaffold(
          body: user == null
              ? Column(
                  children: [
                    PageHeader(title: s.profileTabTitle),
                    Expanded(
                      child: SignInPrompt(icon: AppIcons.user, title: s.guestName, message: s.guestSubtitle),
                    ),
                  ],
                )
              : _ProfileBody(user: user, mode: session.state.mode),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final AppUser user;
  final AppMode mode;

  const _ProfileBody({required this.user, required this.mode});

  Future<void> _edit(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final params = await showEditProfileSheet(context, user);
    if (params != null) cubit.update(params, announce: true);
  }

  Future<void> _switchMode(BuildContext context, AppMode target) async {
    final session = context.read<SessionCubit>();
    final memberships = SessionCubit.membershipsFor(user, target);
    String? businessId;
    if (memberships.length > 1) {
      businessId = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final m in memberships)
                ListTile(
                  title: Text(m.businessName),
                  subtitle: m.branchName == null ? null : Text(m.branchName!),
                  onTap: () => Navigator.of(context).pop(m.businessId),
                ),
            ],
          ),
        ),
      );
      if (businessId == null) return;
    }
    await session.switchMode(target, businessId: businessId);
  }

  Future<void> _logout(BuildContext context) async {
    final s = S.of(context);
    final confirmed = await showConfirmDialog(
      context,
      icon: AppIcons.signOut,
      title: s.logOut,
      message: s.logOutConfirm,
      confirmLabel: s.logOut,
      destructive: true,
    );
    if (confirmed && context.mounted) await context.read<SessionCubit>().logout();
  }

  String _modeLabel(S s, AppMode m) => switch (m) {
        AppMode.customer => s.switchToCustomer,
        AppMode.owner => s.switchToOwner,
        AppMode.staff => s.switchToStaff,
      };

  IconData _modeIcon(AppMode m) => switch (m) {
        AppMode.customer => AppIcons.userFill,
        AppMode.owner => AppIcons.storeFill,
        AppMode.staff => AppIcons.scan,
      };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cubit = context.read<ProfileCubit>();
    final otherModes = SessionCubit.availableModes(user).where((m) => m != mode).toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        PageHeader(title: mode == AppMode.customer ? s.profileTabTitle : s.accountTab),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeSlideIn(child: _ProfileHeader(user: user, onEdit: () => _edit(context))),
              if (otherModes.isNotEmpty) ...[
                SizedBox(height: 20.h),
                FadeSlideIn(
                    index: 1,
                    child: SettingsGroup(
                      title: s.businessMode,
                      children: [
                        for (final m in otherModes)
                          SettingsTile(
                            icon: _modeIcon(m),
                            title: _modeLabel(s, m),
                            onTap: () => _switchMode(context, m),
                          ),
                      ],
                    )),
              ],
              SizedBox(height: 20.h),
              FadeSlideIn(
                  index: 2,
                  child: SettingsGroup(
                    title: s.preferences,
                    children: [
                      if (mode == AppMode.customer)
                        SettingsTile(
                          icon: AppIcons.history,
                          iconColor: AppColors.infoText,
                          title: s.visitHistory,
                          onTap: () => Navigator.of(context).pushNamed(AppRouteEnum.visitHistory.name),
                        ),
                      SettingsTile(
                        icon: AppIcons.bell,
                        iconColor: AppColors.reward,
                        title: s.notifications,
                        subtitle: s.notificationsSubtitle,
                        trailing: Switch.adaptive(
                          value: user.notificationsEnabled,
                          activeTrackColor: AppColors.primary,
                          onChanged: (v) => cubit.update(UpdateProfileParams(notificationsEnabled: v)),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 20.h),
              FadeSlideIn(
                  index: 3,
                  child: SettingsGroup(
                    children: [
                      SettingsTile(
                        icon: AppIcons.signOut,
                        iconColor: AppColors.failedRed,
                        title: s.logOut,
                        titleColor: AppColors.failedRed,
                        trailing: const SizedBox.shrink(),
                        onTap: () => _logout(context),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

/// Brand gradient header with initials, name, phone and birthday.
class _ProfileHeader extends StatelessWidget {
  final AppUser user;
  final VoidCallback onEdit;

  const _ProfileHeader({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final radius = BorderRadius.circular(24.sp);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF8A6347), AppColors.primary, const Color(0xFF5A3D2A)],
        ),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 8))
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onEdit,
          child: Padding(
            padding: EdgeInsetsDirectional.all(18.sp),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: AppColors.brandCream,
                  child: Text(
                    user.firstName.isEmpty ? '?' : user.firstName[0].toUpperCase(),
                    style: AppTextStyle.xxxLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: AppTextStyle.xLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2.h),
                      Text(
                        user.phone,
                        style: AppTextStyle.small.copyWith(color: AppColors.white70),
                        textDirection: TextDirection.ltr,
                      ),
                      if (user.birthday != null)
                        Text(
                          '${s.birthday}: ${Helper.formatDate(user.birthday!)}',
                          style: AppTextStyle.small.copyWith(color: AppColors.white70),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.all(8.sp),
                  decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Icon(AppIcons.edit, color: AppColors.white, size: 18.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
