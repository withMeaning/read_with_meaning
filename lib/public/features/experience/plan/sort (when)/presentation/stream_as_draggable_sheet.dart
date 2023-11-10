import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/features/experience/plan/sort%20(when)/presentation/today_list.realm.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

class StreamAsDraggableSheet extends StatelessWidget {
  const StreamAsDraggableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    DraggableScrollableController sheetController =
        DraggableScrollableController();
    sheetController.addListener(() {
      if (sheetController.size == 1) {
        context.pushNamed(AppRoute.stream.name);
        context.replaceNamed(AppRoute.stream.name);
      }
    });
    return DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 1,
        controller: sheetController,
        snap: true,
        snapSizes: const [0.1, 0.5],
        builder: (context, controller) {
          // TODO: make scroll at half height possible
/*           return NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                logger.i(sheetController.size);
                if (sheetController.size > 0.49 &&
                    sheetController.size < 0.51) {
                  logger.i(controller.offset);
/*                   if (controller.position.atEdge) {
                    return false;
                  } */

                  return true;
                }
                return false;
              },
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Theme.of(context).colorScheme.surface,
                  child: SimpleTodayList(
                    scrollController: controller,
                  ))); */
          return Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).colorScheme.surface,
              child: TodayList(
                scrollController: controller,
              ));
        });
  }
}
