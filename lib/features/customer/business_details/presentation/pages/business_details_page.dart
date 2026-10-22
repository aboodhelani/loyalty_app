import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../core/utils/location_service.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/presentation/session/auth_gate.dart';
import '../../../../../shared/presentation/widgets/app_button.dart';
import '../../../../../shared/presentation/widgets/app_card.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import '../../../../../shared/presentation/widgets/hours_text.dart';
import '../../../../../shared/presentation/widgets/program_text.dart';
import '../../../../../shared/presentation/widgets/settings_group.dart';
import '../../../../../shared/presentation/widgets/stamp_progress.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../../../explore/domain/usecases/explore_usecases.dart';
import '../bloc/business_details_cubit.dart';
import '../../../../../core/styles/app_icons.dart';

/// Business profile (C5): details, the program in plain words, my progress
/// and the Pay button.
class BusinessDetailsPage extends StatelessWidget {
  final String businessId;

  const BusinessDetailsPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BusinessDetailsCubit(
        businessId: businessId,
        getBusinessUseCase: sl<GetBusinessUseCase>(),
        locationService: sl<LocationService>(),
      )..load(),
      child: BlocBuilder<BusinessDetailsCubit, BusinessDetailsState>(
        builder: (context, state) {
          return Scaffold(
            body: switch (state) {
              BusinessDetailsLoaded(:final business) => _DetailsBody(business: business),
              BusinessDetailsError(:final errorMsg) => SafeArea(
                  child: ErrorView(message: errorMsg, onRetry: () => context.read<BusinessDetailsCubit>().load()),
                ),
              _ => const LoadingView(),
            },
            bottomNavigationBar: state is BusinessDetailsLoaded && (state.business.program?.isActive ?? false)
                ? _PayBar(business: state.business)
                : null,
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final Business business;

  const _DetailsBody({required this.business});

  Future<void> _directions(Branch branch) async {
    final uri = Platform.isIOS
        ? Uri.parse('https://maps.apple.com/?daddr=${branch.lat},${branch.lng}')
        : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${branch.lat},${branch.lng}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final category = business.category;
    final style = CategoryStyle.of(category?.slug);
    final photos = [if (business.coverUrl != null) business.coverUrl!, ...business.photos];
    final branch = business.mainBranch;
    final program = business.program;
    final progress = business.myProgress;
    final meta = [category?.name ?? '', if (business.distanceKm != null) Helper.formatDistance(business.distanceKm)]
        .where((e) => e.isNotEmpty)
        .join(' · ');

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 240.h,
          pinned: true,
          backgroundColor: style.color,
          foregroundColor: AppColors.white,
          leading: Padding(
            padding: EdgeInsetsDirectional.all(8.sp),
            child: CircleAvatar(backgroundColor: AppColors.black40, child: const BackButton(color: AppColors.white)),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: photos.isNotEmpty
                ? PageView(
                    children: [
                      for (final url in photos)
                        CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => ColoredBox(color: style.color),
                          errorWidget: (_, __, ___) => ColoredBox(color: style.color),
                        ),
                    ],
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [style.color, Color.lerp(style.color, AppColors.black, 0.35)!],
                      ),
                    ),
                    child: Center(child: Icon(style.icon, size: 72.sp, color: AppColors.white70)),
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -24.h),
            child: Container(
              height: 28.h,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.sp)),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 24.h),
          sliver: SliverList.list(
            children: [
              // Logo sits fully on the cream sheet, with breathing room below the cover.
              Padding(
                padding: EdgeInsetsDirectional.only(top: 4.h, bottom: 20.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(3.sp),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18.sp),
                        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: BusinessLogo(logoUrl: business.logoUrl, categoryKey: category?.slug, size: 60.sp),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(business.name, style: AppTextStyle.pageTitle),
                          SizedBox(height: 2.h),
                          Text(meta, style: AppTextStyle.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (program != null) ...[
                AppCard(
                  color: AppColors.rewardFill,
                  borderColor: AppColors.reward.withValues(alpha: 0.35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(AppIcons.gift, color: AppColors.reward, size: 22.sp),
                          SizedBox(width: 8.w),
                          Text(s.loyaltyProgram, style: AppTextStyle.label.copyWith(color: AppColors.warningText)),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        program.isActive ? programSummary(s, program) : s.programPaused,
                        style: AppTextStyle.xLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (programMinSpend(s, program) != null) ...[
                        SizedBox(height: 4.h),
                        Text(programMinSpend(s, program)!, style: AppTextStyle.caption),
                      ],
                      SizedBox(height: 14.h),
                      Text(s.yourProgress, style: AppTextStyle.caption),
                      SizedBox(height: 6.h),
                      StampProgressBar(ratio: progress?.ratio ?? 0, ready: progress?.isReady ?? false),
                      SizedBox(height: 6.h),
                      Text(
                        progress == null
                            ? s.noCardYet
                            : progress.isReady
                                ? s.readyToRedeem
                                : s.stampsProgress(progress.stampsCount, progress.stampsRequired),
                        style: AppTextStyle.label,
                      ),
                    ],
                  ),
                ),
              ],
              if (business.description.isNotEmpty) ...[
                SizedBox(height: 24.h),
                Text(s.about, style: AppTextStyle.sectionTitle),
                SizedBox(height: 6.h),
                Text(business.description, style: AppTextStyle.body),
              ],
              SizedBox(height: 20.h),
              Row(
                children: [
                  if (branch != null)
                    Expanded(
                      child: _QuickAction(
                        icon: AppIcons.directions,
                        label: s.directions,
                        onTap: () => _directions(branch),
                      ),
                    ),
                  if (branch != null) SizedBox(width: 10.w),
                  Expanded(
                    child: _QuickAction(
                      icon: AppIcons.phone,
                      label: s.call,
                      onTap: () => launchUrl(Uri(scheme: 'tel', path: business.phone)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              SettingsGroup(
                title: s.info,
                children: [
                  if (branch != null) ...[
                    SettingsTile(
                      icon: AppIcons.clock,
                      iconColor: AppColors.success,
                      title: hoursText(s, branch.openingHours),
                      subtitle: s.openingHours,
                    ),
                    SettingsTile(
                      icon: AppIcons.mapPin,
                      iconColor: AppColors.failedRed,
                      title: branch.name,
                      subtitle: branch.address,
                      onTap: () => _directions(branch),
                    ),
                  ],
                  SettingsTile(
                    icon: AppIcons.phone,
                    iconColor: AppColors.infoText,
                    title: business.phone,
                    subtitle: s.call,
                    onTap: () => launchUrl(Uri(scheme: 'tel', path: business.phone)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24.sp),
          SizedBox(height: 6.h),
          Text(label, style: AppTextStyle.label),
        ],
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  final Business business;

  const _PayBar({required this.business});

  Future<void> _pay(BuildContext context) async {
    if (!await ensureSignedIn(context)) return;
    if (!context.mounted) return;
    Navigator.of(context).pushNamed(AppRouteEnum.pay.name, arguments: business);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 12.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.payHere, style: AppTextStyle.caption),
            SizedBox(height: 8.h),
            AppButton(label: s.payButton, icon: AppIcons.contactless, onPressed: () => _pay(context)),
          ],
        ),
      ),
    );
  }
}
