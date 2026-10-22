import 'json_utils.dart';
import 'stamp_card.dart';

class StaffMember {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final BranchRef? branch;
  final bool active;

  const StaffMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.branch,
    required this.active,
  });

  factory StaffMember.fromJson(Json json) {
    final user = readMap(json['user']);
    return StaffMember(
      id: readString(json['id']),
      userId: readString(json['userId'], readString(user?['id'])),
      name: readString(user?['name'], readString(json['name'])),
      phone: readString(user?['phone'], readString(json['phone'])),
      branch: BranchRef.fromJson(json['branch']),
      active: json['active'] != false,
    );
  }
}
