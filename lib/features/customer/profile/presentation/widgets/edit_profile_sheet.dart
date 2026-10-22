import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/domain/models/app_user.dart';
import '../../../../../shared/presentation/widgets/app_button.dart';
import '../../../../auth/domain/usecases/auth_usecases.dart';
import '../../../../../core/styles/app_icons.dart';

/// Returns the new name/birthday, or null when dismissed.
Future<UpdateProfileParams?> showEditProfileSheet(BuildContext context, AppUser user) {
  return showModalBottomSheet<UpdateProfileParams>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _EditProfileSheet(user: user),
  );
}

class _EditProfileSheet extends StatefulWidget {
  final AppUser user;

  const _EditProfileSheet({required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final _name = TextEditingController(text: widget.user.name);
  late DateTime? _birthday = widget.user.birthday;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthday = picked);
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
            Text(s.editProfile, style: AppTextStyle.sectionTitle),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: s.nameLabel),
              validator: (v) => (v ?? '').trim().isEmpty ? s.nameRequired : null,
            ),
            SizedBox(height: 12.h),
            InkWell(
              onTap: _pickBirthday,
              child: InputDecorator(
                decoration: InputDecoration(labelText: s.birthdayLabel, suffixIcon: const Icon(AppIcons.cake)),
                child: Text(_birthday == null ? '' : Helper.formatDate(_birthday!), style: AppTextStyle.large),
              ),
            ),
            SizedBox(height: 20.h),
            AppButton(
              label: s.save,
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(UpdateProfileParams(name: _name.text.trim(), birthday: _birthday));
              },
            ),
          ],
        ),
      ),
    );
  }
}
