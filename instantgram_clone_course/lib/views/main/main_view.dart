import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram_clone_course/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instantgram_clone_course/state/image_upload/models/file_type.dart';
import 'package:instantgram_clone_course/state/post_settings/providers/post_settings_provider.dart';
import 'package:instantgram_clone_course/views/components/dialogs/alert_dialog_model.dart';
import 'package:instantgram_clone_course/views/components/dialogs/logout_dialog.dart';
import 'package:instantgram_clone_course/views/constants/strings.dart';
import 'package:instantgram_clone_course/views/create_new_post/create_new_post_view.dart';
import 'package:instantgram_clone_course/views/tabs/home/home_view.dart';
import 'package:instantgram_clone_course/views/tabs/search_view/search_view.dart';
import 'package:instantgram_clone_course/views/tabs/user_posts/user_posts_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.appName,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                // Pick a video
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (videoFile == null) {
                  log('No video file selected');
                  return;
                }

                // Reset the postSettingsProvider
                ref.refresh(postSettingProvider);

                // Go to the screen to create a new post
                if (!mounted) {
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      fileToPost: videoFile,
                      fileType: FileType.video,
                    ),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.film,
              ),
            ),
            IconButton(
              onPressed: () async {
                // Pick a image
                final imageFile =
                    await ImagePickerHelper.pickImageFromGallery();
                if (imageFile == null) {
                  log('No imageFile file selected');
                  return;
                }

                // Reset the postSettingsProvider
                ref.refresh(postSettingProvider);

                // Go to the screen to create a new post
                if (!mounted) {
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      fileToPost: imageFile,
                      fileType: FileType.image,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogOut = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);

                if (shouldLogOut) {
                  await ref.read(authStateProvider.notifier).logOut();
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.home),
              )
            ],
          ),
        ),
        body: const TabBarView(children: [
          UserPostsView(),
          SearchView(),
          HomeView(),
        ]),
      ),
    );
  }
}
