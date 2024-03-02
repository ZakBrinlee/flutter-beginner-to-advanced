import 'package:instantgram_clone_course/enums/date_sorting.dart';
import 'package:instantgram_clone_course/state/comments/models/comment_model.dart';
import 'package:instantgram_clone_course/state/comments/models/post_comments_request.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocs = toList()
        ..sort(
          (a, b) {
            switch (request.dateSorting) {
              case DateSorting.newestOnTop:
                return b.createdAt.compareTo(a.createdAt);
              case DateSorting.oldestOnTop:
                return a.createdAt.compareTo(b.createdAt);
            }
          },
        );

      return sortedDocs;
    } else {
      return this;
    }
  }
}
