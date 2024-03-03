import 'package:flutter/material.dart';
import 'package:instantgram_clone_course/state/comments/models/comment_model.dart';
import 'package:instantgram_clone_course/views/components/comments/compact_comment_tile.dart';

class CompactCommentColumn extends StatelessWidget {
  final Iterable<Comment> comments;
  const CompactCommentColumn({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .map(
              (comment) => CompactCommentTile(
                comment: comment,
              ),
            )
            .toList(),
      ),
    );
  }
}
