import '../../../../../core/network/api_client.dart';
import '../../../../../core/utils/constant/network_constant.dart';
import '../../../../../shared/domain/models/activity_summary.dart';
import '../../../../../shared/domain/models/loyalty_program.dart';
import '../../../../../shared/domain/models/staff_member.dart';
import '../../../domain/models/owner_business.dart';

/// Business app, owner side (B1–B4).
class OwnerApi {
  final ApiClient _client;

  OwnerApi(this._client);

  Future<OwnerBusiness> business(String id) async {
    final json = await _client.get(ownerBusinessPath(id));
    return OwnerBusiness.fromJson(json);
  }

  Future<void> updateProfile(String id, BusinessProfileUpdate update) async {
    await _client.patch(ownerBusinessPath(id), data: {
      'name': update.name,
      if (update.categoryId != null) 'categoryId': update.categoryId,
      'description': update.description,
      'phone': update.phone,
    });
    if (update.branchId != null && update.address != null) {
      await _client.patch(ownerBranchPath(id, update.branchId!), data: {'address': update.address});
    }
  }

  Future<List<ProgramTemplate>> templates() async {
    final list = await _client.getList(programTemplatesPath);
    return list.whereType<Map>().map((e) => ProgramTemplate.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// Changing target or reward bumps `version`; existing cards keep theirs.
  Future<LoyaltyProgram> saveProgram(String id, LoyaltyProgram program) async {
    final json = await _client.put(ownerProgramPath(id), data: program.toRequest());
    return LoyaltyProgram.fromJson(json);
  }

  Future<void> setProgramStatus(String id, ProgramStatus status) async {
    await _client
        .patch(ownerProgramStatusPath(id), data: {'status': status == ProgramStatus.active ? 'ACTIVE' : 'PAUSED'});
  }

  Future<List<StaffMember>> staff(String id) async {
    final list = await _client.getList(ownerStaffPath(id));
    return list.whereType<Map>().map((e) => StaffMember.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// They sign in with OTP on that phone and get staff mode.
  Future<void> addStaff(String id, {required String name, required String phone, String? branchId}) async {
    await _client.post(ownerStaffPath(id), data: {
      'name': name,
      'phone': phone,
      if (branchId != null) 'branchId': branchId,
    });
  }

  Future<void> removeStaff(String id, String staffId) async {
    await _client.delete(ownerStaffMemberPath(id, staffId));
  }

  Future<ActivitySummary> activity(String id, ActivityRange range) async {
    final json = await _client.get(ownerActivityPath(id), queryParameters: {'range': range.wire});
    return ActivitySummary.fromJson(json);
  }
}
