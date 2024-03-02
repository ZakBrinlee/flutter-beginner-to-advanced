import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/comments/models/comment_payload.dart';
import 'package:instantgram_clone_course/state/constants/firebase_collection_name.dart';
import 'package:instantgram_clone_course/state/image_upload/typedefs/is_loading.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/post_id.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/user_id.dart';

class SendCommentStateNotifier extends StateNotifier<IsLoading> {
  SendCommentStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> sendComment({
    required UserId fromUserId,
    required String comment,
    required PostId onPostId,
  }) async {
    isLoading = true;
    final payload = CommentPayload(
      fromUserId: fromUserId,
      comment: comment,
      postId: onPostId,
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .add(payload);

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
