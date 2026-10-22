# Loyalty app

One Flutter app for the loyalty platform MVP. The signed-in user's business memberships decide which shell shows:

- **Customer** (default, works signed out): Explore (map + list) · Wallet · Scan (My QR) · Profile
- **Owner**: Activity · Program · Staff · Business · Account
- **Staff**: Stamp scanner · Redeem · Live payments · Account

Users switch mode from Profile/Account. Owners of several businesses pick one.

## Architecture (same as Zox)

```
lib/
  core/       network (Dio ApiClient, token refresh, Socket.IO), router, styles (design tokens), utils, DI
  shared/     domain models, session (SessionCubit + AuthGate), design-system widgets
  features/
    auth/                      phone + OTP (C2)
    customer/{explore, business_details, payment, wallet, profile}
    owner/                     B1–B4
    staff/                     S1–S3
    main/                      role shells
    onboarding/, splash/
```

Each feature has `data` (Api + RepoImpl) → `domain` (Repo, UseCases) → `presentation` (Bloc/Cubit, pages, widgets), plus a `*_injections.dart` file registered in `core/utils/injections.dart`.

## Backend

`https://loyalty-api-amkh.onrender.com` (Swagger at `/docs`), set in `lib/core/utils/constant/network_constant.dart`.

- Auth: phone OTP → access token (15 min) + single-use refresh token. `DioNetwork` refreshes on 401 and replays the request.
- Payments: `POST /payments` returns a Stripe test intent, which the app presents with Apple Pay (`flutter_stripe`). The stamp is issued server-side from the webhook, and the app polls `GET /payments/:id`.
- Realtime: Socket.IO events (`payment.succeeded`, `stamp.added`, …) refresh the wallet, live payments and owner activity.

Demo accounts (dev OTP `000000`): owner `050 000 0001`, staff `050 000 0002` (Fade Masters) / `050 000 0003` (Brew Lab), customer `050 000 0010`.

## Run

```bash
flutter pub get
dart run intl_utils:generate   # after editing lib/core/translations/l10n/*.arb
flutter run
```

To add strings: `python3 tool/add_strings.py '{"key": "Text"}'`, then regenerate.

Xcode 27 note: the simulator build is pinned to arm64 (`ARCHS[sdk=iphonesimulator*] = arm64`) because Xcode 27's `lipo -verify_arch` breaks Flutter's universal-simulator check.

## Brand

Cream `#F2EDD7` (backgrounds, soft fills) and brown `#755139` (actions, accents), with earthy status colours. Tokens are in `lib/core/styles/app_colors.dart`; titles and numbers use Plus Jakarta Sans and body text uses Inter. Shared components: `AppCard`, `AppButton`, `AppNavBar`, `PageHeader`, `SettingsGroup`/`SettingsTile`, `IconBadge`, `showConfirmDialog`/`showInputDialog` and `AppSnackBar`.

## Before TestFlight

- Register the Apple Pay merchant ID that the API returns (`merchant.com.example.loyalty` now) and add its certificate in Stripe. Replace the placeholder bundle ID `com.loyaltyapp.loyaltyApp`.
- Google Maps key: iOS `Info.plist` → `GMSApiKey`, Android `AndroidManifest.xml` meta-data. Restrict it in Google Cloud to the iOS bundle ID / Android package + SHA-1 before release.
- Push notifications (FCM → `POST /me/devices`), logo/photo upload (`/uploads`) and a map-pin picker for B1 are not wired yet.
- Language: English only for now. Layouts use directional padding, so Arabic can be added later with an `intl_ar.arb` and `supportedLocales` in `main.dart`.
