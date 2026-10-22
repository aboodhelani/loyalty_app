import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../../shared/domain/models/business.dart';
import '../../../../shared/domain/models/category.dart';
import '../../../../shared/presentation/widgets/app_button.dart';
import '../../../../shared/presentation/widgets/category_style.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../../../customer/explore/domain/usecases/explore_usecases.dart';
import '../../domain/models/owner_business.dart';
import '../bloc/owner_business_cubit.dart';
import '../widgets/owner_feedback.dart';

/// Business profile (B1). Logo/photos upload and the map pin come with the
/// `/uploads` endpoint and a map picker; text fields are editable now.
class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.businessProfileTitle)),
      body: BlocConsumer<OwnerBusinessCubit, OwnerBusinessState>(
        listener: showOwnerFeedback,
        buildWhen: (a, b) => a.runtimeType != b.runtimeType || (b is OwnerBusinessLoaded && !b.saving),
        builder: (context, state) => switch (state) {
          OwnerBusinessLoaded(:final data) => _ProfileForm(key: ValueKey(data.business.id), business: data.business),
          OwnerBusinessError(:final errorMsg) =>
            ErrorView(message: errorMsg, onRetry: () => context.read<OwnerBusinessCubit>().load()),
          _ => const LoadingView(),
        },
      ),
    );
  }
}

class _ProfileForm extends StatefulWidget {
  final Business business;

  const _ProfileForm({super.key, required this.business});

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.business.name);
  late final _description = TextEditingController(text: widget.business.description);
  late final _phone = TextEditingController(text: widget.business.phone);
  late final _address = TextEditingController(text: widget.business.mainBranch?.address ?? '');
  late String? _categoryId = widget.business.categoryId;
  List<Category> _categories = const [];

  @override
  void initState() {
    super.initState();
    sl<GetCategoriesUseCase>()(NoParams()).then((r) {
      if (mounted) r.fold((_) {}, (list) => setState(() => _categories = list));
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final branch = widget.business.mainBranch;
    await context.read<OwnerBusinessCubit>().updateProfile(BusinessProfileUpdate(
          name: _name.text.trim(),
          categoryId: _categoryId,
          description: _description.text.trim(),
          phone: _phone.text.trim(),
          branchId: branch?.id,
          address: branch == null || _address.text.trim() == branch.address ? null : _address.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final saving = context
        .select((OwnerBusinessCubit c) => c.state is OwnerBusinessLoaded && (c.state as OwnerBusinessLoaded).saving);
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 32.h),
        children: [
          Center(
            child: BusinessLogo(
              logoUrl: widget.business.logoUrl,
              categoryKey: widget.business.category?.slug,
              size: 84.sp,
            ),
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: _name,
            maxLength: 120,
            decoration: InputDecoration(labelText: s.businessName),
            validator: (v) => (v ?? '').trim().isEmpty ? s.nameRequired : null,
          ),
          SizedBox(height: 4.h),
          DropdownButtonFormField<String>(
            initialValue: _categories.any((c) => c.id == _categoryId) ? _categoryId : null,
            decoration: InputDecoration(labelText: s.category),
            items: [for (final c in _categories) DropdownMenuItem(value: c.id, child: Text(c.name))],
            onChanged: (v) => setState(() => _categoryId = v),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _description,
            maxLines: 4,
            maxLength: 2000,
            decoration: InputDecoration(labelText: s.description, alignLabelWithHint: true),
          ),
          SizedBox(height: 4.h),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: s.phone),
            ),
          ),
          if (widget.business.mainBranch != null) ...[
            SizedBox(height: 12.h),
            TextFormField(
              controller: _address,
              maxLines: 2,
              decoration: InputDecoration(labelText: s.address, alignLabelWithHint: true),
            ),
          ],
          SizedBox(height: 24.h),
          AppButton(label: s.save, loading: saving, onPressed: _save),
        ],
      ),
    );
  }
}
