import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/validators/phone_validator.dart';
import '../../../../shared/domain/models/staff_member.dart';
import '../../../../shared/presentation/widgets/app_button.dart';
import '../../../../shared/presentation/widgets/app_card.dart';
import '../../../../shared/presentation/widgets/app_dialog.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../bloc/owner_business_cubit.dart';
import '../widgets/owner_feedback.dart';
import '../../../../core/styles/app_icons.dart';

/// Staff (B3): add by name + phone, remove.
class OwnerStaffPage extends StatelessWidget {
  const OwnerStaffPage({super.key});

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<OwnerBusinessCubit>();
    final result = await showModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddStaffSheet(),
    );
    if (result != null) await cubit.addStaff(name: result.$1, phone: result.$2);
  }

  Future<void> _remove(BuildContext context, StaffMember member) async {
    final s = S.of(context);
    final cubit = context.read<OwnerBusinessCubit>();
    final ok = await showConfirmDialog(
      context,
      icon: AppIcons.userMinus,
      title: s.removeStaff,
      message: s.removeStaffConfirm(member.name),
      confirmLabel: s.removeStaff,
      destructive: true,
    );
    if (ok) await cubit.removeStaff(member.id);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.staffTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context),
        icon: const Icon(AppIcons.userPlus),
        label: Text(s.addStaff),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: BlocConsumer<OwnerBusinessCubit, OwnerBusinessState>(
        listener: showOwnerFeedback,
        builder: (context, state) {
          if (state is OwnerBusinessError) {
            return ErrorView(message: state.errorMsg, onRetry: () => context.read<OwnerBusinessCubit>().load());
          }
          if (state is! OwnerBusinessLoaded) return const LoadingView();
          final staff = state.data.staff;
          if (staff.isEmpty) {
            return EmptyView(icon: AppIcons.teamFill, title: s.staffEmpty, message: s.staffEmptyMessage);
          }
          return ListView.separated(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 96.h),
            itemCount: staff.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, i) {
              final m = staff[i];
              return AppCard(
                padding: EdgeInsetsDirectional.zero,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primarySoft,
                    child: Text(
                      m.name.isEmpty ? '?' : m.name[0].toUpperCase(),
                      style: AppTextStyle.label.copyWith(color: AppColors.primary),
                    ),
                  ),
                  title: Text(m.name, style: AppTextStyle.label),
                  subtitle: Text(
                    [m.phone, if (m.branch != null) m.branch!.name].join(' · '),
                    style: AppTextStyle.caption,
                  ),
                  trailing: IconButton(
                    icon: const Icon(AppIcons.trash, color: AppColors.destructiveIcon),
                    tooltip: s.removeStaff,
                    onPressed: state.saving ? null : () => _remove(context, m),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddStaffSheet extends StatefulWidget {
  const _AddStaffSheet();

  @override
  State<_AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<_AddStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, MediaQuery.viewInsetsOf(context).bottom + 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.addStaff, style: AppTextStyle.sectionTitle),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: s.nameLabel),
              validator: (v) => (v ?? '').trim().isEmpty ? s.nameRequired : null,
            ),
            SizedBox(height: 12.h),
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                decoration: InputDecoration(labelText: s.phoneLabel, hintText: '050 123 4567'),
                validator: (v) => PhoneValidator.isValid(v ?? '') ? null : s.phoneInvalid,
              ),
            ),
            SizedBox(height: 20.h),
            AppButton(
              label: s.addStaff,
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop((_name.text.trim(), PhoneValidator.normalize(_phone.text)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
