import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/add/presentation/add_exp.dart';
import 'package:read_with_meaning/public/features/experience/plan/sort%20(when)/presentation/today_list.realm.dart';
import 'package:read_with_meaning/public/routing/navigation.dart';

import 'package:read_with_meaning/public/routing/routes.dart';

class WhenListScreen extends StatelessWidget {
  const WhenListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveCenter(
      child: Stack(
        children: [
          MainSwipeNavigation(
            gradientImage: const AssetImage(navigationBackgroundImageOnBlack),
            centerMenuItem: MenuItem(
              icon: Icomoon.which,
              label: NavOptions.spile.label,
              callback: () {
                context.pushNamed(AppRoute.spile.name);
              },
            ),
            leftMenuItem: MenuItem(
              label: NavOptions.add.label,
              icon: Icomoon.addText,
              callback: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const SingleChildScrollView(
                        child: AddExpForm(),
                      );
                    });
              },
            ),
            rightMenuItem: MenuItem(
              label: NavOptions.command.label,
              icon: Icomoon.magicSearch,
              callback: () {
                context.pushNamed(AppRoute.search.name);
              },
            ),
            child: const TodayList(),
          ),
        ],
      ),
    ));
  }
}
