import 'package:flutter/material.dart';
import 'package:instantgram_clone_course/state/posts/models/post.dart';
import 'package:instantgram_clone_course/views/components/post/post_thumbnail_view.dart';
import 'package:instantgram_clone_course/views/post_details/post_details_view.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsGridView({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts.elementAt(index);
          return PostThumbnailView(
            post: post,
            onTapped: () {
              // Todo: Navigate to the post detail page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PostDetailsView(post: post),
                ),
              );
            },
          );
        });
  }
}
