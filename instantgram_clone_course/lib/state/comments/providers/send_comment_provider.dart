import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/comments/notifiers/send_comment_notifier.dart';
import 'package:instantgram_clone_course/state/image_upload/typedefs/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentStateNotifier, IsLoading>(
  (_) => SendCommentStateNotifier(),
);
