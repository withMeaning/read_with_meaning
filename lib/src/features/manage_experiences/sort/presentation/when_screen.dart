import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/src/common_widgets/navigation/top_navigation.dart';

import '../../../../routing/routes.dart';

class WhenListScreen extends StatelessWidget {
  const WhenListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TopNavigation(
      centerIcon: IconButton(
          onPressed: () {
            context.pushNamed(AppRoute.now.name);
          },
          icon: const Icon(Icons.circle_outlined)),
      child: const Center(child: Text("When List")),
    );
  }
}