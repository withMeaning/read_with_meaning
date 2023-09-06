import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/features/experience/plan/sources/presentation/add_source.dart';
import 'package:read_with_meaning/public/features/experience/plan/sources/presentation/list_of_exps.dart';
import 'package:read_with_meaning/public/routing/navigation.dart';

import 'package:read_with_meaning/public/routing/routes.dart';

class SourcesListScreen extends StatelessWidget {
  const SourcesListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ResponsiveCenter(child: Consumer(
      builder: (context, ref, child) {
        return MainSwipeNavigation(
            centerMenuItem: MenuItem(
              label: NavOptions.now.label,
              icon: Icons.circle_outlined,
              callback: () {
                context.pushNamed(AppRoute.now.name);
              },
            ),
            leftMenuItem: MenuItem(
              label: NavOptions.add.label,
              icon: Icons.add,
              callback: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const SingleChildScrollView(
                        child: AddSourceForm(),
                      );
                    });
              },
            ),
            rightMenuItem: MenuItem(
              label: NavOptions.command.label,
              icon: Icomoon.magic_search,
              callback: () {
                context.pushNamed(AppRoute.search.name);
              },
            ),
            child: const ListOfSources());
      },
    )));
  }
}
