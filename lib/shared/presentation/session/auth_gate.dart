import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_route_enum.dart';
import 'session_cubit.dart';

/// Sign-up is asked for on the first Pay or Scan, not on app open (C2).
/// Returns true when the user is (now) signed in.
Future<bool> ensureSignedIn(BuildContext context) async {
  if (context.read<SessionCubit>().state.isSignedIn) return true;
  final result = await Navigator.of(context).pushNamed(AppRouteEnum.signIn.name);
  return result == true;
}
