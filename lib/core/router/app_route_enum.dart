enum AppRouteEnum {
  splash,
  onboarding,
  main,
  signIn,
  businessDetails,
  pay,
  paymentSuccess,
  cardDetails,
  redeem,
  visitHistory,
}

extension AppRouteExtension on AppRouteEnum {
  String get name {
    switch (this) {
      case AppRouteEnum.splash:
        return "/splash";
      case AppRouteEnum.onboarding:
        return "/onboarding";
      case AppRouteEnum.main:
        return "/main";
      case AppRouteEnum.signIn:
        return "/sign-in";
      case AppRouteEnum.businessDetails:
        return "/business";
      case AppRouteEnum.pay:
        return "/pay";
      case AppRouteEnum.paymentSuccess:
        return "/payment-success";
      case AppRouteEnum.cardDetails:
        return "/card";
      case AppRouteEnum.redeem:
        return "/redeem";
      case AppRouteEnum.visitHistory:
        return "/visit-history";
    }
  }
}
