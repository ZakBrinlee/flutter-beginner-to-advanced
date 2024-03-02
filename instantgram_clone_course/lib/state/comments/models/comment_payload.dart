import 'dart:collection' show MapView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instantgram_clone_course/state/constants/firebase_field_name.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/post_id.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/user_id.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required UserId fromUserId,
    required String comment,
    required PostId postId,
  }) : super({
          FirebaseFieldName.userId: fromUserId,
          FirebaseFieldName.comment: comment,
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        });
}
