import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/plan/overview/application/info_provider.dart';
import 'package:read_with_meaning/public/routing/navigation.dart';

import 'package:read_with_meaning/public/routing/routes.dart';

import 'overview_scroll_view.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ResponsiveCenter(child: Consumer(
      builder: (context, ref, child) {
        return MainSwipeNavigation(
            centerMenuItem: MenuItem(
              label: NavOptions.now.label,
              icon: Icomoon.now,
              callback: () {
                context.pushNamed(AppRoute.now.name);
              },
            ),
            leftMenuItem: MenuItem(
              label: NavOptions.question.label,
              icon: Icons.question_mark_sharp,
              callback: () {
                ref.watch(infoProvider.notifier).state =
                    !ref.read(infoProvider);
              },
            ),
            rightMenuItem: MenuItem(
              label: NavOptions.command.label,
              icon: Icomoon.magicSearch,
              callback: () {
                context.pushNamed(AppRoute.search.name);
              },
            ),
            gradientImage: const AssetImage(navigationBackgroundImageOnBlack),
            child: const OverviewScrollView());
      },
    )));
  }
}
