import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/features/experience/plan/sources%20(where)/integrations/presentation/add_source.dart';
import 'package:read_with_meaning/public/features/experience/plan/sources%20(where)/integrations/presentation/list_of_exps.dart';
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
              label: NavOptions.overview.label,
              icon: Icons.menu,
              callback: () {
                context.pushNamed(AppRoute.overview.name);
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
                        child: AddSourceForm(),
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
            child: const ListOfSources());
      },
    )));
  }
}
