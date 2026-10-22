import 'json_utils.dart';

/// Role a user holds inside one business (spec §3).
enum BusinessRole { owner, staff }

/// A business the user can manage, from `GET /me` → `memberships`.
class BusinessMembership {
  final String businessId;
  final String businessName;
  final String? logoUrl;
  final BusinessRole role;
  final String? branchId;
  final String? branchName;

  const BusinessMembership({
    required this.businessId,
    required this.businessName,
    this.logoUrl,
    required this.role,
    this.branchId,
    this.branchName,
  });

  factory BusinessMembership.fromJson(Json json) {
    final business = readMap(json['business']) ?? const {};
    final branch = readMap(json['branch']);
    return BusinessMembership(
      businessId: readString(business['id']),
      businessName: readString(business['name']),
      logoUrl: business['logoUrl']?.toString(),
      role: readEnum(BusinessRole.values, json['role'], BusinessRole.staff),
      branchId: branch?['id']?.toString(),
      branchName: branch?['name']?.toString(),
    );
  }

  Json toJson() => {
        'business': {'id': businessId, 'name': businessName, 'logoUrl': logoUrl},
        'role': enumWire(role),
        'branch': branchId == null ? null : {'id': branchId, 'name': branchName},
      };
}

class AppUser {
  final String id;
  final String name;
  final String phone;
  final DateTime? birthday;
  final bool notificationsEnabled;
  final String locale;
  final int unreadNotifications;

  /// Businesses this user owns or works at. Empty for a plain customer; the
  /// app only offers business mode when this is not empty.
  final List<BusinessMembership> memberships;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.birthday,
    this.notificationsEnabled = true,
    this.locale = 'en',
    this.unreadNotifications = 0,
    this.memberships = const [],
  });

  String get firstName => name.trim().split(' ').first;

  bool get hasProfile => name.trim().isNotEmpty;

  bool get hasBusinessAccess => memberships.isNotEmpty;

  factory AppUser.fromJson(Json json) => AppUser(
        id: readString(json['id']),
        name: readString(json['name']),
        phone: readString(json['phone']),
        // A date-only value: keep the calendar day, not a timezone-shifted one.
        birthday: DateTime.tryParse(readString(json['birthday']).split('T').first),
        notificationsEnabled: json['notificationsEnabled'] != false,
        locale: readString(json['locale'], 'en'),
        unreadNotifications: readInt(json['unreadNotifications']),
        memberships: readList(json['memberships'], BusinessMembership.fromJson),
      );

  Json toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'birthday': birthday == null ? null : _dateOnly(birthday!),
        'notificationsEnabled': notificationsEnabled,
        'locale': locale,
        'unreadNotifications': unreadNotifications,
        'memberships': memberships.map((m) => m.toJson()).toList(),
      };

  static String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// `PATCH /me` returns the user without memberships; keep the ones we have.
  AppUser mergeProfile(AppUser updated) => AppUser(
        id: id,
        name: updated.name,
        phone: updated.phone,
        birthday: updated.birthday,
        notificationsEnabled: updated.notificationsEnabled,
        locale: updated.locale,
        unreadNotifications: unreadNotifications,
        memberships: updated.memberships.isEmpty ? memberships : updated.memberships,
      );
}
