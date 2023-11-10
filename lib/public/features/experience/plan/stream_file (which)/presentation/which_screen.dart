import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/plan/sort%20(when)/presentation/stream_as_draggable_sheet.dart';
import 'package:read_with_meaning/public/features/experience/plan/stream_file%20(which)/presentation/edit_stream_file.dart';
import 'package:read_with_meaning/public/routing/navigation.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

class WhichScreen extends StatelessWidget {
  const WhichScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveCenter(
            child: Stack(
      children: [
        MainSwipeNavigation(
            gradientImage:
                const AssetImage(navigationBackgroundImageOnTransparent),
            centerMenuItem: MenuItem(
              label: NavOptions.lakes.label,
              icon: Icomoon.what,
              callback: () {
                context.pushNamed(AppRoute.lakes.name);
              },
            ),
            leftMenuItem: MenuItem(
              label: NavOptions.add.label,
              icon: Icons.add,
              callback: () {},
            ),
            rightMenuItem: MenuItem(
              label: NavOptions.command.label,
              icon: Icomoon.magicSearch,
              callback: () {
                context.pushNamed(AppRoute.search.name);
              },
            ),
            child: const EditFile()),
        const StreamAsDraggableSheet(),
      ],
    )));
  }
}
