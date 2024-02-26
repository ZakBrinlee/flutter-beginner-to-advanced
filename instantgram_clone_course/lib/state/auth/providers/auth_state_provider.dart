import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/auth/models/auth_state.dart';
import 'package:instantgram_clone_course/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  // Provider does not have dependecies to the outside app if the `ref` is not used
  (_) => AuthStateNotifier(),
);
