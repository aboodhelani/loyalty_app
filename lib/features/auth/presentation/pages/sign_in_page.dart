import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/helper.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/validators/phone_validator.dart';
import '../../../../shared/presentation/session/session_cubit.dart';
import '../../../../shared/presentation/widgets/app_button.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_hero.dart';
import '../widgets/otp_boxes.dart';
import '../../../../core/styles/app_icons.dart';

/// Phone + OTP sign-in / sign-up (C2). New numbers get the profile step.
/// Pops `true` once the user is signed in.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        requestOtpUseCase: sl<RequestOtpUseCase>(),
        verifyOtpUseCase: sl<VerifyOtpUseCase>(),
        updateProfileUseCase: sl<UpdateProfileUseCase>(),
      ),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (a, b) => b.error != null || a.step != b.step,
      listener: (context, state) {
        if (state.error != null) AppSnackBar.showError(context, state.error!);
        if (state.step == AuthStep.done && state.user != null) {
          context.read<SessionCubit>().signedIn(state.user!);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
        final onCode = state.step == AuthStep.code;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          // Light status bar over the brown hero.
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: AppColors.primary,
            body: Column(
              children: [
                AuthHero(
                  compact: keyboardOpen || state.step != AuthStep.phone,
                  onBack: onCode
                      ? () => context.read<AuthBloc>().add(const AuthChangeNumberRequested())
                      : () => Navigator.of(context).maybePop(),
                  showBackArrow: onCode,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32.sp)),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(begin: const Offset(0.06, 0), end: Offset.zero).animate(animation),
                          child: child,
                        ),
                      ),
                      child: switch (state.step) {
                        AuthStep.phone => const _PhoneStep(key: ValueKey('phone')),
                        AuthStep.code => _CodeStep(key: const ValueKey('code'), state: state),
                        AuthStep.profile || AuthStep.done => const _ProfileStep(key: ValueKey('profile')),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shared layout of each step: progress, title, subtitle, then content.
class _StepBody extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? footer;

  const _StepBody(
      {required this.step, required this.title, required this.subtitle, required this.children, this.footer});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 28.h, 24.w, MediaQuery.paddingOf(context).bottom + 24.h),
      children: [
        Row(
          children: [
            for (var i = 1; i <= 3; i++) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: i == step ? 24.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: i <= step ? AppColors.primary : AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
              ),
              SizedBox(width: 6.w),
            ],
            const Spacer(),
            Text(s.stepOf(step, 3), style: AppTextStyle.caption),
          ],
        ),
        SizedBox(height: 20.h),
        Text(title, style: AppTextStyle.pageTitle.copyWith(fontSize: 26.sp)),
        SizedBox(height: 8.h),
        Text(subtitle, style: AppTextStyle.body),
        SizedBox(height: 28.h),
        ...children,
        if (footer != null) ...[SizedBox(height: 24.h), footer!],
      ],
    );
  }
}

/// White field shell with a soft shadow, shared by the step inputs.
class _FieldShell extends StatelessWidget {
  final Widget child;
  final bool error;

  const _FieldShell({required this.child, this.error = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18.sp),
        border: Border.all(color: error ? AppColors.failedRed : Colors.transparent, width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: child,
    );
  }
}

const _bareInput = InputDecoration(
  border: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
  filled: false,
  isDense: true,
);

class _PhoneStep extends StatefulWidget {
  const _PhoneStep({super.key});

  @override
  State<_PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<_PhoneStep> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final s = S.of(context);
    if (!PhoneValidator.isValid(_controller.text)) {
      setState(() => _error = s.phoneInvalid);
      return;
    }
    setState(() => _error = null);
    context.read<AuthBloc>().add(AuthPhoneSubmitted(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final loading = context.select((AuthBloc b) => b.state.loading);
    return _StepBody(
      step: 1,
      title: s.signInTitle,
      subtitle: s.signInSubtitle,
      footer: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(AppIcons.lock, size: 14.sp, color: AppColors.foregroundSubtle),
              SizedBox(width: 6.w),
              Flexible(child: Text(s.privacyNote, textAlign: TextAlign.center, style: AppTextStyle.caption)),
            ],
          ),
          SizedBox(height: 6.h),
          Text(s.smsNote,
              textAlign: TextAlign.center, style: AppTextStyle.caption.copyWith(color: AppColors.foregroundFaint)),
        ],
      ),
      children: [
        // Phone numbers stay left-to-right in every layout direction.
        Directionality(
          textDirection: TextDirection.ltr,
          child: _FieldShell(
            error: _error != null,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.all(8.sp),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(color: AppColors.brandCream, borderRadius: BorderRadius.circular(12.sp)),
                  child: Text('🇦🇪  +971', style: AppTextStyle.label),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                    style: AppTextStyle.xLarge.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    cursorColor: AppColors.primary,
                    decoration: _bareInput.copyWith(
                      hintText: '50 123 4567',
                      hintStyle: AppTextStyle.xLarge.copyWith(color: AppColors.foregroundFaint),
                      contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 6.w, vertical: 18.h),
                    ),
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    onSubmitted: (_) => _submit(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 8.w, top: 8.h),
            child: Text(_error!, style: AppTextStyle.small.copyWith(color: AppColors.failedRed)),
          ),
        SizedBox(height: 20.h),
        AppButton(label: s.continueLabel, loading: loading, onPressed: _submit),
        SizedBox(height: 24.h),
        const _Perks(),
      ],
    );
  }
}

