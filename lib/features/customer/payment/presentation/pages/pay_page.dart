import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../shared/presentation/widgets/app_card.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import '../../../../../shared/presentation/widgets/icon_badge.dart';
import '../../../../../shared/presentation/widgets/program_text.dart';
import '../../domain/usecases/payment_usecases.dart';
import '../bloc/payment_bloc.dart';
import '../widgets/apple_pay_button.dart';
import '../../../../../core/styles/app_icons.dart';

/// Pay (C6): business pre-selected, amount input, Apple Pay.
class PayPage extends StatelessWidget {
  final Business business;

  const PayPage({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(
        business: business,
        createPaymentUseCase: sl<CreatePaymentUseCase>(),
        authorizePaymentUseCase: sl<AuthorizePaymentUseCase>(),
        awaitResultUseCase: sl<AwaitPaymentResultUseCase>(),
      ),
      child: _PayView(business: business),
    );
  }
}

class _PayView extends StatefulWidget {
  final Business business;

  const _PayView({required this.business});

  @override
  State<_PayView> createState() => _PayViewState();
}

class _PayViewState extends State<_PayView> {
  final _amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  double? get _value {
    final v = double.tryParse(_amount.text.replaceAll(',', '.'));
    return (v == null || v <= 0) ? null : v;
  }

  void _onState(BuildContext context, PaymentState state) {
    if (state is PaymentIdle && state.error != null) {
      AppSnackBar.showError(context, state.error!);
    } else if (state is PaymentSucceeded) {
      Navigator.of(context).pushReplacementNamed(AppRouteEnum.paymentSuccess.name, arguments: state.transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final business = widget.business;
    final program = business.program;
    final minSpend = program == null ? null : programMinSpend(s, program);
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: _onState,
      builder: (context, state) {
        final busy = state is! PaymentIdle;
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 24.h),
              children: [
                Row(
                  children: [
                    BusinessLogo(logoUrl: business.logoUrl, categoryKey: business.category?.slug, size: 52.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.payButton.toUpperCase(), style: AppTextStyle.eyebrow),
                          Text(business.name, style: AppTextStyle.sectionTitle.copyWith(fontSize: 22.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 36.h),
                Text(s.amountLabel, textAlign: TextAlign.center, style: AppTextStyle.caption),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(defaultCurrency,
                          style: AppTextStyle.sectionTitle.copyWith(color: AppColors.foregroundSubtle)),
                      SizedBox(width: 8.w),
                      IntrinsicWidth(
                        child: TextField(
                          controller: _amount,
                          autofocus: true,
                          enabled: !busy,
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}([.,]\d{0,2})?'))],
                          style: AppTextStyle.display.copyWith(fontSize: 56.sp),
                          cursorColor: AppColors.primary,
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: AppTextStyle.display.copyWith(fontSize: 56.sp, color: AppColors.foregroundFaint),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: false,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    for (final preset in const [25, 50, 100]) ...[
                      Expanded(
                        child: _PresetChip(
                          label: '$preset',
                          selected: _amount.text == '$preset',
                          onTap: busy ? null : () => _amount.text = '$preset',
                        ),
                      ),
                      if (preset != 100) SizedBox(width: 10.w),
                    ],
                  ],
                ),
                if (program != null && program.isActive) ...[
                  SizedBox(height: 28.h),
                  AppCard(
                    color: AppColors.rewardFill,
                    child: Row(
                      children: [
                        IconBadge(icon: AppIcons.ticket, color: AppColors.warningAccent),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(programSummary(s, program), style: AppTextStyle.label),
                              if (minSpend != null) Text(minSpend, style: AppTextStyle.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (state is PaymentProcessing) ...[
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 16.sp, height: 16.sp, child: const CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 10.w),
                      Text(s.processingPayment, style: AppTextStyle.body),
                    ],
                  ),
                ],
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 8.h, 20.w, 12.h),
              child: ApplePayButton(
                label: s.payWithApplePay,
                loading: busy,
                onPressed: _value == null ? null : () => context.read<PaymentBloc>().add(PayPressedEvent(_value!)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _PresetChip({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(16.sp),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.sp),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
          child: Center(
            child: Text(
              '$defaultCurrency $label',
              style: AppTextStyle.label.copyWith(color: selected ? AppColors.white : AppColors.foreground),
            ),
          ),
        ),
      ),
    );
  }
}
