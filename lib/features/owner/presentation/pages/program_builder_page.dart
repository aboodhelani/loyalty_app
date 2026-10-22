import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../../shared/domain/models/loyalty_program.dart';
import '../../../../shared/presentation/widgets/app_button.dart';
import '../../../../shared/presentation/widgets/app_card.dart';
import '../../../../shared/presentation/widgets/program_text.dart';
import '../../../../shared/presentation/widgets/section_header.dart';
import '../../../../shared/presentation/widgets/stamp_progress.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/owner_usecases.dart';
import '../bloc/owner_business_cubit.dart';
import '../widgets/owner_feedback.dart';
import '../../../../core/styles/app_icons.dart';

/// Loyalty program builder (B2): template or custom, live preview,
/// activate / pause.
class ProgramBuilderPage extends StatelessWidget {
  const ProgramBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.programBuilderTitle)),
      body: BlocConsumer<OwnerBusinessCubit, OwnerBusinessState>(
        listener: showOwnerFeedback,
        buildWhen: (a, b) => a.runtimeType != b.runtimeType || (b is OwnerBusinessLoaded && !b.saving),
        builder: (context, state) => switch (state) {
          OwnerBusinessLoaded(:final data) => _ProgramForm(
              key: ValueKey('${data.business.id}-${data.business.program?.version}-${data.business.program?.status}'),
              program: data.business.program,
            ),
          OwnerBusinessError(:final errorMsg) =>
            ErrorView(message: errorMsg, onRetry: () => context.read<OwnerBusinessCubit>().load()),
          _ => const LoadingView(),
        },
      ),
    );
  }
}

class _ProgramForm extends StatefulWidget {
  final LoyaltyProgram? program;

  const _ProgramForm({super.key, required this.program});

  @override
  State<_ProgramForm> createState() => _ProgramFormState();
}

class _ProgramFormState extends State<_ProgramForm> {
  final _formKey = GlobalKey<FormState>();
  late int _stamps = widget.program?.stampsRequired ?? 5;
  late EarnRule _earnRule = widget.program?.earnRule ?? EarnRule.visit;
  late final _minSpend = TextEditingController(text: _fmt(widget.program?.minSpend));
  late final _reward = TextEditingController(text: widget.program?.rewardText ?? '');
  late final _expiry = TextEditingController(text: '${widget.program?.stampExpiryDays ?? 180}');
  late bool _active = widget.program?.isActive ?? true;
  List<ProgramTemplate> _templates = const [];

  static String _fmt(double? v) => v == null ? '' : (v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v');

  @override
  void initState() {
    super.initState();
    _reward.addListener(() => setState(() {}));
    _minSpend.addListener(() => setState(() {}));
    sl<GetProgramTemplatesUseCase>()(NoParams()).then((r) {
      if (mounted) r.fold((_) {}, (list) => setState(() => _templates = list));
    });
  }

  @override
  void dispose() {
    _minSpend.dispose();
    _reward.dispose();
    _expiry.dispose();
    super.dispose();
  }

  void _applyTemplate(ProgramTemplate t) {
    setState(() {
      _stamps = t.stampsRequired;
      _earnRule = t.earnRule;
      _minSpend.text = _fmt(t.minSpend);
      _reward.text = t.rewardText;
      _expiry.text = '${t.stampExpiryDays}';
    });
  }

  LoyaltyProgram _draft() => LoyaltyProgram(
        id: widget.program?.id ?? '',
        stampsRequired: _stamps,
        earnRule: _earnRule,
        minSpend: double.tryParse(_minSpend.text.replaceAll(',', '.')),
        rewardText: _reward.text.trim(),
        terms: widget.program?.terms,
        stampExpiryDays: int.tryParse(_expiry.text) ?? 180,
        status: _active ? ProgramStatus.active : ProgramStatus.paused,
        version: widget.program?.version ?? 1,
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<OwnerBusinessCubit>().saveProgram(_draft());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final saving = context
        .select((OwnerBusinessCubit c) => c.state is OwnerBusinessLoaded && (c.state as OwnerBusinessLoaded).saving);
    final draft = _draft();
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 32.h),
        children: [
          if (widget.program == null) ...[
            Text(s.noProgramYet, style: AppTextStyle.body),
            SizedBox(height: 8.h),
          ],
          if (_templates.isNotEmpty) ...[
            Text(s.templates, style: AppTextStyle.label),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final t in _templates) ActionChip(label: Text(t.label), onPressed: () => _applyTemplate(t))
              ],
            ),
            SizedBox(height: 16.h),
          ],
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.stampsNeeded, style: AppTextStyle.label),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _stamps > 1 ? () => setState(() => _stamps--) : null,
                      icon: const Icon(AppIcons.minus),
                    ),
                    Expanded(child: Text('$_stamps', textAlign: TextAlign.center, style: AppTextStyle.stat)),
                    IconButton.filledTonal(
                      onPressed: _stamps < 50 ? () => setState(() => _stamps++) : null,
                      icon: const Icon(AppIcons.plus),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(s.earnRuleLabel, style: AppTextStyle.label),
                SizedBox(height: 6.h),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<EarnRule>(
                    segments: [
                      ButtonSegment(
                          value: EarnRule.visit, label: Text(s.earnVisit), icon: const Icon(AppIcons.storeFill)),
                      ButtonSegment(
                          value: EarnRule.payment, label: Text(s.earnPayment), icon: const Icon(AppIcons.contactless)),
                    ],
                    selected: {_earnRule},
                    onSelectionChanged: (v) => setState(() => _earnRule = v.first),
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _reward,
                  maxLength: 120,
                  decoration: InputDecoration(labelText: s.rewardLabel, hintText: s.rewardHint),
                  validator: (v) => (v ?? '').trim().isEmpty ? s.rewardRequired : null,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _minSpend,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}([.,]\d{0,2})?'))],
                  decoration: InputDecoration(labelText: s.minSpendLabel, prefixText: '$defaultCurrency '),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _expiry,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: s.expiryLabel),
                  validator: (v) {
                    final days = int.tryParse(v ?? '');
                    return days == null || days < 1 || days > 3650 ? '1 – 3650' : null;
                  },
                ),
              ],
            ),
          ),
          SectionHeader(title: s.previewTitle),
          AppCard(
            color: AppColors.rewardFill,
            borderColor: AppColors.reward.withValues(alpha: 0.35),
            child: Column(
              children: [
                Text(
                  draft.rewardText.isEmpty ? s.programVisit(_stamps, '…') : programSummary(s, draft),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.xLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                if (programMinSpend(s, draft) != null) ...[
                  SizedBox(height: 4.h),
                  Text(programMinSpend(s, draft)!, style: AppTextStyle.caption),
                ],
                SizedBox(height: 14.h),
                StampGrid(filled: (_stamps / 2).floor(), total: _stamps, slotSize: 34.sp),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          AppCard(
            padding: EdgeInsetsDirectional.zero,
            child: SwitchListTile(
              title: Text(s.programActive, style: AppTextStyle.label),
              subtitle: Text(s.programActiveHint, style: AppTextStyle.caption),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
          ),
          SizedBox(height: 12.h),
          Text(s.programVersionNote, style: AppTextStyle.caption),
          SizedBox(height: 20.h),
          AppButton(label: s.saveProgram, loading: saving, onPressed: _save),
        ],
      ),
    );
  }
}
