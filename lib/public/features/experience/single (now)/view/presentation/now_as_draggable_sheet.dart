import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/no_scroll.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

class NowAsDraggableSheet extends StatelessWidget {
  const NowAsDraggableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    DraggableScrollableController bottomSheetController =
        DraggableScrollableController();
    onBottomSheetEnd() {
      if (bottomSheetController.size > 0.14) {
        bottomSheetController
            .animateTo(0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn)
            .then((value) => context.pushNamed(AppRoute.now.name));
      } else {
        bottomSheetController.animateTo(0.1,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate);
      }
    }

    return DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.01,
        maxChildSize: 1 / 5,
        controller: bottomSheetController,
        snap: true,
        snapSizes: const [0.1],
        builder: (context, controller) {
          return NoScrollBar(
            child: Listener(
              onPointerUp: (_) {
                onBottomSheetEnd();
              },
              onPointerPanZoomEnd: (_) {
                onBottomSheetEnd();
              },
              child: SingleChildScrollView(
                  controller: controller,
                  child: Stack(
                    children: [
                      SizedBox(
                        /* decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: const Alignment(0, 0),
                          colors: <Color>[
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0),
                            Theme.of(context).colorScheme.surface,
                          ],
                        )), */
                        height: MediaQuery.of(context).size.height / 5,
                        child: Transform.flip(
                          flipY: true,
                          child: const Image(
                              image: AssetImage(
                                  navigationBackgroundImageOnTransparent),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Center(
                          child: InkWell(
                        onTap: () {
                          bottomSheetController
                              .animateTo(0.01,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.bounceIn)
                              .then((value) =>
                                  context.pushNamed(AppRoute.now.name));
                        },
                        child: const Icon(
                          Icomoon.now,
                          weight: 100,
                          size: 50,
                        ),
                      ))
                    ],
                  )),
            ),
          );
        });
  }
}
