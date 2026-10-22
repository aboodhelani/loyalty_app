/// Loyalty Platform API (NestJS). Swagger: [apiBaseUrl]/docs.
/// In development the OTP code `000000` always works.
const String apiBaseUrl = "https://loyalty-api-amkh.onrender.com";

/// Socket.IO lives at the API root; connect with `auth: { token }`.
const String socketUrl = apiBaseUrl;

/// Turns a value that may already be absolute, or may be a path relative to the
/// API host, into a usable URL.
String resolveApiUrl(String pathOrUrl) {
  final value = pathOrUrl.trim();
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  return '$apiBaseUrl${value.startsWith('/') ? '' : '/'}$value';
}

// Auth — phone + OTP (C2)
const String authOtpRequestPath = "/auth/otp/request";
const String authOtpVerifyPath = "/auth/otp/verify";
const String authRefreshPath = "/auth/refresh";
const String authLogoutPath = "/auth/logout";

// Discovery (public, C3–C5)
const String categoriesPath = "/categories";
const String businessesPath = "/businesses";
String businessPath(String id) => "/businesses/$id";
const String programTemplatesPath = "/program-templates";

// Me (customer, C8–C12)
const String mePath = "/me";
const String meQrPath = "/me/qr";
const String meWalletPath = "/me/wallet";
String meCardPath(String id) => "/me/cards/$id";
String meCardRedeemPath(String id) => "/me/cards/$id/redeem";
const String mePaymentsPath = "/me/payments";
const String meVisitsPath = "/me/visits";
const String meNotificationsPath = "/me/notifications";
const String meNotificationsReadPath = "/me/notifications/read";
const String meDevicesPath = "/me/devices";

// Payments (C6–C7). The stamp is created server-side from the gateway webhook.
const String paymentsPath = "/payments";
String paymentPath(String id) => "/payments/$id";
String paymentMockConfirmPath(String id) => "/payments/$id/mock-confirm";

// Staff (S1–S3). Users in several businesses must pass `businessId`.
const String staffScanPath = "/staff/scan";
const String staffStampsPath = "/staff/stamps";
const String staffRedemptionResolvePath = "/staff/redemptions/resolve";
const String staffRedemptionConfirmPath = "/staff/redemptions/confirm";
const String staffPaymentsPath = "/staff/payments";

// Owner (B1–B4)
const String ownerBusinessesPath = "/owner/businesses";
String ownerBusinessPath(String id) => "/owner/businesses/$id";
String ownerBranchPath(String id, String branchId) => "/owner/businesses/$id/branches/$branchId";
String ownerProgramPath(String id) => "/owner/businesses/$id/program";
String ownerProgramStatusPath(String id) => "/owner/businesses/$id/program/status";
String ownerStaffPath(String id) => "/owner/businesses/$id/staff";
String ownerStaffMemberPath(String id, String staffId) => "/owner/businesses/$id/staff/$staffId";
String ownerActivityPath(String id) => "/owner/businesses/$id/activity";
