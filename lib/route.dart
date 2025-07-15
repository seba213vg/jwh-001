import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/common/main_navigation.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/view/screens/athentication/log_in.dart';
import 'package:jwh_01/view/screens/athentication/sign_up.dart';

final myRouterProvider = Provider((ref) {
  // ref.watch(authStreamState);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedin = ref.read(authRepoProvider).isLoggedIn;
      if (!isLoggedin) {
        if (state.fullPath != '/SignUpScreen' &&
            state.fullPath != '/LogInScreen') {
          return '/SignUpScreen';
        }
      }
      return null;
    },
    routes: [
      // GoRoute(
      //   name: LoginScreen.routeName,
      //   path: LoginScreen.routeUrl,
      //   builder: (context, state) => LoginScreen(),
      // ),

      // GoRoute(
      //   name: 'emailscreen',
      //   path: '/emailscreen/:username',
      //   builder: (context, state) {
      //     final username = state.params['username'];
      //     return EmailScreen(username: username!);
      //   },
      // ),
      // GoRoute(
      //   name: 'tutorial',
      //   path: '/interestsscreen',
      //   builder: (context, state) {
      //     return PopScope(canPop: false, child: InterestsScreen());
      //   },
      // ),
      GoRoute(
        path: '/:tap(home|travel|voca|contents|profile)',

        builder: (context, state) {
          final tab = state.pathParameters['tap']!;
          return MainNavigationScreen(currentTab: tab);
        },
      ),

      GoRoute(path: '/LogInScreen', builder: (context, state) => LogInScreen()),
      GoRoute(
        path: '/SignUpScreen',
        builder: (context, state) => SignUpScreen(),
      ),

      // GoRoute(
      //   name: ChatsScreen.routeName,
      //   path: ChatsScreen.routeUrl,

      //   builder: (context, state) => ChatsScreen(),
      //   routes: [
      //     GoRoute(
      //       name: ChatDetailScreen.routeName,
      //       path: ChatDetailScreen.routeUrl,

      //       builder: (context, state) {
      //         final chatId = state.params['chatId'];
      //         return ChatDetailScreen(chatId: chatId!);
      //       },
      //     ),
      //   ],
      // ),
    ],
  );
});
