import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/auth/providers/user_id_provider.dart';
import 'package:instantgram_clone_course/state/comments/models/comment_model.dart';
import 'package:instantgram_clone_course/state/comments/providers/delete_comment_provider.dart';
import 'package:instantgram_clone_course/state/user_info/providers/user_info_model_provider.dart';
import 'package:instantgram_clone_course/views/components/animations/small_error_animation_view.dart';
import 'package:instantgram_clone_course/views/components/constants/strings.dart';
import 'package:instantgram_clone_course/views/components/dialogs/alert_dialog_model.dart';
import 'package:instantgram_clone_course/views/components/dialogs/delete_dialog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;

  const CommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoModelProvider(comment.userId));

    return userInfo.when(data: (userInfoModel) {
      final currentUserId = ref.read(userIdProvider);
      return ListTile(
        title: Text(userInfoModel.displayName),
        subtitle: Text(comment.comment),
        trailing: currentUserId == comment.userId
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final shouldDeleteComment =
                      await displayDeleteDialog(context);

                  if (shouldDeleteComment) {
                    await ref
                        .read(deleteCommentProvider.notifier)
                        .deleteComment(
                          commentId: comment.id,
                        );
                  }
                },
              )
            : null,
      );
    }, error: (error, stacktrace) {
      return const SmallErrorAnimationView();
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Future<bool> displayDeleteDialog(BuildContext context) => const DeleteDialog(
        titleOfObjectToDelete: Strings.comment,
      ).present(context).then(
            (value) => value ?? false,
          );
}
