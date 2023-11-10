import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/errors/not_yet_implemented.dart';
import 'package:read_with_meaning/public/common_widgets/transitions.dart';
import 'package:read_with_meaning/public/features/experience/plan/overview/presentation/overview_screen.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';
import 'package:read_with_meaning/public/features/experience/plan/sources%20(where)/where_screen.dart';
import 'package:read_with_meaning/public/features/experience/plan/stream_file%20(which)/presentation/which_screen.dart';
import 'package:read_with_meaning/public/features/experience/plan/view_all%20(what)/presentation/what_screen.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/inbox_zero.dart/presentation/inbox_zero_screen.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/presentation/single_screen.dart';
import 'package:read_with_meaning/public/features/experience/plan/sort%20(when)/presentation/when_screen.dart';
import 'package:realm/realm.dart';

import '../common_widgets/errors/404_screen.dart';
import '../features/boot_up/login/presentation/login_screen.dart';
import '../features/boot_up/splash_screen.dart';

enum AppRoute {
  home,
  login,
  register,
  now,
  exp,
  stream,
  lakes,
  sources,
  all,
  overview,
  four04,
  debugDB,
  settings,
  commands,
  search,
  done,
  spile,
}

// ? might cause issues with autoDispose
// TODO change Riverpod Annotation
final goRouterProvider = Provider.autoDispose<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // checks if the user is logged in, if not, redirect, if yes, prevent the login screen
      User? currentUser = ref.watch(userProvider);
      if (currentUser != null) {
        state.location == '/login' ? '/now' : null;
      } else {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (_, __) => const SplashScreen(),
        routes: [
          GoRoute(
            path: 'login',
            name: AppRoute.login.name,
            builder: (_, __) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register',
            name: AppRoute.register.name,
            pageBuilder: (_, __) => const MaterialPage(
                fullscreenDialog: true, //custom animation
                child: NotYetImplementedScreen()),
            //builder: (_, __) => const ,
          ),
          GoRoute(
            path: 'now',
            name: AppRoute.now.name,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              transitionDuration: const Duration(milliseconds: 350),
              key: state.pageKey,
              child: const SingleExperienceScreen(id: "now"),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      CircleTransition(animation: animation, child: child),
            ),
          ),
          GoRoute(
              path: 'exp/:id',
              name: AppRoute.exp.name,
              builder: (_, state) {
                final expId = state.pathParameters['id']!;
                return SingleExperienceScreen(id: expId);
              }),
          GoRoute(
            path: 'stream',
            name: AppRoute.stream.name,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              transitionDuration: const Duration(milliseconds: 350),
              key: state.pageKey,
              child: const WhenListScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, -1.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeIn)),
                          ),
                          child: child),
            ),
          ),
          GoRoute(
            path: 'lakes',
            name: AppRoute.lakes.name,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              transitionDuration: const Duration(milliseconds: 350),
              key: state.pageKey,
              child: const WhatScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, -1.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeIn)),
                          ),
                          child: child),
            ),
          ),
          GoRoute(
            path: 'sources',
            name: AppRoute.sources.name,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              transitionDuration: const Duration(milliseconds: 350),
              key: state.pageKey,
              child: const WhereScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, -1.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeIn)),
                          ),
                          child: child),
            ),
          ),
          GoRoute(
            path: '404',
            name: AppRoute.four04.name,
            builder: (_, __) => const NotFoundScreen(),
          ),
          GoRoute(
            path: 'search',
            name: AppRoute.search.name,
            builder: (_, __) => const NotYetImplementedScreen(),
          ),
          GoRoute(
            path: 'done',
            name: AppRoute.done.name,
            builder: (_, __) => const InboxZeroScreen(),
          ),
          GoRoute(
            path: 'stream-file',
            name: AppRoute.spile.name,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              transitionDuration: const Duration(milliseconds: 350),
              key: state.pageKey,
              child: const WhichScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, -1.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeIn)),
                          ),
                          child: child),
            ),
          ),
          GoRoute(
            path: 'menu', // TODO rename
            name: AppRoute.overview.name,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              transitionDuration:
                  const Duration(milliseconds: 350), // TODO file const speeds
              key: state.pageKey,
              child: const OverviewScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, -1.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeIn)),
                          ),
                          child: child),
            ),
          ),
        ],
      ),
    ],
  );
});
