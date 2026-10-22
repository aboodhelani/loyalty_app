import '../../../../shared/domain/models/business.dart';
import '../../../../shared/domain/models/json_utils.dart';
import '../../../../shared/domain/models/staff_member.dart';

/// `GET /owner/businesses/:id` — the full profile with program and staff (B1).
class OwnerBusiness {
  final Business business;
  final List<StaffMember> staff;

  const OwnerBusiness({required this.business, required this.staff});

  factory OwnerBusiness.fromJson(Json json) => OwnerBusiness(
        business: Business.fromJson(json),
        staff: readList(json['staff'], StaffMember.fromJson).where((s) => s.active).toList(),
      );
}

/// Editable profile fields (B1).
class BusinessProfileUpdate {
  final String name;
  final String? categoryId;
  final String description;
  final String phone;

  /// Main branch address; edited through the branch endpoint.
  final String? branchId;
  final String? address;

  const BusinessProfileUpdate({
    required this.name,
    this.categoryId,
    required this.description,
    required this.phone,
    this.branchId,
    this.address,
  });
}