/// Three small reasons to sign up, under the phone step.
class _Perks extends StatelessWidget {
  const _Perks();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final perks = [
      (AppIcons.password, s.perkNoPassword),
      (AppIcons.gift, s.perkRewards),
      (AppIcons.heart, s.perkFree),
    ];
    return Row(
      children: [
        for (final (icon, label) in perks)
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsDirectional.all(10.sp),
                  decoration: BoxDecoration(color: AppColors.surfaceElevated, shape: BoxShape.circle),
                  child: Icon(icon, size: 18.sp, color: AppColors.primary),
                ),
                SizedBox(height: 6.h),
                Text(label,
                    textAlign: TextAlign.center, style: AppTextStyle.small.copyWith(color: AppColors.foregroundMuted)),
              ],
            ),
          ),
      ],
    );
  }
}

class _CodeStep extends StatefulWidget {
  final AuthState state;

  const _CodeStep({super.key, required this.state});

  @override
  State<_CodeStep> createState() => _CodeStepState();
}

class _CodeStepState extends State<_CodeStep> {
  String _code = '';

  void _onChanged(String value) {
    // Submit as soon as the sixth digit lands — fewer taps for the 30s target.
    if (value.length == 6) context.read<AuthBloc>().add(AuthCodeSubmitted(value));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final state = widget.state;
    final bloc = context.read<AuthBloc>();
    return _StepBody(
      step: 2,
      title: s.codeTitle,
      subtitle: s.codeSubtitleShort,
      children: [
        // Number being verified, with a quick way to fix a typo.
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(14.w, 6.h, 6.w, 6.h),
          decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(14.sp)),
          child: Row(
            children: [
              Icon(AppIcons.mobile, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(state.phone, textDirection: TextDirection.ltr, style: AppTextStyle.label),
              ),
              TextButton(onPressed: () => bloc.add(const AuthChangeNumberRequested()), child: Text(s.editNumber)),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        OtpBoxes(onChanged: (v) {
          _code = v;
          _onChanged(v);
        }),
        SizedBox(height: 24.h),
        AppButton(label: s.continueLabel, loading: state.loading, onPressed: () => _onChanged(_code)),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.didNotGetCode, style: AppTextStyle.caption),
            state.resendIn > 0
                ? Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.w),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration:
                          BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(20.sp)),
                      child: Text(s.resendIn(state.resendIn),
                          style: AppTextStyle.small.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  )
                : TextButton(onPressed: () => bloc.add(const AuthResendRequested()), child: Text(s.resendCode)),
          ],
        ),
      ],
    );
  }
}

class _ProfileStep extends StatefulWidget {
  const _ProfileStep({super.key});

  @override
  State<_ProfileStep> createState() => _ProfileStepState();
}

class _ProfileStepState extends State<_ProfileStep> {
  final _name = TextEditingController();
  DateTime? _birthday;
  String? _error;

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

  void _submit() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = S.of(context).nameRequired);
      return;
    }
    context.read<AuthBloc>().add(AuthProfileSubmitted(_name.text.trim(), _birthday));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final loading = context.select((AuthBloc b) => b.state.loading);
    return _StepBody(
      step: 3,
      title: s.profileTitle,
      subtitle: s.profileSubtitle,
      children: [
        _FieldShell(
          error: _error != null,
          child: TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            style: AppTextStyle.large.copyWith(fontWeight: FontWeight.w600),
            cursorColor: AppColors.primary,
            decoration: _bareInput.copyWith(
              hintText: s.nameLabel,
              hintStyle: AppTextStyle.large.copyWith(color: AppColors.foregroundFaint),
              prefixIcon: Icon(AppIcons.user, color: AppColors.primary, size: 22.sp),
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 18.h),
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
        ),
        if (_error != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 8.w, top: 8.h),
            child: Text(_error!, style: AppTextStyle.small.copyWith(color: AppColors.failedRed)),
          ),
        SizedBox(height: 12.h),
        _FieldShell(
          child: InkWell(
            onTap: _pickBirthday,
            borderRadius: BorderRadius.circular(18.sp),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 16.h),
              child: Row(
                children: [
                  Icon(AppIcons.cake, color: AppColors.reward, size: 22.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _birthday == null ? s.birthdayPick : Helper.formatDate(_birthday!),
                          style: AppTextStyle.large.copyWith(
                            fontWeight: _birthday == null ? FontWeight.w400 : FontWeight.w600,
                            color: _birthday == null ? AppColors.foregroundFaint : AppColors.foreground,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(s.birthdayHint, style: AppTextStyle.caption),
                      ],
                    ),
                  ),
                  Icon(AppIcons.chevron, color: AppColors.foregroundFaint, size: 22.sp),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 28.h),
        AppButton(label: s.done, loading: loading, onPressed: _submit),
        SizedBox(height: 12.h),
        Center(child: Text(appName, style: AppTextStyle.caption.copyWith(color: AppColors.foregroundFaint))),
      ],
    );
  }
}
