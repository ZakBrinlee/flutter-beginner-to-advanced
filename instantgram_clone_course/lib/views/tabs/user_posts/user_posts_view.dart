import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/main.dart';
import 'package:instantgram_clone_course/state/posts/providers/user_posts_provider.dart';
import 'package:instantgram_clone_course/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instantgram_clone_course/views/components/animations/error_animation_view.dart';
import 'package:instantgram_clone_course/views/components/animations/loading_animation_view.dart';
import 'package:instantgram_clone_course/views/components/post/posts_gridview.dart';
import 'package:instantgram_clone_course/views/constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        final refreshResult = ref.refresh(userPostsProvider);
        return Future.delayed(
          const Duration(seconds: 1),
        ).whenComplete(() => refreshResult.log());
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            return PostsGridView(posts: posts);
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
