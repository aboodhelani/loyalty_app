import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/models/app_user.dart';
import '../../../../auth/domain/usecases/auth_usecases.dart';

class ProfileState {
  final bool saving;

  /// One-shot outcome for the page: an error message, or [saved].
  final String? error;
  final bool saved;

  const ProfileState({this.saving = false, this.error, this.saved = false});
}

/// Profile edits (C12). The updated user goes back to the session through
/// [onUserUpdated], so every screen sees the change.
class ProfileCubit extends Cubit<ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final void Function(AppUser user) onUserUpdated;

  ProfileCubit({required this.updateProfileUseCase, required this.onUserUpdated}) : super(const ProfileState());

  Future<void> update(UpdateProfileParams params, {bool announce = false}) async {
    emit(const ProfileState(saving: true));
    final result = await updateProfileUseCase(params);
    if (isClosed) return;
    result.fold(
      (l) => emit(ProfileState(error: l.errorMessage)),
      (user) {
        onUserUpdated(user);
        emit(ProfileState(saved: announce));
      },
    );
  }
}
