/// Which shell the app shows. One install serves every role (spec §2); the
/// signed-in user's business memberships decide which modes are offered.
enum AppMode { customer, owner, staff }

extension AppModeX on AppMode {
  static AppMode fromName(String? name) =>
      AppMode.values.firstWhere((m) => m.name == name, orElse: () => AppMode.customer);
}
