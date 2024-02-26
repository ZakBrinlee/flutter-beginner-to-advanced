import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/user_id.dart';

// Smaller providers to cherry pick off the larger provider
final userIdProvider =
    Provider<UserId?>((ref) => ref.watch(authStateProvider).userId);
