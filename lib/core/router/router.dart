import 'package:flutter/cupertino.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/customer/business_details/presentation/pages/business_details_page.dart';
import '../../features/customer/payment/presentation/pages/pay_page.dart';
import '../../features/customer/payment/presentation/pages/payment_success_page.dart';
import '../../features/customer/profile/presentation/pages/visit_history_page.dart';
import '../../features/customer/wallet/presentation/pages/card_details_page.dart';
import '../../features/customer/wallet/presentation/pages/redeem_page.dart';
import '../../features/main/presentation/pages/role_shell.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/domain/models/business.dart';
import '../../shared/domain/models/transaction.dart';
import 'app_route_enum.dart';

class AppRouter {
  static String currentRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "/";
    final args = settings.arguments;
    Route<dynamic> page(Widget child, {bool fullscreenDialog = false}) => CupertinoPageRoute(
          settings: RouteSettings(name: settings.name, arguments: args),
          fullscreenDialog: fullscreenDialog,
          builder: (_) => child,
        );

    if (settings.name == AppRouteEnum.splash.name) return page(const SplashPage());
    if (settings.name == AppRouteEnum.onboarding.name) return page(const OnboardingPage());
    if (settings.name == AppRouteEnum.main.name) return page(const RoleShell());
    if (settings.name == AppRouteEnum.signIn.name) return page(const SignInPage(), fullscreenDialog: true);
    if (settings.name == AppRouteEnum.businessDetails.name) {
      return page(BusinessDetailsPage(businessId: args as String));
    }
    if (settings.name == AppRouteEnum.pay.name) return page(PayPage(business: args as Business));
    if (settings.name == AppRouteEnum.paymentSuccess.name) {
      return page(PaymentSuccessPage(transaction: args as PaymentTransaction));
    }
    if (settings.name == AppRouteEnum.cardDetails.name) return page(CardDetailsPage(cardId: args as String));
    if (settings.name == AppRouteEnum.redeem.name) return page(RedeemPage(cardId: args as String));
    if (settings.name == AppRouteEnum.visitHistory.name) return page(const VisitHistoryPage());

    return page(const SplashPage());
  }
}
