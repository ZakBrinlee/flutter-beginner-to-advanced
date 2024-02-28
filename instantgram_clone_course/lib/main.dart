import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone_course/state/auth/models/auth_result.dart';
import 'package:instantgram_clone_course/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram_clone_course/state/providers/is_loading_provider.dart';
import 'package:instantgram_clone_course/views/components/loading/loading_screen.dart';
import 'package:instantgram_clone_course/views/login/login_view.dart';
import 'package:instantgram_clone_course/views/main/main_view.dart';
import 'firebase_options.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey,
        ),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Consumer(builder: (context, ref, child) {
          // ref.listen() for actions that don't rebuild widgets
          ref.listen<bool>(
            isLoadingProvider,
            (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                );
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );
          // ref.watch() for rebuilding widgets based on new value changes
          final isLoggedIn =
              ref.watch(authStateProvider).result == AuthResult.success;
          return isLoggedIn ? const MainView() : const LoginView();
        }));
  }
}
