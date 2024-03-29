import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instantgram_clone_course/state/comments/typedef/comment_id.dart';
import 'package:instantgram_clone_course/state/constants/firebase_field_name.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/post_id.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/user_id.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId userId;
  final PostId postId;

  Comment(Map<String, dynamic> json, {required this.id})
      : comment = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        userId = json[FirebaseFieldName.userId],
        postId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          userId == other.userId &&
          postId == other.postId;

  @override
  int get hashCode => Object.hashAll(
        [
          id,
          comment,
          createdAt,
          userId,
          postId,
        ],
      );
}
